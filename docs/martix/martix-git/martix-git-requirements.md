# MartiX Git Requirements

<!-- markdownlint-disable MD013 MD032 MD060 -->

> Requirements date: 2026-08-14
>
> Status: Phase 1 requirements baseline; implementation is explicitly deferred
> to Phase 2
>
> Requested package names: `skills/martix-git` and
> `plugins/martix-git-automation`

## 1. Purpose

This document defines the requirements for a reusable MartiX Git skill and an
optional automation plugin that together support a safe GitHub development
lifecycle:

```text
intent -> branch/worktree -> staged change -> commit -> pull request
       -> protected merge -> release evidence -> remote/local cleanup
```

The solution must combine reusable domain guidance with deterministic
automation. It must make the distinction between Git state, GitHub state,
client lifecycle state, and model-generated suggestions explicit. It must
support human review at every state-changing boundary and make cleanup
report-first by default.

This is a requirements document, not an implementation plan disguised as code.
No package, script, hook, workflow, manifest, eval file, or marketplace entry
is created by this phase.

### 1.1 Requirement language

- **MUST** identifies a release-blocking requirement.
- **SHOULD** identifies the default design that may be changed only with a
  documented reason.
- **MAY** identifies an optional capability.
- **Phase 2** means the later implementation phase, not the current task.

## 2. Decision summary

### 2.1 Package boundary

The solution consists of two related but independently understandable
artifacts:

| Artifact | Required name | Responsibility |
| --- | --- | --- |
| Standalone skill | `skills/martix-git` | Reusable Git, GitHub, Conventional Commits, Conventional Branch, SemVer, release, hook, and worktree knowledge. |
| Automation plugin | `plugins/martix-git-automation` | User-invoked prompts, deterministic adapters, native-hook and CI templates, lifecycle reporting, and optional runtime-specific hooks. |

The standalone skill is the source of reusable domain knowledge. The plugin
must not silently copy a second rule library into `plugins/martix-git-automation`.
The plugin may reference or compose with the skill, but no undocumented plugin
manifest dependency mechanism may be assumed.

### 2.2 Naming conflict resolution

The earlier plan proposed `skills/martix-conventional-commit` and
`plugins/martix-git`. The current user request selects the broader names above.
Those earlier names are treated as superseded alternatives for this work, not
as aliases, extra packages, or implementation targets. The implementation must
use exactly one standalone skill named `martix-git` and one automation plugin
named `martix-git-automation` unless a later decision record changes this
document.

The naming decision does not change the artifact boundary: reusable knowledge
remains standalone, and lifecycle automation remains plugin-scoped. `[RES-1]
[PLAN-1] [REPO-1]`

### 2.3 Conservative defaults

The default behavior must be:

- read-only for worktree and branch cleanup;
- no `--force`, `reset --hard`, or `clean -fd` operations;
- no network query unless remote evidence is explicitly enabled;
- no commit, branch creation, pull-request creation, hook installation, or
  deletion without an explicit user confirmation at the relevant prompt;
- fail-open for advisory lifecycle reporting and unknown ownership;
- fail-closed for configured commit/branch validation and required CI checks.

These defaults follow the documented distinction between reusable skill
guidance, plugin automation, native Git enforcement, and high-risk worktree
mutation. `[RES-1] [PLAN-1]`

## 3. Inputs and authority

### 3.1 Local inputs

The requirements are derived from:

1. [MartiX Git research resources](./martix-git-research-resources.md), the
   original user brief and requested source list.
2. [MartiX Git research snapshot](./martix-git-research.md), the dated
   primary-source synthesis and source map.
3. [martix-git Plugin Plan](../../knowledge/repository/research/git-worktree-workflows/martix-git-plugin-plan.md), the earlier implementation-ready
   proposal and lifecycle observations.
4. [Repository knowledge](../../knowledge/repository/knowledge.md), which
   defines standalone skill and plugin ownership.
5. [Custom AI artifact rules](../../policy/custom-ai-artifact-rules.md), which
   defines package contracts, progressive disclosure, and evaluation rules.
6. [Existing cleanup engine](../../../scripts/git-cleanup.ps1), which is local
   implementation evidence and the reference behavior for safe cleanup.

### 3.2 Authority order

When sources disagree, apply this order:

1. Git, GitHub, Conventional Commits, Conventional Branch, SemVer, and
   semantic-release specifications or official documentation own the behavior
   they define.
2. Repository policy owns MartiX package layout, validation, and ownership
   decisions.
3. This document owns the product requirements and explicit defaults for the
   two proposed packages.
4. The model may recommend a choice, but it must not present a recommendation
   as a source requirement.

The implementation must preserve source ownership labels such as
`requirement`, `implementation evidence`, `recommendation`, `inference`, and
`gap` when converting this document into skill rules or plugin documentation.

## 4. Product boundary

### 4.1 In scope

The solution must cover these capability modules:

| Module | Skill | Plugin | Initial delivery |
| --- | --- | --- | --- |
| Conventional commit guidance and validation policy | Rules, examples, routing | `/martix-git commit` prompt and validation adapters | Phase 2, iteration 1 |
| Conventional branch naming | Rules and source map | `/martix-git branch` prompt and Git validation | Phase 2, iteration 1 |
| Git workflow practice | Rules and command guidance | Session instructions and prompt orchestration | Phase 2, iteration 1 |
| Native local quality gates | Hook guidance | Setup prompt and hook templates | Phase 2, iteration 2 |
| Pull requests and issue linking | Rules and templates | `/martix-git pr` prompt and `gh` adapter | Phase 2, iteration 2 |
| SemVer and semantic-release | Release rules and decision map | Optional release policy and verify-then-release templates | Phase 2, iteration 2 or later |
| Worktree lifecycle | State model and safety rules | Audit/report adapter and explicit cleanup path | Phase 2, iteration 3 |
| GitHub lifecycle evidence | Rules and event matrix | Optional `gh` queries and remote notification workflow | Phase 2, iteration 3 |
| Copilot runtime guardrails | Safety guidance | Optional runtime-specific hook | Phase 2, iteration 4, only after validation |

### 4.2 Explicit non-goals

The packages must not:

- replace Git, `gh`, GitHub, Sandcastle, Husky, lint-staged, commitlint, or
  repository CI tooling;
- reimplement Git reference, commit, merge, worktree, or hook semantics;
- manage Sandcastle sessions, sandboxes, or worktree ownership without an
  explicit adapter contract;
- become a general CI/CD, deployment, release-publishing, or multi-repository
  orchestration product;
- provide an interactive rebase interface;
- infer ownership from a directory name, branch prefix, open editor, process,
  session age, or heuristic alone;
- delete worktrees, local branches, orphan directories, remote branches, tags,
  or objects based only on age or a generic agent stop event;
- expose wrappers for `git reset --hard`, `git clean -fd`, or unattended force
  deletion;
- copy the text of third-party skills or claim that a third-party action is an
  official standard;
- publish a release from pull-request validation or an unprotected branch.

## 5. Users and operating contexts

### 5.1 Primary users

| User | Need | Safety concern |
| --- | --- | --- |
| Developer | Create a branch, commit staged work, and open a reviewed PR quickly. | Accidental mutation, malformed messages, shell interpolation, lost changes. |
| Maintainer | Enforce repository policy across clients and review release/cleanup evidence. | Local hooks can be bypassed; server policy must remain authoritative. |
| CI operator | Run deterministic commit, branch, release, and merge checks. | Untrusted PR code, credentials, ambiguous merge history. |
| Repository owner | Audit stale worktrees and reconcile external client cleanup. | Dirty, locked, active, externally owned, or unknown state must remain untouched. |

### 5.2 Supported client boundary

The design must distinguish capabilities by client:

- Native Git hooks must work for terminal, VS Code, Copilot CLI, Sandcastle,
  GUI, and CI-created commits when installed in the repository.
- Copilot CLI plugin prompts and hooks are plugin-specific and must not be
  described as universal Git enforcement.
- VS Code agent hooks are preview/runtime-specific. They may be documented and
  tested later, but the plugin must not ship an unverified configuration as a
  supported contract.
- Claude Code may be documented as an external compatibility target, but it is
  not a primary runtime requirement.

## 6. Standalone skill requirements: `skills/martix-git`

### 6.1 Package contract

The standalone skill MUST be independently installable and discoverable. Its
implementation MUST contain the repository-required package surfaces:

