"""Comprehensive tests for the scoring algorithm."""
import pytest
from core.scoring import LivabilityScorer


class TestScoringConstants:
    """Tests for scoring constants and configuration."""
    
    def test_base_score_value(self):
        """Test that base score is set correctly."""
        assert LivabilityScorer.BASE_SCORE == 45.0
    
    def test_positive_weights_sum(self):
        """Test that positive weights sum to expected total."""
        positive_sum = (
            LivabilityScorer.WEIGHT_GREENERY +
            LivabilityScorer.WEIGHT_AMENITIES +
            LivabilityScorer.WEIGHT_PUBLIC_TRANSPORT +
            LivabilityScorer.WEIGHT_HEALTHCARE +
            LivabilityScorer.WEIGHT_BIKE_INFRASTRUCTURE +
            LivabilityScorer.WEIGHT_EDUCATION +
            LivabilityScorer.WEIGHT_SPORTS_LEISURE +
            LivabilityScorer.WEIGHT_PEDESTRIAN_INFRA +
            LivabilityScorer.WEIGHT_CULTURAL
        )
        assert positive_sum == 75.0
    
    def test_penalty_weights_sum(self):
        """Test that penalty weights sum to expected total."""
        penalty_sum = (
            LivabilityScorer.PENALTY_ACCIDENTS +
            LivabilityScorer.PENALTY_INDUSTRIAL +
            LivabilityScorer.PENALTY_MAJOR_ROADS +
            LivabilityScorer.PENALTY_NOISE
        )
        assert penalty_sum == 25.0


class TestGreeneryScore:
    """Tests for greenery score calculation."""
    
    def test_zero_trees_and_parks(self):
        """Test score with no greenery."""
        score = LivabilityScorer.calculate_greenery_score(0, 0)
        assert score == 0.0
    
    def test_only_trees(self):
        """Test score with only trees."""
        score = LivabilityScorer.calculate_greenery_score(10, 0)
        assert score > 0.0
        assert score <= 11.0  # Max tree score
    
    def test_only_parks(self):
        """Test score with only parks."""
        score = LivabilityScorer.calculate_greenery_score(0, 2)
        assert score == 7.0  # 2 parks * 3.5 points each
    
    def test_combined_greenery(self):
        """Test score with both trees and parks."""
        score = LivabilityScorer.calculate_greenery_score(50, 2)
        assert score > 7.0  # More than just parks
        assert score <= 18.0  # Max combined
    
    def test_many_trees_caps_at_max(self):
        """Test that many trees cap at maximum tree score."""
        score = LivabilityScorer.calculate_greenery_score(1000, 0)
        assert score == 11.0  # Max tree score
    
    def test_many_parks_caps_at_max(self):
        """Test that many parks cap at maximum park score."""
        score = LivabilityScorer.calculate_greenery_score(0, 10)
        assert score == 7.0  # Max park score (min of 7.0)


class TestAmenitiesScore:
    """Tests for amenities score calculation."""
    
    def test_zero_amenities(self):
        """Test score with no amenities."""
        score = LivabilityScorer.calculate_amenities_score(0)
        assert score == 0.0
    
    def test_one_amenity(self):
        """Test score with single amenity."""
        score = LivabilityScorer.calculate_amenities_score(1)
        assert score > 0.0
        assert score < 12.0
    
    def test_multiple_amenities(self):
        """Test score with multiple amenities."""
        score = LivabilityScorer.calculate_amenities_score(10)
        assert score > LivabilityScorer.calculate_amenities_score(5)
    
    def test_many_amenities_caps_at_max(self):
        """Test that many amenities cap at maximum."""
        score = LivabilityScorer.calculate_amenities_score(1000)
        assert score == 12.0


class TestPublicTransportScore:
    """Tests for public transport score calculation."""
    
    def test_zero_stops(self):
        """Test score with no transit stops."""
        score = LivabilityScorer.calculate_public_transport_score(0)
        assert score == 0.0
    
    def test_one_stop(self):
        """Test score with one stop."""
        score = LivabilityScorer.calculate_public_transport_score(1)
        assert score > 0.0
        assert score < 10.0
    
    def test_multiple_stops(self):
        """Test that more stops give higher scores."""
        score_1 = LivabilityScorer.calculate_public_transport_score(1)
        score_3 = LivabilityScorer.calculate_public_transport_score(3)
        assert score_3 > score_1
    
    def test_many_stops_caps_at_max(self):
        """Test that many stops cap at maximum."""
        score = LivabilityScorer.calculate_public_transport_score(100)
        assert score == 10.0


class TestHealthcareScore:
    """Tests for healthcare score calculation."""
    
    def test_zero_facilities(self):
        """Test score with no healthcare facilities."""
        score = LivabilityScorer.calculate_healthcare_score(0)
        assert score == 0.0
    
    def test_one_facility(self):
        """Test score with one facility."""
        score = LivabilityScorer.calculate_healthcare_score(1)
        assert score == 3.75
    
    def test_two_facilities_max(self):
        """Test that two facilities reach max score."""
        score = LivabilityScorer.calculate_healthcare_score(2)
        assert score == 7.0


