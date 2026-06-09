import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const FORBID_BYPASS =
  "If you cannot comply, ask the user for permission. Remember: do not bypass rules.";

const MARKDOWN_PATTERNS = [
  {
    re: /^# /m,
    msg: "H1 headings (# Title) are not allowed. The filename serves as the implicit H1, and the content must not repeat the filename as a heading (whether with # or ##).",
  },
  {
    re: /^#+ \d/m,
    msg: "Numbered headings (# 1., ## 1.1., etc.) are not allowed.",
  },
  {
    re: /^#+ .{20,}/m,
    msg: "Heading is too long (max 20 characters).",
  },
  {
    re: /^\s*(?:-|\d+\.) \*\*.*?\*\*/m,
    msg: "The pattern '- **...**' or '1. **...**' (bold text in a list item) is not allowed.",
  },
  { re: /^\s*---+\s*$/m, msg: "Horizontal rule '---' is not allowed." },
];

const MD_RULES_REMINDER =
  "Violation of global Markdown style specification. Please revisit the Markdown style rules already provided to you. Review your output against each of those rules, correct any violations, and ensure full compliance.";

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

    const violations: string[] = [];

    // Markdown 样式检查
    if (filePath.endsWith(".md")) {
      let hasViolation = false;
      for (const { re, msg } of MARKDOWN_PATTERNS) {
        if (re.test(content)) {
          violations.push(msg);
          hasViolation = true;
        }
      }
      if (hasViolation) {
        violations.unshift(MD_RULES_REMINDER);
      }
    }

    // 代码文件注释重复标签检查
    const ext = filePath.split(".").pop();
    const comment = ext && COMMENT_MAP[ext];
    if (comment) {
      const repeatRegex = new RegExp(
        `^\\s*${comment}\\s+(\\w+): .+\\n\\s*${comment}\\s+\\1:`,
        "m",
      );
      if (repeatRegex.test(content)) {
        violations.push(
          "Repeating the same label (e.g., NOTE:) on consecutive comment lines is forbidden. Write the label only once, then indent subsequent lines.",
        );
      }
    }

    if (violations.length > 0) {
      const reason = violations.join(" ") + " " + FORBID_BYPASS;
      return { block: true, reason };
    }
  });
}
