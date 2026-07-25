# Fluent UI skill research and implementation blueprint

Checked: **2026-07-21**

## Executive summary

The recommended package is **`martix-fluent-ui`**. The hyphenated official product
name improves discovery and avoids confusion with the existing
`martix-fluentvalidation` package.

The skill should be:

- React-first, centered on `@fluentui/react-components` v9;
- TypeScript/TSX-first for reusable or composed components;
- accessibility- and public-API-first;
- strict about separating durable guidance from dated package facts;
- explicit that Vue is an exceptional Web Components path, not a parallel React
  API path;
- integrated with `martix-typescript` through a clear ownership handoff;
- evaluated on behavior and activation boundaries, not only document structure.

The main architectural correction is that normal application composition should
use public components, props, slots, and compound components. `_unstable`
state/render APIs are valuable for advanced recomposition, but their name and
location signal a weaker compatibility contract. They should not be the default
wrapper recipe.

The second major correction is the Vue path. Fluent UI React APIs such as
`FluentProvider`, Griffel component styling, and React slots do not transfer to
Vue. The relevant integration surface is `@fluentui/web-components`, and current
v3 package guidance must replace older examples using
`provideFluentDesignSystem`.

## Research scope

This report combines:

- repository conventions and package contracts;
- the existing local research
  [`Fluent UI Skill Research.md`](./Fluent%20UI%20Skill%20Research.md);
- official Fluent UI source, package READMEs, and Storybook;
- Griffel documentation;
- npm package metadata;
- WAI-ARIA Authoring Practices and WCAG;
- current Next.js server-style insertion documentation;
- skill-authoring and evaluation requirements from this repository.

The existing local research was treated as a discovery source, not an authority.
Claims were retained only when they matched current official evidence or were
restated as hypotheses requiring repository inspection.

## Success criteria

The skill succeeds when it consistently:

1. activates for real Fluent UI implementation, migration, styling, SSR, and
   accessibility tasks;
2. does not activate for generic React, TypeScript, Microsoft design language, or
   unrelated products sharing the word "Fluent";
3. selects the correct package generation and public component;
4. produces token-driven, theme-aware, RTL- and forced-colors-aware styling;
5. preserves semantics, keyboard behavior, and focus;
6. isolates unstable or preview APIs;
7. distinguishes React from Web Components/Vue;
8. hands TypeScript infrastructure work to `martix-typescript`;
9. validates behavior in the target repository;
10. cites version-sensitive facts.

## Repository implications

The repository requires a standalone skill package under `skills\martix-*` with:

