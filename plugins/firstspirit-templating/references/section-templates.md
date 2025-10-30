# Section Templates

## Overview

Section templates are content containers within FirstSpirit pages that add dynamic content to the basic framework defined by page templates. They serve as the primary mechanism for defining input components that will contain dynamic page content such as text, tables, images, datasets, and other content types.

### Key Characteristics

- **Purpose**: Add content to the basic framework of a page defined by the page template
- **Flexibility**: Multiple section templates can be created for different content types on a single page
- **Scalability**: Any number of sections can be added to each section area of a page
- **Configuration Similarity**: Section templates function similarly to page templates in their configuration approach

## Section Template Structure

Section templates are configured through five main tabs in the SiteArchitect editor:

### 1. Properties Tab

Contains all required settings for the template, including:
- Template identification and naming
- Basic configuration parameters
- Template metadata

### 2. Form Tab

Defines the input components for the section's content. This is where you specify what types of dynamic content the section will support:
- Text input components
- Image selectors
- Dataset references
- Table components
- Custom input elements

### 3. Rules Tab

Enables conditional logic to influence elements and properties:
- Define rules that control template behavior
- Set conditions for displaying or hiding elements
- Configure property dependencies

### 4. Snippet Tab

Controls how the section appears in overview lists:
- Define preview representations
- Configure snippet display format
- Control list view appearance

### 5. Template Set Tab

Defines how content appears within the template set framework. See the Template Sets section below for detailed information.

## Creating Section Templates

All input components that contain dynamic page content (text, tables, images, datasets, etc.) are defined within a section template. Follow this step-by-step process to create section templates:

### Step 1: Open the Edit Entry View

Access the HTML file editor and select the relevant HTML area to trigger an overlay window.

### Step 2: Identify the Target Section

Move your cursor within the preview until the correct DIV element is highlighted with a frame border. This visual feedback ensures you're targeting the correct container element.

### Step 3: Access the Add Component Dialog

Click the identified entry in the overlay to open the configuration options dialog.

### Step 4: Configure the Component

When configuring the section template component:

1. **Assign a descriptive name**: Use meaningful names that describe the content purpose (e.g., "teaser", "hero_section", "article_body")

2. **Select component type**: Choose "Section template" as the component type from the available options

3. **Replace entire HTML tag option**: Leave the "Replace entire HTML tag" checkbox unchecked by default
   - When checked, this option replaces the entire HTML element with FirstSpirit-specific syntax
   - In most use cases, this should remain unchecked to preserve the HTML structure

### Step 5: Save and Transfer

Click Create to finalize the configuration, then save changes to transfer the component to the Overview tab where it can be further edited and managed.

## Variant Detection

The template wizard includes an automatic variant detection feature that recognizes different template variants when the VARIANT component template is enabled in project Settings.

### Benefits of Variant Detection

- **Single Template, Multiple Designs**: A single section template can accommodate optional components and multiple design variations
- **Reduced Duplication**: Eliminates the need to create separate section templates for similar content with minor variations
- **Streamlined Management**: Simplifies template maintenance by consolidating variants into a single template definition

### How It Works

When variant detection is enabled:
1. The template wizard automatically identifies variant patterns in the HTML structure
2. Different design variations are recognized and mapped to the same section template
3. Optional components are detected and can be toggled on/off without requiring separate templates

## Input Components for Dynamic Content

Section templates define input components for various types of dynamic page content. The Form tab is where these components are configured.

### Common Input Component Types

#### Text Components
- Rich text editors for formatted content
- Plain text fields for simple text input
- Multi-line text areas for longer content

#### Image Components
- Image selectors for media library integration
- Image upload interfaces
- Image metadata configuration (alt text, captions, etc.)

#### Table Components
- Data table definitions
- Column and row configuration
- Cell formatting options

#### Dataset Components
- References to database content
- Dataset query configurations
- Related content connections

## Template Sets

Template sets are administrator-configured components within FirstSpirit projects that enable content management and processing.

