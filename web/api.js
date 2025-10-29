const BASE_DEFAULT = "https://YOUR-RENDER-URL.onrender.com"; // TODO: set your live API

document.addEventListener("DOMContentLoaded", () => {
  const baseInput = document.getElementById("base-url");
  const testButton = document.getElementById("test-status");
  const statusPill = document.getElementById("status-pill");
  const statusMeta = document.getElementById("status-meta");
  const codeBlocks = Array.from(document.querySelectorAll("code[data-template]"));
  const dynamicLinks = document.querySelectorAll("a[data-dynamic]");

  const storedBase = window.localStorage.getItem("ld_api_base");
  const initialBase = sanitizeBase(storedBase || BASE_DEFAULT);
  baseInput.value = initialBase;

  codeBlocks.forEach((block) => {
    block.dataset.original = block.textContent;
  });

  const applyBase = (baseValue) => {
    const sanitized = sanitizeBase(baseValue);
    baseInput.value = sanitized;
    window.localStorage.setItem("ld_api_base", sanitized);

    codeBlocks.forEach((block) => {
      const template = block.dataset.original || "";
      block.textContent = template.replace(/\{\{BASE\}\}/g, sanitized);
    });

    dynamicLinks.forEach((link) => {
      const type = link.dataset.dynamic;
      if (type === "docs") {
        link.href = `${sanitized}/docs`;
      } else if (type === "openapi") {
        link.href = `${sanitized}/openapi.json`;
      }
    });
  };

  const handleInput = () => {
    applyBase(baseInput.value);
  };

  baseInput.addEventListener("change", handleInput);
  baseInput.addEventListener("blur", handleInput);

  applyBase(initialBase);

  testButton.addEventListener("click", async () => {
    const base = sanitizeBase(baseInput.value);
    applyBase(base);
    statusMeta.textContent = "Testing…";
    statusPill.textContent = "Checking";
    statusPill.classList.remove("ok", "bad");

    try {
      const response = await fetch(`${base}/status`, { cache: "no-store" });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const payload = await response.json();
      statusPill.textContent = "Online";
      statusPill.classList.add("ok");
      statusPill.classList.remove("bad");

      const version = payload.version ? `v${payload.version}` : "";
      const time = payload.serverTime || payload.time || payload.timestamp || "";
      const pieces = [version, time].filter(Boolean);
      statusMeta.textContent = pieces.length ? pieces.join(" • ") : "Healthy";
    } catch (error) {
      statusPill.textContent = "Offline";
      statusPill.classList.add("bad");
      statusPill.classList.remove("ok");
      statusMeta.textContent = error.message || "Unable to reach API";
    }
  });
});

function sanitizeBase(value) {
  if (!value) return BASE_DEFAULT;
  const trimmed = value.trim();
  if (!trimmed) return BASE_DEFAULT;
  return trimmed.replace(/\/+$/, "");
}
