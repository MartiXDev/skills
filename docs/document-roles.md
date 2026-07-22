# Document roles and archive policy

<!--
role: normative
verified: 2026-07-22
-->

This document defines the canonical roles for maintainer documentation, the
archive location policy, role metadata, and the research snapshot lifecycle.

## Canonical document roles

Every new or materially edited maintainer document should declare one of these
roles:

### normative

Mandatory rules and contracts that must be followed. Normative documents define
what is required, prohibited, or guaranteed.

**Examples:** Custom AI artifact rules, canonical eval schema, repository
glossary, coding standards.

**Ownership:** Changes require repository coordinator review.

**Freshness:** Keep current. Mark stale normative claims as defects.

### operational

Procedures, playbooks, and how-to guides that describe recommended workflows.
Operational documents tell you how to perform a task correctly.

**Examples:** Validation commands, Git workflow checklists, model evaluation
playbook, package installation guides.

**Ownership:** May be updated by domain maintainers following repository
contracts.

**Freshness:** Keep current. Update when procedures change.

### reference

Supporting maps, catalogs, recipes, indexes, and anti-patterns that provide
quick lookup information. Reference documents collect facts for efficient
retrieval.

**Examples:** Package catalogs, library indexes, taxonomy maps, section order,
default rule profiles, integration maps.

**Ownership:** May be generated or updated by domain maintainers.

**Freshness:** Keep synchronized with source systems. Regenerate when upstream
changes.

### research

Dated evidence records, investigation notes, and analysis snapshots. Research
documents preserve findings at a point in time.

**Examples:** AI ecosystem reviews, model comparisons, workflow evaluations,
domain-specific investigation notes.

**Ownership:** Immutable after initial review except for labeled errata.

**Freshness:** Treat age as context, not defect. Trigger new snapshots on major
upstream changes or after six months.

### roadmap

Proposed plans, specifications, and future direction. Roadmap documents describe
intended work that has not yet been implemented.

**Examples:** Improvement plans, feature specifications, architecture proposals,
integration roadmaps.

**Ownership:** May be updated by proposal authors and domain maintainers.

**Freshness:** Archive when implementation completes or proposal is abandoned.

### historical

Superseded records retained for context. Historical documents are no longer
active guidance but preserve decisions and rationale.

**Examples:** Completed plans, retired specifications, deprecated procedures.

**Ownership:** Immutable. Do not update historical documents; create new ones.

**Freshness:** Age is inherent. Do not mark historical documents as stale.

## Archive policy

**Archive is a location, not a document role.**

Active documents belong in the main `docs/` tree and are linked from active
indexes. Historical documents belong in `docs/archive/` and are linked from
archive indexes.

Archive location rules:

- Move confirmed superseded repository-wide plans to `docs/archive/plans/`.
- Move retired specifications to `docs/archive/specs/`.
- Move deprecated procedures to `docs/archive/procedures/`.
- Keep package-local research in place until the owning package is deliberately
  migrated.
- Update all inbound active links when moving a document to the archive.
- Add an archive index (`docs/archive/README.md`) that lists historical
  documents by category with context about why they were superseded.

Active indexes (`docs/README.md`, package READMEs) must not present archived
material as current guidance.

## Role metadata

New or materially edited maintainer documents should include role and freshness
metadata near the top of the file:

```markdown
<!--
role: normative|operational|reference|research|roadmap|historical
verified: YYYY-MM-DD
-->
```

For research snapshots, use the date in the filename and omit `verified`:

```markdown
<!--
role: research
snapshot: YYYY-MM-DD
-->
```

For historical documents, include the superseded date:

```markdown
<!--
role: historical
superseded: YYYY-MM-DD
reason: Brief explanation of why this was superseded
-->
```

Metadata placement:

- Place metadata after the title and before the first content section.
- Use HTML comments to avoid rendering in most Markdown viewers.
- Do not force incompatible front matter into consumer-sensitive files (e.g.,
  skill package docs that are part of the published package).

Adoption is incremental: existing documents without metadata remain valid until
materially edited.

## Research snapshot lifecycle

Research snapshots are immutable dated evidence records. They follow a
specialized lifecycle:

### Immutability

After initial review and merge, research snapshots accept only:

- **Labeled errata:** Clearly marked corrections to factual errors, broken
  links, or citation mistakes. Errata must be labeled with a correction note
  that preserves the original text.
- **No silent rewrites:** Do not update conclusions, add new findings, or remove
  outdated claims. New findings belong in a new snapshot.

Errata format:

```markdown
**Errata (YYYY-MM-DD):** [Correction description]. ~~Original text~~
Corrected text.
```

### Review triggers

Create a new research snapshot when:

1. **Major upstream change:** A significant model, platform, or ecosystem shift
   makes the baseline evidence outdated.
2. **Six-month backstop:** If no major change occurs, refresh the research
   within six months to prevent indefinite staleness.
3. **Explicit request:** A maintainer or user requests an updated evidence
   baseline.

Do not create a new snapshot for minor version bumps or routine package updates
unless they materially affect the research conclusions.

### Snapshot linking

Research snapshots may reference:

- **Predecessor snapshots:** Link to the previous research on the same topic to
  show evolution.
- **Successor snapshots:** When a new snapshot supersedes an older one, add a
  note at the top of the older snapshot pointing to the newer one.

Example successor note:

```markdown
> **Superseded:** This snapshot has been superseded by
> [YYYY-MM-DD snapshot](./YYYY-MM-DD-topic.md). Retained for historical
> context.
```

### Naming convention

Use the ISO date prefix for research snapshots:

- `YYYY-MM-DD-topic-description.md`
- Example: `2026-07-22-ai-agent-ecosystem-and-documentation-review.md`

## Validation

The repository completion signal should:

- Reject new or materially edited maintainer documents in `docs/` that lack role
  metadata (incremental adoption; warn only for existing documents).
- Reject active indexes that link to archived documents without "archived" or
  "historical" context.
- Reject archived documents that are still linked from active guidance as
  current.
- Warn when research snapshots older than six months have no successor and no
  documented reason for the delay.

## Migration guidance

To adopt this policy:

1. **Add metadata incrementally:** Add role metadata when editing a document,
   not in one big-bang rewrite.
2. **Archive completed plans:** Identify confirmed superseded repository-wide
   plans and move them to `docs/archive/plans/`.
3. **Update indexes:** Ensure `docs/README.md` routes only to active guidance.
4. **Create archive index:** Add `docs/archive/README.md` to list historical
   documents with context.
5. **Preserve package research:** Do not move package-local research until the
   owning package is deliberately migrated.
