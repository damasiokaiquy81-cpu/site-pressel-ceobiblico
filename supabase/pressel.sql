-- =====================================================================
-- CEOBiblico.ai — respostas da pressel (4 perguntas, sem nome/e-mail)
-- Supabase → SQL Editor → cole tudo → Run. Pode rodar de novo sem problema.
-- =====================================================================

-- Uma linha por aparelho (se a pessoa responder de novo, atualiza a mesma linha)
create table if not exists public.pressel_respostas (
  id             bigint generated always as identity primary key,
  dispositivo    text not null unique,   -- código aleatório salvo no navegador
  trabalho       text not null,          -- sim | nao  (trabalha usando notebook/computador)
  religiao       text,                   -- crente | catolico | outro
  tempo          text not null,          -- ate_2h | 2_4h | 4_8h | mais_8h
  ocupacao       text not null,          -- empreendedor | home_office | estudante | jogos
  aparelho       text,                   -- celular | computador
  sistema        text,                   -- Windows | Android | iOS | Mac | Linux | Outro
  criado_em      timestamptz not null default now(),
  atualizado_em  timestamptz not null default now()
);

-- Se a tabela já tinha sido criada pela versão de 3 perguntas
alter table public.pressel_respostas add column if not exists religiao text;

-- Fechada: a página só grava pela função abaixo (ninguém lê de fora)
alter table public.pressel_respostas enable row level security;
revoke all on public.pressel_respostas from anon, authenticated;


-- ---------------------------------------------------------------------
-- Página → salva as respostas
-- ---------------------------------------------------------------------
drop function if exists public.registrar_pressel(text, text, text, text, text, text);

create or replace function public.registrar_pressel(
  p_dispositivo text, p_trabalho text, p_religiao text, p_tempo text, p_ocupacao text,
  p_aparelho text default null, p_sistema text default null)
returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  if length(p_dispositivo) not between 8 and 64
     or p_trabalho not in ('sim', 'nao')
     or p_religiao not in ('crente', 'catolico', 'outro')
     or p_tempo not in ('ate_2h', '2_4h', '4_8h', 'mais_8h')
     or p_ocupacao not in ('empreendedor', 'home_office', 'estudante', 'jogos') then
    return 'erro';
  end if;

  insert into public.pressel_respostas as r (dispositivo, trabalho, religiao, tempo, ocupacao, aparelho, sistema)
  values (p_dispositivo, p_trabalho, p_religiao, p_tempo, p_ocupacao,
          case when p_aparelho in ('celular', 'computador') then p_aparelho end,
          left(p_sistema, 20))
  on conflict (dispositivo) do update set
    trabalho = excluded.trabalho,
    religiao = excluded.religiao,
    tempo = excluded.tempo,
    ocupacao = excluded.ocupacao,
    aparelho = excluded.aparelho,
    sistema = excluded.sistema,
    atualizado_em = now();
  return 'ok';
end;
$$;

revoke all on function public.registrar_pressel(text, text, text, text, text, text, text) from public;
grant execute on function public.registrar_pressel(text, text, text, text, text, text, text) to anon, authenticated;


-- =====================================================================
-- Relatório (rode quando quiser ver):
--
-- Quantas pessoas responderam:
--   select count(*) as total from public.pressel_respostas;
--
-- Porcentagem de cada resposta:
--   select 'trabalho' as pergunta, trabalho as resposta, count(*) as pessoas,
--          round(100.0 * count(*) / sum(count(*)) over (), 1) as pct
--     from public.pressel_respostas group by trabalho
--   union all
--   select 'religiao', religiao, count(*), round(100.0 * count(*) / sum(count(*)) over (), 1)
--     from public.pressel_respostas group by religiao
--   union all
--   select 'tempo', tempo, count(*), round(100.0 * count(*) / sum(count(*)) over (), 1)
--     from public.pressel_respostas group by tempo
--   union all
--   select 'ocupacao', ocupacao, count(*), round(100.0 * count(*) / sum(count(*)) over (), 1)
--     from public.pressel_respostas group by ocupacao
--   order by pergunta, pessoas desc;
-- =====================================================================
