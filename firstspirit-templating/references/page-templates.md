# Page Templates Reference

## Overview

Page templates provide the basic framework for pages in FirstSpirit. They serve as the foundational structure that establishes the layout and configuration for web content, containing information on the placement of elements such as logos and navigation tools, general settings, and definitions for locations where editors can insert content.

According to FirstSpirit documentation, "The first step in template development within a new project is to create a page template." Page templates incorporate both unchanging design elements (like navigation and logos) and reusable input components that can be used once per page (such as page titles).

## Page Template Structure

The FirstSpirit workspace organizes page templates through five configurable tabs:

### 1. Properties Tab

Houses all essential settings and configuration options needed for the page template. This tab contains the fundamental configuration that defines how the page template behaves.

### 2. Form Tab

Defines the input components that comprise the page's editing interface. This is where you specify what content editors can input and modify. Input components are defined within `<CMS_MODULE>` tags and enable editors to enter content for different page areas.

### 3. Rules Tab

Enables creation of rules to control elements and their properties. Rules provide dynamic behavior based on conditions and user actions.

### 4. Snippet Tab

Determines how pages appear within overview lists and preview displays. This tab is crucial for providing rich previews in SiteArchitect and ContentCreator.

### 5. Template Set Tab

Specifies the content presentation format within template sets. This controls how the content is ultimately rendered in different output channels.

## Working with Page Templates

### Development Workflow

Page template development follows a structured approach:

1. **Create new page templates** - Establish the foundation for your pages
2. **Define input components** - Set up fields for user data entry
3. **Configure content areas** - Create locations for flexible content placement
4. **Build navigation systems** - Establish website navigation structure
5. **Generate HTML output** - Define how templates render as web pages

### Key Principles

Page templates establish a standardized structure that allows content editors to add materials to predefined content zones while maintaining consistent design and layout across pages. This system balances template designer control with editor flexibility for content insertion.

## Input Components in Page Templates

Input components are the building blocks of the Form tab, enabling editors to enter and manage content.

### CMS_INPUT_TEXT Component

The `CMS_INPUT_TEXT` component provides a single-line or multi-line text field suitable for various text input needs.

#### Basic Structure

```xml
<CMS_INPUT_TEXT name="uniqueName" hFill="yes" singleLine="no" useLanguages="yes">
    <LANGINFOS>
        <LANGINFO lang="*" label="Default Label" description="Default description"/>
        <LANGINFO lang="DE" label="German Label" description="German description"/>
    </LANGINFOS>
</CMS_INPUT_TEXT>
```

#### Common Attributes

- **`name`** - Unique identifier used to access stored content throughout the template
- **`hFill="yes"`** - Displays the component at full width within the form
- **`singleLine="no"`** - Renders as multi-line text field with visible border
- **`useLanguages="yes"`** - Stores different values per language, enabling multilingual content
- **`maxInputLength`** - Character limit for input (e.g., `"40"`)
- **`allowEmpty="yes"`** - Makes the field optional; editors can leave it blank

### LANGINFO Elements

LANGINFO elements specify language-specific labels and descriptions for input components:

```xml
<LANGINFOS>
    <LANGINFO lang="*" label="Default Label" description="Tooltip text"/>
    <LANGINFO lang="DE" label="Deutsche Bezeichnung" description="Deutsche Beschreibung"/>
    <LANGINFO lang="EN" label="English Label" description="English description"/>
</LANGINFOS>
```

- **`lang="*"`** - Default fallback for languages not explicitly listed
- **`lang="DE"`** - German language variant
- **`label`** - Display text shown in the form editor
- **`description`** - Tooltip text displayed on mouseover

### CMS_GROUP Component

The `CMS_GROUP` component organizes related inputs into logical sections:

```xml
<CMS_GROUP name="groupName" tabs="top">
    <LANGINFOS>
        <LANGINFO lang="*" label="Group Label"/>
    </LANGINFOS>

    <CMS_TAB name="tab1">
        <LANGINFOS>
            <LANGINFO lang="*" label="Tab 1"/>
        </LANGINFOS>
        <!-- Input components here -->
    </CMS_TAB>

    <CMS_TAB name="tab2">
        <LANGINFOS>
            <LANGINFO lang="*" label="Tab 2"/>
        </LANGINFOS>
        <!-- Input components here -->
    </CMS_TAB>
</CMS_GROUP>
```

The `tabs="top"` attribute positions tab labels above the grouped sections, creating an organized interface for editors.

### Practical Example

Here's a complete example grouping two inputs for page metadata:

