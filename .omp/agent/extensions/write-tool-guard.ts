import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const MARKDOWN_PATTERNS = [
  { re: /^# /m, msg: "H1 headings (# Title) are not allowed" },
  {
    re: /^#+ \d/m,
    msg: "Numbered headings (# 1., ## 1.1., etc.) are not allowed",
  },
  { re: /^\s*- \*\*.*\*\*/m, msg: "The '- **...**' pattern is not allowed" },
];

const COMMENT_MAP: Record<string, string> = {
  java: "//",
  ts: "//",
  js: "//",
  rs: "//",
  py: "#",
  lua: "--",
};

export default function markdownStyleGuard(pi: ExtensionAPI) {
  pi.on("tool_call", (event) => {
    const { toolName, input } = event;
    if (toolName !== "write") return;

    const filePath = String(input.path ?? input.file_path ?? "");
    const content = String(input.content ?? "");
    if (!content) return;

    if (filePath.endsWith(".md")) {
      for (const { re, msg } of MARKDOWN_PATTERNS) {
        if (re.test(content)) return { block: true, reason: msg };
      }
      return;
    }

    const ext = filePath.split(".").pop();
    const comment = ext && COMMENT_MAP[ext];
    if (comment) {
      const repeatRegex = new RegExp(
        `^\\s*${comment}\\s+(\\w+): .+\\n\\s*${comment}\\s+\\1:`,
        "m",
      );
      if (repeatRegex.test(content)) {
        return {
          block: true,
          reason:
            "Repeating the same label (e.g., NOTE:) on consecutive comment lines is forbidden. Write the label only once, then indent subsequent lines.",
        };
      }
    }
  });
}
