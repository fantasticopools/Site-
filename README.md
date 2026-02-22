Fantastico Pools — Static Site build & deploy
=============================================

Overview
--------
This repository is a static site. Editable content lives in `data.json`. The included `build.js` reads `data.json`, injects content into `index.html`, and copies assets into `dist/`.

Quick workflow (admin)
----------------------
1. Edit content
   - Update texts, reorder items, add/remove showcase entries in `data.json`.
   - Place images in `webp/` (or root for videos/thumbnails) and reference them from `data.json`.

2. Build (produces `dist/`)

```powershell
# or using npm script
npm run build
```

Additional helper scripts
-------------------------
Two Windows batch helpers are available and exposed as npm scripts to make common media tasks easier for the admin:

- `npm run regenerate-thumbs` — runs `regenerate_thumbnails.bat` to recreate image thumbnails.
- `npm run convert-videos` — runs `convert_videos.bat` to transcode / prepare video assets.

Run them from the project root (Windows PowerShell or CMD):

```powershell
npm run regenerate-thumbs
npm run convert-videos
```

If you need cross-platform equivalents (Linux/macOS), I can add small Node wrappers that call the appropriate shell script on non-Windows systems.

3. Deploy
   - Upload the contents of `dist/` to any static host (the entire folder, not the repository root).

Editing content (end-user/editor)
---------------------------------
- Non-technical editors: give them the `data.json` file or create a tiny UI that edits `data.json` and uploads images to the repository before building.
- After changes are made, run the build and re-deploy the `dist/` folder.