# FirstSpirit Template Functions Reference

## Overview

FirstSpirit template functions provide powerful tools for conditional logic, content highlighting, and dynamic template behavior. These functions are essential for creating interactive, editable content experiences in both SiteArchitect and ContentCreator environments.

## Table of Contents

1. [editorId Function](#editorid-function)
2. [if Function](#if-function)
3. [Function Usage Best Practices](#function-usage-best-practices)

---

## editorId Function

### Purpose

The `editorId()` function enables Content Highlighting and EasyEdit functionality in FirstSpirit's SiteArchitect and ContentCreator. It creates unique references to HTML elements within a page, allowing editors to click and edit content directly in the preview interface.

### Basic Syntax

```
$CMS_VALUE(editorId(editorName:"componentName"))$
```

### Parameters

The `editorId()` function supports multiple parameters for controlling editing behavior:

| Parameter | Type | Description | Scope | Required |
|-----------|------|-------------|-------|----------|
| `editorName` | String | UID of the input component to edit | All | Yes (in most cases) |
| `language` | String | Specifies the language for form opening (e.g., "FR", "EN") | ContentCreator | No |
| `entity` | Object | Entity object for database content editing | All | No |
| `template` | Object/String | TableTemplate object or UID for structured content | All | No |
| `view` | Object | Data source (Content2 object) for context | All | No |
| `element` | Object | FirstSpirit objects like GCA or content areas | All | No |
| `target` | Object | Identifies target objects when not directly determinable | All | No |
| `previewRulesEvaluation` | Boolean | Controls rule evaluation (true/false) | ContentCreator | No |
| `resolution` | String | Activates image cropping functionality | ContentCreator | No |
| `reloadPreview` | Boolean | Refreshes entire page after edits | ContentCreator | No |
| `reloadElement` | String | HTML element ID to reload after edits | ContentCreator | No |
| `json` | Boolean | Returns JSON object instead of HTML fragment | ContentCreator | No |
| `meta` | Boolean | Enables metadata editing via InEdit | ContentCreator | No |
| `externalReference` | String | Supports external references with FS_INDEX | ContentCreator | No |

### Usage Examples

#### Block-Level Highlighting

Highlight an entire heading element for editing:

```html
<h3$CMS_VALUE(editorId(editorName:"pt_headline"))$>
  $CMS_VALUE(pt_headline)$
</h3>
```

#### Element-Specific Highlighting

Highlight specific attributes like images:

```html
<img src="$CMS_REF(st_picture)$"
     alt="$CMS_VALUE(st_picture.description)$"
     $CMS_VALUE(editorId(editorName:"st_picture"))$ />
```

#### Language-Specific Editing

Open form in a specific language:

```html
<div$CMS_VALUE(editorId(editorName:"pt_content", language:"FR"))$>
  $CMS_VALUE(pt_content)$
</div>
```

#### Database Content Editing

Enable editing for entity-based content:

```html
<div$CMS_VALUE(editorId(entity:entity, template:"product_template"))$>
  $CMS_VALUE(entity.tt_name)$
</div>
```

#### Reload Control

Refresh specific elements after editing:

```html
<section id="news-section"$CMS_VALUE(editorId(editorName:"st_news", reloadElement:"news-section"))$>
  $CMS_VALUE(st_news)$
</section>
```

#### Image Resolution/Cropping

Enable image cropping interface:

```html
<img src="$CMS_REF(st_banner)$"
     $CMS_VALUE(editorId(editorName:"st_banner", resolution:"1920x400"))$ />
```

#### JSON Output

Return editor data as JSON instead of HTML:

```html
<script>
  var editorData = $CMS_VALUE(editorId(editorName:"pt_data", json:true))$;
</script>
```

### Default Behavior

When no parameters are passed, the current context is used automatically:

```html
<div$CMS_VALUE(editorId())$>
  <!-- Highlights the current section or page -->
</div>
```

### Return Value

Returns an HTML fragment containing editor identifiers (typically as data attributes) that FirstSpirit uses to enable click-to-edit functionality. When `json:true` is specified, returns a JSON object with editor metadata.

### Critical Best Practices

1. **Avoid Empty Tags**: Never create empty HTML tags with only editorId. Tags should contain at least substitute content (e.g., a non-breaking space `&nbsp;`) to ensure highlighting frames display properly.

   **Bad:**
   ```html
   <p$CMS_VALUE(editorId(editorName:"pt_text"))$></p>
   ```

   **Good:**
   ```html
   <p$CMS_VALUE(editorId(editorName:"pt_text"))$>
     $CMS_IF(!pt_text.isEmpty)$
       $CMS_VALUE(pt_text)$
     $CMS_ELSE$
       &nbsp;
     $CMS_END_IF$
   </p>
   ```

2. **Place editorId in Opening Tag**: Always place the editorId function within the opening tag of the HTML element, before the closing `>`.

3. **Combine with Content Output**: Use editorId alongside actual content output to create a seamless editing experience.

### Availability

Available since FirstSpirit Version 4.0

---

## if Function

### Purpose

The `if()` function evaluates conditions in a compact form, enabling conditional output within templates. It's the primary method for implementing conditional logic within `$CMS_VALUE$` instructions, commonly used to verify whether values are set before rendering content.

### Syntax

```
$CMS_VALUE(
  if(
    CONDITION_1,
    CONDITION_TRUE_1,
    CONDITION_2,
    CONDITION_TRUE_2,
    ...,
    CONDITION_N,
    CONDITION_TRUE_N,
    CONDITION_FALSE
  )
)$
```

### Parameters

The `if()` function uses a variable-length parameter structure:

1. **CONDITION_n** (Required for first pair): Boolean expression or comparison
2. **CONDITION_TRUE_n** (Required for first pair): Output when condition is true
3. **CONDITION_FALSE** (Optional): Output when all conditions are false

### Parameter Requirements

- A condition and corresponding true-branch execution are mandatory
- All other condition/true-branch pairs are optional
- Only one false-branch is permitted, regardless of the number of conditions
- The function must be used within `$CMS_VALUE(...)$` instructions

### Condition Structure

Conditions can be constructed using up to three components:

1. **Variable or constant** - The value to evaluate
2. **Operator** (optional) - Comparison or logical operator
3. **Comparable value** (optional) - The value to compare against

Expressions that return Boolean values (e.g., `#global.preview`) don't require operators or comparison values.

### Evaluation Logic

1. Conditions are evaluated in order from first to last
2. The first condition that evaluates to true triggers its corresponding true-branch
3. If no conditions evaluate to true, the false-branch executes (if provided)
4. No output occurs if no condition is met and no false-branch exists

### Supported Operators

Conditions support standard comparison and logical operators:

- **Comparison**: `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Logical**: `&&` (AND), `||` (OR), `!` (NOT)
- **String/Collection**: `isEmpty`, `isSet`, `contains`

### Usage Examples

#### Simple Condition Check

Check if preview mode is active:

```
$CMS_VALUE(if(#global.preview, "Preview Mode", "Live Mode"))$
```

#### Field Validation

Output default text when field is empty:

```
$CMS_VALUE(if(!lt_text.isEmpty, lt_text, "Link"))$
```

#### Multiple Conditions

Evaluate multiple conditions in sequence:

```
$CMS_VALUE(
  if(
    st_type == "news",
    "News Article",
    st_type == "blog",
    "Blog Post",
    st_type == "product",
    "Product Page",
    "Standard Page"
  )
)$
```

#### Nested Logic with Boolean Expressions

Complex condition with preview and content checks:

```
$CMS_VALUE(
  if(
    #global.preview && pt_draft.isEmpty,
    "Draft content not available in preview",
    !pt_draft.isEmpty,
    pt_draft,
    pt_published
  )
)$
```

#### Loop-Based Conditional Output

Use modulo operations within loops:

```
$CMS_FOR(item, items)$
  <div class="$CMS_VALUE(if(itemStat.index % 2 == 0, "even", "odd"))$">
    $CMS_VALUE(item.name)$
  </div>
$CMS_END_FOR$
```

#### Comparison with Variables

Check against dynamic values:

```
$CMS_VALUE(
  if(
    product.stock > 0,
    "In Stock",
    product.stock == 0,
    "Out of Stock",
    "Pre-Order"
  )
)$
```

#### Boolean Property Checks

Direct boolean evaluation:

```
$CMS_VALUE(if(page.isVisible, "visible", "hidden"))$
```

#### String Comparison

Compare string values:

```
$CMS_VALUE(
  if(
    user.role == "admin",
    '<a href="/admin">Admin Panel</a>',
    user.role == "editor",
    '<a href="/editor">Editor Panel</a>',
    '<a href="/profile">My Profile</a>'
  )
)$
```

#### Null/Empty Checks

Verify content existence before output:

```
$CMS_VALUE(
  if(
    !st_image.isSet,
    "/assets/placeholder.jpg",
    st_image.url
  )
)$
```

### Advanced Patterns

#### Cascading Conditions with Fallbacks

```
$CMS_VALUE(
  if(
    !pt_custom_title.isEmpty,
    pt_custom_title,
    !pt_headline.isEmpty,
    pt_headline,
    page.displayName
  )
)$
```

#### Complex Boolean Logic

```
$CMS_VALUE(
  if(
    (status == "published" || status == "scheduled") && !content.isEmpty,
    content,
    (status == "draft" && #global.preview),
    "Draft: " + content,
    "No content available"
  )
)$
```

#### Type-Based Rendering

```
$CMS_VALUE(
  if(
    element.isType("FS_DATASET"),
    element.formData.tt_name,
    element.isType("FS_CATALOG"),
    element.entity.identifier,
    element.name
  )
)$
```

### Important Notes

1. **Context Limitation**: The `if()` function works only within `$CMS_VALUE(...)$` instructions. For more complex conditional logic, use `$CMS_IF$...$CMS_END_IF$` blocks.

2. **Operator Precedence**: Standard operator precedence rules apply. Use parentheses to explicitly control evaluation order in complex conditions.

3. **Short-Circuit Evaluation**: Conditions are evaluated left-to-right, and evaluation stops at the first true condition.

4. **Type Sensitivity**: Be aware of type conversions when comparing values. String "0" and numeric 0 may behave differently.

5. **Performance**: For simple true/false checks, `if()` is more efficient than full `$CMS_IF$` blocks.

### Availability

Available since FirstSpirit Version 4.0

---

## Function Usage Best Practices

### General Guidelines

1. **Choose the Right Tool**:
   - Use `if()` function for simple inline conditionals within `$CMS_VALUE$`
   - Use `$CMS_IF$...$CMS_END_IF$` blocks for complex multi-line logic
   - Use `$CMS_SWITCH$` for multiple exclusive conditions

2. **Readability**:
   - Format complex `if()` functions with clear indentation
   - Use meaningful variable names in conditions
   - Add comments for non-obvious conditional logic

3. **Performance**:
   - Place most likely conditions first in multi-condition checks
   - Cache repeated calculations in variables before use in conditions
   - Avoid unnecessary `editorId()` calls on non-editable elements

4. **Maintainability**:
   - Extract complex conditions into BeanShell or script variables
   - Document expected data types and possible values
   - Use consistent naming conventions across templates

### Combining editorId with if

Create editable elements with conditional content:

```html
<h2$CMS_VALUE(editorId(editorName:"pt_headline"))$>
  $CMS_VALUE(if(!pt_headline.isEmpty, pt_headline, "Untitled Section"))$
</h2>
```

### Error Prevention

1. **Null Safety**: Always check if objects are set before accessing properties:
   ```
   $CMS_VALUE(if(entity.isSet && !entity.tt_name.isEmpty, entity.tt_name, "N/A"))$
   ```

2. **Empty Content Handling**: Provide meaningful fallbacks:
   ```
   $CMS_VALUE(if(!content.isEmpty, content, "&nbsp;"))$
   ```

3. **Type Validation**: Verify types before operations:
   ```
   $CMS_VALUE(if(value.isType("NUMBER") && value > 0, value, 0))$
   ```

### Testing Functions

1. Test in both preview and live modes
2. Verify behavior with empty/null values
3. Check all conditional branches
4. Validate editorId highlighting in ContentCreator
5. Test with different user roles and permissions

---

## Additional Resources

- FirstSpirit Template Syntax Documentation
- FirstSpirit Function Reference
- ContentCreator InEdit Documentation
- FirstSpirit Best Practices Guide

## Version Compatibility

- `editorId()`: Available since FirstSpirit 4.0
- `if()`: Available since FirstSpirit 4.0

Always check your FirstSpirit version for specific feature availability and behavior.
