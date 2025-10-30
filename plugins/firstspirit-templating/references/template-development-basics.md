# Template Development Basics

## Overview

FirstSpirit is a dynamic, extensible content management platform designed for continuous development rather than as an out-of-the-box solution. The documentation is organized into two levels:
- **Basic principles of template development** - for beginners
- **Template development** - for advanced users

This guide covers the fundamental concepts, tools, and workflows necessary for developing FirstSpirit templates effectively.

## Core Architectural Principles

### Separation of Concerns

The foundational principle of FirstSpirit is the **separation of layout, content, and structure**. This architectural approach ensures:
- **Layout** - Visual presentation and styling
- **Content** - Data and information managed by editors
- **Structure** - Organizational framework and navigation

This separation enables teams to work independently on different aspects of the project while maintaining consistency and scalability.

### Template Organization

Templates serve as the organizational framework within FirstSpirit projects. Each project requires customized templates that function as structural scaffolding, binding together all project content.

**Key aspects:**
- All templates are stored in a centralized **templates repository**
- Templates are categorized into distinct types
- Understanding template composition is essential for effective development
- Templates must be designed to make editor workflows more efficient

## Getting Started with Template Development

### Recommended Learning Path

1. **Start with basics** - Understand core template concepts and architecture
2. **Study composition fundamentals** - Learn how different template types interact
3. **Explore the "First Project" tutorial** - Hands-on implementation through example projects
4. **Advance to specialized techniques** - Move into advanced template development

### Template Development Scope

According to FirstSpirit documentation: "All aspects of development of FirstSpirit projects are explained in the area of template development."

The template development area encompasses:
- Forms and input components
- Rules and dynamic behavior
- Snippets and content presentation
- Template syntax and expressions
- Debugging and testing
- API integration
- Security considerations

## Development Tools and Environments

### Primary Development Interfaces

#### SiteArchitect
The main development environment for template creation and project management. Provides comprehensive access to:
- Template editing
- Project structure management
- Form and rule definition
- Debugging tools

#### ContentCreator
The editor-focused interface with specific requirements and restrictions. Features include:
- Content editing capabilities
- Snippet display in search results
- Content highlighting and EasyEdit functionality
- JavaScript API for user interface interaction

### Developer Tools

#### 1. Code Completion

Available across three key areas:
- **Forms tabs** - for Input components
- **Rules tabs** - for defining Rules
- **Template set tabs** - for inserting FirstSpirit instructions and methods

**Usage:**
Press `Ctrl+Space` to open a window with available tags, parameters, and values.

#### 2. Navigation Features

**Jump-to-References Functionality:**
- Hover over code expressions while holding `Ctrl` to view tooltips
- Tooltips display name, object type, and path
- Use `Ctrl+Click` to navigate directly to referenced elements
- Works across Form, Rules, and Template set tabs

#### 3. Online Help System (F1)

Integrated documentation access:
- Select keywords in templates and press `F1`
- Opens integrated preview with relevant documentation page
- Forms section includes syntax examples with drag-and-drop capability
- Provides immediate context-specific help

#### 4. Template Wizard

Graphical interface for automating template creation:
- Analyzes HTML mockups
- Identifies referenced images and files
- Imports required content into FirstSpirit
- Streamlines the conversion of static HTML to dynamic templates

#### 5. Debugging Tools

**Template Inspector:**
- Quick way to locate existing code in HTML channel
- Accessible via context menu
- Displays tag structure with direct links to relevant template sections
- Enables rapid code navigation

**Template Debugger:**
- Error searching and identification
- Gradual page construction for testing
- View partial results as source text or generated HTML
- Step-through debugging capabilities

#### 6. Chrome Developer Tools

Access to full Chrome Developer Tools suite:
- Available through context menu in integrated preview
- Provides comprehensive web development utilities
- Standard browser debugging features (inspect element, console, network, etc.)

## Template Development Components

### 1. Forms

Forms define input mechanisms and design elements available to editors.

**Purpose:**
- Create input components for content entry
- Define data structure for content types
- Control how editors interact with content

**Key Features:**
- Multiple input component types
- Integration with template composition
- Editor-friendly interfaces

### 2. Rules

Rules enable dynamic form functionality and content validation.

**Capabilities:**
- Implement "Dynamic Forms"
- Real-time content validation
- Allow editors to check data plausibility during entry
- Control element behavior and characteristics

