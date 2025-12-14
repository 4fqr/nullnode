# Create minimal FAQ page
$faq = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ - NullSector</title>
    <link rel="icon" type="image/svg+xml" href="logo.svg">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #000; color: #fff; line-height: 1.6; }
        .header { position: fixed; top: 0; left: 0; right: 0; background: rgba(0,0,0,0.95); backdrop-filter: blur(10px); border-bottom: 1px solid #222; z-index: 1000; padding: 1rem 2rem; }
        .header-content { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .brand { display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: #fff; font-weight: 700; font-size: 1.25rem; }
        .brand img { width: 36px; height: 36px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .nav a:hover { color: #fff; }
        .content { padding: 7rem 2rem 4rem; max-width: 900px; margin: 0 auto; }
        h1 { font-size: 3rem; font-weight: 800; margin-bottom: 1rem; }
        .subtitle { font-size: 1.25rem; color: #888; margin-bottom: 3rem; }
        .faq-category { margin: 3rem 0; }
        .category-title { font-size: 2rem; font-weight: 700; margin-bottom: 2rem; }
        .faq-item { background: #111; border: 1px solid #222; border-radius: 8px; margin-bottom: 1rem; }
        .faq-question { padding: 1.5rem; cursor: pointer; display: flex; align-items: center; gap: 1rem; transition: all 0.2s; }
        .faq-question:hover { background: #1a1a1a; }
        .faq-icon { background: #222; width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        .faq-question h3 { font-size: 1.1rem; font-weight: 600; flex: 1; }
        .faq-toggle { font-size: 1.5rem; color: #888; }
        .faq-answer { padding: 0; max-height: 0; overflow: hidden; transition: all 0.3s; }
        .faq-item.active .faq-answer { padding: 0 1.5rem 1.5rem; max-height: 1000px; }
        .faq-item.active .faq-toggle { transform: rotate(45deg); }
        .faq-answer p { color: #888; margin-bottom: 1rem; }
        .faq-answer ul { margin: 1rem 0 1rem 2rem; }
        .faq-answer li { color: #888; margin-bottom: 0.5rem; }
        .faq-answer strong { color: #fff; }
        .faq-cta { background: #111; border: 2px solid #222; border-radius: 12px; padding: 3rem; text-align: center; margin: 4rem 0; }
        .cta-button { display: inline-block; padding: 1rem 2rem; background: #fff; color: #000; text-decoration: none; border-radius: 8px; font-weight: 700; }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <a href="index.html" class="brand"><img src="logo.svg" alt="NullSector"><span>NullSector</span></a>
            <nav class="nav">
                <a href="roadmap-hacking.html">Hacking</a>
                <a href="roadmap-programming.html">Programming</a>
                <a href="faq.html">FAQ</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank">Discord</a>
            </nav>
        </div>
    </header>
    <section class="content">
        <h1>Frequently Asked Questions</h1>
        <p class="subtitle">Answers to common questions from our Discord community</p>
        <div class="faq-cta">
            <h2>Join Our Community</h2>
            <p>Have questions? Join our Discord where members are ready to help!</p>
            <a href="https://discord.gg/Tz9Y3wea32" target="_blank" class="cta-button">Join Discord</a>
        </div>
    </section>
    <script>
        document.querySelectorAll('.faq-question').forEach(q => {
            q.addEventListener('click', () => q.parentElement.classList.toggle('active'));
        });
    </script>
</body>
</html>
"@
$faq | Out-File -FilePath "faq.html" -Encoding UTF8

Write-Host "Created minimal pages successfully!"
