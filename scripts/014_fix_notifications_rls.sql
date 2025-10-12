-- Fix Notifications Table RLS Policies
-- This fixes the 403 error when inserting meetings/jobs due to notification triggers

-- ===========================================
-- FIX NOTIFICATIONS TABLE POLICIES
-- ===========================================

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Users can view their own notifications" ON public.notifications;
DROP POLICY IF EXISTS "Users can update their own notifications" ON public.notifications;

-- Create permissive policies for notifications
CREATE POLICY "Users can view their own notifications" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- CRITICAL: Allow system to insert notifications (for triggers)
CREATE POLICY "System can insert notifications" ON public.notifications
  FOR INSERT WITH CHECK (true);

-- ===========================================
-- ALTERNATIVE: DISABLE RLS FOR NOTIFICATIONS
-- ===========================================

-- If the above doesn't work, temporarily disable RLS for notifications:
-- ALTER TABLE public.notifications DISABLE ROW LEVEL SECURITY;

-- ===========================================
-- VERIFY POLICIES
-- ===========================================

-- Check notifications policies
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
WHERE tablename = 'notifications'
ORDER BY policyname;
