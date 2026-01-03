"""Tests for the Bremen Livability Index API using pytest and TestClient."""
import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session

from app.main import app
from core.database import get_session, engine


@pytest.fixture
def client():
    """Create a test client for the API."""
    return TestClient(app)


@pytest.fixture
def db_session():
    """Create a database session for testing."""
    with Session(engine) as session:
        yield session


class TestHealthEndpoint:
    """Tests for the /health endpoint."""
    
    def test_health_check_returns_200(self, client):
        """Test that health check returns 200 when database is connected."""
        response = client.get("/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert data["database"] == "connected"


class TestRootEndpoint:
    """Tests for the root / endpoint."""
    
    def test_root_returns_api_info(self, client):
        """Test that root endpoint returns API information."""
        response = client.get("/")
        assert response.status_code == 200
        data = response.json()
        assert data["message"] == "Bremen Livability Index API"
        assert data["version"] == "1.0.0"
        assert "endpoints" in data


class TestAnalyzeEndpoint:
    """Tests for the /analyze endpoint."""
    
    def test_analyze_valid_coordinates(self, client):
        """Test analyze with valid Bremen coordinates."""
        response = client.post(
            "/analyze",
            json={"latitude": 53.0755914, "longitude": 8.8071412}
        )
        assert response.status_code == 200
        data = response.json()
        
        # Check response structure
        assert "score" in data
        assert "location" in data
        assert "factors" in data
        assert "nearby_features" in data
        assert "summary" in data
        
        # Check score is valid
        assert 0 <= data["score"] <= 100
        
        # Check location matches request
        assert data["location"]["latitude"] == 53.0755914
        assert data["location"]["longitude"] == 8.8071412
    
    def test_analyze_returns_nearby_features(self, client):
        """Test that analyze returns nearby feature categories."""
        response = client.post(
            "/analyze",
            json={"latitude": 53.0755914, "longitude": 8.8071412}
        )
        assert response.status_code == 200
        data = response.json()
        
        # Check core feature categories exist (always present)
        core_categories = ["trees", "parks", "amenities", "accidents", 
                          "public_transport", "healthcare", "bike_infrastructure",
                          "education", "sports_leisure", "cultural_venues"]
        for category in core_categories:
            assert category in data["nearby_features"]
    
    def test_analyze_invalid_latitude(self, client):
        """Test that invalid latitude returns 422 validation error."""
        response = client.post(
            "/analyze",
            json={"latitude": 200, "longitude": 8.8}  # Invalid latitude
        )
        assert response.status_code == 422
    
    def test_analyze_invalid_longitude(self, client):
        """Test that invalid longitude returns 422 validation error."""
        response = client.post(
            "/analyze",
            json={"latitude": 53.0, "longitude": 400}  # Invalid longitude
        )
        assert response.status_code == 422
    
    def test_analyze_missing_coordinates(self, client):
        """Test that missing coordinates returns 422 validation error."""
        response = client.post("/analyze", json={})
        assert response.status_code == 422


class TestGeocodeEndpoint:
    """Tests for the /geocode endpoint."""
    
    def test_geocode_valid_query(self, client):
        """Test geocoding a valid address."""
        response = client.post(
            "/geocode",
            json={"query": "Marktplatz Bremen"}
        )
        assert response.status_code == 200
        data = response.json()
        
        assert "results" in data
        assert "count" in data
        assert data["count"] >= 0
    
    def test_geocode_with_limit(self, client):
        """Test geocoding with a limit parameter."""
        response = client.post(
            "/geocode",
            json={"query": "Bremen", "limit": 2}
        )
        assert response.status_code == 200
        data = response.json()
        
        assert len(data["results"]) <= 2
    
    def test_geocode_result_structure(self, client):
        """Test that geocode results have correct structure."""
        response = client.post(
            "/geocode",
            json={"query": "Hauptbahnhof Bremen", "limit": 1}
        )
        assert response.status_code == 200
        data = response.json()
        
        if data["count"] > 0:
            result = data["results"][0]
            assert "latitude" in result
            assert "longitude" in result
            assert "display_name" in result
            assert "address" in result
            assert "type" in result
            assert "importance" in result


class TestScoreConsistency:
    """Tests for score calculation consistency."""
    
    def test_city_center_has_higher_amenities(self, client):
        """Test that city center has more amenities than outskirts."""
        # City center (Am Markt)
        center_response = client.post(
            "/analyze",
            json={"latitude": 53.0755914, "longitude": 8.8071412}
        )
        center_data = center_response.json()
        
        # Outskirts (near airport)
        outskirts_response = client.post(
            "/analyze",
            json={"latitude": 53.0474, "longitude": 8.7867}
        )
        outskirts_data = outskirts_response.json()
        
        # City center should have more amenities
        center_amenities = len(center_data["nearby_features"]["amenities"])
        outskirts_amenities = len(outskirts_data["nearby_features"]["amenities"])
        
        assert center_amenities >= outskirts_amenities
