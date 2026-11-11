# AGENTS.md — Manufacturing Planning Agent

## Purpose and scope
This project supports manufacturing planners by identifying material shortages and potential production delays from production orders, inventory records and deadlines. It displays findings and recommendations on the existing dashboard or response interface. It must not make important operational changes without human approval.

## Agent and tools
- **Manufacturing Planning Agent**: coordinates the workflow; validates inputs, uses shortage and deadline-risk checks, and prepares recommendations.
- **Data validation tool**: checks required fields and flags missing/unclear values.
- **Shortage checker**: compares required material quantities with available inventory.
- **Deadline-risk checker**: links identified shortages to the order deadline for planner attention.
- **OpenAI API tool**: when configured and implemented, helps explain findings and draft recommendations based on supplied data. It is not the source of truth for inventory or deadlines.

## Coordination
One main agent uses specialized tools in a sequence: request/data -> validation -> shortage and deadline checks -> AI-assisted explanation/recommendations (if configured) -> dashboard/response -> human review. Human approval is required before important changes.

## Tech stack and conventions
Keep these details consistent with the actual Antigravity implementation. Document the language, framework, folders and commands used by the prototype. Do not claim a technology is implemented unless it is present in the code.

## Commands
Use the run and test commands documented in README.md and verify them in the actual project before submission.

## Guardrails
- Never automatically change production schedules, inventory or purchase orders.
- Never invent approved substitute materials or supplier availability.
- Ask the user to correct missing, incomplete or unclear data.
- Keep API keys and passwords out of source control. Use environment variables or a local `.env` ignored by Git.
- Keep only placeholder values in `.env.example`.
- Show recommendations as suggestions, not verified facts.
- Human planner retains decision authority.
