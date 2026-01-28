import pytest
from unittest.mock import MagicMock, patch
from fastapi.testclient import TestClient
from app.models import FeatureDetail
from app.main import app
from app.user_models import User, FavoriteAddress
from datetime import datetime

# Mock dependencies
@pytest.fixture
def mock_session():
    return MagicMock()

@pytest.fixture
def client(mock_session):
    # Use dependency_overrides instead of patching
    # This is required because Depends(get_session) is evaluated at definition time
    from core.database import get_session
    
    app.dependency_overrides[get_session] = lambda: mock_session
    
    # Patch database connection check for health endpoint
    with patch("app.main.check_database_connection", return_value=True):
        with TestClient(app) as test_client:
            yield test_client
    
    # Clean up overrides
    app.dependency_overrides.clear()

def test_root_endpoint(client):
    """Test the root endpoint returns API info."""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "version" in data
    assert data["message"] == "Bremen Livability Index API"

def test_health_check_success(client):
    """Test health check returns healthy status."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy", "database": "connected"}

@patch("app.main.check_database_connection", return_value=False)
def test_health_check_failure(mock_check, client):
    """Test health check returns 503 when DB is down."""
    response = client.get("/health")
    assert response.status_code == 503
    assert response.json()["detail"] == "Database connection failed"

@patch("services.geocode.GeocodeService.geocode_address")
def test_geocode_success(mock_geocode, client):
    """Test geocode endpoint with successful result."""
    mock_geocode.return_value = [
        {
            "latitude": 53.0793, 
            "longitude": 8.8017, 
            "display_name": "Bremen, Germany",
            "address": {"city": "Bremen", "country": "Germany"},
            "type": "administrative",
            "importance": 0.9
        }
    ]
    
    response = client.post("/geocode", json={"query": "Bremen", "limit": 1})
    
    assert response.status_code == 200
    data = response.json()
    assert data["count"] == 1
    assert data["results"][0]["latitude"] == 53.0793

@patch("services.geocode.GeocodeService.geocode_address")
def test_geocode_error(mock_geocode, client):
    """Test geocode endpoint handles errors gracefully."""
    mock_geocode.side_effect = Exception("Geocoding service unavailable")
    
    response = client.post("/geocode", json={"query": "ErrorCity"})
    
    assert response.status_code == 500
    assert "Geocoding failed" in response.json()["detail"]

@patch("app.main.LivabilityScorer.calculate_score")
@patch("app.main.fetch_nearby_features")
def test_analyze_endpoint_success(mock_fetch, mock_score, client):
    """Test analyze endpoint returns calculation results."""
    # Mock feature fetch to return empty list or minimal data
    mock_fetch.return_value = []
    
    # Mock score calculation
    mock_score.return_value = {
        "score": 75.5,
        "base_score": 50.0,
        "factors": [],
        "summary": "Good"
    }
    
    payload = {"latitude": 53.0793, "longitude": 8.8017}
    response = client.post("/analyze", json=payload)
    
    assert response.status_code == 200
    data = response.json()
    assert data["score"] == 75.5
    assert data["summary"] == "Good"
    assert "nearby_features" in data

@patch("app.main.create_point_geography")
def test_analyze_endpoint_error(mock_point, client):
    """Test analyze endpoint handles calculation errors."""
    mock_point.side_effect = Exception("Database error")
    
    payload = {"latitude": 53.0793, "longitude": 8.8017}
    response = client.post("/analyze", json=payload)
    
    assert response.status_code == 500
    assert "Analysis failed" in response.json()["detail"]

# ==================== New Tests ====================

def test_get_default_preferences(client):
    """Test default preferences endpoint."""
    response = client.get("/preferences/defaults")
    assert response.status_code == 200
    data = response.json()
    assert "preferences" in data
    assert "multipliers" in data
    assert "factor_keys" in data
    assert data["preferences"]["greenery"] == "medium"

def test_create_user_success(client, mock_session):
    """Test creating a new user or updating existing."""
    # Setup mock to return None (user doesn't exist)
    mock_session.get.return_value = None
    
    payload = {
        "id": "test-uid",
        "email": "test@example.com",
        "display_name": "Test User",
        "provider": "email"
    }
    
    response = client.post("/users", json=payload)
    
    assert response.status_code == 201
    assert response.json()["message"] == "User created"
    
    # Verify DB interactions
    mock_session.add.assert_called()
    mock_session.commit.assert_called()
    mock_session.refresh.assert_called()

def test_update_user_success(client, mock_session):
    """Test updating an existing user."""
    # Setup mock to return existing user
    existing_user = User(id="test-uid", email="old@example.com", provider="email")
    mock_session.get.return_value = existing_user
    
    payload = {
        "id": "test-uid",
        "email": "new@example.com",
        "display_name": "Updated User",
        "provider": "email"
    }
    
    response = client.post("/users", json=payload)
    
    assert response.status_code == 201
    assert response.json()["message"] == "User updated"
    assert existing_user.email == "new@example.com"
    assert existing_user.display_name == "Updated User"

def test_auth_failure_handles_exception(client, mock_session):
    """Test user creation error handling."""
    mock_session.get.side_effect = Exception("DB Connection Lost")
    
    payload = {"id": "uid", "provider": "google"}
    response = client.post("/users", json=payload)
    
    assert response.status_code == 500
    assert "User operation failed" in response.json()["detail"]

def test_add_favorite_success(client, mock_session):
    """Test adding a favorite address."""
    # Mock user exists
    mock_session.get.return_value = User(id="test-uid")
    
    # Simulate DB assigning ID and created_at on refresh
    def refresh_side_effect(obj):
        obj.id = 123
        obj.created_at = datetime.now()
    mock_session.refresh.side_effect = refresh_side_effect
    
    payload = {
        "label": "Home",
        "latitude": 53.0,
        "longitude": 8.0,
        "address": "Test Street 1"
    }
    
    response = client.post("/users/test-uid/favorites", json=payload)
    
    assert response.status_code == 201
    data = response.json()
    assert data["label"] == "Home"
    assert data["id"] == 123
    
    mock_session.add.assert_called()
    mock_session.commit.assert_called()

def test_add_favorite_user_not_found(client, mock_session):
    """Test adding favorite for non-existent user."""
    mock_session.get.return_value = None
    
    payload = {"label": "Home", "latitude": 53.0, "longitude": 8.0}
    response = client.post("/users/unknown/favorites", json=payload)
    
    assert response.status_code == 404
    assert response.json()["detail"] == "User not found"

def test_get_favorites_success(client, mock_session):
    """Test retrieving favorites list."""
    # Mock user exists
    mock_session.get.return_value = User(id="test-uid")
    
    # Mock exec().all() return value
    mock_favorites = [
        FavoriteAddress(
            id=1, user_id="test-uid", label="Home", 
            latitude=53.0, longitude=8.0, 
            created_at=datetime.now()
        )
    ]
    mock_session.exec.return_value.all.return_value = mock_favorites
    
    response = client.get("/users/test-uid/favorites")
    
    assert response.status_code == 200
    data = response.json()
    assert data["count"] == 1
    assert data["favorites"][0]["label"] == "Home"

def test_delete_favorite_success(client, mock_session):
    """Test deleting a favorite."""
    # Mock user and favorite retrieval
    user = User(id="test-uid")
    favorite = FavoriteAddress(id=1, user_id="test-uid")
    
    # Side effect for get: first call returns user, second returns favorite
    mock_session.get.side_effect = [user, favorite]
    
    response = client.delete("/users/test-uid/favorites/1")
    
    assert response.status_code == 204
    mock_session.delete.assert_called_with(favorite)

def test_delete_favorite_forbidden(client, mock_session):
    """Test preventing deletion of another user's favorite."""
    user = User(id="test-uid")
    favorite = FavoriteAddress(id=1, user_id="other-user")
    
    mock_session.get.side_effect = [user, favorite]
    
    response = client.delete("/users/test-uid/favorites/1")
    
    assert response.status_code == 403
    assert "Favorite does not belong to this user" in response.json()["detail"]

@patch("app.main.LivabilityScorer.calculate_score")
@patch("app.main.fetch_nearby_features")
def test_analyze_with_preferences(mock_fetch, mock_score, client):
    """Test analyze endpoint processes user preferences."""
    mock_fetch.return_value = []
    mock_score.return_value = {
        "score": 80.0, "base_score": 50.0, "factors": [], "summary": "Personalized"
    }
    
    payload = {
        "latitude": 53.1, 
        "longitude": 8.1,
        "preferences": {
            "greenery": "high",
            "noise": "low"
        }
    }
    
    response = client.post("/analyze", json=payload)
    
    assert response.status_code == 200
    
    # Verify calculate_score received the preferences
    # We allow other defaults to be present, just check our overrides are there
    call_args = mock_score.call_args
    assert call_args is not None
    preferences_arg = call_args.kwargs["preferences"]
    
    assert preferences_arg["greenery"] == "high"
    assert preferences_arg["noise"] == "low"
