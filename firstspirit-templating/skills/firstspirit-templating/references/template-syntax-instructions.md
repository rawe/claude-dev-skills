# FirstSpirit Template Syntax - Instructions Reference

## Overview

FirstSpirit template instructions are special tags that enable dynamic content generation, control flow, variable manipulation, and template composition. All instructions follow the pattern `$CMS_...(...)$` where the content inside the brackets is always an expression.

### Key Characteristics

- **Structure**: Begin with `$CMS_` and end with `)$`
- **Expression-based**: Content within brackets is evaluated as expressions
- **Nesting**: Support unlimited nesting depth for complex logic
- **Block syntax**: Complex instructions use opening/closing tag pairs (e.g., `$CMS_SET(...)$ ... $CMS_END_SET$`)
- **Parameters**: Multiple parameters separated by commas using `IDENTIFIER:"VALUE"` format

### Critical Limitation

Expressions within `<CMS_HEADER>` tags remain unresolved - this is one of the main sources of errors in template development.

---

## Complete Instruction List

FirstSpirit provides the following core instructions:

- **$CMS_VALUE** - Output variable values and expressions
- **$CMS_SET** - Define variables and assign values
- **$CMS_IF** - Conditional output based on criteria
- **$CMS_FOR** - Loop and iteration control
- **$CMS_SWITCH** - Multi-case conditional branching
- **$CMS_RENDER** - Render templates and execute scripts
- **$CMS_INCLUDE** - Include external file content
- **$CMS_REF** - Resolve references to store objects
- **$CMS_TRIM** - Remove unnecessary whitespace

---

## $CMS_VALUE

### Purpose

Outputs variable contents, input component values, and expression results within templates, making them visible in browsers.

### Syntax

```
$CMS_VALUE(VARIABLE)$
$CMS_VALUE(CONSTANT)$
$CMS_VALUE(EXPRESSION)$
$CMS_VALUE(OBJECT1, default:OBJECT2)$
```

### Parameters

- **VARIABLE/CONSTANT/EXPRESSION**: Required. The value to output.
- **default**: Optional. Fallback content when the primary value is undefined.

### Features

**Variable Output with Dot Notation:**
```
$CMS_VALUE(myVariable.attributeName)$
```

**Expression Evaluation:**
```
$CMS_VALUE(myNumber + 2)$
$CMS_VALUE(6 * 7)$  <!-- Outputs: 42 -->
```

**Default Values:**
```
$CMS_VALUE(VARIABLENAME, default:"--VALUE NOT SET--")$
```

**Method Invocation:**
```
$CMS_VALUE(characterstring.contains("text"))$
$CMS_VALUE("1" == "1")$  <!-- Outputs: true -->
$CMS_VALUE(true || false)$  <!-- Outputs: true -->
```

### Best Practices

**Error Prevention:**
Always test for null/empty values before output:

```
$CMS_IF(!VARIABLE.isNull)$
  $CMS_VALUE(VARIABLE)$
$CMS_END_IF$
```

**Checking Methods:**
- `.isNull()` - Test for null values
- `.isEmpty()` - Check if empty
- `.isSet()` - Check if defined (use cautiously)

**Caution**: While `isSet()` and default parameters suppress errors, they may complicate debugging and risk unintended output on generated pages.

---

## $CMS_SET

### Purpose

Enables variable definition within templates and assigns values to variables. Supports both immediate object allocation and deferred template fragment execution.

### Syntax

**Variant 1 - Object Allocation (Immediate Execution):**
```
$CMS_SET(IDENTIFIER, OBJECT)$
```

**Variant 2 - Template Fragment (Deferred Execution):**
```
$CMS_SET(IDENTIFIER)$
  BODY OF THE TEMPLATE FRAGMENT
$CMS_END_SET$
```

Multiple variables can be defined in a single statement using comma separation.

### Parameters

- **IDENTIFIER**: Required. Variable name containing only A-Z, a-z, 0-9, and underscore characters.
- **OBJECT**: Required for Variant 1. Can be a constant, variable, or expression.
- **BODY**: Required for Variant 2. Template fragment content that executes when the variable is evaluated.

### Supported Instructions in Body

Template fragment bodies support:
- `$CMS_IF(...)$`
- `$CMS_REF(...)$`
- `$CMS_SET(...)$`
- `$CMS_VALUE(...)$`

### Critical Restrictions

