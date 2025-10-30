# FirstSpirit Metadata Templates and Properties

## Overview

Metadata in FirstSpirit provides additional information about objects beyond their primary content. This includes both system-assigned metadata (modification dates, version numbers, editing users) and user-defined metadata that can be customized through metadata templates.

## What is Metadata?

Metadata consists of "additional information available for an object in FirstSpirit." It serves two primary purposes:

1. **System-assigned metadata**: Automatically generated information such as:
   - Last modification date
   - Editing user
   - Release authorization status
   - Version numbers
   - Integrated media counts

2. **User-defined metadata**: Custom information managed by users through the Metadata tab, requiring:
   - A metadata template definition
   - Appropriate permissions in Permission Management

## Metadata Template Configuration

### Creating a Metadata Template

A metadata template must be created as a **page template** in the Template Store. The setup process involves:

1. Create a page template in the Template Store
2. Define input components with unique identifiers
3. Select the template in ServerManager's project properties
4. The template becomes available across all SiteArchitect stores

Once configured, the "Metadata" tab appears in SiteArchitect, allowing editors to input content using the defined input components.

### Visual Indicators

Nodes with specifically assigned metadata display a metadata icon after the object name in the tree structure, making it easy to identify which elements have metadata configured.

## Accessing Metadata Information

### The .meta() Method

To output metadata variable content in template sets, use the system object `#global` with the `.meta()` method:

```java
$CMS_VALUE(#global.meta("metadata_identifier"))$
```

Each input component in the metadata template receives a unique identifier that is used to access its value.

### Example: Accessing Metadata Variables

```java
// Access a simple text metadata field
$CMS_VALUE(#global.meta("author"))$

// Access a date metadata field
$CMS_VALUE(#global.meta("publish_date"))$

// Access a checkbox metadata field
$CMS_VALUE(#global.meta("featured"))$
```

## Metadata Inheritance

FirstSpirit provides three inheritance options that control how metadata behaves in the content hierarchy:

### 1. No Inheritance (none)

```xml
<CMS_INPUT_TEXT name="title" inheritance="none">
    <LANGINFOS>
        <LANGINFO lang="*" label="Title"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>
```

No inheritance from parent nodes occurs. Only the metadata defined on the current node is used.

### 2. Inherit from Parent (inherit)

```xml
<CMS_INPUT_TEXT name="author" inheritance="inherit">
    <LANGINFOS>
        <LANGINFO lang="*" label="Author"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>
```

If the current node lacks metadata, the system searches parent nodes upward in the hierarchy until a value is found.

**Evaluation methods:**
- **Current node only**: Returns value if populated; empty string otherwise
- **Hierarchical inheritance**: Checks current node first, then searches parent nodes upward

### 3. Additive Inheritance (add)

```xml
<CMS_INPUT_TEXT name="keywords" inheritance="add">
    <LANGINFOS>
        <LANGINFO lang="*" label="Keywords"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>
```

Processes all nodes from root downward, aggregating metadata and outputting values separated by delimiters.

**Important**: With additive inheritance, editors see only metadata defined on the current node, not inherited metadata, which can potentially cause user errors.

## Important Constraints and Behaviors

### Language Independence

Metadata is **not language-dependent**. Only fallback definitions (`lang="*"`) apply to input component labels. This means metadata values are shared across all language variants.

### Component Behavior Limitations

Some input components cannot be emptied once populated:
- `CMS_INPUT_DOMTABLE`
- `CMS_INPUT_DOM`
- `CMS_INPUT_RADIOBUTTON`

### Metadata Status

The metadata information icon appears in the project tree only after saving an input. The Metadata tab indicates whether data has been set via checkbox status.

## ELEMENTTYPE Property

The ELEMENTTYPE property checks which element type a form was opened on, enabling dynamic form behavior based on context.

### Syntax

```xml
<PROPERTY source="#global" name="ELEMENTTYPE"/>
```

The `source` attribute must be set to `#global` since it's a system-level property.

### Supported Element Types

The property returns lowercase type names corresponding to API interface names:

**Page Store:**
- `pagestoreroot`
- `pagefolder`
- `page`
- `section`
- `sectionreference`

**Media Store:**
- `mediastoreroot`
- `mediafolder`
- `file`
- `picture`

**Site Store:**
- `sitestoreroot`
- `pagereffolder`
- `pageref`

**Global Content Area:**
- `globalcontentarea`
- `gcapage`

### Usage Context

This expression works in two areas:
1. **Value determination** (`<WITH/>` section)
2. **Preconditions** (`<IF/>` section)

