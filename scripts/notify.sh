#!/bin/bash
# Task Complete Notification Script
# Plays custom notification sound and displays system notification

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
AUDIO_FILE="$SKILL_DIR/assets/notification.aiff"

# Default message
MESSAGE="${1:-任务已完成}"
TITLE="${2:-OpenClaw}"

# Play custom notification sound
if [ -f "$AUDIO_FILE" ]; then
    afplay "$AUDIO_FILE"
else
    echo "Warning: Audio file not found at $AUDIO_FILE" >&2
    # Fallback to system sound
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Glass\""
    exit 0
fi

# Display system notification (silent since we already played sound)
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
