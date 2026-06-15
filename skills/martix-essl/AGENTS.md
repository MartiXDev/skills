---
description: "Dlouhý companion guide pro standalone skill martix-essl"
---

# MartiX eSSL companion

- Tento soubor je dlouhý companion k [SKILL.md](./SKILL.md).
- Balíček používá vrstvený standalone-first split:
  `SKILL.md` routuje aktivaci, `AGENTS.md` drží delší playbooky a handoffy,
  `rules\*.md` nesou atomické guidance, `references\*.md` mapují zdroje a
  `templates\*.md` plus `assets\*.json` drží balíček udržovatelný.
- Začni nejbližším workstreamem a rozšiřuj kontext jen tehdy, když scénář
  opravdu překračuje jednu oblast.

## Cost-aware routing

| Work | Tier |
| --- | --- |
| Ambiguous compliance planning, atestace, high-risk review | `premium` |
| Package-local implementation and standard review | `medium` |
| Validation, JSON sync, markdown cleanup | `cheap` |

## Package inventory

| Vrstva | Účel | Klíčové soubory |
| --- | --- | --- |
| Discovery | Aktivace a výběr workstreamu | [SKILL.md](./SKILL.md) |
| Companion | Delší review route, handoffy, údržba | [AGENTS.md](./AGENTS.md) |
| Rules | Atomická eSSL rozhodovací guidance | [rules/_sections.md](./rules/_sections.md) |
| References | Mapy zdrojů, crosswalky, glosář, schémata | [references/doc-source-index.md](./references/doc-source-index.md) |
| Templates | Checklisty, metadata mapping, review skeletony | [templates/implementacni-checklist-template.md](./templates/implementacni-checklist-template.md) |
| Assets | Taxonomie a preferované pořadí | [assets/taxonomy.json](./assets/taxonomy.json), [assets/section-order.json](./assets/section-order.json) |
| Metadata | Inventory, distribuce a handoff policy | [metadata.json](./metadata.json) |

## Working stance

- Považuj zákon, vyhlášku a národní standard za **trojvrstvý závazný rámec**:
  - zákon určuje povinnosti a právní pojmy,
  - vyhláška určuje provozní detail výkonu spisové služby,
  - národní standard určuje technické a datové chování eSSL.
- Hlavní standard používej jako mapu životního cyklu a vazbu na technické
  přílohy, ne jako jediný zdroj pravdy.
- Když review zasahuje návrh nebo kód, vždy pojmenuj:
  - jaký je dotčený požadavek,
  - jaká je implementační stopa,
  - jaké je riziko pro atestaci nebo auditovatelnost.
- Neřeš tady čistě obecné `.NET/C#` mechaniky, pokud už nejsou přímo nosičem
  eSSL rozhodnutí. V takovém případě proveď handoff na `martix-dotnet-csharp`.

## Kritické package facts

- `docs\martix-essl\README.md` je nejlevnější vstupní mapa zdrojů.
- Hlavní standard pokrývá celý životní cyklus dokumentů, metadata, správu,
  bezpečnost i rozhraní.
- Části `1`, `2`, `4`, `5`, `6`, `7` a `8` standardu mají přímý dopad na
  integrační a datové chování systému.
- Atestační připravenost není jedna kapitola; vzniká z konzistentního chování
  evidence, metadat, auditních stop, export/importu, přístupu a uchovávání.
- `martix-essl` vlastní eSSL expertízu; `martix-dotnet-csharp` vlastní obecné
  jazykové a frameworkové mechaniky.

## Workstream playbook

### Scope, zdroje a handoffy

- Otevři při rozhodování, co je závazný zdroj, kde končí eSSL scope a kdy už má
  nastat handoff.
- Začni s [foundation-scope-a-zdroje](./rules/foundation-scope-a-zdroje.md).
- Přidej [doc-source-index](./references/doc-source-index.md) a
  [pravni-ramec-a-povinnosti-map](./references/pravni-ramec-a-povinnosti-map.md).
- Review questions:
  - Je otázka primárně o eSSL, nebo už spíš o obecném `.NET` návrhu?
  - Je jasné, co je zákonná povinnost, co provozní detail a co technický
    standard?
  - Má odpověď dost stop pro pozdější audit nebo atestaci?

### Příjem, evidence a vady dokumentů

