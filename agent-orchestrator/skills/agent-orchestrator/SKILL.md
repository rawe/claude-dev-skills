---
name: agent-orchestrator
description: Use this skill when you need to orchestrate another Claude Code session via the agent-orchestrator.sh script to perform specialized, potentially long-running tasks in a simplified way. This wrapper handles session management, result extraction, and can be run in background with polling support.
---

# Agent Orchestrator Skill

## Intro

This skill provides guidance on using the `agent-orchestrator.sh` script to delegate work to Claude Code sessions.

Use this when you need to:
- Delegate a task to a specialized session for long-running operations
- Resume tasks later using a simple session name (no session ID management needed)
- Run sessions in the background with polling support
- Get clean result output without manual JSON parsing
- Optionally use agent definitions for specialized behavior

**Key Benefits:**
- Session names instead of session IDs (simpler to track and resume)
- Automatic session file management in `.agent-orchestrator/agent-sessions/` directory
- Built-in result extraction (no need for head/tail/jq commands)
- Clean output to stdout, errors to stderr
- Optional agent associations for specialized capabilities

## Terminology

- **Session**: A named, running conversation with Claude Code
- **Agent**: A reusable configuration/definition that provides specialized behavior for sessions
- **Session Name**: The unique identifier you give to a conversation (e.g., `architect`, `reviewer`)
- **Agent Name**: The identifier for a reusable agent definition (e.g., `system-architect`, `security-reviewer`)

## Variables

The following variables are used in the commands and instructions:

- `<session-name>`: A unique identifier for the session (alphanumeric, dash, underscore only; max 30 chars)
- `<agent-name>`: Optional agent definition to use for the session
- `<initial-prompt>`: The prompt or task description for a new session
- `<resume-prompt>`: The prompt or task description to continue an existing session's work
- `<POLL_INTERVAL>`: The interval in seconds to wait between polling attempts. Default is 60 seconds.

## Script Location

**IMPORTANT:** The `agent-orchestrator.sh` script is located in the same directory as this SKILL.md file.
So it is in the root folder of the skill plugin.

Before using the script for the first time in a conversation, you MUST locate it:

1. Identify the root folder of the plugin skill and append the script name:
   ```
   <path-to-skill-root-folder>/agent-orchestrator.sh
   ```
2. Store this path mentally for the rest of the conversation: <absolute-path-to-agent-orchestrator.sh>
3. Use the absolute path in all subsequent commands

**Example:**
```bash
# Use that exact path in all commands:
<absolute-path-to-agent-orchestrator.sh> new <session-name> -p "<prompt>"
```

**Note:** In all examples below, `agent-orchestrator.sh` represents the absolute path <absolute-path-to-agent-orchestrator.sh> you discovered. Replace it with the actual path when executing commands.

## Commands Overview

The agent-orchestrator.sh supports five commands:

1. **new** - Create a new session (optionally with an agent)
2. **resume** - Resume an existing session by name
3. **list** - List all sessions with their session IDs
4. **list-agents** - List all available agent definitions
5. **clean** - Remove all sessions

## Usage Patterns

### Pattern 1: Synchronous Execution (Wait for Completion)

Use this when you want to wait for the session to complete and get the result immediately.

**Creating a new session:**
```bash
./agent-orchestrator.sh new <session-name> -p "<initial-prompt>"
```

**Creating a new session with an agent:**
```bash
./agent-orchestrator.sh new <session-name> --agent <agent-name> -p "<initial-prompt>"
```

**Creating a new session with prompt from file/stdin:**

This should be considered when the prompt is large or complex or already a prompt file exists potentially created by another session.

```bash
cat prompt.md | ./agent-orchestrator.sh new <session-name>
```

**Resuming an existing session:**
```bash
./agent-orchestrator.sh resume <session-name> -p "<resume-prompt>"
```

**Example:**
```bash
# Create new session with agent
./agent-orchestrator.sh new architect --agent system-architect -p "Create a high-level architecture document for a user authentication system"

# The script blocks until completion and outputs the result
# Output: <result from session>

# Resume the session later (agent association is remembered)
./agent-orchestrator.sh resume architect -p "Add API endpoint specifications to the architecture"
```

### Pattern 2: Background Execution with Polling

Use this when you want to start the session in the background and poll for completion.

**Instructions:**

**1. Start the session in the background:**
- Use Bash tool with `run_in_background: true`
- Use either `new` or `resume` command
- **Important:** Note the bash_id returned by the Bash tool

