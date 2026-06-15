# Mapa atestační připravenosti

| Kontrolní oblast | Co si položit za otázku | Primární zdroje | Typický důkaz |
| --- | --- | --- | --- |
| Příjem a evidence | Je příjem dokumentů auditovatelný a normativně správný? | Vyhláška, hlavní standard kap. 2 | Tok podatelny, metadata doručení, identifikátory |
| Metadata | Umí systém doložit povinná metadata a jejich okamžik vzniku? | Část 8, hlavní standard kap. 9 | Datový model, mapping, exportní reprezentace |
| Třídění a spisy | Odpovídá návrh věcných skupin, spisů a typových spisů standardu? | Hlavní standard kap. 3 a 4 | Model vztahů, pravidla dědičnosti |
| Skartace a uchovávání | Je doložitelná retenční logika a proces vyřazování? | Zákon, hlavní standard kap. 6 | Skartační režimy, návrhy, seznamy, protokoly |
| Audit a bezpečnost | Je dohledatelné kdo, kdy a proč provedl zásah? | Hlavní standard kap. 7, část 6 | Transakční protokol, role, auditní evidence |
| Integrace | Zachovává výměna dat metadata a doménový význam? | Část 1, metadata crosswalk | API kontrakty, mapování zpráv |
| SIP a archivní balíčky | Je archivní nebo skartační balíček vytvořen správně? | Část 2, kap. 6, část 4 | SIP/METS struktura, vazby, skartační seznamy |
| Migrace a exit plán | Lze prokázat úplný a potvrzený přenos do cílového systému? | Část 7 | Dávka, manifest, potvrzení přenosu |

## Jak tuto mapu použít

- Při design review z ní udělej checklist.
- Při code review z ní vyber jen oblasti dotčené změnou.
- Při přípravě na atestaci zkontroluj, jestli pro každou oblast existuje i
  implementace, i důkaz.