- Otevři při návrhu podatelny, doručení, validace, identifikátorů a evidencí.
- Začni s
  [prijem-evidence-a-vady-dokumentu](./rules/prijem-evidence-a-vady-dokumentu.md).
- Přidej [zivotni-cyklus-dokumentu-map](./references/zivotni-cyklus-dokumentu-map.md).
- Review questions:
  - Je pokryt příjem analogových i digitálních dokumentů?
  - Je jasné, kdy se dokument dál nezpracovává a jak se vada komunikuje?
  - Zůstávají identifikátory, časové údaje a ověření zajišťovacích prvků
    dohledatelné?

### Spisový plán, věcné skupiny a spisy

- Otevři při třídění, návrhu věcných skupin, typových spisů a vazeb.
- Začni s
  [spisovy-plan-vecne-skupiny-a-spisy](./rules/spisovy-plan-vecne-skupiny-a-spisy.md).
- Přidej [zivotni-cyklus-dokumentu-map](./references/zivotni-cyklus-dokumentu-map.md).
- Review questions:
  - Je jasné, která entita vlastní zatřídění a skartační režim?
  - Jsou popsány vazby mezi věcnou skupinou, spisem, typovým spisem a šablonou?
  - Neztrácí se při návrhu přehled o budoucím exportu nebo archivním předání?

### Metadata a entity

- Otevři při návrhu datového modelu, mapování metadat a dědičnosti.
- Začni s [metadata-a-entity-model](./rules/metadata-a-entity-model.md).
- Přidej [metadata-crosswalk](./references/metadata-crosswalk.md) a
  [glosar-zakladnich-pojmu](./references/glosar-zakladnich-pojmu.md).
- Review questions:
  - Je jasné, která metadata vznikají při příjmu, změně, vyřízení nebo zničení?
  - Nechybí vztahy mezi dokumentem, spisem, komponentou a rejstříkem?
  - Je oddělená normativní povinnost od interní implementační reprezentace?

### Skartace, ukládání, export a přenos

- Otevři při práci se skartačními režimy, lhůtami, návrhy, exportem a
  archivním předáním.
- Začni s
  [skartace-ukladani-prenos-a-vyrazeni](./rules/skartace-ukladani-prenos-a-vyrazeni.md).
- Přidej [skartace-a-archivacni-predani-map](./references/skartace-a-archivacni-predani-map.md)
  a [atestacni-pripravenost-map](./references/atestacni-pripravenost-map.md).
- Review questions:
  - Je jasné, které dokumenty jdou do skartačního řízení a které mimo něj?
  - Umí návrh doložit export, přenos a potvrzení přejímky?
  - Je zajištěno, že životní cyklus dokumentu nekončí „smazáním bez stopy“?

### Správa, bezpečnost a transakční protokol

- Otevři při rolích, přístupu, změnách dokumentů, znepřístupnění a auditních
  stopách.
- Začni s
  [sprava-bezpecnost-a-transakcni-protokol](./rules/sprava-bezpecnost-a-transakcni-protokol.md).
- Přidej [transakcni-protokol-a-audit-map](./references/transakcni-protokol-a-audit-map.md).
- Review questions:
  - Lze dohledat kdo, kdy a proč změnil nebo zničil dokument?
  - Neztrácí systém auditní stopu při exportu, migraci nebo opravách?
  - Je kontrola přístupů a správcovských zásahů viditelná pro pozdější review?

### WS API a výměna dokumentů

- Otevři při integračních návrzích, mapování operací a validaci schémat.
- Začni s [ws-api-a-vymena-dokumentu](./rules/ws-api-a-vymena-dokumentu.md).
- Přidej [ws-api-schema-map](./references/ws-api-schema-map.md) a
  [xsd-wsdl-xml-index](./references/xsd-wsdl-xml-index.md).
- Review questions:
  - Je vybrané správné rozhraní a artefakt (`WSDL`, synchronní nebo asynchronní
    `XSD`)?
  - Odpovídá návrh požadovaným metadatům a vazbám na entity?
  - Není řešena obecná `.NET` integrace bez eSSL kontextu?

### SIP, METS a datové balíčky

- Otevři při archivních balíčcích, popisných a administrativních metadatech.
- Začni s [sip-a-mets-balicky](./rules/sip-a-mets-balicky.md).
- Přidej [sip-mets-map](./references/sip-mets-map.md).
- Review questions:
  - Je jasné, jaká metadata vstupují do `METS` a která jdou do jiných vrstev?
  - Nezaměňuje návrh SIP pro skartační řízení s archivním předáním?
  - Jsou vazby mezi entitami a komponentami dohledatelné?

