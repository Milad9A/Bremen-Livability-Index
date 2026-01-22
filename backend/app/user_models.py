"""SQLModel models for users and favorites."""
from datetime import datetime
from typing import Optional
from sqlmodel import SQLModel, Field


class User(SQLModel, table=True):
    """User model for storing authenticated users."""
    __tablename__ = "users"
    __table_args__ = {"schema": "gis_data"}
    
    id: str = Field(primary_key=True)  # Firebase UID
    email: Optional[str] = Field(default=None, max_length=255)
    display_name: Optional[str] = Field(default=None, max_length=255)
    provider: str = Field(max_length=50)  # google, github, email, guest
    created_at: datetime = Field(default_factory=datetime.utcnow)


class FavoriteAddress(SQLModel, table=True):
    """Model for storing user favorite addresses."""
    __tablename__ = "favorite_addresses"
    __table_args__ = {"schema": "gis_data"}
    
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: str = Field(foreign_key="gis_data.users.id")
    label: str = Field(max_length=255)
    latitude: float
    longitude: float
    address: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
