import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const CONTEXT7_TOOLS: Record<string, true> = {
  "resolve-library-id": true,
  "query-docs": true,
};

const FORBID_BYPASS =
  "If you cannot comply, ask the user for permission. Remember: do not bypass rules.";

export default function context7FirstGuard(pi: ExtensionAPI) {
  let context7Used = false;

  pi.on("tool_call", (event) => {
    const { toolName } = event;

    if (CONTEXT7_TOOLS[toolName]) {
      context7Used = true;
      return;
    }

    if (toolName === "web_search" && !context7Used) {
      return {
        block: true,
        reason:
          "You MUST try Context7 tools (resolve-library-id, query-docs) before using web_search. If Context7 yields no useful results, then web_search is permitted. " +
          FORBID_BYPASS,
      };
    }
  });
}
