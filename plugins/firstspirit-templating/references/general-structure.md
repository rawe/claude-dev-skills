# FirstSpirit General Structure and Stores

## Overview

FirstSpirit is a content management system built on a fundamental architectural principle: **strict separation of layout, content, and structure**. This separation enables independent modification of different website aspects while maintaining content reusability across the entire system.

The core philosophy addresses the traditional challenges of website maintenance by allowing editorial teams to manage content without requiring web design expertise, while developers control layout and functionality separately.

## Core Architecture: The Six-Store System

FirstSpirit organizes all project data into six distinct, specialized stores. Each store has a specific purpose and is color-coded in the interface for easy identification.

### 1. Page Store

**Purpose:** Primary repository for editorial content where content creators work with pages and sections.

**Key Characteristics:**
- Main editing interface for content creators
- Houses editorial content in a structured format
- Provides standard input elements (text editors, form fields, etc.)
- Enables editors to add pages, sections, and manage existing content

**Structure and Components:**

The Page Store supports four primary object types:

1. **Folders** - Organizational hierarchy, typically mirroring intended website menu structure
2. **Pages** - Standard content containers that usually correspond to individual website pages
3. **Sections** - Content divisions within pages that map to specific content areas (enabling multi-column layouts)
4. **Section References** - References to existing sections for content reuse across multiple pages

**Content Organization:**
- One page in the Page Store typically corresponds to one website page
- Each page can contain multiple sections assigned to different content areas
- Sections organize content within pages for layout flexibility
- Content includes text, images, files, and other media inserted using standard input elements

**Relationship with Other Stores:**
- Pages align with page templates from the Template Store
- Sections align with section templates that define individualized layouts
- Content areas organize sections within pages for complex website designs

### 2. Data Store

**Purpose:** Manages highly structured, database-driven content.

**Key Characteristics:**
- Designed for structured content like product catalogs, address lists, and news databases
- Accommodates custom database structures
- Supports external database integration for frequently-updated information
- Ideal for content requiring database-style querying and organization

**Typical Use Cases:**
- Product catalogs
- Address directories
- News archives
- Event calendars
- Any content requiring complex relationships and structured data models

### 3. Site Store

**Purpose:** Governs the website's physical hierarchy and navigation structure.

**Key Characteristics:**
- Maps the navigation architecture of the website
- Separates structure from layout, allowing independent modification
- Each folder represents a navigation menu level
- Subfolders automatically create new menu tiers
- Controls menu item ordering and display options

**Structural Elements:**

The Site Store organizes content through five main components:

1. **Folders** - Each folder represents a menu level in website navigation
2. **Start folders** - Direct links to pages when a menu level lacks a dedicated page
3. **Page references** - Individual pages available for display in navigation
4. **Start pages** - The initial page shown when multiple pages exist at one menu level
5. **Document groups** - Containers that unite multiple page references and menu levels for unified display

**Navigation Management:**
- Navigation points can be added, modified, or removed at any depth and time
- Automatic menu level creation occurs with each new subfolder
- Link management preserves referential integrity throughout the structure
- Navigation can be implemented through various formats (traditional HTML, JavaScript, Flash)
- Navigation appearance and positioning defined independently from structure

**Key Advantage:**
The separation enables flexible design changes without restructuring the content hierarchy. You can completely change how navigation looks and where it appears without touching the underlying structure.

### 4. Media Store

**Purpose:** Central repository for all project media assets.

**Key Characteristics:**
- Stores all media files used across the website
- Centralized management prevents duplication
- Enables reuse of media across multiple pages and templates

**Media Types:**
- Images (JPEG, PNG, GIF, SVG, etc.)
- Videos (MP4, WebM, etc.)
- Audio files
- Documents (PDF, Word, Excel, etc.)
- Downloadable files
- Other digital assets

### 5. Template Store

**Purpose:** The system's core where layout design and functional specifications reside.

**Key Characteristics:**
- Contains all templates that define how content is displayed
- Serves as the connector between all other stores
- Integrates content, media, and structure during website generation
- Defines page layouts, section layouts, and format templates

**Integration Role:**
Templates combine elements from multiple stores during generation:
- Content from Page Store and Data Store
- Media from Media Store
- Structure from Site Store
- All unified into complete website presentations

**Template Types:**
- Page templates (define overall page structure)
- Section templates (define content area layouts)
- Format templates (define specific output formats)
- Link templates (define how links are generated)

### 6. Global Settings

**Purpose:** Project-wide configurations and shared content.

**Key Characteristics:**
- User preferences and permissions
- Project rules and workflows
- URL configuration and SEO optimization
- Reusable content elements for frequently-used page components
- Project languages and multilingual settings

**Configuration Areas:**
- Editorial permissions (for FirstSpirit users)
- Workflow permissions (specialized editorial access)
- User permissions (for website visitors)
- Application interface locale settings
- Editing languages (for template developers)
- Project languages (for content)

## Separation of Content and Layout

### The Core Principle

FirstSpirit's fundamental architecture principle states: **"strict separation of layout, content and structure."**

This separation addresses the inefficiency of traditional website maintenance where changing a single design element required manually updating hundreds or thousands of individual HTML files.

### How Separation Works

**Content Layer (Page Store, Data Store):**
- Editors maintain, change, and create content like newspaper editors
- No web design expertise required
- Focus on information quality and accuracy
- Content exists independently of presentation

**Layout Layer (Template Store):**
- Developers define templates that control presentation
- Templates can be updated without touching content
- Design changes propagate automatically across all content
- Separation enables design consistency

