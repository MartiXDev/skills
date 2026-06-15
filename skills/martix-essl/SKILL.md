---
name: martix-essl
description: >-
  Český standalone-first skill pro návrh, implementaci, code review a
  atestační připravenost elektronických systémů spisové služby podle zákona
  499/2004 Sb., vyhlášky 259/2012 Sb. a Národního standardu eSSL. Použij tento
  skill vždy, když uživatel řeší eSSL, spisovou službu, metadata entit, spisy,
  skartační režimy, SIP/METS, WS API, migraci, transakční protokol, atestaci
  nebo chce posoudit .NET řešení vůči českým eSSL pravidlům, i když se ptá
  hlavně na architekturu, review nebo kód.
license: Complete terms in LICENSE.txt
---

# MartiX eSSL router

- Použij tento skill pro **doménovou a compliance expertízu eSSL**.
- Převáděj právní a standardizační požadavky do návrhu, implementačních
  rozhodnutí, code review a checklistů.
- Drž odpověď stručnou, ale neschovávej rizika, povinnosti ani nejasnosti.
- Když už dotaz není primárně o eSSL, atestaci, metadatech, životním cyklu
  dokumentu nebo standardizačních schématech, předej obecné .NET/C# mechaniky
  do `martix-dotnet-csharp`.

## Kdy tento skill použít

- Navrhuješ nebo reviduješ vlastní eSSL řešení v `.NET 10+`.
- Potřebuješ vyložit požadavek ze zákona, vyhlášky nebo národního standardu a
  převést ho do implementačních kroků.
- Řešíš příjem dokumentů, evidenci, metadata, věcné skupiny, typové spisy,
  skartační režimy, export/import, přenos, audit nebo bezpečnost.
- Potřebuješ pracovat s částmi standardu pro `WS API`, `SIP/METS`, migraci,
  transakční protokol nebo entity metadata.
- Děláš code review a chceš zkontrolovat, že změna nepoškozuje eSSL soulad ani
  atestační připravenost.

## Kdy tento skill nepoužít

- Dotaz je čistě o obecném `.NET`, `C#`, `ASP.NET Core`, DI, výkonu nebo test
  frameworku bez jasné eSSL vazby.
- Uživatel chce formální právní stanovisko místo technického a doménového
  vysvětlení.
- Téma patří do jiného MartiX skillu a eSSL je jen okrajová zmínka.

## Výchozí pracovní režim

1. Urči, zda jde hlavně o **soulad**, **návrh**, **integraci**, nebo
   **review změny**.
2. Otevři nejmenší relevantní `rule` a k ní jednu odpovídající `reference`.
3. Odpověz tak, aby bylo zřejmé:
   - co je normativní požadavek,
   - co je implementační doporučení,
   - co je riziko nebo chybějící důkaz,
   - které zdroje to podpírají.
4. Pokud je potřeba, doporuč další krok nebo handoff na
   `martix-dotnet-csharp`.

## Preferovaný tvar odpovědi

Použij podle situace co nejmenší užitečný formát:

- **Compliance / review:** `Shrnutí`, `Požadavky`, `Rizika`, `Doporučené kroky`,
  `Zdrojové soubory`
- **Návrh řešení:** `Cíl`, `Dopady eSSL`, `Doporučený návrh`, `Otevřené otázky`,
  `Zdrojové soubory`
- **Rychlá orientace ve zdrojích:** `Krátká odpověď`, `Kde to hledat`,
  `Co ověřit dál`

## Začni nejbližším workstreamem

