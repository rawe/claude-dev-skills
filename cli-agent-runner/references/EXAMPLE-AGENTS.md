# Example Agent Definitions

This reference provides a complete example agent definition demonstrating all three components of the CLI Agent Runner agent system.

## Example Source Location

The example files are located at `../example/agents/` (relative to this file) and include:

**browser-tester.json** - Agent configuration
- Defines agent name, description, and references to prompt and MCP config files

**browser-tester.prompt.md** - System prompt
- Contains role definition, expertise areas, and behavioral guidelines
- Automatically prepended to user prompts when the agent is used

**browser-tester.mcp.json** - MCP configuration
- Configures Playwright MCP server for browser automation capabilities
- Provides tool access to the agent's sessions
- IMPORTANT: Not all agents require MCP configurations; this is specific to agents needing external tool access.

## Using the Example

**Source**: Copy the example files from `../example/agents/` (relative to this file)
**Destination**: Place them in `.cli-agent-runner/agents/` in your project directory

Once copied to your project, the agent can be used with the CLI Agent Runner script.

## Customizing Agents

To create your own agents based on this example:
1. Copy and rename all three files to match your agent's purpose
2. Update the `name` field in the JSON to match the new filename (without extension)
3. Edit the system prompt markdown file to define your agent's role and behavior
4. Modify or add MCP configurations for any tools your agent requires
5. Update the description to clearly explain the agent's purpose