- Neither IDENTIFIER nor OBJECT parameters may contain `$CMS_VALUE(...)$` expressions
- Using an identifier within its own template fragment body causes infinite loops
- Variant 1 executes immediately at definition
- Variant 2 defers execution until variable evaluation

### Usage Examples

**Simple Variable Assignment:**
```
$CMS_SET(myVariable, "Hello World")$
$CMS_SET(count, 42)$
```

**Expression Resolution:**
```
$CMS_SET(result, (5 + 3).toString)$
```

**Creating Collections:**
```
$CMS_SET(mySet, { })$  <!-- Empty set -->
$CMS_SET(myList, [])$  <!-- Empty list -->
$CMS_SET(myList, ["item1", "item2", "item3"])$
```

**Language-Dependent Values:**
Use maps to store multilingual content indexed by language abbreviations:
```
$CMS_SET(greetings, {
  "en": "Welcome",
  "de": "Willkommen",
  "fr": "Bienvenue"
})$
```

**Template Fragments:**
Template fragments execute body code when called, allowing dynamic value reassignment:
```
$CMS_SET(dynamicContent)$
  <p>Generated at: $CMS_VALUE(#global.now)$</p>
$CMS_END_SET$
```

---

## $CMS_IF

### Purpose

Checks a comparable value for 'true' or 'false' and controls output depending on the determined value. Enables conditional logic in templates.

### Syntax

**Basic Structure:**
```
$CMS_IF(CONDITION)$
  EXECUTION PART (FULFILLED CONDITION)
$CMS_END_IF$
```

**With Else Clause:**
```
$CMS_IF(CONDITION)$
  EXECUTION PART (FULFILLED)
$CMS_ELSE$
  EXECUTION PART (UNFULFILLED)
$CMS_END_IF$
```

**With Multiple Conditions:**
```
$CMS_IF(CONDITION_1)$
  EXECUTION PART (FULFILLED CONDITION_1)
$CMS_ELSIF(CONDITION_2)$
  EXECUTION PART (FULFILLED CONDITION_2)
$CMS_ELSIF(CONDITION_3)$
  EXECUTION PART (FULFILLED CONDITION_3)
$CMS_ELSE$
  EXECUTION PART (UNFULFILLED CONDITIONS)
$CMS_END_IF$
```

### Parameters

**CONDITION**: Required. A boolean expression consisting of:
1. Variable or constant
2. Operator (optional)
3. Comparable value (optional)

### Valid Conditions

```
1 == 1
a != b
count > 10
#global.preview
myVariable.isEmpty()
```

### Features

- Supports nested conditions of any depth
- `$CMS_ELSIF(...)$` combines else and if functionality
- Boolean-returning methods require no operator or comparable value
- Multiple `$CMS_ELSE$` and `$CMS_ELSIF$` tags allowed

### Examples

**Simple Condition:**
```
$CMS_IF(!myVariable.isNull)$
  $CMS_VALUE(myVariable)$
$CMS_END_IF$
```

**With Else:**
```
$CMS_IF(#global.preview)$
  <div class="preview-mode">Preview Mode Active</div>
$CMS_ELSE$
  <div class="live-mode">Live Mode</div>
$CMS_END_IF$
```

**Multiple Conditions:**
```
$CMS_IF(userRole == "admin")$
  <button>Edit</button>
  <button>Delete</button>
$CMS_ELSIF(userRole == "editor")$
  <button>Edit</button>
$CMS_ELSE$
  <span>Read-only access</span>
$CMS_END_IF$
```

**Nested Conditions:**
```
$CMS_IF(!user.isNull)$
  $CMS_IF(user.isActive)$
    Welcome, $CMS_VALUE(user.name)$!
  $CMS_ELSE$
    Your account is inactive.
  $CMS_END_IF$
$CMS_END_IF$
```

---

## $CMS_FOR

### Purpose

Enables loop implementation within FirstSpirit templates for iterating over collections, lists, maps, and number ranges. Available since FirstSpirit 4.0, replacing the iterative functionality previously handled by `$CMS_RENDER(...)$`.

### Syntax

```
$CMS_FOR(IDENTIFIER, OBJECT)$
  LOOP BODY
$CMS_END_FOR$
```

### Parameters

- **IDENTIFIER**: Required. Variable name representing the current object during each iteration.
- **OBJECT**: Required. A set-valued element to iterate over.

### Object Types

**Number Set (Integers Only):**
```
[STARTVALUE .. ENDVALUE]
```

**List:**
```
[OBJECT_1, OBJECT_2, ..., OBJECT_N]
```