### Practical Example: Conditional Metadata Display

Show specific form elements only for picture elements:

```xml
<RULE>
    <WITH>
        <EQUAL>
            <PROPERTY source="#global" name="ELEMENTTYPE"/>
            <TEXT>picture</TEXT>
        </EQUAL>
    </WITH>
    <DO>
        <PROPERTY source="#form.st_metamedia" name="VISIBLE"/>
    </DO>
</RULE>
```

This rule makes the "st_metamedia" form content visible only when editing image metadata, hiding it on other element types.

### Example: Different Metadata for Different Element Types

```xml
<RULE>
    <WITH>
        <OR>
            <EQUAL>
                <PROPERTY source="#global" name="ELEMENTTYPE"/>
                <TEXT>page</TEXT>
            </EQUAL>
            <EQUAL>
                <PROPERTY source="#global" name="ELEMENTTYPE"/>
                <TEXT>section</TEXT>
            </EQUAL>
        </OR>
    </WITH>
    <DO>
        <PROPERTY source="#form.st_content_metadata" name="VISIBLE"/>
    </DO>
</RULE>
```

This shows content-specific metadata fields only for pages and sections.

## TEMPLATE Property

The TEMPLATE property retrieves the reference name (UID) of the template associated with template-based elements like pages, sections, and datasets.

### Syntax

```xml
<PROPERTY source="#global" name="TEMPLATE"/>
```

### Key Characteristics

**Source Attribute**: Must use `source="#global"` since this is a universally applicable property.

**Scope Behavior**:
- When applied to a page, it returns page template information even if executed within nested components (like paragraphs in FS_CATALOG)
- For metadata, it returns information about the element where the metadata was defined

### Usage Contexts

This property works within:
- Value determination sections (`<WITH/>`)
- Precondition definitions (`<IF/>`)

### Example: Storing Template Information

```xml
<RULE when="ONLOCK">
    <WITH>
        <PROPERTY name="TEMPLATE" source="#global"/>
    </WITH>
    <DO>
        <PROPERTY name="VALUE" source="template_id"/>
    </DO>
</RULE>
```

This rule captures the template identifier during lock operations and assigns it to a value property.

### Example: Template-Specific Metadata Fields

```xml
<RULE>
    <WITH>
        <EQUAL>
            <PROPERTY source="#global" name="TEMPLATE"/>
            <TEXT>news_article</TEXT>
        </EQUAL>
    </WITH>
    <DO>
        <PROPERTY source="#form.st_article_metadata" name="VISIBLE"/>
    </DO>
</RULE>
```

This displays article-specific metadata fields only when the page uses the "news_article" template.

## Practical Metadata Usage Examples

### Example 1: Basic Metadata Template

```xml
<CMS_INPUT_TEXT name="st_title" inheritance="inherit">
    <LANGINFOS>
        <LANGINFO lang="*" label="Page Title"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>

<CMS_INPUT_TEXTAREA name="st_description" inheritance="inherit">
    <LANGINFOS>
        <LANGINFO lang="*" label="Meta Description"/>
    </LANGINFOS>
</CMS_INPUT_TEXTAREA>

<CMS_INPUT_TEXT name="st_keywords" inheritance="add">
    <LANGINFOS>
        <LANGINFO lang="*" label="Keywords"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>

<CMS_INPUT_CHECKBOX name="st_noindex" inheritance="none">
    <LANGINFOS>
        <LANGINFO lang="*" label="No Index"/>
    </LANGINFOS>
</CMS_INPUT_CHECKBOX>
```

### Example 2: Accessing Metadata in HTML Output

```html
<head>
    <title>$CMS_VALUE(#global.meta("st_title"))$</title>
    <meta name="description" content="$CMS_VALUE(#global.meta("st_description"))$">
    <meta name="keywords" content="$CMS_VALUE(#global.meta("st_keywords"))$">
    $CMS_IF(#global.meta("st_noindex"))$
        <meta name="robots" content="noindex, nofollow">
    $CMS_END_IF$
</head>
```

### Example 3: Conditional Metadata Based on Element Type and Template

