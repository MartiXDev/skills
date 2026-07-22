# Kvalitní evaly pro Agent Skills

Datum rešerše: 2026-07-20

## Shrnutí

Kvalitní evaly Skillu musí odděleně ověřovat dvě věci:

1. zda se Skill aktivuje pro správné požadavky a neaktivuje pro blízké
   nerelevantní požadavky;
2. zda po aktivaci skutečně zlepší správnost, úplnost a efektivitu výsledku.

Samotná existence `evals/evals.json`, očekávaných sekcí nebo několika
ukázkových promptů kvalitu nedokazuje. Silná sada potřebuje realistické a
hraniční scénáře, diskriminační assertions, vhodně zvolené gradery, opakované
běhy pro nedeterministické části, baseline a regresní workflow.

Repozitář už správně definuje evaly jako regresní pokrytí routingu a očekávané
kvality. Jeho validátor však kontroluje hlavně tvar dat a existenci souborů,
nikoli sémantickou kvalitu promptů, assertions nebo jejich schopnost odhalit
regresi. Portfolio audit proto musí posuzovat obě vrstvy samostatně:
strukturální validitu a důkazní sílu.

## Co musí eval sada měřit

| Vrstva | Otázka | Preferovaný důkaz |
| --- | --- | --- |
| Aktivace | Načte se Skill, když má? | Pozitivní prompty, trigger rate |
| Neaktivace | Vynechá Skill u near-miss? | Negativní near-misses |
| Instrukce | Dodrží postup a hranice? | Assertions nad výstupem a trace |
| Výsledek | Je správný a úplný? | Checks a jasná rubrika |
| Nástroje | Zvolí správný nástroj a data? | Tool call a argumenty |
| Přínos | Je lepší než baseline? | Baseline a blind A/B |
| Stabilita | Uspěje napříč běhy? | Pass rate a rozptyl |
| Náklady | Odpovídá přínos nákladům? | Delta času a tokenů |

