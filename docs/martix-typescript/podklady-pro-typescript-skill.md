# Podklady pro tvorbu špičkového TypeScript skillu

**Stav zdrojů:** 21. července 2026  
**Cílový balíček:** `skills/martix-typescript`  
**Primární baseline:** TypeScript 7.0.x, s explicitní přechodovou větví pro TypeScript 6.0  
**Účel dokumentu:** podklad pro následnou implementaci pomocí
`writing-great-skills` a eval-driven review pomocí `skill-creator`

## Executive summary

TypeScript 7 je skutečně stabilní vydání, nikoli preview. Oficiální oznámení
z 8. července 2026 uvádí dostupnost přes běžný balíček `typescript`; při
ověření 21. července byl na npm jako `latest` dostupný TypeScript 7.0.2.
TypeScript 7 přináší nativní Go compiler (Corsa), typicky 8–12× rychlejší plné
buildy, paralelní checkery a builders a nový watch režim. Současně ale 7.0
**nemá programové API**. Nástroje závislé na compiler API a frameworky s
embedded TypeScript toolingem proto mohou dočasně vyžadovat TypeScript 6.0
nebo souběh obou generací.

Nejlepší výsledný skill nemá být encyklopedie ani kolekce univerzálních
`tsconfig` snippetů. Má být malý, model-invoked, projektově adaptivní
**type-first router** s opakovatelným procesem:

1. zjistit projektový kontext, skutečnou verzi compileru a existující příkazy;
2. určit host/runtime a vlastnictví modulu;
3. navrhnout nejmenší typově bezpečnou změnu;
4. implementovat podle lokálních konvencí;
5. spustit každý relevantní projektový check samostatně;
6. skončit až po čistém typechecku a všech souvisejících kontrolách.

Hlavní kvalitativní rozdíl proti veřejným skillům bude v kombinaci:

- TS7-first, ale s přesnou TS6 compatibility větví;
- kontrolovatelných dokončovacích kritérií;
- progresivního zpřístupnění po skutečných větvích;
- rozhodování podle projektu místo absolutních zákazů;
- kompilovaných příkladů a regresních evalů;
- ostrých hand-off hranic vůči JavaScriptu, frameworkům, lintingu, runtime
  testování, package managementu a code review.

## 1. Metoda a zdroje

Výzkum kombinoval:

- lokální pravidla a architekturu repozitáře;
- existující srovnání veřejných TypeScript skillů;
- přímé GitHub code search a čtení konkrétních revizí `SKILL.md`;
- oficiální TypeScript 6/7, Node.js, typescript-eslint a Agent Skills zdroje;
- principy `writing-great-skills` a proces `skill-creator`.

Upřednostněny byly primární zdroje. Katalogové stránky a popularita byly použity
jen jako pomocný signál, nikdy jako důkaz technické správnosti.

### Klíčové lokální zdroje

- Repo je standalone-first marketplace a preferuje instalaci přes marketplace
  nebo `npx skills add`; balíčky pod `skills/` jsou samostatné skilly
  ([`README.md`, ř. 6–23](../../README.md),
  [`docs/repo-overview.md`, ř. 7–14](../repo-overview.md)).
- Reusable domain knowledge patří do `skills\martix-*`; plugin je odůvodněný až
  hooky, agenty, prompt assets, MCP/LSP nebo složeným workflow
  ([`docs/custom-ai-artifact-rules.md`, ř. 43–63](../custom-ai-artifact-rules.md)).
- Samostatný skill musí mít `plugin.json`, `metadata.json`, `README.md`,
  `SKILL.md`, `AGENTS.md`, licenci, `rules/`, `references/`, `templates/`,
  assets a evaly; `SKILL.md` je router, nikoli plná knowledge base
  ([`docs/custom-ai-artifact-rules.md`, ř. 220–276](../custom-ai-artifact-rules.md)).
- Změny routingu musí synchronizovat metadata, taxonomy, section order a evaly
  ([`.github/instructions/skill-packages.instructions.md`, ř. 21–32](../../.github/instructions/skill-packages.instructions.md)).
