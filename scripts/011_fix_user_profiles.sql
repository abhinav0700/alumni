-- Quick User Profile Fix Script
-- This script helps fix common user profile issues that cause 403 errors

-- Step 1: Check all users and their status
SELECT 
  id,
  email,
  full_name,
  role,
  is_approved,
  created_at,
  CASE 
    WHEN role = 'alumni' AND is_approved = true THEN '✅ CAN_POST_JOBS_AND_MEETINGS'
    WHEN role = 'alumni' AND is_approved = false THEN '⚠️ NEEDS_APPROVAL'
    WHEN role != 'alumni' THEN '❌ NOT_ALUMNI'
    ELSE '❓ UNKNOWN_ISSUE'
  END as status
FROM profiles 
ORDER BY created_at DESC;

-- Step 2: Fix common issues (uncomment the lines you need)

-- Option A: Make all users alumni (if appropriate)
-- UPDATE profiles SET role = 'alumni' WHERE role IS NULL OR role = 'student';

-- Option B: Approve all users (if appropriate)
-- UPDATE profiles SET is_approved = true WHERE is_approved = false;

-- Option C: Fix specific user (replace 'USER_ID' with actual ID)
-- UPDATE profiles SET role = 'alumni', is_approved = true WHERE id = 'USER_ID';

-- Step 3: Verify the fix
-- SELECT id, email, role, is_approved FROM profiles WHERE id = 'USER_ID';
