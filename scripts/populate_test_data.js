// Simple script to populate test data in MongoDB
// Run with: node scripts/populate_test_data.js

const { MongoClient } = require('mongodb');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/alumni';
const MONGODB_DB = process.env.MONGODB_DB || 'alumni';

async function populateTestData() {
  const client = new MongoClient(MONGODB_URI);
  
  try {
    await client.connect();
    console.log('Connected to MongoDB');
    
    const db = client.db(MONGODB_DB);
    
    // Sample meeting data
    const sampleMeeting = {
      title: "Sample Alumni Meeting",
      description: "A sample meeting for testing purposes",
      host_id: "sample-user-id",
      meeting_date: new Date(Date.now() + 24 * 60 * 60 * 1000), // Tomorrow
      duration_minutes: 60,
      max_participants: 50,
      meeting_url: "https://meet.google.com/sample-meeting",
      meeting_id: "sample-meeting-id",
      password: "sample123",
      is_active: true,
      created_at: new Date(),
      updated_at: new Date()
    };
    
    // Sample job data
    const sampleJob = {
      title: "Sample Software Engineer Position",
      company: "Sample Company",
      location: "Remote",
      job_type: "full-time",
      experience_level: "mid",
      salary_range: "$80,000 - $120,000",
      description: "A sample job posting for testing purposes",
      requirements: "Experience with JavaScript, React, Node.js",
      application_url: "https://sample-company.com/careers",
      contact_email: "hr@sample-company.com",
      posted_by: "sample-user-id",
      is_approved: true,
      is_active: true,
      created_at: new Date(),
      updated_at: new Date()
    };
    
    // Insert sample data
    const meetingResult = await db.collection('meetings').insertOne(sampleMeeting);
    const jobResult = await db.collection('jobs').insertOne(sampleJob);
    
    console.log('Sample data inserted:');
    console.log('- Meeting ID:', meetingResult.insertedId);
    console.log('- Job ID:', jobResult.insertedId);
    
    // Verify data
    const meetings = await db.collection('meetings').find({}).toArray();
    const jobs = await db.collection('jobs').find({}).toArray();
    
    console.log(`\nTotal meetings: ${meetings.length}`);
    console.log(`Total jobs: ${jobs.length}`);
    
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await client.close();
    console.log('Disconnected from MongoDB');
  }
}

populateTestData();
