# FS-CLI Usage Guide

## Prerequisites

- Java Runtime Environment (JRE) 17 or higher
- FirstSpirit 5.2.231105 or higher
- Correct `JAVA_HOME` environment variable set

## Environment Variables

FS-CLI supports environment variables to simplify command execution:

| Variable    | Description                                    | Default     |
|-------------|------------------------------------------------|-------------|
| `fshost`    | FirstSpirit host address                       | `localhost` |
| `fsport`    | FirstSpirit port number                        | `8000`      |
| `fsmode`    | Connection mode: HTTP, HTTPS, or SOCKET        | `HTTP`      |
| `fsuser`    | FirstSpirit user account                       | -           |
| `fspwd`     | FirstSpirit user password                      | -           |
| `fsproject` | FirstSpirit project name                       | -           |

**IMPORTANT** These environment variables are already set in the .env file in the project root directory for convenience.

### Setup Environment Variables

Use the .env file to set the required environment variables.


## Common Commands

### Test Connection
Test connection to FirstSpirit server:

```bash
source .env
.fs-cli/bin/fs-cli.sh test
```

### Export All Templates

Export all templates from FirstSpirit server to local sync directory:

```bash
source .env
.fs-cli/bin/fs-cli.sh -sd sync_dir/ export
```

**What gets exported:**
- Page templates
- Section templates
- Format templates
- Link templates
- Workflows
- Rules

All exported content is stored in `sync_dir/TemplateStore/`.

### Export Only TemplateStore

Export only templates (no content, media, etc.):

```bash
source .env
.fs-cli/bin/fs-cli.sh -sd sync_dir/ export -- templatestore
```

### Export Specific Element by UID

Export a single element by its unique ID:

```bash
source .env
.fs-cli/bin/fs-cli.sh -sd sync_dir/ export -uid homepage
```

Replace `homepage` with the UID of the element you want to export.

### Import Templates

Import templates from local sync directory to FirstSpirit server:

```bash
source .env
.fs-cli/bin/fs-cli.sh -sd sync_dir/ import
```

**Requirements:**
- Sync directory must exist
- Sync directory must contain valid `TemplateStore/` structure (see `fs-cli-sync-structure.md`)
- User must have write permissions in FirstSpirit project

**Important:** Import overwrites existing templates with the same names in FirstSpirit.

### Dry Run Import

Test import without making changes to the server:

```bash
source .env
.fs-cli/bin/fs-cli.sh -sd sync_dir/ import --dry-run
```

Use this to verify what would be imported before actually doing it.

## Alternative: Using Explicit Parameters

If you prefer not to use environment variables, you can specify all parameters explicitly:

```bash
.fs-cli/bin/fs-cli.sh \
  -h localhost \
  -port 8000 \
  -u admin \
  -pwd your-password \
  -m HTTP \
  -p my-project \
  -sd sync_dir/ \
  export
```

**However**, using environment variables (via `.env` file) is **strongly recommended** for:
- Security (credentials not in command history)
- Convenience (shorter commands)
- Consistency (same config across commands)

## Notes

- **Always source `.env` before running commands** to load environment variables
- When using environment variables, connection parameters (`-h`, `-port`, `-u`, `-pwd`, `-m`, `-p`) can be omitted
- The sync directory is in the project root subfolder `sync_dir/`
- Import overwrites existing templates with the same names in FirstSpirit
- Export creates/overwrites files in the sync directory
- Use `--dry-run` with import to test safely before applying changes
