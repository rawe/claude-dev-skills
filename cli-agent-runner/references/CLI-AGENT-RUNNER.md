# CLI Agent Runner

A lightweight orchestration layer for managing multiple Claude Code agent sessions through a simple command-line interface.

## Overview

The CLI Agent Runner provides a simplified abstraction for delegating work to Claude Code. Instead of manually managing session IDs, output files, and JSON parsing, you work with **named sessions** that can be created, resumed, and monitored through intuitive commands. Sessions can optionally use **agent definitions** to provide specialized behavior and capabilities.

## Core Concepts

### Sessions

A **session** is a named, persistent conversation with Claude Code. Each session:
- Has a unique name (e.g., `architect`, `reviewer`, `dev-agent`)
- Maintains conversation history across multiple interactions
- Can be paused and resumed at any time
- Operates independently from other sessions
- Optionally uses an **agent** definition for specialized behavior

Think of sessions as individual workstreams or conversations you can delegate tasks to and check back with later.

### Agents (Definitions)

An **agent** is a reusable configuration that defines the behavior, expertise, and capabilities for sessions. Agents are optional - you can create generic sessions without them, or use agents to create specialized sessions with predefined behavior.

#### Agent Structure

Each agent consists of three components stored in `.cli-agent-runner/agents/`:

**1. JSON Configuration File** (`<agent-name>.json`)
```json
{
  "name": "system-architect",
  "description": "Expert in designing scalable system architectures",
  "system_prompt_file": "system-architect.prompt.md",  // Optional
  "mcp_config": "browser-tester.mcp.json"              // Optional
}
```
- `name`: Agent identifier (must match filename)
- `description`: Human-readable description
- `system_prompt_file`: Reference to system prompt (optional)
- `mcp_config`: Path to MCP configuration for tool access (optional)

**2. System Prompt File** (`<agent-name>.prompt.md`) - Optional
Markdown file containing the agent's role definition, expertise areas, and behavioral guidelines. When specified, this prompt is prepended to user prompts automatically.

**3. MCP Configuration File** (`<config-name>.json`) - Optional
Standard MCP server configuration enabling the agent to access external tools and capabilities. Passed to Claude CLI via `--mcp-config` flag.

#### Agent Workflow

When creating a session with an agent:
1. Agent JSON config is loaded and validated
2. System prompt (if specified) is prepended to user's prompt
3. MCP config (if specified) is passed to Claude CLI
4. Agent association is stored with session metadata
5. When resuming, the session automatically uses its associated agent

### Session Management

The tool abstracts away Claude Code's internal session ID management. You interact with sessions using memorable names rather than UUIDs, while the tool handles:
- Session file storage and organization
- Session ID extraction and tracking
- Agent association and configuration
- Result retrieval and formatting
- State management (initializing, active, completed)

## Use Cases

### Multi-Session Workflows

Coordinate multiple specialized sessions working on different aspects of a project:
```bash
# First, discover available agent definitions
./cli-agent-runner.sh list-agents

# Architecture session using system-architect agent
./cli-agent-runner.sh new architect --agent system-architect -p "Design microservices architecture for e-commerce"

# Development session implements based on architecture
cat architecture.md | ./cli-agent-runner.sh new developer --agent senior-developer -p "Implement based on this design:"

# Reviewer session provides feedback
./cli-agent-runner.sh new reviewer --agent security-reviewer -p "Review the implementation for best practices"
```

### Long-Running Background Tasks

Delegate time-consuming tasks to background sessions while you continue working:
- Large codebase analysis
- Comprehensive documentation generation
- Multi-step refactoring operations
- Complex test suite creation

### Iterative Refinement

Resume sessions to continue and refine their previous work:
```bash
# Initial work
./cli-agent-runner.sh new technical-writer --agent documentation-expert -p "Create API documentation"

# Later refinement
./cli-agent-runner.sh resume technical-writer -p "Add authentication examples"

# Further enhancement
./cli-agent-runner.sh resume technical-writer -p "Include error handling section"
```

### Stateful Conversations

Maintain context across multiple prompts without re-explaining background:
- Each session retains full conversation history
- No need to repeat requirements or context
- Build on previous responses naturally

## Features

### Current Capabilities

**Session Management**
- Create new sessions with descriptive names
- Resume existing sessions by name
- List all active sessions with status
- List all available agent definitions
- Clean up all sessions in one command
- Optional agent associations for specialized behavior

**Flexible Prompting**
- Direct prompt input via `-p` flag
- File-based prompts via stdin piping
- Combined prompts (prefix + file content)
- Large prompt support without character limits

