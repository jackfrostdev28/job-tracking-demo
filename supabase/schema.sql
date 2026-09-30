-- Shared Hugcode workboard state.
-- Apply this in the Supabase SQL Editor after creating a project.
-- Only signed-in users can access the shared board.

create table if not exists public.workboard_state (
  id text primary key check (id = 'shared'),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.workboard_state enable row level security;

revoke all on table public.workboard_state from anon, public;
revoke delete on table public.workboard_state from authenticated;
grant select, insert, update on table public.workboard_state to authenticated;

drop policy if exists "Signed-in users can read the shared board" on public.workboard_state;
create policy "Signed-in users can read the shared board"
  on public.workboard_state for select to authenticated
  using (id = 'shared');

drop policy if exists "Signed-in users can create the shared board" on public.workboard_state;
create policy "Signed-in users can create the shared board"
  on public.workboard_state for insert to authenticated
  with check (id = 'shared');

drop policy if exists "Signed-in users can update the shared board" on public.workboard_state;
create policy "Signed-in users can update the shared board"
  on public.workboard_state for update to authenticated
  using (id = 'shared')
  with check (id = 'shared');

-- Enable real-time updates between team members.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'workboard_state'
  ) then
    alter publication supabase_realtime add table public.workboard_state;
  end if;
end;
$$;
