import pytest
from unittest.mock import MagicMock, patch
from fastapi.testclient import TestClient
from app.models import FeatureDetail
from app.main import app


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
            "importance": 0.9,
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
        "summary": "Good",
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


@patch("app.main.LivabilityScorer.calculate_score")
@patch("app.main.fetch_nearby_features")
def test_analyze_with_preferences(mock_fetch, mock_score, client):
    """Test analyze endpoint processes user preferences."""
    mock_fetch.return_value = []
    mock_score.return_value = {
        "score": 80.0,
        "base_score": 50.0,
        "factors": [],
        "summary": "Personalized",
    }

    payload = {
        "latitude": 53.1,
        "longitude": 8.1,
        "preferences": {"greenery": "high", "noise": "low"},
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
