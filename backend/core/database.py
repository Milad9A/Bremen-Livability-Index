"""Database connection and session management using SQLModel."""
from contextlib import contextmanager
from sqlmodel import create_engine, Session
from sqlalchemy import text
from config import settings

# Create the SQLAlchemy engine
# The pool_pre_ping ensures connections are valid before use
engine = create_engine(
    settings.database_url,
    echo=False,
    pool_pre_ping=True
)


def get_session():
    """Get a database session for dependency injection."""
    with Session(engine) as session:
        yield session


@contextmanager
def get_db_session():
    """Get a database session with automatic cleanup (context manager version)."""
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
