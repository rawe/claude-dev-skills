#!/bin/bash
# Validates Java environment and fs-cli setup

set -e

PROJECT_ROOT="$(pwd)"
FS_CLI_DIR="$PROJECT_ROOT/.fs-cli"

echo "Validating FirstSpirit CLI environment..."
echo ""

# Load .env
if [ -f "$PROJECT_ROOT/.env" ]; then
    source "$PROJECT_ROOT/.env"
else
    echo "❌ .env file not found. Run setup-fs-cli.sh first."
    exit 1
fi

# Check Java
echo "Checking Java..."
if ! command -v java &> /dev/null; then
    echo "❌ Java not found. Please install Java 17 or higher."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F '.' '{print $1}')
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17+ required. Found Java $JAVA_VERSION"
    exit 1
fi
echo "✓ Java $JAVA_VERSION found"

# Check JAVA_HOME
if [ -z "$JAVA_HOME" ]; then
    echo "⚠ Warning: JAVA_HOME not set"
    echo "  Consider setting it in your shell profile"
else
    echo "✓ JAVA_HOME: $JAVA_HOME"
fi

# Check fs-cli directory
if [ ! -d "$FS_CLI_DIR" ]; then
    echo "❌ .fs-cli directory not found. Run setup-fs-cli.sh first."
    exit 1
fi
echo "✓ .fs-cli directory exists"

# Check fs-cli installation
FS_CLI_VERSION=${FS_CLI_VERSION:-"4.8.6"}
if [ ! -d "$FS_CLI_DIR/bin" ] || [ ! -d "$FS_CLI_DIR/lib" ]; then
    echo "❌ fs-cli not properly installed at: $FS_CLI_DIR"
    echo "   Expected bin/ and lib/ directories not found"
    exit 1
fi
echo "✓ fs-cli $FS_CLI_VERSION installed"

# Check fs-isolated-runtime.jar
JAR_PATH="$FS_CLI_DIR/lib/fs-isolated-runtime.jar"
if [ ! -f "$JAR_PATH" ]; then
    echo "❌ fs-isolated-runtime.jar not found at: $JAR_PATH"
    echo "   Please obtain it from your FirstSpirit server or developer portal"
    exit 1
fi
echo "✓ fs-isolated-runtime.jar found"

# Check fs-cli executable
FS_CLI_BIN="$FS_CLI_DIR/bin/fs-cli"
if [ ! -x "$FS_CLI_BIN" ]; then
    chmod +x "$FS_CLI_BIN"
fi
echo "✓ fs-cli executable ready"

# Test fs-cli help
echo ""
echo "Testing fs-cli..."
if "$FS_CLI_BIN" -h > /dev/null 2>&1; then
    echo "✓ fs-cli runs successfully"
else
    echo "❌ fs-cli failed to run"
    exit 1
fi

# Display configuration
echo ""
echo "========================================="
echo "Environment Valid!"
echo "========================================="
echo ""
echo "Configuration:"
echo "  Server: $FS_MODE://$FS_HOST:$FS_PORT"
echo "  Project: $FS_PROJECT"
echo "  User: $FS_USER"
echo "  fs-cli: $FS_CLI_VERSION"
echo "  FS Version: $FS_VERSION"
echo ""
echo "Ready to use fs-cli!"
echo ""