**Example for new session:**
```bash
./agent-orchestrator.sh new <session-name> -p "<initial-prompt>"
```

**Example for new session with agent:**
```bash
./agent-orchestrator.sh new <session-name> --agent <agent-name> -p "<initial-prompt>"
```

**Example for resuming session:**
```bash
./agent-orchestrator.sh resume <session-name> -p "<resume-prompt>"
```

**2. Initial Polling Wait:**
- Use Bash tool (NOT background): `sleep <POLL_INTERVAL>`
- Default POLL_INTERVAL is 60 seconds

**3. Check if background process is still running:**
- Use BashOutput tool with the bash_id from step 1
- The tool returns shell status showing if process is running or completed
- If status shows still running: continue to step 4
- If status shows completed: continue to step 5
- **Do NOT use:** kill -0, pgrep, ps, or any other process checking commands

**4. Polling Wait Loop:**
- Use Bash tool (NOT background): `sleep <POLL_INTERVAL>`
- Return to step 3

**5. Process Completed - Get Results:**
- The result is already captured in the Bash tool's output when the process completes
- Simply read the output from the completed Bash execution
- The output will be the session's result (already extracted by the script)

**Full Background Example:**
```bash
# Step 1: Start in background
./agent-orchestrator.sh new architect --agent system-architect -p "Design authentication system"
# Returns bash_id: abc123

# Step 2: Initial wait
sleep 60

# Step 3: Check status
# Use BashOutput with bash_id: abc123
# If status: running, continue to step 4
# If status: completed, read the output - it contains the result

# Step 4: If still running, wait and check again
sleep 60
# Return to step 3
```

### Pattern 3: Listing Sessions

Use this to see all existing sessions and their status.

```bash
./agent-orchestrator.sh list
```

**Output format:**
```
session-name (session: session-id)
architect (session: 3db5dca9-6829-4cb7-a645-c64dbd98244d)
reviewer (session: initializing)
```

- "initializing" means the session file exists but hasn't started yet (empty file)
- "unknown" means the session ID couldn't be extracted
- Otherwise, shows the actual session ID

### Pattern 4: Listing Available Agent Definitions

Use this to discover what agent definitions are available before creating a session.

```bash
./agent-orchestrator.sh list-agents
```

**Output format:**
```
agent-name:
description

---

next-agent-name:
description

---

another-agent-name:
description
```

**Example output:**
```
code-reviewer:
Reviews code for best practices, bugs, and potential improvements

---

documentation-writer:
Creates comprehensive technical documentation and guides

---

system-architect:
Expert in designing scalable system architectures
```

**Use Case:**
- Discover available agents before creating a new session
- Understand what specialized capabilities are available
- Choose the appropriate agent for your task

**Important Notes:**
- Each agent definition is separated by `---` for clear parsing
- Agent names can be used with `--agent` flag when creating sessions
- If no agents exist, outputs: "No agent definitions found"

### Pattern 5: Cleaning All Sessions

Use this to remove all sessions and start fresh.

```bash
./agent-orchestrator.sh clean
```

**Behavior:**
- Removes the entire `.agent-orchestrator/agent-sessions/` directory
- All session files and history are permanently deleted
- No confirmation prompt - immediate deletion
- Safe to run even if no sessions exist

**Output:**
```
All sessions removed
```
or
```
No sessions to remove
```

## Prompt Input Methods

The script supports flexible prompt input:

1. **Via `-p` flag only:** `./agent-orchestrator.sh new architect -p "Your prompt here"`
2. **Via stdin only:** `echo "Your prompt" | ./agent-orchestrator.sh new architect`
3. **Both combined:** `cat file.md | ./agent-orchestrator.sh new architect -p "Context:"`

**Concatenation:** If both `-p` and stdin are provided, they are concatenated with `-p` content first, then a newline, then stdin content. This is useful for adding context before piping in a file.

**IMPORTANT** STDIN should be used if it is neccessarry to provide a a large complex promt to the agent or the result of another command output. e.g. `tree` for listing a directory structure.

**Example:**
```bash
cat requirements.md | ./agent-orchestrator.sh new architect -p "Create an architecture document based on these requirements:"
```
Results in prompt:
```
Create an architecture document based on these requirements:
<contents of requirements.md>
```

## Error Handling

All errors are output to stderr and the script exits with code 1:

- **Session name validation errors:**
  - Empty name
  - Name too long (>30 characters)
  - Invalid characters (only alphanumeric, dash, underscore allowed)

