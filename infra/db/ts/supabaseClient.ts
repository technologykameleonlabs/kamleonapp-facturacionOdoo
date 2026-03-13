import dotenv from 'dotenv'
dotenv.config({ path: 'infra/env/.env.local' })

import { createClient } from '@supabase/supabase-js'

const url = process.env.NEXT_PUBLIC_SUPABASE_URL!
const key = (process.env.SUPABASE_SERVICE_ROLE || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY)!

export const sb = createClient(url, key, { auth: { persistSession: false } })