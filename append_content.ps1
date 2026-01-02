# PowerShell script to append massive content
$file = "c:\Users\geeth\Documents\Null\nullnode-main\hacking-ch05.html"

# Read current content
$current = Get-Content $file -Raw

# Check if file ends with specific string
if ($current -match "WiFi 6E\s+=\s+9\.6 Gbps\s+\(6GHz band\)") {
    Write-Host "Found marker, appending content..." -ForegroundColor Green
    
    # Content will be appended using Add-Content in next step
    Write-Host "Ready to append 3000+ lines of content" -ForegroundColor Cyan
} else {
    Write-Host "Marker not found, file may need review" -ForegroundColor Yellow
}

# Display current line count
$lineCount = (Get-Content $file | Measure-Object -Line).Lines
Write-Host "Current line count: $lineCount" -ForegroundColor Cyan
Write-Host "Target: 3500-4000+ lines" -ForegroundColor Cyan
Write-Host "Lines needed: $(3500 - $lineCount)" -ForegroundColor Yellow