**Map:**
```
{KEY_1: VALUE_1, ..., KEY_N: VALUE_N}
```

### System Object: #for

Within the loop body, the `#for` system object provides metadata:

- **#for.index**: Current iteration count (zero-based)

### Examples

**Iterating Over a List:**
```
$CMS_FOR(item, ["apple", "banana", "cherry"])$
  <li>$CMS_VALUE(item)$</li>
$CMS_END_FOR$
```

**Number Range Iteration:**
```
$CMS_FOR(num, [7 .. 14])$
  <div>Number: $CMS_VALUE(num)$</div>
$CMS_END_FOR$
```

**Using Loop Index:**
```
$CMS_FOR(product, productList)$
  <div class="product-$CMS_VALUE(#for.index)$">
    $CMS_VALUE(product.name)$
  </div>
$CMS_END_FOR$
```

**Map Iteration:**
```
$CMS_FOR(entry, languageMap)$
  <p>
    Language: $CMS_VALUE(entry.key)$
    Translation: $CMS_VALUE(entry.value)$
  </p>
$CMS_END_FOR$
```

**Complex List Iteration:**
```
$CMS_FOR(page, #global.node.children)$
  $CMS_IF(!page.isNull && page.isReleased)$
    <a href="$CMS_REF(page)$">$CMS_VALUE(page.displayName)$</a>
  $CMS_END_IF$
$CMS_END_FOR$
```

### Intended Uses

- Outputting lists and complex elements
- Executing instructions iteratively
- Generating repetitive HTML structures
- Processing collections and datasets

---

## $CMS_SWITCH

### Purpose

Enables conditional output based on multiple possible values of a single variable, functioning as a case-differentiation mechanism within FirstSpirit templates.

### Syntax

```
$CMS_SWITCH(OBJECT)$
  STANDARDEXECUTIONPART
  $CMS_CASE(CONDITION_1)$
    EXECUTIONPART_1
  $CMS_CASE(CONDITION_2)$
    EXECUTIONPART_2
  ...
  $CMS_CASE(CONDITION_N)$
    EXECUTIONPART_N
$CMS_END_SWITCH$
```

### Parameters

- **OBJECT**: Required. The value being evaluated. Can be a constant, variable, expression, or method call.
- **CONDITION**: Required for each case. The value to match against. Can be a constant, variable, expression, or class definition.

### Evaluation Logic

The instruction compares each `$CMS_CASE(...)$` condition sequentially against the provided object. When a match occurs, its corresponding execution block runs. If no conditions match, the default section (content before the first case) executes.

### Default Case Handling

Content preceding the first `$CMS_CASE(...)$` block serves as the default, executing when no case conditions match:

```
$CMS_SWITCH(value)$
  Default content here
  $CMS_CASE("option1")$
    Option 1 content
  $CMS_CASE("option2")$
    Option 2 content
$CMS_END_SWITCH$
```

### Examples

**Language-Dependent Output:**
```
$CMS_SWITCH(#global.language.abbreviation.toLowerCase)$
  Welcome!
  $CMS_CASE("de")$
    Willkommen!
  $CMS_CASE("en")$
    Welcome!
  $CMS_CASE("fr")$
    Bienvenue!
$CMS_END_SWITCH$
```

**Type Checking:**
```
$CMS_SWITCH(_var)$
  Unknown type
  $CMS_CASE(class("java.lang.String"))$
    This is a String
  $CMS_CASE(class("java.math.BigInteger"))$
    This is an Integer
  $CMS_CASE(class("java.lang.Boolean"))$
    This is a Boolean
$CMS_END_SWITCH$
```

**User Role Handling:**
```
$CMS_SWITCH(user.role)$
  <span>Guest</span>
  $CMS_CASE("admin")$
    <button>Admin Panel</button>
  $CMS_CASE("editor")$
    <button>Edit Content</button>
  $CMS_CASE("viewer")$
    <span>View Only</span>
$CMS_END_SWITCH$
```

**Status-Based Styling:**
```
$CMS_SWITCH(orderStatus)$
  $CMS_CASE("pending")$
    <span class="status-pending">Pending</span>
  $CMS_CASE("shipped")$
    <span class="status-shipped">Shipped</span>
  $CMS_CASE("delivered")$
    <span class="status-delivered">Delivered</span>
  $CMS_CASE("cancelled")$
    <span class="status-cancelled">Cancelled</span>
$CMS_END_SWITCH$
```

