# Fix all colored styles across hacking chapters and terminal

Write-Host "Removing colored styles from pages..."

$fixed = 0

# Fix hacking-ch03.html - remove all rgba colors
Write-Host "[1/3] Fixing hacking-ch03.html..."
$ch03 = Get-Content "hacking-ch03.html" -Raw

$ch03 = $ch03 -replace 'background:\s*linear-gradient\([^)]*rgba\([^)]*\)[^)]*\)', 'background: #0a0a0a'
$ch03 = $ch03 -replace 'background:\s*rgba\([^)]*\)', 'background: #0a0a0a'
$ch03 = $ch03 -replace 'border:\s*\d+px\s+solid\s+rgba\([^)]*\)', 'border: 1px solid #222'
$ch03 = $ch03 -replace 'border-left:\s*\d+px\s+solid\s+#[0-9a-fA-F]{6}', 'border-left: 3px solid #fff'
$ch03 = $ch03 -replace 'color:\s*#00[a-fA-F0-9]{4}', 'color: #fff'
$ch03 = $ch03 -replace 'border:\s*1px\s+solid\s+#ff5f57', 'border: 1px solid #222'
$ch03 = $ch03 -replace 'color:\s*#ff5f57', 'color: #fff'
$ch03 = $ch03 -replace 'onmouseover="[^"]*"', ''
$ch03 = $ch03 -replace 'onmouseout="[^"]*"', ''

$ch03 | Set-Content "hacking-ch03.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed hacking-ch03.html"

# Fix hacking-ch04.html - remove all rgba colors
Write-Host "[2/3] Fixing hacking-ch04.html..."
$ch04 = Get-Content "hacking-ch04.html" -Raw

$ch04 = $ch04 -replace 'background:\s*linear-gradient\([^)]*rgba\([^)]*\)[^)]*\)', 'background: #0a0a0a'
$ch04 = $ch04 -replace 'background:\s*rgba\([^)]*\)', 'background: #0a0a0a'
$ch04 = $ch04 -replace 'border:\s*\d+px\s+solid\s+rgba\([^)]*\)', 'border: 1px solid #222'
$ch04 = $ch04 -replace 'border-left:\s*\d+px\s+solid\s+#[0-9a-fA-F]{6}', 'border-left: 3px solid #fff'
$ch04 = $ch04 -replace 'border:\s*\d+px\s+solid\s+#[0-9a-fA-F]{6}', 'border: 1px solid #222'
$ch04 = $ch04 -replace 'color:\s*#[0-9a-fA-F]{6}(?!;?\s*background)', 'color: #fff'

$ch04 | Set-Content "hacking-ch04.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed hacking-ch04.html"

# Fix null-terminal.html - remove green accent colors
Write-Host "[3/3] Fixing null-terminal.html..."
$terminal = Get-Content "null-terminal.html" -Raw

$terminal = $terminal -replace '<meta name="theme-color" content="#00ff88">', '<meta name="theme-color" content="#000000">'
$terminal = $terminal -replace 'color:\s*#00ff88', 'color: #fff'
$terminal = $terminal -replace 'background:\s*#00ff88', 'background: #fff'
$terminal = $terminal -replace 'background:\s*var\(--accent-gradient\);', 'background: #000;'

$terminal | Set-Content "null-terminal.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed null-terminal.html"

Write-Host ""
Write-Host "Completed! Fixed $fixed files."

