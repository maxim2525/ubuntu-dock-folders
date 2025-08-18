#!/usr/bin/env bash

# List of common search paths
SEARCH_PATHS=(
    "/usr/share/applications"
    "/usr/local/share/applications"
    "$HOME/.local/share/applications"
    "/var/lib/flatpak/exports/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
)

if [[ -z "$1" ]]; then
    echo "Usage: $0 <app-name or .desktop file>"
    exit 1
fi

FILENAME="$1"
# Ensure it ends with .desktop
if [[ "$FILENAME" != *.desktop ]]; then
    FILENAME="${FILENAME}.desktop"
fi

found_files=()

# Search in the predefined paths
for path in "${SEARCH_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
        while IFS= read -r file; do
            found_files+=("$file")
        done < <(find "$path" -type f -name "$FILENAME" 2>/dev/null)
    fi
done

# If nothing found, fall back to searching the whole system
if [[ ${#found_files[@]} -eq 0 ]]; then
    echo "Not found in standard paths. Searching entire filesystem (this may take a while)..."
    while IFS= read -r file; do
        found_files+=("$file")
    done < <(find / -type f -name "$FILENAME" 2>/dev/null)
fi

if [[ ${#found_files[@]} -gt 0 ]]; then
    echo "Found .desktop file(s):"
    for file in "${found_files[@]}"; do
        echo "  $file"
    done
else
    echo "No .desktop file found for '$1'"
fi

