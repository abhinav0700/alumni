# MongoDB Integration Setup

## Environment Variables

Create a `.env.local` file in your project root with these variables:

```env
# Supabase Configuration (for user authentication)
NEXT_PUBLIC_SUPABASE_URL=https://xeahbntkqbgyuncuzieb.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here

# MongoDB Configuration (for meetings and jobs)
MONGODB_URI=mongodb://localhost:27017/alumni
MONGODB_DB=alumni

# Application Configuration
NEXT_PUBLIC_BASE_URL=http://localhost:3005
NEXT_PUBLIC_DEV_SUPABASE_REDIRECT_URL=http://localhost:3005/dashboard
```

## Installation

1. Install the new dependencies:
```bash
npm install mongodb mongoose
# or
yarn add mongodb mongoose
# or
pnpm add mongodb mongoose
```

2. Make sure MongoDB is running on your local machine:
```bash
# Start MongoDB (if using local installation)
mongod

# Or if using Docker:
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

## What's Changed

### ✅ MongoDB Integration
- **Meetings**: Now stored in MongoDB instead of Supabase
- **Jobs**: Now stored in MongoDB instead of Supabase
- **User Authentication**: Still uses Supabase (for profiles, login, etc.)

### ✅ API Routes Created
- `GET/POST /api/meetings` - List and create meetings
- `GET/PUT/DELETE /api/meetings/[id]` - Individual meeting operations
- `GET/POST /api/jobs` - List and create jobs
- `GET/PUT/DELETE /api/jobs/[id]` - Individual job operations

### ✅ Updated Pages
- **Meeting Schedule**: Now uses MongoDB API
- **Meeting List**: Now fetches from MongoDB
- **Job Posting**: Now uses MongoDB API
- **Job List**: Now fetches from MongoDB

## Benefits

1. **No More RLS Issues**: MongoDB doesn't have Row Level Security restrictions
2. **Better Performance**: Direct database access without Supabase overhead
3. **More Control**: Full control over data structure and queries
4. **Scalability**: MongoDB scales better for large datasets

## Testing

1. Start your development server:
```bash
npm run dev
```

2. Try creating a meeting or job - should work without 403 errors!

3. Check your MongoDB database to see the data:
```bash
# Connect to MongoDB
mongosh alumni

# View meetings
db.meetings.find()

# View jobs
db.jobs.find()
```

## Troubleshooting

If you get connection errors:
1. Make sure MongoDB is running
2. Check the MONGODB_URI in your .env.local file
3. Verify the database name is correct
4. Check the MongoDB logs for any issues
