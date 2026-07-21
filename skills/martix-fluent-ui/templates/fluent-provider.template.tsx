import type { PropsWithChildren } from "react";
import {
  FluentProvider,
  webLightTheme,
} from "@fluentui/react-components";

export function AppFluentProvider({ children }: PropsWithChildren) {
  return (
    <FluentProvider theme={webLightTheme}>
      {children}
    </FluentProvider>
  );
}
