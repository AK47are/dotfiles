let lastBeep = 0;

function canBeep(): boolean {
  const now = Date.now();
  if (now - lastBeep >= 10000) {
    lastBeep = now;
    return true;
  }
  return false;
}

export default function (pi) {
  pi.on("agent_end", (event, ctx) => {
    if (canBeep()) {
      pi.exec("powershell", ["-NoProfile", "-Command", "[Console]::Beep()"]);
    }
  });

  pi.on("tool_call", (event, ctx) => {
    if (event.toolName === "ask" && ctx.hasUI && canBeep()) {
      pi.exec("powershell", ["-NoProfile", "-Command", "[Console]::Beep()"]);
    }
  });
}
