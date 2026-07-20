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

  pi.on("session_start", (event: { type: string; reason?: string }) => {
    if (event.reason !== "startup" && event.reason !== "new") return;
    firstTurnPending = true;
  });

  pi.on("input", (event: { text?: string }) => {
    const text = event.text ?? "";

    // /grilling-off [rest] → disable, rest goes through normal routing
    if (text.startsWith("/grilling-off")) {
      grillingEnabled = false;
      firstTurnPending = false;
      const rest = text.slice("/grilling-off".length).trimStart();
      return { text: rest };
    }

    // First non-command input → inject skill
    if (!grillingEnabled || !firstTurnPending) return;
    if (text.startsWith("/")) return;
    firstTurnPending = false;
    const skill = detectSkill();
    return { text: `/skill:${skill} ${text}` };
  });

  // Register for TUI autocomplete only
  pi.registerCommand("grilling-off", {
    description: "Disable auto-grilling for the current session",
    handler: () => {},
  });
}
