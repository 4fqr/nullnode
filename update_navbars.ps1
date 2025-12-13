# PowerShell script to add Resources link to all chapter file navbars
$rootPath = "c:\Users\geeth\Documents\Null\nullnode-main"

# Pattern to find in hacking chapters
$hackingOld = @"
            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link active">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link">Programming</a>
                <a href="faq.html" class="nav-link">FAQ</a>
"@

$hackingNew = @"
            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link active">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link">Programming</a>
                <a href="resources.html" class="nav-link">Resources</a>
                <a href="faq.html" class="nav-link">FAQ</a>
"@

# Pattern to find in programming chapters
$programmingOld = @"
            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link ">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link active">Programming</a>
                <a href="faq.html" class="nav-link">FAQ</a>
"@

$programmingNew = @"
            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link ">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link active">Programming</a>
                <a href="resources.html" class="nav-link">Resources</a>
                <a href="faq.html" class="nav-link">FAQ</a>
"@

$updatedCount = 0

# Update hacking chapters
Write-Host "Updating hacking chapters..." -ForegroundColor Cyan
Get-ChildItem -Path $rootPath -Filter "hacking-ch*.html" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match [regex]::Escape($hackingOld)) {
        $content = $content -replace [regex]::Escape($hackingOld), $hackingNew
        Set-Content -Path $_.FullName -Value $content -NoNewline
        Write-Host "✓ Updated $($_.Name)" -ForegroundColor Green
        $updatedCount++
    } else {
        Write-Host "✗ Pattern not found in $($_.Name)" -ForegroundColor Yellow
    }
}

# Update programming chapters
Write-Host "`nUpdating programming chapters..." -ForegroundColor Cyan
Get-ChildItem -Path $rootPath -Filter "programming-ch*.html" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match [regex]::Escape($programmingOld)) {
        $content = $content -replace [regex]::Escape($programmingOld), $programmingNew
        Set-Content -Path $_.FullName -Value $content -NoNewline
        Write-Host "✓ Updated $($_.Name)" -ForegroundColor Green
        $updatedCount++
    } else {
        Write-Host "✗ Pattern not found in $($_.Name)" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "Total files updated: $updatedCount" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