class TestBikeInfrastructureScore:
    """Tests for bike infrastructure score calculation."""
    
    def test_zero_bike_infra(self):
        """Test score with no bike infrastructure."""
        score = LivabilityScorer.calculate_bike_infrastructure_score(0)
        assert score == 0.0
    
    def test_some_bike_infra(self):
        """Test score with some bike infrastructure."""
        score = LivabilityScorer.calculate_bike_infrastructure_score(5)
        assert score > 0.0
        assert score <= 8.0


class TestEducationScore:
    """Tests for education score calculation."""
    
    def test_zero_education(self):
        """Test score with no education facilities."""
        score = LivabilityScorer.calculate_education_score(0)
        assert score == 0.0
    
    def test_one_school(self):
        """Test score with one school."""
        score = LivabilityScorer.calculate_education_score(1)
        assert score == 3.0
    
    def test_two_schools_max(self):
        """Test that two schools reach max score."""
        score = LivabilityScorer.calculate_education_score(2)
        assert score == 6.0


class TestSportsLeisureScore:
    """Tests for sports and leisure score calculation."""
    
    def test_zero_sports(self):
        """Test score with no sports facilities."""
        score = LivabilityScorer.calculate_sports_leisure_score(0)
        assert score == 0.0
    
    def test_some_sports(self):
        """Test score with some sports facilities."""
        score = LivabilityScorer.calculate_sports_leisure_score(3)
        assert score > 0.0
        assert score <= 5.0


class TestPedestrianInfraScore:
    """Tests for pedestrian infrastructure score calculation."""
    
    def test_zero_pedestrian(self):
        """Test score with no pedestrian infrastructure."""
        score = LivabilityScorer.calculate_pedestrian_infra_score(0)
        assert score == 0.0
    
    def test_some_pedestrian(self):
        """Test score with some pedestrian infrastructure."""
        score = LivabilityScorer.calculate_pedestrian_infra_score(5)
        assert score > 0.0
        assert score <= 4.0


class TestCulturalScore:
    """Tests for cultural venues score calculation."""
    
    def test_zero_cultural(self):
        """Test score with no cultural venues."""
        score = LivabilityScorer.calculate_cultural_score(0)
        assert score == 0.0
    
    def test_one_venue(self):
        """Test score with one venue."""
        score = LivabilityScorer.calculate_cultural_score(1)
        assert score == 2.0
    
    def test_two_venues_max(self):
        """Test that two venues reach max score."""
        score = LivabilityScorer.calculate_cultural_score(2)
        assert score == 4.0


class TestAccidentPenalty:
    """Tests for accident penalty calculation."""
    
    def test_zero_accidents(self):
        """Test no penalty with no accidents."""
        penalty = LivabilityScorer.calculate_accident_penalty(0)
        assert penalty == 0.0
    
    def test_one_accident(self):
        """Test penalty with one accident."""
        penalty = LivabilityScorer.calculate_accident_penalty(1)
        assert penalty == 1.75
    
    def test_many_accidents_caps(self):
        """Test that penalty caps at maximum."""
        penalty = LivabilityScorer.calculate_accident_penalty(10)
        assert penalty == 7.0


class TestIndustrialPenalty:
    """Tests for industrial area penalty."""
    
    def test_not_near_industrial(self):
        """Test no penalty when not near industrial area."""
        penalty = LivabilityScorer.calculate_industrial_penalty(False)
        assert penalty == 0.0
    
    def test_near_industrial(self):
        """Test penalty when near industrial area."""
        penalty = LivabilityScorer.calculate_industrial_penalty(True)
        assert penalty == 8.0


class TestMajorRoadsPenalty:
    """Tests for major roads penalty."""
    
    def test_not_near_major_road(self):
        """Test no penalty when not near major road."""
        penalty = LivabilityScorer.calculate_major_roads_penalty(False)
        assert penalty == 0.0
    
    def test_near_major_road(self):
        """Test penalty when near major road."""
        penalty = LivabilityScorer.calculate_major_roads_penalty(True)
        assert penalty == 5.0


class TestNoisePenalty:
    """Tests for noise penalty calculation."""
    
    def test_zero_noise(self):
        """Test no penalty with no noise sources."""
        penalty = LivabilityScorer.calculate_noise_penalty(0)
        assert penalty == 0.0
    
    def test_some_noise(self):
        """Test penalty with some noise sources."""
        penalty = LivabilityScorer.calculate_noise_penalty(2)
        assert penalty == 3.5
    
    def test_many_noise_caps(self):
        """Test that penalty caps at maximum."""
        penalty = LivabilityScorer.calculate_noise_penalty(10)
        assert penalty == 5.0


