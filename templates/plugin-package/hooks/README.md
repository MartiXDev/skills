# Plugin Display Name hooks

This plugin does not need hooks by default.

Add hooks only when deterministic plugin-level automation is required.

When hooks are needed, prefer an event-keyed `version: 1` hook configuration.
Keep the executable script in `hooks\`, document a check-only mode when the
script can modify files, and keep output concise enough for CI logs.
