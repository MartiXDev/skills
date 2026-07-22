# Srovnání `martix-dotnet-csharp` s oficiálním `dotnet/skills`

## Shrnutí

`martix-dotnet-csharp` není vhodné předělat na kopii oficiálního katalogu.
Jeho záměr — jeden instalovatelný, robustní router s mapami, pravidly,
referencemi a evaly — řeší jiný problém než oficiální katalog 99 skill balíčků
seskupených do 16 doménových pluginů. Vhodný směr je proto **převzít jejich
disciplínu pracovních postupů a měření, nikoli jejich distribuční
granularitu**.

Největší přínos oficiálního repozitáře pro tento balíček je ve čtyřech
oblastech:

1. každý zásah začíná výsledkem, vstupy a hranicí použitelnosti;
2. procedurální témata mají konkrétní workflow, validaci a obnovu po selhání;
3. evaly používají reálné fixture repozitáře, tvrdé assertiony, negativní
   aktivaci a srovnání se stavem bez skillu;
4. změny jsou měřeny opakovaně, včetně tokenů, nástrojů, počtu kroků,
   statistické nejistoty a rizika overfittingu.

Místní balíček je naopak silnější jako jednotná znalostní mapa: má malý router,
19 atomických pravidel, 13 referenčních dokumentů, stabilní taxonomii a
explicitní přechody mezi doménami. Tuto vlastnost je třeba zachovat.

Prioritou by mělo být:

- opravit tři neplatné odkazy na již neexistující výzkumné podklady;
- doplnit akční mapu pro běžné úkoly, aby široký router rychle našel správný
  pracovní postup;
- rozšířit autorský kontrakt pravidel o vstupy, workflow, validaci a recovery;
- převést evaly z popisného seznamu na spustitelný, fixture-based experiment se
  stavem bez skillu a nejméně třemi až pěti opakováními;
- postupně přidat několik hlubších „task packs“ uvnitř stejného skillu, zejména
  pro MSBuild diagnostiku, upgrade frameworku, test platformu a runtime
  diagnostiku.

## Rozsah a metoda

