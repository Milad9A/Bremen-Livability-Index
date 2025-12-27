FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for psycopg2 and geopandas
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Use shell form so $PORT is expanded
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
