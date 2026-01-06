import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
    throw new Error('Missing Supabase environment variables');
}

// Client with service role (for backend operations)
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

// Client factory for user context (pass user's JWT)
export const createUserClient = (accessToken: string) => {
    return createClient(supabaseUrl, process.env.SUPABASE_ANON_KEY!, {
        global: {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        }
    });
};
