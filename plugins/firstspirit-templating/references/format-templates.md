# Format Templates

## Overview

Format templates define text formatting options available to content editors in FirstSpirit. They enable consistent styling through DOM editor and DOM table input components, ensuring brand compliance and content consistency across all output channels.

## Purpose and Core Concepts

Format templates serve as the foundation for text formatting within FirstSpirit's content management system. They provide editors with predefined formatting options that maintain design consistency while preventing unauthorized styling variations.

### Key Characteristics

**Two Types of Formatting:**

1. **Section Formatting**: Applied to entire paragraphs up to line breaks
   - Only available when no text is highlighted
   - Affects complete content blocks
   - Used for structural formatting like headings and paragraphs

2. **Individual Text Formatting**: Applied to selected text only
   - Available when text is highlighted or cursor is within a string
   - Used for inline styling like bold, italic, or underline
   - Applies to specific character ranges

## Configuration Structure

Format templates utilize a two-tab configuration interface:

### Properties Tab

Contains all essential settings for the template including:
- Template name and identifier
- Formatting type (section vs. individual)
- Visual properties (colors, fonts, borders)
- Accessibility settings

### Template Set Tab

Manages formatting-specific configuration details:
- Assignment to template sets
- Channel-specific output rules
- Conversion rule associations

## Implementation Requirements

Three critical steps are required to create functional format templates:

### 1. Conversion Rules

Each template set must have a defined conversion rule that determines how formatted content is transformed for different output channels (HTML, PDF, mobile, etc.).

### 2. Output Definition

Formatted content visibility depends on output specifications defined for each template set. Without proper output configuration, formatted text will not appear in generated pages.

### 3. Template Specification

Developers must designate the format template within the form area of relevant page or section templates. This connects the formatting options to specific input components.

## Default Format Templates

FirstSpirit provides pre-built format templates as export files that can be imported into a project's Template Store under the "Format templates" node.

### Critical Requirement

**The default format templates are required in a variety of contexts for correct operation and must not be deleted.**

### Version Comparison Templates

Four specialized templates handle change visualization in version history:

- `deleted` - Shows removed inline content
- `deleted_block` - Shows removed block-level content
- `inserted` - Shows added inline content
- `inserted_block` - Shows added block-level content

These templates can be customized by adjusting properties like:
- Colors to highlight changes
- Font size and weight
- Border styles
- Background colors

### Standard HTML Format Templates

The system includes templates for common HTML formatting elements:

**Text Formatting:**
- `b` - Bold text
- `i` - Italic text
- `u` - Underlined text
- `pre` - Preformatted text

**Structure:**
- `p` - Paragraph
- `br` - Line break
- `ul` - Unordered list
- `li` - List entry

**Tables:**
- `table` - Table container
- `tr` - Table row
- `td` - Table cell

**Special:**
- `CMS_LINK` - Hyperlinks
- `default_style_template` - Default styling
- `default_inline_table` - Default table configuration

### Customization

Properties of format templates can be modified to alter display behavior in the DOM editor. This allows organizations to customize appearance while maintaining required functionality.

## Table Format Templates

Table format templates define how inline tables appear and function within FirstSpirit. They provide comprehensive control over visual presentation and editing constraints.

### Purpose

Table format templates control:
- Visual presentation of tables in the editor and frontend
- Editing constraints (row/column limits)
- Style application across different table areas
- User permissions for table modifications

### Configuration Options

#### Visual Presentation

Upload a "meaningful screenshot" to show editors how the template appears in the frontend. This visual reference helps editors select appropriate templates for their content needs.

#### Size Constraints

Templates allow administrators to specify:
- Minimum row count
- Maximum row count
- Minimum column count
- Maximum column count

When the "limited" checkbox is enabled:
- Editors cannot exceed specified boundaries
- Relevant buttons automatically disable when limits are reached
- Prevents table structure violations

#### Style Application

Each table format template uses:
- **Precisely one standard style template** for the entire table
- **Additional style templates** for individual cells, rows, or columns through display rules

### Display Rules System

Display rules override the standard template for specific table areas, providing granular control over table styling.

#### Rule Configuration

Each display rule specifies:

1. **Application Area**: Whether it applies to rows, columns, or cells
2. **Application Scope**:
   - `ALL` - All items of the specified type
   - `EVEN` - Even-numbered items only
   - `ODD` - Odd-numbered items only
   - `FIRST` - First item only
   - `LAST` - Last item only
   - User-defined numbers - Specific row/column numbers
3. **Associated Style Template**: Which style template to apply
4. **Editor Permissions**: Whether editors can modify or delete affected areas

#### Evaluation Order

The system processes display rules using specific logic:

1. Display rules are evaluated top-down in the defined order
2. The standard template applies to remaining cells not affected by rules
3. **Important Limitation**: Rules cannot affect ALL columns AND ALL rows simultaneously

#### Integration with Style Templates

Style templates work seamlessly with table format templates, allowing control over:
- Background colors
- Text alignment
- Font properties
- Borders and spacing
- Other formatting properties across different table sections

## Best Practices

### Naming Conventions

Use descriptive, meaningful names for format templates that indicate:
- Purpose (e.g., "Headline Level 2", "Quote Block")
- Visual appearance (e.g., "Red Alert Text", "Centered Caption")
- Context of use (e.g., "Product Description Paragraph")

### Template Organization

- Group related format templates together
- Create separate templates for different content types
- Maintain consistent styling across template sets
- Document custom templates for future reference

### Version Control Considerations

When customizing default format templates:
- Preserve the original version comparison templates
- Document all modifications
- Test changes across all output channels
- Verify formatting appears correctly in preview and production

### Table Template Design

When creating table format templates:
- Provide clear screenshots showing frontend appearance
- Set reasonable size constraints that balance flexibility with design requirements
- Use display rules strategically to highlight important table areas
- Test templates with various content scenarios
- Consider accessibility requirements (headers, contrast, etc.)

### Multi-Channel Output

Remember that format templates must be configured for each output channel:
- Define conversion rules for HTML, PDF, mobile, and other channels
- Test formatting in all target channels
- Ensure consistent appearance across platforms
- Account for channel-specific limitations

## Common Use Cases

### Editorial Formatting

Format templates enable editors to:
- Apply consistent heading styles
- Highlight important text (quotes, callouts, warnings)
- Format lists and structured content
- Create accessible, well-formatted tables
- Maintain brand guidelines without technical knowledge

### Multi-Channel Publishing

Format templates support:
- Responsive design across devices
- Print-optimized formatting for PDF generation
- Mobile-specific text presentation
- Channel-specific style variations

### Workflow Integration

Format templates integrate with:
- Content approval workflows
- Version comparison tools
- Translation management
- Multi-site content distribution

## Technical Considerations

### Performance

- Minimize the number of format templates to reduce editor complexity
- Use display rules efficiently to avoid excessive processing
- Cache rendered output when possible

### Maintenance

- Regularly review and consolidate format templates
- Remove unused templates to simplify editor interface
- Update templates when design standards change
- Document dependencies between templates and page templates

### Accessibility

Ensure format templates support:
- Semantic HTML structure
- Screen reader compatibility
- Proper heading hierarchy
- Color contrast requirements
- Keyboard navigation

## Summary

Format templates are essential components of FirstSpirit's content management system, providing the bridge between editorial flexibility and design consistency. By properly configuring format templates, organizations can empower editors to create well-formatted content while maintaining brand standards across all output channels. Understanding the distinction between section and individual formatting, properly implementing table format templates with display rules, and maintaining the required default templates ensures a robust and user-friendly content editing experience.