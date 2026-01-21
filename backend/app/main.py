"""FastAPI backend for Bremen Livability Index using SQLModel ORM."""
from typing import List, Optional
from datetime import datetime
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlmodel import Session, select
from sqlalchemy import func, cast
from geoalchemy2 import Geography
from geoalchemy2.functions import ST_AsGeoJSON, ST_Distance, ST_DWithin, ST_SetSRID, ST_MakePoint
from pydantic import BaseModel, Field
import json

from app.models import (
    LocationRequest, LivabilityScoreResponse, GeocodeRequest, 
    GeocodeResponse, GeocodeResult, FeatureDetail
)
from app.db_models import (
    Tree, Park, Amenity, Accident, PublicTransport, 
    Healthcare, IndustrialArea, MajorRoad,
    BikeInfrastructure, Education, SportsLeisure,
    PedestrianInfrastructure, CulturalVenue, NoiseSource,
    Railway, GasStation, WasteFacility, PowerInfrastructure,
    ParkingLot, Airport, ConstructionSite
)
from app.user_models import User, FavoriteAddress
from core.scoring import LivabilityScorer
from core.database import get_session, check_database_connection
from core.logging import logger
from services.geocode import GeocodeService
from config import settings


# Pydantic models for user favorites API
class UserCreateRequest(BaseModel):
    """Request model for creating/registering a user."""
    id: str = Field(..., description="Firebase UID")
    email: Optional[str] = None
    display_name: Optional[str] = None
    provider: str = Field(..., description="Auth provider: google, github, email, phone, guest")


class FavoriteCreateRequest(BaseModel):
    """Request model for adding a favorite address."""
    label: str = Field(..., min_length=1, max_length=255)
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    address: Optional[str] = None


class FavoriteResponse(BaseModel):
    """Response model for a favorite address."""
    id: int
    label: str
    latitude: float
    longitude: float
    address: Optional[str]
    created_at: datetime


class FavoritesListResponse(BaseModel):
    """Response model for list of favorites."""
    favorites: List[FavoriteResponse]
    count: int


app = FastAPI(
    title="Bremen Livability Index API",
    description="API for calculating quality of life scores based on spatial analysis",
    version="1.0.0"
)

# Configure CORS with settings
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

logger.info(f"Starting Bremen Livability Index API v1.0.0")
logger.info(f"CORS origins: {settings.cors_origins_list}")


