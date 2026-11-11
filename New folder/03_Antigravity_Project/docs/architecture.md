# Architecture

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
       (only if configured and implemented)
                 |
                 v
       Dashboard / response message
                 |
                 v
        Human planner review
                 |
                 v
       No unapproved operational change
```

This is one main agent using specialized tools. Confirm that the diagram matches the actual prototype before submission.