```text
skills/martix-git/
├── plugin.json
├── metadata.json
├── README.md
├── SKILL.md
├── AGENTS.md
├── LICENSE.txt
├── rules/
├── references/
├── templates/
├── assets/
│   ├── taxonomy.json
│   └── section-order.json
└── evals/
    └── evals.json
```

The implementation MUST keep reusable domain knowledge in this package and
MUST keep `SKILL.md` as a compact routing entrypoint. `SKILL.md` SHOULD remain
under 500 lines and MUST route to the smallest relevant rule or reference file.
The package identity MUST remain synchronized across `plugin.json`,
`metadata.json`, `README.md`, marketplace metadata, and release notes when
those surfaces are later added. `[REPO-1] [ART-1]`

### 6.2 Activation and routing

#### 6.2.1 Canonical command namespace

The skill and automation plugin MUST use `/martix-git` as the canonical
command namespace. The command grammar MUST be:

```text
/martix-git [workflow] [action] [options]
```

The command family MUST include these canonical entrypoints:

| Command | Classification | Required behavior |
| --- | --- | --- |
| `/martix-git` | Smart entrypoint | Inspect the request and repository, infer the smallest appropriate workflow, build a state-based plan, and execute only confirmed actions. |
| `/martix-git status` | Atomic, read-only | Report repository, branch, worktree, staged/unstaged, upstream, PR, and relevant policy state. |
| `/martix-git branch` | Smart branch workflow | Propose and, after confirmation, create or switch to the needed topic branch/worktree. |
| `/martix-git branch propose` | Atomic, read-only | Generate and validate a branch candidate without creating or switching. |
| `/martix-git branch create` | Atomic mutation | Create the confirmed branch or worktree after all branch and ref checks pass. |
| `/martix-git branch pr` | Composed workflow | Run the branch-to-PR planner: inspect branch, stage, commit, push, and PR prerequisites, then perform only the steps that are necessary and confirmed. |
| `/martix-git stage` | Smart staging workflow | Inspect staged and unstaged changes, propose an explicit path set, and stage only after confirmation. |
| `/martix-git stage add` | Atomic mutation | Stage only the explicitly supplied paths or approved hunks; never stage the entire worktree implicitly. |
| `/martix-git commit` | Smart commit workflow | Inspect staged work, draft a message, and create a commit only when staged changes require one and the user confirms. |
| `/martix-git commit propose` | Atomic, read-only | Draft and validate a commit message from the staged diff without committing. |
| `/martix-git commit create` | Atomic mutation | Create one reviewed commit from the current staged diff using a temporary message file and native hooks. |
| `/martix-git push` | Smart push workflow | Inspect upstream and divergence, then push only when the remote does not already contain the required commits. |
| `/martix-git push plan` | Atomic, read-only | Report whether a push is needed, blocked, or unnecessary. |
| `/martix-git push publish` | Atomic mutation | Push to the confirmed remote/ref, set upstream when needed, and never force-push by default. |
| `/martix-git pr` | Smart PR workflow | Run the full PR preflight, including optional branch, stage, commit, and push steps, then create or report the PR. |
| `/martix-git pr plan` | Atomic, read-only | Produce the full PR plan and classify every prerequisite as perform, skip, ask, or block. |
| `/martix-git pr create` | Atomic mutation | Create a reviewed draft or ready PR after the current branch is valid, pushed, and no duplicate open PR exists. |
| `/martix-git pr view` | Atomic, read-only | Report the existing PR and its current head/base, draft, checks, and issue-link state. |
| `/martix-git policy setup` | Smart setup workflow | Inspect existing hooks and CI, then propose repository policy changes without overwriting existing configuration. |
| `/martix-git worktree audit` | Atomic, read-only | Produce the safe worktree and branch lifecycle report. |
| `/martix-git worktree apply` | Atomic mutation | Apply only explicitly selected, revalidated, safe cleanup candidates. |
| `/martix-git release plan` | Atomic, read-only | Calculate and explain release prerequisites and release impact without publishing. |
| `/martix-git release publish` | Atomic mutation | Publish only from an approved protected release context after verification and confirmation. |

The names `/branch`, `/commit`, `/pr`, `/setup-git-policy`, and
`/audit-worktrees` MAY remain compatibility aliases, but all new documentation,
examples, prompts, and evaluations MUST use the `/martix-git` namespace.

The no-argument `/martix-git` command MUST be a smart entrypoint, not an alias
for a fixed branch, commit, or PR operation. It MUST:

1. inspect the user's explicit request and the smallest relevant repository
  state;
2. map the request to one primary workflow, such as branch, commit, PR,
  policy, worktree, or release;
3. build a state-based plan before any mutation;
4. classify each possible step as `perform`, `skip`, `ask`, or `block`;
5. present the plan, commands, assumptions, and expected effects;
6. obtain confirmation before each state-changing step or an explicitly
  grouped confirmation covering the displayed steps;
7. re-read state after every mutation and recompute later steps;
8. report completed, skipped, blocked, and unresolved steps separately.

When the request has no actionable intent, `/martix-git` MUST perform a
read-only status inspection and ask one focused question. It MUST NOT infer a
desire to create a branch, stage files, commit, push, open a PR, publish, or
clean up merely from the presence of a dirty worktree.

The smart planner MUST use repository evidence and explicit user intent in this
order:

1. explicit user constraints and requested target;
2. current Git/GitHub state;
3. configured repository policy;
4. safe defaults and conservative refusal.

The planner MUST not turn a skipped step into a required step merely because a
composed workflow contains that step. A PR request may result in only a report
of an existing PR, or in a branch, stage, commit, push, and PR sequence, based
on the observed state.

Supported common options SHOULD include `--dry-run` or `--plan`, `--base`,
`--remote`, `--branch`, `--issue`, `--type`, `--scope`, `--worktree`,
`--paths`, `--draft`, and `--body-file`. Options MUST be passed as structured
arguments and MUST NOT weaken confirmation, validation, ownership, or
revalidation requirements.

The skill description MUST trigger for substantive requests involving any of
the following, even when the user does not name the skill:

- Conventional Commit messages or commit-message review;
- Conventional Branch or policy-based branch naming;
- Git branch and worktree workflow decisions;
- GitHub pull-request drafting, creation, merge policy, or issue linking;
- SemVer, release impact, changelog policy, or semantic-release setup;
- Git hooks, commitlint, lint-staged, pre-commit, commit-msg, or pre-push
  policy;
- worktree audit, stale branch reconciliation, post-merge cleanup, or local
  versus remote cleanup.

Natural-language requests such as "create a PR", "open a pull request", or
"prepare this change for review" MUST route to the `/martix-git pr` smart
workflow even when the user does not type the command. A request containing
only "PR" is insufficient intent for mutation; the skill MUST inspect state and
ask for the intended PR goal when the surrounding request does not establish
one.

The skill SHOULD NOT trigger for generic application version parsing, unrelated
file deletion, general CI/CD design, or Git operations with no policy,
workflow, GitHub, release, hook, or worktree concern.

The routing rules MUST include near-miss guidance so the model does not invoke
the skill merely because a prompt contains the word `commit`, `branch`, or
`release` in an unrelated domain.

### 6.3 Normative domain rules

The skill MUST provide source-backed rules for the following topics.

#### 6.3.1 Conventional Commits

The skill MUST:

- treat Conventional Commits 1.0.0 as a commit-message specification, not a
  branch-name, pull-request, hook, or release-tool specification;
- describe the structural form
  `<type>[optional scope]: <description>`, optional body, and optional footers;
- preserve the defined meanings of `feat` and `fix`;
- support optional scopes, valid footer/trailer content, `!` breaking-change
  notation, and `BREAKING CHANGE:` or `BREAKING-CHANGE:` footer semantics;
- state that the specification permits additional types and does not define a
  MartiX-specific allow-list, imperative style, scope list, or header length;
- distinguish a source requirement from a repository policy when recommending
  types, scopes, subject style, or maximum length;
- explain that a Conventional Commit may inform release automation without
  implying that every valid commit must produce a release;
- preserve valid footers and avoid rewriting user-authored commit metadata;
- provide examples for valid messages, breaking changes, body content, and
  multiple footers, plus invalid examples with precise explanations.

The skill MUST NOT describe a PR body as one Conventional Commit or require a
branch name to match the commit parser.

#### 6.3.2 Conventional Branch and Git ref safety

The skill MUST:

- treat Conventional Branch as a separate specification from Conventional
  Commits;
- use a pinned, versioned Conventional Branch specification, initially
  `v1.1.0`, rather than an unversioned latest endpoint;
