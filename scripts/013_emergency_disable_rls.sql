-- EMERGENCY FIX: Disable RLS Temporarily
-- Use this if the above script doesn't work

-- Disable RLS for meetings and jobs tables
ALTER TABLE public.meetings DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs DISABLE ROW LEVEL SECURITY;

-- This will allow any user to insert/update/delete meetings and jobs
-- WARNING: This removes all security restrictions temporarily

-- To re-enable RLS later (after fixing policies):
-- ALTER TABLE public.meetings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
