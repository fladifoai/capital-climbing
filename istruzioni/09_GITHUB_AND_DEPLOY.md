# GitHub e deploy

## Repository

Durante lo sviluppo:

```text
private
```

Quando pronto:

- pubblico;
- collaboratori;
- licenza;
- branch protection;
- pull request.

## Branch

```text
main
feature/auth
feature/catalog-import
feature/user-search
fix/scoring
```

## Protezione main

Richiedere:

- pull request;
- almeno una approvazione;
- conversazioni risolte;
- niente force push;
- niente cancellazione branch.

## Workflow GitHub Actions

Passaggi:

```text
checkout
setup Node
npm ci
npm run lint
npm run typecheck
npm run test
npm run build
upload Pages artifact
deploy Pages
```

## GitHub Pages

Usare:

- `HashRouter`;
- base Vite corretta;
- Source: GitHub Actions.

## Variabili

Configurare senza inserirle nel repository:

```text
VITE_SUPABASE_URL
VITE_SUPABASE_PUBLISHABLE_KEY
```

## File utili

```text
README.md
CONTRIBUTING.md
LICENSE
CODEOWNERS
.github/ISSUE_TEMPLATE/
.github/pull_request_template.md
```

## Licenza futura

Valutare:

```text
AGPL-3.0
```

prima della pubblicazione open source.
