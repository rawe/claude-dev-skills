# Template Syntax - Expressions and Data Types

## Overview

In FirstSpirit, a data type is defined as "the summary of a specific object set (e.g. character strings) and the methods allowed on this set." The template syntax supports both general-purpose data types and specialized types for specific FirstSpirit functionality.

## General Data Types

FirstSpirit provides seven fundamental data types that form the basis of template development:

### 1. Boolean

**Available since:** FirstSpirit 4.0

The Boolean data type represents one of two possible values: `true` or `false`. These values are commonly used as return types for input components and in conditional expressions.

#### Definition and Usage

```ftml
$CMS_SET(isValid, true)$
$CMS_SET(isEnabled, false)$
```

#### Conditional Checks

```ftml
$CMS_IF(varName == true)$
  Content when true
$CMS_END_IF$

$CMS_IF(isEnabled)$
  Enabled content
$CMS_END_IF$
```

#### Input Component

The `CMS_INPUT_TOGGLE` standard input component returns Boolean data types for use in forms.

#### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `booleanValue()` | boolean | Extract primitive boolean value |
| `equals(Object)` | boolean | Compare equality with another object |
| `isNull()` | boolean | Checks whether an expression or object is null |
| `logicalAnd(boolean, boolean)` | boolean | Performs logical AND operation |
| `logicalOr(boolean, boolean)` | boolean | Performs logical OR operation |
| `logicalXor(boolean, boolean)` | boolean | Performs logical XOR operation |
| `parseBoolean(String)` | boolean | Convert string to boolean value |
| `toJSON()` | String | Convert to JSON-compatible representation (v5.2.11+) |
| `toString()` | String | Convert to string representation |

#### Examples

```ftml
$-- Define boolean variables --$
$CMS_SET(isActive, true)$
$CMS_SET(hasPermission, false)$

$-- Using booleanValue() --$
$CMS_VALUE(isActive.booleanValue())$

$-- Logical operations --$
$CMS_SET(result, isActive.logicalAnd(hasPermission))$
$CMS_VALUE(result)$ $-- Returns false --$

$-- String conversion --$
$CMS_VALUE(isActive.toString())$ $-- Returns "true" --$

$-- Parsing from string --$
$CMS_SET(parsed, parseBoolean("true"))$
```

### 2. String

The String data type represents text sequences of variable length. Strings are fundamental for text manipulation in templates.

#### Definition

```ftml
$CMS_SET(text, "Hello World")$
$CMS_SET(name, "FirstSpirit")$
```

### 3. Number

The Number data type handles numeric values for mathematical operations and calculations.

#### Definition

```ftml
$CMS_SET(count, 42)$
$CMS_SET(price, 19.99)$
```

### 4. Date

The Date data type handles date and time values for temporal operations.

#### Definition

```ftml
$CMS_SET(currentDate, now())$
```

### 5. List

**Available since:** FirstSpirit 4.0

The List data type is "an ordered, indexed set of list elements." Unlike Sets, elements can occur more than once within a list.

#### Creation Syntax

```ftml
$-- Empty list --$
$CMS_SET(empty_list, [])$

$-- Filled list --$
$CMS_SET(list, [1, 2, 3])$
$CMS_SET(names, ["Alice", "Bob", "Charlie"])$

$-- Range syntax --$
$CMS_SET(range, [1..10])$
$CMS_SET(letters, ["a".."z"])$
```

#### Element Access

Lists use zero-based indexing:

```ftml
$-- Access by index --$
$CMS_VALUE(list[0])$ $-- First element --$
$CMS_VALUE(list[2])$ $-- Third element --$
$CMS_VALUE(list.get(2))$ $-- Equivalent method syntax --$

$-- Access with variables --$
$CMS_SET(i, 1)$
$CMS_VALUE(list[i])$
$CMS_VALUE(list.get(i))$

$-- Set element values --$
$CMS_SET(list[0], "new value")$
```

#### Sorting and Ordering

