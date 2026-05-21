import { createClient } from "@supabase/supabase-js";

// Client Supabase côté navigateur (clé anon).
// Les opérations sensibles passent par un client service-role côté serveur uniquement.
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? "";

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
