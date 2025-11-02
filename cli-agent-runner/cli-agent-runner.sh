#!/bin/bash

set -euo pipefail

# Constants
PROJECT_DIR="$PWD"
AGENT_SESSIONS_DIR="$PROJECT_DIR/.cli-agent-runner/agent-sessions"
AGENTS_DIR="$PROJECT_DIR/.cli-agent-runner/agents"
MAX_NAME_LENGTH=30

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Show help message
show_help() {
  cat << EOF
Usage:
  cli-agent-runner.sh new <session-name> [--agent <agent-name>] [-p <prompt>]
  cli-agent-runner.sh resume <session-name> [-p <prompt>]
  cli-agent-runner.sh list
  cli-agent-runner.sh list-agents
  cli-agent-runner.sh clean

Commands:
  new          Create a new session (optionally with an agent)
  resume       Resume an existing session
  list         List all sessions with metadata
  list-agents  List all available agent definitions
  clean        Remove all sessions

Arguments:
  <session-name>  Name of the session (alphanumeric, dash, underscore only; max 30 chars)
  <agent-name>    Name of the agent definition to use (optional for new command)

Options:
  -p <prompt>     Session prompt (can be combined with stdin; -p content comes first)
  --agent <name>  Use a specific agent definition (only for new command)

Examples:
  # Create new session (generic, no agent)
  ./cli-agent-runner.sh new architect -p "Design user auth system"

  # Create new session with agent
  ./cli-agent-runner.sh new architect --agent system-architect -p "Design user auth system"

  # Create new session from file
  cat prompt.md | ./cli-agent-runner.sh new architect --agent system-architect

  # Resume session (agent association remembered)
  ./cli-agent-runner.sh resume architect -p "Continue with API design"

  # Resume from file
  cat continue.md | ./cli-agent-runner.sh resume architect

  # Combine -p and stdin (concatenated)
  cat requirements.md | ./cli-agent-runner.sh new architect -p "Create architecture based on:"

  # List all sessions
  ./cli-agent-runner.sh list

  # List all agent definitions
  ./cli-agent-runner.sh list-agents

  # Remove all sessions
  ./cli-agent-runner.sh clean
EOF
}

# Error message helper
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}

# Ensure required directories exist
ensure_directories() {
  mkdir -p "$AGENT_SESSIONS_DIR"
  mkdir -p "$AGENTS_DIR"
}

