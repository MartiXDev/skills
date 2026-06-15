# eSSL governance — přístup, bezpečnost a transakční protokol

## Purpose

Použij tuto rule při návrhu nebo review rolí, přístupu, změn dokumentů,
znepřístupnění, ničení a auditních stop včetně transakčního protokolu.

## Default guidance

- Posuzuj správu a bezpečnost jako součást životního cyklu dokumentu, ne jako
  oddělený infrastruktuní modul bez vazby na doménu.
- Každou změnu dokumentu, znepřístupnění nebo zničení navrhuj tak, aby zůstala
  dohledatelná přes metadata nebo transakční protokol.
- U rolí a přístupu pojmenuj, kdo může:
  - číst,
  - měnit,
  - schvalovat,
  - ničit,
  - provádět správní zásahy.
- Když se review dotýká auditních dat, ověř i exportní a migrační dopady, aby se
  auditní kontinuita neztratila mimo hlavní databázi.
- Pokud je potřeba konkrétní schéma pro ztvárnění protokolu, otevři mapu auditu
  a technický artefakt až po výběru správného scénáře.

## Avoid

- Nevnímej audit jen jako aplikační log pro provozní troubleshooting.
- Nenechávej změny, znepřístupnění nebo zničení bez normativně obhajitelné stopy.
- Neredukuj správcovské zásahy na technickou administraci bez doménového významu.
- Nepřesouvej role a oprávnění čistě do obecných `.NET` bezpečnostních vzorů bez
  eSSL kontextu.

## Review checklist

- [ ] Je u citlivých operací dohledatelné kdo, kdy a proč zasáhl.
- [ ] Je auditní stopa navázaná na dokumenty, metadata nebo entity.
- [ ] Návrh pokrývá změny, zničení i znepřístupnění.
- [ ] Je zřejmý dopad na export, migraci a atestační review.

## Related files

- [references/transakcni-protokol-a-audit-map.md](../references/transakcni-protokol-a-audit-map.md)
- [references/atestacni-pripravenost-map.md](../references/atestacni-pripravenost-map.md)
- [rules/code-review-a-implementacni-dopady.md](./code-review-a-implementacni-dopady.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md` (kapitola `7. SPRÁVA A BEZPEČNOST`)
- `docs\martix-essl\standard\2024_85-VMV p6 Schéma XML pro ztvárnění transakčního protokolu.md`
- `docs\martix-essl\law\Sb_2012_259_2024-07-01_IZ Vyhláška o podrobnostech výkonu spisové služby.md` (evidence a zabezpečení evidenčních pomůcek)
