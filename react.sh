#!/bin/bash

# Ensure wofi and wl-copy are installed
if ! command -v wofi &> /dev/null; then
    echo "wofi is not installed. Please install wofi first."
    exit 1
fi

if ! command -v wl-copy &> /dev/null; then
    echo "wl-copy is not installed. Please install wl-clipboard first."
    exit 1
fi

# Directory containing images
directory=~/Pictures/MoutonReact

# Make sure the directory path is absolute
directory=$(realpath "$directory")

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory $directory does not exist."
    exit 1
fi

# Use wofi to select an image
selected=$(for img in "$directory"/*.jpg; do
    img_path=$(realpath "$img")
    base_name=$(basename "$img" .jpg)
    printf "%s\0icon\x1f%s\n" "$base_name" "$img_path"
done | wofi --matching=fuzzy -i -s ~/.config/wofi/mouton.css -p="What reaction image are we looking for ?" --normal-window --show dmenu --allow-images --allow-markup --Dimage_size=256 --define dynamic_lines=true)

# If a selection was made
if [ -n "$selected" ]; then
    # Find the image that matches the selected base_name
    for img in "$directory"/*.jpg; do
        base_name=$(basename "$img" .jpg)
        if [ "$base_name" = "$selected" ]; then
            # Copy the image to the clipboard using wl-copy
            if wl-copy --type image/png < "$img"; then
                echo "Copied $img to clipboard."
            else
                echo "Failed to copy $img to clipboard."
            fi
            break
        fi
    done
else
    echo "No image selected."
fi