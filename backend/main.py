"""FastAPI backend for Bremen Livability Index."""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from models import LocationRequest, LivabilityScoreResponse, GeocodeRequest, GeocodeResponse, GeocodeResult
from scoring import LivabilityScorer
from database import get_db_cursor
from geocode import GeocodeService

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
        
        with get_db_cursor() as cursor:
            # Trees within 100m
            cursor.execute("""
                SELECT COUNT(*) as count FROM gis_data.trees
                WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 100)
            """, (lon, lat))
            tree_count = cursor.fetchone()["count"]
            
            # Parks within 100m
            cursor.execute("""
                SELECT COUNT(*) as count FROM gis_data.parks
                WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 100)
            """, (lon, lat))
            park_count = cursor.fetchone()["count"]
            
            # Amenities within 500m
            cursor.execute("""
                SELECT COUNT(*) as count FROM gis_data.amenities
                WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 500)
            """, (lon, lat))
            amenity_count = cursor.fetchone()["count"]
            
            # Accidents within 150m
            cursor.execute("""
                SELECT COUNT(*) as count FROM gis_data.accidents
                WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 150)
            """, (lon, lat))
            accident_count = cursor.fetchone()["count"]
            
            # Public transport stops within 300m
            cursor.execute("""
                SELECT COUNT(*) as count FROM gis_data.public_transport
                WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 300)
            """, (lon, lat))
            transport_count = cursor.fetchone()["count"]
            
            # Healthcare within 500m
            cursor.execute("""
                SELECT COUNT(*) as count FROM gis_data.healthcare
                WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 500)
            """, (lon, lat))
            healthcare_count = cursor.fetchone()["count"]
            
            # Industrial areas within 200m
            cursor.execute("""
                SELECT EXISTS(
                    SELECT 1 FROM gis_data.industrial_areas
                    WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 200)
                ) as near
            """, (lon, lat))
            near_industrial = cursor.fetchone()["near"]
            
            # Major roads within 100m
            cursor.execute("""
                SELECT EXISTS(
                    SELECT 1 FROM gis_data.major_roads
                    WHERE ST_DWithin(geometry, ST_SetSRID(ST_MakePoint(%s, %s), 4326)::geography, 100)
                ) as near
            """, (lon, lat))
            near_major_road = cursor.fetchone()["near"]
        
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
            summary=result["summary"]
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    from config import settings
    uvicorn.run(app, host=settings.api_host, port=settings.api_port)
