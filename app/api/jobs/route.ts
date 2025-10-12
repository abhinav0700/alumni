import { NextRequest, NextResponse } from 'next/server'
import { connectToDatabase } from '@/lib/mongodb'
import { Job } from '@/lib/models/job'

export async function GET(request: NextRequest) {
  try {
    const { db } = await connectToDatabase()
    const jobs = await db.collection('jobs').find({ is_active: true }).toArray()
    
    // Use NextResponse.json for proper JSON response
    return NextResponse.json(jobs)
  } catch (error) {
    console.error('Error fetching jobs:', error)
    return new NextResponse(
      JSON.stringify({ error: 'Failed to fetch jobs', details: error instanceof Error ? error.message : 'Unknown error' }), 
      { 
        status: 500,
        headers: {
          'Content-Type': 'application/json',
        },
      }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { db } = await connectToDatabase()
    
    const job: Omit<Job, '_id'> = {
      ...body,
      is_approved: true, // Auto-approve jobs
      is_active: true,
      created_at: new Date(),
      updated_at: new Date(),
    }
    
    const result = await db.collection('jobs').insertOne(job)
    
    return NextResponse.json({ 
      success: true, 
      id: result.insertedId,
      job: { ...job, _id: result.insertedId }
    }, {
      status: 201,
      headers: {
        'Content-Type': 'application/json',
      },
    })
  } catch (error) {
    console.error('Error creating job:', error)
    return NextResponse.json(
      { 
        error: 'Failed to create job', 
        details: error instanceof Error ? error.message : 'Unknown error' 
      }, 
      { 
        status: 500,
        headers: {
          'Content-Type': 'application/json',
        },
      }
    )
  }
}
