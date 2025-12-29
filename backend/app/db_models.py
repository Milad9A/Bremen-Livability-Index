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
