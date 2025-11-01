# FirstSpirit CLI Installation Guide

This guide walks you through setting up fs-cli for your FirstSpirit project.

## Prerequisites

- **Java 17 or higher** installed locally
- **JAVA_HOME** environment variable set (recommended)
- Access to a FirstSpirit server
- FirstSpirit user credentials

## Setup Steps

### 1. Run the Setup Script

run the setup script:

```bash
../scripts/setup-fs-cli.sh
```

BE AWARE that this script is interactive and relative to this file here.

This script will:
- Prompt for fs-cli version (default: 4.8.6)
- Download and extract fs-cli to `.fs-cli/`
- Prompt for your FirstSpirit version
- Guide you through obtaining `fs-isolated-runtime.jar`
- Create the `.env` and `.env.example` files
- Update `.gitignore`

### 2. Obtain fs-isolated-runtime.jar

**This is the only manual step.**

The `fs-isolated-runtime.jar` file must match your FirstSpirit server version exactly.

#### Option A: From FirstSpirit Server 

The fs-isolated-runtime jar is located in the server installation directory `[serverRoot]/data/fslib`


#### Option B: From Crownpeaks file server

1. Login to (https://file.crownpeak.com)
2. Navigate to Downloads → FirstSpirit → Your Version
3. Find and Download `fs-isolated-runtime.jar`
4. Copy to: `.fs-cli/lib/fs-isolated-runtime.jar`

**Important**: The jar version must match your FirstSpirit server version exactly (e.g., 2025.01, 2024.09, etc.)

### 3. Validate Environment

Run the validation script:

```bash
../scripts/validate-environment.sh
```

BE AWARE that this script is elative to this file here.

This checks:
- Java 17+ is installed
- JAVA_HOME is set (optional but recommended)
- fs-cli is extracted properly
- fs-isolated-runtime.jar is in place
- fs-cli can run

### 4. Start Using fs-cli

Once validation passes, you can:

- Use the FirstSpirit skill in Claude Code
- Run fs-cli directly: `.fs-cli/bin/fs-cli`
- Use export/import commands

## Configuration

All configuration is stored in `.env`:

```bash
# FirstSpirit Server Configuration
fshost=localhost
fsport=8000
fsmode=HTTP
fsproject=my-project

# FirstSpirit Credentials (KEEP SECRET - DO NOT COMMIT)
fsuser=Admin
fspwd=your_password

# fs-cli Configuration (for reference only, not used by fs-cli)
FS_CLI_VERSION=4.8.6
FS_VERSION=2025.01
```

**Never commit `.env` to git!** Use `.env.example` as a template for your team.

## Troubleshooting

### Java Version Issues

Check your Java version:

```bash
java -version
```

You need Java 17 or higher. On macOS with multiple Java versions:

```bash
# Set Java 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Or Java 21
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
```

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

### fs-isolated-runtime.jar Version Mismatch

**Symptom**: Connection errors or runtime exceptions

**Solution**: Ensure jar version exactly matches your FirstSpirit server version. Check your server version:

```bash
# In FirstSpirit ServerManager or ask your admin
```

### Permission Denied on fs-cli

```bash
chmod +x .fs-cli/bin/fs-cli
```

### Connection Failures

1. **Verify server is running**:
   ```bash
   telnet $fshost $fsport
   ```

2. **Check credentials** in `.env`

3. **Verify connection mode**: HTTP vs HTTPS vs SOCKET

4. **Check firewall/network access**: Ensure your machine can reach the FS server

5. **Test with fs-cli directly**:
   ```bash
   set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh test
   ```

### Download Failures

If GitHub download fails:

```bash
# Manually download from:
# https://github.com/e-Spirit/FSDevTools/releases/download/VERSION/fs-cli-VERSION.tar.gz

# Extract manually:
tar -xzf fs-cli-VERSION.tar.gz -C .fs-cli/
```

## Directory Structure

After setup:

```
your-project/
├── .env                    # Your config (gitignored)
├── .env.example           # Template (committed)
├── .gitignore             # Ignores .fs-cli/ and .env
├── .fs-cli/               # Gitignored
│   ├── bin/
│   │   └── fs-cli        # The CLI executable
│   ├── lib/
│   │   └── fs-isolated-runtime.jar  # You provide (version-specific)
│   └── .setup-marker     # Tracks setup state (fs-cli version, FS version)
├── sync_dir/              # FirstSpirit templates (exported)
└── scripts/               # Optional convenience scripts
```

## Working with Multiple Environments

Each project connects to one FirstSpirit server version. If you have multiple environments (dev, staging, prod) with the same FS version, you can use different .env files:

```bash
.env           # Default environment
.env.prod      # Production
.env.staging   # Staging

# Switch environments by sourcing different .env files:
set -a && source .env.prod && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export
```

**Note**: All environments in a project should use the same FirstSpirit version since the fs-isolated-runtime.jar is version-specific.

## Advanced: Adding Custom JARs

For future custom functionality:

```bash
# Add your custom JAR to fs-cli classpath
cp your-custom-tool.jar .fs-cli/lib/
```

The fs-cli will automatically include all JARs in the lib folder.

## Next Steps

Once installation is complete:

1. **Learn the commands**: Read `fs-cli-usage.md` for common fs-cli commands and usage examples
2. **Understand template structure**: Read `fs-cli-sync-structure.md` to understand the exported template structure
3. **Start working**: Use the FirstSpirit skill in Claude Code to work with templates
4. **Optional**: Set up version control for `sync_dir/` if using external sync

## Getting Help

If you encounter issues:

1. Run diagnostics: `bash validate-environment.sh`
2. Check this guide's troubleshooting section
3. Review fs-cli README: `.fs-cli/README.txt`
4. Check FirstSpirit server logs
5. Contact your FirstSpirit administrator