**Execution Modes**
- Synchronous execution (wait for completion)
- Background execution with polling support
- Automatic result extraction
- Clean stdout/stderr separation

**State Tracking**
- Session status visibility (active, initializing, completed)
- Session ID management (hidden from user)
- Agent association tracking
- Conversation history persistence
- Cross-session identification

### Companion Skill

The `cli-agent-runner` skill provides integration guidance for Claude Code agents to use this tool within their own workflows. The skill documents:
- Synchronous and asynchronous usage patterns
- Background execution with polling logic
- Result extraction and error handling
- Best practices for agent orchestration

## Future Directions

### Agent Definitions (Current Implementation)

The tool now supports **agent definitions** - reusable configurations that define behavior, capabilities, and constraints for sessions:

**System Prompt Templates**
- Predefined role-based system prompts (architect, developer, reviewer, etc.)
- Consistent behavior across multiple sessions using the same agent
- Custom agent definitions for specialized workflows
- Markdown format for natural prompt editing

**Configuration Profiles**
- MCP (Model Context Protocol) server configurations per agent
- Tool access through MCP integration
- Hybrid JSON + Markdown format for easy editing

**Agent-Based Sessions**
```bash
# Create session with agent
./cli-agent-runner.sh new architect --agent system-architect -p "Design e-commerce system"

# Create generic session (no agent)
./cli-agent-runner.sh new quick-task -p "Simple task"

# Resume remembers agent association
./cli-agent-runner.sh resume architect -p "Add security layer"
```

**Separation of Concerns**
- **Agent**: Blueprint/configuration (reusable definition)
- **Session**: Running conversation (specific instance)
- Agents are reusable; sessions are unique conversations

### Additional Planned Features

**Advanced Orchestration**
- Session-to-session communication patterns
- Dependency chains between sessions
- Parallel session execution coordination
- Result aggregation and synthesis

**Enhanced State Management**
- Session snapshots and rollback
- Conversation branching
- Selective history pruning
- Export/import of sessions

**Observability**
- Detailed execution logs per session
- Token usage tracking
- Performance metrics
- Conversation visualization

**Workflow Automation**
- Declarative multi-session workflows
- Event-driven session triggering
- Conditional execution paths
- Workflow templates

## Architecture

### Components

**`cli-agent-runner.sh`**
Core bash script providing the command-line interface and orchestration logic. Handles session management, Claude Code CLI invocation, and result extraction.

### Directory Structure

The CLI Agent Runner uses a project-relative directory structure located at `.cli-agent-runner/` in the current working directory where the script is invoked.

**`.cli-agent-runner/agent-sessions/`**
Storage directory for session files (JSONL format). Each file contains the complete conversation history and session metadata for one session. Companion `.meta.json` files track agent associations and timestamps.

**`.cli-agent-runner/agents/`**
Storage directory for agent definitions specific to the current project. Each agent consists of:
- A JSON configuration file (`<agent-name>.json`) defining the agent's metadata and settings
- An optional Markdown prompt file (referenced in the JSON) containing the system prompt
- Optional MCP configuration files (referenced in the JSON) for tool access

All sessions and agent definitions are stored relative to the project directory (`$PWD`) where the script is invoked, ensuring each project maintains its own isolated agent environment.

### Design Philosophy

**Simplicity First**
Minimize cognitive overhead for users. Named sessions instead of UUIDs, intuitive commands, sensible defaults.

**Progressive Enhancement**
Start simple, add complexity only when needed. Basic usage is straightforward; advanced features are opt-in.

**Composability**
Tool plays well with Unix pipes, scripts, and other CLI tools. Clean input/output separation enables chaining and automation.

**Transparency**
Clear feedback, meaningful error messages, visible state. Users always know what's happening.

## Integration

The CLI Agent Runner is designed to work within the Claude Code ecosystem:

**Slash Commands**
Create custom slash commands that delegate to sessions via the runner.

**Skills**
Skills can orchestrate multiple sessions for complex, multi-step operations.

**MCP Servers**
Agents support MCP server configurations for enhanced capabilities.
The MCP configuration is passed to the Claude CLI when starting or resuming sessions.

**Workflows** _(Future)_
Declarative workflow definitions will coordinate multiple sessions.

## Status

**Current Version**: Initial Release
**Status**: Production Ready

The core functionality is stable and tested. Agent type system and advanced features are in design phase.

## Related Documentation

- **Script Help**: Run `./cli-agent-runner.sh --help` for command syntax and examples
- **Claude Code CLI**: Refer to Claude Code CLI documentation for underlying command options and usage: https://docs.claude.com/en/docs/claude-code/cli-reference 