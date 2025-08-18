#!/bin/bash

# Standard icon directories
icon_dirs=(
    /usr/share/icons/hicolor
    /usr/share/icons
    /usr/share/pixmaps
    ~/.local/share/icons
)

resolve_icon_path() {
    local icon_name="$1"

    if [[ -f "$icon_name" ]]; then
        echo "$icon_name"
        return
    fi

    for dir in "${icon_dirs[@]}"; do
        result=$(find "$dir" -type f \( -name "${icon_name}.png" -o -name "${icon_name}.svg" \) 2>/dev/null | head -n1)
        if [[ -n "$result" ]]; then
            echo "$result"
            return
        fi
    done

    echo "$icon_name"
}

count=0
names=()
files_to_copy=()
icons=()

for file in "$@"; do
    if [[ -f "$file" ]]; then
        name=$(grep '^Name=' "$file" | head -n1 | cut -d'=' -f2-)
        icon=$(grep '^Icon=' "$file" | head -n1 | cut -d'=' -f2-)
        icon_path=$(resolve_icon_path "$icon")

        echo "File: $file"
        echo "Name: $name"
        echo "Icon: $icon_path"
        echo

        names+=("$name")
        files_to_copy+=("$file")
        icons+=("$icon_path")

        ((count++))
        if (( count >= 10 )); then
            break
        fi
    else
        echo "Skipping: $file (not found)"
    fi
done

if (( ${#names[@]} > 0 )); then
    # Folder name
folder_name=$(IFS=','; echo "${names[*]}")
folder_name="${folder_name//,/\, }"
safe_folder_name="${folder_name//\//-}"
mkdir -p "$safe_folder_name"


    # Copy .desktop files into folder
    for file in "${files_to_copy[@]}"; do
        cp "$file" "$safe_folder_name/"
    done

    echo "Created folder: $safe_folder_name"
    echo "Copied ${#files_to_copy[@]} .desktop files into it."

    # Modify Exec= in copied .desktop files
for copied_file in "$safe_folder_name"/*.desktop; do
    if [[ -f "$copied_file" ]]; then
        # Extract the original Exec line (without "Exec=")
        original_exec=$(grep '^Exec=' "$copied_file" | head -n1 | cut -d'=' -f2-)

        if [[ -n "$original_exec" && "$original_exec" != *"killpcman.sh"* ]]; then
            # Prepare wrapped command
            wrapped_exec="Exec=bash -c \"/home/maxim/apps/smartfolder/killpcman.sh && unset GTK_THEME && $original_exec\""

            # Rebuild the file with the replaced Exec line
            awk -v new_exec="$wrapped_exec" '
                BEGIN { replaced=0 }
                /^Exec=/ {
                    print new_exec
                    replaced=1
                    next
                }
                { print }
                END {
                    if (!replaced) {
                        print new_exec
                    }
                }
            ' "$copied_file" > "$copied_file.tmp" && mv "$copied_file.tmp" "$copied_file"

            echo "Modified Exec in: $copied_file"
        fi
    fi
done

    # Call icon creation script
    if [[ ${#icons[@]} -gt 0 ]]; then
        ./create-dash-folder-icon.sh "${icons[@]}"

        icon_filename=$(IFS='-'; echo "${names[*]}").png
        icon_filename="${icon_filename// /_}"
        icon_path="$(pwd)/$icon_filename"

        if [[ -f "output.png" ]]; then
            mv "output.png" "$icon_path"
            echo "Renamed output.png to: $icon_path"
        else
            echo "Warning: output.png not found after running create-dash-folder-icon.sh"
        fi

        # Create .desktop file for folder
        desktop_filename=$(IFS='-'; echo "${names[*]}").desktop
        desktop_filename="${desktop_filename// /_}"
        folder_path="$(pwd)/$safe_folder_name"

        desktop_file_path="$HOME/.local/share/applications/$desktop_filename"

        mkdir -p "$HOME/.local/share/applications"

        cat > "$desktop_file_path" <<EOF
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Name=$folder_name
Comment=
Exec=env GTK_THEME=Adwaita:dark pcmanfm "$folder_path"
Icon=$icon_path
EOF

        chmod +x "$desktop_file_path"
        echo "Created desktop launcher: $desktop_file_path"
    fi
else
    echo "No valid desktop files processed. No folder created."
fi

