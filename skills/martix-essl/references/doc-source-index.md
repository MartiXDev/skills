# Source index a priorita zdrojů

## Jak číst zdroje

1. Začni v `docs\martix-essl\README.md`.
2. Pro právní povinnost otevři nejdřív `law\`.
3. Pro životní cyklus, pojmy a vazbu témat otevři hlavní standard.
4. Pro konkrétní integrační nebo datový formát otevři odpovídající část
   standardu a teprve potom konkrétní `WSDL`, `XSD` nebo `XML`.

## Hlavní dokumenty

| Vrstva | Soubor | Použij když | Poznámka |
| --- | --- | --- | --- |
| Index | `docs\martix-essl\README.md` | Hledáš správný vstupní bod | Nejlevnější rozcestník |
| Právní rámec | `law\Sb_2004_499_2025-01-01_IZ Zákon o archivnictví a spisové službě.md` | Řešíš povinnosti, role původce, skartační rámec, atestaci | Primární právní autorita |
| Provozní detail | `law\Sb_2012_259_2024-07-01_IZ Vyhláška o podrobnostech výkonu spisové služby.md` | Řešíš příjem, vady, evidenci, podatelnu, identifikátory | Provoznější detail než zákon |
| Globální mapa | `standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` | Potřebuješ pojmy, životní cyklus, přehled kapitol a vazeb | Nadřazený technický rozcestník |
| Část 1 | `standard\2024_85-VMV p1 Schéma XML pro výměnu dokumentů a jejich metadat (WS API).md` | Řešíš integrační rozhraní a výměnu dokumentů | Vede na WSDL a XSD artefakty |
| Část 2 | `standard\2024_85-VMV p2 Schéma XML pro vytvoření datového balíčku SIP.md` | Řešíš SIP, METS, popisná a administrativní metadata | Vede na METS/XLink |
| Část 4 | `standard\2024_85-VMV p4 Schéma XML pro skartačním řízení.md` | Řešíš skartační seznamy a rozhodnutí | Vede na `Seznam.xsd` |
| Část 5 | `standard\2024_85-VMV p5 Schéma XML pro export a import spisového a skartačního plánu.md` | Řešíš export/import spisového plánu | Vede na `SpisovyPlan.xsd` |
| Část 6 | `standard\2024_85-VMV p6 Schéma XML pro ztvárnění transakčního protokolu.md` | Řešíš auditní reprezentaci | Vede na `TransakcniLogObjektu.xsd` |
| Část 7 | `standard\2024_85-VMV p7 Schéma XML pro migraci dat mezi elektronickými systémy spisové služby.md` | Řešíš migraci, dávky, manifest, potvrzení přenosu | Vede na `ermsExportPrenos.xsd` |
| Část 8 | `standard\2024_85-VMV p8 Metadata entit.md` | Řešíš entity, metadata a jejich okamžik vzniku | Klíčový zdroj pro datový model |

## Technické artefakty

| Artefakt | Zdrojová část | Účel |
| --- | --- | --- |
| `ermsAPI.wsdl` | Část 1 | Definice operací služby |
| `ermsIFSyn.xsd` | Část 1 | Synchronní rozhraní |
| `ermsIFAsyn.xsd` | Část 1 | Asynchronní rozhraní |
| `dmBaseTypes.xsd` | Část 1 | Základní datové typy |
| `ermsTypes.xsd` | Část 1 | Společné API typy |
| `ermsAsynU.xsd` | Část 1 | Další API typy pro async scénáře |
| `mets.xsd` | Část 2 | METS kontejner |
| `Dil.xsd` | Část 2 | Části a komponenty souborů |
| `schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml` | Část 2 | XLink vazby pro SIP |
| `Seznam.xsd` | Část 4 | Skartační seznamy a rozhodnutí |
| `SpisovyPlan.xsd` | Část 5 | Spisový a skartační plán |
| `TransakcniLogObjektu.xsd` | Část 6 | Reprezentace transakčního protokolu |
| `ermsExportPrenos.xsd` | Část 7 | Migrace, export, přenos a potvrzení |
