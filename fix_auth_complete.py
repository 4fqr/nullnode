#!/usr/bin/env python3
import os
import re
import glob

# Complete auth HTML with username display
auth_html = '''                <button id="authButton" class="nav-link" style="background: var(--accent-gradient); border: none; padding: 0.5rem 1.5rem; border-radius: 6px; font-weight: 600; cursor: pointer; color: var(--bg-dark); display: none;">Login with Discord</button>
                <div id="userProfile" style="display: none; align-items: center; gap: 0.75rem;">
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <img id="userAvatar" style="width: 36px; height: 36px; border-radius: 50%; border: 2px solid var(--primary-color); cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'" title="" />
                        <span id="userName" style="color: var(--text-primary); font-weight: 500; font-size: 0.95rem; cursor: default;"></span>
                    </div>
                    <button id="logoutButton" class="nav-link" style="background: rgba(255, 95, 87, 0.1); border: 1px solid #ff5f57; padding: 0.4rem 1rem; border-radius: 6px; font-weight: 500; cursor: pointer; color: #ff5f57; transition: all 0.2s;" onmouseover="this.style.background='rgba(255, 95, 87, 0.2)'" onmouseout="this.style.background='rgba(255, 95, 87, 0.1)'">Logout</button>
                </div>'''

def fix_auth_in_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        with open(filepath, 'r', encoding='latin-1') as f:
            content = f.read()

    original_content = content
    
    # Pattern to match existing auth section
    auth_pattern = r'<button id="authButton".*?</div>\s*</div>\s*</div>\s*</nav>'
    
    # Find and replace the auth section
    if 'id="authButton"' in content:
        # Replace old auth with new complete auth
        replacement = auth_html + '\n            </div>\n        </div>\n    </nav>'
        content = re.sub(auth_pattern, replacement, content, flags=re.DOTALL)
        
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✓ Updated {os.path.basename(filepath)}")
            return True
        else:
            print(f"- No changes needed for {os.path.basename(filepath)}")
            return False
    else:
        print(f"✗ No auth section found in {os.path.basename(filepath)}")
        return False

# Process all HTML files
html_files = glob.glob('*.html') + glob.glob('learn/*.html')
html_files = [f for f in html_files if not f.startswith('test-')]

print("Fixing auth sections in all HTML files...\n")
updated_count = 0

for html_file in sorted(html_files):
    if os.path.exists(html_file) and fix_auth_in_file(html_file):
        updated_count += 1

print(f"\n✓ Done! Updated {updated_count} HTML files with complete auth functionality.")
print("\nWhat was fixed:")
print("- Added username display next to avatar")
print("- Added hover effects on avatar and logout button")  
print("- Improved styling and spacing")
print("- Made avatar slightly larger (36px instead of 32px)")
