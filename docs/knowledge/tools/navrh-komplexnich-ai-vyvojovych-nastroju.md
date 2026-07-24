# Návrh komplexního AI vývojového prostředí

## Kontext, agenti, skills, hooks, model routing a optimalizace skutečných nákladů

**Stav dokumentace:** 17. července 2026  
**Hlavní platformy:** Visual Studio Code + GitHub Copilot, GitHub Copilot coding agent/cloud agent, ChatGPT Codex desktop/CLI/IDE/cloud, Claude Code  
**Cíl:** maximalizovat pravděpodobnost správného výsledku při minimálních celkových nákladech, nikoli pouze minimalizovat cenu jednoho tokenu

## Stručný verdikt

Nejlepší výchozí architektura pro dlouhodobý vývoj aplikací je:

```text
malé vždy načítané instrukční jádro
  + jeden obecný koordinátor
  + on-demand skills s progressive disclosure
  + malá sada skutečně odlišných subagentů
  + úzký allowlist nástrojů/MCP
  + deterministické hooks a CI kolem agentního loopu
  + model router založený na riziku a ověřitelnosti
  + evaly měřící cenu za přijatý výsledek
```

Nedoporučuji budovat katalog desítek „frontend“, „backend“, „database“, „test“ a dalších personifikovaných agentů, pokud se liší pouze textem system promptu. Většinu této specializace lépe vyjadřuje **skill**, protože se načte jen při použití a obecný agent si zachová kontext aktuální práce. Samostatný agent je oprávněný tehdy, když potřebujete alespoň jednu skutečnou hranici:

- izolované context window,
- jiný model nebo reasoning effort,
- jiná oprávnění a tools,
- paralelní práci,
- nezávislý názor bez kontaminace implementační historií,
- vlastní sandbox/worktree,
- trvalou paměť specifické role.

