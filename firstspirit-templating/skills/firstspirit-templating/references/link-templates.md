# Link Templates

## Overview

Link templates in FirstSpirit are specialized templates that implement hyperlinks within web projects. They enable consistent link formatting and behavior across an entire project. Links serve multiple purposes: facilitating site navigation, directing users to additional information, providing access to downloadable files, and connecting to external resources.

Unlike page templates or section templates, link templates function as reusable components that are integrated into input components rather than being directly deployed. Template developers use link templates to establish standardized link handling and presentation throughout FirstSpirit projects.

## Link Template Structure

Each link template consists of five main configuration areas:

### 1. Properties Tab
Contains all essential link template settings and basic configuration options.

### 2. Form Tab
Defines input components for pages, allowing editors to configure link properties and content.

### 3. Rules Tab
Enables conditional logic that can affect elements or properties based on specific conditions.

### 4. Snippet Tab
Controls how pages display in overview lists and other aggregated views.

### 5. Template Set Tab
Determines how content appears in template sets and manages template relationships.

## Supported Link Types

FirstSpirit supports eight distinct varieties of links, each serving different purposes:

### 1. Internal Links
References to pages within the same FirstSpirit project, enabling navigation between project content.

### 2. Image Links
Clickable images that function as standalone links without requiring separate target definitions.

### 3. Download Links
Links that trigger file retrieval, allowing users to download documents, media, or other resources.

### 4. External Links
Links to destinations outside the current FirstSpirit project, pointing to other websites or web resources.

### 5. E-mail Links
Mailto links that open the user's default email client with a pre-populated address.

### 6. Dataset Links
Links to database records, connecting to structured data stored in FirstSpirit databases.

### 7. Remote Links
References to content in other FirstSpirit remote projects, enabling cross-project linking.

### 8. Image Map Links
Mouse-sensitive images with multiple clickable regions, each potentially linking to different destinations.

## Using Link Templates

### Integration with Input Components

Link templates are accessed through specialized input components in FirstSpirit. They are not deployed directly but rather integrated into forms where editors can select and configure them.

#### Primary Input Components for Links

**Direct Link Components:**
- `FS_CATALOG` with `type="link"` and `<TEMPLATES type="link"/>`
- `CMS_INPUT_LINK`

**Components Supporting Links Among Other Content:**
- `CMS_INPUT_DOM` - Supports text, images, and links within rich content
- `CMS_INPUT_DOMTABLE` - Table-based content with embedded link support
- `CMS_INPUT_IMAGEMAP` - Image maps with clickable regions

### Limiting Available Link Templates

By default, all link templates in the project are available to editors for selection in input components. To restrict which link templates can be chosen, use the following approaches:

#### For CMS_INPUT_LINK, CMS_INPUT_DOM, CMS_INPUT_DOMTABLE, and CMS_INPUT_IMAGEMAP

Use `LINKEDITORS` and `LINKEDITOR` tags to specify allowed templates:

```xml
<CMS_INPUT_DOM name="contentWithLinks" hFill="yes">
  <LINKEDITORS>
    <LINKEDITOR name="internalLink"/>
    <LINKEDITOR name="externalLink"/>
  </LINKEDITORS>
</CMS_INPUT_DOM>
```

This configuration limits the available link templates to only "internalLink" and "externalLink" templates.

#### For FS_CATALOG

Use `TEMPLATE` with `uid` tags to specify allowed link templates:

```xml
<FS_CATALOG name="linkCatalog" type="link">
  <TEMPLATES type="link">
    <TEMPLATE uid="internalLink"/>
    <TEMPLATE uid="downloadLink"/>
  </TEMPLATES>
</FS_CATALOG>
```

### Language Handling

Link templates have specific language-handling requirements:

- **Input components within link templates** can only be defined independently of language using the `useLanguages="no"` parameter
- **For language-dependent link content**, the parent input component (the one that includes the link template) must use `useLanguages="yes"`

This design ensures that language-specific content is managed at the appropriate level of the template hierarchy.

## Link Template Flexibility

FirstSpirit provides substantial flexibility in link template configuration:

- Default options can be freely arranged in most cases
- Linked images can function across multiple link types
- A single image can serve as an internal navigation element, external resource link, or media download trigger
- Template developers have significant control over link appearance and behavior

## Important Considerations

### Preview Functionality

After modifying link templates, preview functionality may not immediately reflect recently entered content. To resolve this issue:

1. Save the input masks again
2. This will refresh the preview to display current content

### Template Availability

When implementing input components that use link templates, consider:

- Whether all project link templates should be available
- Which specific templates are appropriate for each use case
- How to guide editors toward correct template selection through strategic limitation

## Best Practices

1. **Limit template selection** - Use LINKEDITORS or TEMPLATE tags to provide only relevant link templates for each input component
2. **Consistent naming** - Use clear, descriptive names for link templates that indicate their purpose (e.g., "internalLink", "downloadLink", "externalLink")
3. **Language planning** - Plan language-dependent content at the parent component level, keeping link template internals language-independent
4. **Testing previews** - After template modifications, always save input masks again to ensure previews reflect current content
5. **Documentation** - Document which link types are used in your project and their intended purposes for other developers and editors
