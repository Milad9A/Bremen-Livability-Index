"""Database connection and session management."""
import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
from config import settings


@contextmanager
def get_db_connection():
    """Get a database connection with automatic cleanup."""
    conn = psycopg2.connect(settings.database_url)
    try:
        yield conn
    finally:
        conn.close()


@contextmanager
def get_db_cursor():
    """Get a database cursor with automatic cleanup."""
    with get_db_connection() as conn:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        try:
            yield cursor
            conn.commit()
        except Exception:
            conn.rollback()
            raise
        finally:
            cursor.close()