```ftml
$-- Sort in ascending order --$
$CMS_VALUE(list.sort)$

$-- Reverse order --$
$CMS_VALUE(list.reverse)$

$-- Sort in descending order --$
$CMS_VALUE(list.sort.reverse)$
```

#### Filtering and Transformation

**Filter with Lambda:**
```ftml
$-- Filter elements matching condition --$
$CMS_SET(filtered, list.filter(item -> item > 5))$
```

**Map (Transform) with Lambda:**
```ftml
$-- Transform each element --$
$CMS_SET(doubled, list.map(item -> item * 2))$
```

**Distinct (Remove Duplicates):**
```ftml
$CMS_SET(duplicates, [1, 2, 2, 3, 3, 3])$
$CMS_SET(unique, duplicates.distinct())$
```

**Fold (Summarize):**
```ftml
$-- Aggregate values --$
$CMS_SET(sum, list.fold((acc, item) -> acc + item, 0))$
```

#### Utility Methods

| Property/Method | Return Type | Description |
|-----------------|-------------|-------------|
| `size` | Number | Returns the number of elements in the list |
| `isEmpty` | Boolean | Checks if the list is empty |
| `isNull` | Boolean | Checks if the list is null |
| `first` | Object | Returns the first element |
| `last` | Object | Returns the last element |
| `min` | Object | Returns the minimum value |
| `max` | Object | Returns the maximum value |
| `toString(String)` | String | Joins elements with the specified delimiter |

#### Collection Methods

Lists support Java Collection interface operations:

- `add(Object)` - Add element to the list
- `remove(Object)` - Remove element from the list
- `contains(Object)` - Check if list contains element
- `toArray()` - Convert to array
- Iterator operations compatible with `java.util.List`

#### Examples

```ftml
$-- Create and manipulate list --$
$CMS_SET(numbers, [5, 2, 8, 1, 9])$

$-- Get size --$
$CMS_VALUE(numbers.size)$ $-- Returns 5 --$

$-- Check if empty --$
$CMS_IF(!numbers.isEmpty)$
  List has elements
$CMS_END_IF$

$-- Access first and last --$
$CMS_VALUE(numbers.first)$ $-- Returns 5 --$
$CMS_VALUE(numbers.last)$ $-- Returns 9 --$

$-- Find min and max --$
$CMS_VALUE(numbers.min)$ $-- Returns 1 --$
$CMS_VALUE(numbers.max)$ $-- Returns 9 --$

$-- Sort and display --$
$CMS_VALUE(numbers.sort)$ $-- Returns [1, 2, 5, 8, 9] --$

$-- Join with delimiter --$
$CMS_VALUE(numbers.toString(", "))$ $-- Returns "5, 2, 8, 1, 9" --$

$-- Iterate through list --$
$CMS_FOR(num, numbers)$
  $CMS_VALUE(num)$
$CMS_END_FOR$

$-- Filter even numbers --$
$CMS_SET(evens, numbers.filter(n -> n % 2 == 0))$
$CMS_VALUE(evens)$ $-- Returns [2, 8] --$

$-- Double all numbers --$
$CMS_SET(doubled, numbers.map(n -> n * 2))$
$CMS_VALUE(doubled)$ $-- Returns [10, 4, 16, 2, 18] --$
```

### 6. Map

**Available since:** FirstSpirit 4.0

Maps are key-value pair collections that allow efficient data lookup by unique keys.

#### Creation Syntax

```ftml
$-- Empty map --$
$CMS_SET(empty_map, {:})$

$-- Map with key-value pairs --$
$CMS_SET(map, {"name":"Mustermann", "firstname":"Heinz"})$

$-- Multiple pairs, comma-separated --$
$CMS_SET(user, {
  "name": "Doe",
  "firstname": "John",
  "age": 30,
  "active": true
})$
```

#### Accessing Values

Values are retrieved through their assigned keys using three equivalent approaches:

