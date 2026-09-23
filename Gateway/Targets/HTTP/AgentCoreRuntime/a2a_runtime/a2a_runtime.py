from strands import Agent, tool
from strands.multiagent.a2a.executor import StrandsA2AExecutor
from bedrock_agentcore.runtime.a2a import serve_a2a
from strands.models import BedrockModel


@tool
def add_numbers(a: int, b: int) -> int:
    """Return the sum of two numbers."""
    return a + b


tools = [add_numbers]

agent = Agent(
    model=BedrockModel(
        model_id="global.anthropic.claude-opus-5",
    ),
    system_prompt="You are a helpful assistant. Use tools when appropriate.",
    tools=tools,
)

if __name__ == "__main__":
    serve_a2a(StrandsA2AExecutor(agent))
