# FirstSpirit Rules and Dynamic Forms

## Overview

FirstSpirit rules enable template developers to create dynamic forms that automatically adjust based on user input and content state. These rules function seamlessly across both SiteArchitect and ContentCreator environments, providing real-time form manipulation capabilities.

### Key Capabilities

Rules allow developers to:

1. **Validate form content** - Check conditions such as whether dates fall within required timeframes, validate field lengths, or ensure required fields contain appropriate data
2. **Control field visibility** - Dynamically hide or show form elements based on specific conditions or user selections
3. **Establish relationships** - Create dependencies where one field's value affects others (e.g., supplier selection filtering available product options)
4. **Manipulate form properties** - Modify editability, focus, selections, and other component properties dynamically

### Execution Timing

Rules analyze form states at three critical stages:

- **During editorial input** - Real-time evaluation as users interact with the form
- **Upon saving** - Validation before committing changes to the database
- **When entering edit mode or creating new elements** - Initial form setup and configuration

### Rule Violations

When rules are violated, the system displays:

- Color-coded messages tied to restriction levels
- Explanatory messages in the user's language
- Immediate feedback without disrupting normal workspace layout

### Important Security Note

**Using rules to display and hide form elements is not a security model.** Rules assist workflow usability rather than protecting sensitive data from unauthorized access. Do not rely on rules for security-sensitive operations.

### Version Compatibility

FirstSpirit 5.2 introduced modified rule syntax, though earlier versions remain compatible during a transition period.

---

## The Rules Tab

### Purpose

The Rules tab within the Template Store enables template developers to define rules that influence form elements and properties dynamically.

### Available Template Types

The Rules tab can be configured in:

- Page templates
- Section templates
- Format templates (style templates only)
- Link templates
- Table templates
- Scripts
- Workflows

### Section Template Limitation

Rules defined in section templates only affect forms directly based on that template. **Section references do not trigger rule violations**, meaning rules have no impact on referenced sections.

### Developer Assistance

The platform provides code completion functionality on the Rules tab, displaying:

- Available tags in the current context
- Valid parameters for each tag
- Possible values for attributes

This assists developers in writing syntactically correct rules.

---

## Rule Structure

FirstSpirit rules consist of five main components, defined within `<RULE>` tags.

### 1. Execution Time

Rules execute by default when forms are edited. The optional `when` attribute restricts execution to specific events:

- **ONSAVE** - Executes during saving operations
- **ONLOCK** - Executes when entering edit mode or creating new items

#### Example

```xml
<RULE>
  <!-- Executes during form editing (default) -->
</RULE>

<RULE when="ONSAVE">
  <!-- Executes only during save operations -->
</RULE>

<RULE when="ONLOCK">
  <!-- Executes when entering edit mode or creating new items -->
</RULE>
```

### 2. Preconditions (Optional)

An `<IF/>` section defines conditions that must be met before the rule executes. These check form properties and are connected using logical tags.

#### Example

```xml
<RULE>
  <IF>
    <PROPERTY source="checkbox_field" name="VALUE"/>
  </IF>
  <!-- Rule only executes if checkbox_field is checked -->
</RULE>
```

### 3. Value Determination

The rule evaluates form or element properties using:

- **Synchronous checks** - Using `<WITH/>` tags for immediate evaluation
- **Asynchronous execution** - Using `<SCHEDULE/>` tags for deferred evaluation

Values are compared against constants or other form properties.

#### Example

```xml
<RULE>
  <WITH>
    <PROPERTY source="text_field" name="EMPTY"/>
  </WITH>
  <!-- Checks if text_field is empty -->
</RULE>
```

### 4. Handling Instructions (Required)

A **required** `<DO/>` section specifies actions when conditions are met, such as:

- Modifying input component properties
- Displaying correction messages
- Changing form element visibility
- Manipulating selection lists

#### Example

```xml
<RULE>
  <WITH>
    <PROPERTY source="text_field" name="EMPTY"/>
  </WITH>
  <DO>
    <PROPERTY source="submit_button" name="VISIBLE" value="false"/>
  </DO>
  <!-- Hides submit button when text_field is empty -->
</RULE>
```

### 5. Validation (Optional)

A `<VALIDATION/>` section executes when value determination returns FALSE, assigning actions to specific input components with three restriction levels:

