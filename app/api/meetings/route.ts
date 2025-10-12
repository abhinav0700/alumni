import { NextRequest, NextResponse } from 'next/server'
import { connectToDatabase } from '@/lib/mongodb'
import { Meeting } from '@/lib/models/meeting'

export async function GET(request: NextRequest) {
  try {
    const { db } = await connectToDatabase()
    const meetings = await db.collection('meetings').find({ is_active: true }).toArray()
    
    // Use NextResponse.json for proper JSON response
    return NextResponse.json(meetings)
  } catch (error) {
    console.error('Error fetching meetings:', error)
    return new NextResponse(
      JSON.stringify({ error: 'Failed to fetch meetings', details: error instanceof Error ? error.message : 'Unknown error' }), 
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
    
    const meeting: Omit<Meeting, '_id'> = {
      ...body,
      is_active: true,
      created_at: new Date(),
      updated_at: new Date(),
    }
    
    const result = await db.collection('meetings').insertOne(meeting)
    
    return NextResponse.json({ 
      success: true, 
      id: result.insertedId,
      meeting: { ...meeting, _id: result.insertedId }
    }, {
      status: 201,
      headers: {
        'Content-Type': 'application/json',
      },
    })
  } catch (error) {
    console.error('Error creating meeting:', error)
    return NextResponse.json(
      { 
        error: 'Failed to create meeting', 
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
