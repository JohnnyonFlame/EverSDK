rem Requires ImageMagick's convert
rem Provide the following files:
rem - romFileName0_1080.png -> 474x666 Cover Art
rem - romFileName1_hd.png -> 418x295 Game Screenshot
rem - romFileName_gamebanner.png -> 1920x551 Game Banner (when game is selected)
rem By running this script the lower resolution assets are generated for you.

convert.exe "%1"0_1080.png -resize 260x358 "%1"0_hd.png
convert.exe "%1"0_1080.png -resize 112x157 "%1"0.png
convert.exe "%1"1_hd.png -resize 214x146 "%1"1.png
