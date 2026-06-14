# eSSL compliance review — checklisty a převod požadavků do backlogu

## Purpose

Použij tuto rule, když potřebuješ převést normativní požadavky do review výstupu,
implementačního checklistu, backlogu nebo atestačního plánu.

## Default guidance

- Začni krátkým shrnutím situace a hned potom odděl:
  - povinnosti,
  - rizika,
  - doporučené kroky,
  - zdrojové soubory.
- Požadavky nepiš jako slepý výčet kapitol; seskup je podle dopadu na návrh nebo
  změnu systému.
- Když je odpověď určena pro backlog, převáděj požadavky do ověřitelných úkolů
  nebo checklistových bodů.
- Když je odpověď určena pro atestaci nebo audit, pojmenuj i chybějící důkazy,
  ne jen chybějící implementaci.
- Výstup drž použitelný pro vývojáře, analytika i review komentář.

## Avoid

- Nezůstávej u abstraktního „musí být v souladu se standardem“ bez konkrétního
  dopadu na návrh nebo změnu.
- Nemíchej do jednoho bodu povinnost, návrh řešení i neověřené domněnky.
- Neschovávej atestační rizika do obecného závěru na konci.
- Nezahlcuj odpověď zbytečně dlouhými citacemi místo převodu do akčních kroků.

## Review checklist

- [ ] Výstup má oddělené povinnosti, rizika a doporučené kroky.
- [ ] Checklist nebo backlog body jsou ověřitelné.
- [ ] Jsou uvedeny konkrétní zdrojové soubory.
- [ ] Je pojmenovaná atestační nebo auditní stopa, pokud je relevantní.

## Related files

- [references/atestacni-pripravenost-map.md](../references/atestacni-pripravenost-map.md)
- [templates/analyza-souladu-template.md](../templates/analyza-souladu-template.md)
- [templates/implementacni-checklist-template.md](../templates/implementacni-checklist-template.md)

## Source anchors

- `docs\martix-essl\law\Sb_2004_499_2025-01-01_IZ Zákon o archivnictví a spisové službě.md`
- `docs\martix-essl\law\Sb_2012_259_2024-07-01_IZ Vyhláška o podrobnostech výkonu spisové služby.md`
- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md`
