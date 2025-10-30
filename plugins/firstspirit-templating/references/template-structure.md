# Template Structure and Composition

## Overview

Templates form the foundational framework for FirstSpirit websites, serving as the architectural blueprint that connects content from the Page Store and Media Store to the Site Store structure. All templates are centrally maintained in the FirstSpirit **Template Store**, providing a single source of truth for template definitions across projects.

Templates establish consistent, reusable structures that define element placement, content insertion points, and presentation logic. This modular approach enables administrators and developers to create maintainable website architectures while giving content editors the flexibility to manage dynamic content within predefined boundaries.

## Template Types

FirstSpirit provides several template types, each serving specific purposes within the content management system:

### Page Templates

Page templates provide the basic framework for a page, specifying:
- Element placement (logos, navigation, design elements)
- Frame structure and layout
- Designated areas where editors can insert content
- Overall page architecture and hierarchy

Page templates serve as the structural blueprint that contains information about where fixed design elements appear and where dynamic content sections can be placed.

### Section Templates

Section templates insert content into the page framework established by page templates. They feature:
- Individually configured input fields for editorial content
- Support for dynamic content (text, tables, images, datasets)
- Multiple sections per page with various templates for different content types
- Flexible content organization within page structure

Multiple sections can be added to each section area, with several different section templates typically available for different types of potential content found on a page.

### Format Templates

Format templates define text formatting within the system:
- Work with DOM and DOMTABLE input components
- Control text styling and appearance
- Include specialized variants for specific use cases

**Specialized Format Template Variants:**
- **Table Format Templates**: Define formatting for tabular data
- **Style Templates**: Enable integration of inline tables into continuous text

### Link Templates

Link templates define link appearance and behavior within projects:
- Specify input fields editors use to enter link content
- Control HTML output for links
- Standardize link presentation across the project
- Enable consistent link management

### Scripts

Scripts enable automation of operating sequences in FirstSpirit:
- Automate different types of processes
- Enable modifications to data structures
- Extend FirstSpirit functionality programmatically
- Support custom business logic implementation

### Database Schemata

Database schemata provide data structure management:
- Graphical schema editors for creating and modifying database tables
- Associated table templates for data presentation
- Query tools for dataset filtering
- Integration with FirstSpirit content model

### Workflows

Workflows define structured task sequences:
- Fixed, predefined task structures
- Defined due dates and deadlines
- Authorized personnel groups for each task
- Process management and approval chains

## Template Tab Structure

Both page templates and section templates share a common five-tab structure in the SiteArchitect editing interface. Understanding these tabs is essential for effective template development and maintenance.

### Properties Tab

The Properties tab contains all configuration settings required for the template:

**Purpose:**
- General template configuration
- Metadata definition
- Template identification and naming
- Core settings that apply to the entire template

**Key Settings:**
- Template name and identifier
- Description and documentation
- Global template properties
- Template categorization

### Form Tab

The Form tab defines the input components and data fields available to editors:

**Purpose:**
- Define input components for content entry
- Specify data fields and their types
- Configure editorial interface
- Establish content structure

**Content Types Supported:**
- Text fields and text areas
- Rich text editors (DOM components)
- Image selectors
- Dataset references
- Tables and structured data
- Custom input components

**Key Considerations:**
- Input component selection determines editor experience
- Field configuration affects content validation
- Component arrangement impacts usability
- Data binding connects form fields to output

### Rules Tab

The Rules tab enables conditional logic and dynamic behavior:

**Purpose:**
- Define conditional logic
- Influence elements or properties based on criteria
- Create dynamic template behavior
- Implement business rules

**Common Use Cases:**
- Show/hide fields based on other field values
- Conditional validation rules
- Dynamic default values
- Field dependency management
- Workflow automation triggers

**Benefits:**
- Reduces editor complexity by hiding irrelevant fields
- Ensures data consistency
- Enforces business logic
- Creates intelligent, context-aware templates

### Snippet Tab

The Snippet tab controls how pages appear in overview lists and summary views:

**Purpose:**
- Define preview representation
- Configure list view appearance
- Specify summary information
- Control thumbnail generation

**Typical Applications:**
- News article listings
- Product catalogs
- Search results
- Navigation menus
- Content aggregation pages

**Configuration Elements:**
- Preview text extraction
- Thumbnail image selection
- Metadata display
- Custom snippet formatting

### Template Set Tab

The Template Set tab determines content presentation and structure within the template set environment:

**Purpose:**
- Define content appearance in template sets
- Specify output generation rules
- Configure multi-channel delivery
- Control presentation logic

**Key Functions:**
- HTML generation rules
- CSS and JavaScript integration
- Output formatting specifications
- Template set-specific behavior

## Template Organization and Hierarchy

### Template Store Structure

All templates reside in the centrally maintained Template Store, providing:
- Single source of truth for template definitions
- Version control and template management
- Reusability across projects
- Consistent template governance

### Template Composition Patterns

Templates work together in a hierarchical relationship:

```
Page Template (Framework)
├── Header Section Area
│   └── Section Template (Header)
├── Main Content Area
│   ├── Section Template (Text Content)
│   ├── Section Template (Image Gallery)
│   └── Section Template (Data Table)
└── Footer Section Area
    └── Section Template (Footer)
```

