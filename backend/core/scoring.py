"""Scoring algorithm for livability index."""
from typing import List, Dict, Optional
from app.models import FactorBreakdown
import math


class LivabilityScorer:
    """Calculate livability score based on spatial factors."""
    
    # Positive factor weights (total: 60 max)
    WEIGHT_GREENERY = 14.0
    WEIGHT_AMENITIES = 10.0
    WEIGHT_PUBLIC_TRANSPORT = 8.0
    WEIGHT_HEALTHCARE = 6.0
    WEIGHT_BIKE_INFRASTRUCTURE = 6.0
    WEIGHT_EDUCATION = 5.0
    WEIGHT_SPORTS_LEISURE = 4.0
    WEIGHT_PEDESTRIAN_INFRA = 3.0
    WEIGHT_CULTURAL = 4.0
    
    # Negative factor weights (total: 50 max)
    PENALTY_ACCIDENTS = 8.0
    PENALTY_INDUSTRIAL = 10.0
    PENALTY_MAJOR_ROADS = 6.0
    PENALTY_NOISE = 6.0
    PENALTY_RAILWAY = 5.0
    PENALTY_GAS_STATION = 3.0
    PENALTY_WASTE = 5.0
    PENALTY_POWER = 3.0
    PENALTY_PARKING = 2.0
    PENALTY_AIRPORT = 7.0
    PENALTY_CONSTRUCTION = 2.0
    
    # Base score
    BASE_SCORE = 40.0
    
    # Distance thresholds (in meters) 
    GREENERY_RADIUS = 175       
    AMENITIES_RADIUS = 550      
    PUBLIC_TRANSPORT_RADIUS = 450  
    HEALTHCARE_RADIUS = 700     
    ACCIDENT_RADIUS = 90        
    INDUSTRIAL_RADIUS = 125     
    MAJOR_ROADS_RADIUS = 40     
    BIKE_INFRASTRUCTURE_RADIUS = 275  
    EDUCATION_RADIUS = 500     
    SPORTS_LEISURE_RADIUS = 700 
    PEDESTRIAN_INFRA_RADIUS = 275  
    CULTURAL_RADIUS = 500      
    NOISE_RADIUS = 60
    RAILWAY_RADIUS = 75
    GAS_STATION_RADIUS = 50
    WASTE_RADIUS = 200
    POWER_RADIUS = 50
    PARKING_RADIUS = 30
    AIRPORT_RADIUS = 500
    CONSTRUCTION_RADIUS = 100
    
    @staticmethod
    def calculate_greenery_score(tree_count: int, park_count: int) -> float:
        """Calculate greenery score (0-14)."""
        tree_score = min(9.0, math.log1p(tree_count) * 2.0)
        park_score = min(5.0, park_count * 2.5)
        return tree_score + park_score
    
    @staticmethod
    def calculate_amenities_score(amenity_count: int) -> float:
        """Calculate amenities score (0-10)."""
        if amenity_count == 0:
            return 0.0
        score = min(10.0, math.log1p(amenity_count) * 2.8)  
        return score
    
    @staticmethod
    def calculate_public_transport_score(stop_count: int) -> float:
        """Calculate public transport score (0-8)."""
        if stop_count == 0:
            return 0.0
        return min(8.0, math.log1p(stop_count) * 3.5)
    
    @staticmethod
    def calculate_healthcare_score(facility_count: int) -> float:
        """Calculate healthcare score (0-6)."""
        if facility_count == 0:
            return 0.0
        return min(6.0, facility_count * 2.5)
    
    @staticmethod
    def calculate_bike_infrastructure_score(bike_count: int) -> float:
        """Calculate bike infrastructure score (0-6)."""
        if bike_count == 0:
            return 0.0
        return min(6.0, math.log1p(bike_count) * 2.5)
    
    @staticmethod
    def calculate_education_score(education_count: int) -> float:
        """Calculate education facilities score (0-5)."""
        if education_count == 0:
            return 0.0
        return min(5.0, education_count * 1.5)
    
    @staticmethod
    def calculate_sports_leisure_score(sports_count: int) -> float:
        """Calculate sports and leisure score (0-4)."""
        if sports_count == 0:
            return 0.0
        return min(4.0, math.log1p(sports_count) * 1.8)
    
    @staticmethod
    def calculate_pedestrian_infra_score(pedestrian_count: int) -> float:
        """Calculate pedestrian infrastructure score (0-3)."""
        if pedestrian_count == 0:
            return 0.0
        return min(3.0, math.log1p(pedestrian_count) * 1.2)
    
    @staticmethod
    def calculate_cultural_score(cultural_count: int) -> float:
        """Calculate cultural venues score (0-4)."""
        if cultural_count == 0:
            return 0.0
        return min(4.0, cultural_count * 2.0)
    
    @staticmethod
    def calculate_accident_penalty(accident_count: int) -> float:
        """Calculate accident penalty (0-8)."""
        if accident_count == 0:
            return 0.0
        return min(8.0, accident_count * 2.0)
    
    @staticmethod
    def calculate_industrial_penalty(in_industrial_area: bool) -> float:
        """Calculate industrial area penalty (0-10)."""
        return 10.0 if in_industrial_area else 0.0
    
    @staticmethod
    def calculate_major_roads_penalty(near_major_road: bool) -> float:
        """Calculate major roads penalty (0-6)."""
        return 6.0 if near_major_road else 0.0
    
    @staticmethod
    def calculate_noise_penalty(noise_count: int) -> float:
        """Calculate noise sources penalty (0-6)."""
        if noise_count == 0:
            return 0.0
        return min(6.0, noise_count * 2.0)
    
    @staticmethod
    def calculate_railway_penalty(near_railway: bool) -> float:
        """Calculate railway proximity penalty (0-5)."""
        return 5.0 if near_railway else 0.0
    
    @staticmethod
    def calculate_gas_station_penalty(near_gas_station: bool) -> float:
        """Calculate gas station proximity penalty (0-3)."""
        return 3.0 if near_gas_station else 0.0
    
    @staticmethod
    def calculate_waste_penalty(near_waste: bool) -> float:
        """Calculate waste facility proximity penalty (0-5)."""
        return 5.0 if near_waste else 0.0
    
    @staticmethod
    def calculate_power_penalty(near_power: bool) -> float:
        """Calculate power infrastructure proximity penalty (0-3)."""
        return 3.0 if near_power else 0.0
    
    @staticmethod
    def calculate_parking_penalty(near_parking: bool) -> float:
        """Calculate parking lot proximity penalty (0-2)."""
        return 2.0 if near_parking else 0.0
    
    @staticmethod
    def calculate_airport_penalty(near_airport: bool) -> float:
        """Calculate airport/helipad proximity penalty (0-7)."""
        return 7.0 if near_airport else 0.0
    
    @staticmethod
    def calculate_construction_penalty(near_construction: bool) -> float:
        """Calculate construction site proximity penalty (0-2)."""
        return 2.0 if near_construction else 0.0
    
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
        noise_count: int = 0,
        near_railway: bool = False,
        near_gas_station: bool = False,
        near_waste: bool = False,
        near_power: bool = False,
        near_parking: bool = False,
        near_airport: bool = False,
        near_construction: bool = False
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
        railway_penalty = cls.calculate_railway_penalty(near_railway)
        gas_station_penalty = cls.calculate_gas_station_penalty(near_gas_station)
        waste_penalty = cls.calculate_waste_penalty(near_waste)
        power_penalty = cls.calculate_power_penalty(near_power)
        parking_penalty = cls.calculate_parking_penalty(near_parking)
        airport_penalty = cls.calculate_airport_penalty(near_airport)
        construction_penalty = cls.calculate_construction_penalty(near_construction)
        
        # Final score
        positive = greenery + amenities + transport + healthcare + bike_infra + education + sports + pedestrian + cultural
        negative = (accident_penalty + industrial_penalty + roads_penalty + noise_penalty +
                   railway_penalty + gas_station_penalty + waste_penalty + power_penalty +
                   parking_penalty + airport_penalty + construction_penalty)
        final_score = max(0.0, min(100.0, cls.BASE_SCORE + positive - negative))
        
        # Build factors list
        factors = []
        
        factors.append(FactorBreakdown(
            factor="Greenery",
            value=greenery,
            description=f"{tree_count} trees, {park_count} parks within {cls.GREENERY_RADIUS}m",
            impact="positive"
        ))
        
        factors.append(FactorBreakdown(
            factor="Amenities",
            value=amenities,
            description=f"{amenity_count} amenities within {cls.AMENITIES_RADIUS}m",
            impact="positive"
        ))
        
        if public_transport_count > 0:
            factors.append(FactorBreakdown(
                factor="Public Transport",
                value=transport,
                description=f"{public_transport_count} stops within {cls.PUBLIC_TRANSPORT_RADIUS}m",
                impact="positive"
            ))
        
        if healthcare_count > 0:
            factors.append(FactorBreakdown(
                factor="Healthcare",
                value=healthcare,
                description=f"{healthcare_count} facilities within {cls.HEALTHCARE_RADIUS}m",
                impact="positive"
            ))
        
        if bike_infrastructure_count > 0:
            factors.append(FactorBreakdown(
                factor="Bike Infrastructure",
                value=bike_infra,
                description=f"{bike_infrastructure_count} bike facilities within {cls.BIKE_INFRASTRUCTURE_RADIUS}m",
                impact="positive"
            ))
        
        if education_count > 0:
            factors.append(FactorBreakdown(
                factor="Education",
                value=education,
                description=f"{education_count} schools/universities within {cls.EDUCATION_RADIUS}m",
                impact="positive"
            ))
        
        if sports_leisure_count > 0:
            factors.append(FactorBreakdown(
                factor="Sports & Leisure",
                value=sports,
                description=f"{sports_leisure_count} sports facilities within {cls.SPORTS_LEISURE_RADIUS}m",
                impact="positive"
            ))
        
        if pedestrian_infra_count > 0:
            factors.append(FactorBreakdown(
                factor="Pedestrian Infrastructure",
                value=pedestrian,
                description=f"{pedestrian_infra_count} pedestrian features within {cls.PEDESTRIAN_INFRA_RADIUS}m",
                impact="positive"
            ))
        
        if cultural_count > 0:
            factors.append(FactorBreakdown(
                factor="Cultural Venues",
                value=cultural,
                description=f"{cultural_count} cultural venues within {cls.CULTURAL_RADIUS}m",
                impact="positive"
            ))
        
        if accident_count > 0:
            factors.append(FactorBreakdown(
                factor="Traffic Safety",
                value=-accident_penalty,
                description=f"{accident_count} accidents within {cls.ACCIDENT_RADIUS}m",
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
                description=f"{noise_count} noise sources within {cls.NOISE_RADIUS}m",
                impact="negative"
            ))
        
        if near_railway:
            factors.append(FactorBreakdown(
                factor="Railway",
                value=-railway_penalty,
                description="Near railway line",
                impact="negative"
            ))
        
        if near_gas_station:
            factors.append(FactorBreakdown(
                factor="Gas Station",
                value=-gas_station_penalty,
                description="Near gas/petrol station",
                impact="negative"
            ))
        
        if near_waste:
            factors.append(FactorBreakdown(
                factor="Waste Facility",
                value=-waste_penalty,
                description="Near waste/recycling facility",
                impact="negative"
            ))
        
        if near_power:
            factors.append(FactorBreakdown(
                factor="Power Infrastructure",
                value=-power_penalty,
                description="Near power lines/substation",
                impact="negative"
            ))
        
        if near_parking:
            factors.append(FactorBreakdown(
                factor="Large Parking",
                value=-parking_penalty,
                description="Near large parking lot",
                impact="negative"
            ))
        
        if near_airport:
            factors.append(FactorBreakdown(
                factor="Airport/Helipad",
                value=-airport_penalty,
                description="Near airport or helipad",
                impact="negative"
            ))
        
        if near_construction:
            factors.append(FactorBreakdown(
                factor="Construction Site",
                value=-construction_penalty,
                description="Near active construction",
                impact="negative"
            ))
        
        # Generate summary
        summary_parts = []
        if greenery >= 10:
            summary_parts.append("Great greenery")
        elif greenery < 4:
            summary_parts.append("Limited greenery")
        
        if amenities >= 8:
            summary_parts.append("Excellent amenities")
        elif amenities < 4:
            summary_parts.append("Limited amenities")
        
        if transport >= 6:
            summary_parts.append("Good transit access")
        
        if bike_infra >= 5:
            summary_parts.append("Good cycling infrastructure")
        
        if pedestrian >= 2:
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
        
        if near_railway:
            summary_parts.append("Near railway")
        
        if near_airport:
            summary_parts.append("Near airport/helipad")
        
        if near_waste:
            summary_parts.append("Near waste facility")
        
        summary = ". ".join(summary_parts) if summary_parts else "Average livability"
        
        return {
            "score": round(final_score, 1),
            "base_score": cls.BASE_SCORE,
            "factors": factors,
            "summary": summary
        }
