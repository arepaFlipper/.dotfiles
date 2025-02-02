#!/bin/zsh

# Ensure required dependencies are installed
if ! command -v yt-dlp &>/dev/null; then
  echo "yt-dlp is not installed. Please install it first."
  exit 1
fi

if ! command -v yt &>/dev/null; then
  echo "yt-transcript (yt) is not installed. Please install it first."
  exit 1
fi

# Check if a URL was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <youtube-video-url>"
  exit 1
fi

VIDEO_URL="$1"

# Extract the video title using yt-dlp
video_title=$(yt-dlp --get-title "$VIDEO_URL")

if [ $? -ne 0 ]; then
  echo "Failed to retrieve the video title."
  exit 1
fi

# Extract the channel name using yt-dlp
channel_name=$(yt-dlp --print channel "$VIDEO_URL")

if [ $? -ne 0 ]; then
  echo "Failed to retrieve the channel name."
  exit 1
fi

# Generate a suitable filename
safe_title=$(echo "$video_title" | sed 's/ /-/g' | sed 's/[^a-zA-Z0-9-]//g' | tr '[:upper:]' '[:lower:]')
filename="$(date +%s)-${safe_title}.md"
filepath="$VAULT/0-Inbox/$filename"

# Fetch the transcription using yt-transcript
transcription=$(yt --transcript "$VIDEO_URL")

if [ $? -ne 0 ]; then
  echo "Failed to retrieve the video transcription."
  transcription="Transcription could not be fetched."
fi

# Create the .md file with metadata, resources, and analysis section
cat <<EOL >"$filepath"
---
id: ${filename%.md}
aliases:
  - $video_title
tags:
  - youtube
  - pending
---

# $video_title
This video was produced by $channel_name.

## RESOURCES
- [video]($VIDEO_URL)

EOL

# Call fabric to analyze and append the result after the "ANALYSIS RESULT" section
analysis=$(cat "$filepath" | fabric --model "gpt-3.5-turbo" -sp extract_wisdom)

echo -e "$analysis" >> "$filepath"

# Append the transcription after the analysis
cat <<EOL >>"$filepath"

## TRANSCRIPTION
$transcription
EOL

# Output the created file path
echo "Created file: $filename"

