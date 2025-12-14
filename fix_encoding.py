#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Fix UTF-8 encoding corruption in all HTML files"""

import os
import glob

# Define all the corrupted patterns and their correct replacements
FIXES = {
    # Em-dash and quotes
    'â€"': '—',
    'â€œ': '"',
    'â€': '"',
    'â€™': "'",
    'â€˜': "'",
    
    # Emojis that got corrupted
    'ðŸ§': '🧩',
    'ðŸŒ': '🌐',
    'ðŸŸ¢': '🟢',
    'ðŸ"': '🔒',
    'ðŸŽ¯': '🎯',
    'ðŸš€': '🚀',
    'ðŸ'»': '💻',
    'ðŸ›¡': '🛡️',
    'âš™': '⚙️',
    'âœ…': '✅',
    'âš ': '⚠️',
    'ðŸ"¥': '🔥',
    'ðŸ'¡': '💡',
    'ðŸ"': '🔑',
    'ðŸŽ®': '🎮',
    'ðŸ'ª': '💪',
    'â­': '⭐',
    'âž¡': '➡️',
    'ðŸ†š': '🆚',
    'ðŸ"§': '🔧',
    'ðŸ"Š': '📊',
    'ðŸ'¾': '💾',
    'âœ¨': '✨',
    'ðŸš': '🚪',
    'ðŸŽ"': '🎓',
    'ðŸ"': '📝',
    'ðŸ'¼': '💼',
    'ðŸŒŸ': '🌟',
    'ðŸ"±': '📱',
    'ðŸ"¬': '🔬',
    'ðŸ"¦': '📦',
    'ðŸ"': '📁',
    'ðŸ"€': '📀',
    'ðŸ–¥': '🖥️',
    'ðŸ"ˆ': '📈',
    'ðŸ"‰': '📉',
    'ðŸ"Œ': '📌',
    'ðŸ"‹': '📋',
    'ðŸ"': '📍',
    'ðŸ—º': '🗺️',
    'ðŸ—ƒ': '🗃️',
    'ðŸ—‚': '🗂️',
    'ðŸ—„': '🗄️',
    'ðŸ—'': '🗑️',
}

def fix_file(filepath):
    """Fix UTF-8 encoding issues in a file"""
    try:
        # Read the file with UTF-8 encoding
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Apply all fixes
        original_content = content
        for broken, fixed in FIXES.items():
            content = content.replace(broken, fixed)
        
        # Only write if changes were made
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8', newline='') as f:
                f.write(content)
            print(f"✓ Fixed: {os.path.basename(filepath)}")
            return True
        else:
            print(f"  No changes needed: {os.path.basename(filepath)}")
            return False
            
    except Exception as e:
        print(f"✗ Error fixing {filepath}: {e}")
        return False

def main():
    print("=" * 60)
    print("Fixing UTF-8 Encoding Corruption")
    print("=" * 60)
    
    # Find all HTML files (except ULTRA versions)
    html_files = [f for f in glob.glob("*.html") if "ULTRA" not in f]
    
    print(f"\nFound {len(html_files)} HTML files to check")
    print("-" * 60)
    
    fixed_count = 0
    for filepath in sorted(html_files):
        if fix_file(filepath):
            fixed_count += 1
    
    print("-" * 60)
    print(f"\n✓ Fixed {fixed_count} files")
    print(f"  Checked {len(html_files)} total files")
    print("\n" + "=" * 60)
    print("DONE! Refresh your browser to see changes.")
    print("=" * 60)

if __name__ == "__main__":
    main()
