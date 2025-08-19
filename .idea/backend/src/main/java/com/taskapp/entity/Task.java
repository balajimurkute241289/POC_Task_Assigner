package com.taskapp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tasks")
@EntityListeners(AuditingEntityListener.class)
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Task title is required")
    @Size(min = 1, max = 200, message = "Task title must be between 1 and 200 characters")
    @Column(nullable = false)
    private String title;

    @NotBlank(message = "Task description is required")
    @Size(min = 1, max = 1000, message = "Task description must be between 1 and 1000 characters")
    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @NotNull(message = "Latitude is required")
    @Column(nullable = false)
    private Double latitude;

    @NotNull(message = "Longitude is required")
    @Column(nullable = false)
    private Double longitude;

    @Column(name = "completion_radius")
    private Double completionRadius = 100.0; // Default 100 meters

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TaskStatus status = TaskStatus.PENDING;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assigner_id", nullable = false)
    private User assigner;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assignee_id", nullable = false)
    private User assignee;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "task", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<TaskCompletion> completions = new ArrayList<>();

    // Constructors
    public Task() {}

    public Task(String title, String description, Double latitude, Double longitude, User assigner, User assignee) {
        this.title = title;
        this.description = description;
        this.latitude = latitude;
        this.longitude = longitude;
        this.assigner = assigner;
        this.assignee = assignee;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getCompletionRadius() {
        return completionRadius;
    }

    public void setCompletionRadius(Double completionRadius) {
        this.completionRadius = completionRadius;
    }

    public TaskStatus getStatus() {
        return status;
    }

    public void setStatus(TaskStatus status) {
        this.status = status;
    }

    public User getAssigner() {
        return assigner;
    }

    public void setAssigner(User assigner) {
        this.assigner = assigner;
    }

    public User getAssignee() {
        return assignee;
    }

    public void setAssignee(User assignee) {
        this.assignee = assignee;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<TaskCompletion> getCompletions() {
        return completions;
    }

    public void setCompletions(List<TaskCompletion> completions) {
        this.completions = completions;
    }

    // Helper methods
    public boolean isCompleted() {
        return TaskStatus.COMPLETED.equals(this.status);
    }

    public boolean isPending() {
        return TaskStatus.PENDING.equals(this.status);
    }

    public boolean isInProgress() {
        return TaskStatus.IN_PROGRESS.equals(this.status);
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", completionRadius=" + completionRadius +
                ", status=" + status +
                ", assigner=" + (assigner != null ? assigner.getUsername() : "null") +
                ", assignee=" + (assignee != null ? assignee.getUsername() : "null") +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