Codex vybírá Skill při implicitní aktivaci podle `description`, proto routingový
test nesmí spoléhat jen na explicitní `$skill` invocation. Oficiální Codex
dokumentace požaduje jasný scope a boundaries v popisu a doporučuje testovat
prompty přímo proti popisu Skillu
([OpenAI: Build skills](https://learn.chatgpt.com/docs/build-skills)). OpenAI pro
agenty dále rozlišuje instruction following, funkční správnost, výběr nástroje
a přesnost jeho argumentů
([OpenAI: Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices)).

## Návrh testovacích případů

### Output a workflow evaly

Jeden případ má obsahovat realistický uživatelský prompt, lidsky čitelný popis
úspěchu, případné vstupní soubory a konkrétní ověřitelné assertions. Pro první
iteraci stačí 2–3 případy, ale už mezi nimi má být alespoň jeden edge case.
Prompty mají měnit formulaci, míru detailu a formálnost a mají používat reálný
kontext, jako jsou cesty k souborům a konkrétní hodnoty
([Agent Skills: Evaluating skill output quality](https://agentskills.io/skill-creation/evaluating-skills)).

Praktické minimální pokrytí jednoho Skillu:

- hlavní happy path odpovídající primárnímu slibu Skillu;
- další reprezentativní varianta hlavní schopnosti;
- edge, error nebo bezpečnostní scénář;
- package-specific boundary či dříve pozorovaná regrese;
- scénář s nástrojem nebo vstupním souborem, pokud je používání nástroje či
  artefaktu podstatou Skillu.

Ne každý Skill potřebuje všech pět samostatných případů. Každá relevantní
kategorie ale musí být pokryta a minimem pro nový Skill zůstávají tři
realistické capability případy: core, edge a package-specific boundary.

### Routing evaly

Routingová sada má být samostatná, protože měří jiný jev než kvalitu výstupu.
Cílový stav je přibližně 20 dotazů: 8–10 `should-trigger` a 8–10
`should-not-trigger`. Negativní případy mají být obtížné near-misses se stejnými
klíčovými slovy, sousední doménou nebo konkurenčním Skillem, ne zjevně
nerelevantní prompty. Pozitivní sada má kombinovat explicitní a implicitní
záměr, krátké i kontextové zadání, běžný jazyk, překlepy a jedno- i vícekrokové
úlohy
([Agent Skills: Optimizing skill descriptions](https://agentskills.io/skill-creation/optimizing-descriptions)).

Při optimalizaci popisu se mají routing dotazy rozdělit přibližně 60/40 na
train a held-out validation. Fixní validation sada omezuje přeučení na konkrétní
formulace. Po optimalizaci je vhodné přidat ještě čerstvé, dosud nepoužité
dotazy.

## Assertions a gradery

Dobrá assertion je konkrétní, pozorovatelná a schopná odlišit správný výstup od
zjevně chybného. `Výstup je kvalitní` je neověřitelné; požadavek na přesnou
frázi je naopak často příliš křehký. Každý PASS má obsahovat konkrétní důkaz ve
výstupu nebo artefaktu
([Agent Skills: grading principles](https://agentskills.io/skill-creation/evaluating-skills#grading-principles)).

Použij tuto hierarchii graderů:

1. deterministický check pro syntaxi, schéma, existenci souboru, počet položek,
   kompilaci, lint, testy a přesná data;
2. LLM pass/fail, klasifikaci nebo pairwise grader s explicitní rubrikou pro
   významově otevřené vlastnosti;
3. lidské hodnocení pro subjektivní kvalitu a pravidelnou kalibraci
   automatických graderů.

OpenAI podporuje string, similarity, model a Python gradery, ale doporučuje
LLM-as-a-judge až tam, kde kód nestačí. Modelový grader se má ověřit na více
kandidátních odpovědích a ground truths, bránit reward hackingu a používat
vyvážená data
([OpenAI: Graders](https://developers.openai.com/api/docs/guides/graders)).
OpenAI současně upozorňuje, že modely lépe rozlišují mezi možnostmi než volně
generují hodnocení; pairwise, klasifikace a skórování podle konkrétních kritérií
jsou proto vhodnější než vágní holistické skóre
([OpenAI: Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices)).

`expected_sections` je užitečný kontrakt struktury, ale sám o sobě není grader.
Sekce může existovat a přitom být věcně prázdná nebo chybná. Alespoň klíčové
scénáře proto potřebují assertions, které kontrolují obsah nebo dosažený
výsledek.

## Nedeterminismus a férovost

Každý běh musí začínat s čistým kontextem a stejnými podmínkami. Capability
eval se spouští se Skillem a proti baseline bez Skillu, případně proti snapshotu
předchozí verze. Porovnání má používat stejný prompt, vstupy, model a povolené
nástroje. Blind A/B snižuje očekávací zkreslení LLM nebo lidského hodnotitele
([Agent Skills: Evaluating skill output quality](https://agentskills.io/skill-creation/evaluating-skills)).

Modelové chování není deterministické. Pro routing je rozumný začátek tři běhy
na dotaz a sledování trigger rate. U output evalů se mají více trials použít
zejména u flaky nebo uživatelsky kritických scénářů; report má uvádět alespoň
pass rate a rozptyl. Pro uživatelsky exponované agenty je důležitá konzistence,
nikoli jen možnost uspět alespoň jednou
([Anthropic: Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)).

Nulová úspěšnost nemusí znamenat slabý Skill. Nejdřív je nutné ověřit, že zadání
je jednoznačné, řešitelné a že známé referenční řešení gradery opravdu projde.
Dva doménoví experti by měli být schopni dojít ke stejnému PASS/FAIL verdiktu.

## Coverage a regresní workflow

OpenAI doporučuje task-specific evaly odpovídající reálné distribuci,
automatizované skórování kalibrované lidskou zpětnou vazbou a průběžné
rozšiřování sady o nové případy nedeterminismu. Dataset má zahrnovat typické,
edge a adversarial případy
([OpenAI: Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices)).

Doporučený cyklus:

1. definovat měřitelný cíl a rozhodovací hranice Skillu;
2. sestavit realistický dataset a referenční řešení;
3. zvolit nejdeterminističtější vhodné gradery;
4. změřit baseline a novou verzi za shodných podmínek;
5. prohlédnout výstupy, trace a selhání graderů;
6. opravit obecnou příčinu, nikoli konkrétní eval prompt;
7. spustit celou sadu znovu a uložit výsledky iterace;
8. přidat reálné chyby a nové boundaries jako regresní případy.

Automatické evaly mají běžet při změně `SKILL.md`, routingu, assertions,
skriptů nebo relevantních referencí a při změně cílového modelu. Produkční
feedback a ruční kontrola trace doplňují mezery automatizace. Žádná jednotlivá
vrstva nepokrývá vše
([OpenAI: Trace grading](https://developers.openai.com/api/docs/guides/trace-grading),
[Anthropic: Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)).

## Doporučený minimální standard repozitáře

Skill je připravený pro regresní ochranu pouze tehdy, když splní všechna tato
minima:

- validní repo schéma, stabilní popisné string `id` a existující vstupní
  soubory;
- nejméně tři capability scénáře: core, edge/error a package-specific
  boundary/regression;
- konkrétní assertions u každého případu; samotné `expected_sections` nestačí
  tam, kde nerozliší správný a chybný obsah;
- pozitivní implicitní aktivace a alespoň jeden obtížný negativní near-miss;
- deterministický grader pro vše, co lze ověřit programově;
- jasná LLM nebo lidská rubrika s důkazem pro otevřená kritéria;
- baseline bez Skillu nebo se starou verzí;
- opakované běhy a evidence variability pro nedeterministické či kritické
  scénáře;
- uložený pass rate a delta času/tokenů alespoň při release nebo významné
  změně;
- vlastník sady a pravidlo, že každá opravená reálná chyba přidá regresní
  případ.

Pro routing je výše uvedené minimum pouze vstupní gate. Zralý Skill má cílit na
samostatnou sadu přibližně 20 pozitivních a near-miss negativních dotazů, každý
opakovaný třikrát a s held-out validation sadou.

## Auditní rubrika

Každou oblast ohodnoť 0–2 body:

| Oblast | 0 bodů | 1 bod | 2 body |
| --- | --- | --- | --- |
| Schéma | Chybí | Validní | Validní a úplné |
| Coverage | Triviální | Core a část hranic | Core, edge a regrese |
| Routing | Bez negative | Snadný negative | Realistické near-misses |
| Assertions | Vágní | Zčásti ověřitelné | Diskriminační, s evidencí |
| Graders | Jen dojem | Bez kalibrace | Vhodné a kalibrované |
| Variabilita | Jeden běh | Některé reruns | Pass rate a rozptyl |
| Baseline | Chybí | Neformální | Reprodukovatelný, blind A/B |
| Regrese | Jednorázová | Ruční rerun | Automatická gate |

Interpretace:

- 0–5: evaly chybí nebo neposkytují použitelný důkaz;
- 6–10: základní smoke coverage, významná rizika zůstávají;
- 11–13: dobrá regresní sada s několika konkrétními mezerami;
- 14–16: vyspělá, reprodukovatelná a průběžně udržovaná sada.

Tato bodová hranice je doporučený repo overlay odvozený z uvedených principů,
nikoli součást otevřeného Agent Skills standardu.

## Audit současného portfolia

### Rozsah a metoda

Audit zahrnuje všech deset instalovatelných balíčků pod `skills/martix-*`.
Nezahrnuje šablonu `templates/skill-package` ani interní pracovní Skills pod
`.agents/skills`, protože nejsou samostatnými publikovanými balíčky portfolia.

Byly provedeny tyto kontroly:

- parsování všech `evals/evals.json` a inventura polí;
- porovnání promptů a assertions s doménami v `assets/taxonomy.json`;
- posouzení realističnosti pozitivních, negativních a hybridních promptů;
- kontrola existence runneru, fixtures, grading a benchmark artefaktů;
- spuštění `scripts/validate-repository.ps1`.

Repozitářová validace prošla. To potvrzuje strukturální validitu, ne
funkční kvalitu: validátor assertions ani výsledky běhů nevyžaduje.

### Souhrnná inventura

| Metrika | Stav |
| --- | ---: |
| Publikované Skills | 10 |
| Skills s `evals/evals.json` | 10 |
| Eval případy celkem | 67 |
| Pozitivní případy | 48 |
| `negative_activation` případy | 19 |
| Případy s assertions | 47 |
| Případy bez assertions | 20 |
| Assertions celkem | 174 |
| Dedikované vstupní fixtures | 0 |
| Uložené grading nebo benchmark výsledky | 0 |
| Nenulové `escalation` kontrakty | 0 |

Všechny Skills tedy eval soubor mají, ale ani u jednoho dnes nelze z
repozitáře doložit, že Skill proti baseline skutečně zvyšuje úspěšnost.
Neexistuje uložený pass rate, rozptyl, časová/tokenová delta ani výsledek
blind porovnání.

### Hodnocení po jednotlivých Skills

Skóre používá výše uvedenou rubriku 0–16. Protože všem balíčkům chybí
gradery, opakované běhy, baseline a automatická regresní gate, může i velmi
dobrá statická specifikace dosáhnout nejvýše 8 bodů. Jde o skóre zralosti
eval systému, nikoli o hodnocení kvality samotného Skillu.

| Skill | Evals | S assertions | Negative | Skóre | Stav |
| --- | ---: | ---: | ---: | ---: | --- |
| [`martix-dotnet-csharp`](../skills/martix-dotnet-csharp/evals/evals.json) | 5 | 5 | 2 | 7 | Silný smoke základ |
| [`martix-essl`](../skills/martix-essl/evals/evals.json) | 9 | 9 | 2 | 8 | Nejlépe pokrytá doména |
| [`martix-fastendpoints`](../skills/martix-fastendpoints/evals/evals.json) | 6 | 6 | 1 | 6 | Příliš routingové |
| [`martix-fluentvalidation`](../skills/martix-fluentvalidation/evals/evals.json) | 6 | 6 | 1 | 6 | Dobré assertions, slabé near-miss |
| [`martix-markdown`](../skills/martix-markdown/evals/evals.json) | 6 | 2 | 2 | 5 | Core evaly bez assertions |
| [`martix-powershell`](../skills/martix-powershell/evals/evals.json) | 7 | 7 | 2 | 8 | Nejsilnější assertions |
| [`martix-sharepoint-pnp`](../skills/martix-sharepoint-pnp/evals/evals.json) | 6 | 2 | 2 | 5 | Pozitivní evaly bez assertions |
| [`martix-sharepoint-server`](../skills/martix-sharepoint-server/evals/evals.json) | 7 | 1 | 3 | 5 | Šest evalů bez assertions |
| [`martix-sharepoint-spfx`](../skills/martix-sharepoint-spfx/evals/evals.json) | 8 | 2 | 2 | 6 | Šest evalů bez assertions |
| [`martix-tunit`](../skills/martix-tunit/evals/evals.json) | 7 | 7 | 2 | 7 | Široké, ale routingové pokrytí |

#### `martix-dotnet-csharp`

Silné stránky jsou konkrétní hranice s FastEndpoints a FluentValidation,
modernizace staršího SDK projektu a oddělení premium plánování od
implementačních slices. Assertions jsou převážně ověřitelné.

Doplnit je potřeba samostatné případy pro async/concurrency a cancellation,
EF Core nebo data access, diagnostiku a bezpečnost. Alespoň jeden případ má
vytvořit nebo upravit reálný projekt, který lze zkompilovat a otestovat.

#### `martix-essl`

Sada má nejlepší doménovou šíři: compliance, příjem, metadata, WS API,
SIP/METS, migraci i právní hranici. Assertions přezkušují konkrétní pojmy a
zdrojové vrstvy, ne pouze formát odpovědi.

Doplnit je vhodné spisovou tvorbu, governance/audit trail a hlubší skartační
edge case. U tvrzení založených na právních a normativních zdrojích má grader
kontrolovat konkrétní citaci a verzi zdroje; pouhá přítomnost termínu nestačí.

#### `martix-fastendpoints`

Prompty pokrývají všech šest taxonomy domén a dobře testují progresivní
načítání minimálního rule setu. Polovina assertions ale hodnotí routing,
handoff nebo proces místo správnosti výsledné implementace.

Doplnit je třeba konkrétní endpoint projekt s kompilací a integračním testem,
samostatný auth/authz failure case a druhý realistický near-miss. U AOT scénáře
mají checks ověřit build/publish, ne pouze správné rozdělení plánu.

#### `martix-fluentvalidation`

Assertions dobře zachycují `ValidateAsync`, manual validation boundary,
TestHelper a rozlišení message, error code, severity a custom state.

Jediný negative prompt je abstraktní meta-požadavek, nikoli near-miss. Nahradit
nebo doplnit jej konkrétním DataAnnotations, Minimal API filter nebo
FastEndpoints-only scénářem. Chybí samostatné pokrytí RuleSets,
conditions/cascade flow a extensibility; vytvořený validátor má projít
deterministickými unit testy.

#### `martix-markdown`

Čtyři hlavní pozitivní scénáře mají jen `expected_output`, bez jediné
assertion. Assertions jsou přítomné pouze u dvou scope-boundary případů. Sada
proto chrání neaktivaci lépe než vlastní lint a repair schopnost.

Nejvyšší priorita je rozložit každý ze čtyř `expected_output` popisů do
konkrétních assertions. Přidat malé Markdown/config fixtures s očekávaným
markdownlint výsledkem a deterministicky ověřit, že oprava odstranila cílené
nálezy bez plošného vypnutí pravidel. Doplnit tabulky, seznamy, code/HTML a
front matter.

#### `martix-powershell`

Staticky nejsilnější sada: assertions kontrolují konkrétní atributy, typy,
metody, zakázané aliasy a destruktivní safety kontrakt. Dva negative případy
jsou realistické a blízké scope hranici.

Chybí však fixtures a skutečné AST, build nebo Pester/PSScriptAnalyzer ověření.
Doplnit modulový manifest/package, parameter sets, validační atributy a
advanced patterns. Assertions musí označit, zda vymáhají upstream PowerShell
kontrakt, nebo přísnější MartiX repo styl; jinak hrozí, že lokální preference
bude prezentována jako platformní povinnost.

#### `martix-sharepoint-pnp`

Pozitivní prompty dobře vybírají nástroje, auth a hranici mezi PnPjs,
PnP PowerShell a CLI for Microsoft 365. Všechny čtyři pozitivní případy ale
nemají assertions ani vstupní soubory; hodnotit lze jen vágní
`expected_output`.

Doplnit konkrétní assertions pro autentizaci, idempotenci, dry-run/safety a
vlastnictví jednotlivých kroků. Pro rychle se měnící auth a command surface
zapisovat testovanou verzi/normativní zdroj. Přidat fixture skriptu a grader,
který kontroluje command/argument trace bez provádění změn v tenantovi.

#### `martix-sharepoint-server`

Tři konkrétní negative případy dobře oddělují SPFx a PnP. Pouze obecný
handoff ale obsahuje assertions; šest ostatních případů spoléhá jen na
`expected_output`.

Doplnit assertions pro WSP/Feature ownership, activation order, upgrade a
rollback, farm scope a Subscription Edition boundary. Použít malý fixture
manifestu nebo solution struktury a deterministicky kontrolovat packaging;
produkční deployment prompt má mít explicitní bezpečnostní a eskalační
očekávání.

#### `martix-sharepoint-spfx`

Prompty tematicky pokrývají téměř celou taxonomy, včetně tooling,
webparts/extensions, data klientů, hostů, UI, deploymentu a migrace. Šest
pozitivních případů však nemá assertions; formalizované jsou jen dva handoffy.

Doplnit assertions a fixtures pro `package-solution.json`, web part manifest a
toolchain. Compatibility eval má být verzovaný a ověřovat Node/React/TypeScript
matici proti aktuálnímu primárnímu zdroji. Samostatně otestovat Form Customizer
nebo library component a build/paketizaci jednoduchého projektu.

#### `martix-tunit`

Sada pokrývá všech sedm taxonomy domén a zachycuje nejrizikovější TUnit
chybu: neawaitované assertions. Handoffy a minimální rule-set routing jsou
dobře formulované, ale tvoří velkou část měřeného chování.

Doplnit reálný test projekt a ověřit `dotnet test` nebo odpovídající
Microsoft.Testing.Platform runner, včetně negativního testu na neawaitovaný
`Assert.That`. U TUnit.Mocks a C# 14/beta omezení verzovat zdrojovou pravdu a
přidat druhý concrete near-miss mimo TUnit.

### Společné systémové mezery

#### Evaly netvoří spustitelný regresní systém

Mimo interní `skill-creator` není v repozitáři runner, který by portfolio
evaly vykonal, odstupňoval a agregoval. CI spouští pouze strukturální
`validate-repository.ps1`. Nejsou uložené `grading.json`, `benchmark.json`,
`timing.json` ani ekvivalentní release summary.

#### Existují dva nekompatibilní JSON dialekty

Repo kontrakt používá top-level `skill`, string `id`,
`expected_output|expected_sections` a `assertions`. Lokální
[`skill-creator` schema](../.agents/skills/skill-creator/references/schemas.md)
popisuje `skill_name`, integer `id`, `expected_output` a `expectations`, zatímco
jeho workflow text na jiných místech znovu pracuje s `assertions`. Bez adaptéru
nelze portfolio soubory přímo použít v doporučeném benchmark workflow.

Nedoporučuje se okamžitá hromadná migrace. Nejprve je třeba zvolit kanonické
repo schéma, verzovat je a napsat malý adaptér pro runner/viewer.

#### Negativní pokrytí je částečně nadhodnocené

Šest Skills používá variantu obecného promptu „uživatel žádá pomoc, která
patří jinam; posuď scope“ a stejné assertions. Takový prompt agentovi předem
prozradí očekávaný handoff a není silným testem false-positive aktivace.
Počítá se jako smoke test instrukcí, ne jako kvalitní near-miss.

#### `files` nemá jednoznačnou sémantiku

V současných evalech `files` obvykle označuje interní Skill soubory, které má
agent konzultovat. V běžném eval workflow ale stejné pole označuje vstupní
artefakty uživatelského případu. Dvacet případů má pole prázdné a nikde
není dedikovaná fixture. Oddělit `context_files` od `input_files`.

#### Assertions nejsou typované podle původu a graderu

Jednoduchý string neříká, zda jde o upstream kontrakt, MartiX policy,
deterministický check nebo LLM rubriku. Doporučený budoucí tvar je alespoň:

```json
{
  "id": "uses-validate-async",
  "text": "Uses ValidateAsync when any rule is asynchronous.",
  "source": "upstream",
  "grader": "regex-or-ast",
  "severity": "must"
}
```

Pro zpětnou kompatibilitu může runner nadále přijímat string jako zkrácený
tvar.

### Prioritizovaný plán zlepšení

#### P0: Zprovoznit společný eval kontrakt

1. Přidat `schema_version` a JSON Schema pro repo dialekt.
2. Rozhodnout a zdokumentovat `context_files` versus `input_files`.
3. Přidat adaptér do `skill-creator` benchmark/viewer formátu.
4. Rozšířit validátor o unikátní ID a neprázdné assertions; výjimka musí
   být explicitní, například `qualitative_only: true` s rubrikou.
5. Oddělit capability evaly od trigger evalů.

#### P1: Zavřít největší obsahové mezery

1. Doplnit assertions do 20 případů v `martix-markdown` a SharePoint Skills.
2. Nahradit obecné scope prompty realistickými near-misses.
3. Přidat alespoň jeden edge/error nebo bezpečnostní scénář pro každý
   Skill.
4. Definovat význam `escalation` a použít jej u produkčních, destruktivních,
   právních nebo jinak vysoce rizikových případů.

#### P2: Přidat důkaz funkčnosti

1. Pro každý Skill vybrat tři reprezentativní capability evaly.
2. Spustit ve stejném turnu variantu se Skillem a baseline bez Skillu nebo se
   snapshotem předchozí verze.
3. Programovatelné výstupy ověřit buildem, testem, lintem, AST nebo JSON Schema;
   otevřené vlastnosti hodnotit kalibrovanou pass/fail rubrikou.
4. Každý nedeterministický případ spustit alespoň třikrát.
5. Vygenerovat benchmark a statický review viewer pro lidskou kontrolu.

#### P3: Zavést regresní provoz

1. Při PR spouštět rychlé deterministické checks a malý smoke subset.
2. Při release nebo změně modelu spouštět plnou sadu s baseline a reruns.
3. Ukládat kompaktní benchmark summary; objemné traces mohou být CI artefaktem.
4. Každou opravenou produkční chybu přidat jako regresní případ.
5. Nastavit gate podle confidence intervalu nebo opakovaně potvrzeného poklesu,
   ne podle jediného nedeterministického běhu.

## Dopad na současné repo konvence

Repo pravidla již stanovují účel, základní tvar a povinnost aktualizovat evaly
při změně routingu nebo očekávané kvality
([Custom AI artifact rules](./custom-ai-artifact-rules.md#evals)). Šablona navíc
obsahuje `assertions`, `token_budget`, `negative_activation` a `escalation`
([repo šablona evalů](../templates/skill-package/evals/evals.json)).

Současný [repo validátor](../scripts/validate-repository.ps1) kontroluje top-level
`skill`, přítomnost případů, `id`, `prompt`, očekávaný výstup, model tier,
`parallel_safe`, token budget, existenci souborů a alespoň varuje při absenci
negativní aktivace. Nekontroluje však:

- realistickou obtížnost a reprezentativnost promptů;
- kvalitu nebo povinnou přítomnost assertions;
- diskriminační sílu graderů;
- baseline, opakované běhy, pass rate nebo rozptyl;
- regresní historii a kalibraci s lidským hodnocením.

Otevřená [Agent Skills specification](https://agentskills.io/specification)
definuje `SKILL.md`, metadata a volitelné adresáře, nikoli interoperabilní eval
schéma. Současný JSON tvar je proto legitimní repo/harness konvence a není nutné
jej migrovat jen kvůli upstream kompatibilitě. Doporučené zlepšení je zpřísnit
jeho sémantický kontrakt a vytvořit runner/reporting vrstvu nad existující
strukturou.

Poznámka k nástrojům: konkrétní OpenAI Evals platforma je v procesu ukončení;
nový repo workflow proto nemá být svázán s jejím legacy API. Výše uvedené
principy návrhu, graderů a kontinuální evaluace jsou na konkrétním harnessu
nezávislé
([OpenAI: Working with evals](https://developers.openai.com/api/docs/guides/evals)).
