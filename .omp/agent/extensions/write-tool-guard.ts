import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const FORBID_BYPASS =
  "If the current warning conflicts with requirements given earlier in this conversation, ask the user promptly; " +
  "do not decide based on whether you can apply the rule. Remember: do not bypass rules.";

type MarkdownPattern = {
  re: RegExp;
  msg: string | ((match: RegExpMatchArray, line: string) => string);
};

const MARKDOWN_PATTERNS: MarkdownPattern[] = [
  {
    re: /^# /gm,
    msg: "H1 headings (# Title) are not allowed. The filename serves as the implicit H1, and the content must not repeat the filename as a heading (whether with # or ##).",
  },
  {
    re: /^#+ \d/gm,
    msg: "Numbered headings (# 1., ## 1.1., etc.) are not allowed.",
  },
  {
    re: /^#+ .{20,}/gm,
    msg: (_match, line) => {
      const headingText = line.replace(/^#+\s+/, "");
      return `Heading is too long (max 20 characters). The offending line is "${line}", whose heading text (after the '# ' markers) is ${headingText.length} characters; shorten it to 19 characters or fewer.`;
    },
  },
  {
    re: /^\s*(?:-|\d+\.) \*\*.*?\*\*/gm,
    msg: "The pattern '- **...**' or '1. **...**' (bold text in a list item) is not allowed.",
  },
  { re: /^\s*---+\s*$/gm, msg: "Horizontal rule '---' is not allowed." },
];

/** Strip YAML frontmatter (--- ... ---) from the beginning of content.
 *  Returns the body after the closing ---, or the original content if no frontmatter found. */
function stripFrontmatter(content: string): string {
  const lines = content.split("\n");
  let firstNonEmpty = -1;
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim() !== "") {
      firstNonEmpty = i;
      break;
    }
  }
  if (firstNonEmpty < 0 || !/^\s*---+\s*$/.test(lines[firstNonEmpty])) {
    return content;
  }
  for (let i = firstNonEmpty + 1; i < lines.length; i++) {
    if (/^\s*---+\s*$/.test(lines[i])) {
      return lines.slice(i + 1).join("\n");
    }
  }
  return content;
}
/** Collect markdown style violations. For long headings, the message
 *  names the whole offending line and its heading text length. */
function checkMarkdown(body: string): string[] {
  const violations: string[] = [];
  for (const { re, msg } of MARKDOWN_PATTERNS) {
    for (const match of body.matchAll(re)) {
      const lineStart = match.index!;
      const lineEnd = body.indexOf("\n", lineStart);
      const line =
        lineEnd === -1 ? body.slice(lineStart) : body.slice(lineStart, lineEnd);
      violations.push(typeof msg === "function" ? msg(match, line) : msg);
    }
  }
  return violations;
}

const MD_RULES_REMINDER = "Violation of global Markdown style specification.";

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
    const violations: string[] = [];

    // Markdown 样式检查
    if (filePath.endsWith(".md")) {
      const body = stripFrontmatter(content);
      const mdViolations = checkMarkdown(body);
      if (mdViolations.length > 0) {
        violations.push(MD_RULES_REMINDER, ...mdViolations);
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
      const reason = [...new Set(violations)].join(" ") + " " + FORBID_BYPASS;
      return { block: true, reason };
    }
  });
}
