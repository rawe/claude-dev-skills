# FirstSpirit FS-CLI Export/Sync Directory Structure

## Overview

This document describes the structure and file formats used when exporting FirstSpirit templates using FS-CLI (FSDevTools). The export creates a hierarchical file system structure that mirrors the FirstSpirit project structure, preserving all template configurations, forms, rules, and output channels.

## General Structure

The FS-CLI export follows a consistent pattern:

```
sync_dir/
├── .FirstSpirit/           # Export metadata (do not version control)
│   ├── Files_*.txt        # List of all exported files with checksums
│   └── Import_*.txt       # Import metadata
│
└── TemplateStore/         # Template Store root
    ├── FormatTemplates/   # Text formatting templates
    ├── LinkTemplates/     # Link templates
    ├── PageTemplates/     # Page templates
    ├── SectionTemplates/  # Section templates (content modules)
    ├── Schemes/           # Database schema templates
    ├── Scripts/           # Script templates
    └── Workflows/         # Workflow definitions
```

### Key Principles

1. **Folder hierarchy mirrors FirstSpirit structure**: The file system replicates the exact folder structure from the FirstSpirit project
2. **One folder per element**: Each FirstSpirit template/element gets its own directory
3. **Consistent file naming**: Files use standardized names based on their purpose
4. **Multiple files per template**: Templates are decomposed into separate files for different aspects (form, output, rules, etc.)

## Template Store Structure

### Template Types and Locations

| Template Type | Directory | Purpose |
|--------------|-----------|---------|
| **Page Templates** | `TemplateStore/PageTemplates/` | Define page framework and structure |
| **Section Templates** | `TemplateStore/SectionTemplates/` | Content modules inserted into pages |
| **Format Templates** | `TemplateStore/FormatTemplates/` | Text formatting options for editors |
| **Link Templates** | `TemplateStore/LinkTemplates/` | Link type configurations |
| **Table Templates** | `TemplateStore/Schemes/` | Database schema templates |
| **Script Templates** | `TemplateStore/Scripts/` | BeanShell scripts and functions |
| **Workflows** | `TemplateStore/Workflows/` | Approval and release workflows |

## File Types Reference

Each template directory contains a combination of the following files, depending on the template type:

### Core Files (All Templates)

#### StoreElement.xml
**Purpose**: Core template metadata and configuration

**Contains**:
- Template ID (`id` attribute) - unique identifier
- Template reference name (`filename` or `name` attribute)
- Template type (`type` attribute: `page`, `section`, `format`, etc.)
- Display names (multilingual via `<LANG>` elements)
- Channel/extension mappings (`<EXTENSION>` elements)
- Template body definitions (`<TEMPLATEBODY>`)
- Format template style definitions (`<style>` for format templates)

#### FS_Files.txt
**Purpose**: File registry with metadata for all files in the template directory

**Contains**: Tab-delimited list with checksum, file size, timestamp, MIME type, and filename for each file

#### FS_Info.txt
**Purpose**: Additional metadata about the template element

**Contains**: Template information, creation/modification dates, author information

#### FS_References.txt
**Purpose**: Dependency tracking

**Contains**: References to other FirstSpirit elements that this template depends on or uses

### Form Definition Files

#### GomSource.xml
**Purpose**: Form definition (GOM = GUI Object Model)

**Contains**:
- Input component definitions (CMS_INPUT_*, FS_CATALOG, FS_INDEX, etc.)
- Form field configurations
- Labels and descriptions (multilingual via `<LANGINFO>`)
- Layout and organization
- Default values

#### GomDefaults.xml
**Purpose**: Default values for GOM form fields (optional)

**Found in**: Style/Format templates primarily

**Contains**: Default values for form fields

### Output Channel Files

#### ChannelSource_[CHANNEL]_[EXTENSION].[EXTENSION]
**Purpose**: Template output for specific delivery channels

