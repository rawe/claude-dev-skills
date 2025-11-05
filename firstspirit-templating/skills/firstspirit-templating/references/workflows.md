# FirstSpirit Workflows Reference

## Overview

Workflows in FirstSpirit represent "a sequence of tasks that is completed according to a fixed, predefined structure" with configurable due dates and authorized user groups. They enable structured approval and release processes for project elements, ensuring controlled content publication and deletion.

## Workflow Types

FirstSpirit supports two primary workflow categories:

### Context-Oriented Workflows
- Linked to specific objects within the project
- Triggered by actions on particular elements
- Example: Release request workflow for pages or media

### Context-Free Workflows
- Independent of specific objects
- Started manually from the menu bar
- Example: Task workflow for general assignments

## Workflow Structure

### Configuration Tabs

The workflow editor provides five primary configuration interfaces:

#### 1. Properties Tab
Establishes valid settings for the workflow, including:
- Workflow name and description
- Due date configurations
- Authorized user groups
- General behavior settings

#### 2. State Diagram Tab
Enables graphical modeling of workflow states and transitions with specific rules:
- Visual representation of workflow steps
- State connections and flow logic
- Conditional transitions between states

#### 3. Form Tab
Defines input components for workflow entries:
- Custom input fields for workflow initiation
- Data collection forms
- User interaction elements

#### 4. Rules Tab
Controls elements and properties through rule definitions:
- Conditional logic for workflow behavior
- Element visibility and editability rules
- Dynamic workflow adjustments

#### 5. Snippet Tab
Customizes workflow display in overview lists:
- Preview information shown in workflow listings
- Summary data presentation
- Custom display templates

## Permissions and Security

FirstSpirit offers flexible permission management for workflows:

- **Granular Access Control**: "FirstSpirit offers a flexible feature for defining very precisely which user is permitted to perform a particular workflow step"
- **Role-Based Permissions**: Assign workflow steps to specific user groups
- **Step-Level Authorization**: Control who can execute each workflow transition

## Error Handling

### Error States
- Optional error states prevent inconsistent workflow instances
- Provide fallback paths for unexpected situations
- Enable recovery mechanisms for failed operations

### Write Protection
- Restricts editing of protected workflow objects
- Ensures data integrity during workflow execution
- Prevents concurrent modifications

## Script Support

Workflows support scripting for complex functionality:
- Custom logic implementation
- Integration with external systems
- Automated decision-making
- Data validation and transformation

## API Access

Workflows are accessible through dedicated Java packages:

```java
de.espirit.firstspirit.workflow.model
de.espirit.firstspirit.access.store.templatestore
de.espirit.firstspirit.workflow
```

These packages provide programmatic access to:
- Workflow creation and management
- State transitions
- Custom workflow logic
- Integration with FirstSpirit APIs

## BasicWorkflows Module

### Purpose

The BasicWorkflows module is a FirstSpirit standard module providing ready-to-use release and deletion workflows. It combines "common release and delete logics in workflows for releasing or deleting FirstSpirit elements" to prevent re-implementation across projects.

### Technical Requirements

- **FirstSpirit Version**: 2022.3 or later (Isolated or Legacy-Mode)
- **Java Version**: Java 17
- **License**: Valid FirstSpirit license with `license.WORKFLOW` parameter set to `1`

### Core Workflow Types

#### Release Workflow

Manages element publication with dependency tracking across multiple areas:

**SiteArchitect Support:**
- Media elements
- Entities
- Data sources
- Pages
- Page references
- Document groups
- Folders
- Global pages
- Project settings

**ContentCreator Support:**
- Page references
- Entities
- Document groups

**Features:**
- Automatic dependency resolution
- Conflict detection for unreleased dependencies
- Multi-element release coordination
- Approval process integration

#### Delete Workflow

Handles element removal with conflict prevention:

**SiteArchitect Support:**
- Media elements
- Entities
- Data sources
- Pages
- Page references
- Document groups
- Folders
- Global pages
- Project settings

