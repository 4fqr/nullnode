# Fix all issues at once

Write-Host "Fixing all issues..." -ForegroundColor Cyan

# 1. Fix terminal green glow
Write-Host "[1/4] Removing terminal green glow..." -ForegroundColor Yellow
$terminal = Get-Content "null-terminal.html" -Raw -Encoding UTF8

$terminal = $terminal -replace 'rgba\(0,\s*255,\s*136[^)]*\)', 'rgba(255, 255, 255, 0.2)'
$terminal = $terminal -replace 'box-shadow: 0 20px 60px rgba\(255, 255, 255, 0\.2\);', 'box-shadow: none;'

$terminal | Out-File "null-terminal.html" -Encoding UTF8 -NoNewline
Write-Host "  Terminal green removed" -ForegroundColor Green

# 2. Fix hacking chapter styling
Write-Host "[2/4] Fixing hacking chapter styling..." -ForegroundColor Yellow
$ch03 = Get-Content "hacking-ch03.html" -Raw -Encoding UTF8
$ch04 = Get-Content "hacking-ch04.html" -Raw -Encoding UTF8

# Remove broken gradients
$ch03 = $ch03 -replace 'background: #0a0a0a 100%\);', 'background: #0a0a0a;'
$ch04 = $ch04 -replace 'background: #0a0a0a 100%\);', 'background: #0a0a0a;'

$ch03 | Out-File "hacking-ch03.html" -Encoding UTF8 -NoNewline
$ch04 | Out-File "hacking-ch04.html" -Encoding UTF8 -NoNewline
Write-Host "  Hacking chapters fixed" -ForegroundColor Green

Write-Host ""
Write-Host "Fixes applied! Now recreating programming chapters with EXTREME detail..." -ForegroundColor Cyan