- Budoucí `martix-webapp` počítá s reusable React/TypeScript skillem; obecná
  TypeScript znalost proto nesmí zůstat skrytá uvnitř pluginu
  ([`docs/plugin-bundle-strategy.md`, ř. 40–43, 60–64](../plugin-bundle-strategy.md)).

### Klíčové externí zdroje

- [TypeScript 7.0 announcement](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/)
- [TypeScript 6.0 release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html)
- [TypeScript 7 Corsa repository](https://github.com/microsoft/typescript-go)
- [Corsa intentional changes](https://github.com/microsoft/typescript-go/blob/main/CHANGES.md)
- [TypeScript npm registry metadata](https://registry.npmjs.org/typescript)
- [Node.js TypeScript support](https://nodejs.org/api/typescript.html)
- [typescript-eslint dependency versions](https://typescript-eslint.io/users/dependency-versions/)
- [Agent Skills specification](https://agentskills.io/specification)
- [Anthropic Agent Skills authoring article](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)

## 2. Co přesně znamená TypeScript 7 baseline

### 2.1 Ověřený stav vydání

K 21. červenci 2026:

- oficiální Microsoft blog označuje TypeScript 7 za dostupný produkční release;
- instalace `npm install -D typescript` poskytuje nový nativní `tsc`;
- npm registry uváděla `latest: 7.0.2`, `rc: 7.0.1-rc` a
  `next: 7.1.0-dev.20260721.1`;
- původní JS compiler je označován jako **Strada**, nový Go compiler jako
  **Corsa**.

Skill má proto používat TypeScript 7 jako greenfield default. Nesmí však zaměnit
„stabilní compiler“ za „kompletní kompatibilitu celého ekosystému“.

### 2.2 Změny s největším dopadem na skill

| Oblast | TypeScript 7 fakta | Důsledek pro skill |
| --- | --- | --- |
| Compiler | Nativní Go port, obvykle 8–12× rychlejší buildy a 6–26 % nižší peak memory v publikovaných Microsoft benchmarcích | Preferovat TS7 pro CLI typecheck/build, ale výkon neměnit v univerzální slib |
| API | 7.0 nemá programové compiler API; nové API je očekáváno v 7.1 | Detekovat API consumers, custom transformery a embedded tooling |
| Paralelismus | Experimentální `--checkers`, `--builders`; `--singleThreaded` pro omezené CI a diagnostiku | Ladit až po měření; hlídat násobení workerů a paměť |
| Watch | Nový cross-platform watcher založený na portu Parcel watcheru | Nepřenášet staré polling workaroundy bez ověření |
| Defaults | `strict`, `noUncheckedSideEffectImports`, nový `target`, `module: esnext`, `types: []`, `rootDir: ./`, stabilní type ordering | Neukládat staré implicitní předpoklady; auditovat globals a layout |
| Odstraněné volby | mimo jiné `target: es5`, `moduleResolution: node/node10`, `baseUrl`, `module: amd/umd/systemjs/none`, `moduleResolution: classic` | Všechny bundled config examples musí být TS7-compile-tested |
| Moduly | Migrovat podle hosta na `nodenext` nebo `preserve` + `bundler` | Nikdy nedoporučovat module settings bez zjištění runtime/bundleru |
| CLI | `tsc` s nalezeným `tsconfig` odmítá současné file arguments bez `--ignoreConfig` | Validace nesmí slepě skládat file paths k project commandu |

Zdroj: [oficiální oznámení TypeScriptu 7.0](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/),
zejména sekce „Running Side-by-Side with TypeScript 6.0“, „Custom Scaling“ a
„Updates Since 5.x“.

### 2.3 Povinná TS6 compatibility větev

Microsoft výslovně dokumentuje, že TypeScript 7.0 nemá API a pro souběh vydal
`@typescript/typescript6` s binárkou `tsc6`. To je load-bearing rozhodovací bod,
nikoli okrajová poznámka.

Skill musí při TypeScript 7 projektu zjistit, zda se používá:

- `typescript-eslint` nebo jiný přímý consumer `typescript` API;
- custom transformer;
- Vue, Svelte, Astro, MDX, Angular template typechecking nebo Volar;
- editor plugin závislý na starém language-service API;
- tooling, které importuje `typescript` jako peer dependency.

Když ano, má doporučit ověření compatibility a případně oficiální side-by-side
alias místo bezpodmínečného upgradu. Samotný typescript-eslint k datu rešerše
deklaruje podporu `>=4.8.4 <6.1.0`, tedy nikoli TS7
([dependency versions](https://typescript-eslint.io/users/dependency-versions/)).

### 2.4 Migrace 6 → 7

Bezpečná migrační větev:

1. Nejdříve dostat projekt na čistý TypeScript 6.0 bez `ignoreDeprecations`.
2. Při porovnání declaration outputu zapnout v TS6 dočasně
   `stableTypeOrdering`.
3. Opravit odstraněné flags a explicitně nastavit potřebné `types` a `rootDir`.
4. Spustit stejné projektové checks na TS6 a TS7.
5. Porovnat diagnostics a `.d.ts`, ne textové pořadí bez kontextu.
6. Identifikovat tooling, který musí dočasně zůstat na TS6.

`stableTypeOrdering` je migrační diagnostický nástroj a může TS6 zpomalit až o
25 %; nemá být dlouhodobý performance default
([TypeScript 6.0 release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html#the---stabletypeordering-flag)).

### 2.5 JavaScript/JSDoc interop

Corsa záměrně zpřísňuje JavaScript/JSDoc chování. Mimo jiné nepodporuje
constructor-function class patterns, omezuje Closure syntax, vyžaduje explicitní
`typeof` v některých JSDoc type positions a mění Unicode chování template literal
type inference. Tato větev patří do samostatné reference, protože je důležitá pro
`allowJs`/`checkJs`, ale většina čistých `.ts` projektů ji nepotřebuje.

Zdroj: [`microsoft/typescript-go/CHANGES.md`](https://github.com/microsoft/typescript-go/blob/main/CHANGES.md).

## 3. Scope a hranice budoucího skillu

### Vlastní scope `martix-typescript`

Skill má vlastnit:

- TypeScript type-system a type-driven API design;
- narrowing, generics, conditional/mapped/template literal types;
- `unknown`, `never`, `satisfies`, const type parameters a explicitní boundary
  types;
- `tsconfig`, compiler behavior, declaration emit a project references;
- host-aware module resolution a ESM/CJS interoperability z pohledu TypeScriptu;
- TS5/6 → TS7 migrace a TS6/TS7 side-by-side tooling;
- `.d.ts` authoring/publishing correctness;
- type-level tests a compile-fail tests;
- diagnostiku typechecku a compiler performance;
- TypeScript-specific code review při implementaci nebo opravě.

### Hand-off hranice

| Sousední oblast | Zůstává v TypeScript skillu | Předat dál |
| --- | --- | --- |
| JavaScript | TS interop, `allowJs`, `checkJs`, JSDoc typed JS | Obecný runtime JS, DOM a syntax bez typových dopadů |
| React/Vue/Angular/Svelte | Framework-agnostic typy a TS7 compatibility upozornění | Props/hooks/templates, framework config a framework-specific APIs |
| Testing | Type-level assertions, compile-pass/fail, typy test doubles | Runner setup, mocking strategy a runtime test architecture |
| ESLint | Vysvětlit compiler source of truth a API compatibility | Rule selection, flat config a lint policy |
| Package management | `.d.ts`, `types`, export conditions a resolution correctness | Publishing workflow, semver, lockfile a registry operations |
| Build/bundler | TypeScript emit/noEmit, module host alignment | Vite/Webpack/esbuild/Rollup-specific optimization |
| Code review | TypeScript-specific kontrolní body během změny | Obecný PR proces, severity taxonomy a review governance |
| SPFx | Obecná TypeScript pravidla a TS compatibility | SPFx/React/theming guidance v `martix-sharepoint-spfx` |

Repo portfolio již používá hand-off princip „stay here / open companion skill“
místo kopírování pravidel
([`docs/skill-portfolio-coordination-plan.md`, ř. 68–90](../skill-portfolio-coordination-plan.md)).
Stejný vzor je vhodný i zde.

## 4. Poučení z existujících TypeScript skillů

Detailní lokální audit je v
[`docs/martix-typescript/porovnani-ai-skillu-pro-typescript.md`](./porovnani-ai-skillu-pro-typescript.md).
### Co převzít

- Z `Jeffallan/typescript-pro`: type-first proces, pět jasných fází a tabulku
  „load when“.
- Z `pproenca/dot-skills`: krátký router a jemné, pojmenované reference.
- Z projektových skillů: respekt ke skutečnému package manageru, skriptům,
  runtime a lokálním conventions.
- Z MartiX balíčků: layered package, machine-readable taxonomy, stabilní pořadí,
  source boundary a evaly.

### Co nepřevzít

- nekompilované advanced-type příklady;
- absolutní „always branded types“, „never enums“ a podobné zákazy;
- fallback `npm run typecheck || npx tsc --noEmit`, který skryje selhání
  projektového commandu;
- zastaralé TypeScript 5.x configs (`baseUrl`, `moduleResolution: node`);
- přesná performance procenta bez reprodukovatelného benchmarku;
- široké framework triggery bez odpovídajícího obsahu;
- osiřelé reference a několik set řádků tutorial prose v `SKILL.md`;
- unix-only helper scripts v cross-platform skillu.

Lokální audit dospěl ke stejnému závěru: žádný veřejný kandidát není dost dobrý
beze změn; nejlepší je vlastní hybrid s TS7 aktualizací a kompilací každého
příkladu
([srovnání, ř. 157–169](./porovnani-ai-skillu-pro-typescript.md)).

## 5. Návrh invocation podle `writing-great-skills`

Skill má být **model-invoked**. TypeScript se objevuje uvnitř běžných coding
tasků a uživatel nemá být nucen pamatovat si ruční slash command. Cena za
always-loaded description je ospravedlněná.

Vedoucí slovo doporučuji **type-first**. Je srozumitelné, již použité v
nejlepším hodnoceném kandidátovi a spojuje invocation s runtime chováním.

### Kandidát description

> Type-first TypeScript 7 authoring, migration, debugging, and review for
> `.ts`/`.tsx`, `tsconfig`, compiler diagnostics, generics, narrowing, module
> resolution, declarations, project references, and type-check performance.
> Use when implementing or fixing TypeScript, designing typed APIs, resolving
> TS errors, migrating TypeScript 5/6 to 7, or coordinating TS7 with tools that
> still require the TypeScript 6 compiler API. Hand framework-specific UI,
> runtime test-runner, lint-policy, and package-publishing details to their
> owning skills.

Před použitím se musí description evalovat proti 20 realistickým pozitivním a
near-miss negativním promptům. `writing-great-skills` doporučuje jeden trigger
na skutečnou větev, ne seznam synonym; `skill-creator` následně umožňuje
optimalizaci description podle trigger accuracy.

## 6. Informační hierarchie a navržený balíček

`SKILL.md` má být přibližně 120–160 řádků. Specifikace doporučuje pod 500 řádků,
ale lokální audit ukazuje, že pro tento router je kratší hranice vhodnější.
Metadata se načítají vždy, celé `SKILL.md` po triggeru a zdroje až podle potřeby
([Agent Skills specification](https://agentskills.io/specification#progressive-disclosure)).

```text
skills/martix-typescript/
├── SKILL.md
├── AGENTS.md
├── README.md
├── LICENSE.txt
├── plugin.json
├── metadata.json
├── rules/
│   ├── _sections.md
│   ├── language-type-design.md
│   ├── language-narrowing-boundaries.md
│   ├── language-generics-advanced-types.md
│   ├── config-project-shape.md
│   ├── modules-host-resolution.md
│   ├── libraries-declarations-publishing.md
│   ├── migration-typescript-7.md
│   ├── tooling-api-compatibility.md
│   ├── quality-type-tests.md
│   └── performance-diagnostics.md
├── references/
│   ├── source-index.md
│   ├── typescript-7-compatibility-map.md
│   ├── tsconfig-decision-map.md
│   ├── module-host-map.md
│   ├── compiler-diagnostics-map.md
│   ├── javascript-jsdoc-ts7-changes.md
│   └── anti-patterns-quick-reference.md
├── templates/
│   ├── tsconfig-node.template.jsonc
│   ├── tsconfig-bundler.template.jsonc
│   ├── tsconfig-library.template.jsonc
│   └── type-test.template.ts
├── assets/
│   ├── taxonomy.json
│   └── section-order.json
└── evals/
    └── evals.json
```

Templates musí být varianty, ne jeden „best tsconfig“. Každý template musí
uvádět předpokládaný host a být validovaný TypeScriptem 7.0.2. TS6 compatibility
config nemá být default template; patří do transition reference.

### Jednotný rule contract

Pro konzistenci s repo portfoliem:

1. Purpose
2. Default guidance
3. Decision branches
4. Review checklist
5. Related files
6. Source anchors

Repo dnes používá obdobný contract `Purpose`, `Default guidance`, `Avoid`,
`Review checklist`, `Related files`, `Source anchors`
([`martix-dotnet-csharp/assets/section-order.json`, ř. 1–9](../../skills/martix-dotnet-csharp/assets/section-order.json)).
Pro nový skill je pozitivně formulované „Decision branches“ lepší než rozsáhlá
sekce zákazů; hard guardrails lze uvést uvnitř konkrétní větve.

## 7. Runtime proces skillu

Každý krok musí skončit kontrolovatelným completion criterion.

### Krok 1 — Inventory

Zjistit:

- `package.json`, lockfile a package manager;
- lokální `typescript` verzi a skutečný `tsc --version`;
- `tsconfig*`, `extends`, project references a package boundaries;
- runtime/host: Node, browser bundler, Bun, Deno, framework compiler;
- existující typecheck/build/test/lint scripts;
- API consumers a framework tooling blokující čistý TS7 upgrade.

**Hotovo, když:** je znám compiler generation, host, config graph a každý
relevantní validační command.

### Krok 2 — Route

Vybrat nejmenší pravidlo/reference podle problému. Module resolution se určuje
podle hosta, ne podle oblíbeného configu. Framework detail se předá owning
skillu.

**Hotovo, když:** každá část požadavku má jednoho vlastníka a nejsou načteny
nesouvisející větve.

### Krok 3 — Type-first design

Nejdříve určit:

- vstupní a výstupní boundaries;
- inference versus explicit annotation;
- discriminants, narrowing a invalid states;
- public versus internal types;
- runtime validation boundary, kde typy samy nestačí.

**Hotovo, když:** typový model zachytí požadované invariants bez spekulativních
abstrakcí.

### Krok 4 — Implement

Udělat nejmenší změnu respektující lokální conventions. Reuse existující
helpers/types, nepřidávat nový config nebo dependency bez potřeby.

**Hotovo, když:** implementace a související typové testy pokrývají změněné
chování.

### Krok 5 — Validate independently

Spustit nejmenší existující checks, každý samostatně. Projektový command má
přednost před generic `npx tsc --noEmit`. Fallback je přípustný pouze tehdy,
když projekt žádný typecheck command nemá, a musí být označen jako fallback.

**Hotovo, když:** každý relevantní command skončí úspěšně; žádné selhání není
překryto `||`; veřejné `.d.ts` nebo type tests jsou ověřeny, pokud se změnily.

### Krok 6 — Review the delta

Zkontrolovat diagnostics, runtime/type boundary, exported API, config impact,
TS6/TS7 compatibility a scope změny.

**Hotovo, když:** změna splňuje původní požadavek, nepřidává vedlejší policy a
je doložená čistými checks.

## 8. Technický obsah, který musí být pokryt

### P0 — nutné pro první kvalitní verzi

- TS7 defaults a removed options;
- TS6/TS7 side-by-side a compiler API gap;
- host-aware `nodenext` versus `preserve` + `bundler`;
- strict type safety a beyond-strict volby jako kontextová rozhodnutí;
- inference, narrowing, `unknown`, exhaustive discriminated unions;
- type-first public API design;
- declaration emit a library boundaries;
- project references a `tsc --build`;
- type-level testing;
- validace pomocí existujících project scripts;
- compiler performance pouze měřením.

### P1 — progresivně zpřístupněné větve

- Node native type stripping versus plný TS runtime;
- `allowJs`/`checkJs` a Corsa JSDoc změny;
- advanced conditional/mapped/template literal types;
- TS7 parallelism tuning;
- dual-package declarations a export maps;
- declaration diffing při migraci.

### P2 — nepatří do první verze

- framework-specific component recipes;
- kompletní ESLint pravidlový katalog;
- Vitest/Jest tutorial;
- bundler configuration cookbook;
- package publishing automation;
- obecný JavaScript performance guide.

Node native TypeScript je důležitá P1 větev: Node type stripping ignoruje
`tsconfig`, neprovádí typecheck, nepodporuje `.tsx` a odmítá konstrukce vyžadující
emit, například enums a parameter properties
([Node.js TypeScript docs](https://nodejs.org/api/typescript.html)).

## 9. Eval a review plán podle `skill-creator`

Tvorba skillu nemá skončit u „vypadá dobře“. Doporučený loop:

1. napsat draft a 6–8 realistických behavior evalů;
2. spustit každý prompt se skillem i bez něj ve stejné vlně;
3. mezitím doplnit objektivní assertions;
4. grade outputs a agregovat benchmark;
5. vygenerovat human review přes `eval-viewer/generate_review.py`;
6. zapracovat feedback bez overfittingu;
7. zopakovat alespoň jednu iteraci;
8. nakonec optimalizovat description na trigger eval setu.

### Minimální behavior eval matrix

| Eval | Co musí skill prokázat |
| --- | --- |
| TS7 greenfield Node app | Zvolí `nodenext`, zjistí runtime a nepoužije odstraněné options |
| TS7 bundler app | Zvolí host-aware `preserve` + `bundler`, ne Node config |
| TS6 → TS7 library migration | Použije stable ordering jen pro migraci, porovná `.d.ts` a odhalí API consumers |
| Vue/Svelte/Astro projekt | Nevnucuje čistý TS7 upgrade, upozorní na TS6 embedded-tooling větev |
| typescript-eslint project | Ověří declared support a navrhne kompatibilní side-by-side uspořádání |
| Advanced generic API | Vytvoří kompilovatelný typ a pozitivní i negativní type test |
| Slow monorepo | Nejdříve změří, poté uvažuje `--checkers`/`--builders` a memory tradeoff |
| Node type stripping | Rozliší erasable syntax, `tsconfig` ignorování a plný runtime přes `tsx` |

### Trigger eval set

Nejméně 20 dotazů:

- 8–10 should-trigger: TS diagnostics, `tsconfig`, advanced types, declaration
  emit, TS7 migration, compiler performance, module resolution;
- 8–10 near-miss negatives: čistý JavaScript runtime bug, React state design,
  ESLint stylistic rule, Vitest mocking, npm publishing, Webpack optimization,
  SPFx deployment.

Nejsilnější negativní evaly mají obsahovat slovo „TypeScript“, ale jejich
skutečný vlastník musí být jiný skill. Tím se ověří hranice, ne pouhé keyword
matching.

### Objektivní quality gates

- každý bundled `.ts` example kompiluje na TS7.0.2;
- migrační examples se spouštějí i na podporované TS6 compatibility verzi;
- každý `tsconfig` template projde odpovídajícím compilerem;
- evaly odhalí použití odstraněného `baseUrl` nebo `moduleResolution: node`;
- skill nikdy nepřekryje neúspěšný project script generic fallbackem;
- reference files jsou dosažitelné jedním explicitním context pointerem;
- metadata, taxonomy a section order odpovídají skutečným cestám;
- description splňuje Agent Skills limits a parent-directory match;
- repository validation a Markdown check jsou zelené.

## 10. Rizika a mitigace

| Riziko | Mitigace |
| --- | --- |
| Rychlé zastarávání po TS7.1 API | Oddělit dated compatibility map od stabilních type-design pravidel |
| Překryv s React/framework skilly | Explicitní hand-off table a near-miss trigger evaly |
| Jeden univerzální `tsconfig` | Variant templates podle hosta a decision map |
| Tutorial sprawl | `SKILL.md` jako kroky + routing; detail za context pointers |
| Nepravdivé advanced-type ukázky | Compile-test každý example a negative test |
| Performance cargo cult | Vyžadovat baseline measurement a zaznamenat CPU/memory tradeoff |
| TS7 compiler vs TS6 tooling zmatek | Inventory kroku dát samostatný compatibility check |
| Duplicitní policy v rules a references | Každé normativní pravidlo má jeden source of truth; references mapují fakta a zdroje |
| Windows portability | Projektové příkazy a cross-platform scripts; žádné implicitní `grep/head/wc` |

## 11. Doporučený implementační postup

1. Vytvořit `skills/martix-typescript` z repo template a sladit identitu ve všech
   package surfaces.
2. Napsat source index s explicitním dated baseline 2026-07-21.
3. Implementovat krátký `SKILL.md` s procesem Inventory → Route → Type-first →
   Implement → Validate → Review.
4. Přidat P0 rules a tři host-specific config templates.
5. Kompilovat všechny examples na TS7.0.2 a migrační examples také na TS6.
6. Přidat behavior a trigger evals.
7. Spustit `skill-creator` with-skill/baseline loop a vytvořit review viewer.
8. Revidovat skill přes `writing-great-skills`: invocation, hierarchy,
   completion criteria, single source of truth, no-op pruning a pozitivní
   steering.
9. Optimalizovat description až po stabilizaci obsahu.
10. Synchronizovat `plugin.json`, `metadata.json`, assets, README a marketplace
    entry a spustit repo validation.

Marketplace je shared coordinator-owned soubor; má se upravovat až po dokončení
package-local práce
([`docs/plugin-bundle-strategy.md`, ř. 107–120](../plugin-bundle-strategy.md)).

## 12. Nejistoty a otevřené body

- TypeScript 7.1 může přinést nové API a rychle změnit compatibility doporučení.
  `tooling-api-compatibility.md` proto musí být explicitně datovaný.
- `microsoft/typescript-go` README při ověření stále obsahoval některé preview
  formulace, zatímco oficiální release blog a npm potvrzují GA. Pro release status
  je autoritativnější release announcement a registry; README je užitečný pro
  roadmap a feature-parity stav.
- Framework compatibility se může lišit podle konkrétní verze framework toolingu.
  Skill má ověřovat instalované verze a oficiální compatibility, nikoli navždy
  fixovat seznam „TS6-only“.
- `allowed-tools` v Agent Skills spec je experimentální; první verze jej nemusí
  používat bez jasné runtime potřeby.
- Přesný název skillu předpokládám `martix-typescript`. Pokud má budoucí portfolio
  oddělit obecný TypeScript a React/TypeScript frontend skill, je vhodné zachovat
  obecný skill pod tímto názvem a framework vrstvu řešit companion skillem.

## Závěr

Nejlepší `martix-typescript` má být TS7-first **rozhodovací a prováděcí skill**,
nikoli další tutorial. Jeho hlavní hodnota bude v tom, že před každou změnou
spolehlivě zjistí compiler generation, host, config graph a tooling compatibility,
poté použije type-first návrh a skončí až po nezávisle úspěšných projektových
checks. Technická fakta, která se rychle mění, musí být v datovaných referencích;
stabilní runtime proces a dokončovací kritéria musí zůstat přímo v `SKILL.md`.