**Naming pattern**: `ChannelSource_<ChannelName>_<extension>.<extension>`

**Common examples**:
- `ChannelSource_HTML_html.html` - HTML output channel
- `ChannelSource_XML_xml.xml` - XML output channel
- `ChannelSource_JSON_json.json` - JSON output channel

**Contains**: FirstSpirit template syntax with output logic (HTML, XML, or other formats)

### Rule Definition Files

#### Ruleset.xml
**Purpose**: Dynamic form behavior and validation rules

**Contains**:
- Conditional visibility rules
- Field dependency rules
- Validation rules (SAVE, RELEASE, INFO severity)
- Dynamic value calculations
- Multi-language support rules

### Preview/Snippet Files

These files define how templates appear in preview mode and in template selection dialogs.

#### SnippetThumb.txt
**Purpose**: Thumbnail/icon preview

**Contains**: Template syntax to generate small preview image or icon

#### SnippetHeader.txt
**Purpose**: Header/title preview

**Contains**: Template syntax to generate preview title (often just the headline field)

#### SnippetExtract.txt
**Purpose**: Content extract preview

**Contains**: Template syntax to generate preview text/excerpt

**Example**:
```
$CMS_IF(!pt_headline.isEmpty)$
  $CMS_VALUE(pt_headline.toText(false))$
$CMS_END_IF$
```

### Workflow-Specific Files

#### Workflow.xml
**Purpose**: Complete workflow definition

**Contains**:
- States (start, end, intermediate states)
- Activities (tasks, actions)
- Transitions (connections between states)
- Email configurations
- Permissions and rights
- User/group assignments
- Scripting logic

**Structure**: Java object serialization format describing the workflow graph

**Key Components**:
- **States**: Workflow stages with permissions and duration
- **Activities**: Tasks users perform
- **Transitions**: Connections with email notifications and rights
- **Coordinates**: Visual layout positions (x, y coordinates)

#### ViewScript.txt
**Purpose**: Custom workflow display/view logic (optional)

**Contains**: BeanShell script for custom workflow UI

## Directory Organization by Template Type

### Page Templates
```
PageTemplates/
└── pt_standard_page/
    ├── StoreElement.xml                    # Template metadata
    ├── GomSource.xml                       # Form definition
    ├── Ruleset.xml                         # Form rules
    ├── ChannelSource_HTML_html.html        # HTML output
    ├── SnippetThumb.txt                    # Thumbnail preview
    ├── SnippetHeader.txt                   # Header preview
    ├── SnippetExtract.txt                  # Extract preview
    ├── FS_Files.txt                        # File registry
    ├── FS_Info.txt                         # Metadata
    └── FS_References.txt                   # Dependencies
```

### Section Templates
```
SectionTemplates/
└── st_text_image_module/
    ├── StoreElement.xml                    # Template metadata
    ├── GomSource.xml                       # Form definition
    ├── Ruleset.xml                         # Form rules
    ├── ChannelSource_HTML_html.html        # HTML output
    ├── SnippetThumb.txt                    # Thumbnail preview
    ├── SnippetHeader.txt                   # Header preview
    ├── SnippetExtract.txt                  # Extract preview
    ├── FS_Files.txt                        # File registry
    ├── FS_Info.txt                         # Metadata
    └── FS_References.txt                   # Dependencies
```

### Format Templates
```
FormatTemplates/
├── h1/
│   ├── StoreElement.xml                    # Format definition with style
│   ├── ChannelSource_HTML_html.html        # HTML rendering
│   ├── FS_Files.txt
│   ├── FS_Info.txt
│   └── FS_References.txt
│
└── common_format_templates/                # Folder grouping
    ├── StoreElement.xml                    # Folder metadata
    ├── FS_Files.txt
    ├── FS_Info.txt
    ├── FS_References.txt
    │
    ├── default_style_template/
    │   ├── StoreElement.xml                # Style template definition
    │   ├── GomSource.xml                   # Style configuration form
    │   ├── GomDefaults.xml                 # Default style values
    │   ├── Ruleset.xml
    │   ├── ChannelSource_HTML_html.html
    │   ├── FS_Files.txt
    │   ├── FS_Info.txt
    │   └── FS_References.txt
    │
    └── p/                                  # Paragraph format
        ├── StoreElement.xml
        ├── ChannelSource_HTML_html.html
        └── ...
```

