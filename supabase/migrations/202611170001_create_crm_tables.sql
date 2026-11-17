create extension if not exists pgcrypto;

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  company text not null,
  phone text not null,
  email text not null,
  service text not null,
  investment text not null,
  estimated_value numeric(12,2) not null default 0,
  notes text not null default '',
  source text not null default 'Formulário',
  status text not null default 'Novo lead'
    check (status in ('Novo lead','Qualificado','Reunião','Proposta','Fechado','Perdido')),
  score smallint not null default 0 check (score between 0 and 100),
  ai_analysis text,
  ai_recommendation text,
  ai_potential text check (ai_potential in ('Baixo','Médio','Alto')),
  ai_intent text check (ai_intent in ('Baixa','Média','Alta')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.interactions (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid not null references public.leads(id) on delete cascade,
  type text not null,
  description text not null,
  created_at timestamptz not null default now()
);

create index if not exists leads_status_idx on public.leads(status);
create index if not exists leads_created_at_idx on public.leads(created_at desc);
create index if not exists interactions_lead_created_idx on public.interactions(lead_id, created_at desc);

alter table public.leads enable row level security;
alter table public.interactions enable row level security;

-- CRM access requires Supabase Auth. Do not add anonymous read/write policies.
create policy "Authenticated users can read leads"
  on public.leads for select to authenticated using (true);
create policy "Authenticated users can create leads"
  on public.leads for insert to authenticated with check (true);
create policy "Authenticated users can update leads"
  on public.leads for update to authenticated using (true) with check (true);
create policy "Authenticated users can delete leads"
  on public.leads for delete to authenticated using (true);

create policy "Authenticated users can read interactions"
  on public.interactions for select to authenticated using (true);
create policy "Authenticated users can create interactions"
  on public.interactions for insert to authenticated with check (true);
create policy "Authenticated users can update interactions"
  on public.interactions for update to authenticated using (true) with check (true);
create policy "Authenticated users can delete interactions"
  on public.interactions for delete to authenticated using (true);