- **SAVE** - Prevents saving (highest severity)
- **RELEASE** - Prevents releasing
- **INFO** - Default informational level (lowest severity)

#### Example

```xml
<RULE>
  <WITH>
    <NOT>
      <PROPERTY source="email_field" name="EMPTY"/>
    </NOT>
  </WITH>
  <DO>
    <VALIDATION>
      <PROPERTY source="email_field" name="VALID" value="true"/>
    </VALIDATION>
  </DO>
</RULE>
```

### Minimum Requirements

Each rule must contain at least:

1. A value determination section (`<WITH/>` or `<SCHEDULE/>`)
2. A handling instruction section (`<DO/>`)

---

## Validation

### Core Concept

Validation is "a certain handling instruction that is executed as long as conditions defined within the `<WITH/>` section are not fulfilled."

### Key Characteristics

- Validations are **optional** within rules
- Must be assigned to a specific form input component
- Uses an internal `<PROPERTY>` tag with the component name and `VALID` attribute
- Multiple validations can exist in a single `<DO>` section for different components

### Message Display

When a `<MESSAGE>` tag follows the `<PROPERTY>` tag, the corresponding message displays below the input component.

#### Example

```xml
<RULE when="ONSAVE">
  <WITH>
    <NOT>
      <PROPERTY source="title_field" name="EMPTY"/>
    </NOT>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="title_field" name="VALID" value="true"/>
      <MESSAGE lang="*" text="Title is required before saving"/>
      <MESSAGE lang="DE" text="Titel ist erforderlich vor dem Speichern"/>
    </VALIDATION>
  </DO>
</RULE>
```

### Negation with NOT

Boolean results can be negated using the `<NOT/>` tag to invert validation logic.

#### Example

```xml
<WITH>
  <NOT>
    <PROPERTY source="field_name" name="EMPTY"/>
  </NOT>
</WITH>
<!-- TRUE when field_name is NOT empty -->
```

### Practical Validation Scenarios

#### Combined Field Checks

Multiple input fields can be validated together, where at least one must contain data before saving.

```xml
<RULE when="ONSAVE">
  <WITH>
    <OR>
      <NOT>
        <PROPERTY source="phone_field" name="EMPTY"/>
      </NOT>
      <NOT>
        <PROPERTY source="email_field" name="EMPTY"/>
      </NOT>
    </OR>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="phone_field" name="VALID" value="true"/>
      <PROPERTY source="email_field" name="VALID" value="true"/>
      <MESSAGE lang="*" text="Either phone or email is required"/>
    </VALIDATION>
  </DO>
</RULE>
```

#### Multi-Rule Validation

A single component can be validated across separate rules (e.g., character limit in one rule, number restrictions in another). Each rule independently affects validity - if any rule marks it invalid, the component becomes invalid overall.

```xml
<!-- Rule 1: Check minimum length -->
<RULE when="ONSAVE">
  <WITH>
    <PROPERTY source="username" name="LENGTH"/>
    <LESS value="5"/>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="username" name="VALID" value="false"/>
      <MESSAGE lang="*" text="Username must be at least 5 characters"/>
    </VALIDATION>
  </DO>
</RULE>

<!-- Rule 2: Check for special characters -->
<RULE when="ONSAVE">
  <WITH>
    <PROPERTY source="username" name="VALUE"/>
    <MATCHES regex="[^a-zA-Z0-9]"/>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="username" name="VALID" value="false"/>
      <MESSAGE lang="*" text="Username can only contain letters and numbers"/>
    </VALIDATION>
  </DO>
</RULE>
```

### Default Values Behavior

Rules preventing form saves are suspended when applying default or fallback values through the template store, allowing pre-assigned values to be saved without triggering validation errors.

---

## Form Properties

### Overview

The `<PROPERTY/>` tag defines form element properties across rule definitions. It serves two purposes:

1. Determining values or properties (in preconditions and value determination)
2. Performing actions on form elements (in handling instructions)

### Required Attributes

- **source** - Specifies the form element (component name, design component, or system object)
- **name** - Specifies which property to access

### Source Types

#### 1. Input Component

Access specific component properties like stored values:

```xml
<PROPERTY source="gadget" name="VALUE"/>
```

#### 2. Design Component

Access non-value elements like groups or labels using the `#form.` prefix:

```xml
<PROPERTY source="#form.gadget" name="VISIBLE"/>
```

