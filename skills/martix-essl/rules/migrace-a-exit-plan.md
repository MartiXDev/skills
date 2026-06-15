# eSSL migration — dávky, manifest a potvrzení přenosu

## Purpose

Použij tuto rule při návrhu nebo review migrace mezi eSSL, spisové rozluce,
exportních dávkách, `manifest.xml`, potvrzení přenosu a exit plánu.

## Default guidance

- Migraci posuzuj jako doménový přenos entit a metadat, ne jako prosté přesunutí
  souborů mezi úložišti.
- U každé migrační dávky explicitně popiš:
  - kontejner,
  - manifest,
  - popisy jednotlivých entit,
  - potvrzení přenosu.
- Ověř, že návrh zachovává metadata, vazby, auditní kontinuitu a možnost doložit
  úspěšné dokončení přenosu.
- Když jde o exit plán, pojmenuj i podmínky, za kterých lze odstranit zdrojová
  data.
- Obecné techniky zpracování ZIP, streamingu nebo serializace předej do
  `martix-dotnet-csharp`, pokud už nejde o normativní požadavek migrace.

## Avoid

- Nepopisuj migraci jen jako export/import bez potvrzení přenosu.
- Nevypouštěj `manifest.xml` nebo strukturu dávek z review.
- Nenechávej mazání zdrojových dat na neurčitém „po migraci“ bez kritéria
  úspěchu.
- Neztrácej auditní a metadata kontinuitu mezi starým a novým systémem.

## Review checklist

- [ ] Je popsán kontejner, manifest i přenos entit.
- [ ] Je jasné, kdy a jak se vrací potvrzení přenosu.
- [ ] Je ošetřeno, kdy lze odstranit zdrojová data.
- [ ] Je zohledněna metadata a auditní kontinuita.

## Related files

- [references/migrace-a-prenos-map.md](../references/migrace-a-prenos-map.md)
- [references/atestacni-pripravenost-map.md](../references/atestacni-pripravenost-map.md)
- [rules/skartace-ukladani-prenos-a-vyrazeni.md](./skartace-ukladani-prenos-a-vyrazeni.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV p7 Schéma XML pro migraci dat mezi elektronickými systémy spisové služby.md`
- `docs\martix-essl\standard\ermsExportPrenos.xsd`
- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` (část o přenosu, exportu a importu)
