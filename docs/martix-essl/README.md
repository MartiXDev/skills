# Dokumentace martix-essl

## Přehled

Tato složka obsahuje **české právní a technické standardy pro elektronické systémy spisové služby** (e-SSLS — elektronické systémy spisové služby), převedené z dokumentů Microsoft Word (.docx) do formátu Markdown pro snadné odkazování a integraci do budoucích vývojových sezení.

### Obsah

- **Právní rámec** (2 soubory): Zákon 499/2004 a Vyhláška 259/2012
- **Technický standard** (8 souborů): Národní standard 2024/85-VMV se 7 detailními částmi
- **Extrahované technické artefakty** (13 souborů): Schémata WSDL a XSD extrahovaná z vložených specifikací

**Jazyk:** Čeština
**Datum převodu:** Červen 2025
**Formát:** UTF-8 Markdown s čistými tabulkami Markdown
**Cílová skupina:** Implementátoři systémů, architekti, vývojáři, LLM sezení

---

## Rychlá navigace

### Pro právní a regulační požadavky

Viz složka [`law/`](law/) pro české zákony a vyhlášky:

- **Zákon 499/2004** — Základ pro archivnictví a spisovou službu
- **Vyhláška 259/2012** — Podrobné pravidla výkonu

### Pro technickou implementaci

Viz složka [`standard/`](standard/) pro části Národního standardu:

- **Část 1** — Schémata WS API pro výměnu dokumentů
- **Část 2** — SIP (Submission Information Package) a metadata METS
- **Část 4** — Schémata skartačních rozhodnutí
- **Část 5** — Import/export spisového a skartačního plánu
- **Část 6** — Reprezentace transakčního protokolu
- **Část 7** — Migrace dat mezi systémy
- **Část 8** — Definice metadat entit

### Pro schémata XML/WSDL/XSD

Viz níže uvedená sekce **Extrahované technické artefakty** pro mapování všech 13 souborů schémat na zdrojové dokumenty.

---

## Právní dokumenty (složka `law/`)

| Název souboru | Zkratka | Zaměření obsahu | Klíčové sekce |
| --- | --- | --- | --- |
| `Sb_2004_499_2025-01-01_IZ Zákon o archivnictví a spisové službě.md` | Zákon 499/2004 | Zákon o archivnictví a spisové službě | HLAVA I–VI: Základní pojmy, archivnictví, archivy, spisová služba, správa, vynucování |
| `Sb_2012_259_2024-07-01_IZ Vyhláška o podrobnostech výkonu spisové služby.md` | Vyhláška 259/2012 | Podrobnosti výkonu spisové služby | Přijetí dokumentů, evidence, manipulace, vady dokumentů, skartační řízení |

Oba dokumenty jsou v platnosti a tvoří právní základ pro všechny elektronické systémy spisové služby v České republice.

---

## Technické standardní dokumenty (složka `standard/`)

| Název souboru | Část | Účel | Primární schémata |
| --- | --- | --- | --- |
| `2024_85-VMV národní standard pro elektronické systémy spisové služby.md` | — | Rámec a slovník | — |
| `2024_85-VMV p1 Schéma XML pro výměnu dokumentů a jejich metadat (WS API).md` | **Část 1** | WS API pro výměnu dokumentů a metadata | `ermsAPI.wsdl`, `ermsIFSyn.xsd`, `ermsIFAsyn.xsd`, `dmBaseTypes.xsd`, `ermsTypes.xsd`, `ermsAsynU.xsd` |
| `2024_85-VMV p2 Schéma XML pro vytvoření datového balíčku SIP.md` | **Část 2** | Vytvoření SIP s metadaty METS | `mets.xsd`, `Dil.xsd`, `schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml` |
| `2024_85-VMV p4 Schéma XML pro skartačním řízení.md` | **Část 4** | Skartační rozhodnutí a přijetí do archivu | `Seznam.xsd` |
| `2024_85-VMV p5 Schéma XML pro export a import spisového a skartačního plánu.md` | **Část 5** | Export a import spisového a skartačního plánu | `SpisovyPlan.xsd` |
| `2024_85-VMV p6 Schéma XML pro ztvárnění transakčního protokolu.md` | **Část 6** | Schéma transakčního protokolu | `TransakcniLogObjektu.xsd` |
| `2024_85-VMV p7 Schéma XML pro migraci dat mezi elektronickými systémy spisové služby.md` | **Část 7** | Migrace dat mezi systémy | `ermsExportPrenos.xsd` |
| `2024_85-VMV p8 Metadata entit.md` | **Část 8** | Specifikace metadat entit | — |

