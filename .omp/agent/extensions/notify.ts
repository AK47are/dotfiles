let beepTimer = null;

function scheduleBeep(pi) {
  if (beepTimer) {
    clearTimeout(beepTimer);
  }
  beepTimer = setTimeout(() => {
    pi.exec("powershell", ["-NoProfile", "-Command", "[Console]::Beep()"]);
    beepTimer = null;
  }, 10000);
}

export default function (pi) {
  pi.on("agent_end", (event, ctx) => {
    if (!ctx.hasUI) return;
    scheduleBeep(pi);
  });

  pi.on("tool_call", (event, ctx) => {
    if (event.toolName === "ask" && ctx.hasUI) {
      scheduleBeep(pi);
    }
  });
}
