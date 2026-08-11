# Skill Benchmark: martix-platform

**Model**: task-agent default (unspecified)
**Date**: 2026-08-08T22:08:55Z
**Evals**: 7 evals (1 run each per configuration)

## Summary

| Metric | With Skill | Without Skill | Delta |
|--------|------------|---------------|-------|
| Pass Rate | 100% | 58% | +0.42 |
| Time | unavailable | unavailable | n/a |
| Tokens | unavailable | unavailable | n/a |

## Analyst observations

- With-skill runs passed all 35 assertions; without-skill runs passed 20 of 35 (58.1%).
- Reliable-event, capability-admission, and security evals passed identically in both configurations, so those assertion sets are not strongly discriminating.
- Timing and token telemetry was unavailable for these task-agent runs; benchmark values are not resource comparisons.
- Each configuration has one run per eval, so there is no variance estimate; treat this as a directional first iteration.
- The clearest gains are in Platform-specific authority, generated topology, migration-command, current-versus-target, and companion-handoff details.
