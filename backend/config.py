"""Configuration settings for the backend."""
import os
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""
    # Railway provides DATABASE_URL automatically when PostgreSQL is added
    database_url: str = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5433/bremen_livability"
    )
    api_host: str = "0.0.0.0"
    # Railway uses PORT, local dev uses API_PORT or defaults to 8000
    api_port: int = int(os.getenv("PORT", os.getenv("API_PORT", "8000")))
    
    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()
