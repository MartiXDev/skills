# WS API schema map

| Artefakt | Role | Otevři když | Poznámka |
| --- | --- | --- | --- |
| `ermsAPI.wsdl` | Definice operací a vazeb služby | Potřebuješ mapu služeb a operací | Neobsahuje detail všech datových struktur |
| `ermsIFSyn.xsd` | Synchronní rozhraní | Řešíš request/response struktury synchronních volání | Používej po výběru operace |
| `ermsIFAsyn.xsd` | Asynchronní rozhraní | Řešíš async scénáře nebo fronty | Odděluj od synchronní vrstvy |
| `dmBaseTypes.xsd` | Základní typy | Potřebuješ společné typové základy | Často podpůrný zdroj |
| `ermsTypes.xsd` | Společné API typy | Řešíš metadata nebo common structures | Doplněk ke konkrétní operaci |
| `ermsAsynU.xsd` | Async API typy | Řešíš rozšíření asynchronních struktur | Neotevírej bez async kontextu |

## Doporučené pořadí čtení

1. `p1 ... (WS API).md`
2. `ermsAPI.wsdl`
3. `ermsIFSyn.xsd` nebo `ermsIFAsyn.xsd`
4. `ermsTypes.xsd` a `dmBaseTypes.xsd`
5. `metadata-crosswalk.md`, pokud se dotaz dotýká doménových údajů
