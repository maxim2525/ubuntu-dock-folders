#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 image1 [image2 ...]"
    exit 1
fi

count=$#
tile_size="200x200"
cols=2
rows=2
total_slots=$((cols * rows))

echo "Arranging $count images in grid: ${cols}x${rows}"

# Create a transparent placeholder image
placeholder="/tmp/placeholder.png"
convert -size "$tile_size" xc:none "$placeholder"

# Create a temporary directory for converted images
tmpdir=$(mktemp -d)
trap "rm -rf '$tmpdir'" EXIT

# Helper function to convert SVG to PNG preserving transparency and colors
convert_svg_to_png() {
    local svg_file="$1"
    local png_file="$2"

    if command -v rsvg-convert >/dev/null 2>&1; then
        rsvg-convert -w 200 -h 200 -o "$png_file" "$svg_file"
    elif command -v inkscape >/dev/null 2>&1; then
        inkscape "$svg_file" --export-type=png --export-filename="$png_file" --export-width=200 --export-height=200 >/dev/null 2>&1
    else
        convert -background none -resize 200x200 "$svg_file" "$png_file"
    fi
}

# Prepare image list with placeholders for empty slots, converting SVGs to PNGs
image_list=()
for ((i=1; i<=total_slots; i++)); do
    if (( i <= count )); then
        img="${!i}"
        ext="${img##*.}"
        ext="${ext,,}"  # lowercase extension

        if [[ "$ext" == "svg" ]]; then
            base=$(basename "$img" .svg)
            pngfile="$tmpdir/${base}.png"
            convert_svg_to_png "$img" "$pngfile"
            image_list+=("$pngfile")
        else
            image_list+=("$img")
        fi
    else
        image_list+=("$placeholder")
    fi
done

# Generate the montage with transparency preserved
montage "${image_list[@]}" -tile "${cols}x${rows}" -geometry "${tile_size}+0+0" -background none -alpha set output.png

echo "Created output.png with $count images in a fixed ${cols}x${rows} grid."

