import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { existsSync } from "fs";

function detectSkill(): string {
  const cwd = process.cwd();
  if (existsSync(cwd + "/.git")) return "grill-with-docs";
  if (existsSync(cwd + "/.omp/CONTEXT.md")) return "grill-with-docs";
  if (existsSync(cwd + "/.omp/CONTEXT-MAP.md")) return "grill-with-docs";
  return "grilling";
}

export default function (pi: ExtensionAPI) {
  let grillingEnabled = false;

  pi.on("session_start", (_event, ctx) => {
    const sessionFile = ctx.sessionManager.getSessionFile();
    grillingEnabled = !sessionFile || !existsSync(sessionFile);
  });

  pi.on("session_switch", (event: { reason: string }) => {
    grillingEnabled = event.reason === "new";
  });

  pi.on("input", (event: { text?: string }) => {
    const text = event.text ?? "";
    if (!grillingEnabled) return;
    grillingEnabled = false;
    if (text.startsWith("/")) return;
    const skill = detectSkill();
    return { text: `/skill:${skill} ${text}` };
  });
}
