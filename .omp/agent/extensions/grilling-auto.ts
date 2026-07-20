/**
 * Auto-Grilling Extension
 */
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
  let grillingEnabled = true;
  let firstTurnPending = true;

  pi.on("session_start", () => {
    firstTurnPending = true;
  });

  pi.on("input", (event: { text?: string }) => {
    if (!grillingEnabled || !firstTurnPending) return;
    if (event.text?.startsWith("/")) return;
    firstTurnPending = false;
    const skill = detectSkill();
    return { text: `/skill:${skill} ${event.text}` };
  });

  pi.registerCommand("grilling-off", {
    description: "Disable auto-grilling",
    handler: () => {
      grillingEnabled = false;
    },
  });
}