### Workflows
```
Workflows/
└── assign_task/
    ├── StoreElement.xml                    # Workflow metadata
    ├── Workflow.xml                        # Workflow definition (states, transitions)
    ├── GomSource.xml                       # Form for workflow parameters
    ├── Ruleset.xml                         # Form rules
    ├── ViewScript.txt                      # Custom view script (optional)
    ├── SnippetThumb.txt                    # Preview files
    ├── SnippetHeader.txt
    ├── SnippetExtract.txt
    ├── FS_Files.txt
    ├── FS_Info.txt
    └── FS_References.txt
```

## Metadata Directory: .FirstSpirit

**Location**: `.FirstSpirit/` at the root of the sync directory

**Purpose**: Contains internal metadata required for successful synchronization between file system and FirstSpirit server

**Important**: Do NOT version control this directory. It contains session-specific information.

### Files

#### Files_[sessionid]_[revision].txt
**Purpose**: Complete file registry for the export

**Contains**: Tab-delimited entries with reference IDs and file information (checksum, size, timestamp, MIME type, filename)

#### Import_[sessionid]_[revision].txt
**Purpose**: Import instructions and metadata for re-importing into FirstSpirit

## Template Identification

### Finding Templates

Templates are located by type in their respective directories:

| What to find | Where to look | Identifier |
|-------------|---------------|------------|
| Page template by name | `PageTemplates/[name]/` | Directory name matches template reference name |
| Section template by name | `SectionTemplates/[name]/` | Directory name matches template reference name |
| Format template by name | `FormatTemplates/[name]/` | Directory name matches format name |
| Template by ID | Search `StoreElement.xml` files for `id` attribute | Unique numeric ID |
| Template display name | Look in `StoreElement.xml` → `<LANG>` elements | Multilingual display names |

### Template Reference Names

The directory name matches the template's **reference name** (UID name) in FirstSpirit:
- `pt_standard_page` → Page Template with reference name "pt_standard_page"
- `st_text_image_module` → Section Template with reference name "st_text_image_module"

### Template IDs

Each template has two IDs in `StoreElement.xml`:
- `id` - Element instance ID
- `templateid` - Template definition ID (for page/section templates)

## Information Access Guide

### How to Find Specific Information

| Information Needed | File to Check | Location in File |
|-------------------|---------------|------------------|
| **Template display name** | `StoreElement.xml` | `<LANG displayname="..." language="EN"/>` |
| **Template reference name** | `StoreElement.xml` | `filename` or `name` attribute |
| **Template ID** | `StoreElement.xml` | `id` attribute |
| **Form fields** | `GomSource.xml` | `<CMS_INPUT_*>` elements |
| **Field labels** | `GomSource.xml` | `<LANGINFO lang="*" label="..."/>` |
| **Available format templates** | `GomSource.xml` in DOM fields | `<FORMATS><TEMPLATE name="..."/></FORMATS>` |
| **HTML output** | `ChannelSource_HTML_html.html` | Entire file |
| **Template variables** | `ChannelSource_HTML_html.html` | `<CMS_HEADER>` section |
| **Form rules** | `Ruleset.xml` | `<RULE>` elements |
| **Dependencies** | `FS_References.txt` | List of referenced elements |
| **Workflow states** | `Workflow.xml` | `<FIELD name="states">` section |
| **Workflow transitions** | `Workflow.xml` | `<FIELD name="transitions">` section |

## Template Set Configuration

