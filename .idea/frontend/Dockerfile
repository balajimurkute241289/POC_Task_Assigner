# Multi-stage build for Flutter application
FROM ubuntu:20.04 AS build

# Set environment variables
ENV FLUTTER_VERSION=3.16.5
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME
RUN cd $FLUTTER_HOME && git checkout $FLUTTER_VERSION

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get Flutter dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build the application
RUN flutter build web --release

# Runtime stage
FROM nginx:alpine

# Copy built web app to nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
