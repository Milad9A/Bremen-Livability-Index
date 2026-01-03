"""Scoring algorithm for livability index."""
from typing import List, Dict, Optional
from app.models import FactorBreakdown
import math


class LivabilityScorer:
    """Calculate livability score based on spatial factors."""
    
    # Positive factor weights (total: 75 max)
    WEIGHT_GREENERY = 18.0
    WEIGHT_AMENITIES = 12.0
    WEIGHT_PUBLIC_TRANSPORT = 10.0
    WEIGHT_HEALTHCARE = 7.0
    WEIGHT_BIKE_INFRASTRUCTURE = 8.0
    WEIGHT_EDUCATION = 7.0
    WEIGHT_SPORTS_LEISURE = 5.0
    WEIGHT_PEDESTRIAN_INFRA = 4.0
    WEIGHT_CULTURAL = 4.0
    
    # Negative factor weights (total: 25 max)
    PENALTY_ACCIDENTS = 7.0
    PENALTY_INDUSTRIAL = 8.0
    PENALTY_MAJOR_ROADS = 5.0
    PENALTY_NOISE = 5.0
    
    # Base score
    BASE_SCORE = 45.0
    
    # Distance thresholds (in meters) 
    GREENERY_RADIUS = 175       
    AMENITIES_RADIUS = 550      
    PUBLIC_TRANSPORT_RADIUS = 450  
    HEALTHCARE_RADIUS = 700     
    ACCIDENT_RADIUS = 90        
    INDUSTRIAL_RADIUS = 125     
    MAJOR_ROADS_RADIUS = 40     
    BIKE_INFRASTRUCTURE_RADIUS = 275  
    EDUCATION_RADIUS = 900     
    SPORTS_LEISURE_RADIUS = 700 
    PEDESTRIAN_INFRA_RADIUS = 275  
    CULTURAL_RADIUS = 1100      
    NOISE_RADIUS = 60           
    
    @staticmethod
    def calculate_greenery_score(tree_count: int, park_count: int) -> float:
        """Calculate greenery score (0-18)."""
        tree_score = min(11.0, math.log1p(tree_count) * 2.75)
        park_score = min(7.0, park_count * 3.5)
        return tree_score + park_score
    
    @staticmethod
    def calculate_amenities_score(amenity_count: int) -> float:
        """Calculate amenities score (0-12)."""
        if amenity_count == 0:
            return 0.0
        score = min(12.0, math.log1p(amenity_count) * 4.2)  
        return score
    
    @staticmethod
    def calculate_public_transport_score(stop_count: int) -> float:
        """Calculate public transport score (0-10)."""
        if stop_count == 0:
            return 0.0
        return min(10.0, math.log1p(stop_count) * 5.75)
    
    @staticmethod
    def calculate_healthcare_score(facility_count: int) -> float:
        """Calculate healthcare score (0-7)."""
        if facility_count == 0:
            return 0.0
        return min(7.0, facility_count * 3.75)
    
    @staticmethod
    def calculate_bike_infrastructure_score(bike_count: int) -> float:
        """Calculate bike infrastructure score (0-8)."""
        if bike_count == 0:
            return 0.0
        return min(8.0, math.log1p(bike_count) * 3.75)
    
    @staticmethod
    def calculate_education_score(education_count: int) -> float:
        """Calculate education facilities score (0-7)."""
        if education_count == 0:
            return 0.0
        return min(7.0, education_count * 3.0)
    
    @staticmethod
    def calculate_sports_leisure_score(sports_count: int) -> float:
        """Calculate sports and leisure score (0-5)."""
        if sports_count == 0:
            return 0.0
        return min(5.0, math.log1p(sports_count) * 2.75)
    
    @staticmethod
    def calculate_pedestrian_infra_score(pedestrian_count: int) -> float:
        """Calculate pedestrian infrastructure score (0-4)."""
        if pedestrian_count == 0:
            return 0.0
        return min(4.0, math.log1p(pedestrian_count) * 2.0)
    
    @staticmethod
    def calculate_cultural_score(cultural_count: int) -> float:
        """Calculate cultural venues score (0-4)."""
        if cultural_count == 0:
            return 0.0
        return min(4.0, cultural_count * 2.0)
    
    @staticmethod
    def calculate_accident_penalty(accident_count: int) -> float:
        """Calculate accident penalty (0-7)."""
        if accident_count == 0:
            return 0.0
        return min(7.0, accident_count * 1.75)
    
    @staticmethod
    def calculate_industrial_penalty(in_industrial_area: bool) -> float:
        """Calculate industrial area penalty (0-8)."""
        return 8.0 if in_industrial_area else 0.0
    
    @staticmethod
    def calculate_major_roads_penalty(near_major_road: bool) -> float:
        """Calculate major roads penalty (0-5)."""
        return 5.0 if near_major_road else 0.0
    
    @staticmethod
    def calculate_noise_penalty(noise_count: int) -> float:
        """Calculate noise sources penalty (0-5)."""
        if noise_count == 0:
            return 0.0
        return min(5.0, noise_count * 1.75)
    
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
        near_major_road: bool = False,
        bike_infrastructure_count: int = 0,
        education_count: int = 0,
        sports_leisure_count: int = 0,
        pedestrian_infra_count: int = 0,
        cultural_count: int = 0,
        noise_count: int = 0
    ) -> Dict:
        """Calculate overall livability score."""
        
        # Positive factors
        greenery = cls.calculate_greenery_score(tree_count, park_count)
        amenities = cls.calculate_amenities_score(amenity_count)
        transport = cls.calculate_public_transport_score(public_transport_count)
        healthcare = cls.calculate_healthcare_score(healthcare_count)
        bike_infra = cls.calculate_bike_infrastructure_score(bike_infrastructure_count)
        education = cls.calculate_education_score(education_count)
        sports = cls.calculate_sports_leisure_score(sports_leisure_count)
        pedestrian = cls.calculate_pedestrian_infra_score(pedestrian_infra_count)
        cultural = cls.calculate_cultural_score(cultural_count)
        
        # Negative factors
        accident_penalty = cls.calculate_accident_penalty(accident_count)
        industrial_penalty = cls.calculate_industrial_penalty(near_industrial)
        roads_penalty = cls.calculate_major_roads_penalty(near_major_road)
        noise_penalty = cls.calculate_noise_penalty(noise_count)
        
        # Final score
        positive = greenery + amenities + transport + healthcare + bike_infra + education + sports + pedestrian + cultural
        negative = accident_penalty + industrial_penalty + roads_penalty + noise_penalty
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
        
        if bike_infrastructure_count > 0:
            factors.append(FactorBreakdown(
                factor="Bike Infrastructure",
                value=bike_infra,
                description=f"{bike_infrastructure_count} bike facilities within 200m",
                impact="positive"
            ))
        
        if education_count > 0:
            factors.append(FactorBreakdown(
                factor="Education",
                value=education,
                description=f"{education_count} schools/universities within 800m",
                impact="positive"
            ))
        
        if sports_leisure_count > 0:
            factors.append(FactorBreakdown(
                factor="Sports & Leisure",
                value=sports,
                description=f"{sports_leisure_count} sports facilities within 500m",
                impact="positive"
            ))
        
        if pedestrian_infra_count > 0:
            factors.append(FactorBreakdown(
                factor="Pedestrian Infrastructure",
                value=pedestrian,
                description=f"{pedestrian_infra_count} pedestrian features within 200m",
                impact="positive"
            ))
        
        if cultural_count > 0:
            factors.append(FactorBreakdown(
                factor="Cultural Venues",
                value=cultural,
                description=f"{cultural_count} cultural venues within 1km",
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
        
        if noise_count > 0:
            factors.append(FactorBreakdown(
                factor="Noise Sources",
                value=-noise_penalty,
                description=f"{noise_count} noise sources within 100m",
                impact="negative"
            ))
        
        # Generate summary
        summary_parts = []
        if greenery >= 12:
            summary_parts.append("Great greenery")
        elif greenery < 6:
            summary_parts.append("Limited greenery")
        
        if amenities >= 10:
            summary_parts.append("Excellent amenities")
        elif amenities < 5:
            summary_parts.append("Limited amenities")
        
        if transport >= 8:
            summary_parts.append("Good transit access")
        
        if bike_infra >= 6:
            summary_parts.append("Good cycling infrastructure")
        
        if pedestrian >= 3:
            summary_parts.append("Pedestrian-friendly")
        
        if cultural_count >= 2:
            summary_parts.append("Cultural area")
        
        if near_industrial:
            summary_parts.append("Industrial area nearby")
        
        if near_major_road:
            summary_parts.append("Near major road")
        
        if accident_penalty > 4:
            summary_parts.append("Traffic safety concerns")
        
        if noise_penalty > 4:
            summary_parts.append("Potential noise issues")
        
        summary = ". ".join(summary_parts) if summary_parts else "Average livability"
        
        return {
            "score": round(final_score, 1),
            "base_score": cls.BASE_SCORE,
            "factors": factors,
            "summary": summary
        }
