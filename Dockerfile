# Step 1: Use a base image with system dependencies
FROM debian:bullseye-slim AS build

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl unzip git xz-utils ca-certificates

# Set Flutter version
ARG FLUTTER_VERSION=3.27.3
ENV FLUTTER_HOME=/flutter

# Download and extract Flutter
RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    && mkdir -p $FLUTTER_HOME \
    && tar -xf flutter.tar.xz -C $FLUTTER_HOME --strip-components=1 \
    && rm flutter.tar.xz

# Add Flutter to PATH and verify installation
ENV PATH="$FLUTTER_HOME/bin:$PATH"
RUN flutter --version

# Fix git safe directory issue
RUN git config --global --add safe.directory $FLUTTER_HOME

# Enable Flutter Web
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Fix permission issues
RUN chown -R root:root /app

# Get dependencies
RUN flutter --version && flutter pub get

# Build the Flutter web app
RUN flutter build web

# Step 2: Use NGINX to serve the built app
FROM nginx:alpine

# Copy built web files from the build stage
COPY --from=build /app/build/web/ /usr/share/nginx/html/
COPY .env /usr/share/nginx/html/.env

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
