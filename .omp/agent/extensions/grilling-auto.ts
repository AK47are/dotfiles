import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

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
    return { text: `/skill:grilling ${event.text}` };
  });

  pi.registerCommand("grilling-off", {
    description: "Disable auto-grilling",
    handler: () => {
      grillingEnabled = false;
    },
  });
}
