-- ================================================================
-- SHRI MATHOSHREE SANGANABASSAMMA RAVAJAPPA MADARI KALYANA MANTAPA
-- SUPABASE DATABASE SCHEMA
-- Run this in Supabase → SQL Editor → New Query
-- ================================================================

-- 1. BOOKINGS TABLE
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  booking_id text unique not null,
  user_name text not null,
  date date not null,
  event_type text not null,  -- wedding | engagement | birthday | reception | naming | upanayana | anniversary | corporate | other
  guests integer default 0,
  slot text not null,        -- morning | afternoon | evening | fullday
  phone text,
  status text default 'confirmed',  -- confirmed | pending | cancelled
  created_at timestamptz default now()
);

-- 2. BLOCKED DATES TABLE
create table if not exists public.blocked_dates (
  id uuid primary key default gen_random_uuid(),
  date date not null unique,
  reason text,
  created_at timestamptz default now()
);

-- 3. ROW LEVEL SECURITY

alter table public.bookings enable row level security;
alter table public.blocked_dates enable row level security;

-- Bookings: anyone can insert (public booking), anyone can read dates/event_type (for calendar)
-- Admin reads full data via service key in admin portal
drop policy if exists "Anyone can create bookings" on public.bookings;
create policy "Anyone can create bookings"
  on public.bookings for insert with check (true);

drop policy if exists "Public read bookings" on public.bookings;
create policy "Public read bookings"
  on public.bookings for select using (true);

-- Blocked dates: anyone can read, admin manages via service key
drop policy if exists "Public read blocked" on public.blocked_dates;
create policy "Public read blocked"
  on public.blocked_dates for select using (true);

drop policy if exists "Anyone insert blocked" on public.blocked_dates;
create policy "Anyone insert blocked"
  on public.blocked_dates for insert with check (true);

drop policy if exists "Anyone delete blocked" on public.blocked_dates;
create policy "Anyone delete blocked"
  on public.blocked_dates for delete using (true);

-- 4. REALTIME
alter publication supabase_realtime add table public.bookings;
alter publication supabase_realtime add table public.blocked_dates;

-- ================================================================
-- AFTER RUNNING THIS:
-- 1. Replace YOUR_SUPABASE_URL and YOUR_SUPABASE_ANON_KEY in:
--    → dashboard.html
--    → admin.html
-- 2. Change admin password in admin.html → ADMIN_PWD variable
--    Default: SRKM@Admin2026
-- 3. Add your WhatsApp number (search XXXXXXXXXX in all files)
-- ================================================================
