# eSSL integration — WS API a výměna dokumentů

## Purpose

Použij tuto rule při návrhu nebo review integračního rozhraní mezi eSSL a jiným
informačním systémem spravujícím dokumenty, zejména pro výběr `WSDL`, `XSD` a
správného integračního scénáře.

## Default guidance

- Začni tím, zda řešíš:
  - definici operací služby,
  - strukturu synchronních zpráv,
  - strukturu asynchronních zpráv,
  - společné typy a metadata.
- `WSDL` používej pro mapu služeb a vazeb; konkrétní datové struktury ověřuj v
  příslušných `XSD`.
- Když dotaz řeší metadata nebo entity, doplň i metadata crosswalk, aby
  integrace neztratila doménový význam.
- Když odpovídáš vývojáři, nejdřív uveď, **které artefakty má otevřít a proč**,
  teprve potom přecházej k implementačním detailům.
- Obecnou generaci klienta, serializaci nebo transportní pipeline předej do
  `martix-dotnet-csharp`, pokud už nejde o eSSL doménové rozhodnutí.

## Avoid

- Nezačínej hned generováním klientského kódu bez určení správného standardního
  artefaktu.
- Nezaměňuj synchronní a asynchronní struktury.
- Neodděluj API kontrakty od metadat a životního cyklu dokumentů.
- Nevysvětluj čistě obecný SOAP/.NET stack jako hlavní výstup tohoto skillu.

## Review checklist

- [ ] Je vybraný správný artefakt (`WSDL`, synchronní `XSD`, asynchronní `XSD`, společné typy).
- [ ] Je zřejmá vazba na metadata a entity.
- [ ] Je popsáno, co zůstává v martix-essl a co jde do martix-dotnet-csharp.
- [ ] Výstup ukazuje konkrétní zdrojové soubory.

## Related files

- [references/ws-api-schema-map.md](../references/ws-api-schema-map.md)
- [references/xsd-wsdl-xml-index.md](../references/xsd-wsdl-xml-index.md)
- [rules/metadata-a-entity-model.md](./metadata-a-entity-model.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV p1 Schéma XML pro výměnu dokumentů a jejich metadat (WS API).md`
- `docs\martix-essl\standard\ermsAPI.wsdl`
- `docs\martix-essl\standard\ermsIFSyn.xsd`
- `docs\martix-essl\standard\ermsIFAsyn.xsd`
- `docs\martix-essl\standard\ermsTypes.xsd`
- `docs\martix-essl\standard\ermsAsynU.xsd`