- recommend the `<type>/<description>` branch form and explain trunk branch
  exceptions and configured aliases;
- validate the generated name independently with
  `git check-ref-format --branch`;
- state that aligning `feature/` with `feat:` is a workflow convention, not a
  cross-specification requirement;
- never create or switch to a trunk branch when a topic branch is intended;
- reject invalid, ambiguous, control-character, whitespace, or policy-disallowed
  names before mutation.

The exact accepted prefix list, lowercase policy, description length, and issue
identifier format MUST be configurable. They MUST NOT be presented as universal
Conventional Branch requirements.

#### 6.3.3 Git workflow practice

The skill MUST recommend:

- small logical changes that can be reviewed and tested independently;
- one topic branch per nontrivial feature or bug fix;
- inspection of status, staged diff, branch, upstream, and recent history before
  suggesting a mutation;
- native `git switch -c` or `git worktree add -b` for branch/worktree creation;
- argument-based command invocation without shell interpolation of branch names,
  messages, issue titles, or PR text;
- temporary message files for commit bodies and footers;
- explicit review before commit, PR creation, merge, release, or cleanup;
- clear distinction between local branches, remote-tracking refs, remote
  branches, tags, and unreachable objects.

#### 6.3.4 Pull requests and issues

The skill MUST:

- treat a PR title, body, head, and base as separate GitHub fields;
- explain that GitHub may use a PR title or body to construct a merge or squash
  commit according to repository settings;
- make Conventional Commit-shaped PR titles a configurable repository policy,
  required only when the selected merge policy makes the title release-significant
  or when the repository explicitly chooses that policy;
- keep PR bodies focused on summary, motivation, implementation, tests, risk,
  migration/breaking-change notes, and issue references;
- distinguish non-closing references such as `Refs #123` from closing keywords
  such as `Fixes #123` and `Closes #123`;
- explain default-branch limitations and cross-repository issue reference syntax;
- use structured GitHub CLI/API fields rather than scraping rendered PR text;
- recommend draft PRs and human review before creation when the workflow permits;
- never insert a closing keyword merely to make a PR look complete.

#### 6.3.5 SemVer and semantic-release

The skill MUST:

- treat SemVer 2.0.0 as the version syntax and precedence contract;
- explain normal, pre-release, and build metadata rules and the immutability of
  released versions;
- keep Git tag spelling such as `v1.2.3` separate from the SemVer value `1.2.3`;
- explain that semantic-release defaults to Angular commit conventions and that
  a Conventional Commits preset or custom release rules must be explicitly
  configured;
- describe the verify, last-release, commit-analysis, notes, version, tag,
  publish, and notification pipeline;
- require protected release branches, full history where needed, dry-run support,
  least-privilege credentials, and no publishing from PR validation;
- treat semantic-release as an optional integration profile, not a mandatory
  dependency for every repository using the skill;
- distinguish release impact policy from message validity and from branch naming.

#### 6.3.6 Hooks and quality gates

The skill MUST explain the roles and limits of:

| Boundary | Required guidance |
| --- | --- |
| `commit-msg` | Validate the proposed commit message and preserve trailers. |
| `pre-commit` | Run bounded staged-file linting, formatting, secret checks, or cheap targeted tests. |
| `pre-push` | Optionally run bounded verification before publishing refs. |
| CI | Repeat required checks because local hooks can be missing, changed, or bypassed with `--no-verify`. |
| GitHub protection/rulesets | Enforce checks and branch policy that must not be bypassed locally. |
| Agent/plugin hooks | Provide client-specific guardrails only; never claim universal Git coverage. |

The skill MUST recommend existing repository tooling before introducing a new
validator and MUST label commitlint, Husky, lint-staged, and third-party GitHub
Actions as implementation options rather than owners of the Conventional
Commits specification.

#### 6.3.7 Worktrees and cleanup

The skill MUST define a state model that distinguishes:

- main, current, protected, active, dirty, locked, detached, missing/prunable,
  externally owned, unknown, and clean eligible worktrees;
- local branch tips and remote branch state;
- ancestry evidence and GitHub merged-PR evidence;
- a removed worktree registration and the local branch that may remain after it;
- registered worktrees and unregistered directories under explicitly configured
  scan roots.

The skill MUST require:

- `git worktree list --porcelain -z` or an equivalent NUL-safe inventory;
- audit before apply;
- revalidation immediately before each mutation;
- no mutation for dirty, locked, current, main, detached/unverifiable,
  protected, active, externally owned, unknown, open-PR, or ambiguous-merge
  states;
- no force removal by default;
- explicit operator confirmation for worktree or branch deletion;
- separate handling of `git fetch --prune`, worktree metadata pruning, and
  object garbage collection;
- local cleanup ownership for local branches/worktrees and remote workflow
  ownership for remote branches/PR state;
- use of the existing [git-cleanup.ps1](../../../scripts/git-cleanup.ps1) as the
  initial reference engine instead of creating competing cleanup semantics.

An empty ordinary orphan directory MAY be reported for explicit removal only
when it is below a configured scan root, is not a reparse point, contains no
`.git` entry, and remains empty after revalidation. Non-empty, Git-bearing,
reparse-point, or unknown directories MUST remain untouched.

### 6.4 Skill output contract

When activated, the skill MUST:

1. identify the relevant domain rule and current repository evidence;
2. separate source requirements, repository policy, recommendations, inferences,
   and unresolved gaps;
3. inspect the smallest necessary local surface before proposing a command;
4. provide a proposed result or command with assumptions and expected effects;
5. request confirmation before a state-changing action;
6. report the exact validation performed and any remaining uncertainty.

For commit, branch, PR, release, and cleanup requests, the skill MUST favor a
structured result over a prose-only answer. It MUST never claim that a command
ran when it only drafted or recommended the command.

### 6.5 Skill originality and source handling

The implementation MUST use the cited upstream specifications and the
repository's own guidance without copying third-party skill text. Inspiration
from GitHub's `awesome-copilot` Conventional Commit and Conventional Branch
skills MAY influence workflow shape, but the MartiX skill must have original
routing, examples, safety language, and repository-specific boundaries.

## 7. Automation plugin requirements: `plugins/martix-git-automation`

### 7.1 Plugin package contract

The plugin MUST use the exact identity `martix-git-automation`, the repository's
`martix-` prefix, and SemVer package versioning. It MUST include the repository
plugin surfaces needed by the shipped assets:

```text
plugins/martix-git-automation/
├── plugin.json
├── README.md
├── agents/
├── instructions/
├── prompts/
├── hooks/
├── templates/
├── tests/
└── schema.json
```

`hooks.json` MAY be added only when the target runtime event and input contract
have been validated. The manifest MUST contain only fields supported by the
target plugin runtime. The plugin MUST NOT claim an automatic dependency
installation mechanism for `skills/martix-git` until a first-party contract is
verified.

The plugin README MUST document:

- the companion standalone skill and independent installation path;
- required versions and external commands (`git`, optional `gh`, PowerShell 7+
  for Windows scripts);
- supported clients and preview/runtime limitations;
- report-only and confirmation defaults;
- every state-changing command and its rollback or refusal behavior;
- how to disable or uninstall generated hooks and workflows;
- validation commands and known source/runtime gaps.

### 7.2 Deterministic/model-guided boundary

The plugin MUST keep deterministic state handling separate from model-guided
language generation:

| Layer | May do | Must not do |
| --- | --- | --- |
| Deterministic scripts | Parse Git/GitHub output, validate refs/messages/config, classify worktrees, revalidate state, and invoke commands safely. | Guess user intent, infer ownership, or silently broaden a candidate set. |
| Skill | Select types/scopes, explain policy, draft commit/branch/PR/release text, and explain reports. | Treat generated text as validated state or perform hidden mutations. |
| Prompts | Orchestrate inspection, review, confirmation, and deterministic adapters. | Bypass confirmation or duplicate the cleanup state machine. |
| Native hooks/CI | Enforce configured repository checks. | Depend on an AI session, network-only evidence, or an unbounded full build by default. |

The model MUST NOT parse `git worktree list --porcelain`, decide whether a
worktree is safe to delete, calculate release impact without the configured
analyzer policy, or interpolate untrusted text into a shell command.

### 7.3 Required commands and smart workflows

The plugin MUST provide the following user-invoked commands in the canonical
`/martix-git` namespace. The commands are requirements, not a claim about a
particular client's slash-command syntax. The smart forms MUST use the planner
defined in section 6.2.1; the explicit `propose`, `create`, `add`, `publish`,
`plan`, `view`, and `apply` forms MUST preserve their stated atomic boundaries.

