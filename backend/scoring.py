"""Scoring algorithm for livability index."""
from typing import List, Dict, Optional
from models import FactorBreakdown
import math


class LivabilityScorer:
    """Calculate livability score based on spatial factors."""
    
    # Positive factor weights
    WEIGHT_GREENERY = 25.0
    WEIGHT_AMENITIES = 25.0
    WEIGHT_PUBLIC_TRANSPORT = 15.0
    WEIGHT_HEALTHCARE = 10.0
    
    # Negative factor weights (penalties)
    PENALTY_ACCIDENTS = 15.0
    PENALTY_INDUSTRIAL = 15.0
    PENALTY_MAJOR_ROADS = 10.0
    
    # Base score
    BASE_SCORE = 25.0
    
    # Distance thresholds (in meters)
    GREENERY_RADIUS = 100
    AMENITIES_RADIUS = 500
    PUBLIC_TRANSPORT_RADIUS = 300
    HEALTHCARE_RADIUS = 500
    ACCIDENT_RADIUS = 150
    INDUSTRIAL_RADIUS = 200
    MAJOR_ROADS_RADIUS = 100
    
    @staticmethod
    def calculate_greenery_score(tree_count: int, park_count: int) -> float:
        """Calculate greenery score (0-25)."""
        tree_score = min(12.5, math.log1p(tree_count) * 2.5)
        park_score = min(12.5, park_count * 4.0)
        return tree_score + park_score
    
    @staticmethod
    def calculate_amenities_score(amenity_count: int) -> float:
        """Calculate amenities score (0-25)."""
        if amenity_count == 0:
            return 0.0
        score = min(25.0, math.log1p(amenity_count) * 4.5)
        if amenity_count >= 10:
            score = min(25.0, score + 3.0)
        return score
    
    @staticmethod
    def calculate_public_transport_score(stop_count: int) -> float:
        """Calculate public transport score (0-15)."""
        if stop_count == 0:
            return 0.0
        return min(15.0, math.log1p(stop_count) * 5.0)
    
    @staticmethod
    def calculate_healthcare_score(facility_count: int) -> float:
        """Calculate healthcare score (0-10)."""
        if facility_count == 0:
            return 0.0
        return min(10.0, facility_count * 3.0)
    
    @staticmethod
    def calculate_accident_penalty(accident_count: int) -> float:
        """Calculate accident penalty (0-15)."""
        if accident_count == 0:
            return 0.0
        return min(15.0, accident_count * 3.0)
    
    @staticmethod
    def calculate_industrial_penalty(in_industrial_area: bool) -> float:
        """Calculate industrial area penalty (0-15)."""
        return 15.0 if in_industrial_area else 0.0
    
    @staticmethod
    def calculate_major_roads_penalty(near_major_road: bool) -> float:
        """Calculate major roads penalty (0-10)."""
        return 10.0 if near_major_road else 0.0
    
    @classmethod
    def calculate_score(
        cls,
        tree_count: int,
        park_count: int,
        amenity_count: int,
        accident_count: int,
        public_transport_count: int = 0,
        healthcare_count: int = 0,
        near_industrial: bool = False,
        near_major_road: bool = False
    ) -> Dict:
        """Calculate overall livability score."""
        
        # Positive factors
        greenery = cls.calculate_greenery_score(tree_count, park_count)
        amenities = cls.calculate_amenities_score(amenity_count)
        transport = cls.calculate_public_transport_score(public_transport_count)
        healthcare = cls.calculate_healthcare_score(healthcare_count)
        
        # Negative factors
        accident_penalty = cls.calculate_accident_penalty(accident_count)
        industrial_penalty = cls.calculate_industrial_penalty(near_industrial)
        roads_penalty = cls.calculate_major_roads_penalty(near_major_road)
        
        # Final score
        positive = greenery + amenities + transport + healthcare
        negative = accident_penalty + industrial_penalty + roads_penalty
        final_score = max(0.0, min(100.0, cls.BASE_SCORE + positive - negative))
        
        # Build factors list
        factors = []
        
        factors.append(FactorBreakdown(
            factor="Greenery",
            value=greenery,
            description=f"{tree_count} trees, {park_count} parks within 100m",
            impact="positive"
        ))
        
        factors.append(FactorBreakdown(
            factor="Amenities",
            value=amenities,
            description=f"{amenity_count} amenities within 500m",
            impact="positive"
        ))
        
        if public_transport_count > 0:
            factors.append(FactorBreakdown(
                factor="Public Transport",
                value=transport,
                description=f"{public_transport_count} stops within 300m",
                impact="positive"
            ))
        
        if healthcare_count > 0:
            factors.append(FactorBreakdown(
                factor="Healthcare",
                value=healthcare,
                description=f"{healthcare_count} facilities within 500m",
                impact="positive"
            ))
        
        if accident_count > 0:
            factors.append(FactorBreakdown(
                factor="Traffic Safety",
                value=-accident_penalty,
                description=f"{accident_count} accidents within 150m",
                impact="negative"
            ))
        
        if near_industrial:
            factors.append(FactorBreakdown(
                factor="Industrial Area",
                value=-industrial_penalty,
                description="Near industrial zone",
                impact="negative"
            ))
        
        if near_major_road:
            factors.append(FactorBreakdown(
                factor="Major Road",
                value=-roads_penalty,
                description="Near highway/major road",
                impact="negative"
            ))
        
        # Generate summary
        summary_parts = []
        if greenery >= 15:
            summary_parts.append("Great greenery")
        elif greenery < 8:
            summary_parts.append("Limited greenery")
        
        if amenities >= 15:
            summary_parts.append("Excellent amenities")
        elif amenities < 8:
            summary_parts.append("Limited amenities")
        
        if transport >= 8:
            summary_parts.append("Good transit access")
        
        if near_industrial:
            summary_parts.append("Industrial area nearby")
        
        if near_major_road:
            summary_parts.append("Near major road")
        
        if accident_penalty > 5:
            summary_parts.append("Traffic safety concerns")
        
        summary = ". ".join(summary_parts) if summary_parts else "Average livability"
        
        return {
            "score": round(final_score, 1),
            "factors": factors,
            "summary": summary
        }
