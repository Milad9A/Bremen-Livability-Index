"""Configuration settings for the backend."""
import os
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""
    database_url: str = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5433/bremen_livability"
    )
    api_host: str = os.getenv("API_HOST", "0.0.0.0")
    api_port: int = int(os.getenv("API_PORT", "8000"))
    
    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()

