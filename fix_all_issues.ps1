# Fix ALL issues: UTF-8 encoding, CSS, and ensure programming chapters are visible

Write-Host "Starting comprehensive fixes..." -ForegroundColor Cyan

# 1. Fix UTF-8 encoding corruption in ALL HTML files
Write-Host "`n[1/3] Fixing UTF-8 encoding corruption..." -ForegroundColor Yellow

$files = Get-ChildItem -Path "." -Filter "*.html" -File | Where-Object { $_.Name -notlike "*ULTRA*" }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Fix common UTF-8 corruptions
    $content = $content -replace 'â€"', '—'  # em-dash
    $content = $content -replace 'â€œ', '"'   # left double quote
    $content = $content -replace 'â€', '"'    # right double quote
    $content = $content -replace 'â€™', "'"   # right single quote
    $content = $content -replace 'â€˜', "'"   # left single quote
    $content = $content -replace 'ðŸ§', '🧩'  # puzzle emoji
    $content = $content -replace 'ðŸŒ', '🌐'  # globe emoji
    $content = $content -replace 'ðŸŸ¢', '🟢' # green circle
    $content = $content -replace 'ðŸ"', '🔒'  # lock emoji
    $content = $content -replace 'ðŸŽ¯', '🎯'  # target emoji
    $content = $content -replace 'ðŸ', '📦'   # package emoji
    $content = $content -replace 'ðŸš€', '🚀'  # rocket emoji
    $content = $content -replace 'ðŸ'»', '💻'  # laptop emoji
    $content = $content -replace 'ðŸ›¡', '🛡️'  # shield emoji
    $content = $content -replace 'âš™', '⚙️'  # gear emoji
    $content = $content -replace 'âœ…', '✅'  # check mark
    $content = $content -replace 'âš ï¸', '⚠️'  # warning
    $content = $content -replace 'ðŸ"¥', '🔥'  # fire emoji
    $content = $content -replace 'ðŸ'¡', '💡'  # light bulb
    $content = $content -replace 'ðŸ"', '🔑'  # key emoji
    $content = $content -replace 'ðŸŽ®', '🎮'  # game controller
    $content = $content -replace 'ðŸ'ª', '💪'  # muscle emoji
    $content = $content -replace 'â­', '⭐'   # star
    $content = $content -replace 'âž¡', '➡️'  # right arrow
    $content = $content -replace 'ðŸ†š', '🆚'  # VS symbol
    $content = $content -replace 'ðŸ"§', '🔧'  # wrench
    $content = $content -replace 'ðŸ"Š', '📊'  # chart
    $content = $content -replace 'ðŸ'¾', '💾'  # floppy disk
    $content = $content -replace 'âœ¨', '✨'   # sparkles
    $content = $content -replace 'ðŸš', '🚪'   # door
    $content = $content -replace 'ðŸŽ"', '🎓'  # graduation cap
    $content = $content -replace 'ðŸ"', '📝'   # memo
    $content = $content -replace 'ðŸ'¼', '💼'  # briefcase
    $content = $content -replace 'ðŸŒŸ', '🌟'  # glowing star
    $content = $content -replace 'ðŸ"±', '📱'  # phone
    $content = $content -replace 'ðŸ"¬', '🔬'  # microscope
    
    # Write back with proper UTF-8 encoding (NO BOM)
    [System.IO.File]::WriteAllText($file.FullName, $content, (New-Object System.Text.UTF8Encoding $false))
}

Write-Host "  ✓ UTF-8 encoding fixed in all HTML files" -ForegroundColor Green

# 2. Verify hacking chapter CSS is correct
Write-Host "`n[2/3] Verifying hacking chapter CSS..." -ForegroundColor Yellow

$hackingFiles = @("hacking-ch03.html", "hacking-ch04.html")
foreach ($file in $hackingFiles) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw -Encoding UTF8
        
        # Ensure CSS has proper background color (not broken gradient)
        if ($content -match 'background:\s*#0a0a0a\s+100%\)') {
            Write-Host "  ! Found broken CSS in $file, fixing..." -ForegroundColor Red
            $content = $content -replace 'background:\s*#0a0a0a\s+100%\)', 'background: #0a0a0a;'
            [System.IO.File]::WriteAllText($file, $content, (New-Object System.Text.UTF8Encoding $false))
            Write-Host "  ✓ Fixed CSS in $file" -ForegroundColor Green
        } else {
            Write-Host "  ✓ CSS in $file is correct" -ForegroundColor Green
        }
    }
}

# 3. Verify programming chapters are present and display correctly
Write-Host "`n[3/3] Verifying programming chapters..." -ForegroundColor Yellow

$progChapters = @("programming-ch01.html", "programming-ch02.html", "programming-ch03.html", "programming-ch04.html")
foreach ($chapter in $progChapters) {
    if (Test-Path $chapter) {
        $lines = (Get-Content $chapter).Count
        $size = [math]::Round((Get-Item $chapter).Length / 1KB, 1)
        
        if ($lines -gt 400) {
            Write-Host "  ✓ $chapter OK: $lines lines, ${size}KB" -ForegroundColor Green
        } else {
            Write-Host "  ! $chapter might be too short: $lines lines" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✗ $chapter MISSING!" -ForegroundColor Red
    }
}

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "ALL FIXES COMPLETED!" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "`nSummary:" -ForegroundColor White
Write-Host "  ✓ UTF-8 encoding corruption fixed (emojis/symbols)" -ForegroundColor Green
Write-Host "  ✓ Hacking chapter CSS verified/fixed" -ForegroundColor Green
Write-Host "  ✓ Programming chapters verified" -ForegroundColor Green
Write-Host "`nPlease refresh your browser to see changes!" -ForegroundColor Yellow
