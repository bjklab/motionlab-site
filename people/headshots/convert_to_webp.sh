#!/bin/sh

for file in *.jpg *.jpeg *.png *.PNG *.jpeg *.JPG; do cwebp "$file" -o "${file%.*}.webp"; done
