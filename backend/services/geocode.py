"""Geocoding service using Nominatim (OpenStreetMap) API."""
import aiohttp
from typing import List, Optional
from urllib.parse import urlencode


class GeocodeService:
    """Service for geocoding addresses using Nominatim."""
    
    NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
    USER_AGENT = "BremenLivabilityIndex/1.0"
    
    @staticmethod
    async def geocode_address(query: str, limit: int = 5) -> List[dict]:
        """
        Geocode an address query and return results.
        
        Args:
            query: Address search query
            limit: Maximum number of results to return
            
        Returns:
            List of geocoded results with coordinates and formatted addresses
        """
        search_query = f"{query}, Bremen, Germany" if "Bremen" not in query else query
        
        params = {
            "q": search_query,
            "format": "json",
            "limit": limit,
            "addressdetails": 1,
            "bounded": 0,
            "viewbox": "8.481,53.227,8.993,52.959",  # Bremen bounding box (lon_min, lat_max, lon_max, lat_min)
        }
        
        headers = {
            "User-Agent": GeocodeService.USER_AGENT
        }
        
        async with aiohttp.ClientSession() as session:
            url = f"{GeocodeService.NOMINATIM_URL}?{urlencode(params)}"
            async with session.get(url, headers=headers) as response:
                if response.status == 200:
                    results = await response.json()
                    return [
                        {
                            "latitude": float(result["lat"]),
                            "longitude": float(result["lon"]),
                            "display_name": result["display_name"],
                            "address": result.get("address", {}),
                            "type": result.get("type", ""),
                            "importance": result.get("importance", 0.0)
                        }
                        for result in results
                    ]
                else:
                    raise Exception(f"Geocoding failed with status {response.status}")
