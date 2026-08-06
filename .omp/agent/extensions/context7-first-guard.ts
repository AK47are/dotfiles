import type {
  ExtensionAPI,
  ToolCallEvent,
} from "@earendil-works/pi-coding-agent";

export default function context7FirstGuard(pi: ExtensionAPI) {
  let context7Used = false;

  pi.on("tool_call", (event: ToolCallEvent) => {
    const invokedToolName =
      event.toolName === "write"
        ? /^xd:\/\/(.+)/.exec(String(event.input.path ?? ""))?.[1]
        : event.toolName;

    if (
      invokedToolName === "resolve-library-id" ||
      invokedToolName === "query-docs"
    ) {
      context7Used = true;
      return;
    }

    if (invokedToolName === "web_search" && !context7Used) {
      return {
        block: true,
        reason:
          "You MUST try Context7 before using web_search, regardless of whether you think it applies." +
          "Do not use other tools to bypass this rule.",
      };
    }
  });
}