| Workstream | Použij když | Otevři |
| --- | --- | --- |
| Scope, zdroje a handoffy | Potřebuješ rozhodnout, co je závazný zdroj, jaký je scope skillu nebo jestli už má nastat handoff | [rules/foundation-scope-a-zdroje.md](./rules/foundation-scope-a-zdroje.md), [references/doc-source-index.md](./references/doc-source-index.md), [references/pravni-ramec-a-povinnosti-map.md](./references/pravni-ramec-a-povinnosti-map.md) |
| Příjem, evidence a vady dokumentů | Řešíš podatelnu, doručení, validaci, podací razítko, identifikátory, základní nebo samostatnou evidenci | [rules/prijem-evidence-a-vady-dokumentu.md](./rules/prijem-evidence-a-vady-dokumentu.md), [references/zivotni-cyklus-dokumentu-map.md](./references/zivotni-cyklus-dokumentu-map.md) |
| Spisový plán, věcné skupiny a spisy | Navrhuješ zatřiďování, věcné skupiny, typové spisy, šablony, vazby a spisový plán | [rules/spisovy-plan-vecne-skupiny-a-spisy.md](./rules/spisovy-plan-vecne-skupiny-a-spisy.md), [references/zivotni-cyklus-dokumentu-map.md](./references/zivotni-cyklus-dokumentu-map.md) |
| Metadata a entity | Potřebuješ mapovat metadata dokumentu, spisu, komponenty, rejstříku nebo skartačních režimů | [rules/metadata-a-entity-model.md](./rules/metadata-a-entity-model.md), [references/metadata-crosswalk.md](./references/metadata-crosswalk.md), [references/glosar-zakladnich-pojmu.md](./references/glosar-zakladnich-pojmu.md) |
| Skartace, ukládání, export a přenos | Řešíš skartační režimy, skartační řízení, archivní předání, export nebo import | [rules/skartace-ukladani-prenos-a-vyrazeni.md](./rules/skartace-ukladani-prenos-a-vyrazeni.md), [references/skartace-a-archivacni-predani-map.md](./references/skartace-a-archivacni-predani-map.md), [references/atestacni-pripravenost-map.md](./references/atestacni-pripravenost-map.md) |
| Správa, bezpečnost a audit | Potřebuješ řešit role, přístup, znepřístupnění, ničení dokumentů nebo transakční protokol | [rules/sprava-bezpecnost-a-transakcni-protokol.md](./rules/sprava-bezpecnost-a-transakcni-protokol.md), [references/transakcni-protokol-a-audit-map.md](./references/transakcni-protokol-a-audit-map.md) |
| WS API a výměna dokumentů | Navrhuješ integrační rozhraní, synchronní/asynchronní operace a práci s WSDL/XSD | [rules/ws-api-a-vymena-dokumentu.md](./rules/ws-api-a-vymena-dokumentu.md), [references/ws-api-schema-map.md](./references/ws-api-schema-map.md), [references/xsd-wsdl-xml-index.md](./references/xsd-wsdl-xml-index.md) |
| SIP a METS | Stavíš datový balíček SIP, popisná metadata, METS nebo XLink vazby | [rules/sip-a-mets-balicky.md](./rules/sip-a-mets-balicky.md), [references/sip-mets-map.md](./references/sip-mets-map.md), [references/xsd-wsdl-xml-index.md](./references/xsd-wsdl-xml-index.md) |
| Migrace a exit plán | Řešíš migraci mezi eSSL, spisovou rozluku, dávky ZIP, manifest nebo potvrzení přenosu | [rules/migrace-a-exit-plan.md](./rules/migrace-a-exit-plan.md), [references/migrace-a-prenos-map.md](./references/migrace-a-prenos-map.md) |
| Soulad a implementační checklist | Potřebuješ převést požadavky do backlogu, review checklistu nebo atestačního plánu | [rules/soulad-review-a-implementacni-checklisty.md](./rules/soulad-review-a-implementacni-checklisty.md), [references/atestacni-pripravenost-map.md](./references/atestacni-pripravenost-map.md) |
| Code review dopadů | Posuzuješ konkrétní změnu v kódu nebo návrhu a chceš odhalit eSSL dopady | [rules/code-review-a-implementacni-dopady.md](./rules/code-review-a-implementacni-dopady.md), [references/atestacni-pripravenost-map.md](./references/atestacni-pripravenost-map.md), [AGENTS.md](./AGENTS.md) |

## Rychlé referenční plochy

- [Source index](./references/doc-source-index.md)
- [Právní rámec a povinnosti](./references/pravni-ramec-a-povinnosti-map.md)
- [Životní cyklus dokumentu](./references/zivotni-cyklus-dokumentu-map.md)
- [Metadata crosswalk](./references/metadata-crosswalk.md)
- [Index schémat](./references/xsd-wsdl-xml-index.md)
- [Mapa atestační připravenosti](./references/atestacni-pripravenost-map.md)

## Konvence balíčku

- `SKILL.md` routuje; detail drž v `rules\` a `references\`.
- `AGENTS.md` používej pro delší review route, maintainer guidance a handoffy.
- Když potřebuješ vysvětlit termín, raději odkaž na glosář než načítat celý
  hlavní standard.
- Když potřebuješ technický artefakt, otevři nejdřív jeho mapu a teprve pak
  konkrétní `WSDL`, `XSD` nebo `XML`.
