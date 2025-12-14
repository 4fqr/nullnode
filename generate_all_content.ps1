# Generate all missing content with proper minimal styling
$ErrorActionPreference = "Stop"

# Standard minimal header for ALL pages
$standardHeader = @'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TITLE_PLACEHOLDER - NullSector</title>
    <link rel="icon" type="image/svg+xml" href="logo.svg">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root { --bg: #000; --text: #fff; --text2: #888; --border: #222; }
        body { font-family: 'Inter', sans-serif; background: #000; color: #fff; line-height: 1.7; }
        .header { position: fixed; top: 0; left: 0; right: 0; background: rgba(0,0,0,0.95); backdrop-filter: blur(10px); border-bottom: 1px solid #222; z-index: 1000; padding: 1rem 2rem; }
        .header-content { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .brand { display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: #fff; font-weight: 700; font-size: 1.25rem; }
        .brand img { width: 36px; height: 36px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .nav a:hover, .nav a.active { color: #fff; }
        .content { padding: 7rem 2rem 4rem; max-width: 1200px; margin: 0 auto; }
        h1 { font-size: 3rem; font-weight: 800; margin-bottom: 1rem; }
        h2 { font-size: 2rem; font-weight: 700; margin: 3rem 0 1.5rem; }
        h3 { font-size: 1.5rem; font-weight: 600; margin: 2rem 0 1rem; }
        p { color: #888; margin-bottom: 1.5rem; font-size: 1.05rem; line-height: 1.8; }
        code { font-family: 'JetBrains Mono', monospace; background: #111; padding: 0.2rem 0.5rem; border-radius: 4px; color: #fff; font-size: 0.9em; }
        pre { background: #111; border: 1px solid #222; border-radius: 8px; padding: 1.5rem; margin: 1.5rem 0; overflow-x: auto; }
        pre code { background: none; padding: 0; }
        .example-box { background: #111; border: 1px solid #222; border-radius: 12px; padding: 2rem; margin: 2rem 0; }
        .example-box h4 { color: #fff; margin-bottom: 1rem; }
        .metaphor-box { background: #111; border-left: 4px solid #fff; padding: 2rem; margin: 2rem 0; border-radius: 8px; }
        .metaphor-box strong { color: #fff; }
        ul, ol { margin: 1rem 0 1.5rem 2rem; color: #888; }
        li { margin-bottom: 0.75rem; line-height: 1.7; }
        strong { color: #fff; }
        .breadcrumb { background: #111; border: 1px solid #222; padding: 0.75rem 1.5rem; border-radius: 8px; display: inline-flex; gap: 0.5rem; margin-bottom: 2rem; }
        .breadcrumb a { color: #fff; text-decoration: none; }
        .breadcrumb span { color: #888; }
        .chapter-num { display: inline-block; width: 60px; height: 60px; line-height: 60px; text-align: center; background: #111; border: 2px solid #222; border-radius: 12px; font-size: 1.5rem; font-weight: 800; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <a href="index.html" class="brand">
                <img src="logo.svg" alt="NullSector">
                <span>NullSector</span>
            </a>
            <nav class="nav">
                <a href="roadmap-hacking.html">Hacking</a>
                <a href="roadmap-programming.html">Programming</a>
                <a href="null-terminal.html">Null Terminal</a>
                <a href="faq.html">FAQ</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank">Discord</a>
            </nav>
        </div>
    </header>
'@

Write-Host "Standard header template created successfully!" -ForegroundColor Green
Write-Host "Now manually creating each chapter with full content..." -ForegroundColor Yellow
