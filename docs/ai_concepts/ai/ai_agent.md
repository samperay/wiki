Defined tool schemas that the LLM can read and act on
Wrote a tool-call loop that detects finish_reason == "tool_calls" and dispatches execution
Returned tool results to the model so it could compose a complete answer
Let the model decide when to call the tool based on the user's request


import os
import json
from openai import OpenAI

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
    base_url=os.getenv("OPENAI_API_BASE"),
)

tools = [
    {
        "type": "function",
        "function": {
            "name": "check_calendar",
            "description": "Check the user's calendar for events on a given date.",
            "parameters": {
                "type": "object",
                "properties": {
                    "date": {
                        "type": "string",
                        "description": "The date to check in YYYY-MM-DD format."
                    }
                },
                "required": ["date"]
            }
        }
    },
        {
        "type": "function",
        "function": {
            "name": "check_email_inbox",
            "description": "list un-read emails for the user",
            "parameters": {
                "type": "object",
                "properties": {
                    "email_id": {
                        "type": "string",
                        "description": "get the input text in any format."
                    }
                },
                "required": ["email_id"]
            }
        }
    },

]

def check_calendar(date):
    return "10am: Team standup, 2pm: Dentist appointment"

def check_email_inbox(email_id):
    return "technanny@simply.com: you have 10 unread emails, sam@test.com: you have 1000 unread emails" 


def execute_tool(name, args):
    if name == "check_calendar":
        return check_calendar(**args)
    elif name == "check_email_inbox":
        return check_email_inbox(**args)
    return f"Unknown tool: {name}"

system_message = "You are a helpful personal assistant."

messages = [
    {"role": "system", "content": system_message},
    {"role": "user", "content": "Do I have any unread emails?"}
]

response = client.chat.completions.create(
    model="openai/gpt-4.1-mini",
    messages=messages,
    tools=tools,
)

finish_reason = response.choices[0].finish_reason
print(f"Finish reason: {finish_reason}")

if finish_reason == "tool_calls":
    assistant_message = response.choices[0].message
    messages.append(assistant_message)

    for tool_call in assistant_message.tool_calls:
        name = tool_call.function.name
        args = json.loads(tool_call.function.arguments)
        result = execute_tool(name, args)

        messages.append({
            "role": "tool",
            "tool_call_id": tool_call.id,
            "content": result,
        })

    final_response = client.chat.completions.create(
        model="openai/gpt-4.1-mini",
        messages=messages,
        tools=tools,
    )
    print(final_response.choices[0].message.content)
else:
    print(response.choices[0].message.content)



# Agent loop

Here is what you built:

An OpenAI client configured from environment variables
A while True loop that calls the LLM and checks finish_reason
A multi-turn loop that drives a sequence of questions through a shared conversation history
That while loop — checking finish_reason == "stop" to decide whether to exit — is the core of every agent in this course. When you add tools in the next lesson, you will extend the else branch to handle tool_calls. The loop itself does not change.

What is next: The next lesson introduces the other four components of a real agent — tools, tool execution, memory management, and the system prompt — and wires them into the loop you built here.

```python
import os
from openai import OpenAI

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
    base_url=os.getenv("OPENAI_API_BASE"),
)

messages = [
    {"role": "system", "content": "You are a helpful assistant."}
]

# Replace the block below with the multi-turn loop

questions = [
    "What is an agent?",
    "How is that different from a chatbot?",
    "Give me one example.",
]

for question in questions:
    messages.append({"role": "user", "content": question})

    while True:
        response = client.chat.completions.create(
            model="openai/gpt-4.1-mini",
            messages=messages,
        )
        finish_reason = response.choices[0].finish_reason
        if finish_reason == "stop":
            reply = response.choices[0].message.content
            print(f"Q: {question}")
            print(f"A: {reply}")
            print()
            messages.append({"role": "assistant", "content": reply})
            break
        else:
            break

```
