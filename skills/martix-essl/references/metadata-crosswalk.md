# Metadata crosswalk

| Entita | Kde je popsána | Klíčová metadata | Kdy otevřít |
| --- | --- | --- | --- |
| Skartační režim | Část 8 | Identifikátor, skartační lhůta, typ operace, spouštěcí událost | Navrhuješ vyřazování nebo retenční logiku |
| Věcná skupina | Část 8 + hlavní standard kap. 3 | Identifikátor, spisový znak, popis, datum otevření/uzavření, vazba na skartační režim | Navrhuješ třídění nebo plán |
| Šablona typového spisu a její součásti | Část 8 + hlavní standard kap. 3 | Identifikátory, spisový znak, vazba na nadřazenou součást, pravidla dílů | Navrhuješ typové spisy |
| Spisový a skartační plán | Část 8 + část 5 | Identifikátor, název, popis, platnost od/do, odkaz na věcné skupiny | Řešíš import/export plánu |
| Komponenta | Část 8 | Název, formát, velikost, hash, verze, zajišťovací prvky, vazby | Řešíš příjem souborů nebo SIP |
| Dokument | Část 8 + vyhláška | Identifikátor, číslo jednací, doručení, odesílatel, stručný obsah, podoba | Navrhuješ evidence a oběh |
| Spis | Část 8 | Identifikátor, vazby na dokumenty, zatřídění, stav | Řešíš workflow nebo export |
| Typový spis | Část 8 | Identifikátor, vazby, struktura součástí | Řešíš šablony a dědičnost |
| Díl typového spisu | Část 8 | Identifikátor, časové období, vazby | Řešíš periodické členění |
| Záznam ve jmenném rejstříku | Část 8 | Identifikátor subjektu, role, údaje o osobě/organizaci | Řešíš odesílatele nebo další osoby |

## Praktické guardrails

- Když navrhuješ databázi, nemapuj metadata jen podle typu sloupce; udrž i
  normativní okamžik vzniku.
- Když navrhuješ API nebo export, ověř, že metadata zůstávají přenositelná bez
  ztráty významu.
- Když review zasahuje dokument nebo komponentu, zkontroluj i vazby na další
  entity, ne jen samotný objekt.
