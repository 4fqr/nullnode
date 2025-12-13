# Supabase Discord OAuth Setup Guide

## 🚨 Error: "Database error saving new user"

This error occurs because the database tables haven't been created yet. Follow these steps:

---

## Step 1: Run Database Setup SQL

1. Go to Supabase SQL Editor: https://fshfvihunprbqlukbdpi.supabase.co/project/fshfvihunprbqlukbdpi/sql

2. Click **"New Query"**

3. Copy the entire contents of `supabase-setup.sql` file

4. Paste into the SQL editor

5. Click **"Run"** (or press Ctrl+Enter)

6. You should see: ✅ "Success. No rows returned"

---

## Step 2: Configure Discord OAuth Provider

### A. Get Discord Application Credentials

1. Go to Discord Developer Portal: https://discord.com/developers/applications

2. Click **"New Application"** (or select existing)

3. Name it: `NullSector Labs` (or any name you prefer)

4. Go to **OAuth2** → **General** in the left sidebar

5. Copy these values:
   - **Client ID** (e.g., 123456789012345678)
   - **Client Secret** (click "Reset Secret" if needed, then copy)

6. Under **Redirects**, click **"Add Redirect"** and add:
   ```
   https://fshfvihunprbqlukbdpi.supabase.co/auth/v1/callback
   ```

7. Click **"Save Changes"**

### B. Configure Supabase

1. Go to Supabase Authentication: https://fshfvihunprbqlukbdpi.supabase.co/project/fshfvihunprbqlukbdpi/auth/providers

2. Scroll down and find **Discord**

3. Toggle **"Enable Discord Provider"** to ON

4. Paste your Discord credentials:
   - **Discord Client ID**: [paste from step A5]
   - **Discord Client Secret**: [paste from step A5]

5. Click **"Save"**

---

## Step 3: Test the Login

1. Clear your browser cache and cookies for localhost

2. Go to http://localhost:3000/

3. Click the **"Login"** button in the header

4. You'll be redirected to Discord to authorize

5. After clicking **"Authorize"**, you should be redirected back successfully

6. Your Discord profile should appear in the header

---

## Step 4: Verify Database Tables

After successful login, verify tables were created:

1. Go to Supabase Table Editor: https://fshfvihunprbqlukbdpi.supabase.co/project/fshfvihunprbqlukbdpi/editor

2. You should see these tables:
   - ✅ `profiles` - Your user profile should be there
   - ✅ `lab_codes` - Empty for now
   - ✅ `lab_sessions` - Empty for now

---

## Step 5: Test Lab Access

1. Go to http://localhost:3000/lab.html

2. You should see one of three states:

   - **If you have the Student role (ID: 1444364842378199050)**:
     - "Generate Lab Code" button appears
     - Click it to generate a code
     - Click "Launch Lab Now" to start

   - **If you DON'T have the Student role**:
     - Message: "You need the Student role to access labs"
     - Instructions to join Discord

   - **If not logged in**:
     - "Login with Discord" button

---

## 🔧 Troubleshooting

### Error: "Database error saving new user"
- ✅ Run `supabase-setup.sql` in Supabase SQL Editor
- ✅ Check that the `handle_new_user()` trigger was created

### Error: "Invalid OAuth credentials"
- ✅ Verify Discord Client ID and Secret are correct
- ✅ Make sure you saved changes in Discord Developer Portal
- ✅ Check redirect URL matches exactly

### Error: "Redirect URL mismatch"
- ✅ Add redirect URL in Discord OAuth settings:
  `https://fshfvihunprbqlukbdpi.supabase.co/auth/v1/callback`

### "Login" button doesn't appear
- ✅ Check browser console for JavaScript errors
- ✅ Verify Supabase credentials in HTML files are correct

### Can't check Discord role
- ✅ Make sure Discord OAuth has `guilds.members.read` scope
- ✅ Verify GUILD_ID and STUDENT_ROLE_ID are correct in lab.html

---

## 📋 Summary Checklist

- [ ] Run `supabase-setup.sql` in Supabase SQL Editor
- [ ] Create Discord application (or use existing)
- [ ] Add redirect URL to Discord OAuth
- [ ] Copy Discord Client ID and Secret
- [ ] Enable Discord provider in Supabase
- [ ] Paste Discord credentials in Supabase
- [ ] Test login at http://localhost:3000/
- [ ] Verify profile created in `profiles` table
- [ ] Test lab access at http://localhost:3000/lab.html

---

## 🎉 Success!

Once complete, users can:
1. Login with Discord
2. Get Student role in Discord server
3. Generate lab codes (15-minute validity)
4. Launch Docker labs
5. Generate new codes after 20-minute cooldown

---

## 📞 Need Help?

- Discord: https://discord.gg/Tz9Y3wea32
- GitHub Issues: https://github.com/4fqr/nullnode/issues