class TestCalculateScore:
    """Tests for the main calculate_score method."""
    
    def test_minimum_score_structure(self):
        """Test that minimum input returns valid structure."""
        result = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=0
        )
        assert "score" in result
        assert "base_score" in result
        assert "factors" in result
        assert "summary" in result
    
    def test_base_score_included(self):
        """Test that base score is included in result."""
        result = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=0
        )
        assert result["base_score"] == 45.0
    
    def test_empty_location_gets_base_score(self):
        """Test that a location with nothing gets base score."""
        result = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=0
        )
        assert result["score"] == 45.0
    
    def test_good_location_high_score(self):
        """Test that a location with many positive features scores high."""
        result = LivabilityScorer.calculate_score(
            tree_count=50,
            park_count=2,
            amenity_count=20,
            accident_count=0,
            public_transport_count=5,
            healthcare_count=2,
            near_industrial=False,
            near_major_road=False,
            bike_infrastructure_count=10,
            education_count=2,
            sports_leisure_count=3,
            pedestrian_infra_count=5,
            cultural_count=2,
            noise_count=0
        )
        assert result["score"] > 90.0
    
    def test_bad_location_low_score(self):
        """Test that a location with penalties scores low."""
        result = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=5,
            public_transport_count=0,
            healthcare_count=0,
            near_industrial=True,
            near_major_road=True,
            bike_infrastructure_count=0,
            education_count=0,
            sports_leisure_count=0,
            pedestrian_infra_count=0,
            cultural_count=0,
            noise_count=5
        )
        assert result["score"] < 40.0
    
    def test_score_bounded_0_to_100(self):
        """Test that score is always between 0 and 100."""
        # Test with extreme negative values
        result_low = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=100,
            near_industrial=True,
            near_major_road=True,
            noise_count=100
        )
        assert result_low["score"] >= 0.0
        
        # Test with extreme positive values
        result_high = LivabilityScorer.calculate_score(
            tree_count=10000,
            park_count=100,
            amenity_count=1000,
            accident_count=0,
            public_transport_count=100,
            healthcare_count=100,
            bike_infrastructure_count=1000,
            education_count=100,
            sports_leisure_count=100,
            pedestrian_infra_count=100,
            cultural_count=100
        )
        assert result_high["score"] <= 100.0
    
    def test_factors_list_contains_greenery(self):
        """Test that factors always contain greenery."""
        result = LivabilityScorer.calculate_score(
            tree_count=10,
            park_count=1,
            amenity_count=5,
            accident_count=0
        )
        factor_names = [f.factor for f in result["factors"]]
        assert "Greenery" in factor_names
    
    def test_factors_list_contains_amenities(self):
        """Test that factors always contain amenities."""
        result = LivabilityScorer.calculate_score(
            tree_count=10,
            park_count=1,
            amenity_count=5,
            accident_count=0
        )
        factor_names = [f.factor for f in result["factors"]]
        assert "Amenities" in factor_names
    
    def test_negative_factors_have_negative_impact(self):
        """Test that negative factors are marked with negative impact."""
        result = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=5,
            near_industrial=True
        )
        for factor in result["factors"]:
            if factor.factor in ["Traffic Safety", "Industrial Area", "Major Road", "Noise Sources"]:
                assert factor.impact == "negative"
    
    def test_summary_generated(self):
        """Test that summary is generated."""
        result = LivabilityScorer.calculate_score(
            tree_count=100,
            park_count=5,
            amenity_count=30,
            accident_count=0
        )
        assert len(result["summary"]) > 0
    
    def test_summary_mentions_greenery_when_high(self):
        """Test that summary mentions greenery when score is high."""
        result = LivabilityScorer.calculate_score(
            tree_count=100,
            park_count=5,
            amenity_count=0,
            accident_count=0
        )
        assert "greenery" in result["summary"].lower()
    
    def test_summary_mentions_industrial_when_near(self):
        """Test that summary mentions industrial when nearby."""
        result = LivabilityScorer.calculate_score(
            tree_count=0,
            park_count=0,
            amenity_count=0,
            accident_count=0,
            near_industrial=True
        )
        assert "industrial" in result["summary"].lower()


class TestRadiusConstants:
    """Tests for radius constant values."""
    
    def test_greenery_radius(self):
        """Test greenery radius is sensible."""
        assert LivabilityScorer.GREENERY_RADIUS == 175
    
    def test_amenities_radius(self):
        """Test amenities radius is sensible."""
        assert LivabilityScorer.AMENITIES_RADIUS == 550
    
    def test_public_transport_radius(self):
        """Test public transport radius is sensible."""
        assert LivabilityScorer.PUBLIC_TRANSPORT_RADIUS == 450
    
    def test_accident_radius_smaller_than_positive(self):
        """Test that accident radius is smaller to reduce penalties."""
        assert LivabilityScorer.ACCIDENT_RADIUS < LivabilityScorer.GREENERY_RADIUS
