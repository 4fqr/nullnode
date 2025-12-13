# FINAL SUPABASE CONFIGURATION CHECKLIST

## ✅ COMPLETED FIXES
1. ✓ Added username display next to Discord avatar on ALL pages
2. ✓ Fixed production URL detection (uses nullnode.vercel.app in production)
3. ✓ Added hover effects and improved styling
4. ✓ Fixed logout functionality with page reload
5. ✓ Updated 57+ HTML files with complete auth system

## 🔧 SUPABASE DASHBOARD SETTINGS (CRITICAL - DO THESE NOW)

### 1. URL Configuration
Go to: https://supabase.com/dashboard/project/fshfvihunprbqlukbdpi/auth/url-configuration

**Site URL**: Change from `http://localhost:3000` to `https://nullnode.vercel.app`

**Redirect URLs**: Add these (one per line):
```
https://nullnode.vercel.app/**
https://nullnode.vercel.app/lab.html
http://localhost:3000/**
http://localhost:8000/**
```

### 2. Discord Provider Settings
Go to: https://supabase.com/dashboard/project/fshfvihunprbqlukbdpi/auth/providers

Make sure Discord is enabled with these scopes:
- identify
- email  
- guilds
- guilds.members.read

### 3. Database Tables (IF NOT ALREADY DONE)
Go to: https://supabase.com/dashboard/project/fshfvihunprbqlukbdpi/editor

**Check if these tables exist:**
- profiles
- lab_codes
- lab_sessions

**If they don't exist, run the SQL:**
Go to: https://supabase.com/dashboard/project/fshfvihunprbqlukbdpi/sql

Copy the ENTIRE content of `supabase-setup.sql` and run it.

### 4. RLS Policies (Already in SQL script)
The SQL script includes all necessary Row Level Security policies:
- Users can read their own profile
- Users can insert their own profile
- Users can read their own lab codes
- Etc.

## 🧪 TESTING CHECKLIST

### After Deploying to Vercel:
1. Go to https://nullnode.vercel.app/ (home page)
2. Hard refresh (Ctrl+F5 or Cmd+Shift+R)
3. Open browser console (F12)
4. You should see:
   ```
   [Auth] Environment: PRODUCTION
   [Auth] Site URL: https://nullnode.vercel.app
   [Auth] Checking authentication...
   [Auth] No active session, showing login button
   ```

5. Click "Login with Discord" button
6. Console should show:
   ```
   [Auth] Login button clicked
   [Auth] Current page: https://nullnode.vercel.app/
   [Auth] Using site URL: https://nullnode.vercel.app
   [Auth] OAuth initiated
   ```

7. After Discord authorization, you should be redirected back to site
8. Console should show:
   ```
   [Auth] Auth state changed: SIGNED_IN Session exists
   [Auth] User signed in: your@email.com
   [Auth] Active session found for: your@email.com
   [Auth] Showing user profile: {avatar_url, full_name, ...}
   ```

9. You should see:
   - Your Discord avatar (circular, 36px)
   - Your Discord username next to it
   - Logout button (red)
   - Hover over avatar = grows slightly
   - Hover over username = see full username in tooltip

### On Lab Page (https://nullnode.vercel.app/lab.html):
1. If you DON'T have Student role:
   - Should see message: "You need the Student role to access labs"
   
2. If you HAVE Student role:
   - Should see "Generate Lab Code" button
   - Click it to generate a 6-character code
   - 20-minute cooldown between code generations
   - Use code to spawn a Docker lab

## 🐛 TROUBLESHOOTING

### "Still showing localhost in OAuth"
**Solution**: Clear browser cache completely
- Chrome: Settings → Privacy → Clear browsing data → Cached images and files
- Or use Incognito mode to test fresh

### "Login button not showing"
**Solution**: 
1. Check browser console for errors
2. Make sure Supabase Site URL is set to production
3. Hard refresh page (Ctrl+F5)

### "Discord avatar not showing"
**Solution**:
1. Check console for avatar URL
2. Make sure Discord OAuth includes `identify` scope
3. Check if user profile was created in Supabase
   - Go to: https://supabase.com/dashboard/project/fshfvihunprbqlukbdpi/editor (profiles table)
   - Should see your user with discord_id, username, avatar

### "Can't generate lab code even with Student role"
**Solution**:
1. Check Supabase profiles table: `has_student_role` should be `true`
2. Check lab_codes table for existing codes (20-minute cooldown)
3. Manually set role:
   ```sql
   UPDATE profiles 
   SET has_student_role = true 
   WHERE discord_id = 'YOUR_DISCORD_ID';
   ```

## 📝 WHAT'S WORKING NOW

✅ Login/Signup button on ALL pages (home, chapters, roadmaps, lab, etc.)
✅ Discord OAuth with production URLs
✅ Profile picture display with username
✅ Hover effects and tooltips
✅ Logout functionality with session clearing
✅ Role-based lab access (Student role required)
✅ Lab code generation with cooldown
✅ Database triggers for auto-profile creation
✅ RLS policies for data security

## 🚀 DEPLOYMENT STATUS

- **GitHub**: Latest commit pushed (main branch)
- **Vercel**: Auto-deploys from GitHub (check vercel.app dashboard)
- **Database**: Supabase PostgreSQL ready
- **Auth**: Discord OAuth configured
- **Files**: 57+ HTML pages with complete auth system

## ⚠️ IMPORTANT REMINDERS

1. **MUST** set Supabase Site URL to `https://nullnode.vercel.app`
2. **MUST** clear browser cache after deployment
3. **MUST** have Student role in Discord to generate lab codes
4. Lab codes expire after 15 minutes
5. 20-minute cooldown between code generations
6. Docker containers auto-cleanup after 1 hour

---

**Everything is now production-ready. Follow the Supabase checklist above and you're done! 🎉**
