#!/bin/zsh
# Double-click this file in Finder to start It's MyTabs and open it in your browser.
# Keep the Terminal window open while you practise. Close it (or press Ctrl+C) to stop the app.

cd "$(dirname "$0")" || exit 1

# Make sure Homebrew tools (deno) are found even if the shell profile does not set PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

PORT=47777
URL="http://localhost:$PORT"

if ! command -v deno >/dev/null 2>&1; then
    echo "Deno is not installed. Install it with:  brew install deno"
    echo "Then double-click start.command again."
    read -k 1 "?Press any key to close..."
    exit 1
fi

# Already running? Just open the browser.
if curl -s -o /dev/null "$URL"; then
    echo "It's MyTabs is already running. Opening $URL"
    open "$URL"
    exit 0
fi

# First run (or after an update): install dependencies and build the web UI
if [ ! -f dist/index.html ]; then
    echo "First start: building the app. This takes a minute..."
    deno task setup || { read -k 1 "?Setup failed. Press any key to close..."; exit 1; }
fi

# Keep everything local to this Mac: only listen on this computer, store data in ./data
export MYTABS_HOST=127.0.0.1
export MYTABS_PORT=$PORT
export DATA_DIR="$PWD/data"

# Open the browser as soon as the server answers
(
    for i in {1..60}; do
        if curl -s -o /dev/null "$URL"; then
            open "$URL"
            exit 0
        fi
        sleep 1
    done
) &

echo "Starting It's MyTabs on $URL"
echo "Your tabs and audio are stored in: $DATA_DIR"
echo "To stop the app, close this window or press Ctrl+C."
echo
deno task start
