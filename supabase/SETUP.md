# Supabase setup for Hugcode

The app uses one shared board row in `public.workboard_state`. Every person who can sign in can read and edit the shared board. Database access is protected by Supabase Auth and Row Level Security.

## Database

Run `schema.sql` in the Supabase SQL Editor. It is safe to run again; it creates the table and policies if needed and enables Realtime updates.

## Accounts

The app intentionally has no public sign-up form. In the Supabase Dashboard, open **Authentication → Users** and create an account for each teammate. Share each account's sign-in details securely. Disable public sign-ups in the Auth settings so new visitors cannot create an account and access the shared board.

## Keys

`supabase-config.js` contains the project URL and Publishable key. A Publishable key is designed for browser use. Never put a Secret key or `service_role` key in this file. RLS must remain enabled on `workboard_state`.
