#!/bin/bash

# Ride Sharing API Test Script
# This script tests all API endpoints

BASE_URL="http://localhost:8081"

echo "========================================="
echo "   Ride Sharing API Testing Script"
echo "========================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0

# Function to test endpoints
test_endpoint() {
    local test_name=$1
    local response=$2
    local expected_status=$3
    
    echo -n "Testing: $test_name..."
    
    if echo "$response" | grep -q "$expected_status"; then
        echo -e " ${GREEN}✓ PASSED${NC}"
        ((PASSED++))
    else
        echo -e " ${RED}✗ FAILED${NC}"
        ((FAILED++))
    fi
}

echo "1. Registering USER..."
echo "========================================"
USER_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "password123",
    "role": "ROLE_USER"
  }')
echo "$USER_RESPONSE"
USER_TOKEN=$(echo "$USER_RESPONSE" | jq -r '.token' 2>/dev/null)
test_endpoint "User Registration" "$USER_RESPONSE" "201"
echo ""

echo "2. Registering DRIVER..."
echo "========================================"
DRIVER_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "driver_smith",
    "password": "driver123",
    "role": "ROLE_DRIVER"
  }')
echo "$DRIVER_RESPONSE"
DRIVER_TOKEN=$(echo "$DRIVER_RESPONSE" | jq -r '.token' 2>/dev/null)
test_endpoint "Driver Registration" "$DRIVER_RESPONSE" "201"
echo ""

echo "3. User Login..."
echo "========================================"
LOGIN_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "password123"
  }')
echo "$LOGIN_RESPONSE"
USER_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token' 2>/dev/null)
test_endpoint "User Login" "$LOGIN_RESPONSE" "200"
echo ""

echo "4. Creating a Ride Request (as USER)..."
echo "========================================"
RIDE_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/v1/rides \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "pickupLocation": "Koramangala",
    "dropLocation": "Indiranagar"
  }')
echo "$RIDE_RESPONSE"
RIDE_ID=$(echo "$RIDE_RESPONSE" | jq -r '.id' 2>/dev/null)
test_endpoint "Create Ride Request" "$RIDE_RESPONSE" "201"
echo ""

echo "5. Getting User's Rides..."
echo "========================================"
USER_RIDES=$(curl -s -w "\n%{http_code}" -X GET ${BASE_URL}/api/v1/user/rides \
  -H "Authorization: Bearer ${USER_TOKEN}")
echo "$USER_RIDES"
test_endpoint "Get User Rides" "$USER_RIDES" "200"
echo ""

echo "6. Driver Login..."
echo "========================================"
DRIVER_LOGIN=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "driver_smith",
    "password": "driver123"
  }')
echo "$DRIVER_LOGIN"
DRIVER_TOKEN=$(echo "$DRIVER_LOGIN" | jq -r '.token' 2>/dev/null)
test_endpoint "Driver Login" "$DRIVER_LOGIN" "200"
echo ""

echo "7. Driver Views Pending Ride Requests..."
echo "========================================"
PENDING_RIDES=$(curl -s -w "\n%{http_code}" -X GET ${BASE_URL}/api/v1/driver/rides/requests \
  -H "Authorization: Bearer ${DRIVER_TOKEN}")
echo "$PENDING_RIDES"
test_endpoint "Get Pending Rides" "$PENDING_RIDES" "200"
echo ""

echo "8. Driver Accepts the Ride..."
echo "========================================"
ACCEPT_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/v1/driver/rides/${RIDE_ID}/accept \
  -H "Authorization: Bearer ${DRIVER_TOKEN}")
echo "$ACCEPT_RESPONSE"
test_endpoint "Accept Ride" "$ACCEPT_RESPONSE" "200"
echo ""

echo "9. Completing the Ride..."
echo "========================================"
COMPLETE_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/v1/rides/${RIDE_ID}/complete \
  -H "Authorization: Bearer ${DRIVER_TOKEN}")
echo "$COMPLETE_RESPONSE"
test_endpoint "Complete Ride" "$COMPLETE_RESPONSE" "200"
echo ""

echo "10. Testing Validation Error..."
echo "========================================"
VALIDATION_ERROR=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "ab",
    "password": "1",
    "role": "ROLE_USER"
  }')
echo "$VALIDATION_ERROR"
test_endpoint "Validation Error Handling" "$VALIDATION_ERROR" "400"
echo ""

echo "11. Testing Duplicate Username..."
echo "========================================"
DUPLICATE_ERROR=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "password123",
    "role": "ROLE_USER"
  }')
echo "$DUPLICATE_ERROR"
test_endpoint "Duplicate Username Handling" "$DUPLICATE_ERROR" "400"
echo ""

echo "12. Testing Unauthorized Access..."
echo "========================================"
UNAUTHORIZED=$(curl -s -w "\n%{http_code}" -X GET ${BASE_URL}/api/v1/rides \
  -H "Authorization: Bearer invalid_token")
echo "$UNAUTHORIZED"
test_endpoint "Unauthorized Access Handling" "$UNAUTHORIZED" "403"
echo ""

echo ""
echo "========================================="
echo "           Test Summary"
echo "========================================="
echo -e "Total Tests: $((PASSED + FAILED))"
echo -e "${GREEN}Passed: ${PASSED}${NC}"
echo -e "${RED}Failed: ${FAILED}${NC}"
echo "========================================="
