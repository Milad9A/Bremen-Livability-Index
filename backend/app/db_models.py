"""SQLModel ORM models for database tables.

These models map to the existing PostgreSQL tables in the gis_data schema.
They use GeoAlchemy2 for PostGIS geometry support.
"""
from typing import Optional, Any
from datetime import datetime
from datetime import date as date_type
from sqlmodel import SQLModel, Field
from sqlalchemy import Column, BigInteger, Text, Date, TIMESTAMP
from geoalchemy2 import Geography


class GISBase(SQLModel):
    """Base class for GIS models with common configuration."""
    
    class Config:
        arbitrary_types_allowed = True


class Tree(GISBase, table=True):
    """Trees table - points representing individual trees."""
    __tablename__ = "trees"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Park(GISBase, table=True):
    """Parks table - polygons representing parks and green spaces."""
    __tablename__ = "parks"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POLYGON", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Amenity(GISBase, table=True):
    """Amenities table - points representing various amenities."""
    __tablename__ = "amenities"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    amenity_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Accident(GISBase, table=True):
    """Accidents table - points representing traffic accidents."""
    __tablename__ = "accidents"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    accident_id: Optional[str] = Field(default=None, sa_column=Column(Text))
    severity: Optional[str] = Field(default=None, sa_column=Column(Text))
    accident_date: Optional[date_type] = Field(default=None, sa_column=Column("date", Date))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class PublicTransport(GISBase, table=True):
    """Public transport stops table - points representing bus/tram stops."""
    __tablename__ = "public_transport"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    transport_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Healthcare(GISBase, table=True):
    """Healthcare facilities table - points representing hospitals, pharmacies, etc."""
    __tablename__ = "healthcare"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    healthcare_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class IndustrialArea(GISBase, table=True):
    """Industrial areas table - polygons representing industrial zones."""
    __tablename__ = "industrial_areas"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class MajorRoad(GISBase, table=True):
    """Major roads table - lines representing highways and major roads."""
    __tablename__ = "major_roads"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    road_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class BikeInfrastructure(GISBase, table=True):
    """Bike infrastructure table - bike lanes, paths, and parking."""
    __tablename__ = "bike_infrastructure"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    infra_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Education(GISBase, table=True):
    """Education facilities table - schools, universities, kindergartens."""
    __tablename__ = "education"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    education_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class SportsLeisure(GISBase, table=True):
    """Sports and leisure facilities table."""
    __tablename__ = "sports_leisure"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    leisure_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class PedestrianInfrastructure(GISBase, table=True):
    """Pedestrian infrastructure table - crossings, pedestrian streets, sidewalks."""
    __tablename__ = "pedestrian_infrastructure"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    infra_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class CulturalVenue(GISBase, table=True):
    """Cultural venues table - museums, theatres, cinemas."""
    __tablename__ = "cultural_venues"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    venue_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class NoiseSource(GISBase, table=True):
    """Noise sources table - nightclubs, bars, etc."""
    __tablename__ = "noise_sources"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    noise_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Railway(GISBase, table=True):
    """Railways table - rail, subway, tram lines."""
    __tablename__ = "railways"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    railway_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class GasStation(GISBase, table=True):
    """Gas stations table."""
    __tablename__ = "gas_stations"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="POINT", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class WasteFacility(GISBase, table=True):
    """Waste facilities table - landfills, recycling centers."""
    __tablename__ = "waste_facilities"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    waste_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class PowerInfrastructure(GISBase, table=True):
    """Power infrastructure table - power lines, substations."""
    __tablename__ = "power_infrastructure"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    power_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class ParkingLot(GISBase, table=True):
    """Parking lots table - surface parking areas."""
    __tablename__ = "parking_lots"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    parking_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class Airport(GISBase, table=True):
    """Airports and helipads table."""
    __tablename__ = "airports"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    airport_type: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )


class ConstructionSite(GISBase, table=True):
    """Construction sites table."""
    __tablename__ = "construction_sites"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    osm_id: Optional[int] = Field(default=None, sa_column=Column(BigInteger))
    name: Optional[str] = Field(default=None, sa_column=Column(Text))
    geometry: Any = Field(
        default=None,
        sa_column=Column(Geography(geometry_type="GEOMETRY", srid=4326))
    )
    created_at: Optional[datetime] = Field(
        default=None,
        sa_column=Column(TIMESTAMP, default=datetime.utcnow)
    )
