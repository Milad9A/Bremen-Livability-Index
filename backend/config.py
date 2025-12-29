"""Configuration settings for the backend using pydantic-settings."""
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field
from typing import List


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    model_config = SettingsConfigDict(
        env_file=".env",
        case_sensitive=False,
        extra="ignore"
    )
    
    # Database
    database_url: str = "postgresql://postgres:postgres@localhost:5433/bremen_livability"
    
    # API Server
    api_host: str = "0.0.0.0"
    # Support both PORT (Render/Railway) and API_PORT (local)
    api_port: int = Field(default=8000, validation_alias="PORT")
    
    # CORS - comma-separated list of allowed origins, or "*" for all
    cors_origins: str = "*"
    
    # Logging
    log_level: str = "INFO"
    
    @property
    def cors_origins_list(self) -> List[str]:
        """Parse CORS origins as a list."""
        if self.cors_origins == "*":
            return ["*"]
        return [origin.strip() for origin in self.cors_origins.split(",")]


settings = Settings()

