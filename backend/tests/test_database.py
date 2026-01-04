import pytest
from unittest.mock import MagicMock, patch
from sqlmodel import Session
from sqlalchemy.exc import OperationalError, SQLAlchemyError
from core.database import get_session, get_db_session, check_database_connection, engine

def test_get_session():
    """Test the dependency injection session generator."""
    # We can inspect the generator to see if it yields a session
    generator = get_session()
    session = next(generator)
    assert isinstance(session, Session)
    assert session.bind == engine
    
    # Clean up
    try:
        next(generator)
    except StopIteration:
        pass

def test_get_db_session_commit():
    """Test that context manager commits on success."""
    mock_session = MagicMock(spec=Session)
    
    with patch("core.database.Session", return_value=mock_session):
        with get_db_session() as session:
            assert session == mock_session
        
        # Verify commit was called
        mock_session.commit.assert_called_once()
        mock_session.rollback.assert_not_called()
        mock_session.close.assert_called_once()

def test_get_db_session_rollback():
    """Test that context manager rolls back on exception."""
    mock_session = MagicMock(spec=Session)
    
    with patch("core.database.Session", return_value=mock_session):
        with pytest.raises(ValueError):
            with get_db_session() as session:
                raise ValueError("Something went wrong")
        
        # Verify rollback was called
        mock_session.commit.assert_not_called()
        mock_session.rollback.assert_called_once()
        mock_session.close.assert_called_once()

@patch("core.database.Session")
def test_check_database_connection_success(mock_session_cls):
    """Test successful database connection check."""
    mock_session = MagicMock()
    mock_session_cls.return_value.__enter__.return_value = mock_session
    
    assert check_database_connection() is True
    mock_session.exec.assert_called_once()

@patch("core.database.Session")
def test_check_database_connection_failure(mock_session_cls):
    """Test failed database connection check."""
    mock_session = MagicMock()
    mock_session.exec.side_effect = OperationalError("Connection refused", {}, None)
    mock_session_cls.return_value.__enter__.return_value = mock_session
    
    assert check_database_connection() is False
