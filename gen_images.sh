#!/bin/bash
# Requires ImageMagick's convert
# Provide the following files:
# - romFileName0_1080.png -> 474x666 Cover Art
# - romFileName1_hd.png -> 418x295 Game Screenshot
# - romFileName_gamebanner.png -> 1920x551 Game Banner (when game is selected)
# By running this script the lower resolution assets are generated for you.

romFileName=$1
convert "$romFileName"0_1080.png -resize 260x358 "$romFileName"0_hd.png
convert "$romFileName"0_1080.png -resize 112x157 "$romFileName"0.png
convert "$romFileName"1_hd.png -resize 214x146 "$romFileName"1.png