```ftml
$-- Method syntax --$
$CMS_VALUE(map.get("name"))$

$-- Property syntax --$
$CMS_VALUE(map.name)$

$-- Bracket syntax --$
$CMS_VALUE(map["name"])$
```

All three approaches return the same value for the given key.

#### Adding and Modifying Entries

```ftml
$-- Using bracket syntax --$
$CMS_SET(map["key"], "value")$

$-- Using put method --$
$CMS_SET(void, map.put("email", "john@example.com"))$

$-- Update existing key --$
$CMS_SET(map["name"], "Smith")$
```

#### Iteration

Loop through all key-value pairs:

```ftml
$CMS_FOR(mapWrapper, map)$
  $CMS_VALUE(mapWrapper)$
$CMS_END_FOR$
```

#### Essential Methods

| Property/Method | Return Type | Description |
|-----------------|-------------|-------------|
| `size` | Number | Returns number of key-value pairs |
| `containsKey(Object)` | Boolean | Checks if key exists in map |
| `isEmpty()` | Boolean | Verifies if map is empty |
| `keySet()` | Set | Returns all keys as a Set |
| `values()` | Collection | Returns all values as a Collection |
| `toJSON()` | String | Converts to JSON string (v5.2.11+) |

#### Examples

```ftml
$-- Create map --$
$CMS_SET(person, {
  "name": "Mueller",
  "firstname": "Anna",
  "age": 28,
  "department": "Engineering"
})$

$-- Get size --$
$CMS_VALUE(person.size)$ $-- Returns 4 --$

$-- Check if key exists --$
$CMS_IF(person.containsKey("age"))$
  Age is defined
$CMS_END_IF$

$-- Check if empty --$
$CMS_IF(!person.isEmpty())$
  Person data available
$CMS_END_IF$

$-- Get all keys --$
$CMS_SET(keys, person.keySet())$
$CMS_FOR(key, keys)$
  $CMS_VALUE(key)$
$CMS_END_FOR$

$-- Get all values --$
$CMS_SET(vals, person.values())$
$CMS_FOR(val, vals)$
  $CMS_VALUE(val)$
$CMS_END_FOR$

$-- Convert to JSON --$
$CMS_VALUE(person.toJSON())$

$-- Iterate through map --$
$CMS_FOR(entry, person)$
  Key: $CMS_VALUE(entry.key)$, Value: $CMS_VALUE(entry.value)$
$CMS_END_FOR$

$-- Add new entry --$
$CMS_SET(void, person.put("email", "anna.mueller@example.com"))$

$-- Update existing entry --$
$CMS_SET(person["age"], 29)$
```

### 7. Set

The Set data type is an ordered collection of unique elements. Unlike Lists, Sets do not allow duplicate values.

#### Definition

```ftml
$CMS_SET(uniqueItems, set())$
```

## Special Data Types

FirstSpirit includes 16 specialized types for specific use cases within the CMS:

### DomElement

A document tree which contains structured data. DomElement represents hierarchical XML-like structures within FirstSpirit.

### Link

Suitable for editing and processing values which represent a link within or outside the project. Used for managing internal and external references.

### TargetReference

Returns a reference to any FirstSpirit object. Enables dynamic referencing of content elements, pages, and other project components.

### Other Special Types

Additional specialized types include:

- **Area** - Sections of content areas
- **Card** - Card-based content elements
- **Catalog** - Catalog data structures
- **CatalogAccessor** - Access to catalog data
- **DatasetContainer** - Container for datasets
- **Entity** - Database entities
- **FormData** - Form input data
- **GregorianCalendar** - Calendar operations
- **Index** - Index structures
- **IndexAccessor** - Access to index data
- **MappingMedium** - Media mapping
- **Option** - Option values
- **Record** - Data records
- **Section** - Content sections
- **SectionListEntry** - Section list items
- **Table** - Tabular data

## Expression Syntax

### Variable Assignment

Variables are assigned using the `CMS_SET` instruction:

```ftml
$CMS_SET(variableName, value)$
```