**Structure Layer (Site Store):**
- Navigation hierarchy defined independently
- Menu structure can be reorganized without affecting content or layout
- Referential integrity maintained automatically

### Benefits of Separation

1. **Scalability:** Bulk updates propagate across multiple dependent pages automatically
2. **Maintainability:** Important changes can be made easily and efficiently
3. **Specialization:** Team members focus on their expertise (content vs. design vs. development)
4. **Reusability:** Content can be reused at any time across different contexts
5. **Flexibility:** Each area can be changed independently of others

## Core Concepts and Paradigms

### Content-First Approach

FirstSpirit follows a **content-first methodology** where editorial teams manage information independent of presentation. The system treats editors as content creators rather than technical specialists, enabling them to focus on content quality.

### Accessibility for Non-Technical Users

The framework emphasizes accessibility through graphical interfaces, enabling important changes without requiring proficiency in web design. This democratizes content management across organizations.

### Multi-User Collaboration

FirstSpirit implements selective locking to prevent conflicts:

**Parallel Operations (No Locking Required):**
- Creation of new elements
- Deletion of elements
- Copying elements
- Moving elements

**Exclusive Operations (Edit Mode Required):**
- Editing content
- Release actions
- Any modifications requiring exclusive access

This approach maximizes team productivity while maintaining data integrity.

### Multilingual Architecture

The platform supports language at three distinct levels:

1. **Application Interface Locale:** The language of the FirstSpirit interface itself
2. **Editing Languages:** Languages available to template developers
3. **Project Languages:** Languages for content delivery to end users

**Language Flexibility:**
- Fields can be designated as language-dependent (different content per language)
- Fields can be language-independent (same content across all languages)
- Enables efficient management of multilingual websites

### Role-Based Access Control

FirstSpirit implements granular permission framework where "each individual employee has precisely defined tasks." The system distinguishes between three permission categories:

1. **Editorial Permissions:** For FirstSpirit content editors
2. **Workflow Permissions:** Specialized editorial access with approval capabilities
3. **User Permissions:** For website visitors (frontend access control)

## Data Preservation and Versioning

FirstSpirit provides three mechanisms to ensure information integrity:

### 1. Versioning
- Tracks all changes over time
- Enables rollback to previous versions
- Maintains complete change history
- Supports audit trails

### 2. Historization
- Enables temporal snapshots for generation
- Allows regeneration of website as it appeared at specific points in time
- Supports testing and preview of changes before publication

### 3. Archiving
- Provides permanent, tamper-proof storage
- Ensures long-term data preservation
- Supports compliance and regulatory requirements

## Integration Model: The Generation Process

Templates serve as the integration point during website generation:

1. **Template Selection:** System identifies appropriate template for content
2. **Content Retrieval:** Fetches content from Page Store or Data Store
3. **Media Integration:** Incorporates media from Media Store
4. **Structure Application:** Applies navigation structure from Site Store
5. **Configuration Application:** Applies settings from Global Settings
6. **Output Generation:** Produces final website files (HTML, CSS, JavaScript, etc.)

This process combines all store elements into cohesive, complete website presentations.

## Best Practices for Store Organization

### Page Store Organization
- Mirror your intended site structure in folder hierarchy
- Use descriptive names for pages and sections
- Leverage section references to avoid content duplication
- Organize content logically for easy editor navigation

### Data Store Organization
- Design schemas that match real-world data relationships
- Use appropriate data types for each field
- Consider query performance when designing structure
- Document custom schemas for maintainability

### Site Store Organization
- Create intuitive navigation hierarchies
- Use start pages to define default landing pages
- Leverage document groups for complex navigation scenarios
- Plan for future navigation expansion

### Media Store Organization
- Use folders to categorize media by type or purpose
- Implement consistent naming conventions
- Consider media lifecycle and archiving strategies
- Optimize media files before upload

### Template Store Organization
- Create reusable template components
- Document template functionality for future developers
- Use consistent coding standards
- Separate presentation logic from business logic

### Global Settings Management
- Document all project-specific configurations
- Maintain separate settings for development, staging, and production
- Version control reusable content elements
- Regularly review and update permissions

## Developer Considerations

### Related Concepts to Master
- Language handling within the platform
- Developer tools available (ContentCreator, SiteArchitect)
- Template composition methodologies
- Plugin development capabilities
- API integration patterns

### Content Scaling
The system manages content scaling across websites of any size through centralized repositories, allowing bulk updates to propagate across multiple dependent pages—directly addressing the labor-intensive nature of traditional website maintenance.

## System Statements

Key architectural statements from FirstSpirit documentation:

> "The individual areas can be changed independently of each other and content can be reused at any time."

> "A Content Management System simplifies making changes to content by separating a website's content, layout and structure."

> "The editor maintains, changes and creates editorial content just like a newspaper editor."

These statements encapsulate FirstSpirit's core philosophy: empowering content creators while maintaining technical flexibility for developers.

## Summary

FirstSpirit's six-store architecture provides a robust foundation for enterprise content management:

- **Page Store:** Editorial content and pages
- **Data Store:** Structured, database-driven content
- **Site Store:** Navigation hierarchy and structure
- **Media Store:** Centralized media assets
- **Template Store:** Layout and presentation logic
- **Global Settings:** Project-wide configuration

The strict separation of content, layout, and structure enables:
- Independent modification of different website aspects
- Unlimited content reusability
- Scalable maintenance across large websites
- Team specialization and parallel workflow
- Multilingual content management
- Robust versioning and data preservation

This architecture positions FirstSpirit as an enterprise-grade CMS capable of managing complex, large-scale web projects while remaining accessible to non-technical content creators.