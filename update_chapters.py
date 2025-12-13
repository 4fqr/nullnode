import os
import glob

root = r"c:\Users\geeth\Documents\Null\nullnode-main"

# Patterns for hacking and programming chapters
hacking_old = '''            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link active">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link">Programming</a>
                <a href="faq.html" class="nav-link">FAQ</a>'''

hacking_new = '''            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link active">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link">Programming</a>
                <a href="resources.html" class="nav-link">Resources</a>
                <a href="faq.html" class="nav-link">FAQ</a>'''

programming_old = '''            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link ">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link active">Programming</a>
                <a href="faq.html" class="nav-link">FAQ</a>'''

programming_new = '''            <div class="nav-links">
                <a href="roadmap-hacking.html" class="nav-link ">Hacking</a>
                <a href="roadmap-programming.html" class="nav-link active">Programming</a>
                <a href="resources.html" class="nav-link">Resources</a>
                <a href="faq.html" class="nav-link">FAQ</a>'''

updated_count = 0

# Update hacking chapters
print("Updating hacking chapters...")
for filepath in glob.glob(os.path.join(root, "hacking-ch*.html")):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if hacking_old in content and 'resources.html' not in content:
        content = content.replace(hacking_old, hacking_new)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✓ Updated {os.path.basename(filepath)}")
        updated_count += 1
    elif 'resources.html' in content:
        print(f"⊘ Already has Resources: {os.path.basename(filepath)}")
    else:
        print(f"✗ Pattern not found: {os.path.basename(filepath)}")

# Update programming chapters
print("\nUpdating programming chapters...")
for filepath in glob.glob(os.path.join(root, "programming-ch*.html")):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if programming_old in content and 'resources.html' not in content:
        content = content.replace(programming_old, programming_new)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✓ Updated {os.path.basename(filepath)}")
        updated_count += 1
    elif 'resources.html' in content:
        print(f"⊘ Already has Resources: {os.path.basename(filepath)}")
    else:
        print(f"✗ Pattern not found: {os.path.basename(filepath)}")

print(f"\n{'='*50}")
print(f"Total files updated: {updated_count}")
print(f"{'='*50}")