### Value Output

Output variable values using the `CMS_VALUE` instruction:

```ftml
$CMS_VALUE(variableName)$
```

### Type Operations

#### Method Invocation

Methods are invoked using dot notation:

```ftml
$CMS_VALUE(list.size)$
$CMS_VALUE(map.isEmpty())$
$CMS_VALUE(string.toUpperCase())$
```

#### Chaining

Operations can be chained:

```ftml
$CMS_VALUE(list.sort.reverse)$
$CMS_VALUE(string.trim().toLowerCase())$
```

### Type Conversions

#### Boolean Conversions

```ftml
$-- Parse string to boolean --$
$CMS_SET(bool, parseBoolean("true"))$

$-- Convert to string --$
$CMS_VALUE(boolValue.toString())$

$-- Convert to JSON --$
$CMS_VALUE(boolValue.toJSON())$
```

#### List Conversions

```ftml
$-- Convert to array --$
$CMS_SET(array, list.toArray())$

$-- Convert to string with delimiter --$
$CMS_VALUE(list.toString(", "))$
```

#### Map Conversions

```ftml
$-- Convert to JSON --$
$CMS_VALUE(map.toJSON())$

$-- Extract keys as Set --$
$CMS_SET(keys, map.keySet())$

$-- Extract values as Collection --$
$CMS_SET(values, map.values())$
```

## Lambda Expressions

Lambda expressions enable functional programming patterns in FirstSpirit templates.

### Syntax

```ftml
item -> expression
(param1, param2) -> expression
```

### Usage with Lists

**Filter:**
```ftml
$CMS_SET(adults, people.filter(person -> person.age >= 18))$
```

**Map (Transform):**
```ftml
$CMS_SET(names, people.map(person -> person.name))$
```

**Distinct:**
```ftml
$CMS_SET(uniqueAges, people.distinct(person -> person.age))$
```

**Fold (Reduce):**
```ftml
$CMS_SET(totalAge, people.fold((sum, person) -> sum + person.age, 0))$
```

## Null Handling

All data types provide the `isNull()` method for null checking:

```ftml
$CMS_IF(variable.isNull())$
  Variable is null
$CMS_ELSE$
  Variable has a value
$CMS_END_IF$
```

## Practical Examples

### Example 1: Processing User Data

```ftml
$-- Create list of users --$
$CMS_SET(users, [
  {"name": "Alice", "age": 25, "active": true},
  {"name": "Bob", "age": 30, "active": false},
  {"name": "Charlie", "age": 35, "active": true}
])$

$-- Filter active users --$
$CMS_SET(activeUsers, users.filter(user -> user.active))$

$-- Get user names --$
$CMS_SET(activeNames, activeUsers.map(user -> user.name))$

$-- Display results --$
<h2>Active Users</h2>
<ul>
$CMS_FOR(name, activeNames)$
  <li>$CMS_VALUE(name)$</li>
$CMS_END_FOR$
</ul>

$-- Count active users --$
<p>Total active: $CMS_VALUE(activeUsers.size)$</p>
```

### Example 2: Configuration Management

```ftml
$-- Define configuration --$
$CMS_SET(config, {
  "siteName": "My Website",
  "version": "2.0",
  "features": ["search", "comments", "analytics"],
  "maintenance": false
})$

$-- Check maintenance mode --$
$CMS_IF(!config.maintenance)$
  <div class="site-header">
    <h1>$CMS_VALUE(config.siteName)$</h1>
    <span class="version">v$CMS_VALUE(config.version)$</span>
  </div>

  $-- Display enabled features --$
  <ul class="features">
  $CMS_FOR(feature, config.features)$
    <li>$CMS_VALUE(feature)$</li>
  $CMS_END_FOR$
  </ul>
$CMS_ELSE$
  <p>Site is under maintenance</p>
$CMS_END_IF$
```

### Example 3: Data Aggregation