- `plugin.json`
- `metadata.json`
- `README.md`
- `SKILL.md`
- `AGENTS.md`
- `LICENSE.txt`
- `rules\`
- `references\`
- `templates\`
- `assets\taxonomy.json`
- `assets\section-order.json`
- `evals\evals.json`

`SKILL.md` should remain a compact activation router. Durable decisions belong in
rules; version snapshots, migration maps, and source navigation belong in
references. This follows
[`skill-packages.instructions.md`](../../.github/instructions/skill-packages.instructions.md)
and
[`custom-ai-artifact-rules.md`](../custom-ai-artifact-rules.md).

## Recommended scope

### Owned by `martix-fluent-ui`

- Fluent UI package generation and version inspection
- `@fluentui/react-components` v9
- `FluentProvider`, themes, design tokens, and nested scopes
- Griffel `makeStyles`, class composition, RTL, and forced colors
- component selection
- slots and compound components
- advanced `_unstable` recomposition as an explicit branch
- semantics, keyboard behavior, focus, overlays, and form accessibility
- SSR, style extraction, hydration, and Next.js integration
- Fluent System Icons
- Fluent motion and chart package selection
- Fabric, v8, and v0 migration or coexistence
- the exceptional Vue path through `@fluentui/web-components`
- Fluent-specific behavior tests and review criteria

### Owned by `martix-typescript`

- generic TypeScript API design
- `tsconfig` and JSX configuration
- module and package resolution
- declaration emit and package exports
- compiler-version migration
- general type tests

The boundary is intentionally practical. Typing a Fluent slot or preserving a
Fluent component ref stays in this skill. Choosing `moduleResolution` for atomic
icon imports or publishing a component library moves to `martix-typescript`.

### Other handoffs

- SPFx hosting, packaging, deployment, and SharePoint theme variants belong to
  `martix-sharepoint-spfx`.
- Generic React performance or state architecture stays with React-specific
  guidance when Fluent UI is incidental.
- Vue application architecture remains Vue-owned; this skill covers only the
  Fluent Web Components boundary.

## Current package snapshot

The following npm state was observed on 2026-07-21 and must be rechecked before
version-sensitive changes:

| Package or surface | Observed state | Skill consequence |
| --- | --- | --- |
| `@fluentui/react-components` | 9.74.4 | Primary React v9 umbrella package |
| React peer range | `>=16.14.0 <20.0.0` | Do not assume React 20 support |
| `@fluentui/react-charts` | 9.3.22 | Official chart package exists |
| `@fluentui/react-motion` | 9.16.1 | Official motion package exists |
| `@fluentui/web-components` | 3.0.2 | Current Vue/non-React integration surface |
| `react-alert` | beta in v9 suite | Version-gate and isolate |
| `react-infobutton` | beta in v9 suite | Version-gate and isolate |
| `react-virtualizer` | alpha in v9 suite | Strong API-drift warning |

Sources:

- [npm: `@fluentui/react-components`](https://www.npmjs.com/package/@fluentui/react-components)
- [npm: `@fluentui/react-charts`](https://www.npmjs.com/package/@fluentui/react-charts)
- [npm: `@fluentui/react-motion`](https://www.npmjs.com/package/@fluentui/react-motion)
- [npm: `@fluentui/web-components`](https://www.npmjs.com/package/@fluentui/web-components)
- [Fluent UI package source](https://github.com/microsoft/fluentui/tree/master/packages)

The package version does not imply equal stability for every export. Preview
packages and `_unstable` APIs require separate treatment.

## Evidence hierarchy

Use evidence in this order:

1. installed package metadata and source in the target repository;
2. official package README, Storybook, and source at the matching tag;
3. npm metadata;
4. official Microsoft or framework documentation with an update date;
5. W3C specifications;
6. secondary sources as discovery only.

This order prevents three common errors:

- assuming `master` branch APIs are already published;
- copying an old Learn or blog example into a new major;
- treating one sample application's compiler setup as universal support policy.

Primary navigation:

- [Fluent UI React Storybook](https://react.fluentui.dev/)
- [microsoft/fluentui](https://github.com/microsoft/fluentui)
- [Fluent UI React v9 umbrella package](https://github.com/microsoft/fluentui/tree/master/packages/react-components/react-components)
- [Griffel](https://griffel.js.org/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)

## Core design decisions

### 1. Inspect before prescribing

The agent should identify:

- framework and rendering mode;
- installed React and `@fluentui/*` versions;
- package manager and lockfile;
- current providers and themes;
- styling systems;
- SSR/client boundaries;
- test runner and accessibility tools;
- migration generations.

Without this inventory, even a correct API example may be wrong for the target.

### 2. Public API before advanced recomposition

Use this escalation order:

1. public component;
2. public props;
3. documented slots;
4. compound components;
5. composition from public Fluent primitives;
6. `_unstable` state/render APIs behind an adapter.

The last step is appropriate only when public surfaces cannot express a concrete
requirement, the exact installed export is verified, accessibility remains owned,
and focused upgrade tests exist.

Evidence:

- [Fluent UI React Storybook](https://react.fluentui.dev/)
- [React components source](https://github.com/microsoft/fluentui/tree/master/packages/react-components)

### 3. Interaction before appearance

Component selection starts from the interaction and state model. A dialog,
popover, menu, tooltip, combobox, listbox, toolbar, tabs, and grid may share visual
traits while having different semantics and keyboard contracts.

The skill should prevent "atomic assembly" from bypassing the behavior already
owned by a high-level Fluent component.

Evidence:

- [Fluent UI React Storybook](https://react.fluentui.dev/)
- [WAI-ARIA APG patterns](https://www.w3.org/WAI/ARIA/apg/patterns/)

### 4. Tokens and Griffel as the styling default

Use semantic Fluent tokens for design decisions and Griffel for component styles.
The skill should reject:

- copied generated token values;
- broad private DOM selectors;
- `!important` escalation as a default;
- render-time `makeStyles`;
- a mix of utility classes, inline styles, and Griffel without ownership.

Review dark theme, RTL, forced colors, and consumer override behavior.

Evidence:

- [Griffel documentation](https://griffel.js.org/)
- [CSS forced-colors](https://developer.mozilla.org/docs/Web/CSS/@media/forced-colors)

### 5. Accessibility is behavioral

The skill must review:

- role, name, state, and relationships;
- full keyboard sequence;
- focus placement, containment, visibility, and restoration;
- validation-message association;
- announcement timing;
- zoom and reflow;
- forced colors and reduced motion.

Automated scans are necessary but cannot prove focus or interaction quality.

Evidence:

- [WAI-ARIA APG](https://www.w3.org/WAI/ARIA/apg/)
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [Testing Library query priority](https://testing-library.com/docs/queries/about/#priority)

### 6. SSR guidance must be versioned

The stable architectural principles are:

- request-safe Griffel renderer ownership;
- deterministic server style insertion;
- equivalent server/client provider assumptions;
- explicit client boundaries;
- production hydration validation.

Exact Next.js recipes drift. Current App Router work commonly uses
`useServerInsertedHTML`, but the agent must verify installed versions and current
official material. A pinned official example that uses an experimental third-party
SWC transform is not proof that every application should install it.

Evidence:

- [Griffel React API](https://griffel.js.org/react/api/)
- [Next.js `useServerInsertedHTML`](https://nextjs.org/docs/app/api-reference/functions/use-server-inserted-html)
- [Fluent UI SSR material](https://github.com/microsoft/fluentui/tree/master/apps/public-docsite-v9/src/Concepts/Developer/ServerSideRendering)

### 7. Icons, motion, and charts remain first-party candidates

The local research should not be interpreted as requiring third-party charts or
motion. Official packages exist and should be evaluated against requirements.

For icons:

- use atomic public imports;
- provide accessible names through the owning control;
- verify color variants in forced-colors mode;
- treat module resolution as a TypeScript handoff;
- avoid assuming every generated icon name is a permanent contract.

For motion:

- use it for continuity and feedback;
- respect `prefers-reduced-motion`;
- keep state understandable without animation.

For charts:

- verify current package maturity and supported chart types;
- require accessible descriptions, keyboard behavior, or a data alternative;
- use a third party only for a demonstrated gap.

Evidence:

- [Fluent System Icons](https://github.com/microsoft/fluentui-system-icons)
- [Fluent UI React Charts](https://github.com/microsoft/fluentui/tree/master/packages/charts/react-charts)
- [Fluent UI React Motion](https://github.com/microsoft/fluentui/tree/master/packages/react-components/react-motion)

### 8. Vue is a Web Components branch

For Vue:

- use `@fluentui/web-components`;
- verify the installed major's registration API;
- register only needed elements through verified v3 side-effect definition imports;
- configure Vue custom-element recognition;
- type custom elements and events through a concrete DOM or Vue declaration;
- apply themes through `setTheme()` and `@fluentui/tokens`;
- test SSR registration timing and hydration;
- do not use `FluentProvider`, Griffel, React slots, or React hooks.

Older examples using `provideFluentDesignSystem` are not current v3 guidance.

Evidence:

- [Fluent UI Web Components source](https://github.com/microsoft/fluentui/tree/master/packages/web-components)
- [Vue custom elements](https://vuejs.org/guide/extras/web-components.html#using-custom-elements-in-vue)

## Migration model

Migration should be sliced, measurable, and reversible:

1. inventory package generations, providers, styling, deep imports, and tests;
2. record current visual, behavior, keyboard, focus, and accessibility acceptance;
3. choose a coherent feature or component-family boundary;
4. map interaction and behavior to a public v9 component;
5. move provider/theme/styling/tests with the slice;
6. isolate unavoidable coexistence behind a narrow adapter;
7. define the adapter's deletion condition;
8. remove legacy packages and tests only after acceptance.

Mechanical import renames are insufficient because similarly named components may
have different props, structure, focus, or keyboard behavior.

Evidence:

- [Fluent UI v9 migration docs](https://github.com/microsoft/fluentui/tree/master/packages/react-components/react-components/docs/react-v9/migration)

## Recommended package architecture

```text
skills/martix-fluent-ui/
  plugin.json
  metadata.json
  README.md
  SKILL.md
  AGENTS.md
  LICENSE.txt
  rules/
    foundation-packages-provider-theme.md
    styling-tokens-griffel.md
    component-composition-slots.md
    accessibility-focus.md
    ssr-nextjs.md
    icons-motion-charts.md
    migration-v8-v0.md
    vue-web-components.md
    testing-quality-gates.md
  references/
    source-index.md
    version-support-map.md
    component-selection-map.md
    accessibility-map.md
    ssr-recipes.md
    migration-map.md
    ecosystem-boundaries.md
  templates/
    fluent-provider.template.tsx
    token-styles.template.module.css
    accessible-toolbar.template.tsx
  assets/
    taxonomy.json
    section-order.json
  evals/
    evals.json
    trigger-evals.json
```

## Evaluation strategy

### Behavior evals

The minimum discriminating set should cover:

1. provider and brand theme;
2. accessible icon-only toolbar;
3. public composition versus `_unstable`;
4. Griffel and external CSS conflict;
5. Fabric/v8 migration slice;
6. Next.js App Router SSR;
7. icons plus TypeScript handoff;
8. Vue Web Components v3;
9. chart package selection;
10. generic React negative activation.

Assertions should test decisions that a generic answer often misses, such as
public-before-unstable composition, request-safe renderer ownership, or rejection
of the obsolete Vue registration API.

### Trigger evals

Positive activation cases should include:

- explicit Fluent UI package work;
- Fabric or v8 migration;
- FluentProvider and tokens;
- Griffel conflicts;
- component accessibility and focus;
- Fluent SSR;
- icons, charts, motion;
- Vue with Fluent Web Components.

Hard negatives should include:

- generic React optimization;
- generic TypeScript API design;
- SPFx deployment without Fluent concerns;
- FluentValidation;
- Fluent 2 visual-design discussion with no code;
- Vue using another design system;
- generic accessibility audit;
- Fluent Bit log formatting.

These negatives protect against keyword-only triggering.

## Critical review of the earlier local research

The local source is useful for breadth and discovery, but the following points
required correction or stronger qualification:

| Earlier direction | Corrected position |
| --- | --- |
| Use `_unstable` state/render APIs as a routine composition model | Prefer public components, slots, and compound components; reserve `_unstable` for isolated advanced recomposition |
| Treat React ecosystem recommendations as Fluent UI policy | Keep generic React tooling and architecture outside the skill unless Fluent behavior depends on it |
| Follow old Vue registration examples | Verify `@fluentui/web-components` v3; older `provideFluentDesignSystem` examples are stale |
| Assume Fluent charts or motion are absent/insufficient | Official packages exist; evaluate them against explicit requirements |
| Copy SSR samples directly | Separate durable renderer principles from pinned, version-sensitive recipes |
| Treat accessibility as ARIA markup | Require keyboard, focus, announcement, preferences, and behavior tests |

## Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| API drift | Inspect installed versions and official tagged source |
| Over-triggering on "Fluent" | Use hard negatives and product/package cues |
| React/Vue conceptual mixing | Keep Vue in one exceptional Web Components rule |
| Skill bloat | Keep `SKILL.md` as a router and use progressive disclosure |
| Fragile wrappers | Public APIs first; isolate unstable APIs |
| Styling specificity wars | Define Griffel/token ownership and consumer override contract |
| Accessibility theater | Test keyboard and focus behavior, not only automated scans |
| SSR cargo culting | Date recipes and verify production hydration |
| TypeScript duplication | Explicit `martix-typescript` handoff |

## Final recommendation

Ship `martix-fluent-ui` as a standalone preview skill with the architecture above.
The package should favor precise repository inspection and public Fluent contracts
over broad tutorials. Its quality should be judged by whether it changes model
behavior on the hard decisions: package generation, component semantics, slot
composition, unstable API containment, theme/styling ownership, SSR lifecycle,
Vue separation, and accessibility validation.

## Source list

- [Fluent UI repository](https://github.com/microsoft/fluentui)
- [Fluent UI React Storybook](https://react.fluentui.dev/)
- [Fluent UI React components package](https://github.com/microsoft/fluentui/tree/master/packages/react-components/react-components)
- [Fluent UI v9 migration docs](https://github.com/microsoft/fluentui/tree/master/packages/react-components/react-components/docs/react-v9/migration)
- [Griffel documentation](https://griffel.js.org/)
- [Fluent System Icons](https://github.com/microsoft/fluentui-system-icons)
- [Fluent UI React Charts](https://github.com/microsoft/fluentui/tree/master/packages/charts/react-charts)
- [Fluent UI React Motion](https://github.com/microsoft/fluentui/tree/master/packages/react-components/react-motion)
- [Fluent UI Web Components](https://github.com/microsoft/fluentui/tree/master/packages/web-components)
- [npm: `@fluentui/react-components`](https://www.npmjs.com/package/@fluentui/react-components)
- [npm: `@fluentui/react-charts`](https://www.npmjs.com/package/@fluentui/react-charts)
- [npm: `@fluentui/react-motion`](https://www.npmjs.com/package/@fluentui/react-motion)
- [npm: `@fluentui/web-components`](https://www.npmjs.com/package/@fluentui/web-components)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [Vue custom elements](https://vuejs.org/guide/extras/web-components.html#using-custom-elements-in-vue)
- [Next.js `useServerInsertedHTML`](https://nextjs.org/docs/app/api-reference/functions/use-server-inserted-html)
