import os
import glob
import re

root = r"c:\Users\geeth\Documents\Null\nullnode-main"

updated_count = 0
already_done = 0
failed = 0

# More flexible regex patterns
hacking_pattern = r'(<a href="roadmap-programming\.html" class="nav-link[^"]*">Programming</a>)\s*\n\s*(<a href="faq\.html")'
hacking_replacement = r'\1\n                <a href="resources.html" class="nav-link">Resources</a>\n                \2'

programming_pattern = r'(<a href="roadmap-programming\.html" class="nav-link active">Programming</a>)\s*\n\s*(<a href="faq\.html")'
programming_replacement = r'\1\n                <a href="resources.html" class="nav-link">Resources</a>\n                \2'

# Update all chapter files
print("Updating all chapter files...")
for filepath in glob.glob(os.path.join(root, "*-ch*.html")):
    filename = os.path.basename(filepath)
    
    with open(filepath, 'r', encoding='utf-8') as f:
        original_content = f.read()
    
    # Check if already has resources link
    if '<a href="resources.html" class="nav-link">Resources</a>' in original_content:
        print(f"⊘ Already has Resources: {filename}")
        already_done += 1
        continue
    
    # Try to update
    if filename.startswith("hacking"):
        new_content = re.sub(hacking_pattern, hacking_replacement, original_content)
    else:  # programming
        new_content = re.sub(programming_pattern, programming_replacement, original_content)
    
    # Check if replacement worked
    if new_content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"✓ Updated {filename}")
        updated_count += 1
    else:
        print(f"✗ Pattern not found: {filename}")
        failed += 1

print(f"\n{'='*60}")
print(f"✓ Successfully updated: {updated_count}")
print(f"⊘ Already had Resources: {already_done}")
print(f"✗ Failed (manual review needed): {failed}")
print(f"{'='*60}")
