# SIP a METS map

| Oblast | Otevři | Proč |
| --- | --- | --- |
| Účel balíčku SIP | `p2 ... SIP.md` | Určí, jestli jde o skartační nebo archivní scénář |
| Kořenový `METS` dokument | `p2 ... SIP.md` + `mets.xsd` | Drží kontejner a globální atributy |
| Popisná metadata | `p2 ... SIP.md` + `metadata-crosswalk.md` | Určí, co se do balíčku popisně promítá |
| Administrativní metadata | `p2 ... SIP.md` | Řeší provenienci, technické souvislosti a správu |
| Komponenty a soubory | `Dil.xsd` | Určí, jak reprezentovat soubory a jejich části |
| Vazby pomocí XLink | `schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml` | Řeší odkazy mezi částmi balíčku |

## Na co nezapomenout

- Neřeš SIP bez vazby na entity a metadata.
- Vždy vysvětli, k jakému účelu balíček vzniká.
- Když je v otázce i archivní nebo skartační proces, přidej
  `skartace-a-archivacni-predani-map.md`.
