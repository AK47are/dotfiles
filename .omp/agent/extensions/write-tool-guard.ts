import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

const FORBID_BYPASS =
  "Remember don't bypass this rule. If you cannot comply, ask the user for permission.";

const MARKDOWN_PATTERNS = [
  { re: /^# /m, msg: "H1 headings (# Title) are not allowed." },
  {
    re: /^#+ \d/m,
    msg: "Numbered headings (# 1., ## 1.1., etc.) are not allowed.",
  },
  {
    re: /^\s*- \*\*.*\*\*[:：] /m,
    msg: "The pattern '- **...**' (bold text followed in a list item) is not allowed.",
  },
  { re: /^\s*---+\s*$/m, msg: "Horizontal rule '---' is not allowed." },
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

    const violations: string[] = [];

    // Markdown 样式检查
    if (filePath.endsWith(".md")) {
      for (const { re, msg } of MARKDOWN_PATTERNS) {
        if (re.test(content)) violations.push(msg);
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