#### 3. General Form Information

Access form-level data using the `#global` source:

```xml
<PROPERTY source="#global" name="LANG"/>
```

### Available Properties by Context

#### For Input Components

**Preconditions/Value Determination:**
- CONTAINERTYPE
- DEFAULT
- EDITABLE
- EMPTY
- ENTRY
- FOCUS
- LABEL
- LENGTH
- QUERY.*
- SECTION
- SIZE
- VALUE
- VISIBLE
- VALID

**Handling Instructions:**
- ADD
- COPY
- DESELECT
- EDIT
- EDITABLE
- EMPTY
- NEW
- REMOVE
- SELECT
- VALUE
- VISIBLE

**Validation:**
- VALID

#### For Design Components

**Preconditions/Value Determination:**
- FOCUS (returns FALSE)
- LABEL
- VISIBLE

**Handling Instructions:**
- VISIBLE

#### For General Form Information (#global)

**Preconditions/Value Determination:**
- BODY
- ELEMENTTYPE
- GID
- ID
- INCLUDED
- LANG
- MASTER
- PRESET
- STORETYPE
- TEMPLATE
- TRANSLATED
- UID
- WEB

### Key Property Functions

| Property | Function | Example |
|----------|----------|---------|
| VALUE | Returns or sets the value of an input component | `<PROPERTY source="field" name="VALUE"/>` |
| VISIBLE | Controls visibility of components | `<PROPERTY source="field" name="VISIBLE" value="false"/>` |
| EMPTY | Checks or sets blank values | `<PROPERTY source="field" name="EMPTY"/>` |
| EDITABLE | Defines editability | `<PROPERTY source="field" name="EDITABLE" value="false"/>` |
| FOCUS | Returns Boolean focus state | `<PROPERTY source="field" name="FOCUS"/>` |
| SELECT | Manipulates selection in lists | `<PROPERTY source="list" name="SELECT"/>` |
| DESELECT | Removes selection in lists | `<PROPERTY source="list" name="DESELECT"/>` |
| LENGTH | Returns character count | `<PROPERTY source="field" name="LENGTH"/>` |
| VALID | Sets validation state | `<PROPERTY source="field" name="VALID" value="true"/>` |

---

## Practical Examples and Best Practices

### Example 1: Conditional Field Visibility

Show additional fields only when a checkbox is selected:

```xml
<RULE>
  <WITH>
    <PROPERTY source="show_details" name="VALUE"/>
  </WITH>
  <DO>
    <PROPERTY source="detail_text" name="VISIBLE" value="true"/>
    <PROPERTY source="detail_date" name="VISIBLE" value="true"/>
  </DO>
</RULE>

<RULE>
  <WITH>
    <NOT>
      <PROPERTY source="show_details" name="VALUE"/>
    </NOT>
  </WITH>
  <DO>
    <PROPERTY source="detail_text" name="VISIBLE" value="false"/>
    <PROPERTY source="detail_date" name="VISIBLE" value="false"/>
  </DO>
</RULE>
```

### Example 2: Dependent Dropdown Lists

Filter product options based on selected category:

```xml
<RULE>
  <WITH>
    <PROPERTY source="category_select" name="VALUE"/>
    <EQUALS value="electronics"/>
  </WITH>
  <DO>
    <PROPERTY source="product_select" name="VISIBLE" value="true"/>
    <!-- Additional logic to filter product list would go here -->
  </DO>
</RULE>
```

### Example 3: Date Range Validation

Ensure end date is after start date:

```xml
<RULE when="ONSAVE">
  <WITH>
    <PROPERTY source="end_date" name="VALUE"/>
    <LESS>
      <PROPERTY source="start_date" name="VALUE"/>
    </LESS>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="end_date" name="VALID" value="false"/>
      <MESSAGE lang="*" text="End date must be after start date"/>
      <MESSAGE lang="DE" text="Enddatum muss nach dem Startdatum liegen"/>
    </VALIDATION>
  </DO>
</RULE>
```

### Example 4: Required Field Groups

Make fields required only when a certain option is selected:

```xml
<RULE when="ONSAVE">
  <WITH>
    <AND>
      <PROPERTY source="contact_type" name="VALUE"/>
      <EQUALS value="email"/>
      <PROPERTY source="email_address" name="EMPTY"/>
    </AND>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="email_address" name="VALID" value="false"/>
      <MESSAGE lang="*" text="Email address is required when contact type is email"/>
    </VALIDATION>
  </DO>
</RULE>
```

