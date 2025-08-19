package com.taskapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class MobileTaskBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(MobileTaskBackendApplication.class, args);
    }
}
