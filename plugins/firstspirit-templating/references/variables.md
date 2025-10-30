# Variables in FirstSpirit

## Overview

Variables in FirstSpirit store website content separately from structure and layout, implementing the core principle of "separation of structure, content and layout." Content values are managed in designated storage areas called "Stores," with variables serving as named containers that have unique identifiers and changeable values accessed through those identifiers.

## Variable Identifiers

### Valid Identifier Rules

Variable identifiers must follow specific naming conventions:

- Must contain at least one letter (e.g., `a`, `a1`, `a_b`)
- OR start with underscore plus at least one letter/number (e.g., `_0`, `_a`)
- Cannot use hyphens or consist only of underscores
- Should remain unchanged after creation to preserve project references

**Critical Requirement:** Project-wide unique identifiers must be assigned to each variable, as duplicate identifiers can cause variables to overwrite each other.

### Coding Conventions

Recommended prefixes indicate variable origin and location:

| Prefix | Location | Example |
|--------|----------|---------|
| `gv_` | Global project use | `gv_pagetitle` |
| `pt_` | Page templates | `pt_pagetitle` |
| `st_` | Section templates | `st_text_picture` |
| `ft_` | Format templates | |
| `lt_` | Link templates | `lt_linktext` |
| `tt_` | Table templates | `tt_date` |
| `md_` | Metadata templates | `md_keywords` |
| `ps_` | Project settings | `ps_copyright` |
| `ss_` | Site Store structure | `ss_shownavigation` |

## Variable Declaration Locations

### Templates (Forms Tab)

Input components on the Form tab define variables through the `name` attribute. Values entered by editors populate these variables. Each component requires a unique identifier, as non-unique identifiers can cause saved database contents to be overwritten by new content.

### Template Sets

Variables can be set via:
- `$CMS_SET(...,...)$` instruction
- `<CMS_FUNCTION>` tags
- `<CMS_VALUE>` tags

These variables are developer-assigned and not accessible to editors.

### Metadata

Additional information associated with Page, Media, and Site Store nodes.

### Menu Levels

Structure variables for Site Store folders enable layout variations across hierarchical areas.

### Global Store

Reusable content blocks like copyright notices.

### Schedules

Variables configured in generation schedules override other variables during project generation.

## Defining Variables in Templates

Variables can be defined in three distinct areas of templates:

### 1. Form Area

**Purpose:** Editor-assigned values through input components

**Characteristics:**
- Each component requires a unique identifier (variable name)
- Values are entered directly by editors
- Cannot be accessed in header area

**Controlling Editor Input:**

Template developers can influence value assignment through:

- **Reducing functional scope**: Disable specific features (e.g., bold/italic in DOM inputs)
- **Limiting choices**: Restrict selection options using FILTER, ALLOW, or HIDE tags
- **Mandatory fields**: Use `allowEmpty="no"` parameter
- **Default values**: Set fallback values using `preset` parameter or the "Default values" button
- **Case differentiation**: Employ conditional logic with `isNull` or `isEmpty` methods

### 2. Header Area

Variables defined in `<CMS_HEADER>` sections are template developer-defined and cannot be edited by editors.

**Function-Based Definition:**

```xml
<CMS_FUNCTION name="functionName" resultname="variableName">
  <!-- Function configuration -->
</CMS_FUNCTION>
```

- Functions execute only once during page generation
- Require `name` and `resultname` attributes
- Available header functions: contentSelect, define, Font, MenuGroup, Navigation, PageGroup, Table

**CMS_VALUE Tag Definition:**

Language-dependent variables:

```xml
<CMS_VALUE name="Labeling">
  <LANG id="DE">
    <ATTR name="self">Mann</ATTR>
    <ATTR name="woman">Frau</ATTR>
  </LANG>
  <LANG id="EN">
    <ATTR name="self">man</ATTR>
    <ATTR name="woman">woman</ATTR>
  </LANG>
</CMS_VALUE>
```

Access methods:
- `$CMS_VALUE(Labeling)$` - returns default "self" attribute
- `$CMS_VALUE(Labeling.woman)$` - returns specific attribute

**Header Area Constraints:**
- Variables defined in Form area cannot be accessed in header area
- `CMS_VALUE` definitions must precede `CMS_FUNCTION` tags

### 3. Body Area

Variables defined at runtime using the `$CMS_SET(...)$` instruction:

**Simple String Objects:**

```
$CMS_SET(myVar,"This is a text with \"special characters\".")$
$CMS_VALUE(myVar)$
```

Output: `This is a text with "special characters".`

**Complex Document Objects:**

```
$CMS_SET(myVar3)$
  $CMS_VALUE(myVar2)$
$CMS_END_SET$
```

This creates a `TemplateDocumentImpl` object containing CMS expressions, unlike simple String objects.

**Special Character Handling:**

Escape special characters in strings using backslash notation (e.g., `\"` for quotes).

## Outputting Variables

### $CMS_VALUE(...) Instruction

Basic syntax outputs variable content:

```
Hello $CMS_VALUE(name.firstname)$ $CMS_VALUE(name.lastname)$!
```

**With Expressions:**

