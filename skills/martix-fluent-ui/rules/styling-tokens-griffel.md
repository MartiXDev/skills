# Tokens and Griffel styling

## Purpose

Keep styling theme-aware, deterministic, bidirectional, and compatible with
Fluent UI's runtime and override model.

## Default guidance

- Use semantic Fluent tokens for color, spacing, typography, radius, shadow, and
  duration instead of hard-coded design values.
- Use `makeStyles`, `mergeClasses`, and supported Griffel helpers for component
  styles. Keep style hooks outside render functions.
- Apply generated classes to the documented root or slot. Preserve caller
  `className` and slot props when wrapping or composing components.
- Use logical properties where possible. Verify directionality in both LTR and RTL.
- Add forced-colors behavior only where native semantics and Fluent defaults do not
  already provide it.
- Keep global CSS for genuine document-level concerns. Do not fight component
  internals with broad selectors, `!important`, or DOM-shape assumptions.

## Decision branches

- Prefer a token when the value expresses a design-system decision.
- Prefer a local CSS custom property when consumers need a supported component
  extension point not represented by a global token.
- Use inline styles only for truly dynamic values that cannot be represented by
  classes or variables; do not make inline styles the normal override mechanism.
- When combining wrapper and consumer classes, use the ordering documented by the
  component contract and test the actual precedence.
- For third-party CSS coexistence, isolate ownership by layer or boundary rather
  than increasing specificity globally.

## Review checklist

- [ ] Semantic tokens replace duplicated design literals.
- [ ] `makeStyles` hooks are stable and not created during render.
- [ ] Consumer classes, slot props, and events are preserved.
- [ ] LTR, RTL, dark theme, and forced-colors behavior are considered.
- [ ] Selectors do not depend on private DOM structure.
- [ ] Specificity workarounds are not hiding an ownership problem.

## Related files

- [Token styles template](../templates/token-styles.template.ts)
- [Foundation, packages, and themes](./foundation-packages-provider-theme.md)
- [Accessibility and focus](./accessibility-focus.md)

## Source anchors

- [Griffel documentation](https://griffel.js.org/)
- [Fluent UI React styling specification](https://github.com/microsoft/fluentui/blob/master/packages/react-components/react-components/docs/react-v9/contributing/rfcs/convergence/Styling.md)
- [CSS forced-colors](https://developer.mozilla.org/docs/Web/CSS/@media/forced-colors)
