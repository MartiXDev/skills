# eSSL intake — příjem, vady a evidence dokumentů

## Purpose

Použij tuto rule při návrhu nebo review podatelny, příjmu dokumentů, evidence,
podacích údajů, potvrzení doručení a práce s vadnými dokumenty.

## Default guidance

- Navrhuj příjem analogových i digitálních dokumentů jako auditovatelný tok, ne
  jako jednorázové „uložení souboru“.
- Zachyť datum doručení vždy; u digitálních dokumentů navíc i čas doručení s
  jemností, kterou požadují zdroje.
- U vad dokumentů rozliš:
  - co lze odstranit ve spolupráci s odesílatelem,
  - co se dále nezpracovává,
  - jak se o vadě vede evidence.
- Evidenci, podací razítko, jednoznačný identifikátor a metadata o ověření
  zajišťovacích prvků navrhuj jako dohledatelné a navázané na životní cyklus
  dokumentu.
- Pokud systém přijímá datové zprávy, uveď i pravidla pro potvrzení doručení a
  vazbu na zveřejněné podmínky podatelny.

## Avoid

- Nepřesouvej validační a evidenční odpovědnost mimo řízený tok podatelny.
- Nevypouštěj z návrhu vady dokumentu, zajišťovací prvky nebo metadata ověření.
- Nezacházej s jednoznačným identifikátorem jako s běžným interním klíčem bez
  vazby na normativní požadavky.
- Neredukuj přijetí dokumentu jen na transportní vrstvu bez evidence a stopy.

## Review checklist

- [ ] Je pokryt příjem analogových i digitálních dokumentů.
- [ ] Je jasné, jak se řeší vadné dokumenty a kdy se dále nezpracovávají.
- [ ] Je popsáno zachycení data/času doručení, identifikátoru a evidence.
- [ ] Jsou viditelné dopady na metadata a auditní stopu.

## Related files

- [references/zivotni-cyklus-dokumentu-map.md](../references/zivotni-cyklus-dokumentu-map.md)
- [references/metadata-crosswalk.md](../references/metadata-crosswalk.md)
- [rules/metadata-a-entity-model.md](./metadata-a-entity-model.md)

## Source anchors

- `docs\martix-essl\law\Sb_2012_259_2024-07-01_IZ Vyhláška o podrobnostech výkonu spisové služby.md` (`§ 2` až `§ 10`)
- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` (kapitola `2. PŘÍJEM A EVIDENCE DOKUMENTŮ`)
- `docs\martix-essl\standard\2024_85-VMV p8 Metadata entit.md`
