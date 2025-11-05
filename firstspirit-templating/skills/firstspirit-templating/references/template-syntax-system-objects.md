# FirstSpirit Template Syntax - System Objects

## Overview

System objects in FirstSpirit provide access to information, data, and objects within templates. They are essential for generating dynamic content, accessing contextual information, and controlling template behavior.

### Key Characteristics

- **Context-dependent**: Availability varies depending on the template context
- **Read-access focus**: Primarily provide read-only access, though some methods can modify objects
- **Expression support**: Compatible with template expressions
- **Return types**: Can return objects or standard data types

### Invocation Syntax

All system objects begin with a hash symbol (#) followed by the object name:

```
$CMS_VALUE(#NAME[.METHOD])$
```

## Available System Objects

| Object | Primary Use | Availability |
|--------|------------|--------------|
| **#global** | Preview, project, page, and multi-page information | All templates |
| **#this** | Currently evaluated object (type varies by context) | Context-dependent |
| **#for** | Loop control within `$CMS_FOR(...)$` instructions | For loops |
| **#field** | Access form input components | FS_BUTTON parameters |
| **#content** | Dom Editor sections and table cells | Format templates |
| **#style** | Style information for tables and cells | Format/style templates |
| **#table/#tr/#cell** | Table structure and formatting details | Table contexts |
| **#meta** | Metadata output | Snippets |
| **#nav** | Menu and navigation information | Navigation contexts |
| **#card** | FS_CATALOG component access | Catalog contexts |

---

## #global System Object

The `#global` system object is available across all FirstSpirit template contexts, making it the most versatile system object for accessing contextual information.

### Primary Functions

- Determination of the currently generated node
- Output of content areas
- Output of context information
- Output and evaluation of meta information
- Output and evaluation of page-specific information
- Evaluation of multiple pages

### Key Feature

Methods of `#global` can be invoked both as context-dependent and context-independent methods, providing flexibility in template development.

### Four Main Categories

#### 1. Preview-related Information

Access information about preview states and preview mode.

**Example:**
```
$CMS_IF(#global.preview)$
  <!-- Content shown only in preview mode -->
$CMS_END_IF$
```

#### 2. Project-related Information

Access project data and configuration.

**Example:**
```
Project ID: $CMS_VALUE(#global.project.id)$
```

#### 3. Page-related Information

Access node and section details for the current page.

**Example:**
```
Node ID: $CMS_VALUE(#global.node.id)$
Page ID: $CMS_VALUE(#global.page.id)$
```

#### 4. Meta and Multi-page Information

Retrieve metadata and handle multiple pages.

### Basic Syntax

```
$CMS_VALUE(#global.METHOD)$
$CMS_SET(#global.METHOD, VALUE)$
```

### Common Use Cases

**Check Preview Mode:**
```
$CMS_IF(#global.preview)$
  <div class="preview-notice">You are in preview mode</div>
$CMS_END_IF$
```

**Access Project Information:**
```
$CMS_SET(project, #global.project)$
Current Project: $CMS_VALUE(project.name)$
```

**Get Current Page Context:**
```
$CMS_SET(currentNode, #global.node)$
$CMS_SET(currentPage, #global.page)$
Page Title: $CMS_VALUE(currentPage.name)$
```

---

## #field System Object

The `#field` object retrieves content and information from input components within forms. Available from FirstSpirit version 5.0.

### Key Characteristics

- **Availability:** Only accessible within the `<PARAMS/>` block of `FS_BUTTON` definitions in XML form structures
- **Core Function:** Provides access to form input components by their variable names
- **Return Type:** `FormField<T>` type object with methods to read properties and content

### Usage Pattern

Accessing a component uses dot notation:

```
#field.st_headline
```

This retrieves the input component named "st_headline" as a `FormField` object.

### Practical Application

Components passed via `#field` can be transmitted to scripts or Java classes as parameters. The parameter name (specified in the `<PARAM>` tag's `name` attribute) becomes available as a variable in scripts or through a `Map<String, String>` object in executable classes.

### Available Methods

The returned object implements the `de.espirit.firstspirit.forms.FormField` interface, providing methods to:

- Retrieve component names
- Access current values
- Check default status
- Examine other component attributes

### Example Usage in FS_BUTTON

```xml
<FS_BUTTON name="validate" hFill="yes">
  <LANGINFOS>
    <LANGINFO lang="*" label="Validate"/>
  </LANGINFOS>
  <PARAMS>
    <PARAM name="headline">#field.st_headline</PARAM>
    <PARAM name="text">#field.st_text</PARAM>
  </PARAMS>
  <ONCLICK>
    <SCRIPT>
      // Access the fields in script
      var headlineField = context.getParameter("headline");
      var textField = context.getParameter("text");

      // Validate content
      if (headlineField.get().isEmpty()) {
        context.showDialog("Headline is required!");
      }
    </SCRIPT>
  </ONCLICK>
</FS_BUTTON>
```

### Use Cases

- Dynamic form validation
- Processing form data in button click handlers
- Passing field values to external scripts or Java classes
- Conditional form behavior based on field states

---

## #for System Object

The `#for` system object is available within `$CMS_FOR(...)$` instructions, enabling developers to track iteration state and control loop execution.

### Properties and Methods

| Feature | Purpose | Return Type | Example |
|---------|---------|------------|---------|
| **#for.index** | Current element's position (zero-indexed) | Integer | `$CMS_VALUE(#for.index)$` |
| **#for.isFirst** | Check if rendering the initial element | Boolean | `$CMS_IF(#for.isFirst)$` |
| **#for.isLast** | Check if rendering the final element | Boolean | `$CMS_IF(#for.isLast)$` |
| **#for.BREAK** | Terminate loop execution prematurely | — | `$CMS_VALUE(#for.BREAK)$` |
| **#for.CONTINUE** | Skip to next iteration | — | `$CMS_VALUE(#for.CONTINUE)$` |
| **#for.CONT** | Skip to next iteration (alias) | — | `$CMS_VALUE(#for.CONT)$` |
| **#for.name** | Returns the object identifier "#for" | String | `$CMS_VALUE(#for.name)$` |

### Practical Examples

#### Example 1: Conditional Wrapper Elements

Output opening and closing table tags only at the beginning and end of iteration:

```
$CMS_FOR(item, items)$
  $CMS_IF(#for.isFirst)$
    <table>
      <thead>
        <tr><th>Item</th></tr>
      </thead>
      <tbody>
  $CMS_END_IF$

  <tr>
    <td>$CMS_VALUE(item.name)$</td>
  </tr>

  $CMS_IF(#for.isLast)$
      </tbody>
    </table>
  $CMS_END_IF$
$CMS_END_FOR$
```

#### Example 2: Adding Separators Between Items

```
$CMS_FOR(category, categories)$
  <span>$CMS_VALUE(category.name)$</span>
  $CMS_IF(!#for.isLast)$ | $CMS_END_IF$
$CMS_END_FOR$
```

Output: `Category1 | Category2 | Category3`

#### Example 3: Early Loop Termination

```
$CMS_FOR(product, products)$
  $CMS_IF(product.stock == 0)$
    $CMS_VALUE(#for.BREAK)$
  $CMS_END_IF$
  <div>$CMS_VALUE(product.name)$ - In Stock</div>
$CMS_END_FOR$
```

#### Example 4: Skipping Elements

```
$CMS_FOR(user, users)$
  $CMS_IF(user.isInactive)$
    $CMS_VALUE(#for.CONTINUE)$
  $CMS_END_IF$
  <div>$CMS_VALUE(user.name)$ - Active</div>
$CMS_END_FOR$
```

#### Example 5: Index-based Operations

```
$CMS_FOR(item, items)$
  <div class="item-$CMS_VALUE(#for.index)$">
    Position: $CMS_VALUE(#for.index + 1)$ of $CMS_VALUE(items.size())$
    <p>$CMS_VALUE(item.text)$</p>
  </div>
$CMS_END_FOR$
```

#### Example 6: Alternating Row Colors

```
$CMS_FOR(row, data)$
  $CMS_IF(#for.index % 2 == 0)$
    <tr class="even">
  $CMS_ELSE$
    <tr class="odd">
  $CMS_END_IF$
    <td>$CMS_VALUE(row.content)$</td>
  </tr>
$CMS_END_FOR$
```

### Use Cases

- Conditional rendering of wrapper elements
- Loop control and early termination
- Tracking element position within iterations
- Skipping specific elements without breaking iteration flow
- Adding separators between list items
- Implementing alternating styles

---

## #style System Object

The `#style` system object enables access to style information in format templates for table rows/cells and in style templates themselves. Available from FirstSpirit Version 4.1 onward.

### Primary Functions

**Access Points:**
- Style template content
- Values stored in inline table cells (DOM Editor with table="yes")

### Predefined Layout Attributes

These reserved identifiers directly impact table appearance in the DOM Editor:

| Identifier | Function | Usage |
|-----------|----------|-------|
| `bgcolor` | Table cell background color | `#style.attr("bgcolor")` |
| `color` | Text font color | `#style.attr("color")` |
| `align` | Horizontal text alignment | `#style.attr("align")` |
| `valign` | Vertical alignment (ContentCreator only) | `#style.attr("valign")` |

### Key Methods & Usage

#### Output Values in Templates

Use `$CMS_VALUE(...)$` instruction to display input component values:

```
<td$CMS_VALUE(if(!bgcolor.isEmpty, " bgcolor=" + bgcolor, ""))$>
  Content
</td>
```

#### Access Cell Properties

Invoke `#style.attr("IDENTIFIER")` to retrieve inline table properties:

```
$CMS_SET(cellBgColor, #style.attr("bgcolor"))$
$CMS_SET(textColor, #style.attr("color"))$
$CMS_SET(alignment, #style.attr("align"))$
```

#### Null Checking

Use `isNull` method (not `isEmpty`) to verify `#style` is set:

```
$CMS_IF(!#style.isNull)$
  <td style="background-color: $CMS_VALUE(#style.attr("bgcolor"))$;">
    Content
  </td>
$CMS_ELSE$
  <td>Content</td>
$CMS_END_IF$
```

### Practical Examples

#### Example 1: Applying Cell Background Color

```
<td$CMS_VALUE(if(!#style.isNull && !#style.attr("bgcolor").isEmpty,
              ' bgcolor="' + #style.attr("bgcolor") + '"',
              ''))$>
  $CMS_VALUE(#content)$
</td>
```

#### Example 2: Complete Cell Styling

```
$CMS_SET(bgcolor, #style.attr("bgcolor"))$
$CMS_SET(color, #style.attr("color"))$
$CMS_SET(align, #style.attr("align"))$
$CMS_SET(valign, #style.attr("valign"))$

<td$CMS_VALUE(if(!bgcolor.isEmpty, ' bgcolor="' + bgcolor + '"', ''))$
   $CMS_VALUE(if(!color.isEmpty, ' style="color:' + color + ';"', ''))$
   $CMS_VALUE(if(!align.isEmpty, ' align="' + align + '"', ''))$
   $CMS_VALUE(if(!valign.isEmpty, ' valign="' + valign + '"', ''))$>
  $CMS_VALUE(#content)$
</td>
```

#### Example 3: Style Template with Custom Attributes

```xml
<!-- Style template definition -->
<CMS_INPUT_TEXT name="bgcolor" hFill="yes">
  <LANGINFOS>
    <LANGINFO lang="*" label="Background Color"/>
  </LANGINFOS>
</CMS_INPUT_TEXT>

<CMS_INPUT_TEXT name="color" hFill="yes">
  <LANGINFOS>
    <LANGINFO lang="*" label="Text Color"/>
  </LANGINFOS>
</CMS_INPUT_TEXT>

<CMS_INPUT_COMBOBOX name="align" hFill="yes">
  <LANGINFOS>
    <LANGINFO lang="*" label="Alignment"/>
  </LANGINFOS>
  <ENTRIES>
    <ENTRY value="left">Left</ENTRY>
    <ENTRY value="center">Center</ENTRY>
    <ENTRY value="right">Right</ENTRY>
  </ENTRIES>
</CMS_INPUT_COMBOBOX>
```

#### Example 4: Format Template Using Styles

```
$CMS_IF(!#style.isNull)$
  $CMS_SET(styleAttrs, "")$

  $CMS_IF(!#style.attr("bgcolor").isEmpty)$
    $CMS_SET(styleAttrs, styleAttrs + "background-color:" + #style.attr("bgcolor") + ";")$
  $CMS_END_IF$

  $CMS_IF(!#style.attr("color").isEmpty)$
    $CMS_SET(styleAttrs, styleAttrs + "color:" + #style.attr("color") + ";")$
  $CMS_END_IF$

  <td style="$CMS_VALUE(styleAttrs)$" align="$CMS_VALUE(#style.attr("align"))$">
    $CMS_VALUE(#content)$
  </td>
$CMS_ELSE$
  <td>$CMS_VALUE(#content)$</td>
$CMS_END_IF$
```

### Important Considerations

1. **Predefined Identifiers**: The predefined identifiers (bgcolor, color, align, valign) must be used for layout options
2. **Component Naming**: These must always be indicated with `name="identifier"` within the input component
3. **Compatibility**: Ensures compatibility with both inline and DOM tables
4. **ContentCreator**: The `valign` attribute is only available in ContentCreator

### Use Cases

- Applying dynamic styling to table cells
- Creating reusable style templates
- Handling inline table cell formatting
- Conditional styling based on user input
- Maintaining consistent formatting across tables

---

## #content System Object

The `#content` system object provides access to DOM Editor sections and table cell content in format templates.

### Primary Functions

- Access content from DOM Editor sections
- Retrieve table cell content
- Output formatted content in templates

### Usage Context

Available in format templates when working with:
- DOM Editor content areas
- Table cells (when table="yes" is set)
- Section content

### Basic Syntax

```
$CMS_VALUE(#content)$
```

### Practical Examples

#### Example 1: Basic Content Output

```
<div class="content-area">
  $CMS_VALUE(#content)$
</div>
```

#### Example 2: Conditional Content

```
$CMS_IF(!#content.isEmpty)$
  <section>
    $CMS_VALUE(#content)$
  </section>
$CMS_ELSE$
  <section class="empty">
    <p>No content available</p>
  </section>
$CMS_END_IF$
```

#### Example 3: Table Cell Content

```
<td$CMS_VALUE(if(!#style.isNull, ' class="styled"', ''))$>
  $CMS_VALUE(#content)$
</td>
```

---

## #this System Object

The `#this` system object represents the currently evaluated object within a template context. The type and available methods vary depending on the context.

### Key Characteristics

- **Context-dependent**: Type changes based on the current template context
- **Self-reference**: Refers to the object currently being processed
- **Dynamic typing**: Methods available depend on the actual object type

### Usage Contexts

- Within content area templates: Refers to the current section
- Within format templates: Refers to the current element being formatted
- Within page templates: Refers to the current page or node

### Basic Syntax

```
$CMS_VALUE(#this.METHOD)$
$CMS_VALUE(#this.property)$
```

### Practical Examples

#### Example 1: Accessing Current Object Properties

```
<h1>$CMS_VALUE(#this.name)$</h1>
<p>ID: $CMS_VALUE(#this.id)$</p>
```

#### Example 2: Conditional Logic Based on Object Type

```
$CMS_IF(#this.class.simpleName == "PageRef")$
  <!-- Page-specific rendering -->
$CMS_ELSE_IF(#this.class.simpleName == "Section")$
  <!-- Section-specific rendering -->
$CMS_END_IF$
```

---

## System Object Best Practices

### 1. Context Awareness

Always be aware of the template context when using system objects:

```
$CMS_IF(!#global.preview)$
  <!-- Production-only code -->
$CMS_END_IF$
```

### 2. Null Checking

Always check for null or empty values before accessing properties:

```
$CMS_IF(!#style.isNull && !#style.attr("bgcolor").isEmpty)$
  <!-- Use style information -->
$CMS_END_IF$
```

### 3. Efficient Loop Control

Use `#for` properties to avoid unnecessary processing:

```
$CMS_FOR(item, items)$
  $CMS_IF(item.isValid)$
    <!-- Process valid items -->
  $CMS_ELSE$
    $CMS_VALUE(#for.CONTINUE)$
  $CMS_END_IF$
$CMS_END_FOR$
```

### 4. Combining System Objects

Leverage multiple system objects together for complex scenarios:

```
$CMS_FOR(page, #global.project.pages)$
  $CMS_IF(#for.index < 10)$
    <div class="page-$CMS_VALUE(#for.index)$">
      $CMS_VALUE(page.name)$
    </div>
  $CMS_ELSE$
    $CMS_VALUE(#for.BREAK)$
  $CMS_END_IF$
$CMS_END_FOR$
```

### 5. Readable Code Structure

Use `$CMS_SET$` to create intermediate variables for better readability:

```
$CMS_SET(bgcolor, #style.attr("bgcolor"))$
$CMS_SET(hasBackground, !bgcolor.isEmpty)$

$CMS_IF(hasBackground)$
  <td bgcolor="$CMS_VALUE(bgcolor)$">
$CMS_ELSE$
  <td>
$CMS_END_IF$
  $CMS_VALUE(#content)$
</td>
```

### 6. Performance Considerations

Cache frequently accessed values:

```
$CMS_SET(isPreview, #global.preview)$
$CMS_SET(currentProject, #global.project)$

$CMS_IF(isPreview)$
  <!-- Use cached value -->
$CMS_END_IF$
```

---

## Common Patterns and Recipes

### Pattern 1: Navigation with Loop Control

```
$CMS_SET(navItems, #global.navigation.items)$
<nav>
  <ul>
    $CMS_FOR(item, navItems)$
      $CMS_IF(!item.isVisible)$
        $CMS_VALUE(#for.CONTINUE)$
      $CMS_END_IF$

      <li$CMS_VALUE(if(#for.isFirst, ' class="first"', ''))$
         $CMS_VALUE(if(#for.isLast, ' class="last"', ''))$>
        <a href="$CMS_VALUE(item.url)$">$CMS_VALUE(item.name)$</a>
      </li>
    $CMS_END_FOR$
  </ul>
</nav>
```

### Pattern 2: Styled Tables with Content

```
$CMS_FOR(row, tableData)$
  $CMS_IF(#for.isFirst)$
    <table>
  $CMS_END_IF$

  <tr>
    $CMS_FOR(cell, row.cells)$
      $CMS_SET(cellStyle, cell.style)$

      <td$CMS_VALUE(if(!cellStyle.isNull && !cellStyle.attr("bgcolor").isEmpty,
                       ' bgcolor="' + cellStyle.attr("bgcolor") + '"',
                       ''))$
         $CMS_VALUE(if(!cellStyle.isNull && !cellStyle.attr("align").isEmpty,
                       ' align="' + cellStyle.attr("align") + '"',
                       ''))$>
        $CMS_VALUE(cell.content)$
      </td>
    $CMS_END_FOR$
  </tr>

  $CMS_IF(#for.isLast)$
    </table>
  $CMS_END_IF$
$CMS_END_FOR$
```

### Pattern 3: Form Field Validation in Buttons

```xml
<FS_BUTTON name="submit" hFill="yes">
  <LANGINFOS>
    <LANGINFO lang="*" label="Submit Form"/>
  </LANGINFOS>
  <PARAMS>
    <PARAM name="title">#field.st_title</PARAM>
    <PARAM name="content">#field.st_content</PARAM>
    <PARAM name="category">#field.st_category</PARAM>
  </PARAMS>
  <ONCLICK>
    <SCRIPT>
      var errors = [];

      var title = context.getParameter("title").get();
      var content = context.getParameter("content").get();
      var category = context.getParameter("category").get();

      if (title.isEmpty()) {
        errors.push("Title is required");
      }

      if (content.isEmpty()) {
        errors.push("Content is required");
      }

      if (category == null) {
        errors.push("Category must be selected");
      }

      if (errors.length > 0) {
        context.showDialog("Validation Errors:\n" + errors.join("\n"));
        return false;
      }

      // Proceed with submission
      return true;
    </SCRIPT>
  </ONCLICK>
</FS_BUTTON>
```

### Pattern 4: Preview-Aware Content Rendering

```
$CMS_SET(isPreview, #global.preview)$
$CMS_SET(currentPage, #global.page)$

$CMS_IF(isPreview)$
  <div class="preview-banner">
    Preview Mode: $CMS_VALUE(currentPage.name)$
  </div>
$CMS_END_IF$

<article>
  <h1>$CMS_VALUE(currentPage.headline)$</h1>
  <div class="content">
    $CMS_VALUE(#content)$
  </div>
</article>

$CMS_IF(isPreview)$
  <div class="preview-info">
    <p>Page ID: $CMS_VALUE(currentPage.id)$</p>
    <p>Last Modified: $CMS_VALUE(currentPage.lastModified)$</p>
  </div>
$CMS_END_IF$
```

### Pattern 5: Complex Iteration with Multiple Controls

```
$CMS_SET(items, #global.project.items)$
$CMS_SET(maxItems, 20)$
$CMS_SET(itemCount, 0)$

$CMS_FOR(item, items)$
  $CMS_IF(itemCount >= maxItems)$
    $CMS_VALUE(#for.BREAK)$
  $CMS_END_IF$

  $CMS_IF(!item.isPublished)$
    $CMS_VALUE(#for.CONTINUE)$
  $CMS_END_IF$

  $CMS_SET(itemCount, itemCount + 1)$

  <div class="item item-$CMS_VALUE(#for.index)$">
    <h3>$CMS_VALUE(item.title)$</h3>
    <p>$CMS_VALUE(item.description)$</p>
  </div>

  $CMS_IF(#for.index % 5 == 4 && !#for.isLast)$
    <div class="separator"></div>
  $CMS_END_IF$
$CMS_END_FOR$
```

---

## Summary

FirstSpirit system objects provide powerful tools for template development:

- **#global**: Universal access to project, page, and context information
- **#field**: Form component access in button parameters
- **#for**: Loop control and iteration management
- **#style**: Style information for tables and cells
- **#content**: DOM Editor and table cell content access
- **#this**: Current object reference in context

By understanding and effectively using these system objects, developers can create dynamic, flexible, and maintainable FirstSpirit templates that respond to context, iterate efficiently, and provide rich user experiences.