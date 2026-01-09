#!/usr/bin/env pwsh
# Delete OLD broken section PROPERLY
# This script keeps the comprehensive tools added (Meta sploit, SQLmap, Wireshark, Hydra, John, Hashcat, Gobuster)

$file = "hacking-bonus-kali-part2.html"

# Read ALL lines
$lines = Get-Content $file -Encoding UTF8

Write-Host "Original file: $($lines.Count) lines"

# Find where OLD broken section starts (line with escaped quotes: class=\"code\")
$startDeletion = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match 'class=\\"code\\"') {
        $startDeletion = $i
        Write-Host "Found OLD broken section start at line $($i+1): $($lines[$i].Substring(0, [Math]::Min(80, $lines[$i].Length)))"
        break
    }
}

# Find where GOOD Metasploit content starts (line with "# Loads: Framework, exploits, payloads")
$endDeletion = -1
for ($i = $startDeletion; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '# Loads: Framework, exploits, payloads, auxiliary modules') {
        # Go back to find the "<div class="code">" (without backslashes!)
        for ($j = $i; $j -gt $startDeletion; $j--) {
            if ($lines[$j] -match '<div class="code">' -and $lines[$j] -notmatch 'class=\\"') {
                $endDeletion = $j
                Write-Host "Found GOOD Metasploit section start at line $($j+1): $($lines[$j].Substring(0, [Math]::Min(80, $lines[$j].Length)))"
                break
            }
        }
        break
    }
}

if ($startDeletion -eq -1 -or $endDeletion -eq -1) {
    Write-Host "ERROR: Could not find deletion boundaries!"
    exit 1
}

Write-Host "Will DELETE lines $($startDeletion+1) through $($endDeletion)"
Write-Host "Lines to delete: $($endDeletion - $startDeletion + 1)"

# Keep lines before OLD section + lines from GOOD Metasploit onwards
$newLines = @()
$newLines += $lines[0..($startDeletion-1)]
$newLines += $lines[$endDeletion..($lines.Count-1)]

Write-Host "After deletion: $($newLines.Count) lines"
Write-Host "Deleted: $($lines.Count - $newLines.Count) lines"

# Write back
$newLines | Set-Content $file -Encoding UTF8

Write-Host "✅ OLD broken section deleted!"
Write-Host "File now has proper structure with comprehensive tools intact!"
