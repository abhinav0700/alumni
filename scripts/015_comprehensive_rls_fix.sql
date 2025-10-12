-- COMPREHENSIVE RLS FIX - Fixes All 403 Errors
-- This script fixes RLS policies for jobs, meetings, and notifications

-- ===========================================
-- STEP 1: FIX NOTIFICATIONS TABLE (CRITICAL)
-- ===========================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON public.notifications;

-- Create permissive policies for notifications
CREATE POLICY "Users can view their own notifications" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- Allow system/triggers to insert notifications
CREATE POLICY "System can insert notifications" ON public.notifications
  FOR INSERT WITH CHECK (true);

-- ===========================================
-- STEP 2: FIX MEETINGS TABLE
-- ===========================================

-- Drop existing restrictive policies
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
-- STEP 3: FIX JOBS TABLE
-- ===========================================

-- Drop existing restrictive policies
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
-- STEP 4: VERIFY ALL POLICIES
-- ===========================================

-- Check all policies
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles, 
  cmd
FROM pg_policies 
WHERE tablename IN ('jobs', 'meetings', 'notifications')
ORDER BY tablename, policyname;

-- ===========================================
-- EMERGENCY FALLBACK (If Still Getting 403)
-- ===========================================

-- If you still get 403 errors, uncomment these lines:
-- ALTER TABLE public.notifications DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.meetings DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.jobs DISABLE ROW LEVEL SECURITY;
