# Comparison matrix template

## Purpose

Použij tuto šablonu při porovnání `martix-essl` s jiným skillem, interní
instrukcí nebo alternativním návrhovým přístupem.

## Matrix

| Schopnost | Tento balíček | Porovnání | Gap |
| --- | --- | --- | --- |
| Příklad: metadata entit | `metadata-a-entity-model` | Jiný skill / guideline | Chybějící crosswalk |

## Comparison notes

- Drž srovnání faktické a zdrojově podložené.
- Zapisuj, jestli mezera patří do `rules\`, `references\`, `templates\` nebo
  `assets\`.
- Pojmenuj, jestli jde o eSSL doménový gap nebo o čistě `.NET`/frameworkový gap.
- Když je vhodnější jiný skill, napiš i pravidlo handoffu.

*** Add File: C:\Git\MartiXDev\skills\skills\martix-essl\templates\analyza-souladu-template.md
# Šablona analýzy souladu

## Shrnutí

- Co se posuzuje
- Jaký je hlavní závěr

## Povinnosti a požadavky

| Oblast | Požadavek | Zdroj |
| --- | --- | --- |
| | | |

## Rizika nebo neshody

| Oblast | Riziko | Dopad |
| --- | --- | --- |
| | | |

## Doporučené kroky

1. 
1. 
1. 

## Chybějící důkazy nebo otevřené otázky

- 

## Zdrojové soubory

- 

*** Add File: C:\Git\MartiXDev\skills\skills\martix-essl\templates\implementacni-checklist-template.md
# Šablona implementačního checklistu

## Cíl

- Jaký modul nebo změna se připravuje

## Checklist

- [ ] Právní a standardizační požadavky jsou identifikované
- [ ] Metadata a entity mají jasné vlastnictví
- [ ] Auditní a bezpečnostní dopady jsou popsány
- [ ] Export/import nebo migrace jsou zohledněné, pokud jsou relevantní
- [ ] Handoff na `martix-dotnet-csharp` je zapsaný pro obecné technické detaily

## Rizikové body

- 

## Zdrojové soubory

- 

*** Add File: C:\Git\MartiXDev\skills\skills\martix-essl\templates\metadata-mapping-template.md
# Šablona mapování metadat

| Entita | Metadata | Okamžik vzniku | Uložení v systému | Zdroj |
| --- | --- | --- | --- | --- |
| | | | | |

## Kontrolní otázky

- Zachovává mapování význam normativního údaje?
- Je dohledatelná vazba mezi entitami?
- Neztrácí se metadata při exportu, migraci nebo změně formátu?

*** Add File: C:\Git\MartiXDev\skills\skills\martix-essl\templates\integracni-otazky-template.md
# Šablona integračních otázek

## Scénář

- Jaký systém se napojuje na eSSL
- Jaký je účel výměny

## Otázky k rozhodnutí

1. Potřebujeme `WSDL`, synchronní `XSD`, nebo asynchronní `XSD`?
1. Jaká metadata a entity se musí přenášet?
1. Jak se bude dokazovat správnost a úplnost přenosu?
1. Co je doménová část pro `martix-essl` a co obecná implementační část pro
   `martix-dotnet-csharp`?

## Zdrojové soubory

- 

*** Add File: C:\Git\MartiXDev\skills\skills\martix-essl\templates\migracni-review-template.md
# Šablona migračního review

## Shrnutí migračního scénáře

- Zdrojový systém
- Cílový systém
- Typ přenosu

## Kontrolní body

- [ ] Dávka má definovaný kontejner a `manifest.xml`
- [ ] Přenášejí se entity i metadata
- [ ] Je definováno potvrzení přenosu
- [ ] Je popsán okamžik, kdy lze odstranit zdrojová data
- [ ] Auditní a atestační kontinuita zůstává zachovaná

## Rizika

- 

## Zdrojové soubory

- 
