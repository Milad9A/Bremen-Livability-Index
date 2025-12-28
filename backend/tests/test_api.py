#!/usr/bin/env python3
"""Simple test script for the Bremen Livability Index API."""
import requests
import json
import sys
from typing import Dict, Any


BASE_URL = "http://localhost:8000"


def print_response(title: str, response: requests.Response):
    """Print formatted API response."""
    print(f"\n{'='*60}")
    print(f"{title}")
    print(f"{'='*60}")
    print(f"Status Code: {response.status_code}")
    
    try:
        data = response.json()
        print(f"Response:\n{json.dumps(data, indent=2)}")
    except:
        print(f"Response: {response.text}")
    
    print()


def test_health_check():
    """Test the health check endpoint."""
    print("Testing Health Check...")
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        print_response("Health Check", response)
        return response.status_code == 200
    except requests.exceptions.ConnectionError:
        print("❌ ERROR: Could not connect to API. Is the server running?")
        print(f"   Try: python main.py")
        return False
    except Exception as e:
        print(f"❌ ERROR: {e}")
        return False


def test_root_endpoint():
    """Test the root endpoint."""
    print("Testing Root Endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/", timeout=5)
        print_response("Root Endpoint", response)
        return response.status_code == 200
    except Exception as e:
        print(f"❌ ERROR: {e}")
        return False


def test_analyze_location(lat: float, lon: float, description: str = ""):
    """Test the analyze endpoint with given coordinates."""
    print(f"Testing Analyze Location: {lat}, {lon} {description}")
    try:
        payload = {
            "latitude": lat,
            "longitude": lon
        }
        response = requests.post(
            f"{BASE_URL}/analyze",
            json=payload,
            timeout=30
        )
        print_response(f"Analyze Location {description}", response)
        
        if response.status_code == 200:
            data = response.json()
            score = data.get("score", 0)
            summary = data.get("summary", "")
            factors = data.get("factors", [])
            
            # Color code the score
            if score >= 70:
                score_color = "🟢"
            elif score >= 50:
                score_color = "🟠"
            else:
                score_color = "🔴"
            
            print(f"   {score_color} Score: {score}/100")
            print(f"   Summary: {summary}")
            print(f"   Factors: {len(factors)}")
            for factor in factors:
                impact_icon = "➕" if factor.get("impact") == "positive" else "➖"
                print(f"      {impact_icon} {factor.get('factor')}: {factor.get('value')} - {factor.get('description')}")
        
        return response.status_code == 200
    except Exception as e:
        print(f"❌ ERROR: {e}")
        return False


def main():
    """Run all API tests."""
    print("\n" + "="*60)
    print("Bremen Livability Index API Test Suite")
    print("="*60)
    
    # Test 1: Health Check
    if not test_health_check():
        print("\n❌ Health check failed. Please check:")
        print("   1. Is the backend server running? (python main.py)")
        print("   2. Is the database running? (docker-compose up -d)")
        print("   3. Is the database connection configured correctly?")
        sys.exit(1)
    
    # Test 2: Root Endpoint
    test_root_endpoint()
    
    # Test 3: Analyze different locations
    test_locations = [
        (53.0793, 8.8017, "(Bremen City Center - Marktplatz)"),
        (53.1076, 8.8511, "(University of Bremen)"),
        (53.0474, 8.7867, "(Bremen Airport Area)"),
    ]
    
    print("\n" + "="*60)
    print("Testing Location Analysis")
    print("="*60)
    
    all_passed = True
    for lat, lon, desc in test_locations:
        if not test_analyze_location(lat, lon, desc):
            all_passed = False
    
    # Summary
    print("\n" + "="*60)
    if all_passed:
        print("✅ All tests passed!")
    else:
        print("❌ Some tests failed. Check the output above.")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()

