# Table and Database Schema Templates

## Overview

FirstSpirit provides comprehensive database integration capabilities for managing structured content like product catalogs, address lists, and other frequently changing tabular data. The system includes a graphical schema editor for creating and modifying database tables, along with templates for maintaining and displaying datasets.

## Database Schema Architecture

### Database Abstraction Layer

FirstSpirit implements a database abstraction system that maps the universal FirstSpirit content type system to specific database systems being used. This abstraction enables:

- Platform-independent database connectivity
- Consistent data modeling across different database backends
- Unified content management for structured data

### Core Components

The database schema functionality consists of four primary components:

1. **Schema Creation**: Create new database schemas or generate them from existing database structures
2. **Schema Editor**: Graphical interface for modeling database schemas through visual tools
3. **Table Templates**: Components that connect database tables to data input mechanisms for editors
4. **Queries**: Mechanisms to restrict the number of datasets output for a data source

## Table Templates

### Purpose and Definition

Table templates are essential components in FirstSpirit's database architecture. A table template must be created under the schema for each table entered in the database model.

These templates define the input mechanisms editors use when entering data into corresponding database tables. They function similarly to page and section templates but are specifically tailored for tabular data management.

### Configuration Tabs

Table templates consist of six primary configuration tabs:

#### 1. Properties Tab
Houses essential settings and configuration options for the template.

#### 2. Form Tab
Where input components for data entry are defined. This is the primary location for configuring the editor interface.

#### 3. Mapping Tab
Establishes connections between table columns and their corresponding input components. This mapping ensures data entered through the form is correctly stored in the database.

#### 4. Rules Tab
Enables conditional logic to influence elements or properties. Rules can control visibility, required fields, and other dynamic behaviors.

#### 5. Snippet Tab
Controls how datasets appear in overview lists. This affects how editors see data in list views within ContentCreator.

#### 6. Template Set Tab
Determines content presentation within template sets. This tab configures how the data displays on the website.

### Editing Datasets

Datasets can be edited in ContentCreator through two access points:

- **Data sources view**: Dedicated view for managing data sources
- **Preview**: Directly edit data within the preview interface

### Permissions

An important limitation exists regarding permissions:

- Permissions assigned to data sources are not applied to filters in ContentCreator for technical reasons
- Editorial permissions remain applicable to data source access generally

## Database Integration Tutorial

### Use Case

Database integration is ideal for managing highly structured content that changes frequently. Content is "recorded and managed in the Data Store" for optimal organization and maintenance.

### Implementation Workflow

The complete setup process follows this sequence:

1. **Schema Creation**
   - Establish a database schema with table definitions

2. **Table Structure**
   - Add multiple related tables with columns
   - Define foreign key relationships between tables

3. **Table Templates**
   - Create templates for each database table
   - Configure template properties

4. **Input Components**
   - Define form fields editors use to enter content
   - Add components to the Form tab

5. **Data Mapping**
   - Assign input components to corresponding table columns
   - Configure the Mapping tab to link form fields with database columns

6. **HTML Output**
   - Configure how datasets display on the website
   - Set up the Template Set tab

7. **Data Population**
   - Add data sources to the Data Store with content
   - Create initial datasets

8. **Website Integration**
   - Output data source content to pages
   - Reference data sources in page templates

9. **Query Configuration**
   - Use queries to control dataset presentation
   - Filter and sort data for specific use cases

### Practical Example

A common implementation pattern uses related tables, such as a product management system where "each product is assigned to a corresponding product category." This demonstrates:

- Primary table (Products) with product details
- Reference table (Categories) for classification
- Foreign key relationship linking products to categories

## Inline Tables

### Core Concept

Inline tables provide a different approach to table management in FirstSpirit. These tables are integrated into continuous text using the `CMS_INPUT_DOM` input component, offering editors "limitless design possibilities right down to the cell level."

### Template Structure

Inline tables require two types of templates working together:

#### 1. Table Format Templates

- Created in the Format templates area
- Determine overall table layout
- Can have one standard style template for the entire table
- Support multiple additional style templates for individual cell formatting

#### 2. Style Templates

Define cell-level presentation including:
- Background color
- Text alignment (horizontal and vertical)
- Text color
- Other cell-specific styling

### Implementation Requirements

To enable inline tables functionality:

1. **Create Style Templates First**
   - Style templates must exist before inline tables can function in the DOM input component

2. **Organize Templates**
   - Group style and table format templates in a dedicated folder (e.g., "Inline tables") under Format templates
   - Improves template management and discoverability

3. **Configure DOM Component**
   - Add `table="yes"` parameter to the `CMS_INPUT_DOM` component in section templates
   - This parameter enables inline table functionality in the DOM editor

### Setup Process

Before editors can use inline tables in the DOM editor:

1. Navigate to the desired section template
2. Locate or add the `CMS_INPUT_DOM` input component
3. Add the `table="yes"` parameter to the component configuration
4. Ensure appropriate style templates are available

## Best Practices

### Database Schema Design

- Plan table relationships carefully before creating schemas
- Use foreign keys to maintain referential integrity
- Consider query performance when designing table structures

### Table Template Configuration

- Create intuitive form layouts in the Form tab
- Map all relevant columns in the Mapping tab
- Use Rules tab for validation and conditional logic
- Configure meaningful snippets for overview displays

### Inline Tables

- Create a library of reusable style templates
- Organize format templates in dedicated folders
- Provide clear naming conventions for template selection
- Test table rendering across different output channels

## Related Components

### Data Store

The Data Store is FirstSpirit's dedicated area for managing structured content:

- Stores database schemas and data sources
- Provides centralized data management
- Integrates with ContentCreator for editing

### ContentCreator Integration

ContentCreator provides editor interfaces for:

- Data sources view for managing datasets
- Preview-based editing for direct manipulation
- Filter functionality for finding specific datasets

### Queries

Queries enable sophisticated data filtering and presentation:

- Restrict the number of datasets displayed
- Apply conditions based on column values
- Sort datasets for specific output requirements
- Support complex filtering logic

## Documentation Resources

Additional information is available in:

- FirstSpirit SiteArchitect documentation for Data Store functionality
- ContentCreator editor documentation for data management interfaces
- Schema editor documentation for database modeling
- Template documentation for advanced configuration options