# Validate session name
validate_session_name() {
  local name="$1"

  # Check if empty
  if [ -z "$name" ]; then
    error "Session name cannot be empty"
  fi

  # Check length
  if [ ${#name} -gt $MAX_NAME_LENGTH ]; then
    error "Session name too long (max $MAX_NAME_LENGTH characters): $name"
  fi

  # Check for valid characters (alphanumeric, dash, underscore only)
  if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    error "Session name contains invalid characters. Only alphanumeric, dash (-), and underscore (_) are allowed: $name"
  fi
}

# Get prompt from -p flag and/or stdin
get_prompt() {
  local prompt_arg="$1"
  local final_prompt=""

  # Add -p content first if provided
  if [ -n "$prompt_arg" ]; then
    final_prompt="$prompt_arg"
  fi

  # Check if stdin has data
  if [ ! -t 0 ]; then
    # Read from stdin
    local stdin_content
    stdin_content=$(cat)
    if [ -n "$stdin_content" ]; then
      # If we already have prompt from -p, add newline separator
      if [ -n "$final_prompt" ]; then
        final_prompt="${final_prompt}"$'\n'"${stdin_content}"
      else
        final_prompt="$stdin_content"
      fi
    fi
  fi

  # Check if we got any prompt at all
  if [ -z "$final_prompt" ]; then
    error "No prompt provided. Use -p flag or pipe prompt via stdin"
  fi

  echo "$final_prompt"
}

# Extract result from last line of agent session file
extract_result() {
  local session_file="$1"

  if [ ! -f "$session_file" ]; then
    error "Session file not found: $session_file"
  fi

  local result
  result=$(tail -n 1 "$session_file" | jq -r '.result // empty' 2>/dev/null)

  if [ -z "$result" ]; then
    error "Could not extract result from session file"
  fi

  echo "$result"
}

# Extract session_id from first line of agent session file
extract_session_id() {
  local session_file="$1"

  if [ ! -f "$session_file" ]; then
    error "Session file not found: $session_file"
  fi

  local session_id
  session_id=$(head -n 1 "$session_file" | jq -r '.session_id // empty' 2>/dev/null)

  if [ -z "$session_id" ]; then
    error "Could not extract session_id from session file"
  fi

  echo "$session_id"
}

# Load agent configuration
load_agent_config() {
  local agent_name="$1"
  local agent_file="$AGENTS_DIR/${agent_name}.json"

  if [ ! -f "$agent_file" ]; then
    error "Agent not found: $agent_name (expected: $agent_file)"
  fi

  # Validate JSON
  if ! jq empty "$agent_file" 2>/dev/null; then
    error "Invalid JSON in agent configuration: $agent_file"
  fi

  # Extract fields
  AGENT_NAME=$(jq -r '.name' "$agent_file")
  AGENT_DESCRIPTION=$(jq -r '.description' "$agent_file")
  SYSTEM_PROMPT_FILE=$(jq -r '.system_prompt_file // empty' "$agent_file")
  MCP_CONFIG=$(jq -r '.mcp_config // empty' "$agent_file")

  # Validate name matches filename
  if [ "$AGENT_NAME" != "$agent_name" ]; then
    error "Agent name mismatch: filename=$agent_name, config name=$AGENT_NAME"
  fi
}

# Load system prompt from file
load_system_prompt() {
  local prompt_file="$1"

  if [ -z "$prompt_file" ]; then
    echo ""
    return
  fi

  local full_path="$AGENTS_DIR/$prompt_file"
  if [ ! -f "$full_path" ]; then
    error "System prompt file not found: $full_path"
  fi

  cat "$full_path"
}

# Save session metadata
save_session_metadata() {
  local session_name="$1"
  local agent_name="$2"  # Can be empty for generic sessions
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  local meta_file="$AGENT_SESSIONS_DIR/${session_name}.meta.json"

  cat > "$meta_file" <<EOF
{
  "session_name": "$session_name",
  "agent": $([ -n "$agent_name" ] && echo "\"$agent_name\"" || echo "null"),
  "created_at": "$timestamp",
  "last_resumed_at": "$timestamp"
}
EOF
}

# Load session metadata
load_session_metadata() {
  local session_name="$1"
  local meta_file="$AGENT_SESSIONS_DIR/${session_name}.meta.json"

  if [ ! -f "$meta_file" ]; then
    # No metadata - treat as generic session (backward compatibility)
    SESSION_AGENT=""
    return
  fi

  SESSION_AGENT=$(jq -r '.agent // empty' "$meta_file")
}

# Update session metadata timestamp
update_session_metadata() {
  local session_name="$1"
  local agent_name="$2"  # Optional: agent name if known
  local meta_file="$AGENT_SESSIONS_DIR/${session_name}.meta.json"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  if [ -f "$meta_file" ]; then
    # Update last_resumed_at
    jq ".last_resumed_at = \"$timestamp\"" "$meta_file" > "${meta_file}.tmp"
    mv "${meta_file}.tmp" "$meta_file"
  else
    # Create meta.json if it doesn't exist (backward compatibility)
    save_session_metadata "$session_name" "$agent_name"
  fi
}

# Build MCP config argument for Claude CLI
build_mcp_arg() {
  local mcp_config="$1"

  if [ -z "$mcp_config" ]; then
    echo ""
    return
  fi

  if [ ! -f "$mcp_config" ]; then
    error "MCP config file not found: $mcp_config"
  fi

  echo "--mcp-config $mcp_config"
}

# Command: new
cmd_new() {
  local session_name="$1"
  local prompt_arg="$2"
  local agent_name="$3"  # Optional

  validate_session_name "$session_name"

  local session_file="$AGENT_SESSIONS_DIR/${session_name}.jsonl"

  # Check if session already exists
  if [ -f "$session_file" ]; then
    error "Session '$session_name' already exists. Use 'resume' command to continue or choose a different name"
  fi

  # Get user prompt
  local user_prompt
  user_prompt=$(get_prompt "$prompt_arg")

  # Load agent configuration if specified
  local final_prompt="$user_prompt"
  local mcp_arg=""

  if [ -n "$agent_name" ]; then
    load_agent_config "$agent_name"

    # Load and prepend system prompt
    if [ -n "$SYSTEM_PROMPT_FILE" ]; then
      local system_prompt
      system_prompt=$(load_system_prompt "$SYSTEM_PROMPT_FILE")
      final_prompt="${system_prompt}"$'\n\n---\n\n'"${user_prompt}"
    fi

    # Build MCP argument
    mcp_arg=$(build_mcp_arg "$MCP_CONFIG")
  fi

  # Ensure required directories exist
  ensure_directories

  # Save session metadata immediately
  save_session_metadata "$session_name" "$agent_name"

  # Run claude command
  if ! claude -p "$final_prompt" $mcp_arg --output-format stream-json --permission-mode bypassPermissions >> "$session_file" 2>&1; then
    error "Claude command failed"
  fi

  # Extract and output result
  extract_result "$session_file"
}

# Command: resume
cmd_resume() {
  local session_name="$1"
  local prompt_arg="$2"

  validate_session_name "$session_name"

  local session_file="$AGENT_SESSIONS_DIR/${session_name}.jsonl"

  # Check if session exists
  if [ ! -f "$session_file" ]; then
    error "Session '$session_name' does not exist. Use 'new' command to create it"
  fi

  # Load session metadata to get agent
  load_session_metadata "$session_name"

  # Extract session_id
  local session_id
  session_id=$(extract_session_id "$session_file")

  # Get prompt
  local prompt
  prompt=$(get_prompt "$prompt_arg")

  # Load agent configuration if session has an agent
  local mcp_arg=""
  if [ -n "$SESSION_AGENT" ]; then
    load_agent_config "$SESSION_AGENT"
    mcp_arg=$(build_mcp_arg "$MCP_CONFIG")
  fi

  # Run claude command with resume
  if ! claude -r "$session_id" -p "$prompt" $mcp_arg --output-format stream-json --permission-mode bypassPermissions >> "$session_file" 2>&1; then
    error "Claude resume command failed"
  fi

  # Update session metadata timestamp (or create if missing)
  update_session_metadata "$session_name" "$SESSION_AGENT"

  # Extract and output result
  extract_result "$session_file"
}

# Command: list
cmd_list() {
  # Ensure required directories exist
  ensure_directories

  # Check if there are any sessions
  local session_files=("$AGENT_SESSIONS_DIR"/*.jsonl)

  if [ ! -f "${session_files[0]}" ]; then
    echo "No sessions found"
    return
  fi

  # List all sessions with metadata
  for session_file in "$AGENT_SESSIONS_DIR"/*.jsonl; do
    local session_name
    session_name=$(basename "$session_file" .jsonl)

    local session_id
    # Extract session_id without calling error function (for empty/initializing sessions)
    if [ -s "$session_file" ]; then
      session_id=$(head -n 1 "$session_file" 2>/dev/null | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")
    else
      session_id="initializing"
    fi

    echo "$session_name (session: $session_id)"
  done
}

# Command: list-agents
cmd_list_agents() {
  # Ensure required directories exist
  ensure_directories

  # Check if there are any agent definition files
  local agent_files=("$AGENTS_DIR"/*.json)

  if [ ! -f "${agent_files[0]}" ]; then
    echo "No agent definitions found"
    return
  fi

  # List all agent definitions
  local first=true
  for agent_file in "$AGENTS_DIR"/*.json; do
    local agent_name
    local agent_description

    # Extract name and description from JSON
    agent_name=$(jq -r '.name // "unknown"' "$agent_file" 2>/dev/null)
    agent_description=$(jq -r '.description // "No description available"' "$agent_file" 2>/dev/null)

    # Add separator before each agent (except the first)
    if [ "$first" = true ]; then
      first=false
    else
      echo "---"
      echo ""
    fi

    # Display in requested format
    echo "${agent_name}:"
    echo "${agent_description}"
    echo ""
  done
}

# Command: clean
cmd_clean() {
  # Remove the entire agent-sessions directory
  if [ -d "$AGENT_SESSIONS_DIR" ]; then
    rm -rf "$AGENT_SESSIONS_DIR"
    echo "All sessions removed"
  else
    echo "No sessions to remove"
  fi
}

# Main script logic
main() {
  # Check if no arguments provided
  if [ $# -eq 0 ]; then
    show_help
    exit 1
  fi

  local command="$1"
  shift

  case "$command" in
    new)
      # Parse arguments
      if [ $# -eq 0 ]; then
        error "Session name required for 'new' command"
      fi

      local session_name="$1"
      shift

      local prompt_arg=""
      local agent_name=""
      while [ $# -gt 0 ]; do
        case "$1" in
          -p)
            if [ $# -lt 2 ]; then
              error "-p flag requires a prompt argument"
            fi
            prompt_arg="$2"
            shift 2
            ;;
          --agent)
            if [ $# -lt 2 ]; then
              error "--agent flag requires an agent name"
            fi
            agent_name="$2"
            shift 2
            ;;
          *)
            error "Unknown option: $1"
            ;;
        esac
      done

      cmd_new "$session_name" "$prompt_arg" "$agent_name"
      ;;

    resume)
      # Parse arguments
      if [ $# -eq 0 ]; then
        error "Session name required for 'resume' command"
      fi

      local session_name="$1"
      shift

      local prompt_arg=""
      while [ $# -gt 0 ]; do
        case "$1" in
          -p)
            if [ $# -lt 2 ]; then
              error "-p flag requires a prompt argument"
            fi
            prompt_arg="$2"
            shift 2
            ;;
          *)
            error "Unknown option: $1"
            ;;
        esac
      done

      cmd_resume "$session_name" "$prompt_arg"
      ;;

    list)
      cmd_list
      ;;

    list-agents)
      cmd_list_agents
      ;;

    clean)
      cmd_clean
      ;;

    -h|--help)
      show_help
      exit 0
      ;;

    *)
      error "Unknown command: $command\n\nRun './cli-agent-runner.sh' for usage information"
      ;;
  esac
}

# Run main function
main "$@"
