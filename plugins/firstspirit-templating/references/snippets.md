# FirstSpirit Snippets and Preview Content

## Overview

Snippets are configurable display components in FirstSpirit that define how objects appear in various interfaces throughout the system. They provide a standardized way to present pages, sections, datasets, and media content across search results, reports, and selection dialogs with rich contextual information.

### Purpose

The primary purpose of snippets is to define content that represents FirstSpirit objects as accurately as possible, acting as a form of "teaser" or preview. This enables editors to quickly identify and distinguish between different content items without needing to open each one individually.

### Benefits

- **Improved Editor Experience**: Editors can quickly scan and identify relevant content in search results and selection dialogs
- **Contextual Information**: Provides meaningful previews rather than just technical names or IDs
- **Consistency**: Standardizes how content appears across different FirstSpirit interfaces
- **Efficiency**: Reduces time spent searching for and identifying content items

## Snippet Components

Every snippet consists of three main elements that work together to create a comprehensive preview:

### 1. Thumbnail

A representative image for the object that provides visual identification.

**Characteristics:**
- Displays in the thumbnail area
- Can be pulled from input components (images, media elements)
- Provides quick visual recognition of content

### 2. Label

Representative text serving as the title or main identifier.

**Characteristics:**
- Acts as the primary text identifier
- Typically displays the page or object name
- Should be concise and descriptive
- Falls back to object name if not defined

### 3. Extract

A text summary or teaser content providing additional context.

**Characteristics:**
- Provides a brief description or excerpt of the content
- Often pulled from introductory text or summary fields
- Should give editors enough information to identify content purpose
- Falls back to search result path if not defined

## Where Snippets Appear

Snippets are displayed in multiple locations throughout FirstSpirit:

### SiteArchitect
- Search result lists
- Reports
- Selection dialogs

### ContentCreator
- Search results
- FragmentCreator navigation
- Content selection interfaces

## Defining Snippets in Templates

### The Snippet Tab

Page templates include a dedicated Snippet tab where snippet definitions are configured. This tab is represented by a snippet icon in the compact view.

**Configuration Location:**
- Navigate to the page template
- Select the Snippet tab
- Configure the three areas: Thumbnail, Label, and Extract

### Using Form Variables

Snippets leverage variables from the Form tab's input components. You can reference any input component defined in your template using its identifier.

**Key Principle:**
Multiple input components can be combined to better adjust the output to project-specific requirements.

### Syntax and Access Patterns

Snippet definitions use variable names combined with callable methods:

#### Basic Variable Access
```
#form.IDENTIFIER
```

#### Language-Specific Access
```
#form.IDENTIFIER.LANGABBREVIATION
```

#### Metadata Access
```
#meta.IDENTIFIER
```

#### Method Calls
Variables support methods compatible with `[$CMS_VALUE(...)$]` syntax:
```
#form.IDENTIFIER.method()
```

## Implementation Examples

### Example 1: Simple Page Template Snippet

**Label Configuration:**
```
#form.pt_title
```

**Extract Configuration:**
```
#form.pt_intro
```

This creates a snippet where:
- Label shows the page title from the `pt_title` input component
- Extract shows the introduction text from the `pt_intro` input component

### Example 2: Link Template with Referenced Page

**Label Configuration:**
```
lt_reference.get.displayName(#language)
```

**Extract Configuration:**
```
truncate(lt_reference.pageRef.page.formData.pt_intro, 65)
```

This creates a snippet where:
- Label displays the referenced page's name in the current language
- Extract shows a truncated version (65 characters) of the referenced page's introduction

### Example 3: Media Object Snippet

**Thumbnail Configuration:**
```
#form.pt_image
```

**Label Configuration:**
```
#form.pt_image.meta.description
```

**Extract Configuration:**
```
#form.pt_caption
```

This creates a snippet where:
- Thumbnail displays the actual image
- Label uses the image's metadata description
- Extract shows the caption field

## Advanced Techniques

### Empty Checks

Always implement empty checks to prevent generation errors when fields aren't populated:

```
#if (!form.pt_intro.isEmpty())
  #form.pt_intro
#else
  Default text or empty string
#end
```

### Type Checks

When snippets need to handle multiple object types (pages, references, files, images):

```
#if (#form.pt_reference.isPage())
  #form.pt_reference.page.formData.pt_title
#elseif (#form.pt_reference.isFile())
  #form.pt_reference.file.meta.description
#end
```

### Multilingual Support

For multilingual projects, access language-specific content:

```
#form.pt_title.#language
```

Or explicitly specify the language:

```
#form.pt_title.de
```

### Text Truncation

Limit extract length for consistent display:

```
truncate(#form.pt_intro, 100)
```

This ensures extracts don't exceed 100 characters.

