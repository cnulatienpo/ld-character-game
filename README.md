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
