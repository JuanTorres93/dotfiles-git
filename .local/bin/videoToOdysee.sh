#!/bin/bash

# Usage: RUN FROM FOLDER CONTAINING VIDEO videoToOdysee.sh input 

ffmpeg -i $1 -c:v libx264 -b:v 8M -preset fast -c:a aac -b:a 192k -movflags +faststart render-odysee.mp4