### XML-Conforming Escape

Apply XML escaping to logic results for label and extract to ensure valid output:

```
escape(#form.pt_title)
```

This is particularly important when content may contain special characters or HTML.

## Default Behavior

### When Snippets Are Not Defined

If no snippet configuration exists for a template:
- **Label**: Displays the object name
- **Extract**: Shows the search result path

### When Fields Are Empty

If editors leave snippet-referenced fields empty:
- **Label**: Falls back to object name
- **Extract**: Falls back to search result path

### Path Display in ContentCreator

The search result path appears independently in ContentCreator regardless of snippet configuration. This provides consistent navigation context.

## Best Practices

### Content Design

1. **Be Descriptive**: Define content that clearly distinguishes between different object types and content items
2. **User-Focused**: Prioritize user-friendly display over technical hierarchy information
3. **Consistent Structure**: Maintain consistent snippet patterns across similar template types
4. **Meaningful Previews**: Ensure extracts provide enough context for editors to understand content purpose

### Technical Implementation

1. **Implement Validation**: Always include empty checks and type validation
2. **Use Fallbacks**: Provide sensible defaults when referenced fields are empty
3. **Limit Extract Length**: Truncate extracts to maintain consistent display
4. **Apply Escaping**: Use XML-conforming escapes for label and extract content
5. **Test Multiple Scenarios**: Verify snippets work with various content states (empty fields, different types, etc.)

### Performance Considerations

1. **Avoid Complex Logic**: Keep snippet definitions simple to ensure fast rendering
2. **Minimize Method Chaining**: Excessive method calls can impact performance
3. **Use Cached Values**: Leverage metadata and pre-processed values when available

### Content Guidelines

1. **Title/Label**: Should be concise (typically under 100 characters)
2. **Extract**: Recommended length 50-150 characters for optimal display
3. **Thumbnail**: Use appropriate image sizes (thumbnails, not full-resolution images)

### Multilingual Projects

1. **Language Consistency**: Ensure all snippet elements use the same language context
2. **Fallback Languages**: Implement fallback logic for untranslated content
3. **Language-Specific Formatting**: Consider cultural differences in text display

## Common Use Cases

### Teasers and Summaries

Snippets excel at creating teaser content for:
- News articles (headline + intro)
- Product pages (name + description)
- Event listings (title + date/location)
- Blog posts (title + excerpt)

### Selection Dialogs

When editors select pages or content through dialogs:
- Provide clear identification of content type
- Show enough context to make informed selections
- Use thumbnails to aid visual recognition

### Search Results

Optimize search result display:
- Prioritize relevant information in labels
- Include keywords in extracts
- Use thumbnails to differentiate content types

### Reports and Listings

For administrative and editorial reports:
- Display status or workflow information
- Show modification dates or authors
- Include content classification or categories

## Troubleshooting

### Common Issues

**Issue**: Snippet shows empty content
- **Solution**: Verify input component identifiers are correct
- **Solution**: Implement empty checks with fallback values
- **Solution**: Check that referenced form fields exist

**Issue**: Snippet displays technical paths instead of content
- **Solution**: Ensure snippet tab is properly configured
- **Solution**: Verify variable syntax is correct
- **Solution**: Check that form data is accessible

**Issue**: Snippet breaks with certain content types
- **Solution**: Implement type checking for different object types
- **Solution**: Add null/empty validation
- **Solution**: Use conditional logic for different scenarios

**Issue**: Extract content is too long or improperly formatted
- **Solution**: Apply truncation to limit length
- **Solution**: Use XML escaping for special characters
- **Solution**: Strip HTML tags if necessary

## Integration with Template Development

### Relationship to Form Tab

Snippets depend on input components defined in the Form tab:
- Reference form identifiers directly
- Access nested properties through dot notation
- Combine multiple form fields for comprehensive previews

### Relationship to Rules

Snippet visibility can be controlled through template rules:
- Show/hide based on workflow states
- Vary content based on user permissions
- Adjust based on content type or classification

### Relationship to Sections and Content Areas

For section templates and content areas:
- Define snippets that represent the section's purpose
- Include information about contained content types
- Show relevant section-specific metadata

## Summary

Snippets are a powerful feature in FirstSpirit that significantly improve the editor experience by providing rich, contextual previews of content throughout the system. By thoughtfully designing snippet definitions that leverage form data, implement proper validation, and follow best practices, developers can create intuitive interfaces that help editors work more efficiently and effectively.

Key takeaways:
- Snippets consist of thumbnail, label, and extract components
- They're configured in the Snippet tab using form variables and methods
- Proper implementation includes validation, fallbacks, and escaping
- Well-designed snippets improve search, selection, and navigation experiences
- Default behavior ensures content is always identifiable even without configuration