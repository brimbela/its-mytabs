# It's MyTabs on macOS (personal setup)

This is a fork of [It's MyTabs](https://github.com/louislam/its-mytabs) by Louis Lam (MIT License), set up to run on a Mac.
The original project README is in [README.md](README.md). Feature test results are in [FEATURE-REPORT-v0.1.md](FEATURE-REPORT-v0.1.md).

## 1. One-time install

You only do this once. Open the **Terminal** app and paste these lines one at a time.

1. Install Homebrew (skip if you already have it, check with `brew --version`): see https://brew.sh
2. Install Deno (the program that runs the app):

   ```bash
   brew install deno
   ```

3. Get the app (skip if this folder already exists on your Mac):

   ```bash
   git clone https://github.com/brimbela/its-mytabs.git ~/personal/bass-learning-app
   ```

That's it. The first time you start the app it builds itself (takes about a minute).

## 2. Start and stop

- **Start:** in Finder, open the app folder and double-click **`start.command`**.
  A Terminal window opens, and your browser opens at http://localhost:47777 once the app is ready.
  Keep that Terminal window open while you practise (you can minimise it).
- **Stop:** close the Terminal window, or press `Ctrl+C` in it. If you closed it some other way and the app is still running, double-click **`stop.command`**.
- If you double-click `start.command` while the app is already running, it just opens the browser.

Tip: drag `start.command` to the right side of your Dock to start the app with one click.

If macOS says the file "cannot be opened", right-click it, choose **Open**, then **Open** again. macOS remembers this.

### First start: create your login

The app always has a login screen. The first time, it asks you to create an admin account (email + password).
This account only exists on your Mac, in the app's database. Nothing is sent anywhere.

The app only listens on this Mac (`127.0.0.1`), so other devices on your Wi-Fi cannot open it.

## 3. Add a tab

1. Click **New Tab** at the top.
2. Choose a file: `.gp`, `.gpx`, `.gp3`, `.gp4`, `.gp5`, `.musicxml` or `.capx`.
3. Enter the title and artist, then save.

MusicXML files must end in `.musicxml`. If you have a file ending in `.xml`, rename it to `.musicxml` first.
Compressed MusicXML (`.mxl`) is not accepted (see the feature report).

Where to find free tabs: Ultimate Guitar, GProTab, MuseScore (free downloads), 911Tabs.

## 4. Attach an MP3 and sync it

1. Open the tab, click **Audio** in the bottom bar, then **Add Youtube or Audio File...**
2. Under **Audio files**, pick your `.mp3`, `.ogg` or `.flac` file and click **Upload**.
3. Go back to the tab, click **Audio** and choose your file.
4. Set **Sync Offset** (above the audio player) to the second where bar 1 starts in the song, for example `1.5`.
   Press **Play** and adjust in steps of 0.1 s until the cursor lines up. The value is saved automatically.
   Tip: in **Settings**, choose **Cursor (Instant)** while syncing, it makes timing errors easier to see.

If the tempo changes during the song, use the **Advanced** sync method on the audio edit page instead.

## 5. Practising

| What | How |
| --- | --- |
| Hear the song without the bass | Click the track name (bottom left), then **Mute** on the bass track. Works with the built-in MIDI sound. |
| Show the bass tab | Click the track name, then click the bass track's name. |
| Slow down | Type a value in **Speed** (for example 60). Works for MIDI and MP3, pitch stays the same. |
| Loop a section | Drag across bars on the tab to select them, then press **Loop**. Close the selection with its X button. |
| Count in | **Count in** button. |
| Keyboard | `Space` play/pause, `←` `→` previous/next bar, `↑` restart from the selection start, `S` jump to the first bar with notes. |

**Removing the bass from an MP3:** on the audio edit page each MP3 has buttons to separate it into stems or mute the bass using AI.
The first time, it downloads about 230 MB of model files and asks you first. This was not tested yet.

## 6. Where your data is stored (backup)

Everything is in the **`data`** folder inside the app folder:

| Path | What |
| --- | --- |
| `data/tabs/1/`, `data/tabs/2/`, ... | One folder per tab: the tab file, your attached audio files, and `config.json` (title, artist, favourite, last opened, sync settings, YouTube links) |
| `data/config.db` | Your login and app settings saved with **Save to Server** |

To back up: quit the app, then copy the whole `data` folder somewhere safe (for example iCloud Drive).
To restore: quit the app and put the `data` folder back.

Some preferences are stored **in your browser**, not in the `data` folder: the Settings page (cursor style, colours, etc.)
and per-song speed and loop. Settings can be saved into the `data` folder with **Save to Server** on the Settings page.

## 7. Audio over Bluetooth (important)

If your Bluetooth headphones also have a microphone, macOS can switch them into a low-quality "call" mode (16 kHz).
In that mode **the built-in MIDI playback does not start** (the cursor stays on bar 1). MP3 and YouTube playback still work.

Fix: open **System Settings > Sound > Input** and select **MacBook microphone** (not the headphones). Then reload the page.
To check: open the **Audio MIDI Setup** app and select your headphones. The output format should be 44.1 kHz or 48 kHz, not 16 kHz.

The SONICAKE QAP-50 is a Bluetooth receiver without a microphone, so it should not have this problem.

## 8. Updating the app

In Terminal, inside the app folder:

```bash
git pull
deno task setup
```

## 9. Credits

It's MyTabs is made by Louis Lam and released under the MIT License (see [LICENSE](LICENSE)).
Tab rendering and playback by [alphaTab](https://github.com/CoderLine/alphaTab).
