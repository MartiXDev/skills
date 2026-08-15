# Prompts

Prompt assets use `/martix-git` as their canonical namespace. Each prompt
inspects state, classifies phases, delegates deterministic operations, and
reports the final observed result. `/martix-git pr` uses
`hooks/plan-pr-workflow.ps1` as its read-only coordinator before invoking the
atomic branch, stage, commit, push, and PR adapters.
