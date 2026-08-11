# Platform capability proposal

Use this when proposing a new Platform capability or provider adapter. It is a
design and evidence scaffold, not an approval.

## Identity

- Capability:
- Provider(s):
- Preset(s):
- Current status: `Supported` / `Experimental` / `Deferred`
- Owner:
- User-visible configuration:

## Contract

- What application behavior does the capability enable?
- What is the smallest provider-independent seam?
- What are the failure, timeout, cancellation, retry, and shutdown semantics?
- What security, data-classification, and secret requirements apply?
- What remains absent when the capability is not selected?

## Quality-gate profile

- [ ] Valid combinations are accepted and invalid combinations fail before
      generation.
- [ ] Presence tests cover projects, references, config, startup, health, and
      runtime behavior.
- [ ] Absence tests prove no residue remains.
- [ ] Failure and recovery paths are deterministic and observable.
- [ ] Provider-specific integration evidence exists.
- [ ] Performance/AOT claims name the exact profile.
- [ ] Migration and rollback/recovery evidence is documented.

## Decision

- Rejected combinations:
- Known limitations:
- Required Platform Migration:
- Handoff to:
- Source anchors:
