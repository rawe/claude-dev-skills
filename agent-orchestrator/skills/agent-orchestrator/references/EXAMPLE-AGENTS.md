# Example Agent Definitions

This reference provides a complete example agent definition demonstrating the Agent Orchestrator folder-based agent structure.

## Example Source Location

The example agent is located at `../example/agents/browser-tester/` (relative to this file) and includes:

```
browser-tester/
├── agent.json                   # Agent configuration
├── agent.system-prompt.md      # System prompt (optional)
└── agent.mcp.json               # MCP configuration (optional)
```

**agent.json** - Agent configuration
- Defines agent name and description
- Name must match the folder name

**agent.system-prompt.md** - System prompt
- Contains role definition, expertise areas, and behavioral guidelines
- Automatically prepended to user prompts when the agent is used
- Discovered by convention (no need to reference in agent.json)

**agent.mcp.json** - MCP configuration
- Configures Playwright MCP server for browser automation capabilities
- Provides tool access to the agent's sessions
- Discovered by convention (no need to reference in agent.json)
- IMPORTANT: Not all agents require MCP configurations; this is specific to agents needing external tool access

## Using the Example

**Source**: Copy the entire folder from `../example/agents/browser-tester/` (relative to this file)
**Destination**: Place it in `.agent-orchestrator/agents/` in your project directory

```bash
# From your project root
cp -r path/to/agent-orchestrator/example/agents/browser-tester .agent-orchestrator/agents/
```

Once copied to your project, the agent can be used with the CLI Agent Runner script:

```bash
# List available agents
./agent-orchestrator.sh list-agents

# Create session with the browser-tester agent
./agent-orchestrator.sh new my-test --agent browser-tester -p "Test login flow"
```

## Customizing Agents

To create your own agents based on this example:

1. **Copy the example folder** and rename it to match your agent's purpose
2. **Edit agent.json**: Update the `name` field to match the new folder name
3. **Edit agent.system-prompt.md**: Define your agent's role, expertise, and behavior
4. **Edit or remove agent.mcp.json**: Configure tools your agent needs, or delete if not needed
5. **Place in your project**: Copy the folder to `.agent-orchestrator/agents/` in your project

The folder structure keeps each agent self-contained and easy to distribute or version control.
