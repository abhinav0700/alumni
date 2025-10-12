-- Comprehensive Fix for Jobs and Meetings 403 Errors
-- This script fixes the RLS policies for both jobs and meetings tables

-- ===========================================
-- FIX JOBS TABLE POLICIES
-- ===========================================

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Alumni can insert jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can update their own jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can view approved jobs" ON public.jobs;

-- Create more permissive policies for jobs
CREATE POLICY "Authenticated users can insert jobs" ON public.jobs
  FOR INSERT WITH CHECK (auth.uid() = posted_by);

CREATE POLICY "Authenticated users can update their own jobs" ON public.jobs
  FOR UPDATE USING (auth.uid() = posted_by);

CREATE POLICY "Authenticated users can view all jobs" ON public.jobs
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- ===========================================
-- FIX MEETINGS TABLE POLICIES
-- ===========================================

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Alumni can insert meetings" ON public.meetings;
DROP POLICY IF EXISTS "Users can update their own meetings" ON public.meetings;
DROP POLICY IF EXISTS "Users can view active meetings" ON public.meetings;

-- Create more permissive policies for meetings
CREATE POLICY "Authenticated users can insert meetings" ON public.meetings
  FOR INSERT WITH CHECK (auth.uid() = host_id);

CREATE POLICY "Authenticated users can update their own meetings" ON public.meetings
  FOR UPDATE USING (auth.uid() = host_id);

CREATE POLICY "Authenticated users can view all meetings" ON public.meetings
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- ===========================================
-- VERIFY POLICIES ARE APPLIED
-- ===========================================

-- Check jobs policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename IN ('jobs', 'meetings')
ORDER BY tablename, policyname;