**Location**: `StoreElement.xml` → `<EXTENSION>` element

**Attributes**:
- `file` - File extension for generated files
- `link` - Link extension
- `templateSet` - Template set ID
- `replaceable` - Whether extension can be changed

## Common Use Cases

### 1. Finding All Section Templates
```bash
find sync_dir/TemplateStore/SectionTemplates -name "StoreElement.xml" -type f
```

### 2. Extracting Template Display Names
```bash
grep -r "displayname=" sync_dir/TemplateStore/*/*/StoreElement.xml
```

### 3. Finding Templates Using a Specific Format
```bash
grep -r '<TEMPLATE name="h1"/>' sync_dir/TemplateStore/*/*/GomSource.xml
```

### 4. Listing All Form Fields in a Template
```bash
grep -o 'name="[^"]*"' sync_dir/TemplateStore/PageTemplates/pt_standard_page/GomSource.xml
```

### 5. Finding All HTML Output Templates
```bash
find sync_dir/TemplateStore -name "ChannelSource_HTML_html.html" -type f
```

## Best Practices

### Version Control
1. **DO** version control all template files in `TemplateStore/`
2. **DO NOT** version control `.FirstSpirit/` directory
3. **DO** commit `StoreElement.xml`, `GomSource.xml`, `ChannelSource_*`, and `Ruleset.xml` files
4. **CONSIDER** whether to version `FS_Files.txt` (contains checksums that change frequently)

### Template Development
1. **Naming**: Use consistent prefixes (e.g., `pt_` for page templates, `st_` for section templates)
2. **Organization**: Group related format templates in folders (like `common_format_templates/`)
3. **Documentation**: Use meaningful `displayname` attributes in multilingual `<LANG>` elements
4. **Dependencies**: Check `FS_References.txt` to understand template dependencies

### Editing Exported Files
1. **StoreElement.xml**: Edit carefully, preserve IDs unless creating new templates
2. **GomSource.xml**: Standard XML, can be edited directly
3. **ChannelSource files**: Edit freely, contains your template output logic
4. **Ruleset.xml**: Edit rules following FirstSpirit rule syntax
5. **Workflow.xml**: Complex Java serialization format, prefer editing in SiteArchitect

### Re-importing
1. Maintain the exact directory structure
2. Keep `StoreElement.xml` IDs consistent for updates
3. Ensure all referenced templates exist
4. Validate XML syntax before import

## File Type Summary Table

| File | Required | Template Types | Editable | Purpose |
|------|----------|----------------|----------|---------|
| `StoreElement.xml` | Yes | All | Yes (carefully) | Template metadata and configuration |
| `GomSource.xml` | For templates with forms | Page, Section, Workflow, Style | Yes | Form definition (input components) |
| `GomDefaults.xml` | No | Style/Format | Yes | Default form values |
| `Ruleset.xml` | No | Page, Section, Workflow | Yes | Dynamic form rules |
| `ChannelSource_*.html` | For output templates | Page, Section, Format | Yes | Output channel templates |
| `Workflow.xml` | Yes | Workflow | No (use SiteArchitect) | Workflow definition |
| `ViewScript.txt` | No | Workflow | Yes | Custom workflow view |
| `Snippet*.txt` | No | Page, Section | Yes | Preview content |
| `FS_Files.txt` | Yes | All | No (auto-generated) | File registry |
| `FS_Info.txt` | Yes | All | No (auto-generated) | Element metadata |
| `FS_References.txt` | Yes | All | No (auto-generated) | Dependency tracking |

## References

- **Official Documentation**: https://docs.e-spirit.com/odfs/edocs/sync/
- **FS-CLI Tool**: https://github.com/e-Spirit/FSDevTools
- **Template Development**: https://docs.e-spirit.com/odfs/template-develo/
- **External Synchronization**: https://docs.e-spirit.com/odfs/edocs/sync/how/4-export/
