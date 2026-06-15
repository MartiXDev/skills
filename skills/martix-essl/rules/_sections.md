# Rule section contract

## Purpose

Použij tento section contract při přidávání nového rule souboru do `rules/`,
aby měl balíček stabilní tvar pro review, routing i budoucí rozšiřování.

## Section order

1. `## Purpose`
1. `## Default guidance`
1. `## Avoid`
1. `## Review checklist`
1. `## Related files`
1. `## Source anchors`

## Authoring notes

- Začni H1 nadpisem, který pojmenuje jednu konkrétní eSSL rozhodovací oblast.
- Úvodní odstavec drž úzký a rozhodovací, ne encyklopedický.
- Nejprve popiš závazný rámec a teprve potom implementační doporučení.
- Když téma zasahuje více workstreamů, udrž hlavní rule úzkou a zbytek prolinkuj
  do `references\` nebo sousední rule.
- Když dotaz už není primárně eSSL, explicitně zapiš handoff na
  `martix-dotnet-csharp`.

## Drafting prompts

- Jaké eSSL rozhodnutí musí agent udělat jako první?
- Které zdroje jsou v tomto tématu závazné a v jakém pořadí?
- Jaká chyba nejvíc hrozí pro soulad, audit nebo atestační připravenost?
- Které sousední workstreamy je potřeba prolinkovat?