### Migrace a exit plán

- Otevři při přechodu mezi eSSL, spisové rozluce nebo návrhu přenosových dávek.
- Začni s [migrace-a-exit-plan](./rules/migrace-a-exit-plan.md).
- Přidej [migrace-a-prenos-map](./references/migrace-a-prenos-map.md).
- Review questions:
  - Je dávka korektně strukturovaná a opřená o `manifest.xml`?
  - Je popsáno potvrzení úspěšného přenosu i moment, kdy lze zdrojová data
    odstranit?
  - Zachovávají se metadata a auditní informace při migraci?

### Soulad, checklisty a code review

- Otevři při tvorbě backlogu, auditního checklistu nebo při review konkrétní
  změny.
- Začni s
  [soulad-review-a-implementacni-checklisty](./rules/soulad-review-a-implementacni-checklisty.md)
  nebo [code-review-a-implementacni-dopady](./rules/code-review-a-implementacni-dopady.md).
- Přidej [atestacni-pripravenost-map](./references/atestacni-pripravenost-map.md).
- Review questions:
  - Je změna zhodnocena proti povinnostem, metadatům, auditním stopám a exportu?
  - Je výstup použitelný pro vývojářský backlog nebo code review komentář?
  - Je jasné, co ještě patří do `martix-dotnet-csharp`?

## Common review routes

| Scenario | Start with | Then add |
| --- | --- | --- |
| Nový modul eSSL od nuly | [foundation-scope-a-zdroje](./rules/foundation-scope-a-zdroje.md) | [soulad-review-a-implementacni-checklisty](./rules/soulad-review-a-implementacni-checklisty.md), [zivotni-cyklus-dokumentu-map](./references/zivotni-cyklus-dokumentu-map.md) |
| Příjem datových zpráv a evidence | [prijem-evidence-a-vady-dokumentu](./rules/prijem-evidence-a-vady-dokumentu.md) | [metadata-a-entity-model](./rules/metadata-a-entity-model.md), [metadata-crosswalk](./references/metadata-crosswalk.md) |
| Návrh metadat a entit | [metadata-a-entity-model](./rules/metadata-a-entity-model.md) | [glosar-zakladnich-pojmu](./references/glosar-zakladnich-pojmu.md), [metadata-crosswalk](./references/metadata-crosswalk.md) |
| Integrace přes WS API | [ws-api-a-vymena-dokumentu](./rules/ws-api-a-vymena-dokumentu.md) | [xsd-wsdl-xml-index](./references/xsd-wsdl-xml-index.md), [martix-dotnet-csharp] pro generickou implementační mechaniku |
| SIP nebo archivní balíček | [sip-a-mets-balicky](./rules/sip-a-mets-balicky.md) | [metadata-crosswalk](./references/metadata-crosswalk.md), [skartace-a-archivacni-predani-map](./references/skartace-a-archivacni-predani-map.md) |
| Migrace nebo exit plán | [migrace-a-exit-plan](./rules/migrace-a-exit-plan.md) | [sprava-bezpecnost-a-transakcni-protokol](./rules/sprava-bezpecnost-a-transakcni-protokol.md), [atestacni-pripravenost-map](./references/atestacni-pripravenost-map.md) |
| Code review změny | [code-review-a-implementacni-dopady](./rules/code-review-a-implementacni-dopady.md) | [soulad-review-a-implementacni-checklisty](./rules/soulad-review-a-implementacni-checklisty.md), [martix-dotnet-csharp] pro čistě jazykové nebo frameworkové připomínky |

## Source boundaries

- Primární autorita je lokální zdrojový korpus v `docs\martix-essl\`.
- `law\` drží právní rámec a povinnosti.
- Hlavní standard drží glosář, životní cyklus a vazbu na technické části.
- Části standardu `1`, `2`, `4`, `5`, `6`, `7` a `8` drží technické detaily a
  schémata.
- Extrahované `WSDL`, `XSD` a `XML` artefakty používej přes reference mapy,
  ne jako první čtený soubor bez kontextu.

## Parallel guidance

- Drž práci package-local, pokud nemusíš měnit sdílené registry nebo marketplace.
- U větších revizí rozděluj práci podle workstreamů, ne podle náhodných souborů.
- Před merge vždy spusť markdown check a repository validation.
