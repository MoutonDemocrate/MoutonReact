#!/bin/bash

# For every file in the current directory

for file in *; do
    echo "Processing $file"
    # If file is a .jpg
    if [[ $file == *.jpg ]]; then
        # Show the image in terminal using icat
        kitten icat $file
        # Ask user for new name
        name=$(zenity --entry --title="Rename Image" --text="Enter new name for $file (without extension):")
        # If user didn't provide name, exit the for loop and end the script
        if [[ -z $name ]]; then
            echo "No name provided, ending renaming script"
            break
        fi
        # Rename the file
        mv "$file" "${name}.jpg"
        echo "Renamed $file to ${name}.jpg"
    fi
done