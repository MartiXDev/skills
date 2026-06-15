# Migrace a přenos map

| Krok | Zdroj | Artefakt | Poznámka |
| --- | --- | --- | --- |
| Struktura dávky | Část 7 | `ermsExportPrenos.xsd` | ZIP kontejner, manifest, entity |
| Manifest | Část 7 | `manifest.xml` s kořenovým elementem `Davka` | Musí být validní vůči schématu |
| Popis entity | Část 7 | Dokument s kořenovým elementem `Export` | Jedna entita = jeden XML popis |
| Potvrzení přenosu | Část 7 | `PrenosPotvrzeni` | Potvrzuje úspěšný a kompletní přenos |
| Mazání zdrojových dat | Část 7 | — | Až po potvrzení kompletního přenosu |

## Typické review chyby

- Migrace bez explicitního potvrzení přenosu.
- Dávka bez jasné role `manifest.xml`.
- Přenos souborů bez přenosu vazeb a metadat.
- Exit plán bez pravidla, kdy je dovoleno odstranit původní data.
