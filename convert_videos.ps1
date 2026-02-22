# Fantastico Pools - Parallel Video Conversion Script
# Usage: 
#   .\convert_videos.ps1         - Convert all videos in parallel
#   .\convert_videos.ps1 clean   - Remove generated outputs

param(
    [string]$Action = "",
    [int]$MaxParallel = 4  # Adjust based on your CPU cores
)

# Handle clean action
if ($Action -eq "clean") {
    Write-Host "Deleting generated video outputs and thumbnails..."
    Remove-Item "m*_out.mp4" -ErrorAction SilentlyContinue
    Remove-Item "*thumbnail.jpg" -ErrorAction SilentlyContinue
    Write-Host "Done."
    exit 0
}

Write-Host "=== convert_videos: START ==="
Write-Host "Starting parallel video conversion (max $MaxParallel concurrent)..."
Write-Host ""

# Determine script directory and pass it into jobs so background jobs use correct paths
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define video configurations
$videos = @(
    @{id="m0"; ext="mp4"; crf=$true; crfValue=25; bitrate=$null},
    @{id="m1"; ext="mov"; crf=$true; crfValue=25; bitrate=$null},
    @{id="m2"; ext="mov"; crf=$true; crfValue=25; bitrate=$null},
    @{id="m3"; ext="mov"; crf=$true; crfValue=25; bitrate=$null},
    @{id="m4"; ext="mov"; crf=$true; crfValue=25; bitrate=$null},
    @{id="m5"; ext="mov"; crf=$true; crfValue=25; bitrate=$null},
    @{id="m6"; ext="mov"; crf=$false; crfValue=$null; bitrate="5600k"},
    @{id="m7"; ext="mp4"; crf=$false; crfValue=$null; bitrate="5600k"},
    @{id="m8"; ext="mp4"; crf=$true; crfValue=25; bitrate=$null}
)

# Function to convert a single video
$convertVideo = {
    param($video, $baseDir)

    $id = $video.id
    $ext = $video.ext
    $input = Join-Path $baseDir "$id.$ext"
    $mp4Out = Join-Path $baseDir "${id}_out.mp4"
    $thumbOut = Join-Path $baseDir "${id}_thumbnail.jpg"
    
    $results = @{
        id = $id
        mp4 = "skipped"
        thumb = "skipped"
    }
    
    # MP4 conversion
    if (-not (Test-Path $mp4Out)) {
        if ($video.crf) {
            $args = @("-hide_banner", "-loglevel", "error", "-stats", "-i", $input, 
                     "-c:v", "libx264", "-preset", "slow", "-crf", $video.crfValue, 
                     "-pix_fmt", "yuv420p", "-threads", "0", "-an", "-movflags", "+faststart", 
                     "-vf", "scale=1920:-2", $mp4Out)
        } else {
            $args = @("-hide_banner", "-loglevel", "error", "-stats", "-i", $input, 
                     "-c:v", "libx264", "-preset", "slow", "-b:v", $video.bitrate, 
                     "-pix_fmt", "yuv420p", "-threads", "0", "-an", "-movflags", "+faststart", 
                     "-vf", "scale=1920:-2", $mp4Out)
        }
        & ffmpeg @args 2>&1 | Out-Null
        $results.mp4 = if ($LASTEXITCODE -eq 0) { "done" } else { "failed" }
    }
    
    # Thumbnail generation
    if (-not (Test-Path $thumbOut)) {
        $args = @("-hide_banner", "-loglevel", "error", "-i", $input, 
                 "-ss", "1", "-vframes", "1", 
                 "-vf", "scale=640:422:force_original_aspect_ratio=decrease,pad=640:422:(ow-iw)/2:(oh-ih)/2:black", 
                 "-q:v", "1", $thumbOut)
        & ffmpeg @args 2>&1 | Out-Null
        $results.thumb = if ($LASTEXITCODE -eq 0) { "done" } else { "failed" }
    }
    
    return $results
}

# Process videos in parallel using jobs
$jobs = @()
    foreach ($video in $videos) {
    # Wait if we've hit the parallel limit
    while ((Get-Job -State Running).Count -ge $MaxParallel) {
        Start-Sleep -Milliseconds 100
    }
    
    Write-Host "Starting conversion for $($video.id)..."
    $job = Start-Job -ScriptBlock $convertVideo -ArgumentList $video, $baseDir
    $jobs += $job
}

# Wait for all jobs to complete and show results
Write-Host ""
Write-Host "Waiting for all conversions to complete..."
$jobs | Wait-Job | Out-Null

Write-Host ""
foreach ($job in $jobs) {
    $result = Receive-Job -Job $job
    $status = @()
    if ($result.mp4 -eq "done") { $status += "MP4" }
    if ($result.thumb -eq "done") { $status += "Thumbnail" }
    
    if ($status.Count -gt 0) {
        $statusText = $status -join ', '
        Write-Host "completed $($result.id): $statusText"
    } else {
        Write-Host "  $($result.id): All files already exist"
    }
    Remove-Job -Job $job
}

Write-Host ""
Write-Host "All video conversions completed!"
Write-Host "=== convert_videos: DONE ==="
