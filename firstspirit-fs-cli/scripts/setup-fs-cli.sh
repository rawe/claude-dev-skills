#!/bin/bash
# Setup script for fs-cli in FirstSpirit projects
# This script downloads and extracts fs-cli to .fs-cli/ directory

set -e

PROJECT_ROOT="$(pwd)"
FS_CLI_DIR="$PROJECT_ROOT/.fs-cli"
DEFAULT_FS_CLI_VERSION="4.8.6"

echo "========================================="
echo "FirstSpirit CLI Setup"
echo "========================================="
echo ""

# Step 1: Prompt for fs-cli version
read -p "Enter fs-cli version to download [$DEFAULT_FS_CLI_VERSION]: " FS_CLI_VERSION
FS_CLI_VERSION=${FS_CLI_VERSION:-$DEFAULT_FS_CLI_VERSION}

# Step 2: Create .fs-cli directory
echo ""
echo "Creating .fs-cli directory..."
mkdir -p "$FS_CLI_DIR"

# Step 3: Download fs-cli
DOWNLOAD_URL="https://github.com/e-Spirit/FSDevTools/releases/download/${FS_CLI_VERSION}/fs-cli-${FS_CLI_VERSION}.tar.gz"
TARBALL="$FS_CLI_DIR/fs-cli-${FS_CLI_VERSION}.tar.gz"

echo "Downloading fs-cli ${FS_CLI_VERSION}..."
echo "URL: $DOWNLOAD_URL"

if command -v curl &> /dev/null; then
    curl -L -o "$TARBALL" "$DOWNLOAD_URL"
elif command -v wget &> /dev/null; then
    wget -O "$TARBALL" "$DOWNLOAD_URL"
else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Step 4: Extract and flatten directory structure
echo "Extracting fs-cli..."
tar -xzf "$TARBALL" -C "$FS_CLI_DIR"
# Move contents from fs-cli-VERSION/ to .fs-cli/ directly
mv "$FS_CLI_DIR/fs-cli-${FS_CLI_VERSION}"/* "$FS_CLI_DIR/"
mv "$FS_CLI_DIR/fs-cli-${FS_CLI_VERSION}"/.[!.]* "$FS_CLI_DIR/" 2>/dev/null || true
rmdir "$FS_CLI_DIR/fs-cli-${FS_CLI_VERSION}"
rm "$TARBALL"

echo ""
echo "✓ fs-cli ${FS_CLI_VERSION} downloaded and extracted"
echo ""

# Step 5: Prompt for FirstSpirit version
read -p "Enter your FirstSpirit server version (e.g., 2025.01, 2024.09): " FS_VERSION

# Step 6: Instructions for fs-isolated-runtime.jar
echo ""
echo "========================================="
echo "IMPORTANT: Manual Step Required"
echo "========================================="
echo ""
echo "You need to obtain fs-isolated-runtime.jar for FirstSpirit ${FS_VERSION}"
echo ""
echo "Option 1: From your FirstSpirit server"
echo "  1. SSH into your FirstSpirit server"
echo "  2. Navigate to: <FS_INSTALL>/server/lib-isolated/"
echo "  3. Copy fs-isolated-runtime.jar to:"
echo "     $FS_CLI_DIR/lib/fs-isolated-runtime.jar"
echo ""
echo "Option 2: From FirstSpirit developer portal"
echo "  1. Login to e-Spirit developer portal"
echo "  2. Download fs-isolated-runtime.jar for version ${FS_VERSION}"
echo "  3. Copy it to:"
echo "     $FS_CLI_DIR/lib/fs-isolated-runtime.jar"
echo ""
echo "Press Enter when you have placed fs-isolated-runtime.jar in the lib folder..."
read

# Step 7: Validate jar exists
JAR_PATH="$FS_CLI_DIR/lib/fs-isolated-runtime.jar"
if [ ! -f "$JAR_PATH" ]; then
    echo ""
    echo "⚠ Warning: fs-isolated-runtime.jar not found at:"
    echo "  $JAR_PATH"
    echo ""
    echo "Please place the file there before running fs-cli commands."
    echo ""
else
    echo ""
    echo "✓ fs-isolated-runtime.jar found"
    echo ""
fi

# Step 8: Create .env file
ENV_FILE="$PROJECT_ROOT/.env"
ENV_EXAMPLE="$PROJECT_ROOT/.env.example"

if [ ! -f "$ENV_FILE" ]; then
    echo "Creating .env file for configuration..."
    echo ""

    read -p "FirstSpirit server host [localhost]: " FS_HOST
    FS_HOST=${FS_HOST:-localhost}

    read -p "FirstSpirit server port [8000]: " FS_PORT
    FS_PORT=${FS_PORT:-8000}

    read -p "Connection mode (HTTP/HTTPS/SOCKET) [HTTP]: " FS_MODE
    FS_MODE=${FS_MODE:-HTTP}

    read -p "FirstSpirit project name: " FS_PROJECT

    read -p "FirstSpirit username: " FS_USER

    read -s -p "FirstSpirit password: " FS_PASSWORD
    echo ""

    cat > "$ENV_FILE" << EOF
# FirstSpirit Server Configuration
FS_HOST=${FS_HOST}
FS_PORT=${FS_PORT}
FS_MODE=${FS_MODE}
FS_PROJECT=${FS_PROJECT}

# FirstSpirit Credentials (KEEP SECRET - DO NOT COMMIT)
FS_USER=${FS_USER}
FS_PASSWORD=${FS_PASSWORD}

# fs-cli Configuration
FS_CLI_VERSION=${FS_CLI_VERSION}
FS_VERSION=${FS_VERSION}
EOF

    # Create .env.example (without secrets)
    cat > "$ENV_EXAMPLE" << EOF
# FirstSpirit Server Configuration
FS_HOST=localhost
FS_PORT=8000
FS_MODE=HTTP
FS_PROJECT=your-project-name

# FirstSpirit Credentials (KEEP SECRET - DO NOT COMMIT)
FS_USER=your-username
FS_PASSWORD=your-password

# fs-cli Configuration
FS_CLI_VERSION=${FS_CLI_VERSION}
FS_VERSION=${FS_VERSION}
EOF

    echo ""
    echo "✓ Created .env and .env.example files"
    echo ""
fi

# Step 9: Update .gitignore
GITIGNORE="$PROJECT_ROOT/.gitignore"
if [ -f "$GITIGNORE" ]; then
    if ! grep -q "^\.fs-cli/" "$GITIGNORE"; then
        echo "" >> "$GITIGNORE"
        echo "# FirstSpirit CLI" >> "$GITIGNORE"
        echo ".fs-cli/" >> "$GITIGNORE"
        echo ".env" >> "$GITIGNORE"
        echo "" >> "$GITIGNORE"
        echo "✓ Updated .gitignore"
    else
        echo "✓ .gitignore already configured"
    fi
else
    cat > "$GITIGNORE" << EOF
# FirstSpirit CLI
.fs-cli/
.env
EOF
    echo "✓ Created .gitignore"
fi

# Step 10: Mark setup complete
echo "$FS_CLI_VERSION" > "$FS_CLI_DIR/.setup-marker"
echo "$FS_VERSION" >> "$FS_CLI_DIR/.setup-marker"

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Verify fs-isolated-runtime.jar is in place"
echo "  2. Test connection: bash validate-environment.sh"
echo "  3. Start using fs-cli via the FirstSpirit skill"
echo ""
echo "Configuration stored in: .env"
echo "fs-cli installed at: $FS_CLI_DIR/"
echo "fs-cli version: ${FS_CLI_VERSION}"
echo ""