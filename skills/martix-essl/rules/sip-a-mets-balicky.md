# eSSL SIP — METS, popisná metadata a datové balíčky

## Purpose

Použij tuto rule při návrhu nebo review datových balíčků `SIP`, `METS`,
popisných a administrativních metadat a vazeb mezi entitami a komponentami v
balíčku.

## Default guidance

- Neřeš SIP jako „zip se soubory“; řeš jej jako normativně strukturovaný balíček
  s metadaty, vazbami a účelem.
- Vždy rozliš:
  - roli kořenového `METS` dokumentu,
  - popisná metadata,
  - administrativní metadata,
  - komponenty a jejich vazby,
  - účel balíčku pro skartační řízení nebo archivní předání.
- Když review zasahuje metadata entit, otevři i metadata crosswalk, aby balíček
  zůstal věrný doménovým údajům.
- Při návrhu výstupu popiš, které vazby musí zůstat zachované mezi dokumentem,
  spisem, komponentou a případnými dalšími entitami.

## Avoid

- Neredukuj SIP na export souborů bez popisných a administrativních metadat.
- Nezaměňuj účel balíčku pro skartační řízení s archivním předáním.
- Neignoruj strukturální mapu, odkazy nebo mapování komponent.
- Neřeš jen technickou serializaci bez vazby na normativní význam balíčku.

## Review checklist

- [ ] Je vysvětlená role `METS`, popisných i administrativních metadat.
- [ ] Jsou popsány vazby mezi entitami a komponentami.
- [ ] Je zřejmé, pro jaký účel se balíček vytváří.
- [ ] Odpověď ukazuje konkrétní zdrojové soubory nebo schémata.

## Related files

- [references/sip-mets-map.md](../references/sip-mets-map.md)
- [references/metadata-crosswalk.md](../references/metadata-crosswalk.md)
- [references/xsd-wsdl-xml-index.md](../references/xsd-wsdl-xml-index.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV p2 Schéma XML pro vytvoření datového balíčku SIP.md`
- `docs\martix-essl\standard\mets.xsd`
- `docs\martix-essl\standard\Dil.xsd`
- `docs\martix-essl\standard\schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml`
- `docs\martix-essl\standard\2024_85-VMV p8 Metadata entit.md`
