# eSSL foundation — scope, zdroje a handoffy

## Purpose

Použij tuto rule, když potřebuješ rozhodnout, který zdroj je v dané otázce
závazný, jak široký je eSSL scope a kdy už má nastat handoff mimo tento skill.

## Default guidance

- Začni v `docs\martix-essl\README.md`, abys zvolil nejmenší potřebnou sadu
  zdrojů.
- Rozliš tři vrstvy autority:
  - zákon `499/2004 Sb.` pro právní povinnosti a pojmy,
  - vyhláška `259/2012 Sb.` pro provozní detail výkonu spisové služby,
  - Národní standard eSSL pro technické a datové chování systému.
- Když odpovídáš na návrh nebo review, vždy explicitně odděl:
  - co je závazný požadavek,
  - co je doporučený implementační způsob,
  - co je riziko nebo neprokázaná oblast.
- Když téma zasahuje atestaci, audit, metadata, export/import, identifikátory
  nebo životní cyklus dokumentu, pojmenuj dopad na atestační připravenost hned v
  úvodu.
- Když už dotaz není primárně o eSSL, předej obecné `.NET/C#` mechaniky do
  `martix-dotnet-csharp` a nech v martix-essl jen doménové guardrails.

## Avoid

- Nevydávej národní standard za náhradu zákona nebo vyhlášky.
- Nezaměňuj právní výklad za čistě technické doporučení bez označení hranice.
- Nenatahuj tento skill na obecné `.NET` návrhové vzory bez eSSL kontextu.
- Neotvírej konkrétní `XSD` nebo `WSDL` bez předchozího určení správné mapy nebo
  workstreamu.

## Review checklist

- [ ] Je jasné, které vrstvy zdrojů jsou pro odpověď rozhodující.
- [ ] Je explicitně pojmenovaná hranice mezi závazným požadavkem a doporučením.
- [ ] Je popsán dopad na atestaci nebo audit, pokud je relevantní.
- [ ] Je případný handoff na `martix-dotnet-csharp` výslovný.

## Related files

- [references/doc-source-index.md](../references/doc-source-index.md)
- [references/pravni-ramec-a-povinnosti-map.md](../references/pravni-ramec-a-povinnosti-map.md)
- [references/atestacni-pripravenost-map.md](../references/atestacni-pripravenost-map.md)

## Source anchors

- `docs\martix-essl\README.md`
- `docs\martix-essl\law\Sb_2004_499_2025-01-01_IZ Zákon o archivnictví a spisové službě.md`
- `docs\martix-essl\law\Sb_2012_259_2024-07-01_IZ Vyhláška o podrobnostech výkonu spisové služby.md`
- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md`