```ftml
$-- Product inventory --$
$CMS_SET(products, [
  {"name": "Laptop", "price": 999, "inStock": true},
  {"name": "Mouse", "price": 25, "inStock": true},
  {"name": "Keyboard", "price": 75, "inStock": false},
  {"name": "Monitor", "price": 350, "inStock": true}
])$

$-- Get available products --$
$CMS_SET(available, products.filter(p -> p.inStock))$

$-- Calculate total inventory value --$
$CMS_SET(totalValue, available.fold((sum, p) -> sum + p.price, 0))$

$-- Find price range --$
$CMS_SET(prices, available.map(p -> p.price))$
$CMS_SET(minPrice, prices.min)$
$CMS_SET(maxPrice, prices.max)$

$-- Display summary --$
<div class="inventory-summary">
  <p>Available products: $CMS_VALUE(available.size)$</p>
  <p>Total value: $$$CMS_VALUE(totalValue)$</p>
  <p>Price range: $$$CMS_VALUE(minPrice)$ - $$$CMS_VALUE(maxPrice)$</p>
</div>
```

### Example 4: Date and Number Operations

```ftml
$-- Number operations --$
$CMS_SET(numbers, [10, 20, 30, 40, 50])$
$CMS_SET(sum, numbers.fold((acc, n) -> acc + n, 0))$
$CMS_SET(average, sum / numbers.size)$

<p>Sum: $CMS_VALUE(sum)$</p>
<p>Average: $CMS_VALUE(average)$</p>

$-- Boolean logic --$
$CMS_SET(hasHighValue, numbers.max > 40)$
$CMS_SET(allPositive, true)$
$CMS_FOR(num, numbers)$
  $CMS_IF(num <= 0)$
    $CMS_SET(allPositive, false)$
  $CMS_END_IF$
$CMS_END_FOR$

$CMS_IF(hasHighValue.logicalAnd(allPositive))$
  <p>All numbers are positive with high values present</p>
$CMS_END_IF$
```

### Example 5: Map Transformation

```ftml
$-- Create user profile --$
$CMS_SET(profile, {
  "username": "jdoe",
  "email": "john.doe@example.com",
  "role": "editor",
  "permissions": ["read", "write", "publish"]
})$

$-- Add computed properties --$
$CMS_SET(void, profile.put("displayName", profile.username.toUpperCase()))$
$CMS_SET(void, profile.put("permissionCount", profile.permissions.size))$

$-- Check permissions --$
$CMS_IF(profile.permissions.contains("publish"))$
  <button class="publish-btn">Publish Content</button>
$CMS_END_IF$

$-- Display profile --$
<div class="user-profile">
  <h3>$CMS_VALUE(profile.displayName)$</h3>
  <p>Email: $CMS_VALUE(profile.email)$</p>
  <p>Role: $CMS_VALUE(profile.role)$</p>
  <p>Permissions ($CMS_VALUE(profile.permissionCount)$):</p>
  <ul>
  $CMS_FOR(perm, profile.permissions)$
    <li>$CMS_VALUE(perm)$</li>
  $CMS_END_FOR$
  </ul>
</div>
```

## Best Practices

1. **Use appropriate data types**: Choose the right data type for your use case (List for ordered collections, Set for unique items, Map for key-value pairs)

2. **Leverage lambda expressions**: Use filter, map, and fold for cleaner, more functional code

3. **Check for null values**: Always validate data using `isNull()` before accessing properties or methods

4. **Chain operations**: Combine operations like `sort.reverse` for concise transformations

5. **Use descriptive variable names**: Make templates more maintainable with clear naming conventions

6. **Optimize iterations**: Use methods like `isEmpty()` to avoid unnecessary loops

7. **Type conversion**: Use appropriate conversion methods (`toJSON()`, `toString()`, etc.) for data serialization

## Version Compatibility

- **Boolean, List, Map, Set**: Available since FirstSpirit 4.0
- **toJSON() method**: Available since FirstSpirit 5.2.11

Always check the FirstSpirit version compatibility for specific features when developing templates.