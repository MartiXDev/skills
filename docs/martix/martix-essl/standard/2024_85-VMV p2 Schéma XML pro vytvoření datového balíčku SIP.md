**Schéma XML pro vytvoření datového balíčku SIP**

**a pro zaznamenání popisných metadat uvnitř datového balíčku SIP**

Normativní části přílohy:

[*Popisná metadata a datový balíček SIP* *2*](#_bookmark0)

1. [*Podmínky použití prvků schématu XML METS* *2*](#_bookmark1)
   1. [*Kořenový element METS 2*](#_bookmark2)
   2. [*Záhlaví METS 3*](#_bookmark3)
   3. [*Subjekt 3*](#_bookmark4)
   4. [*Název/jméno subjektu 3*](#_bookmark5)
   5. [*Poznámka subjektu* *4*](#_bookmark6)
   6. [*Sekce popisných metadat* *4*](#_bookmark7)
   7. [*Vložená (popisná) metadata* *4*](#_bookmark8)
   8. [*(popisná) Data XML* *5*](#_bookmark9)
   9. [*Sekce administrativních metadat* *5*](#_bookmark10)
   10. [*Digitální provenience entity/objektu* *5*](#_bookmark11)
   11. [*Vložená (administrativní) metadata* *6*](#_bookmark12)
   12. [*(administrativní) Data XML* *6*](#_bookmark13)
   13. [*Sekce souborů (komponent)* *6*](#_bookmark14)
   14. [*Skupina souborů (komponent)* *7*](#_bookmark15)
   15. [*Soubor (komponenta) 7*](#_bookmark16)
   16. [*Odkaz na soubor (komponentu) 8*](#_bookmark17)
   17. [*Strukturální mapa* *8*](#_bookmark18)
   18. [*Objekt/entita 8*](#_bookmark19)
   19. [*Vazba souboru (komponenty) 9*](#_bookmark20)
2. [*Schéma XML pro zaznamenání popisných metadat uvnitř datového balíčku SIP* *10*](#_bookmark21)
3. [*Schéma standardu METS pro datový balíček SIP* *44*](#_bookmark22)
4. [*Schéma XLink standardu METS pro datový balíček SIP* *90*](#_bookmark23)

Doplňující informace:

Dokumentace schématu je zveřejněna na stránkách MV v sekci „O nás“, podsekce

„Archivnictví a spisová služba“¨, oblast „Právní předpisy“, odkaz „Národní standard pro elektronické systémy spisové služby“.

# Popisná metadata a datový balíček SIP

# Podmínky použití prvků schématu XML METS

Následující popis prvků schématu XML specifikuje použití těchto prvků za účelem vytvoření datového balíčku SIP. Pokud je u elementu uveden atribut, jde o prvek s povinným výskytem. Jestliže je u hodnoty atributu uvedeno, že „jeho konstrukce není předepsána“, znamená to, že hodnota není definována pravidly a že je možné ji vyplnit jakkoli s omezením pouze na validitu hodnoty proti schématu METS. Naopak popis „uváděná hodnota atributu je“ znamená, že hodnota je jediná přípustná a musí být v dokumentu XML výslovně uvedena.

* 1. ​Kořenový element METS Element definuje globální atributy.

|  |  |
| --- | --- |
| **Element** | **<mets:mets>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |
| Atributy | **xsi:schemaLocation**="<http://www.loc.gov/METS/> <http://www.loc.gov/standards/mets/mets.xsd> <http://www.mvcr.cz/nsesss/v4> <https://www.mvcr.cz/nsesss/v4/nsesss.xsd> <http://www.mvcr.cz/nsesss/2023/log> <https://www.mvcr.cz/nsesss/v4/nsesss-TrP.xsd>"  **OBJID** identifikuje balíček SIP. Jde o jedinečný identifikátor balíčku v rámci původce. Jeho konstrukce není předepsána.  **LABEL** uvádí popis použití dokumentu XML. Povolené hodnoty jsou "Datový balíček pro provedení skartačního řízení" v případě dokumentů určených k posouzení ve skartačním řízení a "Datový balíček pro předávání dokumentů a jejich metadat do archivu" v případě dokumentů vybraných jako archiválie.  **xmlns:mets** zaznamenává adresu (URI) jmenného prostoru schématu METS. Uváděná hodnota je ["http://www.loc.gov/METS/"](http://www.loc.gov/METS/).  **xmlns:nsesss** zaznamenává adresu (URI) jmenného prostoru schématu NSESSS verze 3.0. Uváděná hodnota je ["https://www.mvcr.cz/nsesss/v4".](https://www.mvcr.cz/nsesss/v4)  **xmlns:tp** zaznamenává adresu (URI) jmenného prostoru schématu transakčního protokolu. Uváděná hodnota je ["http://www.mvcr.cz/nsesss/2023/log".](http://www.mvcr.cz/nsesss/2023/log)  **xmlns:xlink** zaznamenává adresu (URI) jmenného prostoru schématu XLink. Uváděná hodnota je ["http://www.w3.org/1999/xlink".](http://www.w3.org/1999/xlink) |

## ​Záhlaví METS

Element definuje subjekty, pro které je dokument XML určen, a informace o vytvoření a pozdějších úpravách dokumentu.

|  |  |
| --- | --- |
| **Element** | **<mets:metsHdr>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |
| **Atributy** | **LASTMODDATE** zaznamenává datum poslední úpravy dokumentu XML ve formě, která je dána normou ISO 8601.  **CREATEDATE** zaznamenává datum vytvoření dokumentu XML ve formě, která je dána normou ISO 8601. |

## ​Subjekt

Element zaznamenává subjekt, který dokument XML vytvořil. Uveden je původce i fyzická osoba odpovědná za tvorbu balíčku.

|  |  |
| --- | --- |
| **Element** | **<mets:agent>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | ANO |
| **Atributy** | **TYPE** definuje, o jaký typ subjektu jde. Povolené hodnoty jsou "ORGANIZATION" (korporace) a "INDIVIDUAL" (fyzická osoba).  **ROLE** definuje, jakou roli příslušný subjekt plní. Uváděná hodnota atributu je "CREATOR" (původce).  **ID** identifikuje subjekt. Jde o jedinečný identifikátor subjektu. Jeho konstrukce není předepsána. |

## ​Název/jméno subjektu

Element definuje název nebo jméno subjektu.

|  |  |
| --- | --- |
| **Element** | **<mets:name>** |
| **Typ** | jednoduchý datový typ |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |

## ​Poznámka subjektu

Element definuje další libovolnou charakteristiku subjektu.

|  |  |
| --- | --- |
| **Element** | **<mets:note>** |
| **Typ** | jednoduchý datový typ |
| **Povinnost** | NE |
| **Opakovatelnost** | ANO |

## ​Sekce popisných metadat

Element definuje část dokumentu XML, která je určena pro vkládání popisných metadat. Ta jsou definována schématem NSESSS podle přílohy č. 2 národního standardu.

|  |  |
| --- | --- |
| **Element** | **<mets:dmdSec>** |
| **Typ** | složený datový typ (kontejner) |
| Povinnost | ANO |
| **Opakovatelnost** | NE |
| **Atributy** | **ID** identifikuje část dokumentu XML. Jde o jedinečný identifikátor části v celém dokumentu. Jeho konstrukce není předepsána. |

## ​Vložená (popisná) metadata

Element zaznamenává vložená popisná metadata. Ta jsou definována schématem NSESSS.

|  |  |
| --- | --- |
| **Element** | **<mets:mdWrap>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |
| **Atributy** | **MDTYPEVERSION** zaznamenává verzi schématu NSESSS. Uváděná hodnota je "4.0".  **OTHERMDTYPE** zaznamenává název schématu XML. Uváděná hodnota je "NSESSS".  **MDTYPE** zaznamenává název schématu XML z číselníku známých schémat. Uváděná hodnota je "OTHER". |

|  |  |
| --- | --- |
|  | **MIMETYPE** zaznamenává určení typu a souborového formátu metadat podle internetového standardu MIME. Uváděná hodnota je "text/xml". |

## ​(popisná) Data XML

Element obsahuje vložená popisná metadata. Ta jsou definována schématem NSESSS (nsesss.xsd) uvedeném na konci této přílohy. Do elementu jsou vkládány kořenové elementy schématu NSESSS s prefixem nsesss. V případě, že jsou základní entita NSESSS (tj. díl typového spisu, dokument nebo spis) nebo její podřízené či nadřízené entity spojeny s jinou entitou prostřednictvím pevného křížového odkazu, je tato entita rovněž vložena do tohoto elementu.

|  |  |
| --- | --- |
| **Element** | **<mets:xmlData>** |
| **Typ** | smíšený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |

## ​Sekce administrativních metadat

Element definuje část dokumentu XML, která je určena pro vkládání transakčního protokolu. Ten je definován schématem podle přílohy č. 6 národního standardu. Jeden element zaznamenává transakční protokol k jedné entitě/objektu.

|  |  |
| --- | --- |
| **Element** | **<mets:amdSec>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | ANO |
| **Atributy** | ID identifikuje část dokumentu XML. Jde o jedinečný identifikátor části v celém dokumentu. Jeho konstrukce není předepsána. |

## ​Digitální provenience entity/objektu

Element definuje část dokumentu XML, která je určena pro vkládání informací o úkonech provedených s entitou/objektem.

|  |  |
| --- | --- |
| **Element** | **<mets:digiprovMD>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |

|  |  |
| --- | --- |
| **Atributy** | ID identifikuje část dokumentu XML. Jde o jedinečný identifikátor části v celém dokumentu. Jeho konstrukce není předepsána. |

## ​Vložená (administrativní) metadata

Element zaznamenává vložená popisná metadata. Ta jsou definována schématem NSESSS.

|  |  |
| --- | --- |
| **Element** | **<mets:mdWrap>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |
| **Atributy** | **MDTYPEVERSION** zaznamenává verzi schématu transakčního protokolu. Uváděná hodnota je "4.0".  **OTHERMDTYPE** zaznamenává název schématu transakčního protokolu. Uváděná hodnota je "TP".  **MDTYPE** zaznamenává název schématu XML z číselníku známých schémat. Uváděná hodnota je "OTHER".  **MIMETYPE** zaznamenává určení typu a souborového formátu metadat podle internetového standardu MIME. Uváděná hodnota je "text/xml". |

## ​(administrativní) Data XML

Element obsahuje vložená administrativní metadata. Ta jsou definována schématem transakčního protokolu. Do elementu je vkládán kořenový element TransakcniLogObjektu schématu s prefixem tp.

|  |  |
| --- | --- |
| **Element** | **<mets:xmlData>** |
| **Typ** | smíšený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |

## ​Sekce souborů (komponent)

Element definuje část dokumentu XML, která je určena pro soubory (komponenty).

|  |  |
| --- | --- |
| **Element** | **<mets:fileSec>** |
| **Typ** | složený datový typ (kontejner) |

|  |  |
| --- | --- |
| **Povinnost** | NE; povinný je pouze v případě Datového balíčku pro předávání dokumentů a jejich metadat do archivu, který má obsahovat dokumenty v digitální podobě vybrané jako archiválie. |
| **Opakovatelnost** | NE |

## ​Skupina souborů (komponent)

Element zaznamenává soubory (komponenty).

|  |  |
| --- | --- |
| **Element** | **<mets:fileGrp>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |

## ​Soubor (komponenta)

Element zaznamenává jednotlivý soubor (komponentu).

|  |  |
| --- | --- |
| **Element** | **<mets:file>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | ANO |
| **Atributy** | **ID** identifikuje komponentu. Jde o jedinečný identifikátor komponenty v rámci dokumentu XML. Jeho konstrukce není předepsána.  **DMDID** zaznamenává vazbu mezi popisnými a administrativními metadaty komponenty. Obsahuje hodnotu atributu ID elementu  <nsesss:Komponenta> příslušné komponenty.  **MIMETYPE** zaznamenává určení typu a souborového formátu metadat podle internetového standardu MIME.  **CHECKSUMTYPE** zaznamenává šifrovací algoritmus pro tvorbu otisku (hash) komponenty. Povolené hodnoty jsou SHA-256 a SHA-512.  **CHECKSUM** zaznamenává otisk (hash) komponenty. Hodnota se zapisuje v rámci hexadecimální soustavy.  **SIZE** zaznamenává velikost komponenty v bytech.  **CREATED** zaznamenává datum vytvoření komponenty ve formě, která je dána normou ISO 8601. |

## ​Odkaz na soubor (komponentu)

Element zaznamenává obsah souboru (komponenty).

|  |  |
| --- | --- |
| **Element** | **<mets:FLocat>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |
| **Atributy** | **xlink:type** zaznamenává typ použitého způsobu odkazování. Uváděná hodnota atributu je "simple".  **xlink:href** zaznamenává URL souboru (komponenty). Soubory reprezentující komponenty se ukládají do adresáře (složky) s názvem "komponenty".  **LOCTYPE** zaznamenává typ umístění použitý v atributu xlink:href. Uváděná hodnota je "URL". |

## ​Strukturální mapa

Element definuje strukturu objektů a entit podle schématu NSESSS v hierarchické struktuře od nejvýše umístěného spisového plánu až po nejníže umístěnou komponentu.

|  |  |
| --- | --- |
| **Element** | **<mets:structMap>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | NE |

## ​Objekt/entita

Element zaznamenává jednotlivý objekt nebo entitu podle schématu NSESSS.

|  |  |
| --- | --- |
| **Element** | **<mets:div>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | ANO |
| **Opakovatelnost** | ANO |
| **Atributy** | **TYPE** zaznamenává typ objektu nebo entity. Nejvyšší entitou je "spisový plán", dále "věcná skupina", "typový spis", "součást", "díl", "spis", "dokument" a nejnižším objektem je "komponenta". |

|  |  |
| --- | --- |
|  | **DMDID** zaznamenává vazbu mezi popisnými a strukturálními metadaty entit/objektů. Obsahuje hodnotu atributu ID elementu  <nsesss:SpisovyPlan>, <nsesss:VecnaSkupina>, <nsesss:TypovySpis>,  <nsesss:Soucast>, <nsesss:Dil>, <nsesss:Spis>, <nsesss:Dokument> nebo  <nsesss:Komponenta> příslušné entity/objektu.  **ADMID** zaznamenává vazbu mezi administrativními a strukturálními metadaty entit/objektů. Obsahuje hodnotu atributu ID elementu  <mets:amdSec> příslušné entity/objektu. |

## ​Vazba souboru (komponenty)

Element zaznamenává přiřazení souboru (komponenty) k příslušnému dokumentu. Uvádí se jen u dokumentů, které obsahují komponenty, a to pouze v rámci rodičovských elementů <mets:div TYPE="komponenta">.

|  |  |
| --- | --- |
| **Element** | **<mets:fptr>** |
| **Typ** | složený datový typ (kontejner) |
| **Povinnost** | NE |
| **Opakovatelnost** | ANO |
| **Atributy** | **FILEID** identifikuje komponentu. Jde o jedinečný identifikátor v rámci dokumentu XML. Jeho konstrukce není předepsána. |

# Schéma XML pro zaznamenání popisných metadat uvnitř datového balíčku SIP

[Extracted XSD snippet to `Dil.xsd`]
# Schéma standardu METS pro datový balíček SIP

[Extracted XSD snippet to `mets.xsd`]
# Schéma XLink standardu METS pro datový balíček SIP

[Extracted XML snippet to `schéma-xlink-standardu-mets-pro-datový-balíček-sip.xml`]