- **Session lifecycle errors:**
  - Creating session that already exists → Use `resume` instead
  - Resuming session that doesn't exist → Use `new` instead

- **Agent errors:**
  - Agent definition not found
  - Invalid agent configuration

- **Prompt errors:**
  - No prompt provided (neither `-p` nor stdin)

- **Execution errors:**
  - Claude command failed
  - Could not extract session_id or result

## Session Files

- **Location:** `.agent-orchestrator/agent-sessions/<session-name>.jsonl`
- **Metadata:** `.agent-orchestrator/agent-sessions/<session-name>.meta.json` (tracks agent association)
- **Format:** Line-delimited JSON (JSONL)
- **Management:** Fully automatic - you don't need to manage these files

## Agent Definitions

- **Location:** `.agent-orchestrator/agents/<agent-name>.json` (configuration)
- **Prompts:** `.agent-orchestrator/agents/<agent-name>.prompt.md` (system prompt)
- **Format:** Hybrid JSON + Markdown
- **Usage:** Optional - sessions can run without agents

## Best Practices

1. **Session naming:** Use descriptive names like `architect`, `reviewer`, `dev-agent`, `po-agent`
2. **Agent discovery:** Use `list-agents` to discover available agents before creating sessions
3. **Agent selection:** Use agents for specialized behavior, skip for generic tasks
4. **Background execution:** Use for long-running tasks (>1 minute expected)
5. **Synchronous execution:** Use for quick tasks (<1 minute expected)
6. **Polling interval:** Start with 60 seconds, adjust based on expected task duration
7. **Resume strategy:** Use meaningful resume prompts that build on previous work

## Example Workflow

```bash
# 1. Discover available agents
./agent-orchestrator.sh list-agents
# Output shows:
# system-architect:
# Expert in designing scalable system architectures
# ---
# code-reviewer:
# Reviews code for best practices, bugs, and potential improvements
# ---
# documentation-writer:
# Creates comprehensive technical documentation and guides

# 2. Create new architect session with agent in background
# Use Bash tool with run_in_background: true
./agent-orchestrator.sh new architect --agent system-architect -p "Create architecture for microservices-based e-commerce system"
# Note bash_id: xyz789

# 3. Wait 60 seconds
sleep 60

# 4. Check if completed using BashOutput with bash_id xyz789
# Status: running

# 5. Wait another 60 seconds
sleep 60

# 6. Check again with BashOutput
# Status: completed
# Output contains the architecture document result

# 7. Later, resume the session for additional work (agent association remembered)
./agent-orchestrator.sh resume architect -p "Add security considerations to the architecture"

# 8. List all sessions to see status
./agent-orchestrator.sh list
# Output: architect (session: 3db5dca9-6829-4cb7-a645-c64dbd98244d)
```

 ## Important: Working Directory Requirements

  **The `agent-orchestrator.sh` script must be run from your project root** where the `.agent-orchestrator/` directory exists or will be created.

  ### Common Pitfall

  If you change directories during your workflow, the script will look for `.agent-orchestrator/` relative to your current location and may fail silently.

  **Example - What NOT to do:**
  ```bash
  cd .agent-orchestrator/agent-sessions  # Changed directory
  agent-orchestrator.sh clean              # ❌ Returns "No sessions to remove"
  # Script looks for: .agent-orchestrator/agent-sessions/.agent-orchestrator/agent-sessions/

  Example - Correct approach:
  cd /path/to/your/project               # ✅ Back to project root
  agent-orchestrator.sh clean              # ✅ Works correctly
  # Script looks for: /path/to/your/project/.agent-orchestrator/agent-sessions/

  Best Practice

  Always use absolute paths when running the script from non-root directories:

  # Safe - works from any directory
  cd /path/to/your/project && /path/to/agent-orchestrator.sh clean

  # Or explicitly change to project root first
  cd "$(git rev-parse --show-toplevel)" && agent-orchestrator.sh clean

  Shell Persistence Note

  In background shells or long-running terminal sessions, cd commands persist across multiple commands. Always verify your working directory with pwd before running agent-orchestrator.sh
  commands.


## Additional Documentation

**Creating Custom Agents**: See `references/EXAMPLE-AGENTS.md` for a complete agent definition example showing how to create agents with JSON configuration, system prompts, and MCP server integration.

**Architecture & Design Details**: See `references/AGENT-ORCHESTRATOR.md` for comprehensive documentation on the Agent Orchestrator's architecture, design philosophy, directory structure, and advanced usage patterns.