@app.get("/")
async def root():
    """Root endpoint returning API information."""
    return {
        "message": "Bremen Livability Index API",
        "version": "1.0.0",
        "endpoints": {
            "analyze": "/analyze", 
            "health": "/health", 
            "geocode": "/geocode",
            "users": "/users/{user_id}",
            "favorites": "/users/{user_id}/favorites"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint to verify API and database status."""
    if check_database_connection():
        return {"status": "healthy", "database": "connected"}
    else:
        logger.error("Database connection check failed")
        raise HTTPException(status_code=503, detail="Database connection failed")


# ============== User Favorites API ==============

@app.post("/users", status_code=201)
async def create_or_update_user(
    request: UserCreateRequest,
    session: Session = Depends(get_session)
):
    """Create or update a user record."""
    try:
        # Check if user already exists
        existing_user = session.get(User, request.id)
        
        if existing_user:
            # Update existing user
            existing_user.email = request.email or existing_user.email
            existing_user.display_name = request.display_name or existing_user.display_name
            existing_user.provider = request.provider
            session.add(existing_user)
            session.commit()
            session.refresh(existing_user)
            logger.info(f"Updated user: {request.id}")
            return {"message": "User updated", "user_id": existing_user.id}
        else:
            # Create new user
            user = User(
                id=request.id,
                email=request.email,
                display_name=request.display_name,
                provider=request.provider
            )
            session.add(user)
            session.commit()
            session.refresh(user)
            logger.info(f"Created new user: {request.id}")
            return {"message": "User created", "user_id": user.id}
            
    except Exception as e:
        logger.exception(f"Failed to create/update user: {request.id}")
        raise HTTPException(status_code=500, detail=f"User operation failed: {str(e)}")


@app.get("/users/{user_id}/favorites", response_model=FavoritesListResponse)
async def get_user_favorites(
    user_id: str,
    session: Session = Depends(get_session)
):
    """Get all favorite addresses for a user."""
    try:
        # Check if user exists
        user = session.get(User, user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Get favorites
        statement = select(FavoriteAddress).where(
            FavoriteAddress.user_id == user_id
        ).order_by(FavoriteAddress.created_at.desc())
        
        favorites = session.exec(statement).all()
        
        return FavoritesListResponse(
            favorites=[
                FavoriteResponse(
                    id=f.id,
                    label=f.label,
                    latitude=f.latitude,
                    longitude=f.longitude,
                    address=f.address,
                    created_at=f.created_at
                )
                for f in favorites
            ],
            count=len(favorites)
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.exception(f"Failed to get favorites for user: {user_id}")
        raise HTTPException(status_code=500, detail=f"Failed to get favorites: {str(e)}")


@app.post("/users/{user_id}/favorites", response_model=FavoriteResponse, status_code=201)
async def add_favorite(
    user_id: str,
    request: FavoriteCreateRequest,
    session: Session = Depends(get_session)
):
    """Add a favorite address for a user."""
    try:
        # Check if user exists
        user = session.get(User, user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Create favorite
        favorite = FavoriteAddress(
            user_id=user_id,
            label=request.label,
            latitude=request.latitude,
            longitude=request.longitude,
            address=request.address
        )
        session.add(favorite)
        session.commit()
        session.refresh(favorite)
        
        logger.info(f"Added favorite for user {user_id}: {request.label}")
        
        return FavoriteResponse(
            id=favorite.id,
            label=favorite.label,
            latitude=favorite.latitude,
            longitude=favorite.longitude,
            address=favorite.address,
            created_at=favorite.created_at
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.exception(f"Failed to add favorite for user: {user_id}")
        raise HTTPException(status_code=500, detail=f"Failed to add favorite: {str(e)}")


@app.delete("/users/{user_id}/favorites/{favorite_id}", status_code=204)
async def delete_favorite(
    user_id: str,
    favorite_id: int,
    session: Session = Depends(get_session)
):
    """Delete a favorite address."""
    try:
        # Check if user exists
        user = session.get(User, user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Get and verify favorite belongs to user
        favorite = session.get(FavoriteAddress, favorite_id)
        if not favorite:
            raise HTTPException(status_code=404, detail="Favorite not found")
        if favorite.user_id != user_id:
            raise HTTPException(status_code=403, detail="Favorite does not belong to this user")
        
        session.delete(favorite)
        session.commit()
        
        logger.info(f"Deleted favorite {favorite_id} for user {user_id}")
        
    except HTTPException:
        raise
    except Exception as e:
        logger.exception(f"Failed to delete favorite {favorite_id} for user: {user_id}")
        raise HTTPException(status_code=500, detail=f"Failed to delete favorite: {str(e)}")


# ============== Geocoding API ==============

@app.post("/geocode", response_model=GeocodeResponse)
async def geocode_address(request: GeocodeRequest):
    """Geocode an address and return possible locations."""
    try:
        logger.debug(f"Geocoding address: {request.query}")
        results = await GeocodeService.geocode_address(request.query, request.limit)
        geocode_results = [GeocodeResult(**result) for result in results]
        logger.info(f"Geocoded '{request.query}' -> {len(geocode_results)} results")
        return GeocodeResponse(results=geocode_results, count=len(geocode_results))
    except Exception as e:
        logger.exception(f"Geocoding failed for '{request.query}'")
        raise HTTPException(status_code=500, detail=f"Geocoding failed: {str(e)}")


def create_point_geography(lon: float, lat: float):
    """Create a PostGIS geography point from coordinates."""
    return cast(ST_SetSRID(ST_MakePoint(lon, lat), 4326), Geography)


def fetch_nearby_features(
    session: Session, 
    model, 
    point, 
    radius: float, 
    feature_type: str, 
    type_field: str = None, 
    name_field: str = "name"
) -> List[FeatureDetail]:
    """Generic function to fetch nearby features using ORM.
    
    Args:
        session: SQLModel session
        model: ORM model class (e.g., Tree, Park)
        point: PostGIS geography point
        radius: Search radius in meters
        feature_type: Type string for the FeatureDetail
        type_field: Optional field name for subtype (e.g., "amenity_type")
        name_field: Field name for the name column
    
    Returns:
        List of FeatureDetail objects
    """
    # Build the select columns
    columns = [
        model.id,
        getattr(model, name_field).label("name"),
        ST_AsGeoJSON(model.geometry).label("geojson"),
        ST_Distance(model.geometry, point).label("dist")
    ]
    
    # Add subtype field if specified
    if type_field and hasattr(model, type_field):
        columns.append(getattr(model, type_field).label("type_detail"))
    
    # Build and execute query
    statement = (
        select(*columns)
        .where(ST_DWithin(model.geometry, point, radius))
        .order_by("dist")
    )
    
    results = session.exec(statement).all()
    
    # Convert to FeatureDetail objects
    features: List[FeatureDetail] = []
    for row in results:
        subtype = getattr(row, "type_detail", None) if type_field else None
        features.append(FeatureDetail(
            id=row.id,
            name=row.name,
            type=feature_type,
            subtype=subtype,
            distance=round(row.dist, 1),
            geometry=json.loads(row.geojson)
        ))
    
    return features


@app.post("/analyze", response_model=LivabilityScoreResponse)
async def analyze_location(
    request: LocationRequest,
    session: Session = Depends(get_session)
):
    """Analyze a location and return livability score."""
    lat, lon = request.latitude, request.longitude
    logger.debug(f"Analyzing location: ({lat}, {lon})")
    
    try:
        nearby_features = {}
        
        # Create the point once for all queries
        point = create_point_geography(lon, lat)
        
        # Trees within 100m
        trees = fetch_nearby_features(session, Tree, point, 100, "tree")
        nearby_features["trees"] = trees
        tree_count = len(trees)
        
        # Parks within 100m
        parks = fetch_nearby_features(session, Park, point, 100, "park")
        nearby_features["parks"] = parks
        park_count = len(parks)
        
        # Amenities within 500m
        amenities = fetch_nearby_features(
            session, Amenity, point, 500, "amenity",
            type_field="amenity_type"
        )
        nearby_features["amenities"] = amenities
        amenity_count = len(amenities)
        
        # Accidents within 150m (use severity as name)
        accidents = fetch_nearby_features(
            session, Accident, point, 150, "accident",
            name_field="severity"
        )
        nearby_features["accidents"] = accidents
        accident_count = len(accidents)
        
        # Public transport stops within 300m
        transport = fetch_nearby_features(
            session, PublicTransport, point, 300, "public_transport",
            type_field="transport_type"
        )
        nearby_features["public_transport"] = transport
        transport_count = len(transport)
        
        # Healthcare within 500m
        healthcare = fetch_nearby_features(
            session, Healthcare, point, 500, "healthcare",
            type_field="healthcare_type"
        )
        nearby_features["healthcare"] = healthcare
        healthcare_count = len(healthcare)
        
        # Industrial areas within 200m
        industrial = fetch_nearby_features(
            session, IndustrialArea, point, 200, "industrial"
        )
        near_industrial = len(industrial) > 0
        if near_industrial:
            nearby_features["industrial"] = industrial
        
        # Major roads within 100m
        roads = fetch_nearby_features(
            session, MajorRoad, point, 100, "major_road",
            type_field="road_type"
        )
        near_major_road = len(roads) > 0
        if near_major_road:
            nearby_features["major_roads"] = roads
        
        # Bike infrastructure within 200m
        bike_infra = fetch_nearby_features(
            session, BikeInfrastructure, point, 200, "bike_infrastructure",
            type_field="infra_type"
        )
        nearby_features["bike_infrastructure"] = bike_infra
        bike_infrastructure_count = len(bike_infra)
        
        # Education facilities within 800m
        education = fetch_nearby_features(
            session, Education, point, 800, "education",
            type_field="education_type"
        )
        nearby_features["education"] = education
        education_count = len(education)
        
        # Sports and leisure within 500m
        sports_leisure = fetch_nearby_features(
            session, SportsLeisure, point, 500, "sports_leisure",
            type_field="leisure_type"
        )
        nearby_features["sports_leisure"] = sports_leisure
        sports_leisure_count = len(sports_leisure)
        
        # Pedestrian infrastructure within 200m
        pedestrian = fetch_nearby_features(
            session, PedestrianInfrastructure, point, 200, "pedestrian_infrastructure",
            type_field="infra_type"
        )
        nearby_features["pedestrian_infrastructure"] = pedestrian
        pedestrian_infra_count = len(pedestrian)
        
        # Cultural venues within 1000m
        cultural = fetch_nearby_features(
            session, CulturalVenue, point, 1000, "cultural_venue",
            type_field="venue_type"
        )
        nearby_features["cultural_venues"] = cultural
        cultural_count = len(cultural)
        
        # Noise sources within 100m
        noise = fetch_nearby_features(
            session, NoiseSource, point, 100, "noise_source",
            type_field="noise_type"
        )
        noise_count = len(noise)
        if noise_count > 0:
            nearby_features["noise_sources"] = noise
        
        # Railways within 75m
        railways = fetch_nearby_features(
            session, Railway, point, 75, "railway",
            type_field="railway_type"
        )
        near_railway = len(railways) > 0
        if near_railway:
            nearby_features["railways"] = railways
        
        # Gas stations within 50m
        gas_stations = fetch_nearby_features(
            session, GasStation, point, 50, "gas_station"
        )
        near_gas_station = len(gas_stations) > 0
        if near_gas_station:
            nearby_features["gas_stations"] = gas_stations
        
        # Waste facilities within 200m
        waste = fetch_nearby_features(
            session, WasteFacility, point, 200, "waste_facility",
            type_field="waste_type"
        )
        near_waste = len(waste) > 0
        if near_waste:
            nearby_features["waste_facilities"] = waste
        
        # Power infrastructure within 50m
        power = fetch_nearby_features(
            session, PowerInfrastructure, point, 50, "power_infrastructure",
            type_field="power_type"
        )
        near_power = len(power) > 0
        if near_power:
            nearby_features["power_infrastructure"] = power
        
        # Large parking lots within 30m
        parking = fetch_nearby_features(
            session, ParkingLot, point, 30, "parking_lot",
            type_field="parking_type"
        )
        near_parking = len(parking) > 0
        if near_parking:
            nearby_features["parking_lots"] = parking
        
        # Airports/helipads within 500m
        airports = fetch_nearby_features(
            session, Airport, point, 500, "airport",
            type_field="airport_type"
        )
        near_airport = len(airports) > 0
        if near_airport:
            nearby_features["airports"] = airports
        
        # Construction sites within 100m
        construction = fetch_nearby_features(
            session, ConstructionSite, point, 100, "construction_site"
        )
        near_construction = len(construction) > 0
        if near_construction:
            nearby_features["construction_sites"] = construction
        
        # Calculate score
        result = LivabilityScorer.calculate_score(
            tree_count=tree_count,
            park_count=park_count,
            amenity_count=amenity_count,
            accident_count=accident_count,
            public_transport_count=transport_count,
            healthcare_count=healthcare_count,
            near_industrial=near_industrial,
            near_major_road=near_major_road,
            bike_infrastructure_count=bike_infrastructure_count,
            education_count=education_count,
            sports_leisure_count=sports_leisure_count,
            pedestrian_infra_count=pedestrian_infra_count,
            cultural_count=cultural_count,
            noise_count=noise_count,
            near_railway=near_railway,
            near_gas_station=near_gas_station,
            near_waste=near_waste,
            near_power=near_power,
            near_parking=near_parking,
            near_airport=near_airport,
            near_construction=near_construction
        )
        
        logger.info(f"Analyzed ({lat}, {lon}) -> Score: {result['score']}")
        
        return LivabilityScoreResponse(
            score=result["score"],
            base_score=result["base_score"],
            location={"latitude": lat, "longitude": lon},
            factors=result["factors"],
            nearby_features=nearby_features,
            summary=result["summary"]
        )
        
    except Exception as e:
        logger.exception(f"Analysis failed for ({lat}, {lon})")
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=settings.api_host, port=settings.api_port)

