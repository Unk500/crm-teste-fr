# Vela CRM

MVP de CRM em português para captação, acompanhamento e qualificação demonstrativa de leads.

## Estrutura

```text
.
├── index.html
├── assets/
│   ├── app.js                 # Interface e comportamento do MVP
│   ├── styles.css             # Estilos responsivos
│   └── config.example.js      # Exemplo de configuração pública Supabase
├── supabase/
│   └── migrations/            # Esquema inicial e políticas RLS
├── .env.example
└── netlify.toml
```

## Executar localmente

Abra `index.html` no navegador ou sirva a pasta com um servidor estático local. Os dados de demonstração são salvos no `localStorage` deste navegador; ainda não existe conexão ativa com o Supabase.

## Configurar Supabase

1. Crie um projeto Supabase.
2. Execute `supabase/migrations/202611170001_create_crm_tables.sql` no SQL Editor ou aplique a migration com o Supabase CLI.
3. Copie `assets/config.example.js` para `assets/config.js` e preencha `supabaseUrl` e `supabasePublishableKey` com os valores do projeto. `assets/config.js` está no `.gitignore`.
4. Publique o frontend e configure autenticação. A migration permite acesso às tabelas apenas a usuários autenticados; políticas atuais são adequadas a um workspace único. Para múltiplos clientes/workspaces, adicione `workspace_id` e restrinja as policies antes de lançar.

O formulário público ainda precisa ser ligado a uma Edge Function que valide os campos e insira leads com proteção contra abuso. Não abra escrita anônima ampla diretamente nas tabelas.

## Chaves e APIs de terceiros

- A publishable key do Supabase pode ser entregue ao navegador, mas somente com RLS habilitado e policies corretas.
- Nunca coloque a Supabase secret/service_role key ou chaves de IA/terceiros em `index.html`, `assets/app.js`, `assets/config.js` ou em variáveis `VITE_*`.
- Armazene chaves de terceiros nos Secrets das Supabase Edge Functions. O navegador deve chamar uma função autenticada, e a função valida o pedido e chama a API externa.
- `.env.example` contém apenas nomes/formatos ilustrativos; não é carregado pelo app estático.

## Publicar

### Netlify

Importe o repositório no Netlify e use a raiz como diretório de publicação. O `netlify.toml` já define `publish = "."`. Não configure segredos de terceiros como variáveis do frontend.

### GitHub Pages

O app é estático e pode ser servido pelo GitHub Pages. Para publicar em um caminho de projeto (por exemplo `/repo/`), troque caminhos absolutos `/assets/...` no `index.html` por caminhos relativos `assets/...`.

## Limites atuais

- Persistência local no navegador; migration Supabase preparada, mas ainda não integrada ao app.
- Qualificação/mensagem de IA são demonstrações locais, sem chamada a modelo externo.
- O botão do WhatsApp abre uma conversa externa com texto pré-preenchido; não há sincronização de mensagens.
