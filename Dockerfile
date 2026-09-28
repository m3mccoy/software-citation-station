# --- STAGE 1: Build & Dependency Installation ---
FROM node:22-alpine AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy dependency manifests first to leverage Docker layer caching
COPY package*.json ./

# Install all dependencies (including devDependencies if needed for builds)
RUN npm ci

# Copy the rest of the application source files
COPY . .

# --- STAGE 2: Optimized Production Runtime ---
FROM node:22-alpine AS production

# Set production environment flag for framework performance optimizations
ENV NODE_ENV=production

WORKDIR /usr/src/app

# Copy package manifests to track runtime layout
COPY package*.json ./

# Install only strict production dependencies 
RUN npm ci --omit=dev


# Copy application code (including your server.js) from the build stage
COPY --from=build /usr/src/app/server.js ./server.js
COPY . .
# Note: If you have extra source directories (e.g., /src, /public), copy them here:
# COPY --from=build /usr/src/app/src ./src

# Use the built-in, unprivileged 'node' user for enhanced runtime security
USER node

# Document the container runtime port (match this to your server.js configuration)
EXPOSE 3000

# Execute server.js directly using array syntax to properly handle system signals (SIGTERM)
CMD ["node", "server.js"]
