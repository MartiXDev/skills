# eSSL filing — spisový plán, věcné skupiny a spisy

## Purpose

Použij tuto rule při návrhu nebo review spisového a skartačního plánu, věcných
skupin, spisů, typových spisů, šablon a vazeb mezi entitami.

## Default guidance

- Navrhuj spisový plán jako doménovou osu systému, ne jako pomocnou tabulku pro
  UI.
- U věcných skupin, spisů a typových spisů vždy pojmenuj:
  - kdo vlastní identitu a zatřídění,
  - kdo dědí metadata,
  - kde je navázaný skartační režim.
- U typových spisů a šablon kontroluj, že návrh nepoškozuje budoucí export,
  skartační řízení nebo přehled o vazbách mezi entitami.
- Vysvětli, jak se projeví otevření, uzavření a vztahy nadřazenosti nebo
  podřazenosti v datovém modelu i v review scénářích.
- Když návrh řeší import/export spisového plánu, přidej i vazbu na část `5`
  standardu a příslušné schéma.

## Avoid

- Nezaměňuj věcnou skupinu, spis a typový spis za různé názvy téže entity.
- Nepřiděluj skartační režim nebo spisový znak bez vysvětlení vlastnictví.
- Nenechávej vazby mezi entitami implicitní jen v kódu nebo databázových
  foreign keys.
- Neodděluj návrh spisového plánu od budoucího exportu, migrace nebo review.

## Review checklist

- [ ] Je jasné členění věcná skupina / spis / typový spis / šablona.
- [ ] Je popsána dědičnost, vazby a skartační napojení.
- [ ] Je patrný dopad na export/import a archivní životní cyklus.
- [ ] Není zploštěna doména jen na technickou hierarchii bez významu.

## Related files

- [references/zivotni-cyklus-dokumentu-map.md](../references/zivotni-cyklus-dokumentu-map.md)
- [references/metadata-crosswalk.md](../references/metadata-crosswalk.md)
- [references/skartace-a-archivacni-predani-map.md](../references/skartace-a-archivacni-predani-map.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` (kapitoly `3. SPISOVÝ A SKARTAČNÍ PLÁN A ORGANIZACE SPISŮ` a `4. ODKAZOVÁNÍ MEZI ENTITAMI`)
- `docs\martix-essl\standard\2024_85-VMV p5 Schéma XML pro export a import spisového a skartačního plánu.md`
- `docs\martix-essl\standard\2024_85-VMV p8 Metadata entit.md`
