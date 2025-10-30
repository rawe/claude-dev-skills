# Template Wizard and HTML Importer

## Overview

The Template Wizard is a FirstSpirit tool that automates the conversion of HTML mockups into FirstSpirit project templates. It streamlines the template development process by importing external HTML designs and automatically generating FirstSpirit components.

### Purpose

The Template Wizard significantly reduces the time and effort required from delivery of HTML mockups to creation of the initial project prototype by:

- Importing HTML/JSP structures from local sources or URLs
- Automatically transferring referenced images and files from HTML mockups
- Extracting design and layout specifications
- Generating FirstSpirit input components (e.g., DOM editors, image references)
- Mapping form elements and content areas to FirstSpirit templates

### Key Benefits

- **Automation**: Automatically imports HTML structures and associated assets
- **Design Transfer**: Extracts and transfers design specifications from HTML
- **Component Generation**: Creates FirstSpirit components matching HTML content
- **Rapid Prototyping**: Accelerates the journey from mockup to working prototype

## Accessing the Template Wizard

### Access Control

As of version 5.2R2, administrators can restrict access to the Template Wizard through the **"FS-AgencySupport-ProjectPermissions"** project component in ServerManager. This allows limiting usage to specific user groups.

### Starting the Wizard

The Template Wizard can be accessed through the toolbar buttons in the import interface:

- **"Select HTML file"** button: Opens a file selection dialog with the import project root directory as default
- **"Select URL"** button: Allows input of external URLs for importing remote HTML structures

## Template Wizard Workflow

The wizard guides developers through a structured process:

1. **Import HTML structures** - Import HTML/JSP files from local sources or URLs
2. **Auto-import assets** - Automatically transfer referenced images, files, and external content
3. **Transfer design specifications** - Extract layout and design elements from HTML
4. **Build forms** - Use Form Builder to create FirstSpirit components matching HTML content
5. **Assign form elements** - Map form components to templates
6. **Configure content areas** - Define editable regions for page templates

## Importing HTML Structures

### Import Process

1. **Select Source**: Choose between local HTML files or external URLs using the toolbar buttons
2. **Automatic Transfer**: Upon confirmation, the HTML structure transfers to the import project
3. **Asset Import**: Referenced images, files, and external content are automatically imported where possible

### Limitations

The Template Wizard cannot automatically handle:

- **Images/files embedded in JavaScript**: Assets loaded dynamically via JavaScript must be imported manually
- **Navigation structures**: HTML navigation elements must be manually mapped to FirstSpirit navigation
- **JavaScript-based content**: Dynamic content loaded through JavaScript requires manual configuration

### Reimport Considerations

**Important Warning**: Reimporting HTML structures will overwrite current project modifications. The wizard cannot merge reimported changes with existing customizations. Always backup your project before reimporting.

## Analyzing and Working with HTML Structure

### HTML Preview Interface

After importing HTML, you can analyze and work with the structure:

1. **Select an entry** in the import project
2. **Click "Edit entry"** to open the preview tab
3. **View HTML preview** showing the page structure

### Interactive Selection

The preview interface provides powerful selection capabilities:

- **Click inside preview**: Displays an overlay window revealing the HTML hierarchy at that location
- **Multiple selection**: Hold Ctrl while clicking to select multiple elements
- **Visual feedback**: Hover over overlay entries to highlight corresponding areas in the preview
- **Selection confirmation**: Selected areas display with green frames once saved

## Creating FirstSpirit Components

The Template Wizard can generate various FirstSpirit components from HTML structures:

### Automatically Generated Components

**PAGE_TEMPLATE**
- Created automatically when HTML structures are added to the import project
- Becomes a full FirstSpirit template after content areas and input components are defined
- Serves as the foundation for page layouts

### Components Created via Preview Selection

**BODY/Content Areas**
- Define editable page sections
- Mark regions where editors can add and modify content
- Created by selecting areas in the HTML preview

**SECTION_TEMPLATE**
- Reusable template structures
- Created from repeating HTML patterns
- Can be nested within page templates

**INPUT_COMPONENT**
- Form elements for editorial input
- Automatically generated from HTML form elements (e.g., image components from `<img>` tags)
- Maps HTML inputs to FirstSpirit form components

**LINK_TEMPLATE**
- Navigation elements
- Created from HTML anchor tags and navigation structures
- Enables dynamic link management

**RENDER_TEMPLATE**
- Format templates for content rendering
- Controls how content is displayed in different contexts
- Separates content from presentation

**MediaMapping**
- Images or files imported as FirstSpirit media
- Automatically maps HTML media references to FirstSpirit Media Store
- Preserves asset organization and references

### Component Creation Workflow

