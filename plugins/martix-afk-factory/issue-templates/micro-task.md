---
name: "Micro-task (AFK)"
about: "Atomic task suitable for autonomous agent execution. Fill ALL fields before saving — the triage workflow validates them."
labels: ""
assignees: ""
---

## Title

<!-- One-line task title. Must match the issue title above. -->

## Acceptance criteria

<!-- Maximum 3 bullets. Each must be independently verifiable. -->

-
-
-

## Relevant file paths

<!-- Maximum 3 paths. List only the files the agent must read or modify. -->

-
-
-

## Labels required

Add **both** a tier label and an area label before saving this issue.
The triage workflow adds `afk/ready` when both are present.

| Group | Options |
|---|---|
| Tier | `tier/cheap` · `tier/medium` · `tier/premium` |
| Area | `area/backend` · `area/frontend` · `area/test` · `area/docs` · `area/ops` |

<!-- agent-prompt
REPLACE THIS BLOCK with a concise prompt for the agent.
Line 1: task title (matches issue title).
Lines 2-4: acceptance criteria, one per line.
Lines 5-7: relevant file paths, one per line.
Keep the total under 400 characters. This block is extracted verbatim by the dispatch workflow.
-->
