#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but not installed." >&2
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "Docker Compose is required but not installed." >&2
  exit 1
fi

if ! "${COMPOSE_CMD[@]}" version >/dev/null 2>&1; then
  echo "Docker Compose is not available. Install Docker Compose and retry." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is not reachable. Start Docker Desktop or the Docker service and retry." >&2
  exit 1
fi

SERVICES=(
  "templates/docker-compose.promptfoo.yml"
  "templates/docker-compose.phoenix.yml"
)

for svc in "${SERVICES[@]}"; do
  if [[ ! -f "$svc" ]]; then
    echo "Missing compose file: $svc" >&2
    exit 1
  fi
done

"${COMPOSE_CMD[@]}" -f templates/docker-compose.promptfoo.yml up -d --build
"${COMPOSE_CMD[@]}" -f templates/docker-compose.phoenix.yml up -d --build

echo "Started ALLEval services."
echo "Promptfoo: http://localhost:3000"
echo "Phoenix: http://localhost:6006"