#### 7.3.1 `/martix-git branch`

The prompt MUST:

- collect intent, optional issue identifier, branch type, description, base
  branch, and optional worktree path;
- detect and confirm the repository's trunk/base branch from local evidence;
- generate a Conventional Branch candidate using configured policy;
- validate it with the pinned branch specification and
  `git check-ref-format --branch`;
- refuse trunk collisions, existing-branch collisions, invalid refs, or
  ambiguous base state;
- show the exact command and intended target before asking for confirmation;
- create or switch only after confirmation;
- verify the resulting branch and worktree after mutation.

The `/martix-git branch` form MUST behave as a smart branch workflow. It MUST
skip branch creation when the current branch is already a valid, non-protected
topic branch matching the requested intent. `/martix-git branch create` MUST
remain available when the user explicitly wants an atomic branch mutation.

#### 7.3.2 `/martix-git commit`

The prompt MUST:

- inspect `git status` and `git diff --cached` before drafting;
- stop with a useful diagnostic when no staged changes exist;
- invoke `skills/martix-git` guidance when available and report clearly when the
  companion skill is unavailable;
- propose a Conventional Commit message based only on the staged diff and
  explicit repository policy;
- identify breaking changes and missing explanation before commit;
- show the complete message, including body and footers, for user review;
- write reviewed content to a temporary file and invoke
  `git commit --file <path>` using argument-safe execution;
- require explicit confirmation before committing;
- report hook results, commit identity, and final status after success.

The smart `/martix-git commit` form MUST skip commit creation when there are no
staged changes or when the requested change is already represented by the
current commit range. It MUST report the reason for skipping rather than
inventing an empty commit. `/martix-git commit propose` MUST be read-only and
`/martix-git commit create` MUST be the explicit atomic mutation form.

The prompt MUST NOT stage files, amend commits, rewrite history, bypass hooks,
or use `--no-verify` without an explicit separate user request and documented
risk. It MUST not silently fall back to copied Conventional Commit rules when
the companion skill is absent.

#### 7.3.3 `/martix-git pr`

The prompt MUST:

- run a complete read-only preflight before drafting or mutating anything;
- inspect the current branch, base branch, commit range, status, upstream,
  remote divergence, existing PRs, and configured merge/title policy;
- classify the branch, stage, commit, push, and PR phases as `perform`, `skip`,
  `ask`, or `block`, with evidence and a reason for every classification;
- draft a concise title according to the configured policy;
- draft a body with summary, motivation, implementation, tests, risk,
  migration/breaking-change notes, and issue references;
- distinguish `Refs` from `Fixes`/`Closes` and ask before adding a closing
  keyword;
- use `gh pr create` with explicit title, base, head, and `--body-file` values;
- default to a draft PR unless configuration or explicit user choice says
  otherwise;
- require review and confirmation before creating the PR;
- degrade clearly when `gh` is unavailable or unauthenticated;
- report the resulting PR URL, head SHA, base, draft state, and issue-linking
  intent.

When a user asks for a PR in natural language or invokes `/martix-git pr`, the
workflow MUST be capable of starting from the current repository state and
performing the following optional phases in order when evidence requires them:

```text
inspect -> branch -> stage -> commit -> push -> create/update PR
```

The phases are conditional, not a mandatory pipeline. The planner MUST use the
following decision rules:

| Phase | Perform when | Skip when | Ask or block when |
| --- | --- | --- | --- |
| Branch | The repository is detached, on a protected/trunk branch, or has no valid topic branch for the requested intent. | The current branch is a valid non-protected topic branch and its base/intent are suitable. | Branch intent, base branch, naming policy, or existing-branch collision is ambiguous. |
| Stage | Relevant unstaged changes must be included and the user has selected paths/hunks or explicitly approved the complete change set. | The required changes are already staged, or the branch already contains the intended commits and the worktree is clean. | Unstaged changes are mixed, unrelated, untracked, or the requested file scope is unclear. |
| Commit | The selected staged changes are not represented by commits ahead of the base and a commit is needed for the PR. | The worktree is clean and the branch already has the required commits, or there is no staged change to commit. | Staged changes are unrelated, hooks/policy fail, the message is ambiguous, or the branch has no reviewable delta. |
| Push | The local branch is ahead of its upstream, has no upstream, or the PR head is not available on the remote. | The remote already contains the required HEAD and the branch is synchronized. | The branch has diverged, the remote is unavailable, authentication fails, or a force push would be required. |
| Create PR | No open PR exists for the confirmed head/base and the branch is pushed and reviewable. | An open PR already exists for the same head/base; report its URL and do not create a duplicate. | A closed/merged PR already covers the branch, head/base or merge policy is ambiguous, or required checks/remote evidence are unavailable. |

The planner MUST re-read repository state after every performed phase and
recompute all later decisions. A previously generated plan MUST NOT be treated
as proof that a later phase is still necessary. A phase marked `skip` MUST be
reported as skipped with evidence; it MUST not be silently omitted from the
result.

`/martix-git branch pr` MUST invoke the same planner with branch-to-PR intent.
It may create a branch when needed, but it MUST skip branch creation when the
current branch already satisfies the request. `/martix-git pr` and
`/martix-git branch pr` MUST converge on the same safety rules and deterministic
adapters; they may differ only in the initial intent supplied to the planner.

The smart PR workflow MUST support a grouped confirmation after presenting the
full plan, but the user MUST be able to decline an individual phase. Declining
branch creation, staging, committing, pushing, or PR creation MUST stop or
degrade only the dependent phases and MUST NOT cause an alternative hidden
mutation. For example, declining staging MUST not cause the command to stage
all files implicitly, and declining push MUST not cause a force push.

The PR workflow MUST return a structured plan/result with at least these
columns or equivalent fields:

| Field | Required content |
| --- | --- |
| Phase | `inspect`, `branch`, `stage`, `commit`, `push`, or `pr`. |
| Decision | `perform`, `skip`, `ask`, or `block`. |
| Evidence | Current branch/HEAD, status, staged paths, commit range, upstream, remote, PR, or policy evidence used. |
| Action | Exact proposed command or explicit no-op explanation. |
| Confirmation | Required, received, declined, or not applicable. |
| Result | Completed, skipped, blocked, failed, or unresolved, with final observed state. |

The prompt MUST NOT infer that every PR title is a Conventional Commit. It MUST
apply title validation only when the configured merge method or repository policy
makes the title release-significant.

#### 7.3.4 `/martix-git policy setup`

The prompt MUST:

- detect the repository's language, package manager, existing hooks, CI, and
  validation commands before proposing files;
- prefer existing Husky, lint-staged, commitlint, or native tooling over a new
  parallel framework;
- propose `commit-msg`, `pre-commit`, and optional `pre-push` behavior separately;
- propose a CI equivalent for checks that local hooks can bypass;
- avoid overwriting existing configuration without explicit confirmation;
- show all files and commands it would add or change;
- support a dry-run/report mode;
- document installation, bypass, uninstall, and failure behavior;
- validate generated files before enabling them.

The prompt MUST not install a hook that runs network operations, publishes a
release, deletes worktrees, or performs an unbounded full build by default.

#### 7.3.5 `/martix-git worktree audit`

The prompt MUST:

- use the deterministic worktree inventory and existing cleanup engine;
- produce a structured report with worktree path, branch, HEAD, state,
  ownership evidence, merge evidence, reasons for retention, and candidate
  actions;
- distinguish registered worktrees, branches left unattached by external
  cleanup, and configured-root orphan directories;
- default to audit/report-only mode;
- offer an explicit apply phase only after the user selects candidates;
- show a fresh revalidation result immediately before each mutation;
- treat a candidate that disappears externally as a reconciled no-op, not as
  permission to delete its branch;
- return an idempotent result that can be compared with a subsequent audit.

#### 7.3.6 Optional `/martix-git release plan` and `/martix-git release publish`

The plugin MAY provide templates and guidance for these commands. If provided,
they MUST:

- require an explicit analyzer preset and release-rule mapping;
- support dry-run verification before publishing;
- require protected release branches and least-privilege credentials;
- use full history where release analysis needs it;
- separate verification from release publishing;
- refuse to publish from pull-request validation;
- document tag format, pre-release branches, maintenance branches, and the
  source of release-significant commit messages.

The initial plugin MUST NOT make semantic-release a mandatory dependency or
publish releases automatically merely because the plugin is installed.

