-- Ocrea — schéma initial
-- Toutes les tables sont scoped par company_id et protégées par RLS.

-- =========================================================
-- Extensions
-- =========================================================
create extension if not exists "pgcrypto";

-- =========================================================
-- Tables
-- =========================================================

-- Entreprises (PME clientes)
create table if not exists public.companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country text,
  created_at timestamptz not null default now()
);

-- Profils utilisateurs (liés à auth.users)
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  role text not null default 'member',
  created_at timestamptz not null default now()
);

create index if not exists users_company_id_idx on public.users(company_id);

-- Dossiers de crédits documentaires
create table if not exists public.lc_dossiers (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  reference text not null,
  status text not null default 'draft',
  amount numeric(18,2),
  currency text,
  issuing_bank text,
  advising_bank text,
  expiry_date date,
  latest_shipment_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists lc_dossiers_company_id_idx on public.lc_dossiers(company_id);
create index if not exists lc_dossiers_status_idx on public.lc_dossiers(status);

-- Analyses MT700 (IA Claude)
create table if not exists public.mt700_analyses (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references public.lc_dossiers(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  raw_message text,
  analysis jsonb,
  errors_count int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists mt700_analyses_dossier_id_idx on public.mt700_analyses(dossier_id);
create index if not exists mt700_analyses_company_id_idx on public.mt700_analyses(company_id);

-- Envois physiques (DHL etc.)
create table if not exists public.shipments (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references public.lc_dossiers(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  carrier text not null default 'DHL',
  tracking_number text,
  status text,
  last_event_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists shipments_dossier_id_idx on public.shipments(dossier_id);
create index if not exists shipments_company_id_idx on public.shipments(company_id);

-- Documents (BL, factures, certificats, etc.) — Supabase Storage
create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  dossier_id uuid not null references public.lc_dossiers(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  type text not null,
  storage_path text not null,
  uploaded_at timestamptz not null default now()
);

create index if not exists documents_dossier_id_idx on public.documents(dossier_id);
create index if not exists documents_company_id_idx on public.documents(company_id);

-- =========================================================
-- Trigger updated_at sur lc_dossiers
-- =========================================================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists lc_dossiers_set_updated_at on public.lc_dossiers;
create trigger lc_dossiers_set_updated_at
before update on public.lc_dossiers
for each row execute function public.set_updated_at();

-- =========================================================
-- Helper : company_id de l'utilisateur courant
-- =========================================================
create or replace function public.current_company_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select company_id from public.users where id = auth.uid();
$$;

-- =========================================================
-- RLS — activation
-- =========================================================
alter table public.companies        enable row level security;
alter table public.users            enable row level security;
alter table public.lc_dossiers      enable row level security;
alter table public.mt700_analyses   enable row level security;
alter table public.shipments        enable row level security;
alter table public.documents        enable row level security;

-- =========================================================
-- Policies
-- =========================================================

-- companies : l'utilisateur voit / modifie uniquement sa propre entreprise
drop policy if exists companies_select on public.companies;
create policy companies_select on public.companies
  for select using (id = public.current_company_id());

drop policy if exists companies_update on public.companies;
create policy companies_update on public.companies
  for update using (id = public.current_company_id())
  with check (id = public.current_company_id());

-- users : l'utilisateur voit les membres de sa company
drop policy if exists users_select on public.users;
create policy users_select on public.users
  for select using (company_id = public.current_company_id());

drop policy if exists users_self_update on public.users;
create policy users_self_update on public.users
  for update using (id = auth.uid())
  with check (id = auth.uid());

-- lc_dossiers
drop policy if exists lc_dossiers_all on public.lc_dossiers;
create policy lc_dossiers_all on public.lc_dossiers
  for all using (company_id = public.current_company_id())
  with check (company_id = public.current_company_id());

-- mt700_analyses
drop policy if exists mt700_analyses_all on public.mt700_analyses;
create policy mt700_analyses_all on public.mt700_analyses
  for all using (company_id = public.current_company_id())
  with check (company_id = public.current_company_id());

-- shipments
drop policy if exists shipments_all on public.shipments;
create policy shipments_all on public.shipments
  for all using (company_id = public.current_company_id())
  with check (company_id = public.current_company_id());

-- documents
drop policy if exists documents_all on public.documents;
create policy documents_all on public.documents
  for all using (company_id = public.current_company_id())
  with check (company_id = public.current_company_id());
