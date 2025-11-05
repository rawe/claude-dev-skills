# Claude Dev Skills Marketplace

A marketplace for Claude Code skills and plugins.

## Installation

Add this marketplace to your Claude Code configuration:

```
https://github.com/rawe/claude-dev-skills
```

## Available Plugins

### FirstSpirit Templating
Comprehensive knowledge for templating in the FirstSpirit CMS, specifically focused on SiteArchitect development. Covers page templates, section templates, format templates, link templates, input components, template syntax, system objects, rules, and workflows.

**Keywords:** firstspirit, cms, templating, sitearchitect

### FirstSpirit CLI (fs-cli)
FirstSpirit CMS template development using fs-cli. Helps set up fs-cli environment, export templates from FirstSpirit server, modify templates with Claude Code, and import changes back to server. Use when working with FirstSpirit templates, CMS development, or when user mentions fs-cli, FirstSpirit, or template synchronization.

**Keywords:** firstspirit, fs-cli, cms, template-sync, cli

### CLI Agent Runner
Wrapper for Claude Code enabling delegated agent sessions for specialized, potentially long-running tasks. Key features include resumable sessions by name (no session ID management), independent MCP configurations per agent, and background execution with polling support.

**Keywords:** cli, agent, session-management, background-tasks, delegation, mcp-configuration, resumption

### Agent Orchestrator
Framework for orchestrating specialized Claude Code agents to perform complex tasks through delegation and collaboration. Includes commands for initializing agent orchestration capabilities (`/agent-orchestrator-init` primes the main agent to manage and delegate to specialized agents) and creating new agent configurations (`/agent-orchestrator-create-agent` generates agent definition files with custom system prompts and MCP configurations).

**Keywords:** orchestration, agent-delegation, multi-agent, task-management, mcp-configuration, specialized-agents

## Contributing

To add a new plugin to this marketplace:

1. Add your plugin directory to the repository root
2. Each plugin can contain multiple skills, commands, and configuration files
3. Update `.claude-plugin/marketplace.json` with your plugin's metadata
4. Submit a pull request

## License

Individual plugins may have their own licenses. See each plugin directory for details.
