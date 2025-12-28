"""Pydantic models for API requests and responses."""
from pydantic import BaseModel, Field
from typing import List, Optional


class LocationRequest(BaseModel):
    """Request model for location analysis."""
    latitude: float = Field(..., ge=-90, le=90, description="Latitude in decimal degrees")
    longitude: float = Field(..., ge=-180, le=180, description="Longitude in decimal degrees")


class FactorBreakdown(BaseModel):
    """Breakdown of individual factors affecting the score."""
    factor: str
    value: float
    description: str
    impact: str  # "positive" or "negative"


class LivabilityScoreResponse(BaseModel):
    """Response model for livability score."""
    score: float = Field(..., ge=0, le=100, description="Overall livability score (0-100)")
    location: dict = Field(..., description="Requested location coordinates")
    factors: List[FactorBreakdown] = Field(..., description="Breakdown of contributing factors")
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