```xml
<CMS_GROUP name="pageMetadata" tabs="top">
    <LANGINFOS>
        <LANGINFO lang="*" label="Page Metadata"/>
    </LANGINFOS>

    <CMS_TAB name="headline">
        <LANGINFOS>
            <LANGINFO lang="*" label="Headline"/>
        </LANGINFOS>

        <CMS_INPUT_TEXT name="st_headline" hFill="yes" singleLine="no" useLanguages="yes" maxInputLength="40">
            <LANGINFOS>
                <LANGINFO lang="*" label="Page Headline" description="Main headline displayed on the page (max 40 characters)"/>
            </LANGINFOS>
        </CMS_INPUT_TEXT>
    </CMS_TAB>

    <CMS_TAB name="browserTitle">
        <LANGINFOS>
            <LANGINFO lang="*" label="Browser Title"/>
        </LANGINFOS>

        <CMS_INPUT_TEXT name="st_browser_title" hFill="yes" singleLine="no" useLanguages="yes" allowEmpty="yes">
            <LANGINFOS>
                <LANGINFO lang="*" label="Browser Title" description="Title displayed in browser tab (optional)"/>
            </LANGINFOS>
        </CMS_INPUT_TEXT>
    </CMS_TAB>
</CMS_GROUP>
```

This example creates:
- A page headline field (required, maximum 40 characters)
- A browser title field (optional, no character limit)
- Both fields organized in separate tabs for logical organization during content editing

## Content Insertion Locations

Page templates define specific locations where editors can insert content. These predefined content zones allow editors to add materials while maintaining consistent design and layout across pages. This approach ensures that:

- Template designers maintain control over the overall structure
- Editors have flexibility to add and manage content within defined areas
- The site maintains visual and structural consistency
- Content can be easily managed and updated without affecting the template structure

## Snippet Tab Configuration

The Snippet tab defines how pages appear in search results and other locations within SiteArchitect and ContentCreator. Rather than displaying only a page name, it enables a richer preview experience.

### Purpose

The Snippet tab provides editors with "a clear presentation of the content of the search hit" to identify relevant results quickly and locate target objects more efficiently than viewing names alone.

### Key Components

The Snippet tab allows configuration of three preview elements:

1. **Thumbnail** - An image representation of the page
2. **Label** - A title for the search result or preview
3. **Extract** - A text excerpt section providing context

### Configuration Approach

Editors can combine multiple input components from the Form tab to customize the display output. The system supports methods compatible with `[$CMS_VALUE(...)$]` functions, allowing conditional display based on editorial content inputs.

#### Example Configuration

```xml
<!-- Snippet configuration example -->
<THUMBNAIL>
    [$CMS_VALUE(pt_image.thumbnail)$]
</THUMBNAIL>

<LABEL>
    [$CMS_VALUE(st_headline)$]
</LABEL>

<EXTRACT>
    [$CMS_VALUE(st_teaser_text)$]
</EXTRACT>
```

### Fallback Behavior

When editors haven't filled in a specified input component, the system provides automatic fallbacks:

- **Default Label**: The page name displays as the title
- **Default Extract**: The path to the search result displays as text
- **Path Display**: The path always displays in ContentCreator regardless of configuration

### Benefits

This configuration approach offers several advantages:

- **Enhanced Discoverability**: Richer previews help editors locate content faster
- **Context at a Glance**: Editors can understand page content without opening it
- **Improved Workflow**: Reduces time spent searching for specific pages
- **Better Content Management**: Visual and textual previews improve content organization

### Access in Interface

In compact view within the FirstSpirit interface, the Snippet tab is represented by a snippet icon. Toolbar functions and additional details are documented in the Composition of templates section.

## Best Practices

When working with page templates, consider these recommendations:

1. **Plan Your Structure**: Design your page template structure before implementation, considering both static elements and dynamic content areas

2. **Use Meaningful Names**: Choose descriptive names for input components that clearly indicate their purpose (e.g., `st_headline`, `pt_image`, `st_teaser_text`)

3. **Implement Language Support**: Enable `useLanguages="yes"` for components that need multilingual content

4. **Group Related Components**: Use `CMS_GROUP` to organize related input components logically, improving the editor experience

5. **Configure Snippet Previews**: Always configure the Snippet tab to provide meaningful previews for editors

6. **Set Appropriate Constraints**: Use `maxInputLength` and `allowEmpty` attributes to guide editors and maintain content consistency

7. **Provide Clear Labels**: Write descriptive labels and descriptions for all input components to guide editors

8. **Balance Flexibility and Control**: Define content insertion locations that give editors flexibility while maintaining design consistency

## Summary

Page templates are the foundational element of FirstSpirit template development. They establish the framework for pages by:

- Defining the overall page structure through five configurable tabs (Properties, Form, Rules, Snippet, Template Set)
- Providing input components for editors to enter and manage content
- Establishing locations where content can be inserted
- Configuring how pages appear in previews and search results
- Balancing template designer control with editor flexibility

By understanding and effectively utilizing page templates, developers can create robust, maintainable, and editor-friendly content management solutions in FirstSpirit.
