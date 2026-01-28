"""Pydantic models for API requests and responses."""
from pydantic import BaseModel, Field, field_validator
from typing import List, Optional, Dict, Literal
from enum import Enum


class ImportanceLevel(str, Enum):
    """Importance level for scoring factors."""
    excluded = "excluded"
    low = "low"
    medium = "medium"
    high = "high"


class UserPreferences(BaseModel):
    """User preferences for factor importance levels.
    
    Each factor can be set to: excluded, low, medium, or high.
    If not specified, factors default to 'medium'.
    """
    greenery: ImportanceLevel = ImportanceLevel.medium
    amenities: ImportanceLevel = ImportanceLevel.medium
    public_transport: ImportanceLevel = ImportanceLevel.medium
    healthcare: ImportanceLevel = ImportanceLevel.medium
    bike_infrastructure: ImportanceLevel = ImportanceLevel.medium
    education: ImportanceLevel = ImportanceLevel.medium
    sports_leisure: ImportanceLevel = ImportanceLevel.medium
    pedestrian_infrastructure: ImportanceLevel = ImportanceLevel.medium
    cultural: ImportanceLevel = ImportanceLevel.medium
    accidents: ImportanceLevel = ImportanceLevel.medium
    industrial: ImportanceLevel = ImportanceLevel.medium
    major_roads: ImportanceLevel = ImportanceLevel.medium
    noise: ImportanceLevel = ImportanceLevel.medium
    railway: ImportanceLevel = ImportanceLevel.medium
    gas_station: ImportanceLevel = ImportanceLevel.medium
    waste: ImportanceLevel = ImportanceLevel.medium
    power: ImportanceLevel = ImportanceLevel.medium
    parking: ImportanceLevel = ImportanceLevel.medium
    airport: ImportanceLevel = ImportanceLevel.medium
    construction: ImportanceLevel = ImportanceLevel.medium
    
    def to_dict(self) -> Dict[str, str]:
        """Convert to dict for scoring algorithm."""
        return {k: v.value for k, v in self.model_dump().items()}


class LocationRequest(BaseModel):
    """Request model for location analysis."""
    latitude: float = Field(..., ge=-90, le=90, description="Latitude in decimal degrees")
    longitude: float = Field(..., ge=-180, le=180, description="Longitude in decimal degrees")
    preferences: Optional[UserPreferences] = Field(
        None, 
        description="Optional user preferences for factor importance levels"
    )


class FactorBreakdown(BaseModel):
    """Breakdown of individual factors affecting the score."""
    factor: str
    value: float
    description: str
    impact: str  # "positive" or "negative"


class FeatureDetail(BaseModel):
    """Detail of a nearby feature."""
    id: Optional[int] = None
    name: Optional[str] = None
    type: str = Field(..., description="Type of feature (tree, park, amenity, etc.)")
    subtype: Optional[str] = Field(None, description="Specific subtype (e.g. restaurant, school)")
    distance: float = Field(..., description="Distance from query point in meters")
    geometry: dict = Field(..., description="GeoJSON geometry")

class LivabilityScoreResponse(BaseModel):
    """Response model for livability score."""
    score: float = Field(..., ge=0, le=100, description="Overall livability score (0-100)")
    base_score: float = Field(..., description="Base score before positive and negative factors")
    location: dict = Field(..., description="Requested location coordinates")
    factors: List[FactorBreakdown] = Field(..., description="Breakdown of contributing factors")
    nearby_features: Dict[str, List[FeatureDetail]] = Field(default_factory=dict, description="Details of nearby features")
    summary: str = Field(..., description="Human-readable summary")


class GeocodeRequest(BaseModel):
    """Request model for address geocoding."""
    query: str = Field(..., min_length=1, description="Address search query")
    limit: int = Field(5, ge=1, le=10, description="Maximum number of results to return")


class GeocodeResult(BaseModel):
    """Individual geocoded result."""
    latitude: float
    longitude: float
    display_name: str
    address: dict
    type: str
    importance: float


class GeocodeResponse(BaseModel):
    """Response model for geocoding."""
    results: List[GeocodeResult] = Field(..., description="List of geocoded results")
    count: int = Field(..., description="Number of results returned")

