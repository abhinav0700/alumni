-- Migration script to update email domain from @mce.edu.in to @svce.ac.in
-- This script safely updates the database constraints

-- Step 1: Drop the existing constraint (if it exists)
ALTER TABLE profiles 
DROP CONSTRAINT IF EXISTS check_email_domain;

-- Step 2: Add the new constraint for @svce.ac.in
ALTER TABLE profiles 
ADD CONSTRAINT check_email_domain 
CHECK (email LIKE '%@svce.ac.in');

-- Step 3: Update the handle_new_user function to validate the new email domain
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Validate email domain
  IF NEW.email NOT LIKE '%@svce.ac.in' THEN
    RAISE EXCEPTION 'Only @svce.ac.in email addresses are allowed';
  END IF;

  INSERT INTO public.profiles (id, email, full_name, role, graduation_year, department, is_approved)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'role',
    CASE 
      WHEN NEW.raw_user_meta_data->>'graduation_year' IS NOT NULL 
      THEN (NEW.raw_user_meta_data->>'graduation_year')::INTEGER
      ELSE NULL
    END,
    NEW.raw_user_meta_data->>'department',
    true -- Auto-approve users
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 4: Optional - Update existing user emails (if you have any)
-- WARNING: Only run this if you want to update existing users' email domains
-- UPDATE profiles SET email = REPLACE(email, '@mce.edu.in', '@svce.ac.in') WHERE email LIKE '%@mce.edu.in';
