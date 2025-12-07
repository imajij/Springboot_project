# Ride Sharing API

A complete Spring Boot REST API for a ride-sharing application with JWT authentication, role-based access control, and comprehensive ride management features.

## Features

- ✅ User Registration and Authentication with JWT
- ✅ Role-based Access Control (USER and DRIVER roles)
- ✅ Secure password encryption using BCrypt
- ✅ Ride creation, acceptance, and completion workflow
- ✅ Input validation using Jakarta Bean Validation
- ✅ Global exception handling
- ✅ H2 in-memory database for development
- ✅ RESTful API design

## Technologies Used

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Security** with JWT
- **Spring Data JPA**
- **H2 Database**
- **Maven**
- **Lombok**
- **JJWT (JSON Web Token)**

## Project Structure

```
src/main/java/com/rideshare/
├── controller/          # REST API endpoints
│   ├── AuthController.java
│   └── RideController.java
├── service/            # Business logic layer
│   ├── AuthService.java
│   └── RideService.java
├── repository/         # Data access layer
│   ├── UserRepository.java
│   └── RideRepository.java
├── entity/            # JPA entities
│   ├── User.java
│   └── Ride.java
├── dto/               # Data Transfer Objects
│   ├── RegisterRequest.java
│   ├── LoginRequest.java
│   ├── AuthResponse.java
│   ├── CreateRideRequest.java
│   └── RideResponse.java
├── security/          # Security configuration
│   ├── JwtUtil.java
│   ├── JwtAuthenticationFilter.java
│   ├── CustomUserDetailsService.java
│   └── SecurityConfig.java
├── exception/         # Exception handling
│   ├── GlobalExceptionHandler.java
│   ├── NotFoundException.java
│   ├── BadRequestException.java
│   ├── UnauthorizedException.java
│   └── ErrorResponse.java
└── RideShareApplication.java  # Main application class
```

## Getting Started

### Prerequisites

- Java 17 or higher
- Maven 3.6+

### Installation

1. Clone the repository:
```bash
cd /home/ajij/Desktop/Springboot_project
```

2. Build the project:
```bash
mvn clean install
```

3. Run the application:
```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8081`

### H2 Console

Access the H2 database console at: `http://localhost:8081/h2-console`
- JDBC URL: `jdbc:h2:mem:ridesharedb`
- Username: `sa`
- Password: (leave empty)

## API Endpoints

### Authentication Endpoints (Public)

#### 1. Register User
```bash
POST /api/auth/register
Content-Type: application/json

{
  "username": "john",
  "password": "1234",
  "role": "ROLE_USER"
}
```

#### 2. Register Driver
```bash
POST /api/auth/register
Content-Type: application/json

{
  "username": "driver1",
  "password": "abcd",
  "role": "ROLE_DRIVER"
}
```

#### 3. Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "username": "john",
  "password": "1234"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "john",
  "role": "ROLE_USER",
  "message": "Login successful"
}
```

### Ride Endpoints (Protected)

**Note:** All ride endpoints require JWT token in Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

#### 4. Request a Ride (USER only)
```bash
POST /api/v1/rides
Authorization: Bearer <token>
Content-Type: application/json

{
  "pickupLocation": "Koramangala",
  "dropLocation": "Indiranagar"
}
```

#### 5. Get User's Own Rides (USER only)
```bash
GET /api/v1/user/rides
Authorization: Bearer <token>
```

#### 6. View Pending Ride Requests (DRIVER only)
```bash
GET /api/v1/driver/rides/requests
Authorization: Bearer <token>
```

#### 7. Accept a Ride (DRIVER only)
```bash
POST /api/v1/driver/rides/{rideId}/accept
Authorization: Bearer <token>
```

#### 8. Complete a Ride (USER or DRIVER)
```bash
POST /api/v1/rides/{rideId}/complete
Authorization: Bearer <token>
```

## Testing with CURL

### 1. Register a User
```bash
curl -X POST http://localhost:8081/api/auth/register \
-H "Content-Type: application/json" \
-d '{"username":"john","password":"1234","role":"ROLE_USER"}'
```

### 2. Register a Driver
```bash
curl -X POST http://localhost:8081/api/auth/register \
-H "Content-Type: application/json" \
-d '{"username":"driver1","password":"abcd","role":"ROLE_DRIVER"}'
```

### 3. Login
```bash
curl -X POST http://localhost:8081/api/auth/login \
-H "Content-Type: application/json" \
-d '{"username":"john","password":"1234"}'
```

### 4. Create a Ride (replace <token> with actual JWT)
```bash
curl -X POST http://localhost:8081/api/v1/rides \
-H "Authorization: Bearer <token>" \
-H "Content-Type: application/json" \
-d '{"pickupLocation":"Koramangala","dropLocation":"Indiranagar"}'
```

### 5. View Pending Rides (as Driver)
```bash
curl -X GET http://localhost:8081/api/v1/driver/rides/requests \
-H "Authorization: Bearer <driver-token>"
```

### 6. Accept a Ride (as Driver)
```bash
curl -X POST http://localhost:8081/api/v1/driver/rides/1/accept \
-H "Authorization: Bearer <driver-token>"
```

### 7. Complete a Ride
```bash
curl -X POST http://localhost:8081/api/v1/rides/1/complete \
-H "Authorization: Bearer <token>"
```

## Ride Status Flow

1. **REQUESTED** - User creates a ride request
2. **ACCEPTED** - Driver accepts the ride
3. **COMPLETED** - User or Driver completes the ride

## Validation Rules

### Registration
- Username: 3-50 characters, required, must be unique
- Password: minimum 4 characters, required
- Role: must be "ROLE_USER" or "ROLE_DRIVER"

### Create Ride
- Pickup Location: minimum 3 characters, required
- Drop Location: minimum 3 characters, required

## Error Responses

All errors return a standardized JSON response:

```json
{
  "error": "ERROR_CODE",
  "message": "Human readable error message",
  "timestamp": "2025-12-07T12:00:00"
}
```

### Error Codes
- `VALIDATION_ERROR` - Input validation failed
- `NOT_FOUND` - Resource not found
- `BAD_REQUEST` - Invalid request
- `UNAUTHORIZED` - Authentication failed
- `ACCESS_DENIED` - Insufficient permissions
- `AUTHENTICATION_FAILED` - Invalid credentials
- `INTERNAL_SERVER_ERROR` - Server error

## Security Features

- Passwords are encrypted using BCrypt
- JWT tokens expire after 24 hours
- Role-based access control using Spring Security
- Stateless authentication (no sessions)
- CSRF protection disabled for REST API

## Database Schema

### Users Table
- id (Long, Primary Key)
- username (String, Unique)
- password (String, Encrypted)
- role (Enum: ROLE_USER, ROLE_DRIVER)

### Rides Table
- id (Long, Primary Key)
- pickupLocation (String)
- dropLocation (String)
- status (Enum: REQUESTED, ACCEPTED, COMPLETED)
- userId (Long, Foreign Key)
- driverId (Long, Foreign Key, Nullable)
- createdAt (LocalDateTime)
- updatedAt (LocalDateTime)

## Configuration

Edit `src/main/resources/application.properties` to customize:
- Server port
- Database settings
- JWT secret and expiration
- Logging levels

## Future Enhancements

- Add ride rating and reviews
- Implement real-time location tracking
- Add payment integration
- Driver availability status
- Ride history and analytics
- Push notifications
- Admin dashboard

## License

This project is created for educational purposes.

## Author

Ride Sharing API - Spring Boot Project