### Relationship Between Template Types

**Page-to-Section Relationship:**
- Page templates establish the framework
- Section templates populate content areas
- Multiple section templates can coexist on one page
- Section areas are defined within page templates

**Content Flow:**
1. Page template defines overall structure and section areas
2. Editors select appropriate section templates for each area
3. Section templates provide input forms for content entry
4. Content renders according to template set specifications
5. Format templates apply styling to rich text content
6. Link templates standardize link presentation

## Common Template Patterns

### Multi-Section Content Pages

**Pattern:** Page template with multiple distinct content areas

**Structure:**
- Header area (fixed section template)
- Main content area (flexible section templates)
- Sidebar area (optional section templates)
- Footer area (fixed section template)

**Benefits:**
- Maximum editor flexibility
- Consistent page structure
- Content variety within constraints

### Single-Purpose Templates

**Pattern:** Page template designed for specific content type

**Examples:**
- News article templates
- Product detail pages
- Contact forms
- Landing pages

**Benefits:**
- Optimized for specific use case
- Streamlined editor interface
- Purpose-specific validation rules

### Container Templates

**Pattern:** Minimal page template that serves primarily as section container

**Characteristics:**
- Lightweight page structure
- Maximum flexibility for section arrangement
- Focus on content rather than fixed design elements

**Use Cases:**
- Dynamic landing pages
- Marketing campaign pages
- Flexible content assemblies

### Structured Data Templates

**Pattern:** Templates with extensive form definitions for structured content

**Characteristics:**
- Complex form tab configurations
- Multiple input components
- Extensive validation rules
- Database integration

**Use Cases:**
- Product catalogs
- Event calendars
- Directory listings
- Data-driven content

## Common Features Across Templates

Multiple template types include standard editing functionality:

### Editor Features

**Search and Replace:**
- Find text within template code
- Replace across multiple occurrences
- Regular expression support

**Undo/Redo:**
- Revert changes during editing
- Step through edit history
- Recover from mistakes

**Line Numbers:**
- Toggle line number display
- Navigate to specific lines
- Reference code locations

**Code Completion:**
- Auto-suggest functionality
- Syntax assistance
- Faster template development

## Best Practices for Template Structure

### Modularity

**Principle:** Design templates as reusable, self-contained units

**Implementation:**
- Create generic section templates for common content types
- Avoid hard-coding content in templates
- Use parameters for configurable behavior
- Design for reuse across multiple page types

### Separation of Concerns

**Principle:** Keep structure, content, and presentation separate

**Implementation:**
- Page templates focus on structure
- Section templates focus on content
- Template sets focus on presentation
- Rules handle business logic

### Editor Experience

**Principle:** Design templates with content editors in mind

**Implementation:**
- Logical form field organization
- Clear field labels and help text
- Intuitive input component selection
- Progressive disclosure of advanced options
- Validation that guides rather than frustrates

### Maintainability

**Principle:** Create templates that are easy to update and debug

**Implementation:**
- Consistent naming conventions
- Comprehensive template documentation
- Clear code comments
- Logical organization of template code
- Version control integration

### Performance Considerations

**Principle:** Design efficient templates that generate quickly

**Implementation:**
- Minimize complex calculations in templates
- Optimize database queries
- Avoid redundant processing
- Cache where appropriate

## Template Development Workflow

### Planning Phase

1. **Identify Requirements:**
   - Content types needed
   - Editorial workflows
   - Output channels
   - Business rules

2. **Design Structure:**
   - Sketch page layouts
   - Define section areas
   - Plan input components
   - Map content relationships

### Implementation Phase

1. **Create Page Templates:**
   - Configure Properties tab
   - Define section areas
   - Set up basic structure

2. **Develop Section Templates:**
   - Design Form tab layout
   - Configure input components
   - Define validation rules

3. **Implement Logic:**
   - Add Rules tab conditions
   - Configure Snippet tab
   - Set up Template Set output

### Testing Phase

1. **Functional Testing:**
   - Verify input components work correctly
   - Test validation rules
   - Confirm conditional logic

2. **Editor Testing:**
   - Evaluate usability
   - Gather editor feedback
   - Refine interface

3. **Output Testing:**
   - Verify generated HTML
   - Test across channels
   - Validate accessibility

### Deployment Phase

1. **Documentation:**
   - Editor guidelines
   - Technical documentation
   - Known limitations

2. **Training:**
   - Editor training sessions
   - Reference materials
   - Support resources

3. **Monitoring:**
   - Track template usage
   - Gather feedback
   - Identify improvement opportunities

## Summary

FirstSpirit templates provide a robust, hierarchical framework for content management. Understanding template structure and composition is essential for effective FirstSpirit development. The five-tab structure (Properties, Form, Rules, Snippet, Template Set) provides comprehensive control over template behavior, while the relationship between page templates and section templates enables flexible, maintainable website architectures.

By following established patterns and best practices, developers can create templates that balance editorial flexibility with structural consistency, resulting in efficient content management workflows and high-quality output across multiple channels.