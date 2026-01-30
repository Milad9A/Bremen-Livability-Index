"""Logging configuration for the application."""
import logging
import sys
from config import settings


def setup_logging() -> logging.Logger:
    """Configure and return the application logger."""
    logger = logging.getLogger("bremen_livability")
    logger.setLevel(getattr(logging, settings.log_level.upper(), logging.INFO))
    
    if logger.handlers:
        return logger
    
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    
    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    handler.setFormatter(formatter)
    
    logger.addHandler(handler)
    
    return logger


logger = setup_logging()
