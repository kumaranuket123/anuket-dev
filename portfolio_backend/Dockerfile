# ── Build stage ───────────────────────────────────────────────────────────────
FROM dart:stable AS build

WORKDIR /app

# Resolve dependencies first (cached layer)
COPY portfolio_backend/pubspec.yaml portfolio_backend/pubspec.lock ./
RUN dart pub get

# Copy backend source
COPY portfolio_backend/lib ./lib

# Copy portfolio data (path relative to repo root build context)
COPY assets/data/portfolio_data.json ./portfolio_data.json

# Compile to a self-contained native binary
RUN dart compile exe lib/main.dart -o /app/server

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM debian:bookworm-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/server           /server
COPY --from=build /app/portfolio_data.json /portfolio_data.json

ENV DATA_PATH=/portfolio_data.json
ENV PORT=8080

EXPOSE 8080

CMD ["/server"]
