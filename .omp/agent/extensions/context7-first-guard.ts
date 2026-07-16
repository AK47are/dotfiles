import type { ExtensionAPI, ToolCallEvent } from "@earendil-works/pi-coding-agent";

const FORBID_BYPASS =
  "If you cannot comply, ask the user for permission. Remember: do not bypass rules.";

export default function context7FirstGuard(pi: ExtensionAPI) {
  let context7Used = false;

  pi.on("tool_call", (event: ToolCallEvent) => {
    const invokedToolName =
      event.toolName === "write"
        ? /^xd:\/\/(.+)/.exec(String(event.input.path ?? ""))?.[1]
        : event.toolName;

    if (invokedToolName === "resolve-library-id" || invokedToolName === "query-docs") {
      context7Used = true;
      return;
    }

    if (invokedToolName === "web_search" && !context7Used) {
      return {
        block: true,
        reason:
          "You MUST try Context7 tools (resolve-library-id, query-docs) before using web_search. If Context7 yields no useful results, then web_search is permitted. " +
          FORBID_BYPASS,
      };
    }
  });
}
