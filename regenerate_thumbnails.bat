@echo off
echo Regenerating video thumbnails at high quality (400x300, q:v 1)...
echo.

REM m1 thumbnail
echo Generating m1_thumbnail.jpg...
ffmpeg -i m1.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m1_thumbnail.jpg
echo.

REM m2 thumbnail
echo Generating m2_thumbnail.jpg...
ffmpeg -i m2.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m2_thumbnail.jpg
echo.

REM m3 thumbnail
echo Generating m3_thumbnail.jpg...
ffmpeg -i m3.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m3_thumbnail.jpg
echo.

REM m4 thumbnail
echo Generating m4_thumbnail.jpg...
ffmpeg -i m4.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m4_thumbnail.jpg
echo.

REM m5 thumbnail
echo Generating m5_thumbnail.jpg...
ffmpeg -i m5.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m5_thumbnail.jpg
echo.

REM m6 thumbnail
echo Generating m6_thumbnail.jpg...
ffmpeg -i m6.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m6_thumbnail.jpg
echo.

REM m7 thumbnail
echo Generating m7_thumbnail.jpg...
ffmpeg -i m7.mp4 -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m7_thumbnail.jpg
echo.

REM m8 thumbnail
echo Generating m8_thumbnail.jpg...
ffmpeg -i m8.mp4 -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m8_thumbnail.jpg
echo.

echo All thumbnails regenerated successfully!
echo Press any key to exit...
pause >nul