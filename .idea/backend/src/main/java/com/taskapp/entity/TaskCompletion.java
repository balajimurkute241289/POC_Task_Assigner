package com.taskapp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "task_completions")
@EntityListeners(AuditingEntityListener.class)
public class TaskCompletion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "task_id", nullable = false)
    private Task task;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotNull(message = "GPS latitude is required")
    @Column(name = "gps_latitude", nullable = false)
    private Double gpsLatitude;

    @NotNull(message = "GPS longitude is required")
    @Column(name = "gps_longitude", nullable = false)
    private Double gpsLongitude;

    @Column(name = "distance_from_target")
    private Double distanceFromTarget; // Distance in meters from task location

    @Column(name = "completion_verified")
    private boolean completionVerified = false;

    @CreatedDate
    @Column(name = "completed_at", nullable = false, updatable = false)
    private LocalDateTime completedAt;

    @Column(name = "verification_notes")
    private String verificationNotes;

    // Constructors
    public TaskCompletion() {}

    public TaskCompletion(Task task, User user, Double gpsLatitude, Double gpsLongitude) {
        this.task = task;
        this.user = user;
        this.gpsLatitude = gpsLatitude;
        this.gpsLongitude = gpsLongitude;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Double getGpsLatitude() {
        return gpsLatitude;
    }

    public void setGpsLatitude(Double gpsLatitude) {
        this.gpsLatitude = gpsLatitude;
    }

    public Double getGpsLongitude() {
        return gpsLongitude;
    }

    public void setGpsLongitude(Double gpsLongitude) {
        this.gpsLongitude = gpsLongitude;
    }

    public Double getDistanceFromTarget() {
        return distanceFromTarget;
    }

    public void setDistanceFromTarget(Double distanceFromTarget) {
        this.distanceFromTarget = distanceFromTarget;
    }

    public boolean isCompletionVerified() {
        return completionVerified;
    }

    public void setCompletionVerified(boolean completionVerified) {
        this.completionVerified = completionVerified;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public String getVerificationNotes() {
        return verificationNotes;
    }

    public void setVerificationNotes(String verificationNotes) {
        this.verificationNotes = verificationNotes;
    }

    // Helper methods
    public boolean isWithinRadius() {
        return distanceFromTarget != null && distanceFromTarget <= task.getCompletionRadius();
    }

    @Override
    public String toString() {
        return "TaskCompletion{" +
                "id=" + id +
                ", task=" + (task != null ? task.getTitle() : "null") +
                ", user=" + (user != null ? user.getUsername() : "null") +
                ", gpsLatitude=" + gpsLatitude +
                ", gpsLongitude=" + gpsLongitude +
                ", distanceFromTarget=" + distanceFromTarget +
                ", completionVerified=" + completionVerified +
                ", completedAt=" + completedAt +
                ", verificationNotes='" + verificationNotes + '\'' +
                '}';
    }
}
