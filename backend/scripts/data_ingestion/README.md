# Data Ingestion

Scripts for fetching and importing spatial data into the PostGIS database.

## Scripts

### `ingest_osm_data.py`
Fetches data from OpenStreetMap via Overpass API:

**Positive Factors:**
- Trees (natural=tree)
- Parks (leisure=park)
- Amenities (supermarket, school, cafe, restaurant, pharmacy, bank, post_office)
- Public Transport stops (bus_stop, tram_stop)
- Healthcare facilities (hospital, pharmacy, doctors, clinic)
- Bike Infrastructure (cycleways, bike lanes, bicycle parking/rental)
- Education Facilities (school, university, college, kindergarten, library)
- Sports & Leisure (sports centres, swimming pools, playgrounds, fitness centres)
- Water Bodies (rivers, streams, canals, lakes)
- Cultural Venues (museums, theatres, cinemas, galleries, arts centres)

**Negative Factors:**
- Industrial areas (landuse=industrial)
- Major roads (motorway, trunk, primary)
- Noise Sources (nightclubs, bars, pubs, fast food, car repair)

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