---

## $CMS_RENDER

### Purpose

Used within a template to evaluate another output channel at the calling point, integrate the content of a format template, or call a script. Provides template composition and script execution capabilities.

### Syntax

**Template Rendering:**
```
$CMS_RENDER(template:"IDENTIFIER", PARAM_1:VALUE_1, ...)$
```

**Script Execution:**
```
$CMS_RENDER(script:"IDENTIFIER", PARAM_1:VALUE_1, ...)$
```

**Output Channel Inclusion:**
```
$CMS_RENDER(#this, templateSet:"IDENTIFIER", pinTemplateSet:BOOLEAN)$
```

### Parameters

**Required (Mutually Exclusive):**
- **template**: Format template identifier for integration
- **script**: Template-type script identifier created in the project
- **#this**: Reference to current template for output channel rendering

**Optional:**
- **templateSet**: Identifies which output channel to render
- **pinTemplateSet**: Boolean controlling channel context behavior (default: true)
  - `true`: Nested template calls remain in the specified channel
  - `false`: Nested calls revert to the original channel
- **User-defined parameters**: Custom values passed as `IDENTIFIER:VALUE` pairs

### Important Constraints

- The identifiers `template`, `script`, or `version` should not be used for user-specified parameters
- Template and script parameters are mandatory when used
- All other parameters remain optional

### Context Behavior

`$CMS_RENDER` creates isolated contexts, preventing external variable overwrites - unlike `$CMS_VALUE` calls, which operate within existing scopes.

### Examples

**Render a Format Template:**
```
$CMS_RENDER(template:"header", pageTitle:"Home Page", showNav:true)$
```

**Execute a Script:**
```
$CMS_RENDER(script:"calculateTotals", items:cartItems, taxRate:0.08)$
```

**Output Another Channel:**
```
$CMS_RENDER(#this, templateSet:"print")$
```

**Render with Custom Parameters:**
```
$CMS_RENDER(
  template:"product-card",
  product:currentProduct,
  showPrice:true,
  currency:"USD"
)$
```

**Pinned Template Set:**
```
$CMS_RENDER(#this, templateSet:"mobile", pinTemplateSet:true)$
```

---

## $CMS_INCLUDE

### Purpose

Inserts contents of a file from the Media Store into a template. Useful for including static content, external files, or reusable content fragments.

### Syntax

```
$CMS_INCLUDE(
  IDENTIFIER,
  parse:BOOLEAN_VALUE,
  encoding:ENCODING,
  language:LANGUAGEABBREVIATION
)$
```

### Parameters

- **IDENTIFIER**: Required. Object reference using format `type:"name"` or variable name
  - `media:"filename"` - Files/pictures from Media Store
  - `file:"filename"` - Files from Media Store
- **parse**: Optional. Controls FirstSpirit expression processing
  - `true`: Expressions are replaced
  - `false`: Expressions remain unchanged
  - Default: Uses file's Media Store setting
- **encoding**: Optional. Character encoding for output
  - Accepts any Java-supported charset
  - Default: Uses file's Media Store setting
- **lang/language**: Optional. Project language version
  - Accepts language abbreviation in quotes (e.g., `"DE"`, `"EN"`)
  - Alternative: Pass language instance like `#global.project.masterLanguage`
  - Useful for language-dependent media

### Key Behavioral Differences

**Parsed (parse:true):**
Variable references within included files get evaluated and replaced with actual values.

**Unparsed (parse:false):**
FirstSpirit expressions remain as literal text in output.

### Examples

**Basic File Inclusion:**
```
$CMS_INCLUDE(media:"header.html")$
```

**With Parsing Enabled:**
```
$CMS_INCLUDE(media:"template-fragment.html", parse:true)$
```

**Specific Encoding:**
```
$CMS_INCLUDE(file:"content.txt", encoding:"UTF-8")$
```

**Language-Specific Media:**
```
$CMS_INCLUDE(
  media:"welcome-message.html",
  language:"DE",
  parse:true
)$
```

**Using Variable Reference:**
```
$CMS_SET(includedFile, mediaReference)$
$CMS_INCLUDE(includedFile, parse:false)$
```

**Master Language Content:**
```
$CMS_INCLUDE(
  media:"global-footer.html",
  language:#global.project.masterLanguage,
  parse:true
)$
```

---

## $CMS_REF

### Purpose

Resolves references to objects stored across FirstSpirit's separate stores (Page Store, Media Store, Site Store, Template Store) into usable paths for browsers and processors.

