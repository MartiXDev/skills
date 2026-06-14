# eSSL code review — dopady změn na soulad a atestaci

## Purpose

Použij tuto rule při review konkrétní změny v kódu, návrhu nebo integrační
vrstvě, když potřebuješ odhalit eSSL dopady na metadata, audit, export/import,
životní cyklus dokumentu nebo atestační připravenost.

## Default guidance

- Review nezačínej stylem nebo syntaxí; začni otázkou, **který eSSL požadavek může
  změna zasáhnout**.
- U každé významné změny zvaž:
  - příjem a evidenci,
  - metadata a vazby,
  - role a auditní stopy,
  - skartaci, export nebo migraci,
  - atestační připravenost.
- Když komentuješ kód, napiš nejdřív doménový problém a teprve potom navrhni
  technickou opravu.
- Pokud změna odkrývá čistě obecný `.NET/C#` problém bez eSSL dopadu, předávej
  tuto část do `martix-dotnet-csharp`.
- Když chybí informace, napiš, jaký artefakt nebo důkaz je potřeba dohledat.

## Avoid

- Nezůstávej u obecných připomínek bez vazby na eSSL pravidlo nebo riziko.
- Nepřenášej review celé změny do `martix-dotnet-csharp`, pokud jsou přítomné
  eSSL dopady.
- Neignoruj auditní, metadata nebo exportní důsledky jen proto, že diff mění
  „jen službu“ nebo „jen DTO“.
- Nedělej z každé technické připomínky compliance incident bez opory ve zdrojích.

## Review checklist

- [ ] Je pojmenovaný konkrétní eSSL dopad změny.
- [ ] Komentář rozlišuje doménový problém a technickou opravu.
- [ ] Jsou zohledněny metadata, audit nebo životní cyklus, pokud jsou dotčené.
- [ ] Obecná `.NET/C#` mechanika je případně handoffnutá do martix-dotnet-csharp.

## Related files

- [rules/soulad-review-a-implementacni-checklisty.md](./soulad-review-a-implementacni-checklisty.md)
- [references/atestacni-pripravenost-map.md](../references/atestacni-pripravenost-map.md)
- [templates/implementacni-checklist-template.md](../templates/implementacni-checklist-template.md)

## Source anchors

- `docs\martix-essl\standard\2024_85-VMV národní standard pro elektronické systémy spisové služby.md`
- `docs\martix-essl\standard\2024_85-VMV p8 Metadata entit.md`
- `docs\martix-essl\standard\2024_85-VMV p6 Schéma XML pro ztvárnění transakčního protokolu.md`
