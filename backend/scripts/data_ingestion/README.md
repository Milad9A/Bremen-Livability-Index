# Data Ingestion

Scripts for fetching and importing spatial data into the PostGIS database.

## Scripts

### `ingest_osm_data.py`
Fetches data from OpenStreetMap via Overpass API:
- Trees, Parks, Amenities
- Public Transport stops
- Healthcare facilities
- Industrial areas
- Major roads

### `ingest_unfallatlas.py`
Downloads accident data from the German Accident Atlas (Unfallatlas):
- Source: opengeodata.nrw.de
- Filters for Bremen (ULAND=4)
- ~2,000 accidents per year

## Usage

Run all ingestion:
```bash
python ingest_all_data.py
```

Or run individually:
```bash
python -m data_ingestion.ingest_osm_data
python -m data_ingestion.ingest_unfallatlas
```

## Data Sources

| Source | URL |
|--------|-----|
| OpenStreetMap | overpass-api.de |
| Unfallatlas | opengeodata.nrw.de |
