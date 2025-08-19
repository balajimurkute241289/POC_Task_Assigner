# Multi-stage build for Spring Boot application
FROM gradle:8.5-jdk17 AS build

# Set working directory
WORKDIR /app

# Copy gradle files first for better caching
COPY gradle gradle
COPY build.gradle settings.gradle gradlew ./
COPY gradlew.bat ./

# Download dependencies
RUN gradle dependencies --no-daemon

# Copy source code
COPY src ./src

# Build the application
RUN gradle build --no-daemon -x test

# Runtime stage
FROM openjdk:17-jre-slim

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create app user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Create logs directory
RUN mkdir -p /app/logs && chown -R appuser:appuser /app

# Switch to app user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/api/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
