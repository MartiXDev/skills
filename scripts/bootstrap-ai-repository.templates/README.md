# AI repository bootstrap templates

The bootstrap script reads this directory. No generated file body is embedded in the PowerShell orchestrator.

## Layers

- `base/`: files used by every profile.
- `profiles/standard/`: vendor adapters added by the Standard and Full profiles.
- `profiles/full/`: eval, telemetry, schema and hook structure added by Full.
- `technologies/<name>/`: files or fragments selected by `-Technology`.
- `combinations/<name>/`: variants for explicit technology combinations.

`manifest.json` declares profile layers, supported technologies and combination matching. `manifest.schema.json` documents and validates its versioned structure.

## File operations

A normal template file replaces the same relative destination path. The highest-priority selected layer wins. Two replacement files at the same highest priority are rejected as ambiguous.

Fragments avoid duplicating complete text files:

- `AGENTS.md.append` appends its content to generated `AGENTS.md`.
- `AGENTS.md.prepend` prepends its content.

Fragments are applied in ascending layer priority after selecting the replacement template. This works best for Markdown and other line-oriented text. Use a complete technology or combination variant for structured JSON/YAML files.

## Adding a technology

1. Add its entry to `technologyLayers` in `manifest.json`.
2. Create `technologies/<name>/` with only files that differ from the base.
3. Prefer fragments for additive Markdown guidance.
4. Add a complete structured-file variant when merging would not be unambiguous.
5. If two technologies replace the same target, add a matching combination layer.
6. Test `-WhatIf`, actual generation, idempotence and `-Force` before publishing.
