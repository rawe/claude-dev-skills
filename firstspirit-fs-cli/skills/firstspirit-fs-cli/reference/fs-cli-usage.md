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

**IMPORTANT:** These environment variables are already set in the .env file in the project root directory for convenience.

### Setup Environment Variables

The `.env` file should use standard format (without `export` keyword). Use `set -a; source .env; set +a` before running fs-cli commands to properly export these variables.


## Common Commands

### Test Connection
Test connection to FirstSpirit server:

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh test
```

### Export Templates

Export only templates (no content, media, etc.):

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export -- templatestore
```

### Export Single Template by ID

Export a specific template by its UID:

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export -- sectiontemplate:st_text_image_module
```

**Template Type Prefixes:**
- `sectiontemplate:` - Section templates
- `pagetemplate:` - Page templates
- `formattemplate:` - Format templates
- `linktemplate:` - Link templates
- `workflow:` - Workflows
- `script:` - Scripts

**Examples:**
```bash
# Export a section template
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export -- sectiontemplate:st_text_image_module

# Export a page template
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export -- pagetemplate:pt_standard_page

# Export multiple specific templates
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export -- sectiontemplate:st_text_image_module pagetemplate:pt_standard_page
```

**What Happens to Previously Exported Templates:**

When you export a specific template by ID, fs-cli will **remove all other templates** from `sync_dir/` that are not part of the current export. This keeps the sync directory focused on only the templates you specified.

- **Before**: `sync_dir/` contains all previously exported templates
- **After**: `sync_dir/` contains **only** the template(s) you just exported
- **Deleted**: All other templates are removed from `sync_dir/` (not from the server!)

**To keep existing templates and add more**, use the `--keepObsoleteFiles` flag:

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export --keepObsoleteFiles -- sectiontemplate:st_text_image_module
```

### Export Specific Element by UID

Export a single element by its unique ID:

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ export -uid homepage
```

Replace `homepage` with the UID of the element you want to export.

### Import Templates

Import templates from local sync directory to FirstSpirit server:

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ import
```

**Requirements:**
- Sync directory must exist
- Sync directory must contain valid `TemplateStore/` structure (see `fs-cli-sync-structure.md`)
- User must have write permissions in FirstSpirit project

**Important:** Import overwrites existing templates with the same names in FirstSpirit.

### Dry Run Import

Test import without making changes to the server:

```bash
set -a && source .env && set +a && .fs-cli/bin/fs-cli.sh -sd sync_dir/ import --dry-run
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

- **Always use `set -a && source .env && set +a` before running commands** to properly export environment variables
- When using environment variables, connection parameters (`-h`, `-port`, `-u`, `-pwd`, `-m`, `-p`) can be omitted
- The sync directory is in the project root subfolder `sync_dir/`
- Global options like `-sd` must come BEFORE the command (e.g., `-sd sync_dir/ export` not `export -sd sync_dir/`)
- Import overwrites existing templates with the same names in FirstSpirit
- Export creates/overwrites files in the sync directory
- Use `--dry-run` with import to test safely before applying changes
