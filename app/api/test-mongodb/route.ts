import { NextRequest, NextResponse } from 'next/server'
import { connectToDatabase } from '@/lib/mongodb'

export async function GET(request: NextRequest) {
  try {
    const { db } = await connectToDatabase()
    
    // Test the connection by listing collections
    const collections = await db.listCollections().toArray()
    
    // Test inserting a simple document
    const testDoc = {
      test: true,
      timestamp: new Date(),
      message: 'MongoDB connection successful'
    }
    
    const result = await db.collection('test').insertOne(testDoc)
    
    return NextResponse.json({
      success: true,
      message: 'MongoDB connection successful',
      collections: collections.map(c => c.name),
      testInsert: result.insertedId
    }, {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
      },
    })
  } catch (error) {
    console.error('MongoDB test error:', error)
    return NextResponse.json(
      { 
        success: false,
        error: 'MongoDB connection failed', 
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
