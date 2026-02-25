"""Database connection and session management using SQLModel."""

from contextlib import contextmanager
from typing import Generator
from sqlmodel import create_engine, Session
from sqlalchemy import text
from config import settings

engine = create_engine(settings.database_url, echo=False, pool_pre_ping=True)


def get_session() -> Generator[Session, None, None]:
    """Get a database session for FastAPI dependency injection.

    Usage:
        @app.get("/endpoint")
        def endpoint(session: Session = Depends(get_session)):
            ...
    """
    with Session(engine) as session:
        yield session


@contextmanager
def get_db_session() -> Generator[Session, None, None]:
    """Get a database session with automatic cleanup (context manager version).

    Usage:
        with get_db_session() as session:
            ...
    """
    session = Session(engine)
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()


def check_database_connection() -> bool:
    """Check if the database is reachable."""
    try:
        with Session(engine) as session:
            session.exec(text("SELECT 1"))
        return True
    except Exception:
        return False
