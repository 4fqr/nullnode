#!/usr/bin/env python3
"""Generate placeholder chapters for navigation"""

chapters = [
    (2, 'hacking', 'Computer Deep Dive'),
    (3, 'hacking', 'Linux Mastery'),
    (4, 'hacking', 'Networking Fundamentals'),
    (5, 'hacking', 'Programming for Hackers'),
    (6, 'hacking', 'Web Security'),
    (7, 'hacking', 'Exploitation Techniques'),
    (8, 'hacking', 'Reverse Engineering'),
    (9, 'hacking', 'Active Directory'),
    (10, 'hacking', 'Cloud Security'),
    (11, 'hacking', 'Certifications & Career'),
    (2, 'programming', 'OOP & Advanced Concepts'),
    (3, 'programming', 'Data Structures & Algorithms'),
    (4, 'programming', 'Web Development'),
    (5, 'programming', 'Backend Development'),
    (6, 'programming', 'Databases'),
    (7, 'programming', 'Full-Stack Projects'),
    (8, 'programming', 'Professional Practices'),
    (9, 'programming', 'Advanced Topics'),
    (10, 'programming', 'Career Preparation')
]

template = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ch{num:02d}: {title} - NullSector</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="stars"></div>
    <div class="twinkling"></div>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <a href="index.html" style="display: flex; align-items: center; text-decoration: none; color: inherit;">
                    <img src="logo.svg" alt="NullSector Logo" class="logo">
                    <span class="brand-text">NullSector</span>
                </a>
            </div>
            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link {hacking_active}">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link {prog_active}">Programming</a>
                <a href="faq.html" class="nav-link">FAQ</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank" class="nav-link">Discord</a>
            </div>
        </div>
    </nav>
    <section class="content-page">
        <div class="content-container">
            <div class="breadcrumb">
                <a href="roadmap-{path}.html">{path_title} Roadmap</a> / <span>Chapter {num:02d}</span>
            </div>
            <div class="roadmap-section">
                <div class="roadmap-number">{num:02d}</div>
                <h1 class="page-title">Chapter {num:02d}: {title}</h1>
                <p class="page-subtitle">📝 Content In Development</p>
                <div class="key-takeaways" style="margin:3rem 0;">
                    <h3>🚧 Chapter Under Development</h3>
                    <p>This chapter is being written with the same quality as Chapters 01:</p>
                    <ul>
                        <li>✅ Real, researched technical content (no AI filler)</li>
                        <li>✅ Working code examples you can actually run</li>
                        <li>✅ Hands-on labs with step-by-step instructions</li>
                        <li>✅ Security-focused practical knowledge</li>
                        <li>✅ Direct, no-BS technical education</li>
                    </ul>
                    <p><strong>📚 Check back soon!</strong> Quality content takes time to research and write properly.</p>
                    <p style="margin-top: 1.5rem;"><em>In the meantime, complete Chapter 01 topics - they're packed with value!</em></p>
                </div>
                <div style="margin-top: 3rem;">
                    <a href="roadmap-{path}.html" class="nav-button">← Back to Roadmap</a>
                </div>
            </div>
        </div>
    </section>
    <script src="script.js"></script>
</body>
</html>'''

for num, path, title in chapters:
    filename = f"{path}-ch{num:02d}.html"
    html = template.format(
        num=num,
        path=path,
        title=title,
        path_title=path.title(),
        hacking_active='active' if path == 'hacking' else '',
        prog_active='active' if path == 'programming' else ''
    )
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(html)
    
    print(f"✅ Created {filename}")

print("\n✅ All placeholder chapters created!")
print("📊 Total: 2 complete chapters + 19 placeholders = 21 chapters")