```xml
<!-- Show SEO fields only for pages -->
<RULE>
    <WITH>
        <EQUAL>
            <PROPERTY source="#global" name="ELEMENTTYPE"/>
            <TEXT>page</TEXT>
        </EQUAL>
    </WITH>
    <DO>
        <PROPERTY source="#form.st_seo_section" name="VISIBLE"/>
    </DO>
</RULE>

<!-- Show image-specific fields only for pictures -->
<RULE>
    <WITH>
        <EQUAL>
            <PROPERTY source="#global" name="ELEMENTTYPE"/>
            <TEXT>picture</TEXT>
        </EQUAL>
    </WITH>
    <DO>
        <PROPERTY source="#form.st_image_metadata" name="VISIBLE"/>
    </DO>
</RULE>

<!-- Show article metadata only for news template -->
<RULE>
    <WITH>
        <AND>
            <EQUAL>
                <PROPERTY source="#global" name="ELEMENTTYPE"/>
                <TEXT>page</TEXT>
            </EQUAL>
            <EQUAL>
                <PROPERTY source="#global" name="TEMPLATE"/>
                <TEXT>news_article</TEXT>
            </EQUAL>
        </AND>
    </WITH>
    <DO>
        <PROPERTY source="#form.st_article_fields" name="VISIBLE"/>
    </DO>
</RULE>
```

### Example 4: Media Metadata Template

```xml
<!-- Common fields for all media -->
<CMS_INPUT_TEXT name="st_copyright" inheritance="inherit">
    <LANGINFOS>
        <LANGINFO lang="*" label="Copyright"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>

<!-- Picture-specific fields -->
<CMS_MODULE name="st_image_details">
    <LANGINFOS>
        <LANGINFO lang="*" label="Image Details"/>
    </LANGINFOS>

    <CMS_INPUT_TEXT name="st_photographer">
        <LANGINFOS>
            <LANGINFO lang="*" label="Photographer"/>
        </LANGINFOS>
    </CMS_INPUT_TEXT>

    <CMS_INPUT_DATE name="st_photo_date">
        <LANGINFOS>
            <LANGINFO lang="*" label="Photo Date"/>
        </LANGINFOS>
    </CMS_INPUT_DATE>

    <RULES>
        <RULE>
            <WITH>
                <EQUAL>
                    <PROPERTY source="#global" name="ELEMENTTYPE"/>
                    <TEXT>picture</TEXT>
                </EQUAL>
            </WITH>
            <DO>
                <PROPERTY source="#module" name="VISIBLE"/>
            </DO>
        </RULE>
    </RULES>
</CMS_MODULE>
```

### Example 5: Accessing Metadata with Fallback

```java
// Access metadata with fallback value
$CMS_SET(author, #global.meta("st_author"))$
$CMS_IF(!author.empty)$
    <meta name="author" content="$CMS_VALUE(author)$">
$CMS_ELSE$
    <meta name="author" content="Default Author">
$CMS_END_IF$
```

## Permissions and Editing

### Permission Requirements

Users can only modify metadata in edit mode with special permissions assigned through Permission Management. Without proper permissions, the Metadata tab will be read-only or unavailable.

### Accessing Metadata in Edit Mode

1. Open an element in edit mode
2. Navigate to the Metadata tab
3. Input or modify metadata values
4. Save to persist changes

The Metadata tab indicates whether data has been set via checkbox status, providing visual feedback on which fields contain values.

## Best Practices

1. **Use inheritance wisely**: Choose the appropriate inheritance mode based on your content structure:
   - Use `inherit` for properties that should cascade down (e.g., author, copyright)
   - Use `add` for cumulative properties (e.g., keywords, tags)
   - Use `none` for page-specific properties (e.g., noindex flag)

2. **Language-independent design**: Remember that metadata is not language-dependent. Design your metadata schema accordingly.

3. **Conditional visibility**: Use ELEMENTTYPE and TEMPLATE properties to show relevant metadata fields for specific contexts, improving editor experience.

4. **Fallback values**: Always handle cases where metadata might not be set, providing sensible defaults.

5. **Clear labeling**: Use descriptive labels in LANGINFO sections to help editors understand what each field is for.

6. **Component selection**: Be aware that some components (CMS_INPUT_DOMTABLE, CMS_INPUT_DOM, CMS_INPUT_RADIOBUTTON) cannot be emptied once populated. Choose components carefully.

7. **Visual feedback**: Remember that the metadata icon only appears after saving, so inform editors about this behavior.

## Summary

Metadata templates in FirstSpirit provide a powerful way to attach additional information to content elements. By leveraging:
- The `.meta()` method for accessing metadata values
- Inheritance options for hierarchical content structures
- ELEMENTTYPE and TEMPLATE properties for conditional display
- Form rules for dynamic metadata forms

You can create flexible, context-aware metadata systems that enhance content management and output generation across your FirstSpirit projects.