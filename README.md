# PHP Development Environment

A flexible Docker-based PHP development environment that allows you to:
- Build and test different PHP versions from source
- Debug PHP core
- Develop and test PHP extensions
- Work in an isolated container environment

## Features

- Easily switch between different PHP versions by modifying the Dockerfile
- Complete build environment for PHP and extensions
- Containerized development to avoid system conflicts
- Makefile for common operations

## Setup

1. Clone this repository:
```bash
git clone [repository-url]
```

2. Select PHP version:
   - Open `Dockerfile`
   - Modify line 35 to specify your desired PHP version
   ```dockerfile
    git checkout PHP-8.4.4 && \  # Change this to your target version
   ```

## Usage

The project includes a Makefile with the following commands:

- `make build`: Build the Docker container with specified PHP version
- `make up`: Start the development environment
- `make shell`: Access the container shell
- `make stop`: Stop the running container
- `make down`: Remove containers and built images

### Example Usage

```bash
# Build environment with current PHP version
make build

# Start the environment
make up

# Access shell for development
make shell

# Stop the environment
make stop
```

## Debugging PHP

The environment includes necessary tools for debugging PHP core and extensions:

- GDB is pre-installed
- Debug symbols are available
- Core dumps are enabled

## Notes

- All changes to PHP source are isolated within the container
- The environment provides a clean, reproducible development setup
- Perfect for testing PHP builds and extensions across different versions

## Contributing

Feel free to submit issues and pull requests to improve this development environment.

## License

MIT Licence
