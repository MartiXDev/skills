# eSSL metadata — entity model a metadata životního cyklu

## Purpose

Použij tuto rule při návrhu nebo review metadat, entity modelu, hlaviček
metadat, dědičnosti a mapování normativních údajů do databáze nebo API kontraktů.

## Default guidance

- Začni od entity a jejího okamžiku vzniku, ne od tabulky nebo DTO.
- U každé důležité entity pojmenuj:
  - povinná metadata,
  - kdy metadata vznikají nebo se mění,
  - jaké vazby má entita na jiné entity nebo komponenty.
- Metadata dokumentu, spisu, komponenty, rejstříku a skartačních režimů drž
  odděleně, i když jsou technicky uložena v jedné databázi.
- Když navrhuješ API nebo export, vždy ověř, že metadata lze bezeztrátově
  přenést i mimo interní model aplikace.
- Když si nejsi jistý termínem, otevři glosář nebo hlavní standard dřív, než
  začneš abstrahovat do implementační vrstvy.

## Avoid

- Nemapuj metadata jen podle pohodlí ORM nebo persistence vrstvy.
- Neztrácej informaci o okamžiku vzniku nebo změny metadata.
- Nezplošťuj vazby mezi entitami tak, že zanikne auditovatelnost nebo dědičnost.
- Nezaměňuj technické atributy artefaktů se samotnými normativními metadaty.

## Review checklist

- [ ] Je pokryto minimálně metadata dokumentu, spisu, komponenty a věcné skupiny.
- [ ] U významných údajů je popsán okamžik vzniku nebo změny.
- [ ] Jsou zřejmé vazby mezi entitami a komponentami.
- [ ] Návrh je použitelný pro export, migraci i review souladu.

## Related files

- [references/metadata-crosswalk.md](../references/metadata-crosswalk.md)
- [references/glosar-zakladnich-pojmu.md](../references/glosar-zakladnich-pojmu.md)
- [rules/sip-a-mets-balicky.md](./sip-a-mets-balicky.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV p8 Metadata entit.md`
- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` (kapitola `9. METADATA`)
- `docs\martix-essl\law\Sb_2004_499_2025-01-01_IZ Zákon o archivnictví a spisové službě.md` (definice metadat)