1. **Analyze HTML**: Review the imported HTML structure in the preview
2. **Identify areas**: Select HTML elements that should become FirstSpirit components
3. **Generate components**: Use the wizard to create appropriate component types
4. **Visual confirmation**: Selected areas show green frames indicating successful creation
5. **Configure properties**: Set component properties and configuration options

## Form Builder

### Overview

The Form Builder is an integral part of the Template Wizard that simplifies creation of reusable form components. Forms are essential FirstSpirit template components that "provide the editor with a means of adding editorial content to pages and sections."

### Component Templates

Component templates are "flexible form boilerplates which are created once and can then be reused again and again." They combine GOM definition elements with FirstSpirit template syntax.

**Key Advantages:**
- **One-time creation**: Create once, reuse multiple times
- **Server-wide availability**: Access templates across projects through "Import templates from project" function
- **Reusable boilerplates**: Share form structures across current and other projects
- **Flexibility**: Combine GOM definitions with template syntax for customization

### Form Component Types

Forms utilize two primary component categories:

**Input Components**
- Accommodate editorial content
- Examples: `CMS_INPUT_DATE`, `CMS_INPUT_DOM`, `CMS_INPUT_TEXT`, `CMS_INPUT_TEXTAREA`
- Map to HTML form elements and content areas
- Enable structured content entry

**Design Components**
- Visualize the input components
- Control layout and presentation of form elements
- Provide visual structure for editors
- Enhance user experience in ContentCreator

### Creating Forms

1. **Access Form Builder**: Navigate to the Settings tab in the Template Wizard
2. **Create component templates**: Define new form boilerplates
3. **Configure input components**: Set up components for specific application scenarios
4. **Design layout**: Arrange input and design components
5. **Save and reuse**: Make templates available for current and future projects

### Form Builder Limitations

The Template Wizard has two significant constraints for form creation:

**Cannot Group Input Components**
- The wizard does not support automatic creation of `CMS_GROUP` elements
- Manual adaptation required post-import to group related input components
- Grouping must be done in FirstSpirit SiteArchitect after wizard-based creation

**No Dynamic Forms Support**
- The wizard cannot create dynamic forms that change based on user input
- Complex conditional logic requires manual template modification
- Dynamic form behaviors must be implemented in SiteArchitect

### Post-Wizard Form Customization

For complex form requirements beyond wizard capabilities, manual template modification in FirstSpirit SiteArchitect may be necessary:

- Adding `CMS_GROUP` elements to organize related inputs
- Implementing dynamic form behaviors with conditional logic
- Creating custom validation rules
- Adding advanced input component configurations
- Implementing complex data models

## Best Practices

### HTML Preparation

**Structure for Import**
- Use clean, semantic HTML markup
- Avoid complex JavaScript-based layouts
- Keep navigation structures simple and well-organized
- Use standard HTML form elements where possible
- Externalize CSS and JavaScript files for easier import

**Asset Organization**
- Use relative paths for images and files
- Keep assets in logical directory structures
- Avoid embedding resources in JavaScript
- Use standard image formats (JPG, PNG, GIF, SVG)

### Wizard Usage

**Planning Phase**
- Analyze HTML mockups before importing
- Identify reusable components and patterns
- Map HTML structures to FirstSpirit component types
- Plan content areas and editorial workflows
- Document navigation and link structures

**Import Strategy**
- Start with simple page templates
- Import one section at a time for complex sites
- Backup projects before reimporting
- Test imports in development environment first
- Verify asset imports are complete

**Component Creation**
- Use descriptive names for components
- Create section templates for reusable structures
- Define content areas strategically for editor flexibility
- Map HTML semantic elements to appropriate FirstSpirit components
- Leverage component templates for consistency

### Form Builder Best Practices

**Template Design**
- Create component templates for frequently used form patterns
- Use clear, descriptive names for input components
- Design forms with editor experience in mind
- Balance flexibility with structure
- Document component template purposes

**Component Configuration**
- Configure input components for specific use cases
- Set appropriate validation rules
- Provide helpful labels and descriptions
- Consider default values for common scenarios
- Test forms with actual editorial content

**Post-Import Enhancement**
- Group related input components with `CMS_GROUP` after import
- Add validation rules in SiteArchitect
- Implement conditional logic for complex forms
- Enhance user experience with custom styling
- Add help text and documentation for editors

### Multi-User Considerations

**Important Limitation**: The Template Wizard does not support multi-user operations. Best practices:

- Coordinate wizard usage with team members
- Designate one developer for initial imports
- Use version control for tracking changes
- Document wizard-created templates
- Plan import schedules to avoid conflicts

### Maintenance and Updates

