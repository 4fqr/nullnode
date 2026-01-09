#!/usr/bin/env python3
"""
Delete OLD broken section from hacking-bonus-kali-part2.html
Removes lines 16746-19558 (OLD broken content with escaped quotes)
"""

# Read file
with open('hacking-bonus-kali-part2.html', 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"Original file: {len(lines)} lines")

# Keep lines 1-16745 (everything up to and including </div>)
# Delete lines 16746-19558 (OLD broken content)
# Keep lines 19559+ (GOOD Metasploit content starting with "# Loads:")

# Python uses 0-based indexing, so:
# Line 16746 in editor = index 16745
# Line 19558 in editor = index 19557

lines_to_keep = lines[:16745] + lines[19558:]

print(f"After deletion: {len(lines_to_keep)} lines")
print(f"Deleted: {len(lines) - len(lines_to_keep)} lines")

# Write back
with open('hacking-bonus-kali-part2.html', 'w', encoding='utf-8') as f:
    f.writelines(lines_to_keep)

print("✅ OLD broken section deleted!")
print("File now contains:")
print(f"  - Lines 1-16745: All good content (Sections 1-11, Labs, Burp Suite, BloodHound)")
print(f"  - Lines 16746+: M-Tools comprehensive Metasploit, SQLmap, Wireshark, Hydra, John, Hashcat, Gobuster")
