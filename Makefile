# Variables
CONTAINER_NAME = php-build-container

# Start the container
up:
	docker compose up -d

# Stop the container
down:
	docker compose down

# Build the container
build:
	docker compose build
	docker compose up -d

# Run a shell inside the container
shell:
	docker compose exec $(CONTAINER_NAME) bash
