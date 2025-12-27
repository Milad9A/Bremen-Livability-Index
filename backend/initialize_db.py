"""Initialize the database schema from init_db.sql."""
import os
import psycopg2
from config import settings

def main():
    print("=" * 50)
    print("🚀 Initializing Database Schema")
    print("=" * 50)
    
    db_url = settings.database_url
    print(f"Target Database: {db_url.split('@')[1] if '@' in db_url else 'Local'}")
    
    try:
        # Connect to database
        conn = psycopg2.connect(db_url)
        cursor = conn.cursor()
        
        # Read SQL file
        with open("init_db.sql", "r") as f:
            sql_script = f.read()
        
        # Execute script
        print("\nExecuting init_db.sql...")
        cursor.execute(sql_script)
        conn.commit()
        
        print("✅ Schema initialized successfully!")
        
        cursor.close()
        conn.close()
        
    except FileNotFoundError:
        print("❌ Error: init_db.sql not found!")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