### 7.4 Native hook and CI requirements

The plugin MUST provide opt-in templates or adapters for:

1. `commit-msg` validation of the configured Conventional Commit policy;
2. `pre-commit` staged-file checks;
3. optional bounded `pre-push` verification;
4. a CI commit-policy check that catches local `--no-verify` bypasses;
5. optional GitHub ruleset/protection setup guidance.

Hook installers MUST:

- use repository-local configuration or `core.hooksPath` without silently
  replacing existing hooks;
- preserve executable behavior and existing user-owned checks;
- provide Windows PowerShell and POSIX launchers where both are claimed;
- be non-interactive only after the user has approved the setup;
- provide deterministic exit codes and concise diagnostics;
- include an uninstall or rollback path;
- never install cleanup or release publishing behavior in a native hook.

The plugin MUST repeat critical policy in CI because Git documents that local
hooks can be bypassed with `--no-verify` and are not guaranteed to be present.
`main` and configured release branches SHOULD require those checks through
GitHub protection or rulesets.

### 7.5 Worktree and cleanup automation requirements

The plugin MUST integrate with the existing
[git-cleanup.ps1](../../../scripts/git-cleanup.ps1) safety model. Any new
`inspect-git-worktrees.ps1` or adapter MUST either delegate to that engine or
share its fixtures and invariants; two independently drifting cleanup engines
are not acceptable.

The cleanup path MUST satisfy all of the following:

- report-only by default;
- explicit `-Apply` or equivalent mutation mode;
- `SupportsShouldProcess` semantics for PowerShell mutation commands;
- per-item confirmation unless an explicitly controlled automation context
  supplies an equivalent confirmation boundary;
- no `--force` or forced worktree removal;
- NUL-safe parsing for paths and reasons;
- protection for main/current/protected/dirty/locked/detached/unknown/
  externally owned states;
- no branch deletion while a worktree remains attached;
- no branch deletion when an open PR or ambiguous merge evidence exists;
- compare-and-delete or equivalent expected-object-ID protection for local refs;
- immediate state revalidation before mutation;
- graceful handling of missing `git`, missing `gh`, unauthenticated `gh`,
  missing remotes, deleted remote branches, and externally removed worktrees;
- structured output suitable for a prompt, scheduled report, or CI artifact.

The plugin MUST keep remote and local cleanup separate:

| Lane | Owner | Allowed behavior |
| --- | --- | --- |
| Remote | GitHub Actions, GitHub API, or `gh` | Observe merged PRs, record head/base identity, delete or confirm remote head branch according to repository policy, and notify the developer. |
| Local | Developer command, local scheduler, or verified client integration | Fetch/prune remote-tracking refs when requested, audit worktrees, reconcile branches, and perform confirmed local cleanup. |

A remote workflow MUST NOT claim to remove a developer's local worktree or local
branch. A `pull_request` closed event MUST continue only when
`pull_request.merged == true`. A close-without-merge path MUST not be treated as
merged cleanup.

### 7.6 Runtime-specific hooks and adapters

The plugin MUST initially omit runtime hooks whose event names, input shapes,
permissions, or security behavior have not been validated in the target
runtime.

When a session-stop/report hook is later shipped, it MUST:

- be advisory and report-only;
- fail open and never block session completion;
- never remove a worktree, branch, directory, or remote ref;
- read Git state again rather than trusting stale session metadata;
- handle malformed or missing input without throwing an unsafe mutation path;
- document the exact client/runtime and version tested.

A Copilot `PreToolUse` guard MAY be added only after fixture tests capture the
actual tool names and input schema. It may deny only positively matched,
unambiguously dangerous operations; otherwise it must ask or warn. It is never
a substitute for native Git hooks, CI, or GitHub server policy.

### 7.7 Ownership and external lifecycle requirements

The implementation MUST maintain these ownership rules:

| Owner/state | Required behavior |
| --- | --- |
| Git | Treat Git's worktree inventory, refs, HEADs, lock files, and status as authoritative local state. |
| GitHub | Treat PR state, merge state, branch protection, and remote branch state as remote evidence. |
| Sandcastle | Require explicit handle or retained-path evidence; never infer ownership from path or branch name. |
| VS Code/Copilot | Treat archive cleanup observations as non-contractual; reconcile current Git state without racing or assuming ownership. |
| Plugin | Remove only candidates explicitly confirmed safe during the current invocation. Version 1 creates no worktrees. |
| Unknown | Report and retain; no removal is permitted. |

If a client removes a worktree registration but leaves a local branch, the
plugin MUST report the branch as unattached separately. It MUST NOT interpret
that observation as permission to delete the branch.

## 8. Configuration requirements

### 8.1 Repository configuration

The implementation MUST support an optional repository-local
`.martix-git.json` configuration file. It MUST include an explicit schema
version and MUST reject unknown schema versions rather than silently applying
defaults.

The minimum configuration shape is:

```json
{
  "$schema": "https://raw.githubusercontent.com/MartiXDev/skills/main/plugins/martix-git-automation/schema.json",
  "schemaVersion": 1,
  "conventionalCommit": {
    "types": [],
    "scopes": [],
    "requireScope": false,
    "maxHeaderLength": null
  },
  "branch": {
    "specVersion": "1.1.0",
    "prefixes": [],
    "maxLength": null,
    "trunkBranches": []
  },
  "pullRequest": {
    "defaultDraft": true,
    "titlePolicy": "repository",
    "baseBranch": null
  },
  "release": {
    "enabled": false,
    "analyzerPreset": null,
    "tagFormat": "v${version}",
    "releaseBranches": []
  },
  "hooks": {
    "enabled": false,
    "preCommitChecks": [],
    "prePushCommand": null
  },
  "worktree": {
    "enableRemoteEvidence": false,
    "reportOnSessionStop": false,
    "protectedBranches": ["@default"],
    "scanRoots": []
  }
}
```

The exact schema may evolve during implementation, but the following behavior
is required:

- empty `types` and `scopes` mean repository policy is not restricting that
  dimension, not that all values are invalid;
- `titlePolicy: "repository"` delegates title enforcement to the selected merge
  and repository policy;
- release integration is disabled by default;
- remote evidence is disabled by default;
- session-stop reporting is disabled until its runtime is validated;
- cleanup mutations are not enabled by configuration alone;
- secrets, tokens, passwords, and private keys are not accepted in this file;
- unknown properties MUST produce a clear diagnostic rather than being silently
  ignored;
- configuration diagnostics MUST identify path, property, expected type, and
  remediation.

### 8.2 Policy ownership

The configuration MUST distinguish:

- upstream specification facts, which are not configurable away;
- repository policy such as allowed types, scopes, title rules, branch aliases,
  and header length;
- runtime settings such as draft PR defaults and report scheduling;
- safety gates such as protected branches, remote evidence, and scan roots.

The configuration MUST NOT allow a repository policy to disable fundamental
state safety protections such as dirty/locked/current/unknown retention,
revalidation, or confirmation for deletion.

## 9. Safety, security, and failure requirements

### 9.1 Command execution

All Git and GitHub CLI invocations MUST:

- pass arguments as an array or direct argument list;
- avoid `Invoke-Expression`, shell reconstruction, and string interpolation of
  untrusted branch names, messages, PR text, issue titles, or paths;
- check exit status and capture bounded output;
- sanitize terminal control sequences before displaying untrusted text;
- preserve paths with spaces, Unicode, newlines, and other valid Git content;
- use temporary files for multi-line commit/PR/release content and remove them
  after the operation when safe.

### 9.2 State and time-of-check/time-of-use safety

Before every destructive mutation, the implementation MUST independently
re-read and validate:

- repository and worktree identity;
- current branch/HEAD and expected object ID;
- worktree path, lock, and registration;
- clean status and absence of untracked changes where required;
- protected/current/main status;
- branch attachment and open PR state;
- merge evidence and any required remote authentication;
- candidate ownership and user selection.

If any value changes, the operation MUST abort or reconcile safely and explain
why. A missing candidate is a no-op reconciliation result, not a reason to
delete its associated branch.

### 9.3 Protected states

The following states MUST be retained unconditionally unless a future explicit
human-reviewed requirement changes this contract:

- main worktree, current worktree, configured protected branch, or default
  branch;
- dirty or untracked worktree;
- locked worktree;
- detached or unverifiable HEAD;
- active or externally owned worktree;
- unknown owner;
- branch with an open pull request;
- ambiguous squash/rebase merge evidence;
- non-empty, reparse-point, Git-bearing, or unknown orphan directory.

