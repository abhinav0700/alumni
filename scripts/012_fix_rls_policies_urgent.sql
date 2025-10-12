-- URGENT: Fix RLS Policies for Meetings and Jobs
-- This script removes restrictive policies and allows any authenticated user to insert

-- ===========================================
-- FIX MEETINGS TABLE POLICIES
-- ===========================================

-- Drop all existing restrictive policies
DROP POLICY IF EXISTS "Alumni can insert meetings" ON public.meetings;
DROP POLICY IF EXISTS "Users can update their own meetings" ON public.meetings;
DROP POLICY IF EXISTS "Users can view active meetings" ON public.meetings;

-- Create permissive policies for meetings
CREATE POLICY "Any authenticated user can insert meetings" ON public.meetings
  FOR INSERT WITH CHECK (auth.uid() = host_id);

CREATE POLICY "Users can update their own meetings" ON public.meetings
  FOR UPDATE USING (auth.uid() = host_id);

CREATE POLICY "Any authenticated user can view all meetings" ON public.meetings
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- ===========================================
-- FIX JOBS TABLE POLICIES  
-- ===========================================

-- Drop all existing restrictive policies
DROP POLICY IF EXISTS "Alumni can insert jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can update their own jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can view approved jobs" ON public.jobs;

-- Create permissive policies for jobs
CREATE POLICY "Any authenticated user can insert jobs" ON public.jobs
  FOR INSERT WITH CHECK (auth.uid() = posted_by);

CREATE POLICY "Users can update their own jobs" ON public.jobs
  FOR UPDATE USING (auth.uid() = posted_by);

CREATE POLICY "Any authenticated user can view all jobs" ON public.jobs
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- ===========================================
-- VERIFY POLICIES ARE APPLIED
-- ===========================================

-- Check that policies are correctly applied
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles, 
  cmd, 
  qual, 
  with_check
FROM pg_policies 
WHERE tablename IN ('jobs', 'meetings')
ORDER BY tablename, policyname;

-- ===========================================
-- ALTERNATIVE: TEMPORARILY DISABLE RLS (IF NEEDED)
-- ===========================================

-- If the above doesn't work, you can temporarily disable RLS:
-- ALTER TABLE public.meetings DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.jobs DISABLE ROW LEVEL SECURITY;

-- Remember to re-enable RLS later:
-- ALTER TABLE public.meetings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
