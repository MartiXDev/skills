# Porovnání AI skillů pro TypeScript

<!-- markdownlint-disable MD013 -->

Stav rešerše: 21. července 2026. Hodnocen byl skutečný obsah `SKILL.md` a přidružených souborů v konkrétních revizích, nikoli pouze popisy v katalogu nebo počet instalací.

## Krátká odpověď

Z původní trojice je nejlepším **základem k opravě** `typescript-pro` od Jeffallan. Jako obecný implementační skill má nejlépe formulovaný proces, kontrolovatelná dokončovací kritéria a nejčistší progresivní zpřístupnění pěti tematických referencí. Ani jej však kvůli faktickým chybám v referencích nepovažuji za bezvýhradně důvěryhodný kódový zdroj.

Nenašel jsem hotový veřejný skill, který by byl jednoznačně lepší ve všech směrech. **`typescript` od pproenca/dot-skills** je lépe navržený jako větvená referenční příručka a je zajímavý hlavně pro výkon kompilátoru a `tsconfig`, ale není lepším univerzálním implementačním skillem a část jeho kvantitativních či verzovaných tvrzení není spolehlivá.

Pokud chcete zvolit jeden z existujících skillů a přijímáte uvedené výhrady:

```powershell
npx skills add https://github.com/jeffallan/claude-skills --skill typescript-pro
```

Pro specializovaný audit výkonu TypeScriptu lze místo něj zvážit:

```powershell
npx skills add https://github.com/pproenca/dot-skills --skill typescript
```

Oba bych bez úpravy popisů neinstaloval současně: jejich široké modelové triggery se překrývají, soutěžily by o aktivaci a někdy dávají odlišná obecná doporučení.

## Pořadí

| Pořadí | Skill | Verdikt | Nejvhodnější použití |
|---:|---|---|---|
| 1 | `Jeffallan/claude-skills: typescript-pro` | Nejlepší z původní trojice; doporučený základ pro lokální fork | Implementace, návrh typů, konfigurace a typové kontroly |
| 2 | `pproenca/dot-skills: typescript` | Nejlepší informační hierarchie, ale užší a obsahově ne zcela důvěryhodný | Výkon `tsc`, `tsconfig`, moduly a cílené referenční kontroly |
| 3 | `sickn33/agentic-awesome-skills: typescript-expert` | Široký záběr, slabá predikovatelnost | Pouze po výrazném prořezání a opravách |
| 4 | `wshobson/agents: typescript-advanced-types` | Populární tutorial, ne spolehlivý prováděcí skill | Studium základů typového systému, nikoli kopírování vzorů bez ověření |

## Metoda hodnocení

Podle rámce `writing-great-skills` je kořenovou vlastností skillu **predikovatelnost procesu**. Posuzoval jsem proto:

1. **Invocation** — zda popis přesně vymezuje triggery a větve, nebo se aktivuje příliš široce.
2. **Information hierarchy** — zda jsou kroky v hlavním souboru a podmíněné reference za přesnými kontextovými ukazateli.
3. **Completion criteria** — zda agent dokáže objektivně poznat, že implementace a ověření skončily.
4. **Technical trust** — zda jsou příklady kompilovatelné, tvrzení konzistentní a rady aktuální.
5. **Pruning** — duplicity, sediment, no-op instrukce, sprawl a negativní formulace.
6. **Portability** — respekt k projektu, operačnímu systému, správci balíčků a existujícím skriptům.

