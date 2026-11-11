# Manufacturing Planning Agent

## Purpose
This project supports a production planner by checking manufacturing data for material shortages and potential production delays, then displaying findings and recommendations.

## Expected workflow
1. User requests a production check or enters new manufacturing data.
2. The agent validates production orders, inventory records and deadlines.
3. Specialized checks identify material shortages and deadline risks.
4. If the OpenAI API connection is implemented and configured, it helps explain the findings and draft recommendations.
5. Results are shown in the dashboard or response message.
6. The planner reviews the recommendation. Important operational changes are not made without approval.

## Run and test
Use the actual run/test commands for your Antigravity project here and verify them before submission. Do not leave commands that do not work in your environment.

## Environment variables and API key
If the prototype uses the OpenAI API, store the key in a local environment variable or `.env` file. Do not commit `.env`, paste the key into screenshots, or include it in the ZIP. `.env.example` should contain placeholders only. If your current prototype does not use a live API call, state that clearly.

## Evidence
Place genuine screenshots or a short screen recording (maximum 3 minutes) in `evidence/`. Capture the actual working prototype showing input data, detected issue, recommendation and human review if available.

## Limitations
Describe the current implementation accurately. Do not claim real ERP/MRP integration, persistent memory, automatic schedule changes or live API connectivity unless those features have been tested and implemented.