---

## Extrahované technické artefakty

Všechny extrahované soubory jsou umístěny ve složce `standard/`. Jedná se o přesné kopie vložených specifikací XML/WSDL/XSD z původních dokumentů Word se jmény souborů s ohledem na kontext.

### WSDL (Web Service Definition Language)

| Soubor | Zdrojový dokument | Účel |
| --- | --- | --- |
| `ermsAPI.wsdl` | Část 1 | Definice webového rozhraní pro synchronní a asynchronní operace API |

### XSD (XML Schema Definition)

| Soubor | Zdrojový dokument | Účel | Namespace / Klíčová role |
| --- | --- | --- | --- |
| `dmBaseTypes.xsd` | Část 1 | Základní datové typy pro integraci ISDS | `http://isds.czechpoint.cz/v20` |
| `ermsAsynU.xsd` | Část 1 | Datové typy asynchronního API | `http://www.mvcr.cz/nsesss/2024/api` |
| `ermsExportPrenos.xsd` | Část 7 | Schéma exportu a migrace dat | Podporuje prvky `Davka`, `Export`, `PrenosPotvrzeni` |
| `ermsIFAsyn.xsd` | Část 1 | Struktury asynchronního rozhraní | Operace synchronního rozhraní |
| `ermsIFSyn.xsd` | Část 1 | Struktury synchronního rozhraní | Operace asynchronního rozhraní |
| `ermsTypes.xsd` | Část 1 | Datové typy API | Běžné typy používané ve všech operacích API |
| `Dil.xsd` | Část 2 | Schéma části souboru | Definice komponent souborů SIP METS |
| `mets.xsd` | Část 2 | Schéma standardu METS | Balení digitálních objektů (kořen `mets:mets`) |
| `Seznam.xsd` | Část 4 | Schéma seznamu/výčtu | Entity skartačních rozhodnutí |
| `SpisovyPlan.xsd` | Část 5 | Schéma spisového plánu | Hierarchie a metadata spisového plánu |
| `TransakcniLogObjektu.xsd` | Část 6 | Schéma objektu transakčního protokolu | Protokol transakcí na úrovni objektu |

### XML (Datové schéma)

| Soubor | Zdrojový dokument | Účel |
| --- | --- | --- |
| `schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml` | Část 2 | Schéma XLink pro propojení dokumentů METS SIP |

---

## Kontextově vědomé cesty pro rychlý start

Použijte tato doporučení k identifikaci minimální sady souborů potřebných pro vaši úlohu:

### 🔧 Budování integrace WS API

**Začněte s:**

1. Markdown Části 1: `2024_85-VMV p1 Schéma XML pro výměnu dokumentů...`
2. `ermsAPI.wsdl` — operace služby a vazby
3. `ermsIFSyn.xsd` — struktury synchronního rozhraní požadavků/odpovědí
4. `ermsIFAsyn.xsd` — definice asynchronního rozhraní
5. `ermsTypes.xsd` — běžné datové typy

### 📦 Návrh balíčku SIP nebo digitálního archivu

**Začněte s:**

1. Markdown Části 2: `2024_85-VMV p2 Schéma XML pro vytvoření datového balíčku SIP`
2. `mets.xsd` — struktura kontejneru METS
3. `Dil.xsd` — definice souborů/komponent
4. `schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml` — propojení mezi dokumenty
5. Markdown hlavního standardu pro kontext metadat