```
Hello $CMS_VALUE(name.firstname + " " + name.lastname)$!
```

**Best Practice for Null Checks:**

Perform `isNull` or `isEmpty` tests rather than using `default` or `isSet()`, which suppress debugging information:

```
$CMS_IF(!name.isNull)$
  Hello $CMS_VALUE(name.firstname)$!
$CMS_END_IF$
```

This approach prevents error messages while maintaining visibility of debugging information.

### $CMS_REF(...) Instruction

Resolves references to paths. Requires two-part variable format:

1. Keyword (e.g., `media:`)
2. Reference name from relevant store

```
$CMS_REF(media:imageReference)$
```

## Variable Scope and Lifecycle

### Scope Hierarchy

Variables in FirstSpirit follow a hierarchical scope structure:

1. **Template-level**: Variables defined in specific templates
2. **Template Set-level**: Variables accessible across template set tabs
3. **Global-level**: System objects and global variables accessible project-wide

### Execution Timing

- **Header functions**: Execute only once during page generation
- **Body variables**: Evaluated during runtime
- **Form variables**: Populated by editor input before generation
- **Schedule variables**: Applied during project generation, overriding other definitions

### Variable Manipulation

Variables can be modified through:
- Instructions (e.g., `$CMS_SET(...)$`)
- Operations and Expressions
- Methods (e.g., `.isNull()`, `.isEmpty()`)
- Functions

**Important:** Variable manipulation is only possible in template set tabs, not in form definitions.

## Variables in Metadata

### Definition

Metadata variables require a metadata template (a page template created in the Template Store and designated in ServerManager project properties). Editors input content through the "Metadata" tab in SiteArchitect using defined input components.

### Key Characteristics

**Language Independence:**

Metadata is not language-dependent. For labeling input components (`_LANGINFOS_` / `_LANGINFO_`), only the fallback definition (`lang="*"`) is used.

**Component Limitations:**

Certain input components like `CMS_INPUT_DOMTABLE` cannot be emptied once data is entered. Avoid using fall-back values in metadata templates.

### Accessing Metadata Variables

Metadata variable content is accessed using the `#global` system object with the `.meta()` method:

```
$CMS_VALUE(#global.meta.md_keywords)$
```

Variables must have unique identifiers within the metadata template.

### Inheritance Models

Three inheritance approaches are available:

**none:**
- No inheritance from parent nodes
- Only current node metadata is used

**inherit:**
- If no metadata is stored on the current node, the next highest node of the store is used
- Single-level parent inheritance

**add:**
- All higher level nodes are considered, starting from the root node
- Cumulative inheritance from entire hierarchy

**Inheritance Warning:**

With additive inheritance (`add`), editors see only current-node metadata in the interface, not inherited values. This can cause user errors during editing as the complete effective metadata is not visible.

## System Objects

FirstSpirit provides system-maintained variables prefixed with `#` (e.g., `#global`) that offer built-in functionality. These objects provide access to:

- Global project settings
- Current context information
- Metadata via `.meta()` method
- Navigation structures
- Media references

## Best Practices

### Identifier Management

1. **Use consistent prefixes** following the coding conventions to indicate variable origin
2. **Never change identifiers** after creation to preserve project references
3. **Ensure uniqueness** across the entire project to prevent overwrites
4. **Avoid hyphens** and use underscores for multi-word identifiers

### Value Handling

1. **Implement null checks** using `isNull()` or `isEmpty()` methods
2. **Avoid `default` and `isSet()`** which suppress debugging information
3. **Escape special characters** properly in string assignments
4. **Use mandatory fields** (`allowEmpty="no"`) where appropriate

### Template Organization

1. **Place `CMS_VALUE` definitions before `CMS_FUNCTION` tags** in header areas
2. **Define variables in appropriate areas** based on who needs to modify them:
   - Form area for editor-managed content
   - Header area for developer-defined constants
   - Body area for runtime calculations
3. **Use metadata templates** for cross-cutting node attributes

### Metadata Considerations

1. **Avoid fall-back values** in metadata templates, especially with components that cannot be emptied
2. **Choose appropriate inheritance model** based on content structure needs
3. **Document inheritance behavior** for editors when using `add` model
4. **Use unique identifiers** with `md_` prefix for metadata variables

### Performance

1. **Leverage header functions** that execute only once per generation
2. **Minimize complex expressions** in frequently-accessed variables
3. **Use schedule variables** to override values efficiently during generation

## Common Pitfalls

1. **Duplicate identifiers** causing unexpected overwrites
2. **Accessing form variables in header area** (not allowed)
3. **Incorrect order of CMS_VALUE and CMS_FUNCTION** in headers
4. **Using special characters without proper escaping**
5. **Relying on `default` or `isSet()`** instead of proper null checks
6. **Editing confusion with additive metadata inheritance**
7. **Changing identifiers after initial creation** breaking references

## Related Concepts

- Template Contexts
- System Objects (`#global`, etc.)
- CMS Instructions (`$CMS_VALUE$`, `$CMS_REF$`, `$CMS_SET$`)
- Input Components
- Template Sets
- Metadata Templates
- Generation Schedules