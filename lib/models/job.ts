export interface Job {
  _id?: string
  title: string
  company: string
  location: string
  job_type: 'full-time' | 'part-time' | 'internship' | 'contract'
  experience_level: 'entry' | 'mid' | 'senior' | 'executive'
  salary_range?: string
  description: string
  requirements: string
  application_url?: string
  contact_email?: string
  posted_by: string
  is_approved: boolean
  is_active: boolean
  created_at: Date
  updated_at: Date
}

export interface JobWithPoster extends Job {
  poster: {
    full_name: string
    current_company?: string
    current_position?: string
    profile_image_url?: string
    linkedin_url?: string
  }
}
