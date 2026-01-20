@echo off
echo Starting video conversion process...
echo.

REM Convert m1.mov to MP4, WebM, and thumbnail
echo Converting m1...
ffmpeg -i m1.mov -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m1_out.mp4
ffmpeg -i m1.mov -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m1_out.webm
ffmpeg -i m1.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m1_thumbnail.jpg
echo m1 conversion complete.
echo.

REM Convert m2.mov to MP4, WebM, and thumbnail
echo Converting m2...
ffmpeg -i m2.mov -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m2_out.mp4
ffmpeg -i m2.mov -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m2_out.webm
ffmpeg -i m2.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m2_thumbnail.jpg
echo m2 conversion complete.
echo.

REM Convert m3.mov to MP4, WebM, and thumbnail
echo Converting m3...
ffmpeg -i m3.mov -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m3_out.mp4
ffmpeg -i m3.mov -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m3_out.webm
ffmpeg -i m3.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m3_thumbnail.jpg
echo m3 conversion complete.
echo.

REM Convert m4.mov to MP4, WebM, and thumbnail
echo Converting m4...
ffmpeg -i m4.mov -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m4_out.mp4
ffmpeg -i m4.mov -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m4_out.webm
ffmpeg -i m4.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m4_thumbnail.jpg
echo m4 conversion complete.
echo.

REM Convert m5.mov to MP4, WebM, and thumbnail
echo Converting m5...
ffmpeg -i m5.mov -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m5_out.mp4
ffmpeg -i m5.mov -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m5_out.webm
ffmpeg -i m5.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m5_thumbnail.jpg
echo m5 conversion complete.
echo.

REM Convert m6.mov to MP4, WebM, and thumbnail
echo Converting m6...
ffmpeg -i m6.mov -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m6_out.mp4
ffmpeg -i m6.mov -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m6_out.webm
ffmpeg -i m6.mov -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m6_thumbnail.jpg
echo m6 conversion complete.
echo.

REM Convert m7.mp4 to MP4, WebM, and thumbnail
echo Converting m7...
ffmpeg -i m7.mp4 -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m7_out.mp4
ffmpeg -i m7.mp4 -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m7_out.webm
ffmpeg -i m7.mp4 -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m7_thumbnail.jpg
echo m7 conversion complete.
echo.

REM Convert m8.mp4 to MP4, WebM, and thumbnail
echo Converting m8...
ffmpeg -i m8.mp4 -c:v libx264 -preset slow -crf 22 -pix_fmt yuv420p -threads 0 -an -movflags +faststart -vf "scale=1920:-2" m8_out.mp4
ffmpeg -i m8.mp4 -c:v libvpx-vp9 -b:v 0 -crf 32 -pix_fmt yuv420p -threads 0 -tile-columns 2 -frame-parallel 1 -an -movflags +faststart -vf "scale=1920:-2" m8_out.webm
ffmpeg -i m8.mp4 -ss 1 -vframes 1 -vf "scale=400:300:force_original_aspect_ratio=decrease,pad=400:300:(ow-iw)/2:(oh-ih)/2:black" -q:v 1 m8_thumbnail.jpg
echo m8 conversion complete.
echo.

echo All video conversions completed!
echo Press any key to exit...
pause >nul