Největší nevyužitý potenciál mají **hooks**. Deterministický hook může bez LLM zkontrolovat shell command, odfiltrovat tisíce řádků logu, spustit formatter, vybrat relevantní testy, zablokovat secret, doplnit session context, uložit metriky nebo zabránit předčasnému ukončení. Claude Code, Copilot i Codex dnes mají lifecycle hooks; jejich přesné možnosti se liší, ale společný návrhový princip je stejný: **cokoliv lze levně a spolehlivě rozhodnout programem, nemá znovu rozhodovat model**. Oficiální dokumentace VS Code výslovně popisuje hooks jako deterministické akce nezávislé na rozhodnutí modelu a Codex je označuje jako skripty v agentním lifecycle. Viz [VS Code agent customization](https://code.visualstudio.com/docs/copilot/concepts/customization), [Codex hooks](https://learn.chatgpt.com/docs/hooks) a [Claude Code hooks](https://code.claude.com/docs/en/hooks).

## 1. Co skutečně optimalizovat

### 1.1 Cena tokenu není cena výsledku

Levnější model může být celkově dražší, pokud:

- načte více nerelevantních souborů,
- udělá více tool calls,
- potřebuje několik opravných kol,
- vytvoří chybný diff a spotřebuje lidské review,
- nedokáže problém uzavřít a práce se restartuje na silnějším modelu,
- zaplní context window neproduktivní historií,
- způsobí regresi, která se projeví později.

Pro každou kategorii práce proto sledujte očekávané celkové náklady:

```text
Expected total cost =
    LLM input + cached input + output + reasoning
  + tool/API/sandbox compute
  + náklady neúspěšných pokusů
  + lidský steering a review
  + rework a uniklé defekty
  + cena latence / čekání
```

Správná optimalizační jednotka není „token“, ale například:

- cena za přijatý ticket,
- cena za green PR po review,
- cena za odstraněný reprodukovaný defect,
- čas a cena k prvnímu ověřitelnému vertical slice,
- počet lidských minut na přijatou změnu,
- počet tokenů na **akceptovaný** diff, nikoli na libovolný diff.

### 1.2 Minimální metriky

| Metrika | Proč ji měřit |
|---|---|
| First-pass acceptance rate | Odhalí levný model, který vyrábí drahý rework |
| Retry/escalation rate | Ukáže, zda routing začíná příliš nízko |
| Input, cached input, output a reasoning tokens | Rozliší problém dlouhého kontextu od zbytečného výstupu |
| Tool calls a velikost jejich výsledků | Odhalí context pollution z MCP/logů |
| Wall-clock a active human time | Dlouhý autonomní běh nemusí být drahý, pokud neblokuje člověka |
| CI pass po prvním pushi | Praktický proxy signál implementační kvality |
| Review findings podle závažnosti | Zachytí chyby, které testy nevidí |
| Reopened ticket / escaped defect | Měří skutečný downstream náklad |
| Model, effort, skill, agent a route reason | Umožní pozdější optimalizaci routeru |

Bez těchto dat je „použijeme levnější model“ pouze dojem. A/B testujte na vlastním eval corpus, protože relativní výkon modelů se liší podle jazyka, codebase a kvality testů.

## 2. Referenční architektura

```text
Člověk / issue / spec
        │
        ▼
Deterministický intake
- klasifikace cesty/rizika z metadat
- načtení pouze relevantních pravidel
- secret/permission kontrola
        │
        ▼
Obecný koordinátor
- rozumí záměru
- vybere skill, tools a route
- nerozhoduje znovu to, co umí script
        │
        ├───────── jednoduchá práce ─────────► malý/rychlý model
        │
        ├───────── běžná implementace ──────► vyvážený coding model
        │
        └───────── vysoká nejistota/riziko ─► frontier reasoning model
                         │
                         ▼
              volitelný izolovaný subagent
                         │
                         ▼
Deterministický harness
- formatter/lint/typecheck/test
- policy a secret scan
- diff/stat/artefakty
- token/tool telemetry
        │
        ▼
Nezávislé review podle rizika
        │
        ▼
CI + chráněná branch + člověk
```

Tato architektura má pět vlastností:

1. **Progressive disclosure:** always-on context obsahuje jen pravidla potřebná téměř vždy; specializace se načítá ze skills.
2. **Deterministic outer loop:** model je uvnitř kontrolovaného harnessu, nikoli jediným nositelem procesu.
3. **Risk-based routing:** cena modelu roste s nejednoznačností, blast radiusem a náklady chyby.
4. **Independent verification:** agentovo tvrzení „hotovo“ není evidence; evidence jsou commands, testy, diff a review.
5. **Portable source of truth:** doména, rozhodnutí a zadání zůstávají v repozitáři/trackeru, ne pouze v session memory konkrétního výrobce.

## 3. Společná taxonomie napříč platformami

Výrobci používají částečně odlišná jména. Pro návrh je užitečné rozlišovat funkci, nikoli příponu souboru.

| Stavební prvek | Co má vlastnit | Co vlastnit nemá |
|---|---|---|
| `AGENTS.md` / `CLAUDE.md` / always-on instructions | Trvalá pravidla platná téměř při každé práci | Dlouhé postupy, referenční dokumentaci, historii projektu |
| `CONTEXT.md` / domain docs | Ubiquitous language, hranice domény, invariants | Příkazy pro agenta a dočasný stav ticketu |
| Path-specific instructions/rules | Pravidla platná jen pro část stromu nebo typ souboru | Globální pravidla duplikovaná ve všech adresářích |
| Prompt file | Parametrizovaný jednorázový úkol nebo vstup workflow | Trvalé policy a rozsáhlý znovupoužitelný proces |
| Skill | Opakovatelný postup, checklist, domain expertise, scripts/resources | Samostatnou identitu a izolované context window |
| Agent/subagent | Izolaci, model, tools, permissions, paralelní/nezávislou roli | Pouhou tematickou instrukci, kterou zvládne skill |
| Hook | Automatickou reakci na lifecycle event; ideálně deterministickou | Otevřené kreativní řešení celého engineering problému |
| Tool | Jednu dobře popsanou schopnost s úzkým vstupem/výstupem | Celý proces nebo skrytou agentní autonomii |
| MCP server | Skupinu externích tools/data za jasnou trust boundary | Bezhlavý katalog desítek nepoužívaných tool schemas |
| Plugin | Verzionovaný distribuční balík skills/agents/hooks/MCP | První experiment v jednom repozitáři |
| Memory | Malý soubor stabilních, ověřitelných poznatků | Kanonickou specifikaci nebo náhradu ADR/trackeru |
| CI/policy | Skutečné enforcement po agentovi | Promptové doporučení bez technického gate |

## 4. Detailní návrh jednotlivých stavebních prvků

### 4.1 `AGENTS.md`, `CLAUDE.md` a always-on instructions

Toto je nejdražší typ instrukce, protože se načítá automaticky a jeho tokeny se mohou opakovat v každém requestu. Codex přímo doporučuje `AGENTS.md` držet malý; Claude doporučuje přesunout specializované procedury do skills a mířit pod 200 řádků. VS Code kombinuje více always-on instruction files a negarantuje jejich pořadí, takže duplicita a konflikty jsou zvlášť nebezpečné. Viz [Codex customization](https://learn.chatgpt.com/docs/customization/overview), [Claude Code cost guidance](https://code.claude.com/docs/en/costs) a [VS Code custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions).

**Doporučený obsah:**

- přesné build/test/lint/typecheck commands;
- jak vybrat správný test scope;
- skutečně neobvyklé repo konvence;
- safety a approval hranice;
- definice „done“;
- odkazy na `CONTEXT.md`, ADR, standards a skills;
- stručný router: kdy použít spec, ticket, skill nebo eskalovat člověku.

**Nevhodný obsah:**

- kompletní style guide, který už vynucuje formatter/linter;
- workflow pro jednu specifickou migraci;
- API dokumentace frameworku;
- dlouhý katalog všech adresářů;
- celé ADR nebo doménový slovník;
- motivační text, personu a obecné rady typu „piš kvalitní kód“;
- pravidla, která si odporují s nested/path instructions.

**Doporučená intenzita konfigurace:** nízká až střední. Začněte 30–80 rozhodovacími řádky; růst nad přibližně 150–200 řádků považujte za signál k rozdělení do path rules nebo skills. Číselný rozsah je praktické doporučení, nikoli univerzální limit.

### 4.2 `CONTEXT.md` a doménová dokumentace

`CONTEXT.md` není další prompt policy. Je to přenositelná dlouhodobá znalost:

- kanonické názvy doménových pojmů;
- rozdíly mezi podobnými termíny;
- invariants a životní cykly entit;
- hranice bounded contexts/modulů;
- hlavní data flows;
- odkazy na ADR a contracts;
- seznam známých nejasností.

Agent jej nemá načítat celý při každém typo fixu. Root instructions mají obsahovat jen odkaz a routing pravidlo typu „při změně billing domény načti sekci Billing“. U velkého souboru rozdělte doménu do `docs/domain/<context>.md` a udržujte krátký index.

**Doporučená intenzita:** střední až vysoká kvalita, nízká always-on tokenová stopa. Doménová přesnost obvykle ušetří více reworku než agresivní zkracování, ale znalost musí být selektivně dohledatelná.

### 4.3 Instructions a rules

Path/file-specific instructions jsou vhodné pro pravidla, která by jinak zbytečně zatěžovala každý request:

- frontend conventions pouze pro `*.tsx`;
- databázová pravidla pouze pro migrations;
- security policy pro auth modul;
- testovací idiomy pro test projects;
- generated code „do not edit“;
- monorepo package-specific commands.

VS Code podporuje `.instructions.md` s `applyTo`, `AGENTS.md` a také kompatibilní `CLAUDE.md`/`.claude/rules`; současně upozorňuje, že při kombinaci více files není garantováno pořadí. Claude Code používá project rules a hierarchii memory files; Codex používá scoped `AGENTS.md`. Návrh proto musí být **monotonic**: lokální pravidlo má globální zpřesnit, nikoli jej tiše obrátit.

**Doporučená intenzita:** vysoká selektivita, malý počet souborů. Jeden rule file na skutečnou boundary, ne jeden na každý adresář.

### 4.4 Prompts a prompt files

Prompt file je vhodný pro explicitně vyvolaný, parametrizovaný úkol:

- vytvoření release notes;
- rozpad schválené spec;
- kontrola konkrétního diffu;
- scaffolding komponenty;
- incident summary;
- generování changelogu.

Prompt má definovat outcome, vstupy, hranice, validační důkaz a stop conditions. Nemá opakovat always-on instructions. VS Code popisuje prompt files jako repeatable task spouštěný na vyžádání, zatímco agent skills jsou vhodnější pro vícekrokové workflow se scripts a resources. Viz [VS Code customization matrix](https://code.visualstudio.com/docs/copilot/concepts/customization).

**Doporučená struktura:**

```text
Goal
Inputs and authoritative sources
Constraints / out of scope
Required tools or skill
Validation evidence
Structured output contract
Stop / escalation conditions
```

**Doporučená intenzita:** nízká. Pokud se prompt rozrůstá o větvení, scripts, reference a opakované kroky, převeďte jej na skill.

### 4.5 Skills

Skill je výchozí mechanismus specializace. Plný obsah se načítá on-demand; na startu obvykle stačí jméno a popis. Claude Code výslovně uvádí, že skill body se načte až při použití, a VS Code/Copilot i Codex podporují Agent Skills formát. Viz [Claude Code skills](https://code.claude.com/docs/en/skills), [VS Code Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills) a [Codex build skills](https://learn.chatgpt.com/docs/build-skills).

Skill vytvořte, když:

- stejný postup opakovaně vkládáte do chatu;
- proces má checklist nebo několik fází;
- je potřeba domain-specific reference;
- chcete přibalit scripts/templates/examples;
- obecný agent má umět proceduru automaticky objevit;
- proces nepotřebuje vlastní izolovaný context a permission boundary.

Skill nevytvářejte pro jednu větu pravidla ani pro proceduru, kterou lépe a spolehlivěji provede script. Popis skillu musí přesně říkat **kdy se použije**, protože popisy jsou routing index a mohou být součástí základního kontextu.

**Doporučená intenzita:** střední až vysoká. Je lepší mít 10–30 dobře vymezených skills než stejný počet agents; velké katalogy rozdělte podle projektu a nepotřebné skills skryjte před automatickou invokací.

### 4.6 Agents a subagents

Samostatný agent mění „kdo, s čím a v jakém kontextu pracuje“. VS Code custom agents definují instrukce, tools, model a handoffs; Claude subagent má fresh isolated context, může mít model, effort, permissions, skills, MCP, memory a worktree isolation; Codex subagents slouží k delegaci specializované práce. Viz [VS Code custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents), [Claude Code subagents](https://code.claude.com/docs/en/sub-agents) a [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents).

Vytvořte subagenta, pokud potřebujete:

- read-only explorer s levným modelem;
- nezávislého reviewer bez implementačního anchoringu;
- security reviewer s omezenými tools;
- paralelní research hypothesis;
- worktree-isolated implementer;
- jiný context/memory scope;
- odlišný model a effort pro jasně měřitelnou podúlohu.

Nevytvářejte agenta jen proto, že má „být expert na React“. Pokud používá stejné tools, permissions, model i context a pouze dostane React postup, je to skill.

**Doporučená intenzita:** malá stabilní sada. Pro většinu týmů stačí:

1. obecný coordinator/implementer;
2. levný read-only explorer nebo log triager;
3. nezávislý reviewer;
4. volitelný security/architecture reviewer aktivovaný rizikem.

Další role přidávejte až po datech, že oddělení zlepšuje acceptance rate nebo náklady.

### 4.7 Hooks

Hook je lifecycle automation mimo hlavní reasoning loop. Je ideální pro věci, které mají jasný trigger a programovatelný výsledek.

Použití se dělí do tří tříd:

1. **Deterministický command hook:** preferovaná volba; nulová nebo minimální LLM spotřeba.
2. **Prompt/classifier hook:** malý model rozhodne jednoduchou semantickou otázku, kterou nelze snadno zakódovat.
3. **Agent hook:** izolovaný agent provede hlubší verifikaci; nejdražší a má se používat vzácně.

Claude Code podporuje command, prompt, agent, HTTP a MCP-tool handlers; jeho dokumentace označuje agent hooks jako experimentální a pro produkci doporučuje command hooks. Codex k datu analýzy vykonává pouze `type: command`; `prompt` a `agent` sice parsuje, ale přeskočí. VS Code používá kompatibilní hook format a GitHub Copilot CLI/cloud agent mají vlastní oficiální hook lifecycle. Viz [Claude hooks guide](https://code.claude.com/docs/en/hooks-guide), [Codex hooks](https://learn.chatgpt.com/docs/hooks), [VS Code hooks](https://code.visualstudio.com/docs/agent-customization/hooks) a [GitHub Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference).

**Doporučená intenzita:** vysoká, ale s malým počtem jednoduchých, rychlých a idempotentních hooks. Detailní návrh je v samostatné kapitole 6.

### 4.8 Tools a MCP

Tool má modelu nabídnout úzkou akci s dobře popsaným vstupem a malým strukturovaným výstupem. Každý další tool zvětšuje routing decision space a jeho výstup spotřebovává context. VS Code to uvádí explicitně a doporučuje dostupnou sadu nástrojů omezit. Claude doporučuje vypnout nepoužívané MCP servers a u běžných CLI preferovat `gh`, `aws`, `gcloud` či jiné CLI, protože tool definitions přidávají režii. Viz [VS Code tools](https://code.visualstudio.com/docs/copilot/concepts/tools) a [Claude cost management](https://code.claude.com/docs/en/costs).

MCP použijte, pokud:

- potřebujete externí systém nebo data;
- autentizace a schema benefitují ze standardního serveru;
- tool má stabilní, úzký kontrakt;
- potřebujete portable integration více agentů.

Preferujte lokální CLI/script, pokud:

- příkaz už existuje a výstup lze filtrovat;
- nechcete načítat rozsáhlý tool catalog;
- operace je repo-local;
- stačí deterministic wrapper.

**Doporučená intenzita:** minimální allowlist podle role. Explorer nepotřebuje deployment tools; reviewer nepotřebuje write access; implementer nepotřebuje všechny organizační connectors.

### 4.9 Plugins a extensions

Plugin je distribuční jednotka, nikoli základní abstrakce problému. Balí skills, agents, hooks, MCP a případně scripts. Claude doporučuje začít standalone konfigurací a plugin vytvořit až při sdílení napříč projekty; stejný princip platí pro Codex a VS Code agent plugins. Viz [Claude Code plugins](https://code.claude.com/docs/en/plugins) a [VS Code agent customization](https://code.visualstudio.com/docs/copilot/concepts/customization).

Plugin má smysl, pokud:

- stejnou ověřenou capability používá více repozitářů;
- potřebujete verzování, upgrade a provenance;
- komponenty mají společný lifecycle;
- umíte testovat instalaci i odinstalaci;
- máte vlastníka supply-chain a security review.

**Doporučená intenzita:** nízká na začátku, střední po stabilizaci. Nevytvářejte plugin pro každý skill.

### 4.10 Memory, auto-memory a session history

Memory je cache užitečných poznatků, nikoli source of truth. Může pomoci s osobní preferencí, často používaným commandem nebo stabilní vlastností prostředí, ale může zastarat, být vendor-specific a skrývat kontext před týmem.

Do memory patří:

- osobní workflow preference;
- ověřená lokální odlišnost prostředí;
- krátká navigační pomůcka;
- poznatek s jasným provenance a možností invalidace.

Do memory nepatří:

- produktové požadavky;
- bezpečnostní policy;
- schválené architektonické rozhodnutí;
- stav ticketu;
- jediná kopie znalosti potřebné pro handoff.

Tyto informace patří do spec, ADR, trackeru nebo repozitářové dokumentace. Session resume používejte pro kontinuitu stejné práce, ne jako dlouhodobou projektovou databázi.

### 4.11 Task artifacts, issue tracker a specifications

Agentní konfigurace nemá vlastnit pracovní backlog. Specifikace a issues mají být přenositelné a odkazované z promptu. Jeden ticket by měl obsahovat outcome, acceptance criteria, blockers, autoritativní zdroj a validační commands. Dlouhé agentní sessions nahraďte vertical slices, které se vejdou do fresh context window.

### 4.12 Permissions, sandbox a approvals

Autonomie je samostatná osa od inteligence. Silný model s read-only tools může být bezpečnější než levný model s plným host access. Konfigurujte:

- read-only plan/explore režim;
- write scope jen na workspace/worktree;
- síť podle allowlistu;
- short-lived scoped credentials;
- approvals pro citlivé shell/network/write operace;
- oddělenou identitu pro automatizaci;
- PR-only merge u AFK práce.

Prompt není security boundary. Policy má být v sandboxu, permission systému, hooks a CI.

### 4.13 System/developer instructions a konfigurační hierarchie

„Instructions“ nejsou jeden soubor, ale několik vrstev s různou autoritou a cenou: vestavěné system/developer instrukce produktu, organizační managed policy, uživatelský profil, repo instructions a path-specific pravidla. Přesné pořadí se liší podle runtime; VS Code navíc upozorňuje, že pořadí kombinovaných custom instruction files není garantováno.

Praktická pravidla:

- organizační vrstva: compliance, data boundaries a povinné approvals;
- host/user profil: osobní preference a stabilní lokální prostředí;
- repo vrstva: týmový contract, commands a definition of done;
- path vrstva: pouze lokální zpřesnění;
- skill: postup aktivovaný konkrétním typem práce;
- task prompt: pouze outcome a kontext aktuálního ticketu.

Codex umožňuje i `developer_instructions` v `config.toml` a pokročilou náhradu model instructions. Používejte je minimálně: skryté druhé repo-policy zhoršuje přenositelnost a debugging. Povinné týmové pravidlo má být viditelné v repozitáři a skutečný zákaz ve strojové policy. Náhrada built-in instructions vytváří vlastní regresní a upgrade závazek. Viz [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference).

## 5. Platformní mapování a přenositelné jádro

### 5.1 Co je společné a co je adaptér výrobce

Nejlepší dlouhodobý návrh nesmí být závislý na jedné UI aplikaci ani na aktuálním názvu modelu. Rozdělte konfiguraci na dvě vrstvy:

1. **Přenositelné projektové jádro:** doména, ADR, acceptance criteria, commands, standardy, skills, skripty, eval cases a definice výstupních artefaktů.
2. **Tenké adaptéry platformy:** cesty k instruction files, formát agents, hook event names, permissions, model aliases a registrace tools/MCP.

| Schopnost | VS Code / Copilot | Copilot coding agent | Codex | Claude Code | Doporučený source of truth |
|---|---|---|---|---|---|
| Globální repo instrukce | `.github/copilot-instructions.md`, `AGENTS.md` | Copilot instructions, `AGENTS.md` | `AGENTS.md` | `CLAUDE.md`, případně `AGENTS.md` přes adapter/import | Krátký root `AGENTS.md` + vendor shim |
| Path rules | `.github/instructions/*.instructions.md` s `applyTo`; nested `AGENTS.md` | Podpora se liší podle prostředí | Scoped/nested `AGENTS.md` | `.claude/rules`, nested `CLAUDE.md` | Jednotlivé malé rule files |
| Prompt templates | `.github/prompts/*.prompt.md` | Issue/prompt workflow | Reusable prompts/workflows podle surface | Commands/skills | Skills pro proces; prompt jen pro lehký vstup |
| Skills | Agent Skills | Skills podle runtime | Skills | Skills | Portable Agent Skills, vendor extensions jen když nutné |
| Custom agents | `.github/agents/*.agent.md` | Custom agents s omezením cloud fields | Subagents | `.claude/agents/*.md` | Role contract v docs + tenké manifests |
| Hooks | `.github/hooks/*.json` / agent-scoped hooks | CLI/cloud lifecycle hooks | `.codex/hooks.json` nebo `config.toml` | settings/plugin/skill/subagent hooks | Sdílené scripts v `scripts/ai/hooks`, malé manifests |
| Tools / MCP | Built-in, extension tools, MCP | Cloud-available tools/MCP | Built-ins, MCP | Built-ins, MCP | Úzké tool contracts; platformní registrace |
| Plugin | VS Code agent plugin/extension | Podle prostředí | Codex plugin | Claude plugin | Až distribuční vrstva nad stabilními komponentami |
| Memory | Chat/session context a platform features | Issue/PR context | Memories/session | Auto memory + files | Repo docs/tracker; vendor memory jen cache |

Tabulka neznamená stoprocentní funkční paritu. Například GitHub upozorňuje, že pole custom agents se mezi IDE a cloud agentem liší; VS Code nested `AGENTS.md` označuje jako experimentální; Codex k datu analýzy nevykonává všechny syntakticky rozpoznané typy hook handlers. Proto vždy testujte capability v konkrétním runtime, nikoli jen validitu konfiguračního souboru. Viz [GitHub custom agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration), [VS Code custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions) a [Codex hooks](https://learn.chatgpt.com/docs/hooks).

`CONTEXT.md` není podle dokumentovaného discovery modelu first-class automaticky načítané primitivum ani v Codexu, ani v Copilotu. Je to konvence projektové dokumentace, které agent porozumí teprve přes explicitní odkaz nebo retrieval. Tak je to ve skutečnosti výhoda: soubor může být autoritativní, aniž by se automaticky platil v každém requestu. U Codex CLI také neplánujte nové workflow kolem historického adresáře custom prompts; tato funkce byla po deprecaci odstraněna ve verzi 0.117 a OpenAI doporučuje převod na skills. Viz [OpenAI Codex issue k odstranění custom prompts](https://github.com/openai/codex/issues/15941).

### 5.2 Nejméně společný jmenovatel není cílem

Přenositelnost neznamená rezignovat na výhody platformy. Použijte model „portable core, native acceleration“:

- společný skill může obsahovat portable Markdown postup a scripts;
- Claude adaptér přidá přesný `PreToolUse` matcher;
- Codex adaptér přidá odpovídající command hook;
- Copilot adaptér nastaví `applyTo`, tools a cloud-safe fields;
- všechny varianty volají tentýž verzovaný script a produkují tentýž JSON výsledek.

Tím se business policy neduplikuje ve třech promptech. Liší se jen propojení lifecycle eventu s jedním testovatelným programem.

### 5.3 Local, background a cloud nejsou tentýž runtime

U každého produktu oddělte minimálně tři provozní režimy:

| Režim | Výhoda | Typická omezení a rizika | Vhodná práce |
|---|---|---|---|
| Local interactive | okamžitý steering, lokální tools a caches | přístup k hostu, závislost na lokálním stavu | diagnosis, iterativní implementace |
| Local background/worktree | paralelismus bez blokování editace | násobení tokenů, konflikty a lokální resource use | izolovaný ticket s jasnou spec |
| Cloud/background agent | reprodukovatelné ephemeral prostředí, AFK workflow | jiný subset fields/hooks/tools, síť a secrets, setup latency | issue → PR, dávkové a dlouhé práce |

Copilot app/cloud agent používá GitHub-hosted prostředí a jeho setup, firewall, secrets a MCP behavior nelze odvozovat z lokálního VS Code. Codex Local/Worktree sdílí lokální host konfiguraci, zatímco cloud task běží v izolovaném prostředí a nemá automaticky stejnou jemnost lokálního model/tool řízení. Claude Code local, web/cloud a Agent SDK jsou opět různé surfaces. Konfiguraci proto testujte maticí **capability × runtime**, ne pouze „funguje v produktu“.

Reprodukovatelný cloud setup je zároveň ekonomická optimalizace. Když toolchain a dependencies připraví deterministický setup, model nespaluje calls diagnostikou chybějícího runtime. U Copilot cloud agenta patří příprava do `copilot-setup-steps.yml`; setup a agent phase mají odlišné síťové a secret hranice. Viz [GitHub cloud agent environment](https://docs.github.com/en/enterprise-cloud@latest/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment) a [Codex environment modes](https://learn.chatgpt.com/docs/environments/modes).

## 6. Hooks jako deterministický řídicí systém

### 6.1 Proč mají mimořádnou návratnost

Hook je nejlevnější tehdy, když nahradí opakované uvažování modelem. Typický anti-pattern je instrukce: „Před každým commitem zkontroluj secrets, spusť formatter, zjisti dotčené projekty, spusť odpovídající testy a shrň chyby.“ Agent ji musí znovu číst, rozhodnout, vykonat několik calls a zpracovat jejich plný výstup. Hook může stejný proces spustit pokaždé, vrátit pouze status a několik relevantních řádků a při porušení práci zablokovat.

Claude uvádí příklad preprocessingu desetitisícového logu na několik stovek tokenů. VS Code charakterizuje hooks jako deterministické lifecycle actions. GitHub dokumentuje možnost schvalovat či zamítat tool use a auditovat činnost. Codex hook dostává strukturovaný JSON na stdin včetně eventu, modelu a permission mode. To z hooks dělá nejen automatizaci kvality, ale i **tokenový firewall** mezi hlučnými lokálními nástroji a context window. Viz [Claude Code cost management](https://code.claude.com/docs/en/costs), [VS Code hooks](https://code.visualstudio.com/docs/agent-customization/hooks), [GitHub Copilot hooks concept](https://docs.github.com/en/copilot/concepts/agents/hooks) a [Codex hooks](https://learn.chatgpt.com/docs/hooks).

### 6.2 Který lifecycle event použít

Názvy nejsou dokonale jednotné, ale funkční mapa je následující:

| Fáze | Vhodná automatizace bez LLM | Co vrátit agentovi |
|---|---|---|
| Session start | zjistit branch/worktree, tool versions, dirty state, dostupné runtimes, relevantní projekt | Krátký JSON snapshot nebo upozornění pouze při problému |
| Instructions/config loaded | validovat duplicity, neplatné odkazy a příliš velké always-on files | Jen chyby a rozpočty, ne celý obsah |
| User prompt submit | připojit ID ticketu z branch, klasifikovat dotčenou oblast z explicitních metadat | Pár stabilních facts; ne další generický prompt |
| Before tool use | zakázat nebezpečný command, omezit path/network, normalizovat argumenty | allow/deny + stručný důvod |
| Permission request | automaticky povolit bezpečný allowlist; rizikové předat člověku | Rozhodnutí a audit reason code |
| After tool use | secret scan změněných files, formatter, validace tool output schema | Status + actionable findings |
| After tool batch | agregovat změněné projekty a spustit jednou incremental checks | Souhrn, ne opakované výpisy |
| Before/after compact | uložit machine-readable stav, test evidence, otevřené otázky a invariants | Malý resume packet |
| Subagent start/stop | přidělit worktree/budget, zvalidovat handoff contract, uklidit resources | Artefakt path, findings, evidence |
| Stop/task complete | ověřit acceptance checks, dirty state, tests a diff; zabránit falešnému „hotovo“ | Pass nebo přesný seznam chybějících důkazů |
| Config change | zablokovat neautorizované změny hooks/MCP/permissions | Diff + policy decision |

Ne každá platforma nabízí každý event. Navrhujte script podle vstupního JSON kontraktu a event adapter udržujte tenký.

### 6.3 Pět vrstev hooks

#### A. Kritická policy a bezpečnost

Synchronní, rychlé a blokující:

- zákaz čtení credential stores a citlivých cest;
- zákaz destruktivních shell commands mimo schválený scope;
- kontrola síťových destinací;
- secret scan argumentů i vzniklého diffu;
- ochrana files s agentní konfigurací;
- vynucení worktree/workspace hranice.

Tyto hooks musí selhat bezpečně. Pokud policy engine není dostupný, citlivou akci nepovolí. Výjimky mají být explicitní, časově omezené a auditované.

#### B. Kvalita změny

Deterministická a většinou neblokující během iterace, blokující při stop/commit:

- formatter pouze pro změněné files;
- lint/typecheck dotčeného projektu;
- výběr testů podle dependency graph;
- validace migrations, schemas a generated artifacts;
- kontrola, že změna veřejného contractu má test nebo dokumentaci;
- kontrola velikosti a neočekávaných binary files.

Plný test suite nespouštějte po každém write. Použijte stupňování: rychlá kontrola po batchi, cílené testy před ukončením, kompletní suite v CI.

#### C. Redukce kontextu

Zde bývá největší čistá tokenová úspora:

- odfiltrovat opakované stack traces;
- seskupit stejné chyby a zachovat první reprezentativní příklad;
- z test outputu vrátit failing names, assertion a několik řádků okolí;
- z build logu vrátit první root-cause error místo navazujících chyb;
- z rozsáhlého JSON vrátit schema-valid relevant fields;
- z git diffu připravit stats, renamed files a citlivé oblasti.

Původní artefakt ponechte na disku a vraťte jeho path/hash. Agent si jej může explicitně otevřít, když komprimovaný výsledek nestačí.

#### D. Telemetrie a audit

Asynchronní, pokud runtime asynchronní handlers skutečně podporuje; jinak extrémně rychlé:

- route reason, model/effort, skills, agents a tools;
- tokeny, cache hit, latency, retries;
- hash prompt/config verze;
- test outcomes a acceptance;
- approval a policy decisions;
- correlation ID mezi agent run, PR a CI.

Citlivý prompt ani source code neposílejte do telemetry implicitně. Preferujte metadata, hashe a lokální agregace.

#### E. Semantické prompt/agent hooks

Použijte až tehdy, když otázku nelze spolehlivě vyřešit skriptem: například „mění tento diff autentizační trust boundary?“ Malý classifier model může rozhodnout, zda aktivovat security review. Hluboký agent hook má smysl jen u vysokého rizika. Claude podporuje prompt hook s levnějším modelem a experimentální agent hook; Codex k datu analýzy vykonává pouze command hooks, takže portable základ musí být command-first. Viz [Claude hooks guide](https://code.claude.com/docs/en/hooks-guide) a [Codex hooks](https://learn.chatgpt.com/docs/hooks).

### 6.4 Doporučený minimální hook bundle

Začněte šesti hooks, ne desítkami:

1. `session-snapshot`: branch, dirty state, runtimes, relevantní project map.
2. `guard-tool-use`: path/network/command policy a secrets v argumentech.
3. `summarize-tool-output`: redukce build/test/log outputu.
4. `check-changed`: formatter + nejrychlejší relevantní statické kontroly.
5. `verify-stop`: acceptance manifest, cílené testy, neočekávané changes.
6. `record-run`: strukturovaná lokální telemetrie bez obsahu promptu.

Každý hook má mít:

- JSON schema vstupu a výstupu;
- hard timeout výrazně kratší než platformní default;
- idempotenci;
- fixture tests pro allow, deny, timeout a malformed input;
- přesné reason codes;
- omezený stdout; diagnostika patří na stderr/log;
- známého vlastníka a verzi;
- dokumentované chování při chybě.

### 6.5 Portable implementační vzor

```text
platform event
  -> tenký manifest/matcher
  -> scripts/ai/hooks/<capability>
  -> JSON policy/result
  -> malý platform adapter
  -> allow | block | concise context
```

Příklad logického výsledku, nikoli závazný vendor formát:

```json
{
  "decision": "block",
  "reasonCode": "OUTSIDE_WORKTREE_WRITE",
  "message": "Zápis míří mimo schválený worktree.",
  "evidence": { "resolvedPath": "…" }
}
```

Program musí pracovat s parsovanými argumenty, ne slepě interpolovat text z promptu do shellu. U Windows i Unix prostředí používejte argument arrays a kanonizaci cest; nikdy nepředpokládejte, že text commandu je bezpečný.

### 6.6 Hook anti-patterns

- **Obří stdout:** hook ušetří nula tokenů, pokud vrátí celý log.
- **Full suite po každém edit:** zvyšuje latenci a vede uživatele k vypnutí celé vrstvy.
- **Skrytá mutace:** `PostToolUse` hook mění kód bez evidence a agent o tom neví.
- **LLM pro regexovou policy:** dražší, pomalejší a méně deterministické.
- **Dvě pravdy:** hook vynucuje jinou policy než CI.
- **Fail-open u security:** chyba scanneru je interpretována jako úspěch.
- **Nekonečný stop loop:** hook opakovaně blokuje ukončení bez stabilního reason code a možnosti opravy.
- **Globální hook bez matcheru:** spouští se na každý tool a násobí režii.
- **Důvěra bez provenance:** projektový hook je executable supply chain. Codex proto vyžaduje trust projektu a u unmanaged command hooků pracuje s hashem; Claude i GitHub doporučují hook konfiguraci auditovat. Viz [Codex hooks](https://learn.chatgpt.com/docs/hooks) a [Claude Code hooks](https://code.claude.com/docs/en/hooks).

U Codexu počítejte se čtyřmi konkrétními omezeními: command hook je dnes jediný vykonávaný handler, `async` je rozpoznán, ale přeskočen, výchozí timeout bez explicitní hodnoty je velmi dlouhý a `PreToolUse` nepokrývá každou možnou shell/web cestu. `PostToolUse` navíc nemůže vrátit již provedený side effect. Blokující `Stop` vyvolá další modelovou iteraci, takže musí mít loop counter a tvrdý strop. To jsou důvody pro sandbox a CI vedle hooks, ne proti nim. Viz [Codex hooks reference](https://learn.chatgpt.com/docs/hooks).

## 7. Směrování modelů podle celkové ekonomiky

### 7.1 Čtyři úrovně, ne hardcoded seznam modelů

Konkrétní modely, ceny a dostupnost se rychle mění. Vytvořte interní aliases a mapujte je v jednom verzovaném souboru:

| Interní tier | Typická práce | Požadované vlastnosti |
|---|---|---|
| `deterministic` | formatter, grep, dependency graph, policy, log reduction | Bez LLM; testovatelný program |
| `fast` | klasifikace, vyhledání, shrnutí malého vstupu, jednoduchá transformace | Nejnižší latency/cena, omezený output |
| `balanced-code` | běžný bugfix, testy, lokální refactor, dokumentace | Silné tool use a coding, dobrý poměr cena/výkon |
| `frontier-reasoning` | nejasná architektura, rozsáhlá migrace, těžký diagnosis, bezpečnostní návrh | Nejvyšší spolehlivost a dlouhý reasoning/context |

Claude oficiálně doporučuje Sonnet pro většinu coding úloh, Opus rezervovat pro složitou architekturu/multi-step reasoning a Haiku pro jednoduché subagents; konkrétní názvy se však mají chápat jako aktuální příklady tiers. OpenAI model catalog obdobně rozlišuje frontier, mini a nano varianty a podporovaný reasoning effort. Aktuální mapování vždy ověřte v [OpenAI model catalog](https://developers.openai.com/api/docs/models), [Claude Code model configuration](https://code.claude.com/docs/en/model-config) a administraci GitHub Copilot.

### 7.2 Routing score

Router může nejdříve použít metadata a jednoduchá pravidla. Doporučené dimenze se skóre 0–3:

- **ambiguity:** jsou acceptance criteria jasná?
- **blast radius:** kolik modulů, dat a uživatelů může změna ovlivnit?
- **novelty:** existuje v repo podobný vzor?
- **verification strength:** máme rychlé deterministické testy?
- **context breadth:** je potřeba syntetizovat mnoho modulů/dokumentů?
- **tool depth:** kolik závislých kroků a externích systémů je potřeba?
- **security/compliance:** dotýká se auth, secrets, financí, osobních dat, migrací?
- **reversibility:** lze změnu bezpečně vrátit?

Praktický router:

```text
pokud lze úlohu vyřešit spolehlivě programem -> deterministic
jinak pokud je scope malý, vzor jasný a verifikace silná -> fast nebo balanced-code
jinak pokud je běžná implementace s lokálním dopadem -> balanced-code
jinak -> frontier-reasoning

bez ohledu na executor:
pokud je dopad vysoký -> nezávislé review, případně silnější reviewer
```

### 7.3 Kdy rovnou použít dražší model

Silnější model je ekonomičtější od začátku, když:

- chybná první hypotéza spustí mnoho drahých tool calls;
- je problém nejednoznačný a nelze jej rychle reprodukovat;
- změna sahá přes více bounded contexts;
- test oracle je slabý nebo chybí;
- jde o veřejný API contract, data migration nebo security boundary;
- levnější model v podobných evals často eskaluje;
- lidské review je dominantní náklad;
- delší reasoning zabrání rozsáhlému reworku.

Nejhorší routing není „občas jsme použili drahý model“. Je to opakovaný řetězec tří levných neúspěchů, naplněný kontext a teprve potom drahý model, který musí rekonstruovat problém.

### 7.4 Eskalační kontrakt

Levný model nesmí nekonečně pokračovat. Eskaluje po jednom až dvou měřitelných signálech:

- stejný test selhal dvakrát bez nové evidence;
- agent změnil hypotézu bez vysvětlení důkazu;
- scope se rozšířil nad původní moduly;
- context překročil rozpočet;
- narazil na neznámý contract nebo konflikt instrukcí;
- potřebuje permission mimo svůj profil;
- diff překročil risk threshold;
- output verifieru nemá očekávané schema.

Handoff má obsahovat pouze: cíl, ověřená fakta, provedené pokusy, artefakty, současnou hypotézu, otevřené otázky a poslední test evidence. Nepředávejte novýmu modelu slepě celý chat.

### 7.5 Reasoning effort je samostatný knob

Nepřepínejte vždy celý model. U modelů s effort úrovněmi nastavte:

- low pro navigaci, boilerplate a jasné transformace;
- medium pro běžnou implementaci;
- high pro diagnosis, návrh rozhraní a review rizikového diffu;
- max pouze tam, kde evaly dokazují přínos.

Claude upozorňuje, že vyšší effort má diminishing returns a může vést k overthinking; obdobně je potřeba effort ladit empiricky. Viz [Claude model configuration](https://code.claude.com/docs/en/model-config).

### 7.6 Dvoustupňový a třístupňový vzor

Pro větší úlohy funguje:

1. `fast` read-only triage: najde vstupy, relevantní files a existující vzory;
2. `balanced-code` nebo `frontier-reasoning` executor: pracuje s filtrovaným balíčkem;
3. nezávislý reviewer: podle rizika stejný nebo silnější tier, ale s čistým kontextem.

Triage má cenu jen tehdy, když skutečně zmenší vstup. Pokud vyrobí dlouhý prose summary a executor stejně načte vše znovu, přidává náklad bez užitku.

### 7.7 Aktuální cenové mechanismy versus dlouhodobý návrh

API token prices, subscription credits a „premium request“ multipliers nejsou jedna měna. Codex v ChatGPT plánu nelze korektně převést na OpenAI API ceník; Copilot AI credits zahrnují vlastní modelové sazby a produktové slevy. K datu analýzy GitHub uvádí pro Auto model selection desetiprocentní slevu a routování podle složitosti i dostupnosti. Auto je rozumný provozní baseline, ale pro evals a kritické workflow model pinujte, jinak současně měníte routing policy i řešitele. Viz [GitHub Copilot auto model selection](https://docs.github.com/en/enterprise-cloud@latest/copilot/concepts/models/auto-model-selection) a [GitHub models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing).

Měsíční ekonomické review má proto aktualizovat pouze `routing.yml`: skutečné dostupné modely, cenu input/cached/output/reasoning, credit multiplier, latency a eval success. Skills a prompty mají používat stabilní aliases, nikoli názvy modelů nebo ceny.

## 8. Jeden obecný agent, nebo mnoho specialistů?

### 8.1 Doporučená odpověď

Výchozí volba je **jeden obecný coordinator s on-demand skills**, doplněný malým počtem subagentů definovaných skutečnou provozní hranicí. Důvod není estetický, ale ekonomický:

- méně agent descriptions a routing možností v kontextu;
- skills zachovají kontinuitu aktuálního problému;
- jedna sada tools a oprávnění se snáze audituje;
- nedochází k předávání kontextu při každé technologické hranici;
- specializované znalosti lze verzovat a testovat nezávisle.

### 8.2 Rozhodovací tabulka

| Potřeba | Nejlepší prvek |
|---|---|
| Jedna trvalá věta platná vždy | Root instruction |
| Pravidlo pro `*.sql` nebo konkrétní modul | Path rule |
| Opakovatelný znalostní postup | Skill |
| Jednoduchá deterministická akce | Script/tool |
| Automatické spuštění při lifecycle eventu | Hook |
| Jednorázový parametrizovaný workflow entry point | Prompt file |
| Čistý kontext a nezávislý úsudek | Subagent |
| Jiný model/effort/permissions/worktree | Subagent |
| Externí systém se strukturovaným API | MCP/tool |
| Sdílení ověřeného balíku mezi repozitáři | Plugin |

### 8.3 Agent musí mít kontrakt, ne personu

Každý stabilní subagent by měl definovat:

- outcome a explicitní non-goals;
- povolené a zakázané tools;
- read/write/network/permission profil;
- model alias a effort;
- vstupní a výstupní schema;
- maximální budget času/tool calls/tokens;
- stop a escalation conditions;
- validační evidence;
- zda pracuje v samostatném worktree;
- zda a jak smí používat memory.

„Jsi zkušený senior frontend engineer“ je slabý kontrakt. „Read-only, prozkoumej pouze `src/ui`, vrať seznam relevantních files s důkazy a neřeš implementaci; model fast; nejvýše 12 tool calls“ je užitečný kontrakt.

### 8.4 Doporučené stabilní role

- **Coordinator/implementer:** drží intent a integruje výsledek.
- **Explorer/triager:** read-only, levný model, omezený počet calls, strukturované findings.
- **Reviewer:** čistý kontext, vidí spec, diff a test evidence, nemění kód bez explicitního handoffu.
- **Risk reviewer:** security/architecture/data migration; aktivuje router pouze nad prahem.

Technologické specialization typu React, .NET, Kubernetes nebo databáze realizujte primárně skills. Role přidávejte pouze tehdy, když evaly ukážou, že izolace nebo jiné oprávnění přináší měřitelný efekt.

### 8.5 Paralelismus s rozpočtem

Více agentů může zkrátit wall-clock, ale často násobí input context, duplicitní čtení a integrační práci. Paralelizujte jen nezávislé podúlohy s jasně rozděleným ownershipem:

- různé hypotézy diagnosis;
- nezávislé primary-source research;
- oddělené worktrees bez překryvu files;
- implementace versus read-only review.

Neparalelizujte tři agenty, kteří mají všichni „prozkoumat repo a navrhnout řešení“. Pokud potřebujete diversity, dejte každému jinou hypotézu, hranici nebo hodnoticí osu a vyžádejte stejné výstupní schema.

## 9. Context a token engineering

### 9.1 Rozpočet vrstev

Praktický context budget není pevný počet tokenů, ale podíl relevantního obsahu:

| Vrstva | Loading | Cíl |
|---|---|---|
| Root instructions | Vždy | Co nejkratší; rozhodovací pravidla a odkazy |
| Tool/skill/agent index | Vždy nebo discovery | Krátké názvy a přesné trigger descriptions |
| Path rules | Při dotčené cestě | Jen lokální odlišnosti |
| Skill body | On demand | Ucelený postup; další reference progressive |
| Domain/ADR/API docs | Na vyžádání | Autoritativní relevantní sekce |
| Tool output | Po call | Strukturovaný a ořezaný |
| Session history | Dočasně | Jen stejný problém a stále platné důkazy |
| Memory | Selektivně | Stabilní facts, ne historie |

### 9.2 Stable prefix a prompt caching

U API harnessů dejte stabilní obsah na začátek v pořadí:

```text
tools/schema -> system/developer policy -> stabilní project core
-> session/task context -> měnící se tool results a messages
```

Neměňte pořadí tools ani nevkládejte timestamp do stabilního prefixu, pokud jej nepotřebujete. Anthropic dokumentuje cache hierarchii tools → system → messages a upozorňuje, že změna tool definitions invaliduje navazující cache. OpenAI prompt caching obdobně odměňuje stabilní prefixy. Viz [Claude prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching), [Claude tool use with prompt caching](https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-use-with-prompt-caching) a [OpenAI prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching).

Prompt caching snižuje účtovanou cenu a latenci opakovaného prefixu; **nezvětšuje context window a neodstraňuje tokeny z jeho obsazenosti**. Dlouhý always-on manuál proto zůstává problém i při vysokém cache hit rate. U některých runtimes cache invaliduje také změna modelu, effort/context nastavení nebo aktivní sady tools, takže tyto parametry neměňte uvnitř jedné fáze bez důvodu.

### 9.3 Tools jako skrytá context tax

Každý dostupný tool přidává rozhodovací alternativu; rozsáhlé schemas mohou spotřebovat část contextu i bez použití. Praktická pravidla:

- tools přidělovat podle role a fáze;
- velké MCP servery zapínat až při potřebě;
- schema držet úzké a výstup stránkovat;
- místo raw log endpointu nabídnout `get_failures(summary=true)`;
- vracet stable IDs a paths, ne kopírovat celé artefakty;
- nejprve lokální search/index, potom drahé externí retrieval;
- oddělit read a write tools.

Oficiální VS Code dokumentace výslovně uvádí, že zúžení tools šetří context, snižuje premium requests a zlepšuje relevanci i výkon. Viz [VS Code tools](https://code.visualstudio.com/docs/copilot/concepts/tools).

Copilot CLI u podporovaných modelů nabízí tool search: při větších katalozích drží externí definice mimo prompt a dohledává je on demand. GitHub uvádí, že několik desítek definitions může zabrat přibližně 10–20 tisíc tokenů a mechanismus se typicky uplatní nad zhruba 30 tools. Je to užitečná pojistka, nikoli důvod připojit bez rozmyslu každý MCP server; routing i supply-chain riziko zůstávají. Viz [GitHub Copilot CLI tool search](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/tool-search).

### 9.4 Kdy session vyčistit nebo compactovat

Použijte fresh session, když:

- přecházíte na nesouvisející ticket;
- agent je anchored na vyvrácené hypotéze;
- hlavní část historie tvoří zastaralé tool results;
- mění se role z implementace na nezávislé review;
- pokračování vyžaduje jiné permission/trust boundary.

Compact použijte uvnitř stejné práce a zachovejte: cíl, constraints, přijatá rozhodnutí, ověřená fakta, modified files, test evidence, otevřené blockers a další krok. Claude nabízí `/clear` a `/compact`; VS Code má context meter a auto-compaction. Viz [Claude context window](https://code.claude.com/docs/en/context-window) a [VS Code chat context](https://code.visualstudio.com/docs/chat/copilot-chat-context).

### 9.5 Deduplication pravidlo

Jedna informace má mít jedno kanonické místo:

- command v root instructions;
- podrobný postup ve skillu;
- doménový invariant v domain docs;
- architektonické rozhodnutí v ADR;
- enforcement v hook/script/CI;
- aktuální práce v issue/spec.

Ostatní vrstvy na zdroj odkazují. Duplikované pravidlo nejen spotřebuje tokeny, ale po změně vytváří konfliktní kontext.

## 10. Doporučený layout repozitáře

```text
/
├─ AGENTS.md                         # krátké portable instrukční jádro
├─ CONTEXT.md                        # malý index domény, nikoli encyklopedie
├─ docs/
│  ├─ domain/<bounded-context>.md
│  ├─ adr/<decision>.md
│  ├─ standards/<topic>.md
│  └─ agent-architecture.md          # contracts, routing a governance
├─ .agents/
│  └─ skills/<skill>/
│     ├─ SKILL.md
│     ├─ references/
│     ├─ scripts/
│     └─ assets/
├─ .github/
│  ├─ copilot-instructions.md        # tenký Copilot adapter
│  ├─ instructions/*.instructions.md
│  ├─ agents/*.agent.md
│  ├─ prompts/*.prompt.md
│  └─ hooks/*.json
├─ .claude/
│  ├─ CLAUDE.md                      # tenký Claude adapter
│  ├─ rules/*.md
│  ├─ agents/*.md
│  └─ settings.json
├─ .codex/
│  ├─ config.toml
│  └─ hooks.json
├─ scripts/ai/
│  ├─ hooks/                         # sdílená deterministic implementace
│  ├─ context/                       # selekce a komprese kontextu
│  ├─ verify/                        # acceptance/test orchestrace
│  └─ adapters/                      # vendor I/O mapping
└─ ai/
   ├─ routing.yml                    # aliases, risk thresholds, budgets
   ├─ tool-profiles.yml              # allowlist per role
   ├─ evals/                         # reprezentativní tasks + expected evidence
   ├─ schemas/                       # agent/hook/handoff/result contracts
   └─ telemetry-schema.json
```

Ne všechny cesty musí existovat první den. Důležitá je orientace závislostí: vendor manifest závisí na portable scriptu a policy, nikdy obráceně.

### 10.1 Obsah minimálního `AGENTS.md`

```text
Purpose and source-of-truth links
Exact build/test/lint commands
How to select the smallest valid check scope
Safety/approval boundaries
Definition of done and required evidence
Routing links: domain docs, skills, path rules
Conflict/uncertainty escalation rule
```

Vyhněte se kopírování framework docs a generických coding zásad. Formatter, compiler a CI jsou levnější autorita.

### 10.2 `CONTEXT.md` jako index

Root `CONTEXT.md` má být navigační mapa: bounded contexts, kanonické termíny, nejdůležitější invariants a odkazy. Detail patří do menších documents. Tím obecný agent umí najít znalost bez povinného načtení celé domény.

## 11. End-to-end workflow

### 11.1 Intake

1. Issue/spec definuje outcome, scope, acceptance criteria a autoritativní zdroje.
2. Deterministický intake získá branch/ticket metadata a risk flags.
3. Coordinator zkontroluje nejasnosti; u material ambiguity nepředstírá specifikaci.

### 11.2 Context assembly

1. Root instructions a tool profile jsou malé a stabilní.
2. Path resolver vybere relevantní rules.
3. Coordinator aktivuje nejvýše několik odpovídajících skills.
4. Explorer hledá existující pattern jen tehdy, když se tím sníží nejistota.

### 11.3 Route a plán

1. Router vypočte risk/ambiguity/verification score.
2. Vybere model tier, effort, tool profile a budget.
3. U komplexní práce vytvoří krátký execution plan s validačním bodem po každém vertical slice.

### 11.4 Implementace

1. Nejmenší end-to-end slice, nikoli široký horizontální refactor.
2. `PostToolUse`/batch hook formátuje a provede rychlé checks.
3. Hlučné výsledky procházejí reducerem.
4. Při opakovaném selhání se eskaluje; historie se neprodlužuje bez nové evidence.

### 11.5 Verifikace a review

1. `verify-stop` zkontroluje acceptance manifest a test evidence.
2. Risk router rozhodne, zda stačí automatické checks, běžný reviewer, nebo risk reviewer.
3. Reviewer dostane spec + diff + evidence, ne implementační monolog.
4. CI opakuje autoritativní gates v čistém prostředí.

### 11.6 Učení systému

Po přijetí změny se neučí prompt volným textem. Aktualizujte správnou vrstvu:

- opakovaný mechanický problém → hook/linter/test;
- opakovaný postup → skill;
- doménová nejasnost → glossary/domain doc;
- architektonické rozhodnutí → ADR;
- routing chyba → eval case a threshold;
- vendor rozdíl → adapter test.

## 12. Evals, observability a ekonomické řízení

### 12.1 Eval corpus

Vytvořte 30–100 reprezentativních úloh, ne pouze benchmark syntaktických oprav:

- drobný jasný bug;
- chybějící test;
- více-modulový refactor;
- diagnosis bez jasné příčiny;
- změna API contractu;
- databázová migrace;
- security-sensitive změna;
- dokumentace/research;
- práce s dlouhým logem;
- úloha, kterou má správně vyřešit script bez LLM.

Každý case má expected outcome, povolený scope, test oracle, risk class, maximální budget a review rubric. U nondeterministických úloh spusťte více replik.

### 12.2 Co porovnávat

- jeden balanced model versus fast → escalation;
- generic + skill versus specialized agent;
- full MCP catalog versus narrow tool profile;
- raw logs versus hook reducer;
- always-on procedure versus on-demand skill;
- implementer self-review versus isolated reviewer;
- low/medium/high effort;
- fresh session versus dlouhá resumed session.

Výsledek hodnotí nejen pass/fail, ale total tokens, cached ratio, calls, wall-clock, human minutes a závažnost review findings.

### 12.3 Rozhodovací pravidlo pro levnější model

Levnější tier přijměte, pokud:

```text
úspora ceny jednoho úspěšného běhu
  > cena dodatečných retry/escalations
  + cena lidského steeringu
  + očekávaný downstream risk
```

Sledujte interval spolehlivosti, ne jeden povedený demo run. Routing threshold aktualizujte verzovaně a u každé změny uvádějte eval evidence.

### 12.4 Run record

Minimální záznam bez citlivého obsahu:

```json
{
  "taskClass": "bugfix-local",
  "risk": 2,
  "routeReason": ["small-scope", "strong-tests"],
  "modelAlias": "balanced-code",
  "effort": "medium",
  "skills": ["diagnose", "tdd"],
  "toolProfile": "workspace-write-no-network",
  "inputTokens": 0,
  "cachedTokens": 0,
  "outputTokens": 0,
  "toolCalls": 0,
  "retries": 0,
  "verification": ["targeted-tests", "typecheck"],
  "accepted": true
}
```

Nuly jsou placeholders z runtime metrik, ne odhad modelu. Spojte record s anonymizovaným task ID a verzí instructions/skills/hooks/routeru.

VS Code/Copilot lze sledovat přes OpenTelemetry spans a metrics pro LLM calls, tools, hooks, subagents, tokeny, cache, latency a edit outcomes. Content capture ponechte vypnutý, pokud pro něj nemáte explicitní governance, protože může exportovat prompt, kód a argumenty tools. Viz [VS Code OpenTelemetry monitoring](https://code.visualstudio.com/docs/agents/guides/monitoring-agents).

## 13. Bezpečnost a supply chain

### 13.1 Nejrizikovější komponenty

Hooks, plugins, MCP servers a skill scripts jsou executable code. Textový skill může současně ovlivnit model, aby tento kód spustil. Proto:

- pinujte verze a ověřujte provenance;
- prohlížejte scripts před trust/instalací;
- oddělte read-only a write-capable components;
- síť a credentials povolujte nejmenšímu možnému profilu;
- logujte policy decisions, ne secrets;
- konfiguraci agentů a hooks chraňte CODEOWNERS/PR review;
- testujte prompt-injection scénáře z issue, webu, dokumentace a tool outputu;
- externí obsah označujte jako data, nikoli instructions;
- používání nového pluginu/MCP musí mít security ownera a removal path.

### 13.2 Content exclusion není univerzální sandbox

GitHub content exclusion je užitečné administrativní opatření, ale dokumentace upozorňuje na omezení podpory v některých režimech, včetně Edit/Agent mode v editorech. Nepovažujte jej proto za jedinou ochranu secrets. Kombinujte filesystem permissions, credentials mimo workspace, hooks, allowlist tools a CI secret scanning. Viz [GitHub content exclusion](https://docs.github.com/en/copilot/concepts/context/content-exclusion).

### 13.3 Data minimization

- do cloud modelu neposílat celý repository, když stačí symbol/section;
- tool reducer musí odstranit secrets před vrácením outputu agentovi;
- telemetry nemá ukládat prompt/source defaultně;
- vendor memory nesmí obsahovat credentials ani osobní údaje;
- retention a region nastavte podle organizačních požadavků;
- u externího MCP ověřte, kam data putují a jak jsou logována.

## 14. Co konfigurovat hodně, středně a málo

| Prvek | Intenzita | Praktický cíl |
|---|---|---|
| CI, tests, sandbox, permissions | Vysoká | Deterministická důvěra a enforcement |
| Hook scripts | Vysoká, ale úzká | Safety, redukce outputu, relevantní checks, evidence |
| Domain docs/ADR/specs | Vysoká kvalita | Přesná přenositelná znalost |
| Skills | Střední až vysoká | Opakovatelné on-demand postupy |
| Evals/telemetry/router | Střední, postupně vysoká | Ekonomické rozhodování podle dat |
| Path instructions | Střední | Pouze skutečné lokální odlišnosti |
| Root `AGENTS.md`/always-on | Nízká objemem, vysoká přesností | Malé jádro platné téměř vždy |
| Stabilní agents | Nízký počet | Jen skutečné boundaries |
| Prompt files | Nízký počet | Lehké workflow entry points |
| MCP/tools | Minimální podle role | Nejmenší schopný allowlist |
| Plugins | Nízká zpočátku | Až distribuce stabilních capabilities |
| Vendor memory | Nízká | Komfortní cache, nikdy source of truth |

## 15. Zavedení po etapách

### Prvních 30 dní: deterministic foundation

- změřit baseline tokenů, retries, CI pass a human review time;
- zkrátit root instructions a odstranit duplicity;
- definovat přesné build/test/lint commands a definition of done;
- vytvořit `guard-tool-use`, output reducer a `verify-stop`;
- zavést tři model aliases a základní risk rules;
- omezit tool/MCP profiles;
- vytvořit prvních 10–20 eval cases.

### 31–60 dní: progressive specialization

- převést dlouhé opakované instrukce na skills;
- rozdělit domain context a path rules;
- zavést explorer a isolated reviewer role;
- přidat handoff/result schemas;
- měřit generic+skill proti specialized agent variantě;
- přidat cache-friendly stable prefix a context budgets;
- propojit run record s PR/CI výsledkem.

### 61–90 dní: adaptive routing a governance

- kalibrovat thresholds na skutečných datech;
- přidat risk reviewer pro auth/data migrations/compliance;
- balit do pluginu pouze komponenty používané ve více repozitářích;
- automaticky detekovat config drift a nepoužívané skills/tools;
- měsíčně re-evaluovat model mapping a ceny;
- čtvrtletně provést supply-chain a prompt-injection review.

## 16. Doporučení pro konkrétní platformy

### VS Code a GitHub Copilot

- Použijte `.github/copilot-instructions.md` pouze jako malé repo jádro nebo adapter na `AGENTS.md`.
- Path-specific `.instructions.md` používejte pro technologické boundaries; kvůli negarantovanému pořadí nebudujte konfliktní override řetězce.
- Custom agents využijte především pro tool/model/permission/handoff rozdíly.
- Hooks dejte do verzovaného repo layoutu a sdílejte jejich scripts s ostatními platformami.
- U cloud coding agenta ověřte podporu jednotlivých agent fields a dostupnost nástrojů v cloudu.
- Sledujte context meter; zúžte tool set dříve, než automaticky přepnete na větší model.

### Codex

- Root a scoped `AGENTS.md` držte krátké a přesuňte procedury do skills.
- Subagents používejte pro paralelní izolovanou práci a nezávislé review, nikoli jako katalog person.
- Hooks stavte command-first; `prompt`/`agent` handler nepovažujte za aktivní jen proto, že parser konfiguraci přijme.
- Projektovým hooks důvěřujte až po review; počítejte s trust/hash mechanismem.
- Model a effort mapujte přes aliases v routeru a pravidelně aktualizujte podle model catalogu a vlastních evals.

### Claude Code

- `CLAUDE.md` držte přibližně pod 200 řádků a specializované postupy přesuňte do skills, jak doporučuje oficiální cost guidance.
- `.claude/rules` používejte pro path scope; imports nejsou tokenová úspora, pokud se stejně načtou při startu.
- Subagentům nastavte model, effort, tools, permissions, skills a případně worktree podle role.
- Pro produkční enforcement preferujte command hooks; prompt hook použijte pro levnou semantickou bránu a experimentální agent hook jen měřeně.
- Vypínejte nepoužívané MCP servers; kde dává smysl, preferujte existující CLI a output reducer.
- Pro nesouvisející úlohy používejte fresh context; auto memory považujte za cache.

## 17. Konečný návrh kombinace

Pro dlouhodobou práci doporučuji následující cílový stav:

1. **Repo je autorita:** issues/specs, ADR, domain docs, commands a tests.
2. **Always-on kontext je malý:** přibližně desítky rozhodovacích řádků, ne manuál.
3. **Jeden obecný coordinator:** vlastní intent a integraci.
4. **Skills jsou hlavní specializace:** znalosti a postupy se načítají až při použití.
5. **Tři až čtyři role:** coordinator, levný explorer, čistý reviewer, risk reviewer.
6. **Hooks jsou vnější nervový systém:** policy, redukce contextu, kvalita, evidence a telemetry bez LLM.
7. **Tools jsou capability budget:** každá role dostane nejmenší účelný allowlist.
8. **Router optimalizuje accepted result:** model i effort volí podle rizika, ambiguity a síly verifieru.
9. **Silnější model se používá včas:** pokud předchází drahému bloudění nebo reworku.
10. **CI a člověk zůstávají gates:** autonomie není totéž co oprávnění merge/deploy.
11. **Vendor konfigurace je adapter:** portable scripts, skills a dokumentace zůstávají společné.
12. **Každé zlepšení prochází evalem:** nepřidávat agent, skill, MCP ani hook bez jasného očekávaného přínosu a možnosti odebrání.

Největší dosažitelná úspora obvykle nevznikne výběrem nejlevnějšího modelu. Vznikne odstraněním zbytečného always-on kontextu, hlučných tool outputs, opakovaného LLM rozhodování a neúspěšných loopů. Teprve na tomto deterministickém základu má jemné model routing skutečnou ekonomickou hodnotu.

## 18. Konkrétní bootstrap nového repozitáře

### 18.1 Zásada: nejdříve deterministický projekt, potom agentní vrstva

Nový repozitář nenastavujte tak, že nejprve vytvoříte deset agents a katalog skills. Správné pořadí je:

1. ověřitelný build, testy, formatter, lint/typecheck a secret scan;
2. stručné zdroje pravdy a exact commands;
3. jeden portable agent contract;
4. tenké adaptéry používaných platforem;
5. deterministic hooks nad již fungujícími scripts;
6. teprve potom skills, role, routing, evaly a telemetry.

Agent neumí opravit chybějící test oracle tím, že dostane delší prompt. Bez jednoznačných commands a strojového výsledku bude levný i drahý model spotřebovávat tokeny na odhadování, zda je práce hotová.

### 18.2 Tři bootstrap profily

| Profil | Kdy jej použít | Co vytvořit |
|---|---|---|
| Minimal | experiment, malá knihovna, jeden agentní produkt | `AGENTS.md`, `CONTEXT.md`, domain/ADR základ, `ai/project.json`, routing/tool profiles, kontrolní scripts, skills directory |
| Standard | běžný dlouhodobý aplikační repozitář | Minimal + Copilot, Claude a Codex adapters a adresáře pro path rules/hooks |
| Full | tým, více repozitářů, regulovaný nebo nákladově řízený provoz | Standard + eval corpus, handoff schema, telemetry a portable hook layout |

Výchozí volba je **Standard**. Full profil nepoužívejte jako záminku k okamžitému zapnutí všech mechanismů; vytváří strukturu, nikoli automaticky důvěryhodné enforcement.

### 18.3 Připravený bootstrap skript

Součástí této analýzy je [bezpečný PowerShell orchestrátor](./bootstrap-ai-repository.ps1) a samostatný [verzovatelný strom šablon](./bootstrap-ai-repository.templates/). PowerShell soubor neobsahuje žádný text generovaných files. Čte manifest a skládá vybrané vrstvy:

```text
bootstrap-ai-repository.templates/
├─ manifest.json
├─ base/                         # portable minimum pro všechny profily
├─ profiles/
│  ├─ standard/                 # Copilot, Claude a Codex adapters
│  └─ full/                     # evaly, schemas, telemetry a hooks layout
├─ technologies/
│  ├─ dotnet/
│  └─ node-pnpm/
└─ combinations/
   └─ dotnet-node-pnpm/         # přesná varianta pro společný repo stack
```

Každá vrstva zrcadlí cílové cesty v novém repozitáři. Běžný template file je úplná varianta cíle. Soubor `AGENTS.md.append` se k vybrané variantě `AGENTS.md` připojí a `AGENTS.md.prepend` se vloží před ni. Tím lze technologickou instrukci udržovat jako malý fragment bez kopírování celého základního souboru.

Priority jsou explicitní: base → profile → technology → combination. Pokud dvě vybrané technologie nabízejí úplnou variantu stejného cíle se stejnou prioritou a neexistuje vyšší kombinovaná varianta, bootstrap skončí s chybou. Nikdy tiše nerozhoduje podle pořadí adresářů.

Podporované technologie a kombinace vypíšete bez změny repozitáře:

```powershell
pwsh -NoProfile -File .\bootstrap-ai-repository.ps1 -ListTechnology
```

Skript je idempotentní, podporuje `-WhatIf`, standardně nepřepisuje žádný existující soubor a umí volitelně inicializovat Git.

Nejprve zobrazte plán:

```powershell
pwsh -NoProfile -File .\bootstrap-ai-repository.ps1 `
  -RepositoryPath C:\src\MyApplication `
  -Profile Standard `
  -Technology dotnet `
  -InitializeGit `
  -WhatIf
```

Po kontrole spusťte skutečný bootstrap:

```powershell
pwsh -NoProfile -File .\bootstrap-ai-repository.ps1 `
  -RepositoryPath C:\src\MyApplication `
  -Profile Standard `
  -Technology dotnet `
  -InitializeGit
```

Pro kombinovaný .NET + pnpm repozitář se automaticky vybere i přesná combination layer:

```powershell
pwsh -NoProfile -File .\bootstrap-ai-repository.ps1 `
  -RepositoryPath C:\src\MyPortal `
  -Profile Full `
  -Technology dotnet,node-pnpm `
  -InitializeGit
```

Opakované spuštění existující files přeskočí. `-Force` je přepíše šablonami, proto jej nepoužívejte na nakonfigurovaný repozitář bez diffu a zálohy:

```powershell
# Pouze po vědomé kontrole; přepisuje již existující scaffold files.
pwsh -NoProfile -File .\bootstrap-ai-repository.ps1 `
  -RepositoryPath C:\src\MyApplication `
  -Profile Full `
  -Force
```

Skript úmyslně **neaktivuje vendor hooks, nenastavuje credentials, síť ani konkrétní modely**. Tyto operace mění trust boundary, jejich schémata se vyvíjejí a vyžadují review konkrétního repozitáře. Bootstrap připraví portable core a místa pro tenké adaptéry.

Novou technologii přidáte bez změny PowerShellu:

1. zaregistrujte jméno, cestu a prioritu v `manifest.json`;
2. vytvořte `technologies/<name>/` pouze s odlišnými files nebo fragmenty;
3. pro Markdown preferujte malé `.append`/`.prepend` fragmenty;
4. pro strukturovaný JSON/YAML použijte úplnou validní variantu;
5. pokud dvě technologie nahrazují stejný file, přidejte odpovídající combination layer;
6. ověřte `-WhatIf`, skutečné generování, opakovaný běh a `-Force -WhatIf`.

### 18.4 Co udělat před spuštěním bootstrapu

Sepište krátkou vstupní kartu:

| Otázka | Požadovaná odpověď |
|---|---|
| Jaký je primární runtime a package manager? | Jedna podporovaná verze a lockfile |
| Jak se provede clean restore/install? | Jeden neinteraktivní command |
| Jaký command ověří formatting? | Check režim bez skryté mutace |
| Jaký command provede lint/typecheck? | Strojový exit code |
| Jaké jsou rychlé a plné testy? | Oddělené commands a očekávaná doba |
| Jak vzniká build artifact? | Reprodukovatelný command |
| Jak se skenují secrets/dependencies? | Lokální nebo CI command |
| Které cesty jsou generated/protected? | Explicitní patterns a vlastník |
| Potřebuje běžný vývoj síť? | Default deny, allowlist nebo approval |
| Co agent nikdy nesmí sám provést? | Publish, deploy, migration, externí write apod. |

Pokud některou odpověď neznáte, je to úkol pro build/CI setup, nikoli pro `AGENTS.md`.

### 18.5 První hodina po bootstrapu

#### Krok 1: nakonfigurujte `ai/project.json`

Každý command je pole: executable a jednotlivé argumenty. Nepoužívá se shellový command string, takže je méně prostoru pro quoting chyby a command injection. Prázdné pole znamená „dosud nenakonfigurováno“ a kontrolní script takovou položku přeskočí; pokud je celá fáze prázdná, úmyslně selže.

Ilustrační .NET konfigurace:

```json
{
  "schemaVersion": 1,
  "commands": {
    "format": ["dotnet", "format", "--verify-no-changes", "--no-restore"],
    "lint": ["dotnet", "build", "--no-restore", "--configuration", "Release"],
    "typecheck": [],
    "testFast": ["dotnet", "test", "--no-restore", "--filter", "Category!=Integration"],
    "testFull": ["dotnet", "test", "--no-restore"],
    "build": ["dotnet", "build", "--no-restore", "--configuration", "Release"],
    "secretScan": ["gitleaks", "detect", "--no-banner", "--redact"]
  },
  "phases": {
    "quick": ["format", "lint"],
    "stop": ["format", "lint", "testFast", "build", "secretScan"],
    "ci": ["format", "lint", "testFull", "build", "secretScan"]
  }
}
```

Ilustrační Node/pnpm konfigurace:

```json
{
  "schemaVersion": 1,
  "commands": {
    "format": ["pnpm", "exec", "prettier", ".", "--check"],
    "lint": ["pnpm", "run", "lint"],
    "typecheck": ["pnpm", "run", "typecheck"],
    "testFast": ["pnpm", "run", "test:unit"],
    "testFull": ["pnpm", "run", "test"],
    "build": ["pnpm", "run", "build"],
    "secretScan": ["gitleaks", "detect", "--no-banner", "--redact"]
  },
  "phases": {
    "quick": ["format", "lint", "typecheck"],
    "stop": ["format", "lint", "typecheck", "testFast", "build", "secretScan"],
    "ci": ["format", "lint", "typecheck", "testFull", "build", "secretScan"]
  }
}
```

Příklady slepě nekopírujte. Názvy scripts, test categories a pořadí restore/build se musí shodovat s konkrétním projektem. Duplicitní build v lint a build fázi je u některých .NET repozitářů zbytečný; nahraďte jej specializovaným analyzátorem nebo upravte phase list.

#### Krok 2: ověřte stejné commands lokálně

```powershell
pwsh ./scripts/ai/Invoke-AiChecks.ps1 -Phase Quick
pwsh ./scripts/ai/Invoke-AiChecks.ps1 -Phase Stop
pwsh ./scripts/ai/Invoke-AiChecks.ps1 -Phase CI
```

Než tyto commands dostane agent, musí projít v clean checkoutu bez interaktivních dotazů. Plná CI fáze může být dlouhá, ale musí být reprodukovatelná.

#### Krok 3: upravte `AGENTS.md`

Nahraďte pouze skutečné TODO/obecné části. Root soubor má zůstat přibližně na desítkách řádků. Přidejte:

- jak vybrat nejmenší validní project/test scope;
- generated a protected paths;
- repo-specific architektonickou hranici;
- přesnou definici evidence při dokončení;
- odkazy na relevantní domain docs a první skills.

Nevkládejte sem celý README, framework dokumentaci ani style rules již vynucené toolingem.

#### Krok 4: vyplňte `CONTEXT.md`

Stačí účel systému, bounded contexts, několik kritických invariants a kanonické termíny. Každou větší doménu přesuňte do `docs/domain/<context>.md`. Cílem je retrieval mapa, ne automaticky načítaná encyklopedie.

#### Krok 5: nastavte `ai/routing.json`

Mapujte aliases `fast`, `balanced-code` a `frontier-reasoning` na aktuálně dostupné modely **mimo skills a prompty**. Pokud platforma vlastní model router nepodporuje, aliases stále slouží jako governance a eval záznam; konkrétní volbu provede člověk nebo surface adapter.

### 18.6 První den: CI a ochrana konfiguračních files

Lokální agent a CI musí volat stejnou kontrolní implementaci. Jinak vzniknou dvě pravdy. CI workflow může provést restore/install a potom:

```powershell
pwsh ./scripts/ai/Invoke-AiChecks.ps1 -Phase CI
```

Do CODEOWNERS nebo ekvivalentního rulesetu přidejte minimálně:

```text
/AGENTS.md                         @platform-owner @security-owner
/.github/copilot-instructions.md  @platform-owner
/.github/hooks/                   @platform-owner @security-owner
/.claude/                         @platform-owner @security-owner
/.codex/                          @platform-owner @security-owner
/.agents/skills/                  @platform-owner
/scripts/ai/                      @platform-owner @security-owner
/ai/                              @platform-owner
/.github/workflows/               @platform-owner @security-owner
```

Vlastníky přizpůsobte týmu. Důležitý je princip: agent nesmí nenápadně oslabit verifier nebo hook, kterým bude následně sám hodnocen.

### 18.7 Doporučené portable scripts

Bootstrap vytváří první dva. Další přidávejte v tomto pořadí podle skutečné potřeby:

| Script | Trigger | Úloha bez LLM | Výstup do kontextu | Chování při chybě |
|---|---|---|---|---|
| `Get-AiSessionContext.ps1` | session start | branch, dirty state, changed files, dostupné tools | Kompaktní JSON | Warning; neblokovat běžné čtení |
| `Invoke-AiChecks.ps1` | post-batch, stop, CI | jednotná orchestrace checks | Pass nebo první root cause | Stop/CI blokovat |
| `Get-AiChangedScope.ps1` | po batchi změn | dependency graph a dotčené projekty/testy | Seznam IDs/paths | Fallback na širší bezpečný scope |
| `Protect-AiToolUse.ps1` | pre-tool/permission | canonical paths, command/network allow/deny | Decision + reason code | U citlivé akce fail-closed |
| `Compress-AiToolOutput.ps1` | post-tool | deduplikace logů, první root cause, failing tests | Nejvýše stovky řádků; ideálně desítky | U parser failure vrátit path k raw artefaktu |
| `Assert-AiCompletion.ps1` | stop/task complete | acceptance manifest, required checks, dirty/protected files | Přesný seznam chybějící evidence | Blokovat s loop limitem |
| `Write-AiRunRecord.ps1` | stop/CI | route, config hash, tools, checks, token metadata | Nic nebo krátké ID | Telemetry obvykle fail-open |
| `Test-AiConfiguration.ps1` | pre-commit/CI | JSON schemas, odkazy, duplicity, size budgets, executable existence | Findings s paths | CI blokovat |
| `Update-AiModelMap.ps1` | měsíčně, mimo agent run | připravit návrh cen/model aliases | Diff k lidskému review | Nikdy automaticky neměnit production route |

#### Návrh `Get-AiChangedScope`

Nedělejte jen `git diff --name-only`. Script má:

1. získat changed files proti zvolenému merge-base;
2. mapovat je na projekty/packages;
3. rozšířit scope o závislé projekty podle skutečného dependency graphu;
4. najít relevantní test targets;
5. vrátit strukturované IDs a důvod zahrnutí;
6. při neznámé změně zvolit širší bezpečný scope.

To umožní spouštět cílené testy bez toho, aby LLM znovu analyzoval project graph.

#### Návrh output reduceru

`Compress-AiToolOutput` má ponechat raw log jako artefakt a modelu vrátit například:

```json
{
  "status": "failed",
  "rootCause": "CS0246 in src/Billing/InvoiceService.cs:42",
  "failedTargets": ["Billing.UnitTests"],
  "representativeDiagnostics": ["..."],
  "suppressedDuplicateCount": 137,
  "rawArtifact": ".ai-runs/2026-07-17T010203Z/build.log",
  "sha256": "..."
}
```

Reducer nesmí „shrnovat“ význam chyb kreativně. Má parsovat známý formát, zachovat originální diagnostiku a přiznat, když parser selhal.

#### Návrh completion verifieru

Verifier nemá znovu spustit nekonečný agent loop. Použijte task-local manifest:

```json
{
  "requiredPhase": "Stop",
  "requiredArtifacts": [],
  "protectedPaths": [".github/workflows", "scripts/ai", "ai"],
  "allowDirty": true,
  "maximumContinuationCount": 1
}
```

Při chybě vrátí reason codes, například `CHECKS_NOT_RUN`, `CHECK_FAILED`, `PROTECTED_FILE_CHANGED` nebo `MISSING_ARTIFACT`. Po jednom opravném pokračování eskaluje člověku místo dalšího modelového kola.

### 18.8 Jak hooks zavádět bez rizikového „big bang“

#### Fáze A: manuální scripts

Nejprve je spouští vývojář a CI. Měříte runtime, stabilitu a množství outputu.

#### Fáze B: audit-only hooks

Hook nic neblokuje. Zapisuje reason codes, co by povolil/zamítl, a kolik outputu by odfiltroval. Měřte false positives alespoň na běžném vzorku úloh.

#### Fáze C: warnings a redukce

Aktivujte session snapshot a output reducer. Policy violation zatím vrací warning; jednoznačné secrets mohou být výjimkou s okamžitým blokem.

#### Fáze D: přesné enforcement

Blokujte pouze pravidla s fixture tests a nízkým false-positive rate. `Stop` hook dostane continuation limit. Full test suite zůstává phase boundary/CI, ne `PostToolUse` po každém zápisu.

#### Fáze E: vendor adapters

Pro Copilot, Codex a Claude vytvořte malé manifests/matchers, které převádějí vendor event JSON na interní schema a volají stejný portable script. Adapter testujte uloženými fixtures z každého runtime. Nepředpokládejte, že stejné jméno eventu znamená totožný payload nebo blokovací sémantiku.

### 18.9 První skills a agents

Nevytvářejte skills podle seznamu technologií. První tři až pět skills mají odrážet opakující se rizikové workflow, například:

- `diagnose-failure`: reprodukce → minimalizace → hypotézy → evidence → regression test;
- `database-migration`: compatibility, rollback, locking, backfill a validační checklist;
- `change-public-api`: consumer impact, versioning, contracts a dokumentace;
- `security-sensitive-change`: trust boundaries, secrets, authn/authz a scanner evidence;
- `release`: deterministické artefakty, provenance, changelog a approval gate.

Na začátku stačí jeden obecný agent. Přidejte read-only explorer a reviewer pouze tehdy, když platforma umí skutečně omezit jejich tools/permissions nebo izolovat context. Každá role musí mít strukturovaný výstup a budget. Technologickou znalost ponechte ve skillu.

### 18.10 Automatizovaný organizační postup

Pro více repozitářů vytvořte centrální repository template nebo interní bootstrap balík:

```text
Create repository
  -> copy portable scaffold at pinned version
  -> detect project manifests and propose commands
  -> human confirms ai/project.json
  -> run clean restore/build/test
  -> validate agent configuration
  -> enable audit-only hooks
  -> execute 3–5 smoke evals
  -> open bootstrap PR
  -> required owners review policy/config files
  -> merge; enforcement remains staged
```

Detekce stacku může být čistě deterministická:

- `*.sln` / `*.csproj` → nabídnout .NET adapter;
- `package.json` + lockfile → odpovídající npm/pnpm/yarn adapter;
- `pyproject.toml` → Python adapter;
- `go.mod`, `Cargo.toml`, Maven/Gradle files → příslušný adapter;
- více manifestů → monorepo režim a explicitní project map.

Script má **navrhnout** commands, nikoli je bez ověření prohlásit za autoritativní. Spusťte je v clean sandboxu a teprve po úspěchu zapište do `ai/project.json`.

Organizační template verzujte. Upgrade má otevřít PR s přesným diffem a changelogem, nikoli přepsat lokální přizpůsobení. Jednoduchý manifest může evidovat:

```json
{
  "scaffoldVersion": "1.0.0",
  "profile": "standard",
  "managedFiles": [
    "scripts/ai/Invoke-AiChecks.ps1",
    "ai/schemas/handoff.schema.json"
  ],
  "localFiles": [
    "AGENTS.md",
    "CONTEXT.md",
    "ai/project.json"
  ]
}
```

Managed files lze aktualizovat pouze při shodě očekávaného hashe; local files se nikdy automaticky nepřepisují.

### 18.11 Co automatizovat bez LLM

LLM nepotřebujete pro:

- vytvoření adresářů a šablon;
- detekci project manifests a lockfiles;
- ověření JSON/YAML schemas;
- kontrolu odkazů a existence executables;
- výpočet velikosti always-on instrukcí;
- detekci duplicitních pravidel pomocí exact/normalized hashů;
- načtení Git branch/status/diff scope;
- dependency graph poskytovaný build systémem;
- formatter, lint, typecheck, tests, build a scanners;
- kontrolu protected paths;
- redukci známých log formats;
- generování config diffu a bootstrap PR;
- telemetry metadata a config hashes.

LLM použijte až pro nejednoznačné části: návrh bounded contexts, formulaci invariants, posouzení architektonického rizika, klasifikaci neznámého diffu nebo review změny, jejíž správnost nemá silný mechanický oracle.

### 18.12 Definition of done pro agent-ready repozitář

Repozitář je připraven, když:

- clean checkout lze neinteraktivně nainstalovat a sestavit;
- Quick, Stop a CI phases mají alespoň jeden skutečný command a odpovídající runtime;
- CI používá stejný check orchestrator jako lokální agent;
- `AGENTS.md` je krátký, bez duplicitní dokumentace a obsahuje přesné commands/hranice;
- `CONTEXT.md` funguje jako index a kritické invariants mají autoritativní místo;
- vendor adapters pouze odkazují na portable core;
- write/network permissions jsou defaultně minimální;
- agent config, hooks, scripts, MCP a CI mají review ownership;
- hooks jsou nejprve auditované a mají tests, timeouty a omezený output;
- existuje alespoň jeden jednoduchý, jeden diagnostický a jeden rizikový eval case;
- model aliases a route reasons se zapisují mimo prompty;
- raw logs zůstávají jako artefakty, model dostává pouze relevantní výřez;
- žádný agent nemůže sám nepozorovaně změnit verifier a následně tímto oslabeným verifierem projít;
- merge/deploy policy odpovídá riziku projektu.

### 18.13 Doporučený týdenní bootstrap plán

| Den | Výsledek |
|---|---|
| 1 | Portable scaffold, exact commands, clean local/CI run |
| 2 | Stručný agent contract, domain index, protected paths a ownership |
| 3 | Session context, changed-scope a output-reduction scripts |
| 4 | Audit-only hooks ve všech skutečně používaných runtimes |
| 5 | První tři workflow skills, explorer/reviewer jen podle potřeby |
| 6 | 10 reprezentativních eval cases a run record |
| 7 | Baseline modelů, routing thresholds, false-positive review a bootstrap ADR |

Po týdnu systém zmrazte na krátké pilotní období. Každé další pravidlo přidejte pouze jako reakci na opakovaný měřitelný problém a do nejlevnější správné vrstvy: script/hook, CI, dokumentace, skill, path rule, nebo teprve nakonec always-on instruction.

## 19. Primární zdroje

### OpenAI / Codex

- [Codex customization overview](https://learn.chatgpt.com/docs/customization/overview)
- [Codex AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Codex skills](https://learn.chatgpt.com/docs/build-skills)
- [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [Codex hooks](https://learn.chatgpt.com/docs/hooks)
- [OpenAI model catalog](https://developers.openai.com/api/docs/models)
- [OpenAI prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching)

### GitHub Copilot a Visual Studio Code

- [VS Code agent customization](https://code.visualstudio.com/docs/copilot/concepts/customization)
- [VS Code custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
- [VS Code custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents)
- [VS Code Agent Skills](https://code.visualstudio.com/docs/agent-customization/agent-skills)
- [VS Code hooks](https://code.visualstudio.com/docs/agent-customization/hooks)
- [VS Code tools and context cost](https://code.visualstudio.com/docs/copilot/concepts/tools)
- [VS Code chat context](https://code.visualstudio.com/docs/chat/copilot-chat-context)
- [GitHub custom agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [GitHub Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)
- [GitHub Copilot hooks concept](https://docs.github.com/en/copilot/concepts/agents/hooks)
- [GitHub Copilot content exclusion](https://docs.github.com/en/copilot/concepts/context/content-exclusion)

### Anthropic / Claude Code

- [Claude Code features overview](https://code.claude.com/docs/en/features-overview)
- [Claude Code memory and CLAUDE.md](https://code.claude.com/docs/en/memory)
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code hooks reference](https://code.claude.com/docs/en/hooks)
- [Claude Code hooks guide](https://code.claude.com/docs/en/hooks-guide)
- [Claude Code cost management](https://code.claude.com/docs/en/costs)
- [Claude Code model configuration](https://code.claude.com/docs/en/model-config)
- [Claude Code context window](https://code.claude.com/docs/en/context-window)
- [Claude Code plugins](https://code.claude.com/docs/en/plugins)
- [Claude prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)
- [Claude tools with prompt caching](https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-use-with-prompt-caching)