**Version Management**
- Document wizard-generated templates
- Track manual modifications separately
- Create backup before reimporting HTML
- Test updated HTML in isolated environment
- Maintain changelog of template modifications

**Ongoing Development**
- Reserve wizard for initial template creation
- Use SiteArchitect for ongoing modifications
- Avoid reimporting unless necessary
- Keep HTML mockups synchronized with templates
- Document deviations from original HTML

## Common Workflows

### Creating a New Page Template from HTML

1. **Import HTML file** using "Select HTML file" button
2. **Verify asset imports** - Check that images and files imported correctly
3. **Analyze structure** in HTML preview
4. **Define content areas** by selecting editable regions
5. **Create input components** for dynamic content
6. **Configure form elements** using Form Builder
7. **Test in ContentCreator** with sample content
8. **Enhance manually** in SiteArchitect as needed

### Building Reusable Section Templates

1. **Identify repeating patterns** in HTML mockups
2. **Import HTML** containing the section structure
3. **Select section elements** in preview
4. **Create SECTION_TEMPLATE** from selection
5. **Define input components** for variable content
6. **Configure component template** for reusability
7. **Test section** in multiple contexts
8. **Make available** across project

### Converting HTML Forms to FirstSpirit

1. **Import HTML** with form elements
2. **Analyze form structure** and fields
3. **Use Form Builder** to create component templates
4. **Map HTML inputs** to FirstSpirit input components
5. **Configure validation** and constraints
6. **Group related fields** manually with `CMS_GROUP`
7. **Test editorial workflow** in ContentCreator
8. **Document form usage** for editors

### Updating Templates from New HTML Versions

1. **Backup current project** state
2. **Document manual modifications** made since last import
3. **Import updated HTML** (will overwrite existing)
4. **Verify component mappings** remain correct
5. **Reapply manual modifications** from backup
6. **Test thoroughly** before deploying
7. **Update documentation** with changes

## Troubleshooting

### Assets Not Importing

**Problem**: Images or files referenced in HTML don't import automatically

**Solutions**:
- Check that asset paths are relative, not absolute
- Verify assets aren't embedded in JavaScript
- Manually import missing assets through Media Store
- Update references in templates after manual import

### Navigation Not Mapping Correctly

**Problem**: HTML navigation doesn't transfer to FirstSpirit structure

**Solution**: The wizard cannot automatically map navigation. Manually create:
- Navigation structure in SiteArchitect
- Link templates for navigation elements
- Menu templates for dynamic navigation

### Reimport Overwrites Customizations

**Problem**: Reimporting HTML loses manual template modifications

**Prevention**:
- Always backup before reimporting
- Document all manual changes
- Consider if reimport is truly necessary
- Plan to reapply customizations after reimport

### Form Groups Missing

**Problem**: Related form fields aren't grouped

**Solution**: The wizard doesn't create `CMS_GROUP` elements automatically. After import:
- Open template in SiteArchitect
- Add `CMS_GROUP` tags around related input components
- Configure group properties (collapsed, labels, etc.)

### Dynamic Form Features Needed

**Problem**: Need conditional or dynamic form behaviors

**Solution**: Wizard doesn't support dynamic forms. In SiteArchitect:
- Add conditional logic with template syntax
- Implement visibility rules
- Create dependent field behaviors
- Use scripts for complex interactions

## Technical Considerations

### Performance

- Large HTML structures may take time to analyze
- Asset import speed depends on file sizes and quantity
- Preview rendering affected by HTML complexity
- Consider importing complex sites in sections

### Compatibility

- Supports HTML and JSP file formats
- Works with standard HTML form elements
- Compatible with CSS and JavaScript files
- Integrates with FirstSpirit Media Store

### Limitations Summary

The Template Wizard has specific limitations that require manual intervention:

1. **No JavaScript asset handling** - Dynamically loaded assets must be imported manually
2. **No navigation mapping** - Navigation structures require manual configuration
3. **No merge on reimport** - Reimports overwrite existing modifications
4. **No multi-user support** - Single-user tool for template creation
5. **No component grouping** - `CMS_GROUP` must be added manually
6. **No dynamic forms** - Complex form logic requires SiteArchitect

## Summary

The Template Wizard accelerates FirstSpirit template development by automating HTML import and component generation. While powerful for initial template creation, it works best as part of a hybrid approach:

- **Use wizard for**: Initial HTML import, asset transfer, basic component creation, form boilerplates
- **Use SiteArchitect for**: Component grouping, dynamic forms, navigation mapping, complex customizations

By understanding both the capabilities and limitations of the Template Wizard, developers can efficiently create FirstSpirit templates while knowing when to transition to manual development for advanced features.