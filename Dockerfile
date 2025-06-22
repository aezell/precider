FROM elixir:1.18.4-alpine

# Install build dependencies
RUN apk add --no-cache build-base npm git python3

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy source
COPY . .

# Compile
RUN mix compile

# Build assets (if you have them)
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
# RUN npm run --prefix ./assets deploy
# RUN mix phx.digest

CMD ["mix", "phx.server"]