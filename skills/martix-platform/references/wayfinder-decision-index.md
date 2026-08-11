# Wayfinder decision index

Wayfinder files are approved design provenance, not the active tracker. Open
the current Platform source and manifest first.

| Concern | Target source |
| --- | --- |
| Platform direction and package topology | `docs\wayfinder\martix-platform\platform-blueprint.md` |
| Implementation sequence and acceptance paths | `docs\wayfinder\martix-platform\migration-roadmap.md` |
| Integration-event leasing and recovery | `tickets\109-integration-event-delivery.md` |
| Identity provider seams | `tickets\005-identity-seams-and-providers.md` |
| Security and observability baseline | `tickets\111-security-observability-baseline.md` |
| Generated-solution lifecycle | `tickets\016-generated-solution-lifecycle.md` |
| Release and migration policy | `tickets\114-release-migration-policy.md` |

When a ticket describes a target API that is absent from source, route the task
to a design or Platform Migration instead of writing code that assumes it exists.
