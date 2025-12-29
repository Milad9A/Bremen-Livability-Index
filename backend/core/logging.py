"""Logging configuration for the application."""
import logging
import sys
from config import settings


def setup_logging() -> logging.Logger:
    """Configure and return the application logger."""
    # Create logger
    logger = logging.getLogger("bremen_livability")
    logger.setLevel(getattr(logging, settings.log_level.upper(), logging.INFO))
    
    # Avoid duplicate handlers
    if logger.handlers:
        return logger
    
    # Create console handler with formatting
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    
    # Create formatter
    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    handler.setFormatter(formatter)
    
    # Add handler to logger
    logger.addHandler(handler)
    
    return logger


# Create the application logger
logger = setup_logging()
