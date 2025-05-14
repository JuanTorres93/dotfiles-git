#!/bin/bash

VIDEO_DIR=~/hdd/Video\ editting/
TEMPLATE_FOLDER_NAME=00\ -\ KDENLIVE\ TEMPLATE
THUMBNAIL_TEMPLATE=${VIDEO_DIR}00\ -\ ASSETS/THUMBNAIL\ FACTORY/thumbnailTemplate.xcf

# List elements in the video directory and get last one
LAST_VIDEO=$(ls "$VIDEO_DIR" | tail -n 1)

# LAST_VIDEO is in the format "INTEGER - VIDEO_NAME", get the integer
LAST_VIDEO_NUMBER=$(echo $LAST_VIDEO | cut -d' ' -f1)

# Increment the integer
NEW_VIDEO_NUMBER=$((LAST_VIDEO_NUMBER + 1))

# If $1 is included, use it as the video name

if [ -z "$1" ]; then
    NEW_VIDEO_NAME="$NEW_VIDEO_NUMBER - Video $NEW_VIDEO_NUMBER"
else
    NEW_VIDEO_NAME=$NEW_VIDEO_NUMBER\ -\ $1
fi

# Copy the template folder to the new video folder
cp -r "$VIDEO_DIR$TEMPLATE_FOLDER_NAME" "$VIDEO_DIR$NEW_VIDEO_NAME"

# Change project file name to videoX, where X is the new video number
mv "$VIDEO_DIR$NEW_VIDEO_NAME/kdenlive/videoX.kdenlive" "$VIDEO_DIR$NEW_VIDEO_NAME/kdenlive/video$NEW_VIDEO_NUMBER.kdenlive"
# Copy the thumbnail template to thumbnail folder as thumbnailX, where X is the new video number
cp "$THUMBNAIL_TEMPLATE" "$VIDEO_DIR$NEW_VIDEO_NAME/thumbnail/thumbnail_video_$NEW_VIDEO_NUMBER.xcf"


# Open the new video folder with thunar
/usr/bin/thunar "$VIDEO_DIR$NEW_VIDEO_NAME" &