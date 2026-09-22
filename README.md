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

## Pendente

- **Botão final**: o `href` do botão `Ver o CEOBiblico.ai` ainda está em `#vsl`.
  Trocar pelo endereço da página de vendas (repositório `site-vendas-ceobiblico`).

## Rodar local

Sirva a pasta por HTTP em vez de abrir o arquivo por duplo clique — com Node instalado:

```
npx --yes serve .
```