### 🔄 Implementace migrace dat

**Začněte s:**

1. Markdown Části 7: `2024_85-VMV p7 Schéma XML pro migraci dat...`
2. `ermsExportPrenos.xsd` — formát exportu a potvrzení
3. Část 1 (pro podrobnosti API o pohybu dat)

### 📋 Budování systému skartace

**Začněte s:**

1. Zákon 499/2004 (právní požadavky na skartaci)
2. Vyhláška 259/2012 (procedurální pravidla)
3. Markdown Části 4: `2024_85-VMV p4 Schéma XML pro skartačním řízení`
4. `Seznam.xsd` — formát seznamu rozhodnutí

### 🏗️ Vytvoření nového systému správy dokumentů

**Začněte s:**

1. Markdown hlavního standardu — slovník a rámec
2. Zákon 499/2004 — právní základ
3. Markdown Částí 1–8 pro podrobnosti implementace
4. Jednotlivé soubory XSD podle potřeby pro jednotlivé komponenty

### 📊 Implementace metadat entit

**Začněte s:**

1. Markdown Části 8: `2024_85-VMV p8 Metadata entit`
2. Markdown hlavního standardu pro typy entit a jejich vztahy

---

## Poznámky k formátu souboru a kódování

- **Formát:** UTF-8 Markdown
- **Styl tabulek:** Tabulky s potrubím Markdown (`| — |`) — žádné tabulky HTML
- **Diakritika:** Česká písmena (č, š, ž, ř, atd.) plně zachována
- **Bez sledovaných změn:** Všechny dokumenty jsou čisté (bez sledovaných změn nebo komentářů aplikace Word)
- **Reference schémat:** Vřazené odkazy na extrahované soubory XSD/WSDL označeny jako `[Extrahovaný fragment XSD do `filename.xsd`]`

---

## Podrobnosti převodu (Reference)

Tato dokumentace byla automaticky převedena ze souborů Microsoft Word (.docx) do formátu Markdown pomocí konvertoru `markitdown` s bloky XML/XSD/WSDL extrahovanými do samostatných souborů pro snazší integraci.

- **Zdrojový formát:** DOCX (Microsoft Word)
- **Cílový formát:** Markdown (.md)
- **Metoda extrakce:** Analýza s vědomím kontextu (odvozeným jmény souborů ze záhlaví dokumentů a atributů schématu)
- **Ověření:** Žádné značky tabulek HTML, UTF-8 ověřeno, veškerý český text zachován
- **Extrahované soubory:** 1 WSDL + 11 XSD + 1 XML = 13 celkově technických souborů artefaktů

---

## Použití této dokumentace v budoucích sezení

Při zahájení nového vývojového sezení:

1. **Identifikujte svůj případ použití** z výše uvedené sekce "Cesty pro rychlý start"
2. **Odkazujte pouze na konkrétní soubory Markdown a schémata** uvedené pro vaši cestu
3. **Explicitně zahrňte názvy souborů** do vašeho příspěvku k LLM sezení (např. "Odkazujte na `ermsAPI.wsdl` a `ermsIFSyn.xsd`")
4. **Vyhněte se prozkoumávání složky** — tento README poskytuje všechny mapování souborů, které potřebujete

Tento přístup **šetří tokeny okna kontextu** tím, že vám umožňuje přesně určit, které soubory jsou relevantní, místo aby bylo nutné, aby LLM skenoval a četl celou strukturu složky.

---

## Otázky nebo aktualizace?

- **Právní výklad:** Konzultujte Zákon 499/2004 a Vyhlášku 259/2012 (složka law/)
- **Otázky ke schématům:** Začněte příslušným Markdown Částí, poté se podívejte na extrahovaný soubor XSD
- **Návrh systému:** Začněte s hlavním standardem pro rámec, poté se ponořte do konkrétních Částí

---

*Naposledy aktualizováno: Červen 2025 | Převod: markitdown | Jazyk: Čeština*
