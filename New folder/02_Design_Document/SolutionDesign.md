# Solution Design Document
## Manufacturing Planning Agent
**Course:** LIAI – Strategy and Change  
**Student:** Mary Chlouie Padios  
**Instructor:** Evandro Barros

## 4.1 Executive summary
Manufacturing planners need to review production orders, material inventory, and deadlines to understand whether a material shortage may affect a production commitment. When these details are checked manually, the planner may need to compare multiple records and contact other teams before deciding what to do. If a shortage is found late, the team may have less time to evaluate options and could face schedule disruption or late delivery. The actual cost and frequency of these problems should be measured during a pilot.

The proposed Manufacturing Planning Agent helps the production planner identify material shortages and potential production delays. It receives production orders, inventory records, and deadlines, uses defined checking tools to compare the information, and can use the OpenAI API to help explain findings and prepare recommendations. The results are shown on a dashboard or as a response message. The agent recommends actions but does not independently make important production changes. The planner remains responsible for reviewing the evidence and approving the next step.

The solution is intended to provide earlier visibility of production risks, more consistent checks, and clearer recommendations. A pilot should measure shortage-checking time, detection accuracy, and how often recommendations are useful to planners. These are proposed measures, not results already demonstrated. The prototype should be evaluated with sample cases before any live manufacturing data or operational system is connected.

## 4.2 Solution overview
### Goal
Identify material shortages and potential production delays, then recommend possible next steps so the production planner can make an informed decision.

### Scope
The proposed workflow:
- Starts when the user requests a production check or enters new manufacturing data.
- Reads production orders, inventory records, and deadlines.
- Checks whether available quantities meet material requirements.
- Flags possible material shortages and deadlines at risk.
- Uses the OpenAI API, when configured in the prototype, to help explain findings and generate recommendations.
- Displays the findings and recommendations on a dashboard or response message.
- Requests human review before important changes.

The agent does **not** independently change production schedules, update inventory, place purchase orders, or approve substitute materials. Delivery-load optimization is outside the initial scope and can be considered later if the core shortage-checking workflow proves useful.

### Main users
The main user is a production planner. Materials/inventory staff, production supervisors, purchasing, quality staff, and IT/security personnel may support validation and future implementation.

## 4.3 Agent roster — Agent Card
### Manufacturing Planning Agent
- **Name and role:** Manufacturing Planning Agent — identifies material shortages and potential production delays.
- **Goal:** Find production problems and recommend solutions to help avoid delays.
- **Input/trigger:** Triggered when a user requests a production check or enters new manufacturing data. Receives production orders, material inventory, and deadlines.
- **Tools and data:** Sample production data, inventory records, deadlines, data-validation and shortage-checking functions, and an OpenAI API tool for analyzing findings and drafting recommendations when configured.
- **Outputs:** Identified problems, shortage quantities, potential deadline risks, and recommendations displayed on the dashboard or in a response message to the production planner.
- **Autonomy level:** Level 2 — the agent analyzes data and proposes solutions, but requires human approval before important changes. It does not independently execute operational changes.
- **Failure handling:** If data is missing, incomplete, inconsistent, or unclear, the system alerts the user and asks for corrected information. If the AI recommendation is uncertain, it should label the uncertainty and ask the planner to verify. It must not make changes without approval.

## 4.4 Organization of the agent
This design uses **one main agent with specialized tools**, which is permitted by the assignment. The Manufacturing Planning Agent coordinates the workflow and uses tools for specific tasks rather than dividing the system into separate autonomous agents.

```text
User request / new manufacturing data
                 |
                 v
       Manufacturing Planning Agent
                 |
       +---------+----------+
       |         |          |
       v         v          v
 Data checks  Shortage    Deadline-risk
              checker       checker
       |         |          |
       +---------+----------+
                 |
                 v
       OpenAI API recommendation
       (if configured; grounded in data)
                 |
                 v
       Dashboard / response message
                 |
                 v
        Human planner review
       approve / reject / revise
                 |
                 v
       No unapproved operational change
```

The tools perform measurable checks, while the AI API can help turn the findings into a readable explanation and possible next steps. The model should not be treated as the source of truth for inventory counts or deadlines; those values must come from the supplied records. This design is simple and keeps the decision authority with the human planner.

## 4.5 Step-by-step workflow
1. The planner requests a production check or enters updated sample data.
2. The agent validates that the required order, inventory, and deadline fields are present.
3. The shortage-checking tool compares required material quantities with available inventory.
4. The deadline-risk tool identifies orders that may be affected by a shortage and displays the relevant deadline from the input data.
5. The agent assembles the findings and, if the OpenAI API is configured, asks it to explain the risk and suggest possible next steps using only the supplied facts.
6. The dashboard or response message displays the order, material, required quantity, available quantity, shortage quantity, deadline, and recommendations.
7. The planner reviews the information and approves, rejects, or revises the proposed next step.
8. The prototype does not modify production schedules, inventory, or purchase orders. A future implementation would require explicit permissions, audit logging, and approved integrations.

### Example
A production order requires 120 units of Connector-X and the sample inventory shows 75 units. The shortage checker calculates a shortage of 45 units. The agent flags the order for review and may recommend checking replenishment timing, confirming whether an approved substitute is available, or asking the planner to assess a schedule adjustment. The system must not claim a substitute is suitable unless an authorized source confirms it.

