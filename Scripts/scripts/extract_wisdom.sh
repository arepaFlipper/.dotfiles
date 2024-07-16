#!/home/cris/.nix-profile/bin/zsh

# Check if yt-dlp is installed
if ! command -v yt-dlp &>/dev/null; then
  echo "yt-dlp is not installed. Please install it first."
  exit 1
fi

# Check if yt-transcript is installed
if ! command -v yt &>/dev/null; then
  echo "yt is not installed. Please install it first."
  exit 1
fi

# Check if a URL was provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <youtube-video-url>"
  exit 1
fi

# Extract the title using yt-dlp
video_title=$(yt-dlp --get-title "$1")

# Check if yt-dlp succeeded
if [ $? -ne 0 ]; then
  echo "Failed to retrieve the video title."
  exit 1
fi

# Extract the channel name using yt-dlp
channel_name=$(yt-dlp --print channel "$1")

# Check if yt-dlp succeeded
if [ $? -ne 0 ]; then
  echo "Failed to retrieve the channel name."
  exit 1
fi

# Process the title to create a suitable filename
if [ -n "$video_title" ]; then
  suffix=$(echo "$video_title" | sed 's/ /-/g' | sed 's/[^a-zA-Z0-9-]//g' | tr '[:upper:]' '[:lower:]')
else
  suffix=""
  for _ in {1..4}; do
    suffix="${suffix}$(tr -cd 'A-Z' </dev/urandom | head -c 1)"
  done
fi

# Create the .md filename with timestamp
filename="$(date +%s)-$suffix.md"
filepath="$VAULT/0-Inbox/$filename"

# Fetch the transcription using yt-transcript
transcription=$(yt --transcript "$1")

# Check if yt-transcript succeeded
if [ $? -ne 0 ]; then
  echo "Failed to retrieve the video transcription."
  transcription="Transcription could not be fetched."
fi

# Create the .md file and include the specified content
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
This video was produced by $channel_name



## RESOURCES
- [video]($1)

## TRANSCRIPTION
$transcription
EOL

# Run fabric command and append output
tempfile=$(mktemp)

cat "$filepath" | fabric --model "gpt-3.5-turbo" -sp extract_wisdom >"$tempfile"

sed -i '12r '"$tempfile" "$filepath"
rm "$tempfile"

# Output the filename
echo "Created file: $filename"
