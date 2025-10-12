# Environment Setup Instructions

## Fix "No API key found" Error

The error you're seeing is because the Supabase API key is not configured. Here's how to fix it:

### Step 1: Create Environment File
Create a file called `.env.local` in your project root with this content:

```
NEXT_PUBLIC_SUPABASE_URL=https://xeahbntkqbgyuncuzieb.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_actual_supabase_anon_key_here
```

### Step 2: Get Your Supabase API Key
1. Go to your Supabase Dashboard
2. Click on your project
3. Go to Settings → API
4. Copy the "anon public" key
5. Replace `your_actual_supabase_anon_key_here` with the real key

### Step 3: Restart Your Development Server
After creating the .env.local file:
```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

### Alternative: Use the Hardcoded Values
I've already updated the code to use fallback values, so it should work even without the .env.local file, but you should still create it for proper configuration.

### What I Fixed
- Updated all Supabase client files to handle missing environment variables
- Added fallback values so the app works even without .env.local
- The app should now be able to connect to your Supabase database

Try posting a job or scheduling a meeting now - the API key error should be resolved!