### What Are Template Sets?

A unique tab is displayed for each template set added by the administrator for a project in the ServerManager. Template sets provide a framework where developers can check, process, and evaluate entries from the Page Store.

### Primary Function

The template set tab serves as a workspace for defining:
- Website functionality
- Content appearance
- Dynamic content processing

The most common implementation is the HTML template set, which allows developers to define website output through source code.

### Structural Organization

Template set content divides into two distinct regions:

#### 1. CMS_HEADER Area

The header area is reserved for function definitions such as:
- Navigation setup
- Dataset output configuration
- Function declarations
- Variable definitions

**Important Note**: `$CMS_(...)` instructions are NOT processed within the CMS_HEADER section. This area is strictly for function definitions.

#### 2. Output Area

The output area supports:
- `$CMS_(...)` instructions for dynamic content
- HTML code for structure and layout
- FirstSpirit syntax for displaying website content
- Template logic and control structures

### Development Features

#### Automatic Code Completion

The template set editor provides automatic code completion for tags starting with `$`, which streamlines template development by:
- Suggesting available FirstSpirit tags
- Reducing syntax errors
- Improving development speed

#### Example Structure

```html
$CMS_HEADER(
  // Function definitions
  // Navigation setup
  // Variable declarations
)$

<!-- Output Area -->
<div class="section-content">
  $CMS_VALUE(st_text)$
  $CMS_RENDER(template:"image_component")$
</div>
```

### Role in Section Templates

Template set tabs function as integral components of section template architecture. They allow developers to:
1. Translate Page Store content into rendered HTML output
2. Apply dynamic FirstSpirit functionality to content
3. Control the final appearance and behavior of section content
4. Integrate with the broader page framework

## Best Practices

### Naming Conventions
- Use descriptive, meaningful names for section templates (e.g., "article_teaser", "hero_banner", "content_body")
- Follow consistent naming patterns across your project
- Use lowercase with underscores or camelCase for clarity

### Template Organization
- Group related section templates logically
- Create reusable section templates for common content patterns
- Document template purpose and usage in comments or metadata

### Variant Usage
- Enable variant detection when you have similar content with minor variations
- Use variants to reduce template proliferation
- Keep variant logic simple and maintainable

### Content Separation
- Use the CMS_HEADER area for all function definitions
- Keep output logic in the designated output area
- Separate concerns: structure (HTML), style (CSS references), and behavior (FirstSpirit logic)

### Input Component Design
- Define clear, intuitive input components for content editors
- Provide appropriate defaults where possible
- Include help text or documentation for complex components
- Consider the editor's workflow when designing the form layout

## Common Use Cases

### 1. Article Teaser Section
A section template for displaying article previews with:
- Headline text input
- Teaser text area
- Featured image selector
- Link to full article

### 2. Hero Banner Section
A full-width banner section with:
- Background image component
- Headline and subheadline text fields
- Call-to-action button configuration
- Overlay opacity settings

### 3. Content Body Section
The main content area with:
- Rich text editor for article body
- Embedded image support
- Table insertion capability
- Dataset references for related content

### 4. Data-Driven Section
Sections that pull from database content:
- Dataset query configuration
- Display template for dataset items
- Filtering and sorting options
- Pagination controls

## Integration with Page Templates

Section templates work in conjunction with page templates to create complete pages:

1. **Page Template**: Defines the overall page structure, layout framework, and section areas
2. **Section Templates**: Fill the section areas with specific content types and functionality
3. **Content Areas**: Designated regions in page templates where section templates can be added

Multiple sections using different section templates can be added to each section area, providing flexible content composition capabilities.

## Summary

Section templates are essential building blocks in FirstSpirit's templating architecture. They provide:
- Structured content input through configurable form components
- Flexible content rendering through template sets
- Reusable content patterns across multiple pages
- Dynamic content integration with the page framework

By understanding section template structure, creation process, and template set configuration, developers can create powerful, flexible content management solutions that serve both editor and end-user needs effectively.