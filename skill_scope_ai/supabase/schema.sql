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
CREATE TABLE resume_analysis (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    job_role TEXT NOT NULL,
    match_score NUMERIC NOT NULL,
    missing_skills JSONB DEFAULT '[]'::jsonb,
    extracted_skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Row Level Security (RLS) configuration

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_analysis ENABLE ROW LEVEL SECURITY;

-- Profile Policies (Users can read/update their own profile)
CREATE POLICY "Users can view own profile." ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile." ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Resume Analysis Policies (Users can read/insert their own analysis)
CREATE POLICY "Users can view own resume analysis." ON resume_analysis FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own resume analysis." ON resume_analysis FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Skills & Resources Policies (Public Read, Admin Write)
CREATE POLICY "Anyone can view skills." ON skills FOR SELECT USING (true);
CREATE POLICY "Anyone can view resources." ON resources FOR SELECT USING (true);

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
