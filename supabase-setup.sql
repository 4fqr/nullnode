-- NullSector Lab Access System - Supabase Database Setup
-- Run this in Supabase SQL Editor: https://fshfvihunprbqlukbdpi.supabase.co/project/fshfvihunprbqlukbdpi/sql

-- ============================================
-- 1. PROFILES TABLE
-- ============================================
-- Stores Discord user information and role status
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    discord_id TEXT UNIQUE,
    username TEXT,
    discriminator TEXT,
    avatar_url TEXT,
    has_student_role BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;

-- Policies: Users can only read their own profile
CREATE POLICY "Users can view own profile" 
    ON public.profiles FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
    ON public.profiles FOR UPDATE 
    USING (auth.uid() = id);

-- ============================================
-- 2. LAB CODES TABLE
-- ============================================
-- Stores generated lab access codes
CREATE TABLE IF NOT EXISTS public.lab_codes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    code TEXT UNIQUE NOT NULL,
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    claimed BOOLEAN DEFAULT false,
    claimed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT valid_expiry CHECK (expires_at > generated_at)
);

-- Enable Row Level Security
ALTER TABLE public.lab_codes ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view own codes" ON public.lab_codes;
DROP POLICY IF EXISTS "Users can insert own codes" ON public.lab_codes;
DROP POLICY IF EXISTS "Users can update own codes" ON public.lab_codes;

-- Policies: Users can only see their own codes
CREATE POLICY "Users can view own codes" 
    ON public.lab_codes FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own codes" 
    ON public.lab_codes FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own codes" 
    ON public.lab_codes FOR UPDATE 
    USING (auth.uid() = user_id);

-- Index for faster code lookups
CREATE INDEX IF NOT EXISTS idx_lab_codes_code ON public.lab_codes(code);
CREATE INDEX IF NOT EXISTS idx_lab_codes_user_id ON public.lab_codes(user_id);
CREATE INDEX IF NOT EXISTS idx_lab_codes_expires_at ON public.lab_codes(expires_at);

-- ============================================
-- 3. LAB SESSIONS TABLE
-- ============================================
-- Tracks active Docker lab sessions
CREATE TABLE IF NOT EXISTS public.lab_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    code_id UUID REFERENCES public.lab_codes(id) ON DELETE SET NULL,
    container_id TEXT UNIQUE NOT NULL,
    container_port INTEGER NOT NULL,
    lab_url TEXT NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    active BOOLEAN DEFAULT true,
    CONSTRAINT valid_session_expiry CHECK (expires_at > started_at)
);

-- Enable Row Level Security
ALTER TABLE public.lab_sessions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view own sessions" ON public.lab_sessions;
DROP POLICY IF EXISTS "Users can insert own sessions" ON public.lab_sessions;
DROP POLICY IF EXISTS "Users can update own sessions" ON public.lab_sessions;

-- Policies: Users can only see their own sessions
CREATE POLICY "Users can view own sessions" 
    ON public.lab_sessions FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sessions" 
    ON public.lab_sessions FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions" 
    ON public.lab_sessions FOR UPDATE 
    USING (auth.uid() = user_id);

-- Index for faster session lookups
CREATE INDEX IF NOT EXISTS idx_lab_sessions_user_id ON public.lab_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_lab_sessions_container_id ON public.lab_sessions(container_id);
CREATE INDEX IF NOT EXISTS idx_lab_sessions_expires_at ON public.lab_sessions(expires_at);

-- ============================================
-- 4. TRIGGER: AUTO-CREATE PROFILE ON SIGNUP
-- ============================================
-- Automatically create a profile when a user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, discord_id, username, avatar_url)
    VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'provider_id',
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'avatar_url'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 5. FUNCTION: CHECK CODE GENERATION COOLDOWN
-- ============================================
-- Returns true if user can generate a new code (20-minute cooldown)
CREATE OR REPLACE FUNCTION public.can_generate_code(user_uuid UUID)
RETURNS BOOLEAN AS $$
DECLARE
    last_generated TIMESTAMP WITH TIME ZONE;
    cooldown_minutes INTEGER := 20;
BEGIN
    -- Get the most recent code generation time
    SELECT generated_at INTO last_generated
    FROM public.lab_codes
    WHERE user_id = user_uuid
    ORDER BY generated_at DESC
    LIMIT 1;

    -- If no codes exist, user can generate
    IF last_generated IS NULL THEN
        RETURN true;
    END IF;

    -- Check if cooldown period has passed
    RETURN (timezone('utc'::text, now()) - last_generated) > (cooldown_minutes || ' minutes')::INTERVAL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 6. FUNCTION: CLEANUP EXPIRED RESOURCES
-- ============================================
-- Removes expired codes and inactive sessions
CREATE OR REPLACE FUNCTION public.cleanup_expired_labs()
RETURNS void AS $$
BEGIN
    -- Mark expired sessions as inactive
    UPDATE public.lab_sessions
    SET active = false
    WHERE expires_at < timezone('utc'::text, now())
    AND active = true;

    -- Delete expired unclaimed codes (older than 24 hours)
    DELETE FROM public.lab_codes
    WHERE expires_at < timezone('utc'::text, now())
    AND claimed = false
    AND generated_at < timezone('utc'::text, now()) - INTERVAL '24 hours';

    -- Delete old inactive sessions (older than 7 days)
    DELETE FROM public.lab_sessions
    WHERE active = false
    AND expires_at < timezone('utc'::text, now()) - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 7. SCHEDULED JOB (Optional - requires pg_cron extension)
-- ============================================
-- Uncomment below if pg_cron is available in your Supabase project
-- SELECT cron.schedule(
--     'cleanup-expired-labs',
--     '*/15 * * * *',  -- Run every 15 minutes
--     $$ SELECT public.cleanup_expired_labs(); $$
-- );

-- ============================================
-- 8. GRANT PERMISSIONS
-- ============================================
-- Grant necessary permissions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.lab_codes TO authenticated;
GRANT ALL ON public.lab_sessions TO authenticated;

-- Grant execute on functions
GRANT EXECUTE ON FUNCTION public.can_generate_code(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cleanup_expired_labs() TO authenticated;

-- ============================================
-- SETUP COMPLETE
-- ============================================
-- Run this entire script in Supabase SQL Editor
-- Then configure Discord OAuth in Authentication > Providers
