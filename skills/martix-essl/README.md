# MartiX eSSL

`martix-essl` je canonical standalone-first MartiX skill pro české elektronické
systémy spisové služby. Převádí požadavky zákona `499/2004 Sb.`, vyhlášky
`259/2012 Sb.` a Národního standardu eSSL do návrhu, implementace, code review
a atestační připravenosti vlastního `.NET 10+` řešení.

- Canonical source root: `skills\martix-essl`
- Primary install surface: standalone `skills` CLI
- Secondary install surface: Copilot CLI marketplace
- Discovery key: `martix-essl`

## Balíček je určen pro

- analýzu souladu eSSL řešení s českým právním a standardizačním rámcem
- návrh modulů, metadat, evidencí, životního cyklu dokumentů a archivních toků
- práci s `WS API`, `SIP/METS`, `WSDL`, `XSD` a migračními artefakty
- code review změn, které mohou zasáhnout metadata, audit, skartaci nebo
  export/import
- přípravu řešení na atestaci eSSL

## Hranice balíčku

- `martix-essl` vlastní **doménovou a compliance expertízu eSSL**
- obecné `.NET/C#` mechaniky předává do `martix-dotnet-csharp`
- nenahrazuje formální právní stanovisko

## Instalace

### Copilot CLI marketplace flow

Použij marketplace flow pro běžnou instalaci GitHub Copilot CLI.

```powershell
copilot plugin marketplace add MartiXDev/skills
copilot plugin marketplace list
copilot plugin marketplace browse martix-skills
copilot plugin install martix-essl@martix-skills
```

### Standalone skills CLI flow

Použij repo-root skill selection pro standalone instalaci.

```powershell
npx skills add https://github.com/MartiXDev/skills --skill martix-essl
```

### Direct source path flow

Přímou cestu k balíčku používej jen pro lokální validaci nebo vývoj.

```powershell
npx skills add C:\Git\MartiXDev\skills\skills\martix-essl `
  -a github-copilot -y
npx skills add C:\Git\MartiXDev\skills\skills\martix-essl `
  -a github-copilot --copy -y
```

## Struktura balíčku

| Cesta | Účel |
| --- | --- |
| [SKILL.md](./SKILL.md) | Stručný router pro aktivaci a výběr workstreamu |
| [AGENTS.md](./AGENTS.md) | Dlouhý companion pro review, handoffy a údržbu |
| [rules/](./rules) | Atomická pravidla pro doménové a integrační rozhodování |
| [references/](./references) | Mapy zdrojů, crosswalky, glosář a index schémat |
| [templates/](./templates) | Šablony pro checklisty, metadata mapping a review výstupy |
| [assets/](./assets) | Strojově čitelné členění a preferované pořadí |
| [evals/](./evals) | Routingové a kvalitativní evaly |
| [metadata.json](./metadata.json) | Inventory, taxonomie a distribuční metadata |
| [plugin.json](./plugin.json) | Balíčková identita pro instalaci a marketplace |
| [LICENSE.txt](./LICENSE.txt) | Licence balíčku |

## Maintainer notes

- Začni v [references/doc-source-index.md](./references/doc-source-index.md).
- Hlavní rozcestník zdrojů mimo balíček je `docs\martix-essl\README.md`.
- Když se změní routing, workstreamy nebo hranice scope, aktualizuj i
  `assets\taxonomy.json`, `assets\section-order.json` a `evals\evals.json`.
- Celý lidsky čitelný obsah tohoto balíčku drž v češtině.
- Obecné `.NET/C#` guidance neduplikuj; cross-linkuj na
  `martix-dotnet-csharp`.

## Ověření

### Package-local JSON validation

```powershell
Get-Content .\skills\martix-essl\metadata.json | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-essl\plugin.json | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-essl\assets\taxonomy.json `
  | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-essl\assets\section-order.json `
  | ConvertFrom-Json | Out-Null
Get-Content .\skills\martix-essl\evals\evals.json | ConvertFrom-Json | Out-Null
```

### Markdown a repository validation

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\plugins\martix-markdown-automation\hooks\markdown-check.ps1 `
  -CheckOnly `
  -Path .\skills\martix-essl\README.md,`
    .\skills\martix-essl\SKILL.md,`
    .\skills\martix-essl\AGENTS.md

powershell -ExecutionPolicy Bypass -File .\scripts\validate-repository.ps1
```

## Update a odinstalace

```powershell
npx skills check
npx skills update
npx skills remove martix-essl
```

## Discovery precedence a konflikty stejných jmen

Copilot deduplikuje podle `name` v `SKILL.md`, ne podle cesty ke složce.
Standalone instalace tak může zastínit marketplace kopii se stejným názvem.

- Pro validaci marketplace verze použij čisté prostředí nebo odeber
  standalone instalaci.
- Pokud budou někdy koexistovat dvě varianty, musí mít odlišná jména.