Srovnání bylo provedeno 21. července 2026 proti větvi `main` oficiálního
repozitáře připnuté na commit
[`1e2fc4f10eac4b48cee92426060e8e080e041d78`](https://github.com/dotnet/skills/commit/1e2fc4f10eac4b48cee92426060e8e080e041d78)
z 20. července 2026. Tím jsou inventář i odkazy reprodukovatelné.

Použity byly pouze primární zdroje vlastněné repozitářem `dotnet/skills`:

- [kořenový README](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/README.md);
- [CONTRIBUTING](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/CONTRIBUTING.md);
- [marketplace manifest](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/.github/plugin/marketplace.json);
- zdrojové `SKILL.md`, jejich `references/`, `scripts/`, agenti a testovací
  fixture;
- [implementace a dokumentace `skill-validator`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/src/README.md);
- [skill-vs-baseline experiment](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/dotnet-skills.experiment.yaml)
  a [CI workflow evaluace](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/.github/workflows/evaluation.yml).

Lokálně byly zkontrolovány `SKILL.md`, `AGENTS.md`, všech 19 pravidel, 13
referencí, taxonomie, pořadí sekcí, šablony a 10 eval případů v
`skills/martix-dotnet-csharp`.

## Inventář oficiálních skills

Na uvedeném commitu obsahuje `plugins/*/skills/*/SKILL.md` 99 skills v 16
pluginech. Počet níže vychází přímo ze zdrojového stromu; marketplace poskytuje
distribuční vrstvu nad stejnými pluginy.

| Plugin | Počet | Zkontrolovaný obsah |
| --- | ---: | --- |
| `dotnet` | 1 | `setup-local-sdk` |
| `dotnet-advanced` | 3 | C# scripts, P/Invoke, NuGet trusted publishing |
| `dotnet-ai` | 5 | vytvoření, debug, test a publikace MCP serveru; výběr AI technologie |
| `dotnet-aspnetcore` | 4 | Web API, OpenTelemetry, upload souborů, převod Blazor Server |
| `dotnet-blazor` | 9 | projekt, komponenty, formuláře, data, auth, prerendering, JS interop |
| `dotnet-data` | 1 | optimalizace EF Core dotazů |
| `dotnet-diag` | 7 | výkon, trace, dump, benchmarky, CLR activation, symbolikace crashů |
| `dotnet-experimental` | 3 | mock usage, SIMD, udržovatelnost testů |
| `dotnet-maui` | 8 | doctor, lifecycle, binding, DI, navigace, safe area, theming |
| `dotnet-msbuild` | 19 | binlog, výkon, inkrementalita, paralelismus, properties/items/targets a modernizace |
| `dotnet-nuget` | 1 | převod na Central Package Management |
| `dotnet-template-engine` | 6 | discovery, instantiation, comparison, authoring, defaults, validation |
| `dotnet-test` | 20 | spuštění a filtrování testů, platform detection, coverage, gaps, smells a testability |
| `dotnet-test-migration` | 5 | migrace MSTest, xUnit, VSTest a Microsoft.Testing.Platform |
| `dotnet-upgrade` | 6 | .NET 8→9, 9→10, 10→11, nullable, AOT a `Thread.Abort` |
| `dotnet11` | 1 | změny `System.Text.Json` v .NET 11 |

Úplný seznam je dohledatelný v
[`plugins/`](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins),
zatímco popis domén a instalace je v
[README](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/README.md).

Z 99 skills má 32 vlastní `references/`, 5 má `scripts/` a 1 má `assets/`.
Oficiální architektura tedy nepředpokládá, že každý skill musí mít všechny
vrstvy. Doplňkový soubor vzniká tam, kde řeší konkrétní náklad: obsáhlá data,
opakovatelnou diagnostiku nebo generovaný artefakt. Příklady jsou
[migrační reference .NET 9→10](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/migrate-dotnet9-to-dotnet10/references),
[skripty nullable migrace](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/migrate-nullable-references/scripts)
a [assets pro vytvoření Blazor projektu](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-blazor/skills/create-blazor-project/assets).

## Dvě různé architektury

### Oficiální repozitář: intent-first katalog

Oficiální projekt optimalizuje především aktivaci úzkého úkolu. Například
`dotnet-webapi` uvádí přímo ve frontmatter, kdy se použije a kdy se má místo něj
použít EF Core nebo jiná oblast; tělo pak obsahuje vstupy, osm kroků a validační
checklist. Viz
[`dotnet-webapi/SKILL.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-aspnetcore/skills/dotnet-webapi/SKILL.md).

Stejný princip je kodifikován v `CONTRIBUTING`: skill má brzy odpovědět, jaký
výsledek vytvoří, kdy se použije a jak se úspěch ověří; doporučené sekce jsou
Purpose, When to use / not use, Inputs, Workflow, Validation a Common pitfalls.
Tělo má zůstat pod 500 řádky a pro další detaily má použít progressive
disclosure. Viz
[`CONTRIBUTING.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/CONTRIBUTING.md).

Výhody:

- přesná aktivace podle slov, která uživatel skutečně používá;
- jednotlivý skill má jasnou dokončovací podmínku;
- workflow lze testovat na konkrétním fixture;
- specializované operace mohou bezpečně obsahovat skripty a přesné příkazy;
- každá oblast může mít vlastní vlastníky a verzi.

Náklady:

- široké pokrytí vyžaduje instalaci více doménových pluginů a routing mezi
  mnoha skill balíčky; některé z nich jsou přitom interní/reference-only a
  výslovně nejsou určené k přímé uživatelské aktivaci;
- sousední témata jsou distribuována mezi pluginy a skills;
- široká změna repozitáře vyžaduje orchestraci několika jednotek;
- doporučení se mohou mezi skills překrývat nebo být různě přísná.

Oficiální profiler navíc pracuje s praktickým rozpočtem 15 000 znaků pro celé
vykreslené menu názvů a descriptions. Velký počet současně načtených skills
tedy nemá jen instalační cenu; spotřebovává i discovery kontext. Viz
[`SkillProfiler.cs`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/src/Check/SkillProfiler.cs#L24-L75).
Tento limit přímo podporuje místní strategii jednoho přesného routeru s
progressive disclosure. Široký obsah může být hluboký, pokud se jeho názvy a
detaily nepromítají všechny do globálního aktivačního menu.

### Místní balíček: knowledge-map-first knihovna

`martix-dotnet-csharp` používá jinou kompresní hranici:

| Vrstva | Aktuální stav | Úloha |
| --- | ---: | --- |
| `SKILL.md` | 65 řádků | aktivace, kompatibilita, první směrování |
| `AGENTS.md` | 274 řádků | doménový playbook a cross-domain trasy |
| `rules/` | 19 pravidel | atomická rozhodovací doporučení |
| `references/` | 13 souborů | mapy, recepty, source trail |
| `templates/` | 3 soubory | pravidlo, rešerše, porovnání |
| `assets/` | 2 JSON soubory | taxonomie a stabilní pořadí |
| `evals/evals.json` | 10 scénářů | aktivace, routing, guidance a handoff |

Výhody:

- jedna instalace pokryje běžnou práci v SDK-style .NET repozitáři;
- centrální kompatibilitní stance chrání starší target frameworky;
- mapy jsou vhodné pro změny, které protínají web, data, async, testování,
  observabilitu a bezpečnost;
- pravidla používají jednotnou strukturu `Purpose`, `Default guidance`, `Avoid`,
  `Review checklist`, `Related files`, `Source anchors`;
- taxonomie dovoluje růst bez přidávání dalších top-level skills.

Slabší místa:

- struktura je velmi dobrá pro rozhodnutí a review, ale méně podrobná pro
  provedení diagnostiky nebo migrace od začátku do konce;
- široká aktivační fráze musí uvnitř balíčku udělat více práce, aby vybrala jen
  nezbytné soubory;
- `Review checklist` není plnohodnotná dokončovací podmínka pro procedurální
  úkol;
- evaly popisují očekávání, ale samy nyní nevytvářejí fixture, nespouštějí
  baseline bez skillu ani neprodukují statisticky použitelný výsledek;
- tři maintenance poznámky odkazují na neexistující podklady:
  `dotnet-platform.md` v `runtime-bcl-map.md` a `dotnet-sdk-map.md`, a
  `web-data-quality.md` v `quality-security-map.md`.

### Výsledek oficiální statické validace místního balíčku

Oficiální `skill-validator check` byl spuštěn i nad místním balíčkem. Kontrola
samotného skillu prošla: profiler naměřil přibližně 1 048 BPE tokenů, šest sekcí
a doporučil profil `detailed`. Upozornění na nulový počet code blocks není u
krátkého routeru samo o sobě závadou, protože příklady jsou záměrně odložené do
recipes. Funkce a způsob statické kontroly jsou popsány v
[`skill-validator README`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/src/README.md).
Oficiální implementace také hlídá description do 1 024 znaků, varuje nad 5 000
BPE tokenů, omezuje reference na jednu adresářovou úroveň od `SKILL.md` a
kontroluje velikost assets; viz
[`SkillProfiler.cs`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/src/Check/SkillProfiler.cs#L113-L265).
Současný místní router se tedy do doporučeného profilu vejde s velkou rezervou.

Kontrola ve plugin režimu však odhalila skutečnou distribuční chybu:
`skills/martix-dotnet-csharp/plugin.json` deklaruje řetězec
`"skills": "skills/"`, ale pod kořenem balíčku takový podadresář neexistuje.
Oficiální manifest používá pole `"skills": ["./skills/"]` a cesta vede na
skutečné vnořené skill adresáře; viz
[`plugins/dotnet/plugin.json`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet/plugin.json).

Proto je nutné rozhodnout mezi dvěma čistými tvary:

1. **standalone-first bez lokálního plugin manifestu** — kanonickým balíčkem je
   přímo adresář se `SKILL.md`; neplatný `plugin.json` se nepublikuje ani
   neregistruje do marketplace;
2. **volitelný plugin wrapper** — mimo kanonický skill vznikne wrapper s platným
   manifestem a skutečným `skills/martix-dotnet-csharp/` podstromem nebo jiným
   podporovaným způsobem zabalení.

První varianta nejlépe odpovídá současnému one-skill cíli. Pokud je Copilot
marketplace důležitý distribuční kanál, druhá varianta zachová jediný obsahový
zdroj, ale pluginový obal se musí samostatně validačně ověřovat. Oficiální
`dotnet` plugin navíc přidává C# LSP přes
[`lsp.json`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet/lsp.json);
to je užitečná inspirace pro volitelný plugin overlay, nikoli požadavek na
jádro standalone skillu. Konkrétní oficiální konfigurace používá prerelease
Roslyn language server, a proto by se neměla tiše stát stabilním lokálním
defaultem.

## Překryv a mezery

„Mezera“ níže neznamená automaticky požadavek převzít celý oficiální plugin.
Ukazuje, kde oficiální repozitář nabízí ověřitelný pracovní postup, zatímco
místní balíček dnes nabízí hlavně rozhodovací vodítko.

| Oblast | `martix-dotnet-csharp` | Oficiální důkaz | Doporučení |
| --- | --- | --- | --- |
| SDK baseline a repo nastavení | Silné mapování TFM, `LangVersion`, `global.json`, shared props | [`setup-local-sdk`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet/skills/setup-local-sdk/SKILL.md) | Zachovat lokální mapu; přidat jeden opakovatelný baseline-inspection postup |
| Moderní C# a public API | Místní pokrytí je širší a koherentnější | Oficiální katalog má hlavně C# scripts a verze v upgrade skills | Nepřebírat fragmentaci; zlepšit eval fixture pro čistou C# knihovnu |
| ASP.NET Core API | Dobré obecné defaults, bootstrap recept a HTTP resilience | [`dotnet-webapi`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-aspnetcore/skills/dotnet-webapi/SKILL.md), [`minimal-api-file-upload`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-aspnetcore/skills/minimal-api-file-upload/SKILL.md) | Doplnit task recepty jen pro opakované složité operace; nezavádět univerzální architektonické zákazy |
| OpenTelemetry | Místní diagnostics pravidlo je koncepční | [`configuring-opentelemetry-dotnet`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-aspnetcore/skills/configuring-opentelemetry-dotnet/SKILL.md) | Přidat konkrétní „instrument → export → verify“ recept a integrační eval |
| EF Core | Dobré zásady pro projection, tracking, paging a testy | [`optimizing-ef-core-queries`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-data/skills/optimizing-ef-core-queries/SKILL.md) | Doplnit měřitelný workflow: SQL/query plan/benchmark před a po; nevytvářet nový skill |
| MSBuild | Dvě široká pravidla; malá diagnostická hloubka | [19 MSBuild skills](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-msbuild/skills) | Nejvyšší obsahová priorita: binlog triage, evaluation/execution, incremental build a Directory.Build vrstvy jako vnitřní task pack |
| NuGet a CPM | Katalog knihoven a obecné build guidance | [`convert-to-cpm`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-nuget/skills/convert-to-cpm/SKILL.md) | Přidat CPM decision/workflow do SDK mapy včetně `packages.config` negativní hranice |
| Spouštění testů | Dobrá strategie unit/integration | [`run-tests`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-test/skills/run-tests/SKILL.md), [`platform-detection`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-test/skills/platform-detection/SKILL.md) | Přidat detection VSTest vs MTP, filtering, TRX a targeted rerun do jednoho test-execution receptu |
| Kvalita testů | Základní anti-patterny a volba vrstev | [20 test skills](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-test/skills) | Vybrat jen outcome-oriented heuristiky pro gaps, smells a assertions; nevstřebat celý katalog |
| Migrace test platformy | Nepokryto | [5 migration skills](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-test-migration/skills) | Přidat pouze pokud evaly pro reálné repo setupy prokážou opakovanou potřebu |
| Upgrade .NET | Kompatibilitní ochrana existuje, upgrade workflow je mělké | [`migrate-dotnet9-to-dotnet10`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/migrate-dotnet9-to-dotnet10/SKILL.md) a jeho [technologické reference](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/migrate-dotnet9-to-dotnet10/references) | Přidat generický upgrade workflow a verzi specifické delta reference pouze pro podporované přechody |
| Nullability migration | Silné pravidlo pro návrh, chybí řízená migrace | [`migrate-nullable-references`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/migrate-nullable-references/SKILL.md) | Přidat inkrementální migrační režim a fixture eval; stále uvnitř language task packu |
| Runtime diagnostika | Guidance pro výkon a observabilitu, bez operativních workflow | [diagnostické skills](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-diag/skills) | Přidat triage mapu „measure → trace/dump/benchmark → interpret → verify“; skripty jen pro bezpečný sběr dat |
| AOT a interop | Prakticky chybí | [`dotnet-aot-compat`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/dotnet-aot-compat/SKILL.md), [`dotnet-pinvoke`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-advanced/skills/dotnet-pinvoke/SKILL.md) | Vést jako volitelný rozšiřující modul, ne jako základ každého repo bootstrapu |
| Blazor, MAUI, Template Engine, AI/MCP | Záměrně nepokryto | Příslušné oficiální pluginy | Ponechat mimo core; přidat až při explicitním rozšíření scope a s vlastními evaly |
| .NET 11 | Místní stance je released .NET 10+/C# 14+ | [`system-text-json-net11`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet11/skills/system-text-json-net11/SKILL.md) | Zachovat stabilní default; preview/next-version obsah oddělit viditelným compatibility gate |

## Co převzít z oficiálního návrhu

### 1. Akční routing uvnitř jednoho skillu

Oficiální názvy jsou většinou slovesné a odpovídají konkrétnímu výsledku:
`run-tests`, `convert-to-cpm`, `dump-collect`, `binlog-failure-analysis` nebo
`migrate-dotnet9-to-dotnet10`. Místní routing je nyní primárně doménový:
Language, SDK, Runtime, Async, Design, Web, Data, Quality/Security.

Přidejte druhou, akční osu bez další instalační jednotky:

```text
uživatelský záměr
  → akční trasa (build / migrate / diagnose / test / create / review)
    → doménová mapa
      → pravidlo
        → volitelný task recipe nebo script
          → validační kontrakt
```

Konkrétně vytvořit `references/task-workflow-map.md` s poli:

| Pole | Příklad |
| --- | --- |
| Intent phrases | „build fails“, `MSB*`, „upgrade to .NET 10“ |
| Required inspection | `.csproj`, `global.json`, `Directory.Build.*` |
| First file | `rules/sdk-project-system.md` |
| Optional deep recipe | `references/build-diagnostics-recipe.md` |
| Stop/hand-off boundary | native crash symbolikace, MAUI UI apod. |
| Validation | build/test/smoke/measurement |

Tato mapa řeší největší riziko robustního unified skillu: ne množství obsahu,
ale špatný výběr prvního souboru.

### 2. Outcome-first kontrakt pro procedurální pravidla

Oficiální `CONTRIBUTING` požaduje outcome, inputs, workflow a validation. Místní
šestisekční kontrakt je vhodný pro advice, ale nestačí pro „udělej migraci“ nebo
„diagnostikuj build“.

Upravit `rules/_sections.md`, `templates/rule-template.md` a
`assets/section-order.json` takto:

1. zachovat povinné `Purpose`, `Default guidance`, `Avoid`, `Review checklist`,
   `Related files`, `Source anchors`;
2. dovolit pro procedurální pravidlo navíc `Inputs and prerequisites`,
   `Workflow`, `Validation` a `Failure recovery`;
3. v šabloně vyžadovat explicitní označení typu `decision rule` nebo
   `task workflow`, aby nebyly procedurální sekce uměle doplňovány všude;
4. validaci formulovat jako pozorovatelný výsledek, ne pouze „zkontrolujte“.

Tím zůstane běžné pravidlo krátké, ale hluboké task packy budou dokončitelné.

### 3. Selektivní task packs, ne nové top-level skills

Doporučené první čtyři packy:

1. `references/build-diagnostics-recipe.md`
   - rozlišit restore, evaluation a execution;
   - kdy vytvořit binlog a jak chránit citlivá data;
   - identifikovat první kořenovou chybu a oddělit kaskádu;
   - ověřit fix čistým i inkrementálním buildem.
2. `references/framework-upgrade-recipe.md`
   - inventář TFM/SDK/packages/workloads;
   - kompilátorové, source a behavioral changes;
   - po malých dávkách build/test/smoke;
   - samostatné delta reference pro konkrétní dvojice verzí.
3. `references/test-execution-recipe.md`
   - detekce VSTest vs Microsoft.Testing.Platform;
   - správné filtrování, reporting a targeted rerun;
   - oddělení command correctness od test design guidance.
4. `references/runtime-diagnostics-recipe.md`
   - rozhodnutí trace vs dump vs benchmark;
   - bezpečný sběr, platformní omezení a reprodukovatelnost;
   - měření před/po a ukončovací kritéria.

Oficiální příklady ukazují, že hluboká operace může mít vlastní reference a
skripty, aniž by vše bylo vloženo do `SKILL.md`; například
[`migrate-dotnet9-to-dotnet10`](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/migrate-dotnet9-to-dotnet10)
a
[`apple-crash-symbolication`](https://github.com/dotnet/skills/tree/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-diag/skills/apple-crash-symbolication).

### 4. Skripty pouze pro deterministické získání důkazů

Oficiální katalog má skripty jen u 5 z 99 skills. To je dobrý signál, že script
není povinná známka „robustnosti“.

Pro místní balíček dávají smysl nejvýše malé, read-only nebo explicitně
potvrzené utility:

- `scripts/inspect-repo-baseline.ps1`: TFM, SDK pin, language version, shared
  props, CPM a detekce test platformy;
- `scripts/collect-build-evidence.ps1`: parametrizované vytvoření binlogu bez
  automatické publikace;
- případně `scripts/check-skill-package.ps1`: interní odkazy, sekční kontrakt,
  JSON a source anchors.

Každý script má mít podporované platformy, vstupy, výstupy, bezpečnostní
omezení, režim bez změn a validační eval. Není vhodné automatizovat kroky, které
vyžadují architektonické rozhodnutí.

### 5. Explicitnější hranice ve frontmatter

Oficiální doporučení říká vložit podstatné „when to use“ i „when not to use“ už
do `description`, protože podle něj runtime rozhoduje o načtení těla. Viz
[`CONTRIBUTING.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/CONTRIBUTING.md)
a konkrétní
[`thread-abort-migration/SKILL.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-upgrade/skills/thread-abort-migration/SKILL.md).

Místní popis již dobře předává FastEndpoints a FluentValidation. Doplnil bych
ještě stručnou negativní hranici pro Blazor UI, MAUI, native crash symbolikaci,
template authoring a AI/MCP. Ne proto, aby se skill zmenšil, ale aby jeho široká
aktivace byla predikovatelná. Budoucí task pack může konkrétní hranici později
zrušit.

## Evaly: největší metodická příležitost

### Co má místní balíček dobře

Současných 10 případů již rozlišuje:

- pozitivní aktivaci;
- negativní a companion-skill hranice;
- first-file routing;
- kompatibilitu staršího SDK-style repozitáře;
- cross-domain témata jako options/DI, EF Core, serializace a public API;
- rubriku Activation, First-file routing, Guidance a Handoff.

To je správně zacílené na unified router. Oficiální jednotlivé skills obvykle
nemusejí měřit tak složitou vnitřní navigaci.

### Co přidat podle oficiálního harnessu

Oficiální `skill-validator` spouští každý scénář bez skillu a se skillem,
sbírá tokeny, tool calls, čas, chyby a dokončení, používá pairwise judge s
prohozením pořadí a z opakovaných běhů počítá bootstrap confidence intervals.
Výchozí počet běhů je 5. Viz
[`skill-validator README`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/src/README.md).

Oficiální eval schema navíc podporuje:

- fixture soubory a setup commands;
- `output_*`, `file_*` a `exit_success` assertiony;
- očekávané a zakázané nástroje;
- limity turnů, tokenů a času;
- explicitní `expect_activation: false`;
- další nutné skills/agenty pro izolovaný běh.

Pravidla pro tvorbu testů zdůrazňují přirozený prompt bez názvu skillu,
outcome místo konkrétní techniky či slovníku a negativní scénáře ověřující
rozpoznání, zdrženlivost a správné přesměrování. Viz
[`create-skill-test/SKILL.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/.agents/skills/create-skill-test/SKILL.md)
a [overfitting dokumentace](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/src/docs/OverfittingDetection.md).
Zákaz názvu cílového skillu v promptu je navíc vynucen testy discovery vrstvy;
viz
[`EvalDiscoveryTests.cs`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-validator/tests/Evaluate/EvalDiscoveryTests.cs#L149-L187).

Oficiální repozitář má také coverage nástroj, který páruje teaching points ze
`SKILL.md` s assertions a rubric a rozlišuje deterministické pokrytí od
rubric-only pokrytí. Viz
[`Measure-SkillCoverage.ps1`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/eng/skill-coverage/Measure-SkillCoverage.ps1#L3-L41).
Pro unified skill by obdobná matice měla navíc obsahovat route: každý veřejně
deklarovaný intent ve frontmatter nebo routing table má mít alespoň jeden
pozitivní eval, každý handoff/`When not to use` negativní eval a každá kolize
domén overlap eval.

### Doporučený místní experiment

Nejvhodnější není slepě převzít cizí adresářové schéma, ale převzít experiment:

| Rameno | Účel |
| --- | --- |
| `no-skill` | zjistit, co model zvládne bez balíčku |
| `current` | změřit současný router a obsah |
| `candidate` | ověřit navrženou změnu |

Každý scénář spustit alespoň 3× při běžné iteraci a 5× před přijetím větší
změny. Ukládat model, commit, prompt, fixture hash, načtené soubory, tool calls,
turns, tokeny, čas, assertiony, rubric score a rozhodnutí. Přidat interval
nejistoty nebo alespoň rozptyl; samotný jeden průchod 6/8 není dostatečný.

Rozšířit `evals/evals.json`, nebo jej převést na YAML, o:

- `setup.files` / `fixture_dir`;
- `expect_activation` místo odvozování pouze z `negative_activation`;
- tvrdé `assertions` oddělené od judge rubriky;
- `expect_tools`, `reject_tools`, `max_turns`, `max_tokens`, `timeout`;
- `baseline: no-skill` a `runs`;
- identitu kandidáta a hash vstupů.

Povinné nové fixture scénáře:

1. MSBuild build s jednou kořenovou chybou a několika kaskádami;
2. stejné API zadání v projektu .NET 8 a .NET 10;
3. VSTest a MTP projekty vyžadující odlišný filter/TRX příkaz;
4. EF Core endpoint s nechtěným načtením celých entit a více kolekcí;
5. nullable migration po jednom projektu nebo souboru;
6. near-miss Blazor, MAUI a non-.NET zadání;
7. široký cross-domain task, který ověří, že router načte jen potřebnou větev.

Pro inspiraci na reálný fixture design lze použít
[`optimizing-ef-core-queries/eval.yaml`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/tests/dotnet-data/optimizing-ef-core-queries/eval.yaml),
[`run-tests/eval.yaml`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/tests/dotnet-test/run-tests/eval.yaml)
a
[`binlog-failure-analysis/eval.yaml`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/tests/dotnet-msbuild/binlog-failure-analysis/eval.yaml).

## Konkrétní plán změn podle souborů

### P0 — integrita a měřitelnost

1. `plugin.json` a marketplace registrace
   - opravit zjištěnou neplatnou `skills/` cestu;
   - preferovat standalone-only distribuci, nebo vytvořit samostatný validní
     wrapper s reálným skill podstromem;
   - přidat plugin-mode statickou kontrolu do release checklistu.
2. `references/runtime-bcl-map.md`
   - odstranit nebo nahradit odkaz na neexistující `dotnet-platform.md`;
   - uvést živý backlog nebo konkrétní source anchors.
3. `references/dotnet-sdk-map.md`
   - stejná oprava `dotnet-platform.md`;
   - přidat vstup do budoucí MSBuild/upgrade task trasy.
4. `references/quality-security-map.md`
   - odstranit nebo nahradit neexistující `web-data-quality.md`;
   - backlog CORS/CSRF vyjádřit přímo nebo odkázat na existující issue/plán.
5. `evals/`
   - vytvořit skutečný `results.md` podle existujícího protokolu;
   - přidat `no-skill` rameno, opakování a alespoň dva malé fixture repozitáře;
   - evidovat commit a model, aby šlo výsledky reprodukovat;
   - doplnit route-to-eval coverage report;
   - zvážit adaptér ze současného `evals.json` do oficiálního `eval.yaml`
     schématu, aby šel použít `skill-validator` bez přepsání kanonických dat.

### P1 — rychlejší routing unified skillu

1. Přidat `references/task-workflow-map.md`.
2. Odkázat jej ze `SKILL.md` hned vedle domain routing table.
3. Přidat jej do `assets/section-order.json` a inventáře v `AGENTS.md`.
4. V `SKILL.md` přidat stručné `When not to use`, aniž by se rozšiřovalo tělo
   o technické návody.
5. Přidat evaly pro kolize domén: build failure vs NuGet restore, API
   performance vs EF query, observability setup vs runtime performance incident.

### P2 — hluboké vnitřní task packs

1. Přidat build diagnostics a test execution recipe.
2. Poté framework upgrade a runtime diagnostics recipe.
3. Každý pack zavést až s fixture evalem a explicitní validací.
4. Doplnit jen skripty, které deterministicky sbírají fakta; nezačínat obecnou
   automatizační vrstvou.
5. Rozšířit `doc-source-index.md` o datum kontroly, podporované verze a
   provenance každého nového version-specific reference packu.

### P3 — volitelné rozšíření po důkazu z evalů

- AOT a P/Invoke;
- Central Package Management migrace;
- test platform migrations;
- OpenTelemetry bootstrap;
- případně Blazor, MAUI, Template Engine nebo AI/MCP jako jasně označené
  volitelné domény uvnitř stejného balíčku.

Rozšíření má projít třemi branami: opakovaný uživatelský scénář, nový obsah
prokazatelně zlepšuje `no-skill` baseline a routing nezhorší negativní či
cross-domain evaly.

## Co z oficiálního repozitáře nepřebírat

### Plošné převzetí katalogové granularity

Oficiální marketplace instaluje doménové pluginy, nikoli nutně každý z 99 skill
balíčků samostatně, a některé balíčky jsou reference-only. Přesto by stejné
členění pro plné pokrytí vyžadovalo více pluginů a směrování mezi mnoha
jednotkami. To odporuje záměru připravit nový repozitář jednou instalací.
Místní balíček má zachovat jediný top-level skill a používat vnitřní task
routes.

### Plošné kopírování obsahu

Oficiální obsah je vhodný jako zdroj scénářů a ověřitelných postupů, ne jako
text k přenesení. `CONTRIBUTING` samo požaduje inspiraci přepsat a přizpůsobit
vlastním konvencím. Viz
[`CONTRIBUTING.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/CONTRIBUTING.md).

### Univerzální architektonické předpisy bez kontextu

Například oficiální `dotnet-webapi` předepisuje mimo jiné nemíchat controllers
a Minimal APIs, používat sealed records pro všechny DTO a rozhraní pro každou
service. Taková pravidla mohou být užitečným defaultem v konkrétní šabloně, ale
nejsou bezpečným univerzálním zákonem pro každý existující repozitář. Místní
skill má nadále nejdříve číst konvence repozitáře a formulovat trade-off. Viz
[`dotnet-webapi/SKILL.md`](https://github.com/dotnet/skills/blob/1e2fc4f10eac4b48cee92426060e8e080e041d78/plugins/dotnet-aspnetcore/skills/dotnet-webapi/SKILL.md).

### Marketplace a multi-agent infrastrukturu

Pluginové manifesty, individuální verzování, CODEOWNERS po pluginu a
specializovaní agenti řeší provoz velkého veřejného katalogu. Pro jeden osobní
unified skill by zvýšily údržbu bez odpovídajícího přínosu. Smysl má pouze
statická validace balíčku a reprodukovatelný eval harness.

### Automatický import preview/next-version obsahu

Oficiální strom již obsahuje .NET 11 obsah. `martix-dotnet-csharp` deklaruje
released .NET 10+ a C# 14+ default. Version-specific delta pack má být oddělený
od stabilního jádra a aktivovaný pouze po zjištění targetu nebo při explicitním
upgrade zadání.

### Skript pro každý workflow

Poměr 5 skills se skripty ku 99 celkem potvrzuje, že většina znalostních a
rozhodovacích témat skript nepotřebuje. Script má vzniknout jen tam, kde
snižuje chybu nebo reprodukuje sběr důkazů.

## Cílový tvar balíčku

Doporučená architektura zachovává jednu instalaci:

```text
martix-dotnet-csharp/
├── SKILL.md                 # krátká aktivace + domain/action router
├── AGENTS.md                # cross-domain playbook
├── rules/                   # stabilní rozhodovací pravidla
├── references/
│   ├── *-map.md             # doménové mapy
│   ├── task-workflow-map.md # akční vstupní mapa
│   ├── *-recipe.md          # hlubší procedurální task packs
│   └── versions/            # jen podporované version-delta reference
├── scripts/                 # malé, bezpečné evidence collectors
├── evals/
│   ├── evals.yaml           # scénáře + assertions + constraints
│   ├── fixtures/            # malé realistické repozitáře
│   └── results.md           # verzované experimentální výsledky
├── templates/
└── assets/
```

Klíčová vlastnost je dvojí progressive disclosure:

1. aktivace načte jen `SKILL.md`;
2. router zvolí jednu doménovou nebo akční mapu;
3. mapa otevře jedno pravidlo;
4. procedurální recipe/reference/script se načte jen tehdy, když úkol opravdu
   vyžaduje hluboké provedení.

To umožní robustní, široké pokrytí bez toho, aby každá odpověď platila tokenovou
daň za celý balíček.

## Rozhodnutí

Oficiální `dotnet/skills` potvrzuje, že místní balíček potřebuje více
proveditelných workflow a výrazně silnější eval infrastrukturu. Nepotvrzuje ale,
že musí být rozdělen na mnoho skills. Pro zamýšlený způsob použití je lepší
**one-skill/many-routes** model:

- jednotná instalace a kompatibilitní politika;
- mapy jako levná navigace;
- atomická pravidla pro běžná rozhodnutí;
- několik hlubokých task packs pro operace, kde obecné guidance nestačí;
- fixture-based evaly dokazující, že nový obsah pomáhá a nezhoršuje routing.

První implementační iterace má skončit po P0 a P1. Teprve výsledky evalů mají
rozhodnout, který z P2 task packů přinese největší užitek na token a náklad
údržby.