**ContentCreator Support:**
- Page references
- Entities
- Media
- Folders
- Document groups

**Features:**
- Reference validation before deletion
- Conflict detection for elements in use
- Safe removal with dependency checks
- Approval process for deletions

### Installation and Configuration

#### Module Installation

1. Open ServerManager
2. Navigate to Server properties
3. Go to Modules section
4. Install BasicWorkflows module

#### Workflow Activation

1. **Enable in Project Settings**: Activate workflows for ContentCreator in project configuration
2. **Web Component Setup**: Enable web component and web server for ContentCreator workflows
3. **Import Workflows**: Import BasicWorkflows into the project
4. **Define Permissions**: Configure user permissions for workflow steps
5. **Select Delete Workflow**: Designate the appropriate delete workflow for the project

### Conflict Resolution

The BasicWorkflows module includes comprehensive conflict management:

#### Conflict Detection
- Identifies unreleased dependencies
- Detects incorrect object states
- Validates element relationships
- Checks for circular dependencies

#### Cancelation Mechanism
- Triggers workflow abandonment when conflicts cannot be resolved
- Preserves project state integrity
- Provides feedback on cancellation reasons

#### Forced Actions
- Overrides standard workflow rules when necessary
- Requires elevated permissions
- Logs forced action events
- Used for emergency situations

### Extension Capabilities

BasicWorkflows can be extended for custom requirements:

#### Supported Extensions
- **MultiNode Ability**: Support for distributed FirstSpirit environments
- **Section References**: Custom handling of section-based content
- **Custom Business Logic**: Integration of project-specific rules

#### Extension Implementation
The module provides interfaces for:
- Custom workflow steps
- Specialized approval processes
- Integration with external systems
- Enhanced validation logic

### Best Practices

#### Release Workflows
1. Always review dependencies before releasing
2. Use approval steps for critical content
3. Configure appropriate user groups for each step
4. Test workflows in development environment first
5. Monitor workflow execution logs

#### Delete Workflows
1. Verify no active references before deletion
2. Implement multi-level approval for critical elements
3. Use conflict detection to prevent broken references
4. Maintain audit trails of deletion requests
5. Configure rollback mechanisms where possible

#### General Workflow Management
1. Document custom workflow logic
2. Use descriptive names for workflow states
3. Implement error handling for all transitions
4. Configure timeout settings appropriately
5. Regularly review and optimize workflow performance

## Approval and Release Processes

### Typical Release Workflow Structure

1. **Initiation**: Content editor requests release
2. **Validation**: System checks for dependencies and conflicts
3. **Approval**: Designated approver reviews changes
4. **Pre-Release**: Final validation and preparation
5. **Release**: Content published to live environment
6. **Notification**: Stakeholders informed of release

### Approval Stages

Workflows can implement multiple approval stages:
- **First-Level Approval**: Content quality review
- **Second-Level Approval**: Business rule validation
- **Final Approval**: Production release authorization

### Release Coordination

For complex releases involving multiple elements:
- Dependency resolution ensures correct order
- Batch release capabilities for related content
- Rollback mechanisms for failed releases
- Scheduling options for timed publication

## Workflow Validation

### Pre-Execution Validation
- User permissions check
- Element state verification
- Dependency validation
- Configuration correctness

### Runtime Validation
- State transition rules enforcement
- Data integrity checks
- Business rule compliance
- Error condition handling

### Post-Execution Validation
- Completion status verification
- Audit log generation
- Notification delivery confirmation
- State consistency checks

## Target Audience

Workflow development and configuration is designed for:
- Technical project managers
- FirstSpirit developers
- System administrators
- Content architecture specialists

**Prerequisites:**
- Familiarity with FirstSpirit structure
- Understanding of workflow concepts
- Knowledge of project requirements
- Experience with permission management

## Additional Resources

For detailed API documentation and advanced workflow development, refer to:
- FirstSpirit API documentation
- Workflow model package documentation
- Template store access documentation
- Custom script development guides
