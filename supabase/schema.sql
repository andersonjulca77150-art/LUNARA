-- Lunara — esquema inicial para cuentas + sincronización en la nube.
-- Ejecutar completo en Supabase: Project → SQL Editor → New query → pegar → Run.
--
-- Diseño: una fila por usuario en cada tabla de datos, todo protegido con
-- Row Level Security (RLS) para que cada quien solo pueda leer/escribir sus
-- propias filas. auth.uid() es el id del usuario autenticado — lo provee
-- Supabase Auth automáticamente, no hay que gestionarlo a mano.
--
-- Compartir con pareja (fase 2, todavía no) se agregaría con una tabla
-- adicional de "shared_access" y políticas RLS con un OR — no se construye
-- todavía para no bloquear esta primera versión con algo más complejo.

create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text,
  updated_at timestamptz not null default now()
);

create table public.cycle_settings (
  user_id uuid references auth.users on delete cascade primary key,
  last_period date not null,
  cycle_length int not null check (cycle_length between 21 and 45),
  period_length int not null check (period_length >= 1),
  updated_at timestamptz not null default now()
);

create table public.period_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  period_date date not null,
  created_at timestamptz not null default now(),
  unique (user_id, period_date)
);

create table public.symptom_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  log_date date not null,
  symptoms jsonb not null default '[]',
  severity text,
  notes text,
  updated_at timestamptz not null default now(),
  unique (user_id, log_date)
);

alter table public.profiles enable row level security;
alter table public.cycle_settings enable row level security;
alter table public.period_history enable row level security;
alter table public.symptom_log enable row level security;

create policy "own profile" on public.profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "own cycle settings" on public.cycle_settings
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own period history" on public.period_history
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own symptom log" on public.symptom_log
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
