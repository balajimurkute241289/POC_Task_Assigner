package com.taskapp.service;

import com.taskapp.entity.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * Service for JWT token operations including generation, validation, and extraction.
 */
@Service
public class JwtService {

    private static final Logger logger = LoggerFactory.getLogger(JwtService.class);

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private Long expiration;

    @Value("${jwt.refresh-expiration}")
    private Long refreshExpiration;

    /**
     * Generate a JWT token for a user.
     * 
     * @param user User to generate token for
     * @return JWT token string
     */
    public String generateToken(User user) {
        return generateToken(new HashMap<>(), user);
    }

    /**
     * Generate a JWT token with extra claims.
     * 
     * @param extraClaims Additional claims to include in the token
     * @param user User to generate token for
     * @return JWT token string
     */
    public String generateToken(Map<String, Object> extraClaims, User user) {
        return buildToken(extraClaims, user, expiration);
    }

    /**
     * Generate a refresh token for a user.
     * 
     * @param user User to generate refresh token for
     * @return Refresh token string
     */
    public String generateRefreshToken(User user) {
        return buildToken(new HashMap<>(), user, refreshExpiration);
    }

    /**
     * Build a JWT token with the specified claims and expiration.
     * 
     * @param extraClaims Additional claims
     * @param user User information
     * @param expiration Expiration time in milliseconds
     * @return JWT token string
     */
    private String buildToken(Map<String, Object> extraClaims, User user, long expiration) {
        return Jwts.builder()
                .setClaims(extraClaims)
                .setSubject(user.getUsername())
                .claim("userId", user.getId())
                .claim("role", user.getRole().name())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Extract username from JWT token.
     * 
     * @param token JWT token
     * @return Username
     */
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /**
     * Extract user ID from JWT token.
     * 
     * @param token JWT token
     * @return User ID
     */
    public Long extractUserId(String token) {
        final Claims claims = extractAllClaims(token);
        return claims.get("userId", Long.class);
    }

    /**
     * Extract user role from JWT token.
     * 
     * @param token JWT token
     * @return User role
     */
    public String extractUserRole(String token) {
        final Claims claims = extractAllClaims(token);
        return claims.get("role", String.class);
    }

    /**
     * Extract expiration date from JWT token.
     * 
     * @param token JWT token
     * @return Expiration date
     */
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /**
     * Extract a specific claim from JWT token.
     * 
     * @param token JWT token
     * @param claimsResolver Function to resolve the claim
     * @return Claim value
     */
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    /**
     * Extract all claims from JWT token.
     * 
     * @param token JWT token
     * @return All claims
     */
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * Get the signing key for JWT operations.
     * 
     * @return Secret key
     */
    private SecretKey getSigningKey() {
        byte[] keyBytes = secret.getBytes();
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Check if JWT token is expired.
     * 
     * @param token JWT token
     * @return true if expired, false otherwise
     */
    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    /**
     * Validate JWT token for a specific user.
     * 
     * @param token JWT token
     * @param userDetails User details to validate against
     * @return true if valid, false otherwise
     */
    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    /**
     * Validate JWT token without user details.
     * 
     * @param token JWT token
     * @return true if valid, false otherwise
     */
    public Boolean validateToken(String token) {
        try {
            return !isTokenExpired(token);
        } catch (JwtException | IllegalArgumentException e) {
            logger.warn("Invalid JWT token: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Check if token is a refresh token (longer expiration).
     * 
     * @param token JWT token
     * @return true if it's a refresh token, false otherwise
     */
    public Boolean isRefreshToken(String token) {
        try {
            Date expiration = extractExpiration(token);
            Date issuedAt = extractClaim(token, Claims::getIssuedAt);
            long tokenDuration = expiration.getTime() - issuedAt.getTime();
            return tokenDuration >= refreshExpiration;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Get time until token expires in milliseconds.
     * 
     * @param token JWT token
     * @return Time until expiration in milliseconds
     */
    public long getTimeUntilExpiration(String token) {
        try {
            Date expiration = extractExpiration(token);
            return expiration.getTime() - System.currentTimeMillis();
        } catch (Exception e) {
            return 0;
        }
    }
}
