# ld-character-game

## 🚀 Deploy to Render
1. Push this repository to your Git provider.
2. In Render, click **New → Web Service**.
3. Select this repository when prompted.
4. Confirm the build command (`pip install -r requirements.txt`) and start command (`uvicorn server.main:app --host 0.0.0.0 --port 8000`).
5. After deployment, copy the live service URL into `api_base()` in GameMaker.

## 🚀 Publish HTML5 build to GitHub Pages
1. Export from GameMaker: Target → HTML5 → Create Executable → choose an export folder (e.g., gms_export/HTML5/).
2. Stage the website:
   ```bash
   ./deploy_gms_html5.sh gms_export/HTML5/
   git push origin main
   ```
3. Enable Pages:
   - Repo → Settings → Pages
   - Source: "GitHub Actions"
4. After the first successful workflow run, your site will be at: https://<your-username>.github.io/<repo-name>/
5. Update your game’s API base URL (in GameMaker): set it to your Render API URL.
6. Cache gotcha: If updates don’t show, hard-refresh (Ctrl/Cmd+Shift+R).

## 📈 Telemetry

Anonymous telemetry events can be sent to the backend via `POST /api/telemetry`.
Payloads should match the following model:

```json
{
  "userId": "anon-user-123",
  "event": "session_start", // one of session_start, attempt, session_end, skip, heartbeat
  "version": "0.1.0",
  "timestamp": 1700000000,
  "meta": { "platform": "html5" }
}
```

Events are appended to `character_api/data/store/telemetry.jsonl`. To inspect a daily
summary run:

```bash
cd character_api
python -m server.telemetry_summary 2024-10-28  # omit the date for “today”
```

## Security & Observability
The API now applies stricter defaults for CORS and security headers. Configure trusted origins by setting the `ALLOWED_ORIGINS` environment variable (comma-separated). In development the API falls back to `*`, while production defaults to your GitHub Pages domain if no origins are provided.

Structured JSON request logs are emitted automatically; they include request metadata such as path, method, latency, and optional `x-user-id` values. Rate limiting support is available via SlowAPI—install it with `pip install slowapi` and keep `ENV=production` to activate the shared limiter.

A scheduled "Uptime Watchdog" workflow pings `/status` every five minutes. Store your deployed URL in the `API_BASE_URL` repository secret so the workflow can alert you by opening (or updating) an issue when downtime is detected.

## Testing & Release

### Running tests locally
1. Install dependencies:
   ```bash
   python -m pip install --upgrade pip
   pip install -r requirements.txt -r requirements-dev.txt
   ```
2. Execute the API test suite:
   ```bash
   pytest -q
   ```

### Running the k6 smoke test
Run the lightweight load test against your desired environment:
```bash
k6 run -e BASE=https://YOUR-RENDER-URL.onrender.com k6/smoke.js
```
Omit the `BASE` variable to target `http://localhost:8000` by default.

### Cutting a release
1. Create and push a semantic tag (the GitHub Actions workflow listens for `v*.*.*`):
   ```bash
   git tag v0.2.0
   git push origin v0.2.0
   ```
2. The release workflow will generate notes (pulling from `web/changelog.json` when available) and upload the lesson JSONL files as assets.

### Continuous integration
* **Pull requests & pushes** – Run the FastAPI pytest suite on Python 3.11 and trigger the k6 smoke test (the k6 job is allowed to fail on forks or when no external URL is configured).
* **Tags** – Build release notes and publish a GitHub Release with lesson data attached for reference.
