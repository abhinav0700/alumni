-- Temporary workaround: Comment out email validation in registration
-- This is ONLY for testing - make sure to run the proper migration later

-- In app/auth/register/page.tsx, temporarily comment out these lines:
-- if (!formData.email.endsWith("@svce.ac.in")) {
--   setError("Only @svce.ac.in email addresses are allowed to register")
--   setIsLoading(false)
--   return
-- }

-- In app/auth/login/page.tsx, temporarily comment out these lines:
-- if (!email.endsWith("@svce.ac.in")) {
--   setError("Only @svce.ac.in email addresses are allowed")
--   setIsLoading(false)
--   return
-- }
