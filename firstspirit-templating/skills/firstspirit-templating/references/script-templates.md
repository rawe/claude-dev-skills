# Scripts and Script Templates

## Overview

Scripts in FirstSpirit enable the implementation of custom functions and capabilities not yet available in the system. They are particularly useful for:

- Complex migration scenarios
- Connecting external systems
- Custom business logic implementation
- Temporary solutions before module development

### Important Consideration

While scripts provide flexibility, FirstSpirit recommends that **functionalities required and used in the long term should be implemented as a FirstSpirit module** with executable or plugin components for better stability and maintainability.

## BeanShell Scripting Language

FirstSpirit uses **BeanShell** as its scripting language, which provides a powerful yet accessible scripting environment.

### Language Characteristics

**Syntax Foundation:**
- Heavily based on Java programming language
- Much more straightforward than Java in many aspects
- Familiar to Java developers but easier to learn

**Key Features:**
- **Dynamic Typing**: Global variables and functions support dynamic typing, eliminating the need for explicit type declarations in many cases
- **Limited Reflexive Access**: Programs can examine and modify their own structure at runtime
- **Simplified Syntax**: Reduces boilerplate code compared to traditional Java

### BeanShell vs Java

BeanShell maintains Java's familiar syntax while adding convenience features:

```beanshell
// Dynamic typing - no type declaration needed
myVariable = "Hello, FirstSpirit";
myNumber = 42;

// Traditional Java-style typing also supported
String explicitString = "Typed variable";
int explicitNumber = 100;
```

## Script Template Configuration

Scripts in FirstSpirit are configured through a multi-tab interface in SiteArchitect, each serving a specific purpose.

### 1. Properties Tab

Contains the **required script settings** including:
- Script name and identification
- Basic configuration parameters
- Script metadata

### 2. Form Tab

Defines **input components** that are called during script runtime:
- User input fields
- Configuration parameters
- Runtime arguments
- Interactive elements for script execution

**Purpose:** Enables scripts to receive dynamic input from users or system processes when executed.

### 3. Rules Tab

Enables the definition of **rules** that influence elements or properties:
- Conditional logic
- Element behavior modification
- Property dependencies
- Validation rules

**Purpose:** Controls how the script interacts with and affects FirstSpirit elements and their properties.

### 4. Template Set Tab

Houses the **actual BeanShell source code**:
- Script implementation
- Function definitions
- Business logic
- Integration code

**Purpose:** Contains the executable code that performs the script's intended functionality.

## Implementing Custom Functions

Custom functions in FirstSpirit scripts leverage BeanShell's capabilities to extend system functionality.

### Function Definition

Functions can be defined using BeanShell's flexible syntax:

```beanshell
// Simple function with dynamic typing
myFunction(param1, param2) {
    return param1 + param2;
}

// Function with explicit types (Java-style)
String formatName(String firstName, String lastName) {
    return firstName + " " + lastName;
}

// Function with mixed typing
processData(dynamicInput) {
    String result = "Processed: " + dynamicInput;
    return result;
}
```

### Global Variables

Scripts support global variables with dynamic typing:

```beanshell
// Global variable definition
globalCounter = 0;
globalConfig = new HashMap();

// Usage in functions
incrementCounter() {
    globalCounter++;
    return globalCounter;
}
```

## Script Template Usage

### Use Cases

**Migration Scenarios:**
Scripts excel in complex data migration tasks where:
- Custom transformation logic is needed
- Data structures require manipulation
- Legacy system integration is required

**External System Integration:**
Scripts facilitate connections to:
- Third-party APIs
- External databases
- Custom web services
- Legacy systems

**Custom Business Logic:**
Implement specialized functionality for:
- Unique content processing
- Custom validation rules
- Specialized workflow automation

### Best Practices

1. **Temporary vs Permanent Solutions**
   - Use scripts for temporary or experimental features
   - Migrate long-term functionality to FirstSpirit modules

2. **Code Organization**
   - Keep scripts focused on specific tasks
   - Use clear naming conventions
   - Document complex logic

3. **Performance Considerations**
   - Be mindful of script execution time
   - Optimize for frequently-used scripts
   - Consider module development for performance-critical operations

4. **Maintainability**
   - Write clean, readable code
   - Add comments for complex operations
   - Follow consistent coding standards

## Integration with Template Development

Scripts work alongside other template components in FirstSpirit's development ecosystem.

### Template Set Relationship

Scripts exist within the Template Set tab, indicating their close relationship with:
- Page templates
- Section templates
- Format templates
- Other template types

### Runtime Execution

Scripts can be:
- Called from templates
- Triggered by workflows
- Executed manually from SiteArchitect
- Invoked through forms and input components

### Development Workflow

1. **Design**: Plan script functionality and input requirements
2. **Configure**: Set up Properties, Form, and Rules tabs
3. **Implement**: Write BeanShell code in Template Set tab
4. **Test**: Execute and validate script behavior
5. **Deploy**: Integrate with templates and workflows
6. **Migrate**: Convert to module if long-term usage is needed

## Advanced Capabilities

### Reflexive Programming

BeanShell's limited reflexive program access allows scripts to:
- Examine object structures at runtime
- Modify behavior dynamically
- Adapt to changing conditions

### Java Integration

Scripts can leverage Java libraries and classes:

```beanshell
// Import Java classes
import java.util.ArrayList;
import java.text.SimpleDateFormat;

// Use Java objects
list = new ArrayList();
formatter = new SimpleDateFormat("yyyy-MM-dd");
```

### FirstSpirit API Access

Scripts have access to FirstSpirit's API for:
- Content manipulation
- Workflow operations
- Template processing
- System integration

## Reference Resources

For deeper technical information about scripting in FirstSpirit, consult:
- **Template Development Resources**: Scripting section
- **FirstSpirit API Documentation**: For available methods and objects
- **BeanShell Documentation**: For language-specific features and syntax

## Summary

Scripts and script templates in FirstSpirit provide a powerful mechanism for extending system capabilities through BeanShell scripting. While they offer flexibility for temporary solutions and complex integrations, long-term functionality should be implemented as FirstSpirit modules for better stability and maintainability. The four-tab configuration system (Properties, Form, Rules, Template Set) provides a structured approach to script development, enabling developers to create sophisticated custom functions that integrate seamlessly with FirstSpirit's template system.
