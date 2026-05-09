# <plugin-display-name> hooks

This plugin does not need active hooks by default.

Add hooks only when automation cannot live inside a standalone skill and the behavior is deterministic enough to run cheaply.

## Hook rules

- Hooks must be opt-in and documented.
- Hooks must have a narrow trigger and clear completion signal.
- Hooks should fail with concise output.
- Hooks must not edit unrelated package files.
- Hooks must not duplicate standalone skill guidance.

## Candidate hook categories

- Documentation changed: run Markdown checks.
- Manifest changed: run repository validation.
- Package release: verify marketplace and metadata consistency.
