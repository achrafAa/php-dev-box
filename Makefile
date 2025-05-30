# Variables
CONTAINER_NAME = php-dev-box

# Container management commands
# Start the container
up:
	docker compose up -d

# Stop the container
down:
	docker compose down

# Pull the latest image and start the container
pull:
	docker compose pull
	docker compose up -d

# Run a shell inside the container
shell:
	docker compose exec $(CONTAINER_NAME) bash

# Restart the container
restart:
	docker compose restart

# Show container logs
logs:
	docker compose logs -f $(CONTAINER_NAME)

# PHP Development commands (phpdev)
# Show help and available targets
help:
	docker compose exec $(CONTAINER_NAME) phpdev help

# Show environment information
info:
	docker compose exec $(CONTAINER_NAME) phpdev info

# Create a new extension skeleton (usage: make create EXT=myext)
create:
	@if [ -z "$(EXT)" ]; then \
		echo "Usage: make create EXT=extension_name"; \
		echo "Example: make create EXT=myext"; \
		exit 1; \
	fi
	docker compose exec $(CONTAINER_NAME) phpdev create EXT=$(EXT)

# Build extension in current directory
build:
	docker compose exec $(CONTAINER_NAME) phpdev build

# Run extension tests
test:
	docker compose exec $(CONTAINER_NAME) phpdev test

# Install built extension
install:
	docker compose exec $(CONTAINER_NAME) phpdev install

# Clean build artifacts
clean:
	docker compose exec $(CONTAINER_NAME) phpdev clean

# Start GDB debugging session
debug:
	docker compose exec $(CONTAINER_NAME) phpdev debug

# Basic code linting
lint:
	docker compose exec $(CONTAINER_NAME) phpdev lint

# Memory debugging with Valgrind
valgrind:
	docker compose exec $(CONTAINER_NAME) phpdev valgrind

# Advanced commands
# Use the development Makefile directly
dev-help:
	docker compose exec $(CONTAINER_NAME) make -f /usr/local/bin/Makefile.php-dev help

# Create extension using development Makefile (usage: make dev-create EXT=myext)
dev-create:
	@if [ -z "$(EXT)" ]; then \
		echo "Usage: make dev-create EXT=extension_name"; \
		echo "Example: make dev-create EXT=myext"; \
		exit 1; \
	fi
	docker compose exec $(CONTAINER_NAME) make -f /usr/local/bin/Makefile.php-dev create EXT=$(EXT)

# Build using development Makefile
dev-build:
	docker compose exec $(CONTAINER_NAME) make -f /usr/local/bin/Makefile.php-dev build

# PHP Core Development commands
# Navigate to PHP source directory and start shell
php-src:
	docker compose exec $(CONTAINER_NAME) bash -c "cd /usr/src/php/src/php-src && bash"

# Clean PHP core build
php-clean:
	docker compose exec $(CONTAINER_NAME) bash -c "cd /usr/src/php/src/php-src && make clean"

# Build PHP core (with debug symbols)
php-build:
	docker compose exec $(CONTAINER_NAME) bash -c "cd /usr/src/php/src/php-src && make -j$$(nproc)"

# Run PHP core tests
php-test:
	docker compose exec $(CONTAINER_NAME) bash -c "cd /usr/src/php/src/php-src && make test"

# Show all available commands
list:
	@echo "=== Container Management ==="
	@echo "  up          - Start the container"
	@echo "  down        - Stop the container"
	@echo "  pull        - Pull latest image and start"
	@echo "  shell       - Access container shell"
	@echo "  restart     - Restart the container"
	@echo "  logs        - Show container logs"
	@echo ""
	@echo "=== PHP Extension Development ==="
	@echo "  help        - Show phpdev help"
	@echo "  info        - Show environment info"
	@echo "  create      - Create extension (make create EXT=name)"
	@echo "  build       - Build extension"
	@echo "  test        - Run extension tests"
	@echo "  install     - Install extension"
	@echo "  clean       - Clean build artifacts"
	@echo "  debug       - Start GDB debugging"
	@echo "  lint        - Run code linting"
	@echo "  valgrind    - Memory debugging with Valgrind"
	@echo ""
	@echo "=== Advanced Development ==="
	@echo "  dev-help    - Development Makefile help"
	@echo "  dev-create  - Create extension with dev Makefile"
	@echo "  dev-build   - Build with dev Makefile"
	@echo ""
	@echo "=== PHP Core Development ==="
	@echo "  php-src     - Navigate to PHP source and start shell"
	@echo "  php-clean   - Clean PHP core build"
	@echo "  php-build   - Build PHP core"
	@echo "  php-test    - Run PHP core tests"
	@echo ""
	@echo "  list        - Show this help"
