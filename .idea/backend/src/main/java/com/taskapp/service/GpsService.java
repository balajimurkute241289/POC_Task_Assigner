package com.taskapp.service;

import org.springframework.stereotype.Service;

/**
 * Service for GPS-related calculations and validations.
 * Uses the Haversine formula to calculate distances between geographical coordinates.
 */
@Service
public class GpsService {

    private static final double EARTH_RADIUS = 6371000; // Earth's radius in meters

    /**
     * Calculate the distance between two geographical points using the Haversine formula.
     * 
     * @param lat1 Latitude of the first point
     * @param lon1 Longitude of the first point
     * @param lat2 Latitude of the second point
     * @param lon2 Longitude of the second point
     * @return Distance in meters
     */
    public double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        // Convert degrees to radians
        double lat1Rad = Math.toRadians(lat1);
        double lon1Rad = Math.toRadians(lon1);
        double lat2Rad = Math.toRadians(lat2);
        double lon2Rad = Math.toRadians(lon2);

        // Differences in coordinates
        double deltaLat = lat2Rad - lat1Rad;
        double deltaLon = lon2Rad - lon1Rad;

        // Haversine formula
        double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
                   Math.cos(lat1Rad) * Math.cos(lat2Rad) *
                   Math.sin(deltaLon / 2) * Math.sin(deltaLon / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return EARTH_RADIUS * c;
    }

    /**
     * Check if a user's GPS location is within the specified radius of a task location.
     * 
     * @param userLat User's latitude
     * @param userLon User's longitude
     * @param taskLat Task's latitude
     * @param taskLon Task's longitude
     * @param radius Radius in meters
     * @return true if user is within radius, false otherwise
     */
    public boolean isWithinRadius(double userLat, double userLon, double taskLat, double taskLon, double radius) {
        double distance = calculateDistance(userLat, userLon, taskLat, taskLon);
        return distance <= radius;
    }

    /**
     * Validate if the given coordinates are valid.
     * 
     * @param latitude Latitude to validate
     * @param longitude Longitude to validate
     * @return true if coordinates are valid, false otherwise
     */
    public boolean isValidCoordinates(double latitude, double longitude) {
        return latitude >= -90 && latitude <= 90 && 
               longitude >= -180 && longitude <= 180;
    }

    /**
     * Get a human-readable distance string.
     * 
     * @param distanceInMeters Distance in meters
     * @return Formatted distance string
     */
    public String getFormattedDistance(double distanceInMeters) {
        if (distanceInMeters < 1000) {
            return String.format("%.0f meters", distanceInMeters);
        } else {
            double kilometers = distanceInMeters / 1000;
            return String.format("%.2f kilometers", kilometers);
        }
    }

    /**
     * Calculate the bearing between two points.
     * 
     * @param lat1 Latitude of the first point
     * @param lon1 Longitude of the first point
     * @param lat2 Latitude of the second point
     * @param lon2 Longitude of the second point
     * @return Bearing in degrees (0-360)
     */
    public double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
        double lat1Rad = Math.toRadians(lat1);
        double lon1Rad = Math.toRadians(lon1);
        double lat2Rad = Math.toRadians(lat2);
        double lon2Rad = Math.toRadians(lon2);

        double deltaLon = lon2Rad - lon1Rad;

        double y = Math.sin(deltaLon) * Math.cos(lat2Rad);
        double x = Math.cos(lat1Rad) * Math.sin(lat2Rad) - 
                   Math.sin(lat1Rad) * Math.cos(lat2Rad) * Math.cos(deltaLon);

        double bearing = Math.toDegrees(Math.atan2(y, x));
        return (bearing + 360) % 360; // Normalize to 0-360
    }
}
