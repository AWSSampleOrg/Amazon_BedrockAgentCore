from bedrock_agentcore import BedrockAgentCoreApp, RequestContext
from strands import Agent, tool
from strands.models import BedrockModel
import typing

app = BedrockAgentCoreApp()


@app.entrypoint
def invoke(payload: dict[str, typing.Any], context: RequestContext):
    agent = Agent(
        model=BedrockModel(
            model_id="global.anthropic.claude-opus-5",
        ),
        system_prompt="",
    )
    return agent(prompt=payload.get("prompt"))


if __name__ == "__main__":
    app.run(port=8080)
