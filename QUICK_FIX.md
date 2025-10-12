# Environment Variables for MongoDB Integration

Create a `.env.local` file in your project root with these variables:

```env
# MongoDB Configuration
MONGODB_URI=mongodb://localhost:27017/alumni
MONGODB_DB=alumni

# Application Configuration
NEXT_PUBLIC_BASE_URL=http://localhost:3005

# Supabase Configuration (for user authentication)
NEXT_PUBLIC_SUPABASE_URL=https://xeahbntkqbgyuncuzieb.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

## Quick Setup Steps:

1. **Create .env.local file** with the above content
2. **Start MongoDB**:
   ```bash
   # If you have MongoDB installed locally:
   mongod
   
   # Or using Docker:
   docker run -d -p 27017:27017 --name mongodb mongo:latest
   ```
3. **Restart your Next.js server**:
   ```bash
   npm run dev
   ```

## What's Fixed:

✅ **MongoDB Connection**: Removed unsupported `bufferMaxEntries` option
✅ **API Responses**: Added proper JSON headers and error handling
✅ **Error Handling**: Better error messages and logging
✅ **Frontend Fetching**: Added proper error handling for API calls

The errors should be resolved now!