**Benefits:**
- Immediate feedback to editors
- Prevent invalid data entry
- Conditional field display
- Business logic enforcement

### 3. Snippets

Snippets create teaser representations of FirstSpirit objects.

**Usage:**
- Combine imagery with textual content
- Display in search results within SiteArchitect and ContentCreator
- Provide preview functionality
- Object display management

### 4. Template Syntax

The template syntax system includes distinct elements:
- **Instructions** - FirstSpirit-specific directives
- **Expressions** - Value calculations and access
- **Data types** - Type system for template data
- **Functions** - Built-in and custom operations
- **System objects** - Platform-provided objects

**Variables:**
Variables enable content storage and subsequent internal access patterns, allowing templates to:
- Store computed values
- Pass data between template sections
- Evaluate content dynamically

### 5. Content Highlighting and EasyEdit

Features designed to improve editor workflows:
- **Content Highlighting** - Visual indicators in preview mode
- **EasyEdit** - In-context editing capabilities
- Available in both ContentCreator and SiteArchitect
- Reduce friction in content management tasks

## Development Workflow

### Standard Development Process

1. **Project Setup**
   - Initialize FirstSpirit project
   - Configure project structure
   - Set up templates repository

2. **Template Creation**
   - Design template architecture
   - Define forms for content input
   - Implement rules for dynamic behavior
   - Create snippets for content preview

3. **Development and Testing**
   - Use code completion for efficiency
   - Leverage navigation features for exploration
   - Employ Template Inspector for code location
   - Debug with Template Debugger

4. **Refinement**
   - Test with actual content
   - Optimize editor workflows
   - Validate across different scenarios
   - Ensure multi-language support

5. **Deployment**
   - Review security considerations
   - Test in target environments
   - Document customizations
   - Train editors on new features

### Best Practices

- **Design for editors** - Always consider the editor experience when creating templates
- **Maintain separation** - Keep layout, content, and structure independent
- **Use built-in tools** - Leverage code completion, F1 help, and debugging tools
- **Test thoroughly** - Use Template Debugger to identify issues early
- **Document decisions** - Maintain clear documentation of template logic
- **Plan for scale** - Design with multi-language and multi-site needs in mind

## API and Scripting

### FirstSpirit API

The public interface for programmatic access:
- Integration with external systems
- Custom functionality implementation
- Automation of repetitive tasks

### JavaScript API

Specific to ContentCreator:
- User interface interaction
- Custom editor behaviors
- Enhanced editing experiences

### Scripting with BeanShell

BeanShell scripting enables:
- Script creation and execution
- Automated processes
- Custom business logic
- Integration with Java ecosystem

## Multi-Language Support

FirstSpirit provides consistent support for managing multiple languages throughout template development:
- Language-aware content storage
- Translation workflows
- Locale-specific rendering
- International project scalability

## Security Considerations

Security is an integral part of template development:
- Project-level security settings
- User and group permissions
- Access control for content and templates
- Secure API usage patterns

## Additional Resources

### Documentation Structure

The FirstSpirit documentation is organized to support progressive learning:
- **Basics section** - Fundamental concepts and getting started
- **Template development** - Comprehensive development reference
- **API documentation** - Technical API references
- **ContentCreator guide** - Editor-focused documentation

### Learning Approach

1. Start with the "First Project" tutorial for practical experience
2. Study the "Composition of templates" section for architectural understanding
3. Explore Forms and Rules for content management patterns
4. Learn Template Syntax for implementation details
5. Master debugging tools for efficient troubleshooting

## Key Takeaways

1. **FirstSpirit is extensible** - It's designed for continuous development and customization, not as a static product
2. **Separation is fundamental** - The separation of layout, content, and structure drives all design decisions
3. **Tools support efficiency** - Built-in tools like code completion, Template Inspector, and debugger accelerate development
4. **Editor experience matters** - Templates should be designed to optimize editor workflows
5. **Progressive complexity** - Start with basics and progressively adopt advanced features as needed

## Summary

Template development in FirstSpirit requires understanding core architectural principles, mastering development tools, and following structured workflows. The platform's separation of concerns enables scalable, maintainable projects, while comprehensive developer tools support efficient implementation. Success comes from balancing technical implementation with editor usability, leveraging built-in features, and following established best practices.