Popularitu jsem použil jen jako pomocný signál. Například skills.sh uvádí přibližně 54,4 tisíce instalací pro `typescript-advanced-types`, ale jeho konkrétní ukázky přesto obsahují ověřené chyby kompilace. [Katalogový záznam wshobson](https://www.skills.sh/wshobson/agents/typescript-advanced-types)

## 1. Jeffallan: `typescript-pro`

Zdroj: [`SKILL.md` v hodnocené revizi](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/SKILL.md), [skills.sh](https://www.skills.sh/jeffallan/claude-skills/typescript-pro).

### Proč vyhrává

- Hlavní soubor má 147 řádků a obsahuje pětikrokový proces: analýza, návrh, implementace, optimalizace a typové testování.
- Kroky 3–5 mají relativně ostrá dokončovací kritéria: `tsc --noEmit`, nulové typové chyby, kontrola veřejných API a iterace do čistého výsledku.
- Pět rozsáhlých témat je umístěno v samostatných souborech a tabulka říká přesně, kdy který načíst: [advanced types](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/advanced-types.md), [type guards](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/type-guards.md), [utility types](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/utility-types.md), [configuration](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/configuration.md) a [patterns](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/patterns.md).
- Vedoucí pojem „type-first“ konzistentně řídí návrh i implementaci.

### Slabiny

- Popis slibuje konfiguraci tRPC, ale `tRPC` se mimo metadata a závěrečný seznam znalostí v těle ani referencích prakticky nevyskytuje. Trigger tedy slibuje větev, která neexistuje.
- Povinný „`Annotated` pattern with type predicates“ není nikde definován ani odkázán.
- Hlavní doporučený `tsconfig` používá `skipLibCheck: false`, zatímco konfigurační reference opakovaně používá `true`; chybí rozhodovací pravidlo, které by obě varianty sjednotilo.
- Reference obsahují věcně chybné ukázky: tvrdí, že `string` je přiřaditelný do `object` v příkladu variance; simuluje compiler-only intrinsic aliasy uživatelskou deklarací `type Uppercase<S> = intrinsic`; a builder neumí ověřit, že byly nastaveny všechny povinné klíče. [Advanced types](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/advanced-types.md), [patterns](https://github.com/Jeffallan/claude-skills/blob/e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319/skills/typescript-pro/references/patterns.md), [oficiální definice `object`](https://www.typescriptlang.org/docs/handbook/2/functions.html#object), [intrinsic string manipulation types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html#intrinsic-string-manipulation-types)
- Univerzální příkazy typu „vždy branded types“, „nikdy enums“ a „vždy declaration files“ jsou příliš silné pro aplikace, knihovny, Node, bundlery a různé projektové konvence.
- Znalostní hranice uvádí „TypeScript 5.0+“. Aktuální TypeScript 7.0 byl vydán 8. července 2026; přebírá nové defaulty z verze 6.0, mění compiler na nativní implementaci a zatím neposkytuje programové API. Skill nemá rozhodovací větev pro TypeScript 6 versus 7 ani pro nástroje, které musí zůstat na šestce. [Oficiální oznámení TypeScriptu 7.0](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/), [TypeScript 6.0 release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html)

Verdikt: **nejlepší základ, ale zaslouží malý opravný fork**.

## 2. pproenca: `typescript`

Zdroj: [`SKILL.md` v hodnocené revizi](https://github.com/pproenca/dot-skills/blob/78ad92f364fe072b432903f04e2c594bf46dcdca/skills/.curated/typescript/SKILL.md), [skills.sh](https://www.skills.sh/pproenca/dot-skills/typescript).

### Co dělá výborně

- Nejlepší popis invocation ze všech kandidátů: uvádí konkrétní úmysly, diagnostické kódy, přípony souborů a výslovné hranice toho, co nepokrývá.
- Hlavní soubor má pouze 93 řádků a směruje do 45 malých pravidel v osmi prioritních kategoriích. To je velmi dobrá progresivní disclosure a co-location.
- Pravidla jsou jednotlivě pojmenovaná podle účelu, takže agent může načíst jen relevantní větev místo celého manuálu.
- Rozlišuje dopad a často uvádí situace, kdy mikrooptimalizaci přeskočit.

### Proč jej nedoporučuji jako univerzální náhradu

- Je to primárně referenční příručka, nikoli implementační proces. Chybí průchod „prozkoumej projekt → změň → spusť projektové kontroly → oprav do zelena“ a jeho dokončovací kritéria.
- Míchá výkon typového systému, obecný JavaScript runtime, paměť a styl. Část obsahu tedy není specifická pro TypeScript.
- Mnohá přesná procenta a násobky nejsou vysledovatelná ke konkrétním měřením. Jsou prezentována jako obecné dopady, ačkoli závisejí na projektu a runtime.
- Pravidlo k `isolatedModules` tvrdí „80–90 % rychlejší transpilation“. Oficiální TypeScript performance guide výslovně říká, že `isolatedModules` samo generování kódu nezrychlí; pouze upozorní na konstrukce nekompatibilní s izolovaným emitováním. [Pravidlo pproenca](https://github.com/pproenca/dot-skills/blob/78ad92f364fe072b432903f04e2c594bf46dcdca/skills/.curated/typescript/references/tscfg-isolate-modules.md), [oficiální vysvětlení](https://github.com/microsoft/TypeScript/wiki/Performance#isolated-file-emit)
- Pravidlo o `@types` říká, že TypeScript implicitně načítá všechny viditelné balíčky. Od TypeScriptu 6.0 je výchozí hodnota `types` nově `[]` a TypeScript 7 tento default přebírá, takže vysvětlení je pro aktuální verze zastaralé. Skill zároveň nepokrývá nativní compiler, paralelní `--checkers`/`--builders`, absenci programového API ani odstraněné volby verze 7. [Pravidlo pproenca](https://github.com/pproenca/dot-skills/blob/78ad92f364fe072b432903f04e2c594bf46dcdca/skills/.curated/typescript/references/module-control-types-inclusion.md), [TypeScript 7.0](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/), [TypeScript 6.0 release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html)

Verdikt: **výborná kostra a dobrý specialista pro výkon, nikoli nejlepší obecný skill**.

## 3. sickn33: `typescript-expert`

Původní URL nyní přesměrovává na `sickn33/agentic-awesome-skills`. Zdroj: [`SKILL.md` v hodnocené revizi](https://github.com/sickn33/agentic-awesome-skills/blob/5833e0fa1e5f47873b39b3727b9c66640cbeade2/skills/typescript-expert/SKILL.md).

### Silné stránky

- Jako jediný z původních kandidátů pokrývá diagnostiku projektu, monorepa, migrace, build performance a validaci.
- Nabízí konkrétní kontrolní seznam code review a praktické diagnostické příkazy.
- Snaží se nejprve přizpůsobit existujícím skriptům a konfiguraci projektu.

### Závažné problémy

- Hlavní soubor má 431 řádků a balíček obsahuje další cheatsheet, konfiguraci, knihovnu utility typů a Python diagnostiku, ale `SKILL.md` na tyto soubory nemá žádné kontextové ukazatele. Reference jsou pro běh prakticky osiřelé; hlavní soubor přitom trpí sprawlem.
- Krok 0 přikazuje práci ukončit a přepnout na `typescript-build-expert`, `typescript-module-expert` nebo `typescript-type-expert`. V hodnoceném stromu repozitáře tyto skilly nejsou. Při instalaci jediného skillu je tedy tato větev slepá.
- Validace používá `npm run typecheck || npx tsc --noEmit` a obdobně testy. Selhání projektového skriptu může být překryto úspěchem obecného fallbacku, takže dokončovací kritérium není spolehlivé.
- Diagnostický Python skript používá `grep`, `head`, `wc` a unixové přesměrování; není přenositelný na standardní Windows prostředí.
- V jednom místě doporučuje Turborepo pod 20 balíčků, v jiném pod 10. Jde o duplicitní a konfliktní rozhodovací pravidlo bez evidence.
- `satisfies` označuje jako „TS 5.0+“, ale operátor byl uveden v TypeScriptu 4.9. [Oficiální TypeScript 4.9 release notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-9.html)
- Ukázka ambientního modulu kombinuje `export default` a `export =` jako jednu deklaraci, místo aby šlo o dvě vzájemně výlučné varianty.
- Přiložená konfigurace se sama označuje jako „Strict TypeScript 5.x“ a používá `baseUrl`. TypeScript 7 již `baseUrl` nepodporuje, takže doporučená konfigurace není aktuální. [TypeScript 7.0 — odstraněné volby](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/#updates-since-5x-and-new-behaviors-from-60)

Verdikt: **příliš mnoho materiálu, slabá hierarchie a několik větví, které mohou agenta přímo odvést od dokončení**.

## 4. wshobson: `typescript-advanced-types`

Zdroj: [`SKILL.md` v hodnocené revizi](https://github.com/wshobson/agents/blob/c4b82b0ad771190355eb8e204b1329732a18449a/plugins/javascript-typescript/skills/typescript-advanced-types/SKILL.md), [detailní příklady](https://github.com/wshobson/agents/blob/c4b82b0ad771190355eb8e204b1329732a18449a/plugins/javascript-typescript/skills/typescript-advanced-types/references/details.md), [skills.sh](https://www.skills.sh/wshobson/agents/typescript-advanced-types).

### Silné stránky

- Popis je tematicky užší a má dobré triggery pro generika, conditional/mapped/template-literal typy a utility.
- Rozdělení na hlavní soubor a jeden soubor s rozpracovanými vzory je alespoň základní progresivní disclosure.
- Je srozumitelný jako výukový materiál.

### Závažné problémy

- Jde převážně o tutorial/reference bez procesu a bez ověřitelného dokončovacího kritéria. Agentovi neříká, jak prozkoumat konkrétní projekt ani jak změnu validovat jeho skripty.
- Za „advanced“ vydává dlouhé vysvětlení základních generik, `Partial`, `Pick`, `Omit` apod.; velká část hlavního souboru je pro dnešní model no-op nebo zbytečná reference.
- Vlastní pravidlo doporučuje vyhnout se `any`, ale ukázky používají `Record<string, any>` a `data: any` na několika místech.
- Typově bezpečný API client omezuje konfiguraci přes `Record<HTTPMethod, ...>`, což vyžaduje všechny deklarované HTTP metody pro každou cestu; vlastní ukázkový `EndpointConfig` však pro jednotlivé cesty definuje jen jejich podmnožinu. Ani tento hlavní „advanced pattern“ tedy v uvedené podobě nesplní svůj generic constraint. [Ukázka API clientu](https://github.com/wshobson/agents/blob/c4b82b0ad771190355eb8e204b1329732a18449a/plugins/javascript-typescript/skills/typescript-advanced-types/references/details.md), [oficiální `Record<Keys, Type>`](https://www.typescriptlang.org/docs/handbook/utility-types.html#recordkeys-type)
- Dva doporučené příklady jsem izoloval a spustil přes TypeScript 6.0.3 i aktuální TypeScript 7.0.2. V obou verzích selhaly stejně:

  ```text
  error TS2344: Type 'false' does not satisfy the constraint 'never'.
  error TS2344: Type '{}' does not satisfy the constraint 'BuilderState<T>'.
  ```

  První chyba pochází z ukázky `ExpectError<AssertEqual<string, number>>`, druhá z výchozího generického parametru `class Builder<T, S extends BuilderState<T> = {}>`.
- Definuje vlastní `ReturnType`, přestože TypeScript stejný utility type standardně poskytuje; v globálním script souboru může vzniknout kolize názvu.

Verdikt: **vysoká popularita nekompenzuje nekompilovatelné ukázky a absenci pracovního procesu**.

## Další prověřené alternativy

- [`jwynia/agent-skills: typescript-best-practices`](https://www.skills.sh/jwynia/agent-skills/typescript-best-practices) má široké pokrytí a užitečné Deno skripty, ale samotný `SKILL.md` má 358 řádků a reference i šablony představují několik tisíc dalších řádků. Je silně názorový a trpí sprawlem; oproti Jeffallanovi není predikovatelnější.
- [`lobehub/lobehub: typescript`](https://www.skills.sh/lobehub/lobehub/typescript) je krátký a udržovaný v reálném velkém TypeScript projektu. Je však záměrně projektový: vyžaduje LobeHub utility, `@lobehub/ui`, Ant Design a konkrétní importní pravidla. Je dobrým příkladem, proč projektový skill často překoná obecný, ale není vhodný ke globální instalaci mimo LobeHub.
- [`antfu/skills: antfu`](https://www.skills.sh/antfu/skills/antfu) má vysoké využití a kvalitní moderní ekosystémové konvence, ale je to preference/tooling skill pro stack Anthonyho Fu, nikoli obecný TypeScript specialista.

## Co bych zvolil podle účelu

| Účel | Volba |
|---|---|
| Jeden obecný TypeScript skill | Jeffallan `typescript-pro` |
| Komplexní generika a typové API | Jeffallan `typescript-pro`, vždy s kompilací typových testů |
| Pomalý `tsc`, declaration emit, projektové reference | pproenca `typescript`, ale bez slepé důvěry v procenta |
| Konvence konkrétního repozitáře | Vlastní projektový skill odvozený z existujícího kódu a nástrojů |
| Studium typového systému | wshobson pouze jako tutorial, ukázky průběžně kompilovat |

## Jak by vypadal skutečně nejlepší skill

Žádný z nalezených hotových kandidátů nesplňuje všechny podmínky. Nejlepší výsledek by byl malý fork/hybrid:

1. Vzít pětikrokový **type-first** proces a dokončovací kritéria z Jeffallan.
2. Zachovat jeho tabulku „Load When“, případně rozdělit reference ještě jemněji jako pproenca.
3. Nahradit univerzální zákazy rozhodovacími pravidly podle typu projektu: aplikace versus knihovna, Node versus bundler, publishovaný versus interní balíček.
4. Aktualizovat konfiguraci podle TypeScriptu 6.0/7.0 a přidat samostatné větve pro migraci 5.x → 6.0, nativní compiler 7.0 a dočasný souběh obou verzí u nástrojů závislých na compiler API.
5. Každý kódový příklad automaticky kompilovat proti podporovaným verzím TypeScriptu.
6. Spouštět detekované projektové příkazy odděleně a vyžadovat, aby každý skončil úspěšně; nespojovat selhání s generickým fallbackem přes `||`.
7. Udržet `SKILL.md` přibližně pod 120–150 řádky; podmíněné znalosti nechat za přesnými kontextovými ukazateli.

Takový vlastní skill by byl kvalitativně lepší než všechny nalezené veřejné varianty, protože by spojoval dobré řízení procesu s aktuální, testovanou a projektově podmíněnou referencí.

## Revize použité při auditu

- sickn33/agentic-awesome-skills: `5833e0fa1e5f47873b39b3727b9c66640cbeade2`
- wshobson/agents: `c4b82b0ad771190355eb8e204b1329732a18449a`
- Jeffallan/claude-skills: `e8be415bc94d8d6ebddc2fb50e5d03c6e27d4319`
- pproenca/dot-skills: `78ad92f364fe072b432903f04e2c594bf46dcdca`
- lobehub/lobehub: `c0836ad8b8fce46e7d2ab7882d26441ddcee2830`