### 9.4 Credentials and untrusted PRs

The plugin MUST not read, store, or transmit credentials. It MAY check
`gh auth status`, but authentication remains managed by `gh` or the CI runtime.

Remote workflows MUST use least-privilege permissions and MUST not check out or
execute untrusted fork code in a privileged event context. Release publishing
and cleanup permissions MUST remain separate where practical. OIDC/trusted
publishing SHOULD be preferred where the target registry supports it.

### 9.5 Failure behavior

| Context | Required behavior |
| --- | --- |
| Native hook configured check fails | Fail closed and return a useful diagnostic. |
| Local hook bypassed with `--no-verify` | CI/server check must catch it. |
| Required CI policy fails | Block protected merge. |
| Copilot guard positively matches high-risk operation | Deny or ask according to verified runtime contract. |
| Worktree cleanup state is unknown | Fail open by reporting and retaining. |
| Session-stop report fails | Fail open and do not block the session. |
| Branch name is invalid | Fail closed before branch mutation. |
| `gh` is missing or unauthenticated | Continue without remote evidence and classify affected decisions as unknown/ambiguous. |
| Release credentials or branch protection are missing | Refuse publishing and explain the prerequisite. |

## 10. End-to-end workflow requirements

### 10.0 Command dispatch and prerequisite planning

Every user-invoked operation MUST be addressable through the canonical
`/martix-git` namespace. The no-argument form MUST dispatch from the user's
intent, while a command with an explicit workflow or action MUST preserve that
scope. Smart commands MAY compose atomic adapters, but atomic commands MUST NOT
silently invoke sibling mutations.

For a PR goal, `/martix-git`, `/martix-git pr`, and `/martix-git branch pr`
MUST run the same prerequisite planner. The planner MUST inspect all phases,
classify each phase as `perform`, `skip`, `ask`, or `block`, and execute only
the phases necessary to produce the requested outcome. The existence of a
phase in the standard lifecycle MUST never make that phase mandatory.

The minimum smart PR lifecycle is:

```text
inspect -> branch? -> stage? -> commit? -> push? -> create/update PR?
```

The question marks are behavioral requirements: each phase is conditional on
current evidence and explicit intent. Read-only inspection is always required;
branch creation, staging, committing, pushing, and PR creation are optional.
Every performed phase MUST be followed by state reinspection before the next
decision. A successful phase MUST not be assumed to have left later state
unchanged.

### 10.1 Repository setup

The `/martix-git policy setup` flow MUST:

1. identify the repository root and default/trunk branch;
2. load or propose the pinned Conventional Branch version;
3. identify commit type, scope, footer, breaking-change, and title policy;
4. identify the merge method and release-significant message source;
5. inspect existing hooks, CI, package tooling, and protection assumptions;
6. propose configuration and generated files without writing them;
7. obtain explicit approval before installation;
8. validate generated files and report how to undo them.

### 10.2 Branch and worktree creation

The `/martix-git branch` flow MUST:

1. gather work intent and optional issue identifier;
2. generate a configured Conventional Branch candidate;
3. validate the candidate against the pinned specification and Git ref rules;
4. check base branch and existing-branch state;
5. show the exact `git switch -c` or `git worktree add -b` action;
6. obtain confirmation;
7. create the branch/worktree;
8. verify branch, HEAD, path, and status;
9. report the result without claiming ownership beyond the observed Git state.

When invoked as `/martix-git branch pr`, the branch flow MUST hand off to the
smart PR planner after branch inspection. It MUST not create a branch if the
current topic branch already satisfies the requested intent.

### 10.3 Staging and commit creation

The `/martix-git stage` flow MUST inspect the staged and unstaged path sets and
propose an explicit path or hunk selection. It MUST stage only after
confirmation. It MUST skip staging when the required changes are already
staged, the worktree is clean, or the branch already contains the intended
commits. It MUST ask when unrelated, untracked, or mixed changes make the
desired scope unclear.

The `/martix-git commit` flow MUST:

1. inspect status and staged diff;
2. generate a message from staged changes and configured policy;
3. identify missing breaking-change explanation or issue context;
4. show the complete proposed message;
5. obtain confirmation;
6. invoke `git commit --file` through argument-safe execution;
7. allow native hooks to run;
8. report commit SHA, message, hook result, and status.

The smart commit flow MUST skip creation when there are no staged changes or
when the current branch already contains the requested reviewable commits. The
atomic `/martix-git commit create` flow MUST create only the reviewed staged
commit and MUST NOT stage additional paths.

### 10.4 Pull request creation

The `/martix-git pr` flow MUST first run the complete prerequisite planner from
section 7.3.3. It MUST:

1. inspect branch, base, commit range, status, staged/unstaged changes,
   upstream, remote divergence, existing PRs, and merge/title policy;
2. perform or skip branch creation based on branch evidence and intent;
3. perform or skip staging based on explicit path selection and staged state;
4. perform or skip committing based on the reviewable commit range and staged
   state;
5. perform or skip pushing based on upstream and remote HEAD state;
6. draft title and body separately only after the branch has a reviewable
   commit range;
7. distinguish navigation references from issue-closing keywords;
8. report an existing open PR and skip duplicate creation;
9. obtain human review and confirmation for every performed mutation;
10. create a draft PR by default with structured CLI arguments/files only when
  no duplicate open PR exists;
11. report URL, head/base, draft state, issue-linking intent, and every skipped
  or blocked phase;
12. degrade clearly if remote access is unavailable.

If a phase is declined, the workflow MUST stop or report the dependent phases
as blocked. It MUST not compensate by staging all files, creating an empty
commit, force-pushing, or creating a duplicate PR.

### 10.5 Merge and release

The release flow MUST:

1. require configured protected release branches;
2. require verification checks to pass before release;
3. use the configured analyzer preset and release rules;
4. distinguish release message source for merge, squash, and rebase histories;
5. support dry-run output before publishing;
6. avoid publishing from pull-request validation;
7. use least-privilege credentials;
8. report tag, version, notes, and publish result separately.

The first implementation MAY provide only guidance and templates for this flow.
It MUST not silently publish.

### 10.6 Remote post-merge lifecycle

The remote flow MAY:

- respond to `pull_request` closed events only when merged;
- record PR number, merge method, base branch, head branch, head SHA, and merge
  SHA;
- delete or confirm deletion of the remote head branch according to repository
  policy;
- post a concise cleanup instruction or workflow summary;
- produce a machine-readable artifact for local reconciliation.

It MUST NOT claim to remove local worktrees or local branches.

### 10.7 Local reconciliation and cleanup

The local flow MUST:

1. optionally refresh remote-tracking refs only when requested;
2. run audit mode first;
3. classify retained and eligible states with reasons;
4. allow the user to select candidates;
5. revalidate each candidate;
6. require confirmation for each mutation;
7. apply only safe, clean, unlocked, unprotected, verified candidates;
8. re-run audit mode and report idempotent results.

## 11. Package layout and asset requirements

### 11.1 Skill assets

The implementation MUST organize the skill using progressive disclosure. The
minimum topic split is:

```text
skills/martix-git/
├── rules/
│   ├── conventional-commits.md
│   ├── conventional-branches.md
│   ├── git-workflows-and-hooks.md
│   ├── pull-requests-and-issues.md
│   ├── semver-and-semantic-release.md
│   └── worktree-lifecycle.md
├── references/
│   ├── source-map.md
│   ├── github-event-matrix.md
│   ├── release-policy.md
│   └── cleanup-state-model.md
├── templates/
│   ├── commit-message.md
│   ├── pull-request-body.md
│   └── release-policy.md
└── evals/
    └── evals.json
```

File names MAY change if the same routing boundary is preserved. The skill
MUST not load every topic reference for a narrow request.

### 11.2 Plugin assets

The implementation SHOULD organize the plugin as:

```text
plugins/martix-git-automation/
├── plugin.json
├── README.md
├── schema.json
├── prompts/
│   ├── martix-git.prompt.md
│   ├── branch.prompt.md
│   ├── stage.prompt.md
│   ├── commit.prompt.md
│   ├── push.prompt.md
│   ├── pr.prompt.md
│   ├── policy-setup.prompt.md
│   ├── worktree-audit.prompt.md
│   └── release.prompt.md
├── instructions/
│   └── git-workflow.instructions.md
├── hooks/
│   ├── README.md
│   ├── inspect-git-worktrees.ps1
│   ├── native-hook-install.ps1
│   └── session-stop-report.ps1
├── templates/
│   ├── policy/
│   │   ├── commitlint.config.mjs
│   │   └── commit-policy.yml
│   ├── github/
│   │   ├── pull-request-template.md
│   │   └── merged-pr-notification.yml
│   └── release/
│       └── verify-and-release.yml
└── tests/
    ├── fixtures/
    ├── inspect-git-worktrees.Tests.ps1
    ├── commit-validation.Tests.ps1
    └── branch-validation.Tests.ps1
```

