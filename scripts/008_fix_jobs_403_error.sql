-- Diagnostic and Fix Script for Jobs 403 Error
-- Run this in your Supabase SQL Editor to diagnose and fix the issue

-- Step 1: Check current user's profile status
-- Replace 'YOUR_USER_ID' with the actual user ID from the error
SELECT 
  id,
  email,
  full_name,
  role,
  is_approved,
  created_at
FROM profiles 
WHERE id = 'YOUR_USER_ID';

-- Step 2: Check if there are any jobs posted by this user
SELECT 
  id,
  title,
  company,
  posted_by,
  is_approved,
  is_active,
  created_at
FROM jobs 
WHERE posted_by = 'YOUR_USER_ID';

-- Step 3: Fix common issues

-- Option A: If user should be alumni but isn't marked as such
-- UPDATE profiles SET role = 'alumni' WHERE id = 'YOUR_USER_ID';

-- Option B: If user should be approved but isn't
-- UPDATE profiles SET is_approved = true WHERE id = 'YOUR_USER_ID';

-- Option C: If you want to temporarily disable RLS for testing (NOT RECOMMENDED FOR PRODUCTION)
-- ALTER TABLE jobs DISABLE ROW LEVEL SECURITY;

-- Step 4: Alternative RLS policies (more permissive for testing)
-- Drop existing policies
DROP POLICY IF EXISTS "Alumni can insert jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can update their own jobs" ON public.jobs;

-- Create more permissive policies for testing
CREATE POLICY "Authenticated users can insert jobs" ON public.jobs
  FOR INSERT WITH CHECK (auth.uid() = posted_by);

CREATE POLICY "Authenticated users can update their own jobs" ON public.jobs
  FOR UPDATE USING (auth.uid() = posted_by);

-- Step 5: Check if the user has the correct role and approval status
-- This query will help you understand what's wrong
SELECT 
  p.id,
  p.email,
  p.role,
  p.is_approved,
  CASE 
    WHEN p.role = 'alumni' AND p.is_approved = true THEN 'CAN_POST_JOBS'
    WHEN p.role = 'alumni' AND p.is_approved = false THEN 'NEEDS_APPROVAL'
    WHEN p.role != 'alumni' THEN 'NOT_ALUMNI'
    ELSE 'UNKNOWN_ISSUE'
  END as job_posting_status
FROM profiles p
WHERE p.id = 'YOUR_USER_ID';
