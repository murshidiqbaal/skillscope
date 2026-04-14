-- Supabase Schema for SkillScope AI

-- Create Extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Profiles Table (Linked to auto-generated Auth Users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT,
    name TEXT,
    education JSONB DEFAULT '[]'::jsonb,
    experience JSONB DEFAULT '[]'::jsonb,
    skills JSONB DEFAULT '[]'::jsonb,
    projects JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Skills Table (For Trending Skills)
CREATE TABLE skills (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    category TEXT,
    demand_score NUMERIC DEFAULT 0.0,
    growth_rate NUMERIC DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Resources Table (Links to Skills)
CREATE TABLE resources (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    skill_id UUID REFERENCES skills(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    type TEXT, -- e.g., 'youtube', 'course', 'documentation', 'article'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Resume Analysis Table
CREATE TABLE public.resume_analysis (
    id UUID NOT NULL DEFAULT gen_random_uuid (),
    user_id UUID NULL,
    match_score INTEGER NOT NULL,
    missing_skills JSONB NULL,
    detected_skills JSONB NULL,
    created_at TIMESTAMP WITH TIME ZONE NULL DEFAULT now(),
    CONSTRAINT resume_analysis_pkey PRIMARY KEY (id),
    -- Assuming references auth.users instead of users to match Supabase defaults
    CONSTRAINT resume_analysis_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
) TABLESPACE pg_default;

-- 5. Chat Sessions Table
CREATE TABLE IF NOT EXISTS public.chat_sessions (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title TEXT NOT NULL DEFAULT 'New Chat',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT chat_sessions_pkey PRIMARY KEY (id),
    CONSTRAINT chat_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
) TABLESPACE pg_default;

-- 6. Chat Messages Table
CREATE TABLE IF NOT EXISTS public.chat_messages (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    conversation_id UUID NULL,
    message TEXT NOT NULL,
    sender TEXT NOT NULL,
    is_error BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT chat_messages_pkey PRIMARY KEY (id),
    CONSTRAINT chat_messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE,
    CONSTRAINT chat_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.chat_sessions (id) ON DELETE CASCADE,
    CONSTRAINT chat_messages_sender_check CHECK (sender IN ('user', 'ai'))
) TABLESPACE pg_default;

-- Backward-compatible additive columns (safe for existing chat_messages table)
ALTER TABLE public.chat_messages
    ADD COLUMN IF NOT EXISTS conversation_id UUID NULL REFERENCES public.chat_sessions (id) ON DELETE CASCADE,
    ADD COLUMN IF NOT EXISTS is_error BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now();

-- Row Level Security (RLS) configuration

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_analysis ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Profile Policies (Users can read/update their own profile)
CREATE POLICY "Users can view own profile." ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile." ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Resume Analysis Policies (Users can read/insert their own analysis)
CREATE POLICY "Users can view own resume analysis." ON resume_analysis FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own resume analysis." ON resume_analysis FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can view own chat sessions." ON chat_sessions;
DROP POLICY IF EXISTS "Users can insert own chat sessions." ON chat_sessions;
DROP POLICY IF EXISTS "Users can update own chat sessions." ON chat_sessions;
DROP POLICY IF EXISTS "Users can delete own chat sessions." ON chat_sessions;
DROP POLICY IF EXISTS "Users can view own chat messages." ON chat_messages;
DROP POLICY IF EXISTS "Users can insert own chat messages." ON chat_messages;
DROP POLICY IF EXISTS "Users can update own chat messages." ON chat_messages;
DROP POLICY IF EXISTS "Users can delete own chat messages." ON chat_messages;

CREATE POLICY "Users can view own chat sessions."
ON chat_sessions FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own chat sessions."
ON chat_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own chat sessions."
ON chat_sessions FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own chat sessions."
ON chat_sessions FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own chat messages."
ON chat_messages FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own chat messages."
ON chat_messages FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own chat messages."
ON chat_messages FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own chat messages."
ON chat_messages FOR DELETE USING (auth.uid() = user_id);

-- Skills & Resources Policies (Public Read, Admin Write)
CREATE POLICY "Anyone can view skills." ON skills FOR SELECT USING (true);
CREATE POLICY "Anyone can view resources." ON resources FOR SELECT USING (true);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_updated_at
ON public.chat_sessions (user_id, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_messages_user_conversation_created_at
ON public.chat_messages (user_id, conversation_id, created_at DESC);

-- Functions
-- Function to automatically create a profile when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, name)
  VALUES (new.id, new.email, new.raw_user_meta_data->>'full_name');
  RETURN new;
END;
$$;

-- Trigger to call handle_new_user()
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
