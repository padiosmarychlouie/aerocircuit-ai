# AGENTS.md — Manufacturing Planning and Load Management

## Project Goal
Build a Manufacturing Planning System using Level 2 Agentic AI to help manage production schedules, materials, workloads, and delivery loads.

## Manufacturing Planning Agent Specification
| Field | Description |
| :--- | :--- |
| **Name and Role** | **Manufacturing Planning Agent** – identifies material shortages and production delays. |
| **Goal** | Find production problems and recommend practical solutions to avoid delays. |
| **Input/Trigger** | Triggered when a user requests a production check or enters new manufacturing data. Receives production orders, material inventory, and deadlines. |
| **Tools and Data** | Sample production data, inventory records, deadlines, and an AI (**OpenAI API**, Anthropic, or Gemini) tool for analyzing problems and recommending solutions. |
| **Outputs** | Displays identified problems and AI recommendations on the dashboard or in a response message to the production planner. |
| **Autonomy Level** | **Level 2 Agentic AI** – The agent analyzes problems and suggests solutions but requires human approval before making important changes. |
| **Failure Handling** | If data is missing or unclear, the system alerts the user and asks for the correct information. It does not make changes without approval. |

## AI Agent Responsibilities
- Detect production delays and material shortages.
- Analyze machine capacity and workload.
- Recommend practical production schedules.
- Evaluate delivery load options.
- Explain recommendations and compare alternatives.
- Ask for human approval before important changes.
- Verify results after approved changes.

## Development Rules
- Inspect the existing project before coding.
- Follow the existing technology stack.
- Use actual data and validated calculations.
- Never invent inventory, capacity, or delivery information.
- Build and test features one step at a time.
- Protect existing files and user data.
- Never expose API keys or passwords.

## Implementation Plan
1. Inspect the project.
2. Review the manufacturing data and existing features.
3. Build production, inventory, capacity, and delivery planning.
4. Connect an AI model (supporting OpenAI API, Anthropic, Gemini, and Built-in Deterministic Mode) and implement the agent.
5. Add human approval, data validation, failure handling, and controlled execution.
6. Test the complete system.

## Final Instruction
Build a practical AI planning assistant that identifies problems, evaluates feasible solutions, and supports human decision-making. Explain changes clearly and verify tests honestly.