### Syntax

```
$CMS_REF(
  IDENTIFIER,
  abs:VALUE,
  contentId:VALUE,
  index:VALUE,
  lang:"LANGUAGE",
  postfix:IDENTIFIER,
  remote:IDENTIFIER,
  res:"RESOLUTION",
  template:IDENTIFIER,
  templateSet:"CHANNEL",
  version:NUMBER
)$
```

Only IDENTIFIER is mandatory; all other parameters are optional.

### Parameters

**IDENTIFIER (Required):**
References objects by type and name:
- `media:"filename"` - Media Store files/pictures
- `pageref:"name"` - Site Store pages/document groups
- `pagefolder:"name"` - Site Store menu levels
- Supports variable names and method invocations

**abs (Path Control):**
- `abs:0` - Relative paths (default)
- `abs:1` - Absolute with prefix
- `abs:2` - Absolute without prefix
- `abs:3` - Internal processor URLs
- `abs:4` - External processor URLs

**lang/language:**
Specifies project language (e.g., `"DE"`, `"EN"`)

**res/resolution:**
Designates image resolution other than original (e.g., `"SCALED"`, `"100_HOCH"`)

**contentId:**
Retrieves URL for specific dataset by ID in content projections

**index:**
Determines URL for specific sub-page in multi-page projections

**postfix:**
Attempts reference with suffix first, then falls back to unsuffixed version

**remote:**
Links to Remote project objects via symbolic name

**template:**
Restricts contentId search to specific table template UID

**templateSet/version:**
Switches between presentation channels (print versions, etc.)

### Important Constraints

- Do not nest `$CMS_REF(...)$` and `$CMS_VALUE(...)$` instructions
- Avoid numerical suffixes for postfix parameters to prevent reference name conflicts
- Remote media access requires valid licensing
- Different remote/target projects may have resolutions with identical names requiring careful specification

### Examples

**Basic Media Reference:**
```
<img src="$CMS_REF(media:"logo.png")$" alt="Logo">
```

**Page Reference:**
```
<a href="$CMS_REF(pageref:"about-us")$">About Us</a>
```

**Absolute Path:**
```
$CMS_REF(media:"stylesheet.css", abs:1)$
```

**Image with Resolution:**
```
<img src="$CMS_REF(media:"hero-image", res:"100_HOCH")$" alt="Hero">
```

**Language-Specific Reference:**
```
$CMS_REF(pageref:"homepage", lang:"DE")$
```

**Print Version:**
```
<a href="$CMS_REF(#global.node, templateSet:"print")$">Print Version</a>
```

**Dataset Reference:**
```
$CMS_REF(pageref:"products", contentId:374)$
```

**Remote Project Reference:**
```
$CMS_REF(media:"shared-asset", remote:"corporate-assets")$
```

**Current Page in Different Channel:**
```
$CMS_REF(#global.node, templateSet:"mobile")$
```

**Page Folder Navigation:**
```
$CMS_FOR(child, #global.node.parent.children)$
  <a href="$CMS_REF(child)$">$CMS_VALUE(child.displayName)$</a>
$CMS_END_FOR$
```

---

## Control Flow and Logic Operations

### Conditional Logic Patterns

FirstSpirit provides multiple approaches for conditional logic:

**Simple Conditions:**
Use `$CMS_IF` for basic true/false decisions:
```
$CMS_IF(condition)$
  Execute when true
$CMS_END_IF$
```

**Binary Choices:**
Use `$CMS_IF` with `$CMS_ELSE` for either/or scenarios:
```
$CMS_IF(condition)$
  Option A
$CMS_ELSE$
  Option B
$CMS_END_IF$
```

**Multiple Conditions:**
Use `$CMS_IF` with `$CMS_ELSIF` for sequential condition checking:
```
$CMS_IF(condition1)$
  Result 1
$CMS_ELSIF(condition2)$
  Result 2
$CMS_ELSIF(condition3)$
  Result 3
$CMS_ELSE$
  Default result
$CMS_END_IF$
```

**Multi-Case Branching:**
Use `$CMS_SWITCH` when checking a single value against multiple possibilities:
```
$CMS_SWITCH(value)$
  Default case
  $CMS_CASE(option1)$
    Handle option 1
  $CMS_CASE(option2)$
    Handle option 2
$CMS_END_SWITCH$
```

### Loop Patterns

