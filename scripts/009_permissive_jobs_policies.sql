-- Quick Fix: More Permissive RLS Policies for Jobs
-- This makes the job posting/updating more permissive for testing

-- Drop the restrictive policies
DROP POLICY IF EXISTS "Alumni can insert jobs" ON public.jobs;
DROP POLICY IF EXISTS "Users can update their own jobs" ON public.jobs;

-- Create more permissive policies
CREATE POLICY "Authenticated users can insert jobs" ON public.jobs
  FOR INSERT WITH CHECK (auth.uid() = posted_by);

CREATE POLICY "Authenticated users can update their own jobs" ON public.jobs
  FOR UPDATE USING (auth.uid() = posted_by);

-- Optional: Allow all authenticated users to view all jobs (including unapproved ones)
DROP POLICY IF EXISTS "Users can view approved jobs" ON public.jobs;
CREATE POLICY "Authenticated users can view all jobs" ON public.jobs
  FOR SELECT USING (auth.uid() IS NOT NULL);
