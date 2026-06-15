# eSSL retention — skartační režimy, ukládání a předání

## Purpose

Použij tuto rule při návrhu nebo review skartačních režimů, ukládání dokumentů,
skartačního řízení, archivního předání, exportu, importu a přenosu.

## Default guidance

- Rozlišuj mezi:
  - běžným uložením a uchováváním dokumentu,
  - skartačním řízením,
  - výběrem archiválií mimo skartační řízení,
  - exportem, importem a přenosem.
- Skartační režimy, lhůty a spouštěcí události navrhuj jako vysvětlitelnou
  doménovou logiku, ne jako nepopsaný set jobů nebo datových flagů.
- Při review vždy ověř, že systém dokáže doložit:
  - proč dokument zůstal uložen,
  - proč a kdy šel do vyřazení,
  - jak bylo provedeno předání nebo zničení.
- Když se mluví o archivním předání nebo skartačním seznamu, otevři i mapu
  schémat a související normativní část standardu.
- Každý návrh ukládání nebo vyřazování posuzuj i z pohledu atestace.

## Avoid

- Nespojuj skartaci se „smazáním po TTL“ bez doménové stopy a protokolace.
- Nepřesouvej rozhodování o skartačním režimu do skrytých interních heuristik.
- Nezaměňuj export, přenos a potvrzení přejímky za jeden technický krok.
- Nevypouštěj archivní předání, seznamy ani výsledné protokoly z review.

## Review checklist

- [ ] Je jasné, kdo a kdy nastavuje skartační režim a lhůtu.
- [ ] Návrh pokrývá skartační řízení nebo výběr archiválií mimo něj.
- [ ] Jsou viditelné exportní, přenosové a archivní stopy.
- [ ] Je pojmenovaný dopad na atestační připravenost.

## Related files

- [references/skartace-a-archivacni-predani-map.md](../references/skartace-a-archivacni-predani-map.md)
- [references/atestacni-pripravenost-map.md](../references/atestacni-pripravenost-map.md)
- [rules/migrace-a-exit-plan.md](./migrace-a-exit-plan.md)

## Source anchors

- `docs\martix-essl\law\Sb_2004_499_2025-01-01_IZ Zákon o archivnictví a spisové službě.md` (`§ 7` až `§ 11`)
- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` (kapitola `6. UKLÁDÁNÍ A VYŘAZOVÁNÍ DOKUMENTŮ`)
- `docs\martix-essl\standard\2024_85-VMV p4 Schéma XML pro skartačním řízení.md`
- `docs\martix-essl\standard\2024_85-VMV p5 Schéma XML pro export a import spisového a skartačního plánu.md`
