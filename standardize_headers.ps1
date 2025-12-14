# Standardize headers across all key pages

Write-Host "Standardizing headers across all pages..."

$standardHeader = @'
            <nav class="nav">
                <a href="roadmap-hacking.html">Hacking</a>
                <a href="roadmap-programming.html">Programming</a>
                <a href="null-terminal.html">Null Terminal</a>
                <a href="faq.html">FAQs</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank">Discord</a>
            </nav>
'@

$standardRoadmapHeader = @'
            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link">Programming</a>
                <a href="null-terminal.html" class="nav-link">Null Terminal</a>
                <a href="faq.html" class="nav-link">FAQs</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank" class="nav-link">Discord</a>
            </div>
'@

$fixed = 0

# Fix index.html
Write-Host "[1/6] Fixing index.html..."
$index = Get-Content "index.html" -Raw
$index = $index -replace '<nav class="nav">[\s\S]*?</nav>', $standardHeader
$index | Set-Content "index.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed index.html"

# Fix faq.html
Write-Host "[2/6] Fixing faq.html..."
$faq = Get-Content "faq.html" -Raw
$faq = $faq -replace '<nav class="nav">[\s\S]*?</nav>', $standardHeader
$faq | Set-Content "faq.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed faq.html"

# Fix roadmap-hacking.html
Write-Host "[3/6] Fixing roadmap-hacking.html..."
$hackRoad = Get-Content "roadmap-hacking.html" -Raw
$hackRoad = $hackRoad -replace '<div class="nav-links">[\s\S]*?<button id="logoutButton"', $standardRoadmapHeader + '        
            <div id="userProfile" style="display: none;">
            </div>
            <button id="logoutButton" style="display: none;"'
$hackRoad = $hackRoad -replace '<div id="userProfile"[\s\S]*?</button>\s*</div>\s*</div>', ''
$hackRoad | Set-Content "roadmap-hacking.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed roadmap-hacking.html"

# Fix roadmap-programming.html
Write-Host "[4/6] Fixing roadmap-programming.html..."
$progRoad = Get-Content "roadmap-programming.html" -Raw
$progRoad = $progRoad -replace '<div class="nav-links">[\s\S]*?<button id="logoutButton"', $standardRoadmapHeader + '        
            <div id="userProfile" style="display: none;">
            </div>
            <button id="logoutButton" style="display: none;"'
$progRoad = $progRoad -replace '<div id="userProfile"[\s\S]*?</button>\s*</div>\s*</div>', ''
$progRoad | Set-Content "roadmap-programming.html" -Encoding UTF8
$fixed++
Write-Host "  Fixed roadmap-programming.html"

# Add header to null-terminal.html
Write-Host "[5/6] Adding header to null-terminal.html..."
$terminal = Get-Content "null-terminal.html" -Raw

$terminalHeader = @'
    <header class="header" style="position: fixed; top: 0; left: 0; right: 0; background: #000; border-bottom: 1px solid #222; z-index: 1000;">
        <div class="header-content" style="max-width: 1400px; margin: 0 auto; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center;">
            <a href="index.html" class="brand" style="display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: #fff; font-weight: 700; font-size: 1.25rem;">
                <img src="logo.svg" alt="NullSector" style="width: 36px; height: 36px;">
                <span>NullSector</span>
            </a>
            <nav class="nav" style="display: flex; gap: 2rem;">
                <a href="roadmap-hacking.html" style="color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s;">Hacking</a>
                <a href="roadmap-programming.html" style="color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s;">Programming</a>
                <a href="null-terminal.html" style="color: #fff; text-decoration: none; font-weight: 500;">Null Terminal</a>
                <a href="faq.html" style="color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s;">FAQs</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank" style="color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s;">Discord</a>
            </nav>
        </div>
    </header>

'@

# Insert header after <body>
$terminal = $terminal -replace '(<body>)', "`$1`n$terminalHeader"
# Add margin-top to terminal-container
$terminal = $terminal -replace '(class="terminal-container")', '$1 style="margin-top: 80px;"'

$terminal | Set-Content "null-terminal.html" -Encoding UTF8
$fixed++
Write-Host "  Added header to null-terminal.html"

Write-Host ""
Write-Host "Completed! Fixed $fixed files."
Write-Host "All pages now have standardized headers."
