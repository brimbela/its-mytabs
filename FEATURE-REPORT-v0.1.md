# Feature Verification Report (v0.1)

- App: It's MyTabs **1.7.0** (latest release, 14 Aug 2026), fork `brimbela/its-mytabs`, branch `mac-v0.1`
- Mac: Apple Silicon, macOS 26 (Darwin 25.5), Deno 2.9.8 via Homebrew, Chrome
- Date: 22 Oct 2026

## How this was tested

1. **The project's own automated test suite** (Playwright, 95 browser tests in Chromium): **94 passed, 0 failed, 1 skipped**.
   The skipped test is the AI stem separation run, which needs a ~230 MB model download.
2. **Hands-on checks** in Chrome and headless Chromium with test files:
   - alphaTab's own MIT-licensed sample files: `.gp5`, `.gpx`, `.gp3`, `.gp4`, `.xml`
   - a 5-string bass MusicXML file and a 100 bpm click-track MP3, both generated for this test
   - the demo tab that ships with the app (`.gp`)

No tabs were downloaded from tab websites.

## Results: section 3.1 step 2

| Feature | Result | Notes |
| --- | --- | --- |
| Load Guitar Pro files (.gp, .gpx, .gp3, .gp4, .gp5) | **Works** | All five formats uploaded and rendered. |
| Load MusicXML | **Partially** | Works only if the file ends in `.musicxml`. Files ending in `.xml` are rejected ("Unsupported file format"). Compressed `.mxl` (common on MuseScore) is not supported. Workaround for `.xml`: rename to `.musicxml`. |
| Bass tab renders, 4-string | **Works** | Electric Bass track in a multi-track `.gp5` rendered as 4-line tab. |
| Bass tab renders, 5-string | **Works** | 5-line tab with B string, labelled "Bass 5-str". |
| MIDI synth playback | **Works, with one Mac caveat** | Plays and the cursor moves (automated tests). **On this Mac it stalled** because the current Bluetooth headphones are in 16 kHz "call" mode. I reproduced it: at 16 kHz the synth never starts, at 44.1 kHz it plays. MP3 and YouTube are not affected. Workaround in README-MAC.md section 7. |
| Mute / solo tracks | **Works** | Track list (bottom left) has Solo, Mute and Volume per track (automated tests). Mute the bass, view the bass tab, hear the rest. |
| Sync to local audio (.mp3, .ogg) | **Works** | MP3 attached, first-bar offset set, cursor matched the audio to within 10 ms. `.flac` is also accepted. |
| Sync to YouTube | **Works** | Automated test: video loads, is selectable and plays. Needs `localhost` (the launcher uses it). Not tested by hand with a real song. |
| Cursor modes | **Works** | Settings page: No Cursor, Cursor (Smooth), Cursor (Instant), Bar (highlights the current bar). All four checked while playing. |
| Keyboard shortcuts in README | **Works** | Space, Left, Right, Up, S (automated tests). |
| **[Unverified]** Tab list / library screen | **Exists (Partially for your v0.2 needs)** | Home page lists all tabs grouped by artist, with search, a Favourites column and a Recently opened column. Each tab is a folder `data/tabs/<id>/` with the tab file, audio and `config.json`. Missing vs 4.3: status (To learn / Learning / Learned), status filter, visible "last practised" date (the app already records `lastAccessAt`, it just doesn't show it), last used speed shown in the list. |
| **[Unverified]** Playback speed | **Works** | Speed box (20% to 1000%). Applies to MIDI and to MP3: at 50% the MP3 ran at half speed with pitch preserved and the cursor stayed on the right bar. Saved per song (in the browser). YouTube speed is also passed to the player. |
| **[Unverified]** Section looping | **Works** | Drag across bars to select a range (with handles to adjust it and an X to clear it), then press Loop. Checked with MP3 audio: bars 2 to 3 looped correctly. Loop combined with a changed speed was not tested by hand. |

## Acceptance criteria (3.2)

| Criterion | Result |
| --- | --- |
| Double-click something and the app opens in the browser | **Met**: `start.command` (tested: starts, opens browser, "already running" case, `stop.command`) |
| Load a free GP bass tab, mute the bass, play, follow the cursor | **Met**, with the Bluetooth caveat above for MIDI playback |
| Attach an MP3, cursor follows after syncing the first bar | **Met** |
| Report says which v0.2 items already exist | See below |

## What this means for v0.2

| v0.2 item | Status | Suggestion |
| --- | --- | --- |
| 4.1 Playback speed | **Already present** | Nothing to build. Optional: preset buttons (50/60/75/90/100%) next to the box. |
| 4.2 Section looping | **Already present** | Nothing to build. |
| 4.3 Song library | **Partial** | Add status + filter, show last practised date and last speed. Status would be a new field in each tab's `config.json`, which is a change to the storage format, so I'll ask before doing it. |
| 4.4 Spotify | **Missing** | Investigate and report first, as the brief says. |
| 4.5 YouTube audio without video | **Missing** | Report options first, as the brief says. |
| 4.6 Native Mac app | **Optional** | Only if `start.command` isn't good enough for you. |

## Things in the brief that turned out different

1. **"No accounts" vs the app.** The app always requires a login and creates an admin account on first start. It's local only (stored in `data/config.db`), but it is a login screen every time the session expires. Proposal: leave it for now (it's harmless and removing it touches upstream auth code). If it annoys you, a v0.2 item could add an auto-login option for local use.
2. **MusicXML** only works as `.musicxml`, not `.xml` or `.mxl` (see table). Small possible fix: accept `.xml` and unzip `.mxl` on upload.
3. **Bonus feature not in the brief:** the app can use AI (Demucs) to split an MP3 into bass, drums and guitar stems, or create a copy of the song **with the bass removed**. That's the MP3 equivalent of muting the bass track. It downloads ~230 MB on first use (it asks first). Not tested yet; worth trying.
4. **Some settings live in the browser**, not in `data/` (Settings page, per-song speed and loop). Using a different browser means starting those again.
5. The launcher binds the app to `127.0.0.1` so it isn't reachable from other devices on your network (by default the app listens on all network interfaces).
