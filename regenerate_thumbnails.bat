@echo off
REM Quick helper: run `regenerate_thumbnails.bat clean` to remove generated thumbnails
if /I "%1"=="clean" goto clean
echo === regenerate_thumbnails: START ===
echo Regenerating video thumbnails at high quality (640:422, q:v 1)...
echo.

REM m1 thumbnail
if exist "m1_thumbnail.jpg" (
	echo Skipping m1_thumbnail.jpg (already exists)
) else (
	echo Generating m1_thumbnail.jpg...
	ffmpeg -n -i m1.mov -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m1_thumbnail.jpg
)
echo.

REM m2 thumbnail
if exist "m2_thumbnail.jpg" (
	echo Skipping m2_thumbnail.jpg (already exists)
) else (
	echo Generating m2_thumbnail.jpg...
	ffmpeg -n -i m2.mov -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m2_thumbnail.jpg
)
echo.

REM m3 thumbnail
if exist "m3_thumbnail.jpg" (
	echo Skipping m3_thumbnail.jpg (already exists)
) else (
	echo Generating m3_thumbnail.jpg...
	ffmpeg -n -i m3.mov -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m3_thumbnail.jpg
)
echo.

REM m4 thumbnail
if exist "m4_thumbnail.jpg" (
	echo Skipping m4_thumbnail.jpg (already exists)
) else (
	echo Generating m4_thumbnail.jpg...
	ffmpeg -n -i m4.mov -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m4_thumbnail.jpg
)
echo.

REM m5 thumbnail
if exist "m5_thumbnail.jpg" (
	echo Skipping m5_thumbnail.jpg (already exists)
) else (
	echo Generating m5_thumbnail.jpg...
	ffmpeg -n -i m5.mov -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m5_thumbnail.jpg
)
echo.

REM m6 thumbnail
if exist "m6_thumbnail.jpg" (
	echo Skipping m6_thumbnail.jpg (already exists)
) else (
	echo Generating m6_thumbnail.jpg...
	ffmpeg -n -i m6.mov -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m6_thumbnail.jpg
)
echo.

REM m7 thumbnail
if exist "m7_thumbnail.jpg" (
	echo Skipping m7_thumbnail.jpg (already exists)
) else (
	echo Generating m7_thumbnail.jpg...
	ffmpeg -n -i m7.mp4 -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m7_thumbnail.jpg
)
echo.

REM m8 thumbnail
if exist "m8_thumbnail.jpg" (
	echo Skipping m8_thumbnail.jpg (already exists)
) else (
	echo Generating m8_thumbnail.jpg...
	ffmpeg -n -i m8.mp4 -ss 1 -vframes 1 -vf "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m8_thumbnail.jpg
)
echo.

echo All thumbnails regenerated successfully!
echo === regenerate_thumbnails: DONE ===
goto :eof

:clean
echo Deleting generated thumbnails... (this removes files matching *thumbnail.jpg)
del /q *thumbnail.jpg 2>nul
echo Done.
goto :eof