$files = @("hacking-ch03.html", "hacking-ch04.html")

foreach($file in $files) {
    $path = "c:\Users\geeth\Documents\Null\nullnode-main\$file"
    $content = Get-Content $path -Raw
    
    # Replace title and styles.css with inline black/white theme
    $content = $content -replace '<link rel="stylesheet" href="styles.css">', @'
<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root { --bg: #000; --bg2: #111; --bg3: #1a1a1a; --text: #fff; --text2: #888; --text3: #555; --accent: #fff; --border: #222; --primary-color: #fff; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); line-height: 1.7; overflow-x: hidden; }
        .progress-bar { position: fixed; top: 0; left: 0; height: 3px; background: var(--accent); z-index: 10000; transition: width 0.2s ease; }
        header { position: fixed; top: 0; left: 0; right: 0; background: var(--bg); border-bottom: 1px solid var(--border); z-index: 1000; }
        .header-content { max-width: 1400px; margin: 0 auto; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .brand { display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: var(--text); font-weight: 700; font-size: 1.25rem; }
        .brand-logo { width: 36px; height: 36px; }
        .header-links { display: flex; gap: 2rem; align-items: center; }
        .header-links a { color: var(--text2); text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .header-links a:hover { color: var(--text); }
        aside { position: fixed; left: 0; top: 70px; bottom: 0; width: 280px; background: var(--bg); border-right: 1px solid var(--border); overflow-y: auto; padding: 2rem 0; z-index: 100; }
        aside::-webkit-scrollbar { width: 6px; }
        aside::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
        .sidebar-nav a { display: block; padding: 0.75rem 2rem; color: var(--text2); text-decoration: none; font-size: 0.95rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-nav a:hover { color: var(--text); background: var(--bg2); }
        .sidebar-nav a.active { color: var(--text); background: var(--bg2); border-left-color: var(--accent); }
        main { margin-left: 280px; margin-top: 70px; padding: 3rem; max-width: 1200px; }
        .stars, .twinkling { display: none; }
        .navbar { display: none; }
        .content-page { padding: 0; margin: 0; }
        .content-container { max-width: 100%; padding: 0; }
        .breadcrumb { display: none; }
        .roadmap-section { margin: 0; }
        .roadmap-number { display: none; }
        .page-title { font-size: 3rem; font-weight: 800; margin-bottom: 1rem; line-height: 1.2; }
        .page-subtitle { font-size: 1.3rem; color: var(--text2); margin-bottom: 3rem; }
        h1 { font-size: 3rem; font-weight: 800; margin-bottom: 1rem; line-height: 1.2; }
        h2 { font-size: 2rem; font-weight: 700; margin: 3rem 0 1.5rem; line-height: 1.3; color: var(--text); }
        h3 { font-size: 1.5rem; font-weight: 600; margin: 2.5rem 0 1rem; color: var(--text); }
        h4 { font-size: 1.25rem; font-weight: 600; margin: 2rem 0 1rem; color: var(--text); }
        p { margin-bottom: 1.5rem; font-size: 1.05rem; color: var(--text2); }
        code { font-family: 'JetBrains Mono', monospace; background: var(--bg2); padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.9em; color: var(--text); }
        pre { background: var(--bg2); border: 1px solid var(--border); border-radius: 8px; padding: 1.5rem; margin: 1.5rem 0; overflow-x: auto; font-family: 'JetBrains Mono', monospace; font-size: 0.95rem; line-height: 1.6; }
        pre code { background: none; padding: 0; }
        ul, ol { margin: 1rem 0 1.5rem 2rem; color: var(--text2); }
        li { margin-bottom: 0.75rem; line-height: 1.7; }
        strong { color: var(--text); font-weight: 600; }
        @media (max-width: 1024px) { aside { transform: translateX(-100%); } main { margin-left: 0; } }
    </style>
'@
    
    # Replace old navbar with new header
    $content = $content -replace '(?s)<div class="stars"></div>.*?</nav>', @'
<div class="progress-bar" id="progressBar"></div>

    <header>
        <div class="header-content">
            <a href="index.html" class="brand">
                <img src="logo.svg" alt="NullSector" class="brand-logo" width="36" height="36">
                <span>NullSector</span>
            </a>
            <div class="header-links">
                <a href="roadmap-hacking.html">Hacking Roadmap</a>
                <a href="index.html">Home</a>
            </div>
        </div>
    </header>

    <aside>
        <nav class="sidebar-nav">
            <a href="#intro">Introduction</a>
            <a href="#topic1">Linux Distributions</a>
            <a href="#topic2">File System</a>
            <a href="#topic3">Permissions</a>
            <a href="#topic4">User Management</a>
            <a href="#topic5">Process Management</a>
            <a href="#topic6">Package Management</a>
            <a href="#topic7">Bash Scripting</a>
            <a href="#topic8">Networking & SSH</a>
        </nav>
    </aside>

    <main>
'@
    
    # Replace closing section tags with main and script
    $content = $content -replace '(?s)</section>.*?<script src="script.js"></script>.*?</body>', @'
</main>

    <script>
        window.addEventListener('scroll', () => {
            const winScroll = document.documentElement.scrollTop;
            const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            const scrolled = (winScroll / height) * 100;
            document.getElementById('progressBar').style.width = scrolled + '%';
        });

        const sections = document.querySelectorAll('section[id], div[id]');
        const navLinks = document.querySelectorAll('.sidebar-nav a');

        window.addEventListener('scroll', () => {
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                if (window.scrollY >= (sectionTop - 100)) {
                    current = section.getAttribute('id');
                }
            });

            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${current}`) {
                    link.classList.add('active');
                }
            });
        });
    </script>
</body>
'@
    
    # Color adjustments - replace green/colorful gradients with black/white
    $content = $content -replace 'rgba\(0,255,136,[^)]+\)', 'rgba(255,255,255,0.1)'
    $content = $content -replace 'rgba\(0,204,255,[^)]+\)', 'rgba(255,255,255,0.08)'
    $content = $content -replace 'rgba\(138,43,226,[^)]+\)', 'rgba(255,255,255,0.06)'
    $content = $content -replace 'rgba\(255,107,107,[^)]+\)', 'rgba(255,255,255,0.05)'
    $content = $content -replace '#00ff88', '#fff'
    $content = $content -replace '#00ccff', '#fff'
    $content = $content -replace '#8a2be2', '#fff'
    $content = $content -replace '#ff6b6b', '#fff'
    $content = $content -replace '#ffc800', '#fff'
    $content = $content -replace 'color: var\(--primary-color\)', 'color: #fff'
    
    Set-Content $path -Value $content
    Write-Host "Updated $file with black/white minimal theme"
}

Write-Host "`nBoth chapters updated successfully!"
