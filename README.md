# PHP Development Environment

A flexible Docker-based PHP development environment using the pre-built [aachraf/php-dev-box](https://hub.docker.com/r/aachraf/php-dev-box) image that allows you to:
- Work with a ready-to-use PHP development environment
- Debug PHP applications and extensions
- Develop PHP core and PHP extensions
- Focus on coding without environment setup overhead

## Features

- Uses the pre-built `aachraf/php-dev-box` Docker image
- Complete PHP development environment ready to use
- Containerized development to avoid system conflicts
- Working directory set to `/workdir` for organized project structure
- Makefile for common operations
- Pre-built with debug symbols and development tools
- Includes GDB, Valgrind, Zig compiler, and more

## Setup

1. Clone this repository:
```bash
git clone git@github.com:achrafAa/php-dev-box.git
cd php-dev-box
```

2. Start the development environment:
```bash
make up
```

## Usage

The project includes a Makefile with the following commands:

- `make up`: Start the development environment
- `make pull`: Pull the latest image and start the container
- `make shell`: Access the container shell
- `make down`: Stop and remove the container
- `make restart`: Restart the container
- `make logs`: Show container logs

### Example Usage

```bash
# Start the environment
make up

# Access shell for development (working directory is /workdir)
make shell

# Pull the latest image and restart
make pull

# Check container logs
make logs

# Stop the environment
make down
```

## Available Commands in Container

Once inside the container (via `make shell`), you have access to the `phpdev` command and various development tools.

### Primary Command: `phpdev`

The main command that provides access to all development tasks:

```bash
# Show help and available targets
phpdev help

# Show environment information
phpdev info

# Create a new extension skeleton
phpdev create EXT=myext

# Build extension in current directory
phpdev build

# Run extension tests
phpdev test

# Install built extension
phpdev install

# Clean build artifacts
phpdev clean

# Start GDB debugging session
phpdev debug

# Basic code linting
phpdev lint

# Memory debugging with Valgrind
phpdev valgrind
```

### Direct Commands via Makefile

You can also run commands directly from your host machine without entering the container:

```bash
# Extension development
make create EXT=myext    # Creates extension in /workdir/myext
make build              # Build extension
make test               # Run tests
make install            # Install extension

# Debugging
make debug              # Start GDB debugging
make valgrind           # Memory debugging

# Get help
make help               # Show phpdev help
make list               # Show all available make commands
```

### Makefile-Based Workflow

You can also use the Makefile directly for more control:

```bash
# Use the development Makefile directly
make -f /usr/local/bin/Makefile.php-dev help
make -f /usr/local/bin/Makefile.php-dev create EXT=myext
make -f /usr/local/bin/Makefile.php-dev build
```

## Development Workflows

### PHP Extension Development

#### 1. Create Extension Skeleton

```bash
# Using make command (from host)
make create EXT=myawesome

# Or access the container directly
make shell
phpdev create EXT=myawesome
cd myawesome
```

This creates a new extension in `/workdir/myawesome` with the following structure:
```
/workdir/myawesome/
├── myawesome.c
├── php_myawesome.h
├── config.m4
└── tests/
```

#### 2. Develop Your Extension

```bash
# Edit your extension code (files are in local src/myawesome/)
nano src/myawesome/myawesome.c
nano src/myawesome/php_myawesome.h

# Or edit inside container
make shell
cd myawesome
nano myawesome.c
nano php_myawesome.h
```

#### 3. Build and Test Extension

```bash
# From host machine
make build              # Build the extension
make test               # Run tests
make install            # Install extension

# Or inside container
make shell
cd myawesome
phpdev build
phpdev test
phpdev install

# Verify extension is loaded
php -dextension=myawesome.so -m | grep myawesome
```

#### 4. Debug Your Extension

```bash
# Debug with GDB (from host)
make debug

# Or inside container
phpdev debug
# Then manually:
gdb php
(gdb) run -dextension=modules/myawesome.so your_test.php

# Memory debugging with Valgrind
make valgrind
# or manually:
valgrind --leak-check=full php -dextension=modules/myawesome.so your_test.php
```

### PHP Core Development

#### 1. Working with PHP Source

```bash
# Access the container
make shell

# Navigate to PHP source
cd /usr/src/php/src/php-src

# Make changes to PHP core
nano Zend/zend_execute.c
# or
nano ext/standard/string.c
```

#### 2. Build and Test PHP Core

```bash
# From host machine
make php-clean          # Clean previous builds
make php-build          # Build PHP core
make php-test           # Run tests

# Or inside container
make shell
cd /usr/src/php/src/php-src

# Clean previous builds
make clean

# Reconfigure if needed
./buildconf --force
./configure --prefix=/opt/php --enable-debug CFLAGS="-g -O0"

# Build PHP
make -j$(nproc)

# Run tests
make test

# Install your custom PHP build
make install
```

#### 3. Debug PHP Core

```bash
# Debug PHP core with GDB
make debug
# or manually:
gdb /opt/php/bin/php
(gdb) set args your_test_script.php
(gdb) break zend_execute
(gdb) run

# Memory debugging with Valgrind
valgrind --leak-check=full /opt/php/bin/php your_test_script.php
```

## Project Structure

```
.
├── src/                 # Your PHP development files (mounted as /workdir in container)
│   ├── php.ini         # PHP configuration
│   ├── .gitignore      # Git ignore rules
│   └── myext/          # Your extension directories (created by phpdev create)
├── docker-compose.yml  # Docker Compose configuration
├── Makefile           # Common commands
└── README.md          # This file
```

## Container Directory Structure

```
/opt/php/                   # PHP installation directory
├── bin/                    # PHP binaries (php, phpize, php-config)
├── lib/                    # PHP libraries
├── include/                # PHP headers
└── etc/                    # PHP configuration

/usr/src/php/src/php-src/   # PHP source code
├── ext/                    # Core extensions
├── Zend/                   # Zend engine
├── main/                   # PHP main components
├── sapi/                   # Server APIs
└── TSRM/                   # Thread safe resource manager

/workdir/                   # Your mounted workspace (local src/ directory)
├── your_extensions/        # Your PHP extensions
├── php.ini                # PHP configuration
└── test_scripts/          # Your test PHP scripts

/usr/local/bin/             # Development tools
├── phpdev                  # Main development command
├── Makefile.php-dev        # Development Makefile
└── zig                    # Zig compiler
```

## Available Tools

### Development Tools
- **GDB** - GNU Debugger for debugging PHP core and extensions
- **Valgrind** - Memory debugging and profiling
- **Strace** - System call tracer
- **Git** - Version control
- **Nano/Vim** - Text editors
- **Zig** - Modern systems programming language compiler

### Build Tools
- **GCC/G++** - C/C++ compilers
- **Autoconf/Automake** - Build system tools
- **Bison/Flex** - Parser generators
- **re2c** - Lexer generator
- **Make** - Build automation
- **pkg-config** - Library configuration

## Docker Image

This project uses the [aachraf/php-dev-box](https://hub.docker.com/r/aachraf/php-dev-box) Docker image which provides a complete PHP development environment. The image source code and detailed documentation is available at [GitHub](https://github.com/achrafAa/php-dev-box-image).

### Available Tags

| Tag                | PHP Version | Architecture             |
| ------------------ | ----------- | ------------------------ |
| latest, 8.4, 8.4.4 | PHP 8.4.4   | linux/amd64, linux/arm64 |
| 8.3, 8.3.15        | PHP 8.3.15  | linux/amd64, linux/arm64 |
| 8.2, 8.2.28        | PHP 8.2.28  | linux/amd64, linux/arm64 |
| 8.1, 8.1.31        | PHP 8.1.31  | linux/amd64, linux/arm64 |

## Use Cases

### PHP Core Development
- Working on Zend Engine improvements
- Developing new PHP language features
- Fixing PHP core bugs and optimizations
- Adding new SAPIs

### PHP Extension Development
- Creating custom PHP extensions
- Porting extensions to new PHP versions
- Debugging extension issues
- Performance testing extensions

### Research & Learning
- Understanding PHP internals
- Learning C programming with PHP
- Experimenting with language features
- Educational purposes

## Contributing

Feel free to submit issues and pull requests to improve this development environment.

## License

MIT License
