import {
  makeStyles,
  shorthands,
  tokens,
} from "@fluentui/react-components";

export const useExampleStyles = makeStyles({
  root: {
    display: "grid",
    gap: tokens.spacingVerticalM,
    color: tokens.colorNeutralForeground1,
    backgroundColor: tokens.colorNeutralBackground1,
    ...shorthands.padding(tokens.spacingVerticalM, tokens.spacingHorizontalM),
    "@media (forced-colors: active)": {
      ...shorthands.border("1px", "solid", "CanvasText"),
    },
  },
});