## 4.6 Tools, data and memory
### Data
- Production orders: order ID, product, material, required quantity, and deadline.
- Inventory records: material code and quantity available.
- Optional approved-substitute information, if the prototype includes it.
- User request that triggers a check.

### Tools
- Data validation: checks required fields and obvious inconsistencies.
- Shortage checker: calculates required quantity minus available quantity, with a minimum shortage of zero.
- Deadline-risk checker: associates a shortage with the order deadline for planner attention.
- OpenAI API: can help explain the findings and draft recommendations. It should receive only the information needed for the task.
- Dashboard/response output: presents the results to the planner.

### Memory and storage
For the prototype, the system may use sample data and session-level state. Do not claim long-term memory or persistent audit logs unless they are implemented. In a real deployment, the organization should define the source of truth, access permissions, data retention, and audit requirements. Model-generated recommendations must not replace inventory or order records.

### API and secrets
If the prototype uses the OpenAI API, the API key must be stored in an environment variable or a local `.env` file that is excluded from Git. Never include a real key in the ZIP, screenshots, prompts, or source code. Include a `.env.example` with placeholder values only. If the current prototype uses a different connection method, update this section to match the actual implementation.

## 4.7 Human-in-the-loop and guardrails
- Human approval is required before important operational changes.
- The agent must not automatically change schedules, inventory, or purchasing records.
- Inventory values, quantities, and deadlines should be visible so the planner can verify the result.
- Missing or unclear data should trigger a warning and request for correction.
- Recommendations should be clearly separated from verified facts.
- The agent must not invent approved substitute materials, supplier availability, or production capacity.
- Use only authorized data and limit access to what the agent needs.
- Keep API keys and passwords out of source control.
- For a production deployment, log the input data version, recommendation, human decision, and any action taken.
- Planners must be able to reject or override recommendations.

Key risks include inaccurate source data, incorrect AI-generated recommendations, privacy or security exposure, automation bias, and employee concern about changing responsibilities. A human approval step reduces the risk of unreviewed actions but does not guarantee that the recommendation is correct.

## 4.8 Evaluation
The following are proposed pilot targets. They are not measured outcomes from the prototype.

| KPI | How to measure | Proposed target |
|---|---|---|
| Time to identify a shortage | Median time from starting a check to seeing the result, compared with the current manual process | 30% lower than baseline |
| Shortage detection accuracy | Correct shortage findings divided by all verified test cases | At least 95% on a verified test set |
| Recommendation usefulness | Percentage of reviewed recommendations judged useful by planners | Track baseline; initial target 70% |
| Human approval compliance | Cases with human review before any important operational change | 100% |

### Test cases
1. Required quantity is greater than inventory: show the correct shortage.
2. Required quantity equals inventory: do not flag a shortage.
3. Inventory exceeds required quantity: do not flag a shortage.
4. Deadline exists and shortage is present: show the deadline alongside the risk.
5. Required data is missing: alert the user and request correction.
6. No approved substitute information is provided: do not invent a substitute.
7. The AI API is unavailable: show the data-based shortage finding if possible and explain that AI recommendations are unavailable.
8. Planner rejects a recommendation: no operational change is made.

Use a verified test set and record the number of cases. Results from a small classroom prototype should not be generalized to a factory without a larger pilot.

## 4.9 Organizational impact and change management
The agent may reduce time spent gathering and comparing information, allowing planners to focus on exceptions and coordination. Materials, purchasing, quality, and production teams may receive earlier requests to confirm replenishment, substitute suitability, or schedule implications. Their expertise remains important because the agent cannot independently determine all engineering, supplier, or operational constraints.

Adoption plan:
- Explain the problem being addressed and the limits of the agent.
- Involve planners in selecting test cases and reviewing recommendations.
- Train users with realistic sample orders and inventory shortages.
- Collect feedback about inaccurate or unhelpful recommendations.
- Assign a process owner to review performance and incidents.
- Review privacy, security, data quality, and employee impacts before connecting real systems.
- Scale only when the pilot shows reliable performance and users understand how to challenge the output.

The change should be framed as decision support for planners, not a replacement for manufacturing experience or accountability.

## 4.10 Prototype notes
The prototype is intended to demonstrate the Manufacturing Planning Agent workflow using the dashboard or response interface already built by the student. The documented workflow should match the actual prototype: request/check trigger, sample or entered production data, shortage/deadline analysis, AI-assisted recommendation where configured, displayed result, and human review.

Before submission, confirm which features are implemented. Do not claim a live OpenAI API connection if the prototype only simulates the response, and do not claim persistent memory, database integration, or automated schedule changes unless those features work. Add genuine screenshots of the running prototype to the presentation and `evidence/` folder. The prototype is an educational demonstration, not a production-ready manufacturing system.

## Appendix A — AI Use Statement
AI assistance was used to help organize the assignment, refine the written explanation, and prepare a structure for the presentation and design document. The student remains responsible for reviewing the content, testing the prototype, checking that every description matches the actual implementation, and following Georgian College's academic-integrity requirements. List any other AI tools used during development accurately before submission.

## References
OpenAI. (n.d.). *Responses API reference*. OpenAI Platform. https://developers.openai.com/api/reference/responses/overview
