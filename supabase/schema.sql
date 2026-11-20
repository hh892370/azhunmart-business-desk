-- AzhunMart Business Desk cloud database
-- Run once in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  order_id text not null, date date not null default current_date, channel text not null check (channel in ('WhatsApp','Website')),
  name text, mobile text, product text not null, variant text not null, qty integer not null default 1 check (qty > 0),
  payment text not null check (payment in ('COD','Prepaid')), price numeric(12,2) not null check (price >= 0),
  status text not null default 'New', payment_status text not null default 'Pending', awb text,
  edd date, delivered_date date, notes text, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists orders_user_date_idx on public.orders(user_id,date desc);
create index if not exists orders_user_order_id_idx on public.orders(user_id,order_id);

create table if not exists public.ad_daily (
  id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date date not null, campaign text, spend numeric(12,2) not null default 0 check (spend >= 0),
  orders integer not null default 0 check (orders >= 0), revenue numeric(12,2) not null default 0 check (revenue >= 0), created_at timestamptz not null default now()
);
create index if not exists ad_daily_user_date_idx on public.ad_daily(user_id,date desc);

create table if not exists public.stock_items (
  id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  product text not null, variant text not null, opening integer not null default 0, purchases integer not null default 0,
  reorder integer not null default 10, created_at timestamptz not null default now(), unique(user_id,product,variant)
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date date not null, category text not null, note text, amount numeric(12,2) not null default 0 check (amount >= 0), created_at timestamptz not null default now()
);
create index if not exists expenses_user_date_idx on public.expenses(user_id,date desc);

create table if not exists public.app_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  value jsonb not null default '{"cogs":108,"websiteFee":9.47,"codShip":120,"prepaidShip":75,"rtoFee":70}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.orders enable row level security;
alter table public.ad_daily enable row level security;
alter table public.stock_items enable row level security;
alter table public.expenses enable row level security;
alter table public.app_settings enable row level security;

drop policy if exists "owner manages orders" on public.orders;
create policy "owner manages orders" on public.orders for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "owner manages ads" on public.ad_daily;
create policy "owner manages ads" on public.ad_daily for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "owner manages stock" on public.stock_items;
create policy "owner manages stock" on public.stock_items for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "owner manages expenses" on public.expenses;
create policy "owner manages expenses" on public.expenses for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "owner manages settings" on public.app_settings;
create policy "owner manages settings" on public.app_settings for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

grant select,insert,update,delete on public.orders, public.ad_daily, public.stock_items, public.expenses, public.app_settings to authenticated;
revoke all on public.orders, public.ad_daily, public.stock_items, public.expenses, public.app_settings from anon;

