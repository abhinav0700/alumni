export interface Meeting {
  _id?: string
  title: string
  description?: string
  host_id: string
  meeting_date: Date
  duration_minutes: number
  max_participants: number
  meeting_url?: string
  meeting_id?: string
  password?: string
  is_active: boolean
  created_at: Date
  updated_at: Date
}

export interface MeetingRegistration {
  _id?: string
  meeting_id: string
  user_id: string
  registered_at: Date
}

export interface MeetingWithHost extends Meeting {
  host: {
    full_name: string
    current_company?: string
    current_position?: string
    profile_image_url?: string
    linkedin_url?: string
  }
  registrations?: MeetingRegistration[]
  registration_count?: number
}
