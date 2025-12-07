## 📁 Project Structure

```
Springboot_project/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── rideshare/
│   │   │           ├── RideShareApplication.java        # Main application class
│   │   │           ├── controller/                      # REST API Controllers
│   │   │           │   ├── AuthController.java         # Authentication endpoints
│   │   │           │   └── RideController.java         # Ride management endpoints
│   │   │           ├── service/                        # Business logic layer
│   │   │           │   ├── AuthService.java            # Authentication service
│   │   │           │   └── RideService.java            # Ride management service
│   │   │           ├── repository/                     # Data access layer
│   │   │           │   ├── UserRepository.java         # User database operations
│   │   │           │   └── RideRepository.java         # Ride database operations
│   │   │           ├── entity/                         # JPA entities
│   │   │           │   ├── User.java                   # User entity
│   │   │           │   └── Ride.java                   # Ride entity
│   │   │           ├── dto/                           # Data Transfer Objects
│   │   │           │   ├── RegisterRequest.java        # Registration request DTO
│   │   │           │   ├── LoginRequest.java           # Login request DTO
│   │   │           │   ├── AuthResponse.java           # Authentication response DTO
│   │   │           │   ├── CreateRideRequest.java      # Create ride request DTO
│   │   │           │   └── RideResponse.java           # Ride response DTO
│   │   │           ├── security/                       # Security configuration
│   │   │           │   ├── JwtUtil.java                # JWT utility class
│   │   │           │   ├── JwtAuthenticationFilter.java # JWT filter
│   │   │           │   ├── CustomUserDetailsService.java # User details service
│   │   │           │   └── SecurityConfig.java         # Security configuration
│   │   │           └── exception/                      # Exception handling
│   │   │               ├── GlobalExceptionHandler.java  # Global exception handler
│   │   │               ├── NotFoundException.java       # Custom exception
│   │   │               ├── BadRequestException.java     # Custom exception
│   │   │               ├── UnauthorizedException.java   # Custom exception
│   │   │               └── ErrorResponse.java           # Error response DTO
│   │   └── resources/
│   │       └── application.properties                   # Application configuration
│   └── test/
│       └── java/                                        # Test classes (optional)
├── target/                                              # Compiled files (generated)
├── pom.xml                                              # Maven configuration
├── README.md                                            # Project documentation
├── test-api.sh                                          # API test script
└── .gitignore                                           # Git ignore file (optional)
```

## 🔍 Component Descriptions

### Controllers
- **AuthController**: Handles registration and login endpoints
- **RideController**: Manages all ride-related operations

### Services
- **AuthService**: Business logic for authentication and authorization
- **RideService**: Business logic for ride management

### Repositories
- **UserRepository**: JPA repository for User entity
- **RideRepository**: JPA repository for Ride entity with custom query methods

### Entities
- **User**: Represents users and drivers with roles
- **Ride**: Represents ride requests with status tracking

### DTOs
- Request DTOs with Jakarta validation annotations
- Response DTOs for clean API responses

### Security
- **JwtUtil**: Token generation and validation
- **JwtAuthenticationFilter**: Intercepts and validates JWT tokens
- **CustomUserDetailsService**: Loads user details for authentication
- **SecurityConfig**: Configures Spring Security and JWT

### Exception Handling
- Global exception handler for consistent error responses
- Custom exceptions for different error scenarios
- Standardized error response format

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL CHECK (role IN ('ROLE_USER', 'ROLE_DRIVER'))
);
```

### Rides Table
```sql
CREATE TABLE rides (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    pickup_location VARCHAR(255) NOT NULL,
    drop_location VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL CHECK (status IN ('REQUESTED', 'ACCEPTED', 'COMPLETED')),
    user_id BIGINT NOT NULL,
    driver_id BIGINT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);
```

## 🔐 Security Flow

```
1. User/Driver Registration
   ↓
2. Password hashed with BCrypt
   ↓
3. User stored in database
   ↓
4. JWT token generated and returned

1. User/Driver Login
   ↓
2. Credentials validated
   ↓
3. JWT token generated with username and role
   ↓
4. Token returned to client

1. API Request with JWT
   ↓
2. JwtAuthenticationFilter intercepts
   ↓
3. Token validated and user authenticated
   ↓
4. Request processed with user context
   ↓
5. Response returned
```

## 🚀 Ride Flow

```
1. USER creates ride request (status: REQUESTED)
   ↓
2. DRIVER views pending rides
   ↓
3. DRIVER accepts ride (status: ACCEPTED)
   ↓
4. USER or DRIVER completes ride (status: COMPLETED)
```

## 📝 API Response Format

### Success Response
```json
{
  "id": 1,
  "pickupLocation": "Koramangala",
  "dropLocation": "Indiranagar",
  "status": "REQUESTED",
  "userId": 1,
  "driverId": null,
  "createdAt": "2025-12-07T10:30:00",
  "updatedAt": "2025-12-07T10:30:00"
}
```

### Error Response
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Pickup location is required",
  "timestamp": "2025-12-07T10:30:00"
}
```

## 🎯 Key Features Implemented

✅ JWT Authentication & Authorization
✅ Role-based Access Control (USER/DRIVER)
✅ BCrypt Password Encryption
✅ Input Validation with Jakarta Bean Validation
✅ Global Exception Handling
✅ RESTful API Design
✅ JPA/Hibernate ORM
✅ H2 In-Memory Database
✅ Swagger-ready API structure
✅ Stateless Authentication
✅ CORS Configuration
✅ Ride Status Management
✅ Comprehensive Error Handling
