# site-pressel-ceobiblico

Pressel do CEOBiblico.ai — 4 perguntas rápidas e, no fim, o convite para a página de vendas.

## Arquivos

- `index.html` — as 4 perguntas, a tela final e o envio das respostas.
- `assets/` — logo, favicon e a fonte Inter (licença em `assets/OFL.txt`).
- `supabase/pressel.sql` — a função `registrar_pressel` que guarda as respostas no Supabase.

## Respostas

São gravadas pela função `registrar_pressel`, com a chave publicável do projeto (a mesma do app).
Não é guardado nome, e-mail nem nada pessoal — só um código aleatório do aparelho, as respostas,
se é celular ou computador, e o sistema.

Religião: `crente` (aparece como Evangélico), `catolico`, `outro` (Outra religião) e `sem_religiao`
(Não tenho religião). Depois de mudar as opções, rode `supabase/pressel.sql` de novo no SQL Editor.

## Botão final

`Ver o CEOBiblico.ai` leva para a página de vendas: https://sitev.ceobiblicoai.site/?d=<código do aparelho>
— o mesmo código salvo nas respostas. Se a pessoa comprar, a venda guarda esse código e a visão
`vendas_com_pressel` (repositório `site-vendas-ceobiblico`, arquivo `supabase/vendas.sql`) mostra a compra
junto com as respostas da pressel.

## Rodar local

Sirva a pasta por HTTP em vez de abrir o arquivo por duplo clique — com Node instalado:

```
npx --yes serve .
```
