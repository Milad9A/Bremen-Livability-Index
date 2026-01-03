# Data Ingestion

Scripts for fetching and importing spatial data into the PostGIS database.

## Scripts

### `ingest_osm_data.py`
Fetches data from OpenStreetMap via Overpass API:

**Positive Factors:**
- Trees (`natural=tree`)
- Parks (`leisure=park`)
- Amenities (`supermarket`, `cafe`, `restaurant`, `bank`, `post_office`, `bakery`, `butcher`)
- Public Transport stops (`bus_stop`, `tram_stop`)
- Healthcare facilities (`hospital`, `pharmacy`, `doctors`, `clinic`)
- Bike Infrastructure (`cycleways`, `bike lanes`, `bicycle parking/rental`)
- Education Facilities (`school`, `university`, `college`, `kindergarten`, `library`)
- Sports & Leisure (`sports centres`, `swimming pools`, `playgrounds`, `fitness centres`)
- Pedestrian Infrastructure (`crossings`, `pedestrian streets`, `footways`)
- Cultural Venues (`museums`, `theatres`, `cinemas`, `galleries`, `arts centres`)

**Negative Factors:**
- Industrial areas (`landuse=industrial`)
- Major roads (`motorway`, `trunk`, `primary`)
- Noise Sources (`nightclubs`, `bars`, `pubs`, `fast food`, `car repair`)

### `ingest_unfallatlas.py`
Downloads accident data from the German Accident Atlas (Unfallatlas):
- Source: unfallatlas.statistikportal.de
- Filters for Bremen (ULAND=4)
- Years: 2019-2023

## Usage

Run all ingestion:
```bash
python -m scripts.ingest_all_data
```

## Data Sources

| Source | URL |
|--------|-----|
| OpenStreetMap | [overpass-api.de](https://overpass-api.de) |
| Unfallatlas | [unfallatlas.statistikportal.de](https://unfallatlas.statistikportal.de) |
