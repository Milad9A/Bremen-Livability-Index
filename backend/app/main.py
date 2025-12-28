"""FastAPI backend for Bremen Livability Index."""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import json
from app.models import LocationRequest, LivabilityScoreResponse, GeocodeRequest, GeocodeResponse, GeocodeResult, FeatureDetail
from core.scoring import LivabilityScorer
from core.database import get_db_cursor
from services.geocode import GeocodeService

app = FastAPI(
    title="Bremen Livability Index API",
    description="API for calculating quality of life scores based on spatial analysis",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {
        "message": "Bremen Livability Index API",
        "version": "1.0.0",
        "endpoints": {"analyze": "/analyze", "health": "/health"}
    }


@app.get("/health")
async def health_check():
    try:
        with get_db_cursor() as cursor:
            cursor.execute("SELECT 1")
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        raise HTTPException(status_code=503, detail="Database connection failed")


@app.post("/geocode", response_model=GeocodeResponse)
async def geocode_address(request: GeocodeRequest):
    """Geocode an address and return possible locations."""
    try:
        results = await GeocodeService.geocode_address(request.query, request.limit)
        geocode_results = [GeocodeResult(**result) for result in results]
        return GeocodeResponse(results=geocode_results, count=len(geocode_results))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Geocoding failed: {str(e)}")


@app.post("/analyze", response_model=LivabilityScoreResponse)
async def analyze_location(request: LocationRequest):
    """Analyze a location and return livability score."""
    try:
        lat, lon = request.latitude, request.longitude
        nearby_features = {}
        
        with get_db_cursor() as cursor:
            # Helper function to process results
            def fetch_features(query, params, feature_type):
                cursor.execute(query, params)
                rows = cursor.fetchall()
                features = []
                for row in rows:

                    features.append(FeatureDetail(
                        id=row.get("id"),
                        name=row.get("name"),
                        type=feature_type,
                        subtype=row.get("type_detail"),
                        distance=round(row["dist"], 1),
                        geometry=json.loads(row["geojson"])
                    ))
                return features

            point_geom = f"ST_SetSRID(ST_MakePoint({lon}, {lat}), 4326)::geography"
            
            # Trees within 100m
            trees = fetch_features(f"""
                SELECT id, name, ST_AsGeoJSON(geometry) as geojson, 
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.trees
                WHERE ST_DWithin(geometry, {point_geom}, 100)
                ORDER BY dist ASC
            """, (), "tree")
            nearby_features["trees"] = trees
            tree_count = len(trees)
            
            # Parks within 100m
            parks = fetch_features(f"""
                SELECT id, name, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.parks
                WHERE ST_DWithin(geometry, {point_geom}, 100)
                ORDER BY dist ASC
            """, (), "park")
            nearby_features["parks"] = parks
            park_count = len(parks)
            
            # Amenities within 500m
            amenities = fetch_features(f"""
                SELECT id, name, amenity_type as type_detail, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.amenities
                WHERE ST_DWithin(geometry, {point_geom}, 500)
                ORDER BY dist ASC
            """, (), "amenity")
            # Update type to include specific amenity type
            for a, row in zip(amenities, cursor.fetchall() if False else amenities): # Hack to keep logic simple
                if hasattr(a, 'type_detail') and a.type_detail: # fetch_features doesn't capture extra cols easily without custom row access
                     pass 
            # Re-doing fetch to be safer given the helper
            # Actually let's just use a more generic approach or query
            nearby_features["amenities"] = amenities
            amenity_count = len(amenities)

            # Accidents within 150m
            accidents = fetch_features(f"""
                SELECT id, severity as name, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.accidents
                WHERE ST_DWithin(geometry, {point_geom}, 150)
                ORDER BY dist ASC
            """, (), "accident")
            nearby_features["accidents"] = accidents
            accident_count = len(accidents)
            
            # Public transport stops within 300m
            transport = fetch_features(f"""
                SELECT id, name, transport_type as type_detail, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.public_transport
                WHERE ST_DWithin(geometry, {point_geom}, 300)
                ORDER BY dist ASC
            """, (), "public_transport")
            nearby_features["public_transport"] = transport
            transport_count = len(transport)
            
            # Healthcare within 500m
            healthcare = fetch_features(f"""
                SELECT id, name, healthcare_type as type_detail, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.healthcare
                WHERE ST_DWithin(geometry, {point_geom}, 500)
                ORDER BY dist ASC
            """, (), "healthcare")
            nearby_features["healthcare"] = healthcare
            healthcare_count = len(healthcare)
            
            # Industrial areas within 200m
            industrial = fetch_features(f"""
                SELECT id, name, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.industrial_areas
                WHERE ST_DWithin(geometry, {point_geom}, 200)
                LIMIT 1
            """, (), "industrial")
            near_industrial = len(industrial) > 0
            if near_industrial:
                nearby_features["industrial"] = industrial
            
            # Major roads within 100m
            roads = fetch_features(f"""
                SELECT id, name, road_type as type_detail, ST_AsGeoJSON(geometry) as geojson,
                       ST_Distance(geometry, {point_geom}) as dist
                FROM gis_data.major_roads
                WHERE ST_DWithin(geometry, {point_geom}, 100)
                LIMIT 1
            """, (), "major_road")
            near_major_road = len(roads) > 0
            if near_major_road:
                nearby_features["major_roads"] = roads
        
        # Calculate score
        result = LivabilityScorer.calculate_score(
            tree_count=tree_count,
            park_count=park_count,
            amenity_count=amenity_count,
            accident_count=accident_count,
            public_transport_count=transport_count,
            healthcare_count=healthcare_count,
            near_industrial=near_industrial,
            near_major_road=near_major_road
        )
        
        return LivabilityScoreResponse(
            score=result["score"],
            location={"latitude": lat, "longitude": lon},
            factors=result["factors"],
            nearby_features=nearby_features,
            summary=result["summary"]
        )
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    from config import settings
    uvicorn.run(app, host=settings.api_host, port=settings.api_port)