### Example 5: Character Length Validation

Enforce minimum and maximum character limits:

```xml
<RULE when="ONSAVE">
  <WITH>
    <OR>
      <AND>
        <PROPERTY source="description" name="LENGTH"/>
        <LESS value="10"/>
      </AND>
      <AND>
        <PROPERTY source="description" name="LENGTH"/>
        <GREATER value="500"/>
      </AND>
    </OR>
  </WITH>
  <DO>
    <VALIDATION severity="SAVE">
      <PROPERTY source="description" name="VALID" value="false"/>
      <MESSAGE lang="*" text="Description must be between 10 and 500 characters"/>
    </VALIDATION>
  </DO>
</RULE>
```

### Example 6: Making Fields Read-Only Based on Conditions

Lock fields after a certain workflow stage:

```xml
<RULE>
  <WITH>
    <PROPERTY source="#global" name="PRESET"/>
    <EQUALS value="published"/>
  </WITH>
  <DO>
    <PROPERTY source="title_field" name="EDITABLE" value="false"/>
    <PROPERTY source="url_field" name="EDITABLE" value="false"/>
  </DO>
</RULE>
```

---

## Best Practices

### 1. Use Descriptive Component Names

Name your form components clearly so rules are easier to understand and maintain:

```xml
<!-- Good -->
<PROPERTY source="user_email" name="EMPTY"/>

<!-- Avoid -->
<PROPERTY source="field1" name="EMPTY"/>
```

### 2. Provide Multi-Language Messages

Always include messages in all supported languages:

```xml
<MESSAGE lang="*" text="Default English message"/>
<MESSAGE lang="DE" text="German message"/>
<MESSAGE lang="FR" text="French message"/>
```

### 3. Use Appropriate Validation Severity

Choose the right severity level for your validation:

- **SAVE** - Use for critical validations that must pass before saving
- **RELEASE** - Use for validations that should pass before releasing to production
- **INFO** - Use for helpful suggestions that don't block saving

### 4. Combine Rules Logically

Break complex logic into multiple rules for better maintainability:

```xml
<!-- Instead of one complex rule, use multiple simpler rules -->
<RULE>
  <!-- Rule for visibility -->
</RULE>

<RULE>
  <!-- Rule for validation -->
</RULE>

<RULE>
  <!-- Rule for editability -->
</RULE>
```

### 5. Test Rules Thoroughly

Test rules in different scenarios:

- Creating new content
- Editing existing content
- Saving content
- Releasing content
- Different language contexts
- Different user permissions

### 6. Consider Performance

- Avoid overly complex rules that might slow down form interactions
- Use `when="ONSAVE"` or `when="ONLOCK"` to limit execution frequency when appropriate
- Be cautious with asynchronous `<SCHEDULE/>` operations

### 7. Document Complex Rules

Add comments to complex rule logic:

```xml
<!-- This rule ensures that when the user selects "custom" option,
     the custom text field becomes visible and required -->
<RULE>
  ...
</RULE>
```

### 8. Remember Security Limitations

Do not rely on rules for security:

- Rules only control UI behavior
- They do not prevent direct API access
- Use proper permissions and backend validation for security

### 9. Handle Edge Cases

Consider what happens when:

- Fields are empty
- Users switch languages
- Content is in different workflow states
- Multiple users edit simultaneously

### 10. Use Logical Operators Effectively

Combine conditions using `<AND>`, `<OR>`, and `<NOT>` for precise control:

```xml
<WITH>
  <AND>
    <OR>
      <PROPERTY source="field1" name="EMPTY"/>
      <PROPERTY source="field2" name="EMPTY"/>
    </OR>
    <NOT>
      <PROPERTY source="field3" name="EMPTY"/>
    </NOT>
  </AND>
</WITH>
```

---

## Summary

FirstSpirit rules provide powerful capabilities for creating dynamic, user-friendly forms that adapt to content and user interactions. By understanding rule structure, validation mechanisms, and form properties, developers can create sophisticated form behaviors that guide editors and ensure content quality. Remember that rules enhance usability but should not be relied upon for security, and always test rules thoroughly across different scenarios and languages.