**Iterating Collections:**
```
$CMS_FOR(item, collection)$
  Process $CMS_VALUE(item)$
$CMS_END_FOR$
```

**Number Ranges:**
```
$CMS_FOR(i, [1 .. 10])$
  Iteration $CMS_VALUE(i)$
$CMS_END_FOR$
```

**Map Iteration:**
```
$CMS_FOR(entry, mapObject)$
  Key: $CMS_VALUE(entry.key)$
  Value: $CMS_VALUE(entry.value)$
$CMS_END_FOR$
```

**Conditional Loops:**
Combine loops with conditions:
```
$CMS_FOR(page, pages)$
  $CMS_IF(!page.isNull && page.isReleased)$
    <a href="$CMS_REF(page)$">$CMS_VALUE(page.displayName)$</a>
  $CMS_END_IF$
$CMS_END_FOR$
```

### Variable Scope and Context

**Local Variables:**
Variables defined with `$CMS_SET` have local scope within their template context:
```
$CMS_SET(localVar, "value")$
```

**Template Fragments:**
Deferred execution for dynamic content:
```
$CMS_SET(fragment)$
  Content with $CMS_VALUE(#global.now)$
$CMS_END_SET$
```

**Isolated Contexts:**
`$CMS_RENDER` creates isolated variable contexts preventing overwrites:
```
$CMS_RENDER(template:"subtemplate", param1:value1)$
```

### Common Patterns

**Null-Safe Output:**
```
$CMS_IF(!variable.isNull)$
  $CMS_VALUE(variable)$
$CMS_ELSE$
  Default content
$CMS_END_IF$
```

**List Processing:**
```
$CMS_SET(items, [])$
$CMS_FOR(item, sourceList)$
  $CMS_IF(item.isActive)$
    $CMS_SET(items, items + [item])$
  $CMS_END_IF$
$CMS_END_FOR$
```

**Language-Dependent Content:**
```
$CMS_SWITCH(#global.language.abbreviation)$
  English content
  $CMS_CASE("de")$
    German content
  $CMS_CASE("fr")$
    French content
$CMS_END_SWITCH$
```

---

## Best Practices Summary

### Error Prevention

1. **Always check for null/empty values** before output
2. **Use conditional wrappers** around `$CMS_VALUE` calls
3. **Test expressions** with `.isNull()` and `.isEmpty()` methods
4. **Avoid `$CMS_VALUE` in `CMS_HEADER`** tags (expressions won't resolve)

### Variable Management

1. **Use descriptive identifiers** following naming conventions
2. **Avoid circular references** in template fragments
3. **Apply `.toString` method** to resolve expressions immediately when needed
4. **Create isolated contexts** with `$CMS_RENDER` to prevent variable conflicts

### Performance

1. **Prefer `$CMS_SWITCH`** over multiple nested `$CMS_IF` statements for multi-case logic
2. **Use template fragments** for deferred execution when appropriate
3. **Minimize nested instructions** where possible
4. **Cache complex expressions** in variables using `$CMS_SET`

### Code Organization

1. **Use meaningful parameter names** in `$CMS_RENDER` calls
2. **Break complex logic** into separate format templates
3. **Document template fragments** with comments
4. **Follow consistent indentation** for readability

### Reference Handling

1. **Don't nest `$CMS_REF` and `$CMS_VALUE`** instructions
2. **Use appropriate path modes** (abs parameter) for context
3. **Specify language explicitly** for multilingual sites
4. **Test remote references** with proper licensing

---

## Troubleshooting Common Issues

### Expressions Not Resolving

**Problem**: Variables show as literal text instead of values.
**Solution**: Ensure expressions are outside `<CMS_HEADER>` tags and use proper syntax.

### Infinite Loops

**Problem**: Template hangs during generation.
**Solution**: Check for self-referencing identifiers in template fragment bodies.

### Null Pointer Errors

**Problem**: Generation fails with null reference errors.
**Solution**: Add null checks before accessing object properties:
```
$CMS_IF(!object.isNull)$
  $CMS_VALUE(object.property)$
$CMS_END_IF$
```

### Incorrect Context in Nested Templates

**Problem**: Variables from parent template overwrite child template variables.
**Solution**: Use `$CMS_RENDER` instead of `$CMS_INCLUDE` for proper context isolation.

### Reference Resolution Failures

**Problem**: `$CMS_REF` returns empty or incorrect paths.
**Solution**: Verify object exists, check store type matches reference type, ensure proper language/resolution parameters.