The plugin MUST not add a custom agent until prompts and deterministic adapters
demonstrate a distinct recurring coordination role that prompts cannot provide.

## 12. Implementation phases for Phase 2

The following phases are requirements for the later implementation and are not
being executed now.

### Phase 2.0: package foundation

- Create both package scaffolds with synchronized identity and documentation.
- Implement the skill router and source map.
- Implement the `/martix-git` command router, smart no-argument entrypoint,
  atomic command boundaries, and `perform`/`skip`/`ask`/`block` plan schema.
- Implement configuration schema validation without mutation.
- Add initial skill eval prompts and negative activation cases.
- Validate Markdown, manifests, links, and repository layout.

**Exit criteria:** both packages are structurally valid, the standalone skill is
independently installable, and no state-changing automation is enabled.

### Phase 2.1: commit, branch, and Git workflow

- Implement `/martix-git branch`, `/martix-git stage`, `/martix-git commit`, and
  their atomic `propose`/`create`/`add` forms.
- Implement deterministic message and branch validation adapters.
- Implement the branch-to-PR composition contract without making PR creation a
  required side effect of `/martix-git branch`.
- Add fixture tests for valid/invalid messages, breaking changes, refs, trunk
  branches, Unicode paths, existing branches, and invalid base state.
- Add workflow instructions with explicit confirmation boundaries.

**Exit criteria:** branch and commit flows produce safe reviewed results; no
destructive operation is possible through these prompts.

### Phase 2.2: native policy and pull requests

- Implement `/martix-git policy setup`, `/martix-git push`, and `/martix-git pr`
  with the full conditional prerequisite planner.
- Compose with existing repository tools where present.
- Add native hook templates and CI parity.
- Add PR title/body and issue-linking policy.
- Add tests for partial staging, already-valid branches, clean branches with
  existing commits, synchronized upstreams, hook bypass, draft PRs, fork PRs,
  missing `gh`, duplicate open PRs, declined phases, and closing versus
  non-closing issue references.

**Exit criteria:** hooks apply across local Git clients, CI catches bypasses, and
the PR flow creates a reviewed draft without accidental issue closure.

### Phase 2.3: worktree lifecycle

- Integrate the existing cleanup engine and add a thin structured adapter if
  required.
- Implement NUL-safe inventory and state classification.
- Add report-only `/martix-git worktree audit`.
- Add explicit apply mode with `ShouldProcess`, candidate selection, and
  revalidation.
- Add fixtures for normal, squash, rebase, dirty, locked, detached, missing,
  externally removed, Unicode, and concurrent-change states.

**Exit criteria:** audits are correct and idempotent; apply mode cannot remove
protected or unknown states and requires explicit confirmation.

### Phase 2.4: remote lifecycle and verified runtime hooks

- Add optional merged-PR notification and local reconciliation guidance.
- Add semantic-release templates only with explicit analyzer configuration.
- Validate Copilot CLI and VS Code hook formats against running runtimes before
  adding `hooks.json`.
- Add report-only session-stop hook if its contract is verified.
- Add a guard hook only after tool names, input schema, and false-positive tests
  are recorded.
- Register package metadata only after package validation passes.

**Exit criteria:** remote and local ownership remain separate, runtime hooks are
  documented and tested, and no automatic cleanup mutation is attached to a
  session stop event.

## 13. Validation and evaluation requirements for Phase 2

### 13.1 Repository validation

Every implementation change MUST run focused checks first and then the
repository validator:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly -Path <changed-markdown-files>

powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

The implementation MUST distinguish pre-existing validator failures in ignored,
generated, worktree, or dependency paths from failures caused by the packages.

### 13.2 Skill evaluation

The standalone skill MUST have one canonical `skills/martix-git/evals/evals.json`
using the repository schema. It MUST include positive and negative activation
cases. The first evaluation wave SHOULD include at least:

- commit message from a staged diff;
- branch name for an issue and intent;
- bare `/martix-git` request routed to the correct primary workflow;
- `/martix-git pr` from a clean topic branch with reviewable commits and an
  existing open PR;
- `/martix-git pr` with independent branch, stage, commit, push, and PR
  decisions;
- `/martix-git branch pr` where branch creation is skipped but push and PR
  creation are required;
- `/martix-git pr` with no staged changes, missing `gh`, detached HEAD,
  divergent upstream, and declined confirmation;
- PR draft with a non-closing issue reference;
- semantic-release policy configuration;
- setup of native hooks and CI parity;
- worktree audit with dirty/locked/current candidates;
- remote-versus-local cleanup explanation;
- near-miss prompts for unrelated application versioning, generic file deletion,
  or generic Git commands.

Each positive case SHOULD assert source ownership, requirement/policy
separation, safe command shape, confirmation, and accurate validation claims.
Cleanup cases MUST assert no force removal, no unknown-state mutation, and
audit-before-apply behavior. PR cases MUST assert that closing keywords are not
invented. Release cases MUST assert no publish from PR validation.

The implementation phase MUST follow the skill-creator evaluation workflow:

1. create realistic eval prompts;
2. run with-skill and no-skill baselines in an external evaluation root;
3. draft objective assertions while runs execute;
4. grade and aggregate results;
5. generate the review viewer with `generate_review.py`;
6. collect human feedback before revising the skill;
7. repeat until the outputs meet the agreed quality floor.

This requirements phase does not create eval artifacts or launch the viewer.

### 13.3 Deterministic tests

The plugin implementation MUST include automated tests for:

| Area | Required cases |
| --- | --- |
| Commit validation | `feat`, `fix(scope)`, extra configured types, body, multiple footers, `!`, breaking footer, malformed prefix/footer, case handling, length policy. |
| Branch validation | Pinned Conventional Branch fixtures, Git ref validation, trunk names, configured aliases, collisions, invalid separators, Unicode and spaces. |
| Prompt command safety | Argument arrays, temporary files, confirmation, no hidden staging, no `--no-verify`, bounded output, missing tools. |
| Smart workflow planning | `perform`/`skip`/`ask`/`block` classification, phase reinspection, independently skipped prerequisites, duplicate PR detection, declined confirmation, no force push, and no implicit staging. |
| Hooks | Correct hook arguments, valid/invalid messages, staged-only checks, bypass detection in CI, uninstall behavior, existing-hook preservation. |
| PR policy | Title mode, body sections, closing versus non-closing references, draft default, fork input, missing authentication, merge queue event. |
| Release policy | Analyzer mapping, breaking changes, custom rules, tag format, dry run, branch protection prerequisite, PR-run refusal. |
| Worktrees | NUL parser, clean/dirty/locked/missing/detached/main/current states, Unicode paths, missing upstream, external removal, TOCTOU, idempotence. |
| Orphan directories | Empty ordinary directory, non-empty directory, reparse point, `.git` entry, unconfigured root, disappearance before apply. |
| Remote evidence | Normal/squash/rebase merge, closed-not-merged PR, deleted remote branch, missing/unauthenticated `gh`, ambiguous evidence, query limits. |
| Runtime hooks | Malformed input, timeout, report-only behavior, no mutation, verified allow/ask/deny cases only. |

PowerShell scripts MUST be tested on PowerShell 7+ on Windows. POSIX launchers
MAY be added only when they have an equivalent test path.

## 14. Acceptance criteria

The requirements are ready for Phase 2 implementation when the following are
accepted:

1. Package names are fixed as `skills/martix-git` and
   `plugins/martix-git-automation`.
2. Reusable rules live in the standalone skill; prompts, hooks, templates, and
   deterministic adapters live in the plugin.
3. Conventional Commits, Conventional Branch, PR fields, issue links, SemVer,
   and semantic-release are represented as separate owning contracts.
4. PR title validation is conditional on explicit merge/repository policy.
5. Native hooks and CI are the enforcement path; agent hooks are supplemental.
6. Remote branch deletion and local worktree/branch cleanup are separate lanes.
7. Existing cleanup behavior is reused or wrapped, not independently forked.
8. Cleanup is audit-first, report-only by default, and protected by
   confirmation, ownership evidence, and immediate revalidation.
9. Unknown, dirty, locked, current, main, detached, active, externally owned,
   open-PR, and ambiguous states are retained.
10. Semantic-release is optional, configured explicitly, and never publishes
    from PR validation or installation alone.
11. Runtime-specific hooks are omitted until their contracts are tested.
12. Phase 2 will include repository validation, deterministic tests, skill evals,
    and human review of generated outputs.
13. The canonical command family is used for new documentation, prompts,
  evaluations, and tests; short names remain aliases only.
14. The bare `/martix-git` entrypoint performs intent routing and state-based
  planning before mutation.
15. PR requests inspect branch, staging, commit, push, and existing-PR state,
  then perform only necessary and confirmed phases.
16. Every skipped, asked, blocked, or performed phase reports evidence and
  outcome, and declining a phase causes dependent phases to stop or block
  without hidden compensating mutations.

The implementation is not complete unless it can demonstrate these criteria
with executable validation and does not merely satisfy them in documentation.

## 15. Open decisions for Phase 2

The following decisions are intentionally left configurable or explicitly open;
they must be resolved before the affected implementation slice is committed:

| Decision | Default requirement | Decision owner |
| --- | --- | --- |
| Accepted commit types | No additional restriction beyond the specification until repository policy is supplied. | Target repository maintainer |
| Scope vocabulary | Freeform unless the target repository configures an allow-list. | Target repository maintainer |
| PR title policy | Repository/merge-method dependent; do not force Conventional Commit shape globally. | Target repository maintainer |
| Merge method | Detect and document the target repository's selected method before release/cleanup setup. | Target repository maintainer |
| semantic-release adoption | Optional profile, disabled by default. | Target repository maintainer |
| Hook manager | Prefer existing native/Husky/lint-staged/commitlint tooling. | Target repository maintainer |
| Runtime hook support | Copilot CLI and VS Code only after live contract tests; no unverified manifest fields. | Plugin maintainer |
| Sandcastle adapter | No inference; require an explicit retained-path or handle record. | Plugin maintainer and Sandcastle owner |
| Local scheduling | Explicit user command first; Windows Task Scheduler example MAY follow. | Plugin maintainer |
| Marketplace registration | After Phase 2.1 package validation and install test. | Repository maintainer |

These open decisions must not weaken the unconditional safety requirements in
section 9.

## 16. Requirement traceability

| User brief requirement | Skill requirement | Plugin requirement | Validation evidence |
| --- | --- | --- | --- |
| Conventional Commits in commits | 6.3.1 | 7.3.2, 7.4 | Commit fixtures, `commit-msg`, skill evals |
| Conventional naming for branches | 6.3.2 | 7.3.1 | Pinned branch fixtures and Git ref tests |
| Conventional policy in PRs | 6.3.4 | 7.3.3 | Title policy and PR prompt tests |
| SemVer | 6.3.5 | 7.3.6 | Version/tag/release mapping tests |
| semantic-release | 6.3.5 | 7.3.6 | Analyzer, dry-run, protected-branch tests |
| Git best practices | 6.3.3, 6.3.7 | 7.2, 7.5 | Command-safety and worktree fixtures |
| GitHub PR and issue management | 6.3.4 | 7.3.3, 7.5.4 | `gh` and issue-linking tests |
| Existing skill inspiration | 6.5 | 7.1 | Originality review and source map |
| Cleanup after agent branches/worktrees | 6.3.7 | 7.3.5, 7.5 | Audit/apply, ownership, TOCTOU tests |
| Hooks and linting automation | 6.3.6 | 7.3.4, 7.4 | Hook install, CI parity, bypass tests |
| Safe automation across clients | 5.2, 9 | 7.6, 7.7 | Compatibility matrix and runtime tests |
| Canonical command family and smart PR planner | 6.2.1, 6.4 | 7.3, 10.0-10.4 | Command routing, decision matrix, phase reinspection, and end-to-end PR fixtures |

## 17. Source map

The source IDs below identify the evidence behind the requirements. The full
claim-level source map remains in [martix-git-research.md](./martix-git-research.md).

| ID | Source | Role |
| --- | --- | --- |
| BRIEF-1 | [MartiX Git research resources](./martix-git-research-resources.md) | Original user requirements and requested sources. |
| RES-1 | [MartiX Git research snapshot](./martix-git-research.md) | Dated synthesis, recommendations, risks, and source ownership. |
| PLAN-1 | [martix-git Plugin Plan](../../knowledge/repository/research/git-worktree-workflows/martix-git-plugin-plan.md) | Earlier package boundary, user journeys, safety model, fixtures, and lifecycle observations. |
| REPO-1 | [Repository knowledge](../../knowledge/repository/knowledge.md) | Standalone skill versus plugin ownership and package maintenance rules. |
| ART-1 | [Custom AI artifact rules](../../policy/custom-ai-artifact-rules.md) | Artifact contracts, progressive disclosure, package files, and eval schema. |
| LOCAL-1 | [Existing cleanup script](../../../scripts/git-cleanup.ps1) | Audit/apply/WhatIf behavior, worktree parser, merge evidence, and guarded local mutation. |
| CC-1 | [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) | Commit-message structure and semantics. |
| CB-1 | [Conventional Branch](https://conventionalbranch.org/) | Branch naming specification and relationship to Conventional Commits. |
| CB-2 | [Conventional Branch v1.1.0 specification](https://conventionalbranch.org/v1.1.0/spec.json) | Pinned machine-readable branch rules. |
| SV-1 | [Semantic Versioning 2.0.0](https://semver.org/) | Version syntax, precedence, releases, and tag distinction. |
| SR-1 | [semantic-release introduction](https://semantic-release.org/intro/) | Commit conventions, CI lifecycle, release steps, and release impact. |
| SR-2 | [semantic-release configuration](https://semantic-release.org/usage/configuration/) | Branches, tag format, plugins, dry run, and protection expectations. |
| SR-3 | [semantic-release release steps](https://semantic-release.org/foundation/release-steps/) | Verification, analysis, notes, tagging, publishing, and notification pipeline. |
| SR-4 | [semantic-release commit analyzer](https://github.com/semantic-release/commit-analyzer) | Presets and configurable release rules. |
| GIT-1 | [gitworkflows](https://git-scm.com/docs/gitworkflows) | Small logical changes and topic branch practice. |
| GIT-2 | [git-commit](https://git-scm.com/docs/git-commit) | Commit templates, trailers, message files, and hook bypass. |
| GIT-3 | [githooks](https://git-scm.com/docs/githooks) | Native hook lifecycle and inputs. |
| GIT-4 | [git-worktree](https://git-scm.com/docs/git-worktree) | Worktree inventory, porcelain format, locks, removal, and pruning. |
| GIT-5 | [git-check-ref-format](https://git-scm.com/docs/git-check-ref-format) | Independent Git ref validation. |
| GH-1 | [Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue) | Closing keywords and default-branch behavior. |
| GH-2 | [Autolinked references and URLs](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls#issues-and-pull-requests) | Navigation references and conversation scope. |
| GH-3 | [GitHub pull-request REST API](https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28) | PR fields, merge state, SHAs, and methods. |
| GH-4 | [GitHub CLI pull-request manual](https://cli.github.com/manual/gh_pr) | Structured PR create, list, view, merge, and close operations. |
| GH-5 | [GitHub merge methods](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/about-merge-methods-on-github) | Normal, squash, and rebase history effects. |
| GH-6 | [Protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) | Required reviews, checks, signatures, linear history, and deletion controls. |
| GH-7 | [Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) | Layered server-side branch and tag policy. |
| GH-8 | [GitHub Actions events](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows) | Merged PR filters, privileged events, schedules, delete, and merge queue events. |
| CC-2 | [GitHub awesome-copilot Conventional Commit skill](https://raw.githubusercontent.com/github/awesome-copilot/main/skills/conventional-commit/SKILL.md) | Non-normative workflow inspiration. |
| CB-3 | [GitHub awesome-copilot Conventional Branch skill](https://raw.githubusercontent.com/github/awesome-copilot/main/skills/conventional-branch/SKILL.md) | Non-normative branch workflow inspiration. |
| VSCODE-1 | [VS Code agent hooks](https://code.visualstudio.com/docs/copilot/customization/hooks) | Runtime-specific hook behavior and security boundary. |

The research snapshot records retrieval dates, discontinued URLs, and source
gaps. Those details must remain available when the requirements are turned into
implementation references.
