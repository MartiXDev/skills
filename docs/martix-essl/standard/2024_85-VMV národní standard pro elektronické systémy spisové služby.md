**Oznámení Ministerstva vnitra, kterým se zveřejňuje národní standard pro elektronické systémy spisové služby**

Ministerstvo vnitra zveřejňuje na základě § 70 odst. 2 zákona č. 499/2004 Sb., o archivnictví a spisové službě a o změně některých zákonů, ve znění pozdějších předpisů (dále jen „zákon“), národní standard pro elektronické systémy spisové služby (dále jen „národní standard“).

Předkládané znění národního standardu vychází z předchozího znění s tím, že především reaguje na zákon č. 197/2024 Sb., kterým se mění zákon č. 499/2004 Sb., o archivnictví a spisové službě a o změně některých zákonů, ve znění pozdějších předpisů, zákon č. 261/2021 Sb., kterým se mění některé zákony v souvislosti s další elektronizací postupů orgánů veřejné moci, ve znění pozdějších předpisů, a zákon č. 106/1999 Sb., o svobodném přístupu k informacím, ve znění pozdějších předpisů, jeho prováděcí vyhlášku č. 200/2024 Sb., kterou se mění vyhláška č. 259/2012 Sb., o podrobnostech výkonu spisové služby, ve znění pozdějších předpisů a dále opravuje některé zjevné chyby předchozího znění zveřejněného ve Věstníku Ministerstva vnitra, částka 62/2024.

Text psaný obyčejnou kursivou není integrální součástí požadavků samých, jeho účelem je lepší vysvětlení smyslu požadavku nebo poskytnutí ilustračního příkladu použití požadavku v praxi.

Přehled revizí národního standardu:

|  |  |
| --- | --- |
| definice 1.58 | změna textu |
| požadavek 2.1.4 | odstranění odkazu na přílohu č. 3 |
| požadavek 2.4.2 | změna textu |
| požadavek 2.4.4 | zrušen |
| požadavek 2.4.5 | zrušen |
| požadavek 2.4.6 | zrušen |
| požadavek 2.5.1 | změna textu |
| požadavek 2.8.4 | zrušen |
| požadavek 2.8.6 | změna textu |
| požadavek 2.8.14 | změna textu |
| požadavek 3.1.9 | změna textu |
| požadavek 3.1.10 | zrušen |
| požadavek 3.3.4 | změna textu a odstranění kursivy |
| požadavek 3.3.8 | změna textu |
| požadavek 3.3.11 | zrušen |
| požadavek 3.4.5 | změna textu |
| požadavek 4.2.4 | změna textu |
| požadavek 5.1.5 | změna textu |
| požadavek 5.2.13 | změna textu |
| požadavek 6.1.1 | změna textu |
| požadavek 6.1.2 | změna textu |
| požadavek 6.1.5 | změna textu |
| požadavek 6.1.6 | změna textu |
| požadavek 7.1.3 | změna textu |
| požadavek 7.1.4 | změna textu |

|  |  |
| --- | --- |
| požadavek 7.3.5 | změna textu |
| požadavek 7.4.1 | změna textu |
| požadavek 7.4.6 | zrušen |
| požadavek 7.4.8 | změna textu |
| příloha č. 3 | zrušena |

Znění národního standardu je zpřístupněno způsobem umožňujícím dálkový přístup na internetových stránkách Ministerstva vnitra v sekci „O nás“, ve složce

„Archivnictví a spisová služba“.

Národní standard nabývá účinnosti dnem 15. prosince 2024, týmž dnem se zrušuje národní standard pro elektronické systémy spisové služby zveřejněný ve Věstníku Ministerstva vnitra, částka 62/2024.

Veřejnoprávní původci uvedou výkon spisové služby do souladu s požadavky národního standardu, ve znění účinném ode dne nabytí účinnosti tohoto národního standardu, do 31. prosince 2026.

Pro účely atestací se posuzuje soulad elektronického systému spisové služby s požadavky národního standardu ve znění účinném ode dne nabytí účinnosti tohoto národního standardu.

Č. j. MV-125016-2/AS-2024

Ředitel odboru archivní správy a spisové služby

**PhDr. Daniel DOLEŽAL, Ph.D.,** v. r.

**Národní standard pro elektronické systémy spisové služby**

## OBSAH

[Obsah 3](#_bookmark0)

1. [ZÁKLADNÍ POJMY 7](#_bookmark1)
   1. [Analogový dokument 7](#_bookmark2)
   2. [Část dokumentu 7](#_bookmark3)
   3. [Číslo jednací 7](#_bookmark4)
   4. [Datový balíček SIP 7](#_bookmark5)
   5. [Datový formát komponenty 7](#_bookmark6)
   6. [Dědičnost 8](#_bookmark7)
   7. [Digitální (elektronický) 8](#_bookmark8)
   8. [Díl typového spisu 8](#_bookmark9)
   9. [Druh dokumentu 8](#_bookmark10)
   10. [Elektronický 8](#_bookmark11)
   11. [Elektronický systém spisové služby 8](#_bookmark12)
   12. [Entita 8](#_bookmark13)
   13. [Export 8](#_bookmark14)
   14. [Hlavička metadat 9](#_bookmark15)
   15. [Import 9](#_bookmark16)
   16. [Informační systém spravující dokumenty 9](#_bookmark17)
   17. [Jednoduchý spisový znak 9](#_bookmark18)
   18. [Jednoznačný identifikátor entity 9](#_bookmark19)
   19. [Komponenta 9](#_bookmark20)
   20. [Kontejnerové datové formáty 9](#_bookmark21)
   21. [Křížový odkaz 10](#_bookmark22)
   22. [Otevření (činnost) 10](#_bookmark23)
   23. [Otevřený (stav) 10](#_bookmark24)
   24. [Posuzovatel skartační operace 10](#_bookmark25)
   25. [Pozastavení skartační operace 10](#_bookmark26)
   26. [Přenos 10](#_bookmark27)
   27. [Příjem 10](#_bookmark28)
   28. [Role 11](#_bookmark29)
   29. [Rozhraní (informačního systému spravujícího dokumenty) 11](#_bookmark30)
   30. [Samostatná evidence dokumentů v elektronické podobě 11](#_bookmark31)
   31. [Schvalování (činnost) 11](#_bookmark32)
   32. [Skartační operace 11](#_bookmark33)
   33. [Skartační režim 11](#_bookmark34)
   34. [Skartační lhůta 11](#_bookmark35)
   35. [Skartační znak 12](#_bookmark36)
   36. [Součást typového spisu 12](#_bookmark37)
   37. [Spis 12](#_bookmark38)
   38. [Spisová značka 12](#_bookmark39)
   39. [Spisový a skartační plán 12](#_bookmark40)
   40. [Spisový znak 12](#_bookmark41)
   41. [Spouštěcí událost 12](#_bookmark42)
   42. [Správcovská role 12](#_bookmark43)
   43. [Stručný obsah 12](#_bookmark44)
   44. [Šablona typového spisu 13](#_bookmark45)
   45. [Transakční protokol 13](#_bookmark46)
   46. [Třídění 13](#_bookmark47)
   47. [Typový spis 13](#_bookmark48)
   48. [Uzavření 13](#_bookmark49)
   49. [Uživatel 13](#_bookmark50)
   50. [Uživatelská role 14](#_bookmark51)
   51. [Věcná skupina 14](#_bookmark52)
   52. [Vyřízení 14](#_bookmark53)
   53. [Zajišťovací prvky 14](#_bookmark54)
   54. [Založení 14](#_bookmark55)
   55. [Znázornění 14](#_bookmark56)
   56. [Znepřístupnění (storno) 14](#_bookmark57)
   57. [Zničení 15](#_bookmark58)
   58. [Zpracovatel 15](#_bookmark59)
   59. [Ztvárnění 15](#_bookmark60)
2. [PŘÍJEM A EVIDENCE DOKUMENTŮ 16](#_bookmark61)
   1. [Příjem 16](#_bookmark62)
   2. [E-mailové schránky 16](#_bookmark65)
   3. [Datové schránky 17](#_bookmark67)
   4. [Kontejnerové datové formáty 18](#_bookmark68)
   5. [Změna datového formátu komponenty a převod dokumentu 18](#_bookmark73)
   6. [Ověřování zajišťovacích prvků 19](#_bookmark78)
   7. [Evidence dokumentů 19](#_bookmark79)
   8. [Jmenný rejstřík 20](#_bookmark85)
   9. [Samostatná evidence dokumentů 22](#_bookmark91)
3. [SPISOVÝ A SKARTAČNÍ PLÁN A ORGANIZACE SPISŮ 24](#_bookmark95)
   1. [Věcné skupiny 24](#_bookmark96)
   2. [Spisy 25](#_bookmark104)
   3. [Typové spisy, součásti typového spisu a díly typového spisu 26](#_bookmark115)
   4. [Udržování vazeb mezi entitami 30](#_bookmark124)
4. [ODKAZOVÁNÍ MEZI ENTITAMI 31](#_bookmark130)
   1. [Křížové odkazy 31](#_bookmark131)
   2. [Druhy dokumentů 32](#_bookmark135)
5. [VYHLEDÁVÁNÍ, VÝBĚR, ZNÁZORNĚNÍ A ZTVÁRNĚNÍ 33](#_bookmark137)
   1. [Vyhledávání a výběr 33](#_bookmark138)
   2. [Znázornění a ztvárnění 34](#_bookmark142)
6. [UKLÁDÁNÍ A VYŘAZOVÁNÍ DOKUMENTŮ 37](#_bookmark149)
   1. [Skartační režimy 37](#_bookmark150)
   2. [Skartační řízení 39](#_bookmark166)
   3. [Přenos, export a import 41](#_bookmark170)
7. [SPRÁVA A BEZPEČNOST 43](#_bookmark175)
   1. [Přístup 43](#_bookmark176)
   2. [Změny, zničení a znepřístupnění dokumentů 44](#_bookmark178)
   3. [Hlášení o stavu eSSL 45](#_bookmark185)
   4. [Transakční protokol 47](#_bookmark187)
8. [ROZHRANÍ PRO PROPOJENÍ INFORMAČNÍCH SYSTÉMŮ SPRAVUJÍCÍCH](#_bookmark188) [DOKUMENTY 49](#_bookmark188)
   1. [Vazby mezi informačními systémy spravujícími dokumenty 49](#_bookmark189)
9. [METADATA 56](#_bookmark200)
   1. [Obecné požadavky na metadata 56](#_bookmark201)
   2. [Požadavky na metadata datových balíčků SIP 56](#_bookmark202)
   3. [Přílohy 58](#_bookmark204)
10. [DOKUMENTACE ŽIVOTNÍHO CYKLU 59](#_bookmark205)
    1. [Dokumentace informačního systému spravujícího dokumenty 59](#_bookmark206)

## ZÁKLADNÍ POJMY

# *Analogový dokument*

Analogový dokument je dokument, jehož alespoň jedna část je analogová. Tato část může být v listinné podobě nebo se jedná o technický nosič dat, který neobsahuje dokumenty v digitální podobě (například obrazový a zvukový nosič s analogovým záznamem signálu, trojrozměrné předměty). Dokument tvořený z částí a komponent se pro účely národního standardu pokládá za analogový.

# *Část dokumentu*

Dokument v analogové podobě je tvořen částmi dokumentu (například průvodní dopis, přílohy, případně obálka doručeného dokumentu).

# *Číslo jednací*

Číslo jednací je evidenční znak dokumentu v rámci evidence dokumentů, jehož tvar vychází z požadavků právního předpisu upravujícího podrobnosti výkonu spisové služby upřesněných ve spisovém řádu původce.

# *Datový balíček SIP*

Informační balíček (Submission Information Package) určený k exportu, importu nebo přenosu replik entit z eSSL nebo do eSSL. Je tvořen podle přílohy č. 2 a obsahuje metadata a komponenty

* + 1. spisu,
    2. dokumentu zatříděného přímo do věcné skupiny (podle předchozí právní úpravy), nebo
    3. dílu typového spisu.

# *Datový formát komponenty*

Datový formát je způsob kódování komponenty pro účely zpracování výpočetní technikou. Pojem „datový formát komponenty“ se pro účely národního standardu užívá v obdobném významu jako „formát“. Datovými formáty jsou například

* + 1. formát Portable Document Format/Archive (PDF/A, ISO 19005),
    2. formát Portable Network Graphics (PNG, ISO/IEC 15948),
    3. formát Tagged Image File Format (TIFF, revize 6 - nekomprimovaný),
    4. formát JPEG File Interchange Format (JPEG/JFIF, ISO/IEC 10918),
    5. formát Graphics Interchange Format (GIF),
    6. formát Waveform audio format (WAV), modulace Pulse-code modulation (PCM),
    7. formát XML,
    8. proprietární formáty dokumentů vytvářené kancelářskými aplikacemi.

# *Dědičnost*

Dědičnost vyjadřuje vlastnost, na jejímž základě mateřská entita předává určitá metadata dceřiné entitě.

# *Digitální (elektronický)*

Pojem „digitální“ vyjadřuje entitu představovanou numerickým řetězcem tvořeným hodnotami

„1“ a „0“ (proud bitů) a interpretovatelným pouze pomocí výpočetní techniky. Pojem

„elektronický“ se pro účely národního standardu užívá obdobně. Za elektronickou nebo digitální se pro účely národního standardu považuje taková entita, kterou lze spravovat prostředky výpočetní techniky; z tohoto důvodu je obvyklé analogové entity převést (konvertovat) do digitální podoby.

# *Díl typového spisu*

Pomocí dílu typového spisu jsou členěny součásti typového spisu. Díl typového spisu slouží k zajištění manipulace s jeho obsahem jako s celkem. Je vytvářen na základě konfigurovatelného časového období, nikoli obsahově. V dílu typového spisu se vytvářejí spisy nebo se do něj vkládají. Díl typového spisu je zařazován do výběru archiválií jako celek.

# *Druh dokumentu*

Druhem dokumentu je tematické označení přiřazené dokumentu bez ohledu na jeho zatřídění v hierarchii entit spisové služby. Druhem dokumentu jsou například „faktury“, „smlouvy“ nebo

„dokumenty operačního programu XY“. Pokud je druhu dokumentu přiřazen skartační režim, může dojít k vyvolání a řešení konfliktu skartačního režimu dokumentu a spisu.

# *Elektronický*

Pojem „elektronický“ se pro účely národního standardu používá obdobně jako pojem

„digitální“.

# *Elektronický systém spisové služby*

Elektronický systém spisové služby (dále jen „eSSL“, na začátku věty psáno „ESSL“) je informační systém určený ke správě dokumentů ve smyslu ustanovení § 2 písm. l) zákona, s využitím § 63 odst. 3 a 4 téhož zákona. Může se jednat o funkční součást informačního systému spravujícího dokumenty, která plní úkoly stanovené zákonem.

# *Entita*

Entitou se rozumí objekt spravovaný eSSL. Mezi entity patří zejména věcná skupina, spisový a skartační plán, skartační režim, typový spis, součást typového spisu, díl typového spisu, spis, dokument, komponenta. Replika entity je jiná instance téže entity.

# *Export*

Export je proces vytvoření repliky vybraných entit spojený s vytvořením repliky metadat těchto entit nebo proces vytvoření repliky transakčního protokolu, a to za účelem převedení vzniklé repliky do jiného systému. Exportované entity a transakční protokol zůstávají zachovány v původním informačním systému spravujícím dokumenty, nejsou tedy na rozdíl od přenosu po jeho ukončení znepřístupněny.

# *Hlavička metadat*

Hlavička metadat je podmnožina metadat pro entitu, která zůstane zachována po zničení nebo přenosu entity. Hlavička metadat je dokladem, že předmětná entita existovala a byla spravována eSSL.

# *Import*

Import je proces vložení entit a jejich metadat, které byly vytvořeny v jiném informačním systému spravujícím dokumenty, do eSSL, například při spisové rozluce nebo migraci na jiný systém eSSL.

# *Informační systém spravující dokumenty*

Informační systém spravující dokumenty je jakýkoli informační systém obsahující komponenty nebo evidující dokumenty. Tento pojem zahrnuje zejména eSSL a samostatné evidence dokumentů vedené v elektronické podobě.

# *Jednoduchý spisový znak*

Jednoduchý spisový znak je označení věcné skupiny nebo součásti typového spisu, které ji odlišuje od jiné věcné skupiny zařazené pod stejnou mateřskou věcnou skupinu nebo součást typového spisu. Doplněním jednoduchého spisového znaku o jednoduché spisové znaky všech nadřazených věcných skupin vzniká spisový znak.

# *Jednoznačný identifikátor entity*

Jednoznačný identifikátor entity je znak pevně spojený s entitou zajišťující její nezaměnitelnost a jedinečnost v rámci informačního systému spravujícího dokumenty. Každá entita je v eSSL označena jednoznačným identifikátorem, kterým je údaj v metadatech. Jednoznačný identifikátor entity může být v případě dokumentu nazýván jako „jednoznačný identifikátor dokumentu“ a rozumí se jím jednoznačný identifikátor podle zákona o archivnictví a spisové službě, nebo v případě spisu jako „jednoznačný identifikátor spisu“ a rozumí se jím identifikátor spisu podle právního předpisu upravujícího podrobnosti výkonu spisové služby apod.

# *Komponenta*

Komponentou se rozumí jednoznačně vymezený proud bitů tvořící datový soubor charakterizovaný zpravidla formátem datového souboru, běžně zpracovávaným programovými aplikacemi, které umožňují provádět správu souborů, složek a disků tak, aby k nim bylo možné uživatelsky srozumitelně přistupovat a s nimi samostatně manipulovat (správce souborů). Komponentou může být i metasoubor zahrnující společné uložení dat a metadat (datový kontejner, například PDF/A-3, ZFO, ZIP), z kterého lze - s pomocí k tomu určených programových aplikací - vyčlenit v něm zapouzdřené datové soubory, se kterými lze pracovat jako se samostatnými komponentami podle věty první.

# *Kontejnerové datové formáty*

Kontejnerové datové formáty jsou formáty komponent obsahující alespoň jednu další komponentu.

# *Křížový odkaz*

Křížový odkaz je vazba mezi entitami. Pevný křížový odkaz zajišťuje spojení spisů, které nelze bez uvedení důvodu odstranit, a přihlíží se k němu při exportu a přenosu. Historicky bylo možné realizovat pevný křížový odkaz i mezi dokumenty, dokumenty a spisy a použít ke vkládání spisů do dílu typového spisu. V případě volného křížového odkazu se jedná o informační vazbu mezi entitami, která nemá vliv na entity spojené tímto odkazem a práci s nimi.

# *Otevření (činnost)*

Otevřením se rozumí:

* + 1. iniciační okamžik uvedení konkrétní instance entity, který umožňuje, aby do dané entity byly vkládány další entity, pokud je to podle národního standardu možné. Otevírá se součást typového spisu, která je definována šablonou typového spisu pro věcnou skupinu umožňující vytvářet typové spisy, díl typového spisu a věcná skupina,
    2. proces navrácení uzavřené instance entity do aktivního stavu. Znovuotevřít lze věcnou skupinu, součást typového spisu, spis. Vzhledem k povaze dílu typového spisu jej není možné opětovně otevřít.

# *Otevřený (stav)*

Otevřený je stav vzniklý otevřením nebo založením entit spisové služby. Ve stavu „otevřený“ je po svém otevření věcná skupina, součást typového spisu a díl typového spisu a po svém založení typový spis, spis.

# *Posuzovatel skartační operace*

Posuzovatel skartační operace je specifická správcovská role, jejíž nositel (konkrétní fyzická osoba pověřená původcem) zejména spravuje spisovnu. Posuzovatel skartační operace dále rozhoduje o znepřístupněných dokumentech, přetřiďuje chybně zatříděné uzavřené spisy, edituje metadata spisů, připravuje výběr archiválií a realizuje rozhodnutí o výběru archiválií.

# *Pozastavení skartační operace*

Pozastavení skartační operace je úkon, kterým je entita dočasně vyřazena ze skartačního řízení, čímž je zabráněno jejímu zničení nebo přenosu do příslušného archivu.

# *Přenos*

Přenos je proces přemístění repliky entity spolu s jejími metadaty do jiného informačního systému spravujícího dokumenty. Účelem přenosu je zejména převést vybrané entity do externí elektronické spisovny**,** digitálního archivu, externího eSSL (spisová rozluka) nebo jiného informačního systému spravujícího dokumenty.

# *Příjem*

Příjem je úkon odborné správy dokumentů, jímž se přijímá dokument do informačního systému spravujícího dokumenty. Příjem zahrnuje také procesy spojené se záznamem do evidenční pomůcky (označení, doplnění metadat) a vložení do spisu.

# *Role*

Role je souhrn oprávnění, jejichž prostřednictvím jsou přidělována práva uživateli informačního systému spravujícího dokumenty. Pro účely národního standardu se rozlišují dva druhy rolí: uživatelská role, správcovská role. Jeden uživatel může mít v informačním systému spravujícím dokumenty přidělenu jednu nebo více rolí (například uživatelskou roli a správcovskou roli).

# *Rozhraní (informačního systému spravujícího dokumenty)*

Rozhraní informačního systému spravujícího dokumenty je soubor webových služeb a XML, s jejichž pomocí komunikuje informační systém spravující dokumenty s eSSL, popřípadě s jiným informačním systémem spravujícím dokumenty. Rozhraní informačního systému spravujícího dokumenty je realizováno prostřednictvím webových služeb a schémat uvedených v příloze č. 1.

# *Samostatná evidence dokumentů v elektronické podobě*

Samostatná evidence dokumentů je informační systém spravující dokumenty, který musí být v souladu s požadavky stanovenými národním standardem a v případě, že sám nezajišťuje v požadovaném rozsahu některé činnosti výkonu spisové služby, musí být integrován se základní evidenční pomůckou pomocí rozhraní informačního systému spravujícího dokumenty. Stanoví-li tak jiný právní předpis nebo spisový řád původce, mohou být dokumenty evidované v samostatných evidencích dokumentů, kterými jsou informační systémy spravující dokumenty, s výjimkou eSSL.

# *Schvalování (činnost)*

Schvalování je proces ve spisové službě, kdy k tomu oprávněná role (schvalovatel) v souladu s vnitřním předpisem původce označuje dokumenty, včetně jejich komponent, jako schválené. Schvalovatel může, ale nemusí být zároveň osobou, která dokument v rámci této činnosti podepisuje. Obsah komponenty schváleného dokumentu nelze měnit bez opakovaného procesu schválení.

# *Skartační operace*

Skartační operace je úkon odborné správy dokumentů, při kterém je ve skartačním řízení uplatněn skartační režim.

# *Skartační režim*

Skartační režim zahrnuje údaje stanovené původcem, které určují okamžik, kdy musí být dokument, spis nebo díl typového spisu navržen ke skartačnímu řízení (skartační lhůta a spouštěcí událost); původce jím navrhuje, jak má být s dokumentem, spisem nebo dílem typového spisu ve skartačním řízení naloženo (skartační znak). Skartační režim stanovuje původce ve svém spisovém a skartačním plánu pro věcnou skupinu nebo součást typového spisu na nejnižší úrovni hierarchie a u typu dokumentu, pokud jej původce využívá.

# *Skartační lhůta*

Doba, po kterou musí být dokument, spis nebo díl typového spisu uložen u původce. Vyjadřuje se počtem let (nejméně 0) počítaným od roku následujícího po roce, kdy nastala spouštěcí událost. Spolu se skartačním znakem a spouštěcí událostí tvoří skartační režim.

# *Skartační znak*

Návrh původce, jak má být s dokumentem, spisem nebo dílem typového spisu naloženo ve skartačním řízení. Vyjadřuje se písmeny A – k trvalému uložení do archivu, S – ke zničení, V – podle předchozí právní úpravy se rozhodne při skartačním řízení. Skartační znak spolu se skartační lhůtou a spouštěcí událostí tvoří skartační režim.

# *Součást typového spisu*

Součást typového spisu člení typový spis podle obsahu. Každá součást typového spisu je pojmenována a její název je uveden ve spisovém a skartačním plánu. Každý typový spis obsahuje alespoň jednu součást typového spisu.

# *Spis*

Spis je entita, v níž jsou organizovány dokumenty vztahující se ke stejnému předmětu (věci).

# *Spisová značka*

Spisová značka je označení spisu; její podobu stanovuje spisový řád původce.

# *Spisový a skartační plán*

Spisovým a skartačním plánem se rozumí souhrn věcných skupin a součástí typového spisu platných v časovém období (časový řez), doplněný o skartační režimy. Spisový a skartační plán je součástí spisového řádu původce.

# *Spisový znak*

Spisový znak je označení věcné skupiny nebo součásti typového spisu, které stanovuje místo entity v hierarchii spisového plánu prostřednictvím dědění spisových znaků mateřských věcných skupin nebo mateřských součástí typového spisu. Je tvořen jednoduchým spisovým znakem věcné skupiny postavené v hierarchii nejvýše a jednoduchými spisovými znaky věcných skupin, popřípadě součástí typového spisu, ležících v hierarchii spisového plánu níže, a to až do dosažení nejbližší mateřské věcné skupiny, popřípadě součásti typového spisu. Spisové znaky jsou jednoznačné v rámci hierarchického spisového plánu, zatímco jednoduché spisové znaky jako takové jsou jednoznačné jen v rámci konkrétní mateřské věcné skupiny.

# *Spouštěcí událost*

Spouštěcí událostí je skutečnost rozhodná pro počátek plynutí skartační lhůty, a pokud to není uzavření spisu, je stanovena ve spisovém a skartačním plánu původce. Spouštěcí událost spolu se skartačním znakem a skartační lhůtou tvoří skartační režim.

# *Správcovská role*

Správcovská role je role vybavená specifickými oprávněními (určit, stanovit, konfigurovat, udržovat, spravovat, vytvářet atp.), která jsou určena národním standardem nebo původcem. Správcovskou rolí je například „Posuzovatel skartační operace“.

# *Stručný obsah*

Stručný obsah dokumentu nebo spisu je několikaslovná charakteristika oblasti, které se dokument nebo spis týkají. Stručný obsah v praxi obvykle odpovídá zažité kolonce „věc“.

# *Šablona typového spisu*

Šablonou typového spisu se rozumí struktura typového spisu definovaná v rámci konfigurace příslušné mateřské věcné skupiny. Šablona typového spisu definuje součásti typového spisu, jejich hierarchii a metadata včetně spisových znaků a skartačních režimů a nastavení časového úseku pro díly typového spisu otevírané v součástech typového spisu. Pro každou mateřskou věcnou skupinu umožňující vytváření typových spisů, je vytvořena právě jedna šablona.

# *Transakční protokol*

Transakční protokol je úplný soubor informací o operacích provedených v informačním systému spravujícím dokumenty, které ovlivnily nebo změnily informační systém spravující dokumenty, entity a jejich metadata. Tyto informace umožňují dohledání, identifikaci, rekonstrukci a kontrolu těchto operací, stavu entit v minulosti a činnosti uživatelů. Transakční protokol je základní prvek důvěryhodnosti informačního systému spravujícího dokumenty. Obsah transakčního protokolu za časové období je ztvárněn do samostatného dokumentu.

# *Třídění*

Tříděním se rozumí systematická klasifikace dokumentů do věcné skupiny a spisu, v souladu se spisovým řádem a spisovým a skartačním plánem, prováděná při výkonu spisové služby. Pojem třídění zahrnuje operace zatřídění a přetřídění.

# *Typový spis*

Typový spis je vnitřně strukturovaná entita vytvořená z předem definované šablony typového spisu. Strukturu tvoří věcné, podle obsahu stanovené součásti typového spisu (jedna nebo více), které mohou být hierarchicky členěné na další součásti. Součást typového spisu na nejnižší úrovni obsahuje alespoň jeden díl typového spisu mechanicky vytvářený pro časové období stanovené pro věcnou skupinu, v níž se typové spisy otevírají. V dílu typového spisu se vytvářejí spisy nebo se do nich vkládají spisy. Základní vlastností typových spisů je, že

* + 1. mají předvídanou strukturu svého obsahu stanovenou ve spisovém a skartačním plánu původce,
    2. jsou dlouhodobě spravovány v rámci konkrétní agendy původce,
    3. spisovou značku tvoří název, jehož způsob tvorby je stanoven ve spisovém řádu původce (například katastrální území, číslo popisné, identifikace konkrétní právnické nebo fyzické osoby), a
    4. nevyřazují se jednotlivé spisy z dílu typového spisu, ale díl typového spisu se vyřazuje jako celek.

# *Uzavření*

Uzavřením se rozumí změna atributů věcné skupiny, typového spisu**,** součásti typového spisu, dílu typového spisu nebo spisu, v jejímž důsledku je zejména znemožněno vkládání dalších dokumentů nebo spisů.

# *Uživatel*

Uživatelem je fyzická osoba používající na základě přidělené role informační systém spravující dokumenty. Různí uživatelé mohou mít rozdílná oprávnění.

# *Uživatelská role*

Uživatelská role je souhrn funkčních oprávnění udělených uživatelům, kteří mohou v informačním systému spravujícím dokumenty vykonávat činnost týkající se odborné správy dokumentů. Jeden uživatel může mít několik uživatelských rolí.

# *Věcná skupina*

Věcná skupina je na věcném (obsahovém) základě vytvořená položka spisového a skartačního plánu, která označuje část jeho hierarchie a je identifikována spisovým znakem. Věcná skupina odpovídá položce spisového a skartačního plánu a může obsahovat jiné věcné skupiny, spisy (historicky i dokumenty) nebo typové spisy. Věcná skupina obsahující typové spisy nebo jinou věcnou skupinu nemůže obsahovat jinou entitu.

# *Vyřízení*

Vyřízením se rozumí změna atributů spisu nebo dokumentu, v jejímž důsledku je zejména znemožněno vyjmutí dokumentu ze spisu, znepřístupnění dokumentu nebo spisu uživatelskou rolí nebo změna komponent s výjimkou změny datového formátu komponenty podle požadavků kapitoly [2.5](#_bookmark73). Vyřízení je možné zrušit. Vyřízení spisu může být spouštěcí událostí.

# *Zajišťovací prvky*

Zajišťovacími prvky dokumentu v digitální podobě, včetně datové zprávy, v níž je obsažen, se rozumí

* + 1. uznávaný elektronický podpis podle § 6 zákona č. 297/2016 Sb., o službách vytvářejících důvěru pro elektronické transakce,
    2. uznávaná elektronická pečeť podle § 9 zákona č. 297/2016 Sb., o službách vytvářejících důvěru pro elektronické transakce,
    3. uznávaná elektronická značka podle § 19 odst. 9 zákona č. 297/2016 Sb., o službách vytvářejících důvěru pro elektronické transakce,
    4. kvalifikované elektronické časové razítko podle čl. 3 odst. 34 nařízení Evropského parlamentu a Rady (EU) č. 910/2014 ze dne 23. července 2014 o elektronické identifikaci a službách vytvářejících důvěru pro elektronické transakce na vnitřním trhu a o zrušení směrnice 1999/93/ES.

# *Založení*

Založením vzniká na základě jednání uživatele nebo systému v konkrétní věcné skupině nový spis nebo typový spis. Současně je spis nebo typový spis otevřen pro vkládání.

# *Znázornění*

Znázornění je uživatelsky vnímatelná interpretace komponenty nebo metadat, zpravidla v podobě zobrazení na obrazovce.

# *Znepřístupnění (storno)*

Znepřístupnění je vyloučení entity z dalšího zpracování v eSSL. Znepřístupněné entity jsou dále uchovány v eSSL v nezměněné podobě s doprovodným zápisem v metadatech, ale uživatelské roli je nelze znázornit ani ztvárnit (stejně jako by byly z eSSL vyjmuty nebo zničeny).

Znepřístupněné entity je možné znovu zpřístupnit, nebo je možné je zničit. V předchozí právní úpravě byl používán ve shodném významu pojem „smazání“.

# *Zničení*

Zničením se rozumí proces likvidace entit, který znemožňuje jejich rekonstrukci a identifikaci jejich obsahu.

# *Zpracovatel*

Zpracovatel je uživatelská role, zejména s následujícími oprávněními

* + 1. editovat stanovená metadata spisu a dokumentu, do spisu vkládat nebo v něm vytvářet dokumenty a vytvářet stanovená metadata, nahlížet do komponent a v případě neschválených komponent tyto měnit, měnit datový formát komponent na výstupní datový formát a opatřovat komponenty zajišťovacími prvky, předat spis jinému zpracovateli nebo jinému zpracovateli postoupit svá vybraná uživatelská oprávnění („držitel spisu“),
    2. na základě uživatelských oprávnění postoupených držitelem spisu nebo podle nastavených oprávnění v rámci šablony typového spisu nahlížet na metadata a entity, vkládat nebo vytvářet entity (dokumenty do spisu, spisy do dílu typového spisu), vkládat stanovená metadata, v případě vlastních dokumentů původce měnit datový formát komponent na výstupní datový formát a opatřovat komponenty zajišťovacími prvky.

# *Ztvárnění*

Znázorněné komponenty nebo metadata mohou být ztvárněny tiskem (do listinné podoby), nebo uložením do nové komponenty. Ztvárněním se také rozumí výsledek

* + 1. změny datového formátu,
    2. převedení dokumentu,
    3. autorizované konverze dokumentu.

## PŘÍJEM A EVIDENCE DOKUMENTŮ

# *Příjem*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.1.1 | ESSL automaticky čísluje všechny verze komponent dokumentu. |
| 2.1.2 | Pokud je přijímaný dokument složen z několika komponent, eSSL přijme všechny jeho komponenty a dále spravuje dokument jako jedinou entitu tak, aby byly zachovány vztahy mezi komponentami a aby byla uchována struktura dokumentu. ESSL současně automaticky zaznamená počet komponent do metadat dokumentu. |
| 2.1.3 | ESSL při příjmu komponenty dokumentu automaticky identifikuje její datový formát, včetně verze formátu podle vnitřní struktury komponenty. ESSL tyto informace ukládá do metadat komponenty.  *Informace pro automatickou identifikaci datových formátů poskytuje například registr PRONOM* [*(www.nationalarchives.gov.uk/PRONOM/).*](http://www.nationalarchives.gov.uk/PRONOM/%29) |
| 2.1.4 | ESSL přijímá entity a metadata v souladu s XML schématy uvedenými v přílohách č. 1, 5, 6 a 8. |
| 2.1.5 | ESSL od příjmu do vyřazení entity průběžně zaznamenává metadata v rozsahu podle přílohy č. 8. |
| 2.1.6 | ESSL umožní předat doručený dokument příslušné fyzické osobě, pokud byl určen k rukám nebo do vlastních rukou. |
| 2.1.7 | ESSL na pokyn uživatelské role při příjmu dokumentu neuloží komponentu dokumentu v případě, že se jedná o komponentu v nepřijímaném datovém formátu, nepřijímané velikosti nebo s jinou vadou, na jejímž základě je odesílatel vyzván k opravě vad dokumentu. ESSL nahradí neuloženou komponentu ztvárněním informací o důvodu jejího neuložení do nové komponenty.  *ESSL vždy zaznamená údaje o odesílateli a datu doručení dokumentu bez ohledu na uložení, nebo neuložení jeho komponent.* |
| 2.1.8 | ESSL při příjmu zaznamená do metadat velikost jednotlivých komponent obsažených v datové zprávě doručené datovou schránkou. |

# *E-mailové schránky*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.2.1 | ESSL zajišťuje   1. automatizované stahování a uložení e-mailových zpráv doručených na elektronické adresy podatelny, 2. odesílání e-mailových zpráv prostřednictvím elektronické adresy podatelny. |
| 2.2.2 | ESSL prostřednictvím funkčního rozšíření poštovního klienta nebo prostředky eSSL umožňuje uživatelské roli přijetí touto rolí vybrané e-mailové zprávy, která byla doručena na jinou e-mailovou adresu, než je elektronická adresa podatelny. |
| 2.2.3 | Pokud je e-mailová zpráva přijata, eSSL uchová jako samostatné komponenty dokumentu   1. e-mailovou zprávu v původním formátu postupem podle požadavku [2.4.2](#_bookmark70), |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. obsah (tělo) e-mailové zprávy a 2. jednotlivé připojené přílohy. |
| 2.2.4 | ESSL z přijaté e-mailové zprávy automaticky vyjímá následující metadata (pokud jsou obsažena v hlavičce e-mailové zprávy):   1. datum a čas odeslání e-mailové zprávy, 2. předmět (věc), 3. odesílatel e-mailové zprávy ve vazbě na jmenný rejstřík. |
| 2.2.5 | ESSL umožňuje uživatelské roli při příjmu e-mailové zprávy upravit metadata automaticky vyjmutá z e-mailové zprávy podle požadavku [2.2.4.](#_bookmark66) |
| 2.2.6 | ESSL automatizovaně zašle potvrzení   1. o přijetí zprávy, 2. o nepřijetí/vadě zprávy. |

# *Datové schránky*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.3.1 | ESSL zajišťuje   1. automatizované stahování a uložení datových zpráv doručených prostřednictvím informačního systému datových schránek, 2. odesílání datových zpráv prostřednictvím informačního systému datových schránek, 3. stahování a uložení informace o dodání datové zprávy do datové schránky adresáta a o doručení datové zprávy (zásilky). |
| 2.3.2 | ESSL zajišťuje využití následujících služeb informačního systému datových schránek:   1. doručení datové zprávy, 2. odeslání datové zprávy, 3. ověření datové zprávy, 4. získání informace o dodání a doručení datové zprávy, 5. získání informace o odesílateli datové zprávy, 6. vyhledání datové schránky a údajů o majiteli, 7. kontrola přístupnosti datové schránky.   *Pravidla pro realizaci rozhraní eSSL vůči informačnímu systému datových schránek pro využívání jednotlivých služeb se řídí Provozním řádem informačního systému datových schránek a jeho přílohami s definicí jednotlivých webových služeb informačního systému datových schránek.* |
| 2.3.3 | ESSL umožňuje uživatelské roli vyhledání datové schránky v informačním systému datových schránek. |
| 2.3.4 | ESSL zajišťuje stahování údajů z obálek doručených datových zpráv a jejich uložení do metadat eSSL v rozsahu:   1. datum a čas dodání, |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. datum a čas doručení, 2. odesílatel. |
| 2.3.5 | Pokud je datová zpráva přijata, eSSL uchová jako samostatné komponenty dokumentu   1. datovou zprávu v původním formátu postupem podle požadavku [2.4.2,](#_bookmark70) 2. hlavičku datové zprávy ztvárněnou do samostatné komponenty a 3. jednotlivé připojené komponenty. |

# *Kontejnerové datové formáty*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.4.1 | ESSL zajistí při příjmu doručeného dokumentu automatizované zpracování komponenty dokumentu v datovém formátu, který má charakter kontejneru, podle požadavků [2.4.3](#_bookmark71) a [2.4.4](#_bookmark72), a to alespoň pro formáty ASiC, FO/ZFO, EML, ISDOCX, ZIP, PDF/A. Povinnost automatického zpracování se nevztahuje na šifrované komponenty v datovém formátu, který má charakter kontejneru, a na již zpracované datové zprávy. |
| 2.4.2 | ESSL uchová kontejner doručeného dokumentu v nezměněné podobě jako samostatnou komponentu alespoň do okamžiku uzavření spisu. |
| 2.4.3 | ESSL při automatizovaném zpracování kontejneru zajistí vyjmutí všech komponent vnořených v první úrovni kontejneru a jejich uložení jako samostatných komponent. Pokud je vyjmutá komponenta v datovém formátu uvedeném v požadavku [2.4.1](#_bookmark69), proces automatického zpracování se opakuje. ESSL v případě selhání automatického zpracování kontejneru poskytne zpracovateli informaci o selhání. |
| 2.4.4 | požadavek zrušen |
| 2.4.5 | požadavek zrušen |
| 2.4.6 | požadavek zrušen |

# *Změna datového formátu komponenty a převod dokumentu*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.5.1 | ESSL po provedení požadavků kapitoly [2.6](#_bookmark78) v případě statických textových dokumentů, statických kombinovaných textových a obrazových dokumentů a statických obrazových dokumentů (alespoň DOC, DOCX, XLS, XLSX, PPT, PPTX, ODT, ODS, ODP, RTF, TXT, PDF, HTM, HTML, BMP) automatizovaně provede změnu datového formátu komponenty na výstupní a výstup změny datového formátu uloží jako novou verzi téže komponenty.  *Převod datových formátů lze řešit i jako asynchronní operaci tak, aby nebylo blokováno další zpracování dokumentu*. |
| 2.5.2 | ESSL při změně datového formátu podle požadavku [2.5.1](#_bookmark74) připojí doložku obsahující informace uvedené v právním předpisu upravujícím podrobnosti výkonu spisové služby  a) do stejné komponenty za obsah vstupu změny datového formátu, umožňuje-li to formát výstupu změny datového formátu, nebo |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | b) do nové komponenty ve výstupním formátu statických textových dokumentů; v takovém případě bude součástí doložky hash výstupní komponenty ze změny datového formátu a název použité hashovací funkce. |
| 2.5.3 | ESSL v případě vlastních dokumentů původce postupuje obdobně jako v požadavku [2.5.1](#_bookmark74)   1. před podepsáním komponenty, a 2. při uzavření spisu, pokud nebyla komponenta podepsána.   Připojení doložky podle požadavku [2.5.2](#_bookmark75) a časového razítka se nevyžaduje. |
| 2.5.4 | ESSL v případě převodu dokumentu z analogové do digitální podoby připojí doložku obsahující informace uvedené v právním předpisu upravujícím podrobnosti výkonu spisové služby obdobně jako v požadavku [2.5.2.](#_bookmark75) |
| 2.5.5 | ESSL opatří výstup převodu dokumentu podle požadavku [2.5.2](#_bookmark75) nebo změny datového formátu dokumentu podle požadavku [2.5.4](#_bookmark76) příslušnými zajišťovacími prvky. |

# *Ověřování zajišťovacích prvků*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.6.1 | ESSL při příjmu nebo vložení komponenty automatizovaně zajistí ověření platnosti zajišťovacích prvků, které jsou ke komponentám připojeny.  *Ověření platnosti zajišťovacích prvků lze řešit i jako asynchronní operaci tak, aby nebylo blokováno další zpracování dokumentu*. |
| 2.6.2 | ESSL při ověření zajišťovacích prvků v době příjmu nebo vložení zaznamená do metadat údaje stanovené právním předpisem upravujícím podrobnosti výkonu spisové služby nebo k dokumentu připojí samostatnou komponentu, která údaje o ověření obsahuje. |

# *Evidence dokumentů*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.7.1 | ESSL automatizovaně přidělí každé entitě jednoznačný identifikátor. Jednoznačné identifikátory se přiřazují alespoň k   1. spisovému a skartačnímu plánu jako celku, 2. věcné skupině, 3. spisu, 4. typovému spisu, 5. součásti typového spisu, 6. dílu typového spisu, 7. dokumentu (jednoznačný identifikátor dokumentu), 8. komponentě, 9. skartačnímu režimu. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.7.2 | ESSL přiřadí dokumentu pořadové číslo v rámci předem určeného časového období, zpravidla konkrétního kalendářního roku. Správcovská role stanoví před začátkem určeného časového období jeho počátek a konec. |
| 2.7.3 | ESSL vede číselník organizačních součástí původce nebo jiných údajů stanovených původcem. Číselník udržuje správcovská role a obsahuje alespoň   1. údaj, 2. datum počátku používání údaje, 3. datum konce používání údaje.   ESSL umožňuje znázornění a export/import číselníku prostřednictvím přílohy č. 7. |
| 2.7.4 | ESSL umožňuje správcovské roli konfigurovat strukturu čísla jednacího (míněno pořadí metadat a oddělovače) podle právního předpisu upravujícího podrobnosti výkonu spisové služby:   1. vycházející z pořadového čísla dokumentu v rámci předem určeného časového období (viz požadavek [2.7.2](#_bookmark81)), 2. vycházející ze spisové značky doplněním pořadového čísla dokumentu ve spisu.   *Například URAD-EPR/2008-525, kde „525“ je pořadové číslo v rámci určeného časového období, „2008“ určené časové období a „EPR“ označení organizační součásti (požadavek* [*2.7.3*](#_bookmark82)*). Obdobně URAD-EPR/2008-222-11, kde „URAD-EPR/2008-222“ je spisová značka a „11“ pořadové číslo dokumentu ve spisu. Použití variant podle písm. a) nebo b) se řídí v příslušné věcné skupině nebo součásti typového spisu příznakem podle požadavku* [*3.1.2*](#_bookmark98) *písm.* [*h)*](#_bookmark99)*, respektive požadavku* [*3.3.6*](#_bookmark118) *písm.* [*c)*](#_bookmark119)*.* |
| 2.7.5 | ESSL podporuje sledování oběhu dokumentů a spisů v analogové podobě prostřednictvím funkce předání a převzetí, s cílem zaznamenat jejich umístění, zpracovatele a datum předání, popřípadě převzetí. |
| 2.7.6 | ESSL umožní uživateli zaznamenat do metadat pokyny pro schvalování a oběh dokumentu nebo spisu. |

# *Jmenný rejstřík*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.8.1 | ESSL neumožní uživatelské roli ukončit příjem doručeného dokumentu bez vytvoření vazby mezi záznamem o osobě odesílatele ve jmenném rejstříku a dokumentem. |
| 2.8.2 | ESSL umožní v rámci odeslání dokumentu výběr adresáta ze jmenného rejstříku a automaticky zaznamená vazbu mezi záznamem o osobě adresáta ve jmenném rejstříku a dokumentem. |
| 2.8.3 | ESSL do okamžiku vyřazení dokumentu umožní uživatelské roli zaznamenání vazby mezi záznamem o jiné osobě ve jmenném rejstříku a dokumentem. |
| 2.8.4 | požadavek zrušen |
| 2.8.5 | ESSL do okamžiku vyřazení spisu umožní uživatelské roli zaznamenání vazby mezi záznamem ve jmenném rejstříku a spisem. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.8.6 | ESSL umožňuje uživatelské roli vyhledávat ve jmenném rejstříku záznamy o podnikajících fyzických osobách a o právnických osobách. |
| 2.8.7 | ESSL umožňuje uživatelské roli vyhledávat ve jmenném rejstříku záznamy o fyzických osobách a výsledky vyhledávání omezí na záznamy, se kterými má uživatelská role oprávnění disponovat   1. na základě nastavených oprávnění nebo 2. existujících vazeb na dokumenty nebo spisy. |
| 2.8.8 | ESSL umožňuje uživatelské roli ztotožnit záznam ve jmenném rejstříku prostřednictvím zadání údajů potřebných pro jeho ztotožnění. Za údaje potřebné pro ztotožnění osoby se považují alespoň:   1. jméno, příjmení, datum narození a adresa trvalého pobytu u fyzické osoby, 2. jméno, příjmení, datum narození, adresa sídla a právní forma u fyzické osoby podnikající, 3. obchodní firma nebo název nebo označení a právní forma u právnické osoby, 4. identifikační číslo osoby u právnické osoby nebo fyzické osoby podnikající, 5. identifikátor datové schránky. |
| 2.8.9 | V případě, že na základě údajů o osobě nelze k dokumentu nebo spisu přiřadit záznam ve jmenném rejstříku:   1. jsou-li k dispozici údaje podle požadavku [2.8.8,](#_bookmark86) eSSL umožní ztotožnění ve zdrojích dat o fyzických osobách podle požadavku [2.8.10](#_bookmark87) nebo o právnických osobách podle požadavku [2.8.11](#_bookmark88) a zaznamená údaje z použitého zdroje dat do záznamu jmenného rejstříku, 2. nejsou-li k dispozici údaje podle požadavku [2.8.8](#_bookmark86) nebo se nepodaří osobu ztotožnit podle písm. a), eSSL umožní vytvoření nového záznamu ve jmenném rejstříku bez ztotožnění osoby a záznam označí jako neztotožněný. |
| 2.8.10 | ESSL umožňuje ověřování údajů o fyzických osobách alespoň v těchto zdrojích:   1. registr obyvatel informačního systému základních registrů, 2. informační systém datových schránek. |
| 2.8.11 | ESSL umožňuje ověřování údajů o právnických osobách a fyzických osobách podnikajících alespoň v těchto zdrojích:   1. registr osob informačního systému základních registrů, 2. informační systém datových schránek. |
| 2.8.12 | ESSL je možné konfigurovat tak, že využívá notifikační služby informačního systému základních registrů pro automatickou aktualizaci údajů u záznamů jmenného rejstříku ztotožněných v informačním systému základních registrů. |
| 2.8.13 | ESSL při příjmu a odeslání dokumentu spojeného se záznamem ve jmenném rejstříku zajišťuje automatickou aktualizaci údajů u záznamů osob ztotožněných podle požadavků [2.8.10](#_bookmark87) a [2.8.11](#_bookmark88); s výjimkou případů, kdy eSSL využívá notifikační službu podle požadavku [2.8.12.](#_bookmark89) |
| 2.8.14 | ESSL automaticky identifikuje vícečetné záznamy ve jmenném rejstříku na základě shody položek podle požadavku [2.8.8](#_bookmark86) a o nalezeném stavu informuje uživatelskou roli |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | oprávněnou ke správě jmenného rejstříku. ESSL umožní této uživatelské roli manuálně identifikovat vícečetné záznamy ve jmenném rejstříku. |
| 2.8.15 | ESSL umožní správcovské roli nastavit lhůtu pro automatické vymazání údajů   1. o fyzické osobě vedené ve jmenném rejstříku, která nemá vazbu na dokument nebo spis, a 2. o právnické osobě vedené ve jmenném rejstříku, která nemá vazbu na dokument nebo spis. |
| 2.8.16 | ESSL umožní správcovské roli manuální zničení údajů o osobě vedené ve jmenném rejstříku, která nemá vazbu na dokument nebo spis. |
| 2.8.17 | ESSL provádí identifikaci záznamů ve jmenném rejstříku, které nemají vazbu na dokument nebo spis, a u těchto záznamů sleduje lhůtu pro jejich zničení podle požadavku [2.8.15.](#_bookmark90) Pokud je k záznamu ve jmenném rejstříku nově připojena vazba na dokument nebo spis a u tohoto záznamu již plyne lhůta pro zničení, je plynutí této lhůty zrušeno. |
| 2.8.18 | ESSL provádí automaticky zničení záznamů ve jmenném rejstříku, kterým uplynula lhůta pro zničení podle požadavku [2.8.15](#_bookmark90) a které nemají vazbu na dokument nebo spis. |
| 2.8.19 | ESSL umožňuje správcovské roli nastavit specifické podmínky ochrany osobních údajů v podobě určení uživatelské role oprávněné ke čtení, zápisu, úpravě a správě jmenného rejstříku a rozsahu oprávnění této uživatelské role ve vztahu k vedení jmenného rejstříku. |
| 2.8.20 | ESSL umožňuje uživatelské roli vyhledávat, filtrovat a setřídit záznamy ve jmenném rejstříku. |

# *Samostatná evidence dokumentů*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 2.9.1 | Je-li samostatná evidence dokumentů napojena na eSSL, musí tak být realizováno rozhraním podle kapitoly [8.1](#_bookmark189), jehož prostřednictvím samostatná evidence dokumentů zajišťuje správu entit v eSSL, není-li jiný způsob napojení efektivnější. |
| 2.9.2 | Samostatná evidence dokumentů, která je napojena na eSSL, nemusí splňovat požadavky [2.9.3](#_bookmark92) až [2.9.16](#_bookmark94), pokud je zajišťuje prostřednictvím eSSL. Pokud samostatná evidence dokumentů využívá integraci na eSSL, musí taková samostatná evidence podporovat tvorbu spisů v souladu s požadavkem [2.9.9](#_bookmark93). |
| 2.9.3 | Jestliže samostatná evidence dokumentů zajišťuje příjem dokumentů, musí splňovat alespoň požadavky [2.1.1](#_bookmark63) až [2.1.3](#_bookmark64) a požadavky kapitoly [2.6](#_bookmark78). |
| 2.9.4 | Jestliže samostatná evidence dokumentů zajišťuje příjem e-mailů, musí zajišťovat alespoň   1. automatizované stahování a uložení e-mailových zpráv doručených na určené elektronické adresy, 2. označení stažených e-mailových zpráv z určené elektronické adresy příznakem, že byly staženy, 3. odesílání e-mailových zpráv prostřednictvím určené elektronické adresy, |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | d) uchování e-mailové zprávy v původním formátu postupem podle požadavku  [2.4.2](#_bookmark70) jako samostatné komponenty,   1. uchování obsahu (těla) e-mailové zprávy jako samostatné komponenty a 2. uchování jednotlivých připojených příloh jako samostatných komponent. |
| 2.9.5 | Jestliže samostatná evidence dokumentů zajišťuje příjem a odesílání dokumentů prostřednictvím informačního systému datových schránek, musí splňovat požadavky kapitoly [2.3](#_bookmark67). |
| 2.9.6 | Samostatná evidence dokumentů musí splňovat požadavky [2.4.1,](#_bookmark69) [2.4.3,](#_bookmark71) [2.4.4](#_bookmark72) a [2.5.1](#_bookmark74) až [2.5.5](#_bookmark77) týkající se datových formátů komponent. |
| 2.9.7 | Samostatná evidence dokumentů musí splňovat při evidenci dokumentu alespoň požadavky [2.7.1](#_bookmark80) a [2.7.5](#_bookmark84). |
| 2.9.8 | Samostatná evidence dokumentů zajišťuje, že dokumenty nebo spisy jsou vkládány do věcných skupin splňujících alespoň požadavky [3.1.1,](#_bookmark97) [3.1.2,](#_bookmark98) [3.1.8](#_bookmark101) až [3.1.12](#_bookmark103). |
| 2.9.9 | V případě, že samostatná evidence dokumentů spravuje spisy, musí splňovat alespoň požadavky [3.2.1,](#_bookmark105) [3.2.2](#_bookmark106), [3.2.4](#_bookmark107) až [3.2.7.](#_bookmark109) |
| 2.9.10 | Pokud samostatná evidence dokumentů spravuje typové spisy, musí splňovat požadavky kapitoly [3.3](#_bookmark115). |
| 2.9.11 | Samostatná evidence dokumentů musí splňovat alespoň požadavky [3.4.1](#_bookmark125), [3.4.4](#_bookmark126) a [3.4.5](#_bookmark127) týkající se vazeb mezi entitami. |
| 2.9.12 | Samostatná evidence dokumentů zajišťuje vedení a ztvárnění transakčního protokolu podle požadavku [5.2.12](#_bookmark148) a kapitoly [7.4.](#_bookmark187) |
| 2.9.13 | Samostatná evidence dokumentů musí splňovat požadavky [6.1.4,](#_bookmark154) [6.1.6](#_bookmark155) písm. a) až d), [6.1.7,](#_bookmark157) [6.1.10,](#_bookmark163) [6.1.11](#_bookmark164) a [6.1.12](#_bookmark165) týkající se skartačního režimu. |
| 2.9.14 | Samostatná evidence dokumentů při skartačním řízení musí splňovat alespoň požadavky kapitoly [6.2](#_bookmark166) a požadavky [7.2.1](#_bookmark179) až [7.2.10](#_bookmark182). V případě požadavku [7.2.10](#_bookmark182) se pro samostatnou evidenci jedná o doporučený seznam metadat. |
| 2.9.15 | Samostatná evidence dokumentů v případě exportu, importu nebo přenosu dat musí splňovat alespoň požadavek [6.3.1](#_bookmark171). |
| 2.9.16 | Samostatná evidence dokumentů musí splňovat požadavky kapitoly [2.8](#_bookmark85) týkající se jmenného rejstříku. |

## SPISOVÝ A SKARTAČNÍ PLÁN A ORGANIZACE SPISŮ

# *Věcné skupiny*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 3.1.1 | ESSL spravuje věcné skupiny v souladu se spisovým a skartačním plánem původce. ESSL zajišťuje, že věcné skupiny jsou uspořádány hierarchicky, přičemž spisy a typové spisy smí být zatříděny pouze do věcných skupin na nejnižší úrovni hierarchie (neobsahují jiné věcné skupiny). |
| 3.1.2 | ESSL vede o věcné skupině alespoň tato metadata:   1. jednoznačný identifikátor, 2. spisový znak, 3. obsah – slovní popis, 4. datum otevření, 5. datum uzavření.   O věcné skupině na nejnižší úrovni hierarchie eSSL dále vede alespoň tato metadata:   1. odkaz na skartační režim, 2. příznak, že věcná skupina je určena pro typové spisy, 3. příznak, který stanoví způsob přidělování čísla jednacího dokumentům v zakládaných spisech dané věcné skupiny (požadavek [2.7.4](#_bookmark83)) s výjimkou věcné skupiny určené pro typové spisy podle písm. g), 4. příznak, že na obsah věcné skupiny je uplatněn trvalý skartační souhlas vydaný příslušným archivem a s vyznačením, zda má být realizován požadavek [3.2.9](#_bookmark110) písm. [a)](#_bookmark111). |
| 3.1.3 | požadavek zrušen |
| 3.1.4 | ESSL umožňuje správcovské roli   1. přidat nové věcné skupiny, 2. uzavřít stávající věcné skupiny pro vkládání 3. pro jednotlivé věcné skupiny samostatně stanovit datum otevření věcné skupiny.   *Primární entitou je věcná skupina, spisový a skartační plán je časový řez aktuálně platných věcných skupin* |
| 3.1.5 | ESSL umožňuje správcovské roli upravit v metadatech obsah – slovní popis stávající věcné skupiny, aniž by vznikla nová věcná skupina. |
| 3.1.6 | ESSL umožňuje správcovské roli v každé konkrétní věcné skupině spisového plánu nastavit možnost vytvářet typové spisy. ESSL zajistí, že v této věcné skupině nesmí být vložena jiná věcná skupina nebo spis. |
| 3.1.7 | ESSL spravuje spisové a skartační plány, které jsou souhrnem věcných skupin používaných v danou dobu. ESSL vede o spisovém a skartačním plánu alespoň tato metadata:   1. jednoznačný identifikátor, 2. název spisového a skartačního plánu, |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. popis spisového a skartačního plánu, 2. platnost od, 3. platnost do, 4. odkaz na věcné skupiny, které tvoří spisový a skartační plán. |
| 3.1.8 | ESSL umožňuje uživatelské roli vkládat spisy a typové spisy pouze do otevřených věcných skupin, tj. do aktuálně platného spisového a skartačního plánu. |
| 3.1.9 | ESSL umožňuje posuzovateli skartační operace hromadné přetřídění uzavřených spisů z věcné skupiny do jiné věcné skupiny; tyto věcné skupiny mohou být uzavřené nebo otevřené. |
| 3.1.10 | požadavek zrušen |
| 3.1.11 | ESSL zajišťuje, aby všechny spisové znaky byly jednoznačné v rámci konkrétního spisového a skartačního plánu. |
| 3.1.12 | ESSL umožňuje správcovské roli v rámci výchozí konfigurace eSSL zajistit, že spisové znaky tvořené zřetězením jednoduchých spisových znaků budou odděleny právě jedním z následujících znaků:   1. „.“ (tečka, ASCII kód 46), 2. „–“ (pomlčka, ASCII kód 45), 3. „/“ (lomítko, ASCII kód 47), 4. „ “ (mezera, ASCII kód 32). |

# *Spisy*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 3.2.1 | ESSL zajistí, že podle volby uživatelské role se nový spis otevře   1. ve věcné skupině, nebo 2. v dílu typového spisu zvolené součásti typového spisu. |
| 3.2.2 | ESSL při založení spisu automaticky přiřadí spisu jednoznačný identifikátor, spisovou značku, spisový znak a způsob přidělování čísla jednacího podle věcné skupiny nebo součásti typového spisu, ve které byl spis založen. ESSL automaticky zaznamená datum založení spisu. |
| 3.2.3 | ESSL při vložení dokumentu do spisu automaticky přiřadí dokumentu pořadové číslo ve spisu a číslo jednací podle požadavku [2.7.4.](#_bookmark83) |
| 3.2.4 | ESSL zajistí založení spisu   1. na základě dokumentu; v tom případě automaticky vyplní stručný obsah spisu podle stručného obsahu dokumentu a umožní jeho bezprostřední editaci, nebo 2. bez dokumentu; v tom případě stručný obsah spisu vyplní uživatelská role. |
| 3.2.5 | ESSL na základě volby uživatelské role zajistí vložení dokumentu do založeného spisu podle přístupových práv uživatelské role. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 3.2.6 | ESSL na základě volby uživatelské role vyřídí spis a datum vyřízení zaznamená do metadat. Vyřízením spisu jsou současně vyřízeny všechny dokumenty v něm, které již dříve nebyly vyřízeny samostatně podle požadavku [3.2.7.](#_bookmark109) |
| 3.2.7 | ESSL umožní uživatelské roli označit jednotlivé dokumenty ve spisu jako vyřízené. Tím není dotčen požadavek [3.2.6](#_bookmark108). |
| 3.2.8 | ESSL na základě konfigurace umožní vyznačení vyřízení spisu jeho uzavřením. |
| 3.2.9 | ESSL na základě volby uživatelské role uzavře spis. Přitom provede kontrolu   1. datových formátů komponent, které popřípadě převede do výstupních datových formátů, 2. metadat zapisovaných uživatelskou rolí, která jsou nezbytná pro vytvoření SIP balíčku podle přílohy č. 2, přičemž uživatelskou roli případně vyzve k jejich doplnění. |
| 3.2.10 | ESSL zajistí, že pokud je věcná skupina nebo součást typového spisu, ve kterém se spis v okamžiku svého uzavření nachází, označena příznakem podle požadavku [3.1.2](#_bookmark98) písm. [i)](#_bookmark100), resp. [3.3.6](#_bookmark118) písm. [d),](#_bookmark120) pak neprovede kontrolu a související činnosti   1. podle požadavku [3.2.9,](#_bookmark110) nebo 2. podle požadavku [3.2.9](#_bookmark110) písm. [b).](#_bookmark112)   *V případě delších skartačních lhůt je vhodné i v případě uděleného skartačního souhlasu provést kontrolu a případně převod všech komponent do výstupního formátu, aby původce byl schopen po dobu trvání lhůty realizovat potřeby spojené s ukládaným dokumentem podle požadavku* [*3.2.10*](#_bookmark113) *písm.* [*a).*](#_bookmark114) |
| 3.2.11 | ESSL na základě volby uživatelské role uzavřený spis otevře. Uzavřený spis vytvořený nebo vložený do dílu typového spisu, který je již uzavřen, se při otevření automaticky přetřídí do otevřeného dílu typového spisu v příslušné součásti. |
| 3.2.12 | Jestliže je znovuotevíraný spis v uzavřené věcné skupině eSSL vyzve uživatelskou roli, aby spis přetřídila do otevřené věcné skupiny. |
| 3.2.13 | Jestliže je znovuotevíraný spis v uzavřeném typovém spisu nebo v uzavřené součásti typového spisu, eSSL provede znovuotevření uzavřeného typového spisu nebo uzavřené součásti typového spisu a otevře spis v nově otevřeném dílu. |
| 3.2.14 | Při změně spisového a skartačního plánu, v jejímž rámci dojde k uzavření věcné skupiny, ve které jsou zatříděny spisy, eSSL vyzve správcovskou roli k přetřídění otevřených spisů z uzavírané do otevřené věcné skupiny. Na základě volby správcovské role eSSL hromadně přetřídí označené spisy. |

# *Typové spisy, součásti typového spisu a díly typového spisu*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 3.3.1 | ESSL umožňuje uživatelské roli zakládat typové spisy. ESSL umožňuje zakládat typové spisy pouze v otevřené věcné skupině k tomu určené. |
| 3.3.2 | ESSL při založení nového typového spisu v dané věcné skupině automaticky otevře součásti a díly typového spisu podle šablony typového spisu definované pro tuto věcnou skupinu. |

|  |  |
| --- | --- |
| 3.3.3 | ESSL zajišťuje, že   1. šablona typového spisu obsahuje alespoň jednu součást typového spisu, 2. součást typového spisu obsahuje alespoň jednu součást typového spisu nebo alespoň jeden díl typového spisu; žádná součást typového spisu nemůže obsahovat jinou součást typového spisu a současně díl typového spisu, 3. pokud otevřená součást typového spisu neobsahuje jinou součást typového spisu, pak obsahuje právě jeden otevřený díl typového spisu, 4. díly typového spisu v různých součástech typového spisu jsou na sobě nezávislé. |
| 3.3.4 | ESSL při uzavření věcné skupiny s otevřenými typovými spisy zajistí, že správcovská role   1. stanoví věcnou skupinu pro typové spisy, do které mají být otevřené typové spisy přetříděny a vytvoří pro ni šablonu typového spisu se shodnou strukturou, jakou měla šablona typového spisu původní věcné skupiny, 2. namapuje šablonu původní věcné skupiny a nové věcné skupiny, 3. má možnost přidat do vytvořené šablony typového spisu nové věcné skupiny další součásti typového spisu, které se nemapují podle písm. b), přičemž do těchto nových součástí typového spisu nebudou přetřiďovány žádné entity.   ESSL zajistí hromadné přetřídění otevřených typových spisů do nové věcné skupiny pro typové spisy podle namapování šablon k datu platnosti nového spisového a skartačního plánu, přičemž u přetřiďovaných typových spisů:   * 1. přetřídí díly typových spisů výhradně do těch součástí typových spisů, které byly namapovány podle písm. b),   2. nezmění skartační režimy již uzavřených dílů typových spisů,   3. uplatní dědičnost skartačního režimu z nové součásti typového spisu na otevřené spisy v otevřených dílech typových spisů,   4. v otevřených dílech typových spisů nezmění skartační režimy uzavřených spisů, které budou následně podléhat při uzavření dílu typového spisu případnému řešení konfliktu skartačních režimů podle požadavku [6.1.8](#_bookmark158) písm. [b),](#_bookmark160)   5. automaticky otevře prázdný díl typového spisu pro každou novou součást typového spisu na nejnižší úrovni hierarchie, která nebyla zahrnuta v šabloně původní věcné skupiny. |
| 3.3.5 | ESSL zajistí, že v rámci vytváření věcné skupiny obsahující typové spisy správcovská role definuje pro tuto věcnou skupinu šablonu typového spisu. |
| 3.3.6 | ESSL musí pro určitou věcnou skupinu umožnit správcovské roli vytvoření šablony typového spisu. Každá součást typového spisu v šabloně typového spisu:  a) je označena spisovým znakem, který vzniká doplněním zděděného spisového znaku věcné skupiny typového spisu, ve které jsou typové spisy vytvářeny, nebo doplněním zděděného spisového znaku součásti typového spisu, do které je daná součást typového spisu vložena, o jednoduchý spisový znak součásti typového spisu, |

|  |  |
| --- | --- |
|  | 1. má přidělený skartační režim, pokud do ní není vložena jiná součást typového spisu, 2. má nastavený způsob přidělování čísla jednacího v zakládaných spisech dané součásti typového spisu (požadavek [2.7.4](#_bookmark83)), 3. příznak, že je na obsah součásti typového spisu uplatněn trvalý skartační souhlas vydaný příslušným archivem a s vyznačením, zda má být realizován požadavek [3.2.9](#_bookmark110) písm. [a)](#_bookmark111).   *Například požadavky na typové spisy týkající se organizací zřizovaných původcem mohou zahrnovat následující součásti: Statutární dokumenty a jejich příprava, Podklady statutárních orgánů a jejich vedení, Vnitřní předpisy, Zápisy vedení zasílané na vědomí, Zprávy a hlášení, Výroční zprávy, Rozbory hospodaření, Audity, Příprava rozpočtu, Zaměstnanecké záležitosti, Investice, Provoz, Členství v mezinárodních organizacích a Ostatní.*  *Každý nový typový spis vytvořený v této věcné skupině je poté automaticky vytvořen s těmito součástmi podle šablony, kterou připraví správcovská role. Spisový znak a skartační režim jsou přidělovány v šabloně například následovně:*   * 1. *Věcná skupina původce pro dané typové spisy*   *Typový spis zřizované organizace A (vytvořený podle šablony součástí typového spisu)*   * + 1. *Statutární dokumenty a jejich příprava A 10*     2. *Podklady statutárních orgánů a jejich vedení A 10*     3. *Vnitřní předpisy A 5*     4. *Zápisy vedení zasílané na vědomí S 5*     5. *Zprávy a hlášení*        1. *Výroční zprávy A 10*        2. *Rozbory hospodaření A 10*        3. *Audity A 5*     6. *Příprava rozpočtu S 5*     7. *Zaměstnanecké záležitosti A 5*     8. *Investice A 5*     9. *Provoz S 5*     10. *Členství v mezinárodních organizacích A 5*     11. *Ostatní S 5* |
| 3.3.7 | ESSL zajistí, že v případě změny šablony typového spisu bude pro tvorbu nových typových spisů uzavřena stávající věcná skupina a zároveň bude otevřena nová věcná skupina pro tvorbu typových spisů založených na změněné šabloně. ESSL zajistí přetřídění otevřených typových spisů z uzavírané věcné skupiny postupem podle požadavku [3.3.4.](#_bookmark116) |
| 3.3.8 | Aniž by se měnila příslušná šablona typového spisu, eSSL umožňuje správcovské roli v šabloně typového spisu pro konkrétní věcnou skupinu upravit   1. názvy součástí typového spisu, 2. určené časové období dílu pro každou součást typového spisu, pokud do ní není vložena jiná součást typového spisu. |

|  |  |
| --- | --- |
| 3.3.9 | ESSL umožňuje nastavit určené časové období dílu typového spisu pro konkrétní součást typového spisu v šabloně typového spisu stanovením doby, po kterou má být díl otevřen.  *Například: 5 let, školní rok, kalendářní rok.* |
| 3.3.10 | ESSL umožňuje zakládat spisy a vkládat spisy do otevřených dílů typového spisu. |
| 3.3.11 | požadavek zrušen |
| 3.3.12 | ESSL umožňuje uživatelské roli uzavření typového spisu a součásti typového spisu. |
| 3.3.13 | ESSL neumožní uzavření typového spisu nebo součásti typového spisu, pokud obsahuje díl typového spisu s neuzavřeným spisem. |
| 3.3.14 | ESSL automaticky uzavře díl typového spisu po uplynutí určeného časového období. ESSL při uzavření dílu typového spisu zajistí v příslušné součásti typového spisu automatické otevření nového dílu typového spisu. Pokud je díl typového spisu v okamžiku uzavírání prázdný, ESSL zajistí automatické zničení uzavíraného dílu typového spisu s výjimkou hlavičky metadat. |
| 3.3.15 | ESSL kontroluje, zda jsou v případě uzavření dílu typového spisu uzavřeny i všechny v něm vytvořené nebo do něj vložené spisy. Jestliže tyto spisy uzavřeny nejsou, eSSL automaticky vyjme spis z uzavíraného dílu a vloží jej do nově otevřeného dílu v příslušné (otevřené) součásti. |
| 3.3.16 | ESSL zabraňuje uživatelské roli zakládat spisy v uzavřeném dílu typového spisu nebo vkládat spisy do uzavřeného dílu typového spisu. |
| 3.3.17 | ESSL neumožní přiřazení skartačního režimu typovému spisu; typový spis nemá skartační režim. |
| 3.3.18 | ESSL zajistí, že součást typového spisu, do které je v šabloně typového spisu   1. vložen díl typového spisu, má v daný okamžik právě jeden skartační režim, 2. vložena jiná součást typového spisu, nemá skartační režim. |
| 3.3.19 | ESSL v okamžiku otevření dílu typového spisu přiřadí dílu typového spisu skartační režim nadřazené součásti typového spisu. |
| 3.3.20 | ESSL při práci s typovými spisy zobrazuje uživatelské roli entity vytvořené nebo vložené v dílech typového spisu jako entity součásti typového spisu, tj. potlačuje zobrazování dílů typového spisu. Informace o dílu typového spisu a jeho obsahu eSSL zobrazí na základě volby uživatelské role, přičemž umožní   1. ztvárnit základní metadata dílu typového spisu za účelem vytištění obalu analogových částí podle požadavku [5.2.5](#_bookmark144) a ztvárnit seznam spisů v dílu typového spisu, 2. doplnit fyzické umístění analogových částí dílu typového spisu,   *Při běžné práci, pokud například uživatelská role vkládá spisy do dílu typového spisu, eSSL uživatelské roli znázorní pouze příslušnou součást typového spisu. Uživatelská role nesmí být nucena vyhledávat v rámci součásti typového spisu díl typového spisu.* |

# *Udržování vazeb mezi entitami*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 3.4.1 | ESSL zajistí, že entity typový spis, součást typového spisu, díl typového spisu, spis nebo dokument budou otevřeny, založeny, vloženy nebo zatříděny právě do jedné nadřazené entity. U věcné skupiny hierarchicky podřízené jiné věcné skupině toto platí obdobně. |
| 3.4.2 | ESSL nedovolí uzavření entity, pokud nejsou uzavřeny všechny jí podřízené entity. ESSL před uzavřením dílu typového spisu všechny v něm otevřené spisy přetřídí do nově otvíraného dílu typového spisu. |
| 3.4.3 | ESSL umožňuje správcovské roli hromadně přetřídit (přemístit) veškerý obsah celé věcné skupiny nebo jeho vyznačenou část do jiné věcné skupiny v rámci spisového plánu. |
| 3.4.4 | ESSL zajišťuje označení spisů nebo typových spisů přetříděných do jiných věcných skupin novými spisovými znaky. Pro označení součástí typového spisu spisovými znaky platí první věta obdobně. |
| 3.4.5 | ESSL umožní roli při přetřiďování spisů rozhodnout, zda budou přetříděny i uzavřené spisy. |
| 3.4.6 | ESSL zajistí, že do uzavřené entity není možné vkládat ani z ní vyjímat jiné entity.  Výjimkou pro vyjmutí je   1. uzavřená věcná skupina nebo uzavřený díl typového spisu, ze kterých je vyjímán spis za účelem jeho znovuotevření v aktuálně otevřené věcné skupině nebo otevřeném dílu typového spisu, 2. přetřídění uzavřených spisů podle požadavku [3.1.9.](#_bookmark102)   Pokud se vyjmutím spisu podle písm. a) uzavřený díl typového spisu vyprázdní, eSSL zajistí automatické zničení tohoto dílu typového spisu s výjimkou hlavičky metadat. |
| 3.4.7 | Pokud je dokument zařazený ve spisu přetříděn do jiného spisu, ve kterém je číslo jednací tvořeno na základě   1. spisové značky a pořadí dokumentu ve spisu, eSSL přidělí dokumentu nové číslo jednací, 2. přiřazeného pořadového čísla v rámci předem určeného časového období podle požadavku [2.7.2,](#_bookmark81) eSSL přidělí dokumentu nové číslo jednací v případě, že původní číslo jednací bylo přiděleno na základě spisové značky a pořadí dokumentu ve spisu. |
| 3.4.8 | ESSL zajistí, že po přetřídění podle požadavku [3.4.7](#_bookmark129) budou požadavek [5.1.8](#_bookmark140) písm. [b)](#_bookmark141) a požadavek [5.2.6](#_bookmark145) písm. [b)](#_bookmark146) realizovány s novým i původním číslem jednacím. |
| 3.4.9 | ESSL zajistí, že pokud je přetřiďován spis do jiné věcné skupiny nebo součásti typového spisu, nezmění se způsob přidělování čísla jednacího dokumentům, který byl nastaven při jeho založení (požadavky [2.7.2](#_bookmark81), [3.1.2](#_bookmark98) a [3.3.6](#_bookmark118)). |

## ODKAZOVÁNÍ MEZI ENTITAMI

# *Křížové odkazy*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 4.1.1 | ESSL umožňuje uživatelské roli vytvořit volný křížový odkaz mezi   1. spisy, 2. dokumenty, 3. spisy a dokumenty. |
| 4.1.2 | ESSL umožňuje uživatelské roli vytvořit pevný křížový odkaz v případě připojení spisu k jinému spisu, přičemž nezáleží, zda je některý ze spisů uzavřený nebo otevřený. Nejvýše jeden ze spisů propojených pevným křížovým odkazem může být otevřený. Uzavřený spis může být propojen pevným křížovým odkazem pouze v případě, že má vyřešené případné konflikty skartačních režimů podle požadavku  [6.1.8](#_bookmark158) písm. [a).](#_bookmark159) |
| 4.1.3 | ESSL nedovolí vytvářet pevné křížové odkazy na spisy založené v dílu typového spisu nebo vložené do dílu typového spisu. Jestliže je do dílu typového spisu vkládán spis obsahující pevný křížový odkaz na jiný spis, eSSL vloží do dílu typového spisu oba spisy, přičemž zároveň odstraní pevný křížový odkaz mezi vkládanými spisy. |
| 4.1.4 | ESSL nejpozději při uzavření spisu obsahujícího pevný křížový odkaz, nebo v okamžiku propojení dvou uzavřených spisů pevným křížovým odkazem, přetřídí podle konfigurace eSSL (požadavek [4.1.5](#_bookmark134)) jeden ze spisů do věcné skupiny ke druhému spisu. Zároveň eSSL provede kontrolu konfliktu skartačních režimů propojených spisů podle požadavku [6.1.8.](#_bookmark158) Výsledný skartační režim stanovený podle požadavku [6.1.8](#_bookmark158) odst. [1)](#_bookmark161) eSSL přiřadí všem spisům, které jsou propojeny pevným křížovým odkazem.  Jestliže je alespoň jeden ze spisů propojených pevným křížovým odkazem vkládán do dílu typového spisu, eSSL všechny propojené spisy přetřídí do dílu typového spisu a automaticky odstraní pevné křížové odkazy. |
| 4.1.5 | ESSL je možné konfigurovat tak, že v případě spisů, mezi nimiž je vytvořen pevný křížový odkaz, a jsou zatříděny v různých věcných skupinách, automaticky při provádění požadavku [4.1.4](#_bookmark133) všechny tyto spisy přetřídí do věcné skupiny, ve které je zatříděn   1. nejdříve založený spis, nebo 2. nejpozději založený spis. |
| 4.1.6 | ESSL povolí odstranění pevného křížového odkazu pouze zpracovateli. ESSL zajistí zadání důvodu odstranění pevného křížového odkazu. |
| 4.1.7 | ESSL umožňuje uživatelské roli hromadně zjistit informace o metadatech alespoň v rozsahu hlavičky metadat entit spojených křížovým odkazem. ESSL umožní tyto entity na základě uživatelských práv znázornit. |

# *Druhy dokumentů*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 4.2.1 | ESSL udržuje číselník druhů dokumentů. ESSL omezuje definování a udržování číselníku druhů dokumentů výlučně na správcovskou roli. |
| 4.2.2 | ESSL zajistí, že dokument má přiřazen nejvýše jeden druh dokumentu. |
| 4.2.3 | ESSL umožňuje konfigurovat specifické prvky metadat pro druhy dokumentů.  *Například faktury se odlišují použitím metadat čísel účtů.* |
| 4.2.4 | ESSL umožní přiřadit novému druhu dokumentu skartační režim, který je pro daný druh dokumentu nadále neměnný. |

## VYHLEDÁVÁNÍ, VÝBĚR, ZNÁZORNĚNÍ A ZTVÁRNĚNÍ

# *Vyhledávání a výběr*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 5.1.1 | ESSL při vyhledávání poskytne uživatelské roli pouze informace (metadata nebo obsah komponent), ke kterým má tato uživatelská role oprávněný přístup. |
| 5.1.2 | Pokud uživatel požaduje přístup k entitám, ke kterým nemá přístupová práva, a jejich vyhledávání nebo přístup požaduje provést jiným způsobem, než je uvedeno v požadavku [5.1.1,](#_bookmark139) eSSL   1. neposkytne žádné informace o entitě (uživateli není poskytnuta informace, zda entita existuje, nebo nikoliv), 2. potvrdí existenci entity (znázorní identifikaci spisu, typového spisu, součásti typového spisu nebo dokumentu), popřípadě uvede zpracovatele entity, neznázorní však název entity ani jiná metadata, 3. znázorní pouze název, druh entity (například u věcné skupiny a dokumentu), datum vytvoření a zpracovatele, nebo 4. znázorní název a další metadata entity.   *Jiným způsobem vyžádání přístupu, než je uveden v požadavku* [*5.1.1*](#_bookmark139)*, se myslí zejména pokus o přístup k entitě na základě reference v systému (zahrnutí entity v seznamu nebo výpisu, funkčním dialogu apod.), přímého zadání odkazu na entitu nebo zobrazení entitu zahrnující apod. Rozsah zobrazených informací podle jednotlivých písmen požadavku je řízen kombinací oprávnění uživatele a způsobu vyžádání přístupu k entitám.* |
| 5.1.3 | ESSL umožňuje roli podle přístupových oprávnění vyhledat a vybrat   1. dokumenty, 2. jakoukoli úroveň věcné skupiny, spisu, typového spisu a součásti typového spisu a jejich příslušná metadata. |
| 5.1.4 | ESSL poskytuje vyhledávací funkci, která umožňuje v jakékoli vzájemné kombinaci spojit vyhledávací podmínky za použití booleovských operátorů   1. A („AND“), 2. NEBO („OR“), 3. NE („NOT“). |
| 5.1.5 | ESSL umožňuje roli podle přístupových oprávnění vyhledávat v metadatech a ve strojově čitelné textové vrstvě komponent podle numerického, alfanumerického nebo textového řetězce. Výsledkem vyhledávání ve strojově čitelné textové vrstvě komponent je příslušná komponenta. |
| 5.1.6 | ESSL umožňuje roli omezit rozsah vyhledávání na ty věcné skupiny, spisy, typové spisy, součásti typového spisu, které role určila. |
| 5.1.7 | ESSL umožňuje roli stanovit časové intervaly pro vyhledávání, například formou rozsahu nebo počtu dnů. |
| 5.1.8 | ESSL zajišťuje vyhledávání a řazení výsledků vyhledávání alespoň podle   1. identifikace typového spisu nebo součásti typového spisu, |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. čísla jednacího nebo části čísla jednacího dokumentu, 2. spisové značky nebo části spisové značky spisu, 3. jednoznačného identifikátoru, 4. zpracovatelů, 5. data odeslání, 6. data doručení nebo v případě vlastních dokumentů data zaevidování, 7. označení a identifikace dokumentu provedených odesílatelem, 8. názvu (věci) věcné skupiny, dokumentu, spisu, typového spisu nebo součásti typového spisu, 9. spisového znaku, 10. skartačního režimu, 11. způsobu odeslání, 12. způsobu doručení. |
| 5.1.9 | ESSL umožňuje správcovské roli vyhledávat v transakčním protokolu specifické operace, entity, uživatele, role, časové údaje nebo časové intervaly. |
| 5.1.10 | Pokud je vyhledán znepřístupněný dokument, eSSL informuje uživatelskou roli podle přístupových oprávnění o existenci původního dokumentu, případně dokument uživatelské roli zpřístupní na základě zvláštního oprávnění. |

# *Znázornění a ztvárnění*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 5.2.1 | ESSL uživatelské roli pracující s věcnou skupinou, spisem, typovým spisem, součástí typového spisu nebo dokumentem znázorní informace o   1. všech hierarchicky nadřazených entitách a 2. všech entitách připojených křížovým odkazem. |
| 5.2.2 | ESSL zpřístupňuje uživatelské roli obsah věcných skupin, spisů, typových spisů, součástí typových spisů nebo dílů typových spisů k prohlížení bez rozlišování mezi uzavřenými a otevřenými věcnými skupinami, spisy, typovými spisy, součástmi typového spisu nebo díly typového spisu. |
| 5.2.3 | ESSL zajistí uživatelské roli ztvárnění metadat dokumentu, spisu, součásti typového spisu a typového spisu vedených v eSSL. |
| 5.2.4 | ESSL umožňuje uživatelské roli zobrazit na obrazovce u každého přijatého dokumentu jeho metadata. |
| 5.2.5 | ESSL zajistí uživatelské roli ztvárnění základních metadat za účelem vytištění obalu analogových částí spisu a dílu typového spisu. Základními metadaty pro ztvárnění jsou alespoň   1. spisová značka spisu nebo název typového spisu, 2. název součásti typového spisu, 3. stručný obsah (předmět, věc) spisu, 4. datum založení/uzavření spisu nebo dílu typového spisu, |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. jednoznačný identifikátor spisu nebo dílu typového spisu včetně vyjádření ve strojově čitelném kódu, 2. spisový znak, 3. skartační režim. |
| 5.2.6 | ESSL znázorní uživatelské roli alespoň tato metadata:   1. jednoznačný identifikátor, 2. číslo jednací dokumentu (požadavek [2.7.4](#_bookmark83)), 3. spisový znak, 4. část transakčního protokolu zachycující historii entity, zejména oběh, 5. spisovou značku spisu, 6. název typového spisu a součásti typového spisu, 7. datum uzavření věcné skupiny, spisu, typového spisu, součásti typového spisu a dílu typového spisu, 8. skartační režim, 9. křížové odkazy na jiné entity, 10. informaci o umístění analogové části spisu, 11. podobu dokumentu (analogová, nebo digitální); jestliže je alespoň jedna z částí dokumentu analogová, podoba celého dokumentu se považuje za analogovou. |
| 5.2.7 | ESSL roli podle přístupových oprávnění dále znázorní a umožní ztvárnění za účelem vytištění alespoň   1. pevný křížový odkaz vzájemně identifikující spojené spisy, 2. u typového spisu seznam všech spisů zařazených do dílů jednotlivých součástí typového spisu v členění po dílech pro jednotlivá určená časová období, 3. seznam všech dokumentů ve spisu, jejich jednoznačné identifikátory a čísla jednací. |
| 5.2.8 | ESSL pro hromadný tisk zajistí uživatelské roli znázornění údajů stanovených v požadavcích [5.2.3](#_bookmark143) až [5.2.7](#_bookmark147). |
| 5.2.9 | ESSL zajistí uživatelské roli znázornění seznamu všech spisů nebo typových spisů včetně zatřídění do věcné skupiny. |
| 5.2.10 | ESSL zajistí správcovské roli ztvárnění spisového plánu za účelem jeho vytištění. |
| 5.2.11 | ESSL zajistí ztvárnění vyhledaných informací podle kapitoly [5.1](#_bookmark138) nebo znázorněných podle kapitoly [5.2](#_bookmark142) do komponenty ve výstupním datovém formátu. |
| 5.2.12 | ESSL obsah transakčního protokolu za stanovený časový úsek, nejdéle však jeden den, automaticky na konci tohoto časového úseku uloží jako dokument s komponentou v datovém formátu PDF/A nebo XML podle přílohy č. 6, který opatří elektronickou pečetí a elektronickým časovým razítkem podle standardu PAdES nebo XAdES-T. Podepisovanou oblastí XML bude vždy kořenový element, kterým je TransakcniLogSystemu. Tato podepisovaná data budou zapouzdřena v elementu Signature/Object. Syntaxe podpisu bude Enveloping. ESSL automaticky dokument zatřídí do spisu. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 5.2.13 | ESSL zajistí uživatelské roli hromadné ztvárnění metadat jednoho nebo více spisů. Ztvárněný spis obsahuje metadata spisu, metadata vložených dokumentů a metadata komponent alespoň v rozsahu:   1. název původce, 2. spisový znak, 3. skartační režim spisu, 4. spisová značka, 5. číslo jednací, nebo evidenční číslo ze samostatné evidence dokumentů, 6. předmět (věc), 7. zpracovatel, 8. podepisující komponenty, 9. soupis spisů připojených pevným křížovým odkazem, 10. soupis spisů připojených volným křížovým odkazem, 11. uživatelské poznámky spisu se jménem uživatele a datem, 12. příslušné části transakčního protokolu, 13. soupis dokumentů ve spisu.   Samostatné komponenty se řadí následujícím způsobem   * 1. komponenta obsahující údaje podle písm. a) až k),   2. komponenta obsahující příslušnou část transakčního protokolu (písm. l) ztvárněného v PDF/A, který opatří elektronickou pečetí a elektronickým časovým razítkem podle standardu PAdES,   3. komponenta obsahující soupis dokumentů vložených ve spisu (písm. m),   4. jednotlivé dokumenty a jejich komponenty.   *Například dokumenty se označí třímístným pořadovým číslem počínaje „001“ a každá jejich komponenta se (ve správném pořadí) označí dvoumístným pořadovým číslem komponenty za pomlčkou (například „001–02“).* |
| 5.2.14 | ESSL zajistí správcovské roli ztvárnění konfiguračních parametrů za účelem jejich vytištění. |
| 5.2.15 | ESSL umožňuje správcovské roli vytvářet seznamy uživatelských rolí a jednotlivých uživatelů pro kontrolu jejich přístupu ke konkrétním entitám a seznamy entit pro kontrolu přístupových práv uživatelů k nim. |

## UKLÁDÁNÍ A VYŘAZOVÁNÍ DOKUMENTŮ

# *Skartační režimy*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 6.1.1 | ESSL umožňuje výlučně správcovským rolím vytvářet a upravovat skartační režim a přiřazovat jej   1. nově otevíraným věcným skupinám, 2. stávajícím věcným skupinám; v takovém případě je vytvořena nová věcná skupina se stejným spisovým znakem a popisem, do které jsou automaticky přetříděny otevřené spisy ze stávající věcné skupiny a tato věcná skupina je uzavřena, 3. šablonám součástí typových spisů při jejich vzniku, 4. nově vytvářeným druhům dokumentů.   ESSL zajistí, že znepřístupněný skartační režim nebude možné přiřadit podle písm. a) až d).  *Tím nejsou dotčeny skartační režimy dokumentů podle předchozí právní úpravy.* |
| 6.1.2 | ESSL neumožní   1. odstranit skartační režim, který je v eSSL používán, 2. změnit přiřazení skartačního režimu k otevřené nebo uzavřené věcné skupině (požadavek [6.1.1](#_bookmark151) písm. [b)](#_bookmark152), součásti typového spisu (požadavek [6.1.1](#_bookmark151) písm. [c)](#_bookmark153) a požadavek [3.3.7](#_bookmark121)) nebo druhu dokumentu. |
| 6.1.3 | ESSL zajistí, že skartační režim uplatňovaný na nově vytvořený dokument, spis, nebo díl typového spisu je děděn   1. z mateřské věcné skupiny v případě spisu, 2. ze spisu v případě dokumentu vloženého do tohoto spisu, 3. z příslušné součásti typového spisu v případě jejího dílu, 4. z dílu typového spisu v případě spisu vloženého do tohoto dílu. |
| 6.1.4 | ESSL umožňuje správcovské roli vždy přidělit skartační režim každé věcné skupině na nejnižší úrovni hierarchie, součásti typového spisu na nejnižší úrovni hierarchie nebo druhu dokumentu. |
| 6.1.5 | ESSL zajistí, že každý skartační režim obsahuje   1. jednoznačný identifikátor, 2. skartační lhůtu, 3. typ skartační operace (skartační znak „A“ nebo „S“), 4. spouštěcí událost. |
| 6.1.6 | ESSL umožňuje správcovské roli stanovit pro skartační režim jednu z následujících spouštěcích událostí   1. rok vyřízení spisu, 2. rok uzavření spisu, 3. rok založení spisu totožný s rokem jeho evidence, 4. rok narození nebo vzniku subjektu, |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | e) externí událost, u které nelze předem stanovit okamžik vzniku spouštěcí události (například formou užití slov „po skončení platnosti smlouvy“,  „od likvidace skládky“ nebo „po zahájení insolvenčního řízení“), s počtem let, po jejichž uplynutí eSSL vyzve posuzovatele skartační operace k posouzení, zda již externí spouštěcí událost nastala.  Skartační režim přiřazený druhu dokumentu může obsahovat spouštěcí událost pouze a), b), e). |
| 6.1.7 | ESSL umožňuje v rámci každého skartačního režimu tyto typy skartačních operací:   1. návrh na trvalé uložení pro dokumenty trvalé hodnoty (dokumenty označené skartačním znakem „A“), 2. návrh na zničení (dokumenty označené skartačním znakem „S“). |
| 6.1.8 | Pokud jsou dokumentu, spisu nebo dílu typového spisu současně přiřazeny různé skartační režimy (s jinou skartační lhůtou nebo s jiným skartačním znakem nebo jinou spouštěcí událostí), vzniká konflikt skartačních režimů.  Konflikty vznikají v následujících případech:   1. liší se skartační režim spisu a skartační režim v něm vloženého dokumentu, pokud má současně přiřazen skartační režim na základě druhu dokumentu, 2. liší se skartační režim dílu typového spisu a skartační režim spisu zatříděného v tomto dílu, který byl změněn po vypořádání konfliktu skartačních režimů spisu podle písm. a) nebo po přetřídění typových spisů do nové věcné skupiny pro typové spisy podle požadavku [3.3.4](#_bookmark116) odst. [4),](#_bookmark117) 3. liší se skartační režimy spisů spojených pevným křížovým odkazem podle požadavku [4.1.2.](#_bookmark132)   ESSL před uzavřením spisu nebo dílu typového spisu nebo při spojení dvou uzavřených spisů pevným křížovým odkazem (požadavek [4.1.4](#_bookmark133)) zajišťuje automaticky vyřešení konfliktů, které jsou v daném okamžiku již řešitelné:   * 1. Přidělením nejzávažnějšího skartačního režimu. Pokud alespoň jeden ze skartačních režimů v konfliktu obsahuje skartační znak „A“, bude v rámci výsledného skartačního režimu uplatněn skartační znak „A“, v ostatních případech bude uplatněn skartační znak „S“.   2. Přidělením nejvzdálenějšího roku vyřazení, který byl stanoven na základě skartačních lhůt a externích spouštěcích událostí, pokud je skartační režimy obsahují a již nastaly. Skartační lhůty a spouštěcí události, které byly v konfliktu skartačních režimů, se poté pro účely vyřazení již neuplatní. Jestliže v době uzavření spisu nebo dílu typového spisu nenastala externí spouštěcí událost a není možné stanovit rok vyřazení, bude automatické vypořádání konfliktu skartačních režimů odloženo do provedení požadavku   [6.1.6](#_bookmark155) písm. [e)](#_bookmark156) a požadavku [6.1.9](#_bookmark162). |
| 6.1.9 | Pokud eSSL identifikuje externí spouštěcí událost podle požadavku [6.1.6](#_bookmark155), která nemá uveden rok, kdy nastala, eSSL po uplynutí lhůty pro kontrolu spouštěcí události počítané od uzavření spisu vyzve posuzovatele skartační operace, aby rozhodl, zda externí spouštěcí událost nastala.  Jestliže spouštěcí událost |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. nastala, posuzovatel skartační operace zaznamená do metadat spisu rok, kdy pro spis spouštěcí událost nastala; obdobně se postupuje v případě dokumentu, který má přiřazen druh dokumentu obsahující skartační režim s externí spouštěcí událostí, 2. nenastala, posuzovatel skartační operace potvrdí eSSL tuto skutečnost; eSSL vyzve znovu k rozhodnutí posuzovatele skartační operace po uplynutí počtu let stanovených při rozhodnutí, zda externí spouštěcí událost nastala.   ESSL zajistí, že posuzovatel skartační operace může   * 1. pro součást typového spisu, pro spisy nebo pro dokumenty zatříděné ve věcné skupině podle předchozí právní úpravy kdykoli hromadně doplnit rok spouštěcí události,   2. individuálně u spisu kdykoli doplnit rok spouštěcí události. |
| 6.1.10 | Pokud uplyne skartační lhůta stanovená určitému dokumentu zatříděnému ve věcné skupině podle předchozí právní úpravy, spisu nebo dílu typového spisu skartačním režimem, eSSL vytvoří po vyřešení konfliktů skartačních režimů (požadavek [6.1.8](#_bookmark158)) návrh na jejich vyřazení. |
| 6.1.11 | ESSL umožňuje řízení procesu výběru dokumentů ve skartačním řízení výlučně posuzovateli skartační operace. |
| 6.1.12 | ESSL při přetřídění uplatní dědičnost skartačního režimu z nové mateřské věcné skupiny nebo z nové mateřské součásti typového spisu na přetřiďované spisy nebo dokumenty zatříděné ve věcné skupině podle předchozí právní úpravy. |
| 6.1.13 | ESSL umožňuje, aby posuzovatel skartační operace nastavil u věcné skupiny, spisu, typového spisu, součásti typového spisu nebo dílu typového spisu příkaz k pozastavení skartační operace. Toto pozastavení se vztahuje na všechny dceřiné entity věcné skupiny, spisu, typového spisu, součásti typového spisu a dílu typového spisu, na kterém bylo pozastavení skartační operace provedeno, i na entity propojené pevným křížovým odkazem s entitou, kde k pozastavení došlo. V případě dokumentů zatříděných ve věcné skupině podle předchozí právní úpravy se tento požadavek aplikuje obdobně. |
| 6.1.14 | ESSL zajistí, že pozastavení skartační operace nepřerušuje plynutí skartační lhůty. |
| 6.1.15 | ESSL zabraňuje u entity (včetně jejích dceřiných entit), na kterou je uplatněno pozastavení skartační operace,   1. znepřístupnění, 2. zařazení do návrhu na vyřazení dokumentů. |
| 6.1.16 | ESSL umožňuje posuzovateli skartační operace odstranit pozastavení skartační operace. |

# *Skartační řízení*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 6.2.1 | ESSL na základě pokynu posuzovatele skartační operace vytvoří seznam entit navržených k vyřazení, který je tvořen datovými balíčky SIP podle přílohy č. 2. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | Datový balíček SIP je tvořen podle požadavku [9.2.2](#_bookmark203) a na základě volby posuzovatele skartační operace   1. neobsahuje komponenty, nebo 2. obsahuje komponenty. |
| 6.2.2 | ESSL vytvoří seznam entit podle požadavku [6.2.1](#_bookmark167) tak, aby jej mohl původce   1. předat příslušnému archivu na technických nosičích dat, nebo 2. vložit na portál pro zpřístupnění archiválií v digitální podobě na základě uživatelského oprávnění posuzovatele skartační operace, nebo 3. předat automatizovaně příslušnému archivu prostřednictvím aplikačního rozhraní stanoveného Národním archivem, pokud bylo zveřejněno. |
| 6.2.3 | ESSL vždy zaznamená v datovém balíčku SIP vazbu na uložení analogových částí dokumentů a spisů, pokud existují.  *V případě dokumentů v analogové podobě je nezbytné spolu s evidencí udržovat jednoznačnou vazbu na fyzické dokumenty, které musí být v souladu s rozhodnutím o výběru archiválií přeneseny nebo zničeny.* |
| 6.2.4 | Příslušný archiv může v průběhu archivní prohlídky požádat prostřednictvím datové zprávy podle přílohy č. 4 o datové balíčky SIP obsahující komponenty. V takovém případě eSSL na základě seznamu, ve kterém je u identifikátorů entit uvedeno  „předložit k výběru“, exportuje datové balíčky SIP s komponentami. |
| 6.2.5 | ESSL zajistí vyznačení rozhodnutí o výběru archiválií na základě seznamu vytvořeného podle přílohy č. 4, který je zaslán příslušným archivem jako příloha protokolu o výběru archiválií:   1. u entity s vyznačenou operací „vybrat za archiválii“ vytvoří datové balíčky SIP obsahující i komponenty a entity označí jako určené k přenosu nebo exportu do digitálního archivu (kapitola [6.3](#_bookmark170)), a v případě analogových entit nebo jejich částí, k přenosu do příslušného archivu, 2. u entity s vyznačenou operací „zničit“ tyto entity označí ke zničení (kapitola [6.3](#_bookmark170)); přitom podporuje například prostřednictvím seznamů zničení odpovídajících entit v analogové podobě, 3. u entity s vyznačenou operací „vyřadit z výběru“ eSSL vyzve posuzovatele skartační operace k úpravě skartačního režimu, 4. u entity s vyznačenou operací „vybrat za archiválii“ nebo „zničit“ eSSL zaznamená Identifikátor skartačního řízení. |
| 6.2.6 | ESSL umožní posuzovateli skartační operace stanovit, které entity s vyznačenou operací „vybrat za archiválii“ budou určeny k přenosu. Toto rozhodnutí lze uskutečnit   1. jednotlivě pro konkrétní entity, nebo 2. hromadně pro všechny entity označené „vybrat za archiválii“. |
| 6.2.7 | ESSL zajistí, že pokud byl u spisu realizován požadavek [3.2.10](#_bookmark113), posuzovatel skartační operace může provést kontroly a související činnosti podle požadavku [3.2.9](#_bookmark110).  *Tento požadavek umožní původci připravit skartační operaci v případě, že je mu příslušným archivem odebrán trvalý skartační souhlas.* |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 6.2.8 | ESSL vyznačí identifikátory digitálního archivu zaslané příslušným archivem v podobě seznamu podle přílohy č. 4 k příslušným entitám (příloha úředního záznamu o předání). Tím je export nebo přenos těchto entit úspěšně ukončen.  *Současně musí být do příslušného archivu přeneseny i entity v analogové podobě.* |

# *Přenos, export a import*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 6.3.1 | ESSL přenáší, exportuje nebo importuje repliky entit, jejich metadata a příslušné části transakčního protokolu prostřednictvím příslušného schématu XML v příloze č. 7. |
| 6.3.2 | ESSL zajistí, aby přenos, export nebo import replik entit byl správcovskou rolí prováděn i hromadně na základě zvolených věcných skupin, spisů, typových spisů nebo součástí typových spisů. |
| 6.3.3 | ESSL umožňuje, aby byla tatáž entita exportována více než jednou. |
| 6.3.4 | ESSL při přenosu nebo exportu dokumentu, spisu, typového spisu, součásti typového spisu, dílu typového spisu nebo obsahu věcné skupiny provádí následující operace:   1. přenos nebo export repliky obsahu stanovené věcné skupiny, spisu, dokumentu, typového spisu, součásti typového spisu nebo dílu typového spisu, včetně jejich metadat a příslušných částí transakčního protokolu, 2. export všech replik hierarchicky nadřazených entit, včetně jejich metadat a příslušných částí transakčního protokolu, 3. export replik spisů napojených nebo vložených do exportované nebo přenášené entity pevným křížovým odkazem, včetně jejich metadat a příslušných částí transakčního protokolu, 4. přenos replik spisů napojených nebo vložených do exportované nebo přenášené entity pevným křížovým odkazem, včetně jejich metadat a příslušných částí transakčního protokolu, pokud jsou napojené nebo vložené spisy určeny k přenosu, 5. ukončení přenosu podle požadavku [6.3.8.](#_bookmark174) |
| 6.3.5 | ESSL při importu repliky dokumentu, spisu, typového spisu, součásti typového spisu, dílu typového spisu nebo obsahu věcné skupiny umožní uživatelskou volbu:   1. spisu, do kterého bude importován dokument, 2. věcné skupiny, do které bude importován spis, 3. cílové věcné skupiny, do které bude importován obsah zdrojové věcné skupiny, 4. věcné skupiny pro typové spisy a součásti (v šabloně typového spisu), do které bude importován spis nebo díl typového spisu ze zvolené zdrojové součásti typového spisu, 5. konkrétních dokumentů, spisů, typových spisů nebo součástí typových spisů, které mají být importovány, 6. věcné skupiny do které bude importován dokument vyřízený podle předchozí právní úpravy nebo v samostatné evidenci nepoužívající spisy.   ESSL |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. neumožní import spisu propojeného pevným křížovým odkazem, aniž by se importovaly všechny propojené spisy, 2. při importu spisů do věcné skupiny zachová pevné křížové odkazy mezi spisy, 3. podle uživatelské volby importuje entity hromadně, 4. při importu typových spisů zajistí, že odpovídá název zdrojového typového spisu a název jeho součásti názvu cílového typového spisu a jeho součásti, jinak se postupuje podle požadavku [3.3.4](#_bookmark116) bez ohledu na to, zda je zdrojový spis otevřený nebo uzavřený, 5. zaznamená přehled z technických důvodů neimportovaných entit a znázorní jej uživateli s možností ztvárnění tohoto přehledu. |
| 6.3.6 | ESSL umožní import vyřízených dokumentů zatříděných přímo ve věcné skupině tak, že tyto dokumenty mohou být opět zařazeny ve věcné skupině.  *Dokumenty bylo možné zatřiďovat do věcné skupiny podle předchozí právní úpravy.* |
| 6.3.7 | Součástí metadat replik entit podle požadavků [6.3.4](#_bookmark172) a [6.3.5](#_bookmark173) jsou příslušné záznamy   1. jmenného rejstříku, 2. číselníku podle požadavku [2.7.3](#_bookmark82). |
| 6.3.8 | ESSL uchovává spisy, typové spisy, součásti typového spisu, díly typového spisu, dokumenty, komponenty a metadata, které jsou přenášeny, a to alespoň do doby potvrzení úspěšnosti ukončeného přenosu jejich replik. Do této doby eSSL umožní opakování přenosu.  *U přenesených entit se i po ukončeném přenosu ve zdrojovém systému trvale uchovává hlavička metadat a příslušné části transakčního protokolu.* |
| 6.3.9 | ESSL zajistí správcovské roli   1. v kterémkoli okamžiku export spisového plánu a skartačních režimů podle přílohy č. 5, 2. jako součást nastavení výchozí konfigurace eSSL import spisového plánu a skartačních režimů podle přílohy č. 5. |

## SPRÁVA A BEZPEČNOST

# *Přístup*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.1.1 | ESSL neumožňuje uživateli provést jakoukoli operaci, nemá-li přidělenu roli s patřičným oprávněním. ESSL musí uživatele úspěšně identifikovat a ověřit. |
| 7.1.2 | ESSL umožňuje roli správu přístupových práv k entitám, ke kterým má tato role sama přiřazena přístupová práva. |
| 7.1.3 | ESSL umožňuje roli potvrdit, nebo odmítnout přiřazení přístupových práv k jakémukoliv dokumentu nebo spisu, která jí byla jinou rolí přiřazena. |
| 7.1.4 | ESSL umožňuje roli, která přiřadila přístupová práva k dokumentu nebo spisu, aby přiřazení zrušila, pokud již nebylo potvrzeno přiřazení. |
| 7.1.5 | ESSL do okamžiku uzavření spisu umožní uživatelské roli podle přístupových oprávnění změnit metadata dokumentu a spisu zapsaná uživatelskou rolí. Po uzavření spisu eSSL umožní správcovské roli změnit metadata dokumentu a spisu zapsaná uživatelskou rolí.  *Tato funkce umožňuje například spisovně provádět případné opravy chyb uživatelů (například chyby při vkládání dat, chybné zařazení ve věcných skupinách apod.).* |
| 7.1.6 | ESSL umožňuje správcovské roli využít konfiguraci oprávnění tak, aby byl konkrétní roli nebo uživateli před stanoveným datem, ke stanovenému datu nebo po stanoveném datu   1. omezen přístup ke konkrétním typovým spisům, součástem typových spisů, spisům, dokumentům nebo komponentám, 2. omezen přístup ke konkrétním věcným skupinám, 3. omezen přístup k určitým vlastnostem a funkcím eSSL (například ke čtení, k aktualizaci nebo k mazání určitých prvků metadat), 4. odmítnut přístup do eSSL. |
| 7.1.7 | ESSL umožňuje správcovské roli, aby   1. přidělovala oprávnění roli a 2. přiřadila jednoho nebo více uživatelů k jakékoli roli. |
| 7.1.8 | ESSL umožňuje správcovské roli definovat pro role přístupová práva stejně jako pro jednotlivé uživatele a přidělovat role jednotlivým uživatelům.  *Tento požadavek umožňuje správcovským rolím spravovat a udržovat soubor přístupových práv spíše pro limitovaný počet rolí, než je udržovat pro velký počet jednotlivých uživatelů.* |
| 7.1.9 | ESSL umožňuje posuzovateli skartační operace přetřídění entity v rámci věcných skupin (požadavek [3.1.9](#_bookmark102)), změnu metadat entity (požadavek [7.1.5](#_bookmark177)), nahlížení do komponent entity, pokud je entita uložena ve spisovně. |
| 7.1.10 | ESSL umožňuje správu věcných skupin výlučně správcovské roli. |
| 7.1.11 | ESSL umožňuje správcovské roli vyhledávání, zobrazení a změnu parametrů a nastavení eSSL, alespoň u   1. číselníků (požadavky [2.7.3](#_bookmark82), [4.2.1](#_bookmark136)), |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. určeného časového období (požadavek [3.3.9](#_bookmark122)), 2. otevírání a uzavírání věcných skupin (kapitola [3.1](#_bookmark96)), 3. skartačních režimů (kapitola [6.1](#_bookmark150)) a 4. tvorbu šablon typových spisů (požadavek [3.3.6](#_bookmark118)). |

# *Změny, zničení a znepřístupnění dokumentů*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.2.1 | ESSL neumožní zničení komponenty, dokumentu, spisu, typového spisu, součásti typového spisu nebo dílu typového spisu nebo jejich metadat, s výjimkou zničení   1. po dokončeném skartačním řízení, 2. na základě uděleného trvalého skartačního souhlasu, 3. po úspěšném dokončení přenosu, 4. po evidenčním převedení do jiné evidenční pomůcky, 5. znepřístupněných dokumentů a spisů, 6. samostatné komponenty došlého kontejneru po uzavření spisu, pokud došlo k úspěšnému vyjmutí všech obsažených komponent podle požadavku [2.4.3](#_bookmark71), 7. prázdného dílu typového spisu podle požadavku [3.3.14](#_bookmark123) a [3.4.6.](#_bookmark128) Při zničení musí být zachována hlavička metadat podle požadavku [7.2.9.](#_bookmark181) |
| 7.2.2 | ESSL zabrání změně komponenty, která je   1. schválena, pokud nedojde k odvolání schválení příslušnou rolí, 2. komponentou doručeného dokumentu, s výjimkou provádění požadavků [2.4.1](#_bookmark69),   [2.4.2](#_bookmark70) a [2.5.1.](#_bookmark74) |
| 7.2.3 | ESSL umožní posuzovateli skartační operace zničení spisu nebo dokumentu na základě trvalého skartačního souhlasu. |
| 7.2.4 | Pokud eSSL provádí zničení spisu nebo dokumentu na základě trvalého skartačního souhlasu, eSSL zajistí, aby posuzovatel skartační operace vyznačil do metadat jednoznačný identifikátor nebo číslo jednací rozhodnutí o udělení trvalého skartačního souhlasu. ESSL zajistí, že o zničení lze na základě volby posuzovatele skartační operace vytvořit hlášení podle požadavku [7.3.8.](#_bookmark186)  *Požadavek slouží k zajištění průkaznosti oprávnění k uvedenému jednání a zajišťuje častý požadavek příslušného archivu na předkládání informačních hlášení, kterým archiv podmiňuje vydání trvalého skartačního souhlasu.* |
| 7.2.5 | ESSL zničí spisy, typové spisy, součásti typového spisu, díly typového spisu, dokumenty, metadata a ztvárnění příslušné části transakčního protokolu, které jsou přenášeny, jestliže obdrží potvrzení o úspěšném ukončení přenosu, a to s výjimkou metadat, která jsou uchovávána v hlavičkách metadat (požadavky [7.2.9](#_bookmark181) a [7.2.10](#_bookmark182)). |
| 7.2.6 | ESSL zničí spisy, díly typového spisu, dokumenty a metadata, které byly určeny ke zničení při skartačním řízení (požadavek [6.2.5](#_bookmark168) písm. [b)](#_bookmark169), a to s výjimkou metadat, která jsou uchovávána v hlavičkách metadat (požadavky [7.2.9](#_bookmark181) a [7.2.10](#_bookmark182)). |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.2.7 | Pokud je v eSSL uplatněna výjimka podle požadavku [7.2.1,](#_bookmark179) eSSL postupuje tak, že dokument zničí spolu s příslušnými metadaty, kromě metadat specifikovaných jako hlavička metadat (požadavek [7.2.9](#_bookmark181)). |
| 7.2.8 | ESSL v případě zničení dokumentu nebo spisu automaticky z metadat odstraní vazbu na dokument nebo spis ze všech záznamů ve jmenném rejstříku. |
| 7.2.9 | ESSL uchovává hlavičku metadat podle přílohy č. 8 popisující   1. typové spisy, 2. součásti typových spisů, 3. díly typových spisů, 4. spisy, 5. dokumenty, 6. komponenty. |
| 7.2.10 | ESSL umožňuje správcovské roli stanovit další metadata, která budou uchována jako hlavička metadat. |
| 7.2.11 | ESSL nabízí konfigurační možnost dokumenty a spisy znepřístupnit. |
| 7.2.12 | ESSL umožní znepřístupnění dokumentu nebo spisu   1. uživateli, který dokument vytvořil a nepředal držení tohoto dokumentu jinému uživateli (první zpracovatel), 2. správcovské roli v případě dokumentů nikdy nezařazených do spisů nebo spisů, které neobsahují dokumenty.   ESSL přitom vyžaduje, aby uživatelská nebo správcovská role vyznačila důvod znepřístupnění. |
| 7.2.13 | ESSL zajistí, aby se znepřístupněné dokumenty a spisy při znázorňování a vyhledávání jevily jako zničené každé roli s výjimkou posuzovatele skartační operace. |
| 7.2.14 | ESSL nedovolí uživatelské nebo správcovské roli provést znepřístupnění dokumentů nebo spisů jako hromadnou operaci. |
| 7.2.15 | ESSL zajistí, aby posuzovatel skartační operace mohl znepřístupněné dokumenty nebo spisy – vyjma již zničených – uvést do původního stavu (zpřístupnit). |
| 7.2.16 | ESSL umožní posuzovateli skartační operace zničit znepřístupněné dokumenty za stanovené období s výjimkou hlaviček metadat, případně eSSL zajistí automatické zničení znepřístupněných dokumentů po uplynutí lhůty nastavené správcovskou rolí. |

# *Hlášení o stavu eSSL*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.3.1 | ESSL zahrnuje funkce ztvárnění stavových hlášení o své správě, stejně jako statistických a jednorázových informací (dále „zprávy“) a jejich vytištění nebo uložení v digitální podobě (například pro zpracování tabulkovým procesorem). |
| 7.3.2 | požadavek zrušen |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.3.3 | ESSL poskytuje alespoň zprávy o celkovém počtu spravovaných   1. spisů a typových spisů, 2. komponent tříděných podle datového formátu uvedeného v metadatu "datový formát komponenty"; uvede se datový formát a celkový počet komponent daného datového formátu, 3. dokumentů a spisů v držení zvoleného zpracovatele, 4. spisů, typových spisů a součástí typových spisů tříděných podle přístupových oprávnění jednotlivých uživatelů; uvede se jméno a příjmení uživatele, jeho uživatelská role a počty spisů, typových spisů a součástí typových spisů, pro které je aktuálním zpracovatelem. |
| 7.3.4 | ESSL poskytuje zprávy o fyzickém umístění analogových částí spisů a dílů typových spisů tříděných podle místa uložení. |
| 7.3.5 | ESSL poskytuje alespoň zprávy o   1. počtu přijatých dokumentů za stanovené období, 2. počtu nově vytvořených spisů a typových spisů v jednotlivých věcných skupinách za stanovené období; věcné skupiny jsou seřazeny podle spisového a skartačního plánu, 3. počtu spisů zatříděných v jednotlivých věcných skupinách za stanovené období nebo ke stanovenému datu; věcné skupiny jsou seřazeny podle spisového a skartačního plánu, 4. všech věcných skupinách otevřených ke stanovenému datu; u každé věcné skupiny se uvede spisový znak. |
| 7.3.6 | ESSL poskytuje zprávu o výsledcích procesů importu, výběru archiválií, přenosu, exportu, zničení s uvedením věcných skupin, typových spisů, součástí typových spisů, dílů typových spisů, spisů a dokumentů, které byly úspěšně importovány, zničeny, znepřístupněny, přeneseny nebo exportovány, s uvedením případných chyb, které v průběhu procesů nastaly. Popis chyby identifikuje dokumenty, věcné skupiny, typové spisy, součásti typového spisu, díly typového spisu, spisy a dokumenty a s nimi spojená metadata, které nebyly úspěšně importovány, přeneseny, exportovány, zničeny. |
| 7.3.7 | ESSL na vyžádání posuzovatele skartační operace poskytuje zprávu, která pro zadané období obsahuje údaje o provedeném znepřístupnění entit podle požadavku [7.2.12](#_bookmark183) v rozsahu:   1. jednoznačný identifikátor znepřístupněného dokumentu a spisová značka spisu, pokud byl dokument do spisu zařazen a po vyjmutí z něj znepřístupněn v souladu s požadavkem [7.2.12](#_bookmark183) písm. [a),](#_bookmark184) 2. spisová značka znepřístupněného spisu, 3. věc znepřístupněného dokumentu a spisu, 4. identifikace uživatele, který dokument znepřístupnil, 5. důvod znepřístupnění. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.3.8 | ESSL na vyžádání posuzovatele skartační operace poskytuje zprávu, která pro zadané období obsahuje údaje o provedeném zničení entit podle požadavku [7.2.1](#_bookmark179) písm. a) až d) v rozsahu:   1. identifikace posuzovatele skartační operace, 2. identifikace vydaného trvalého skartačního souhlasu, 3. datum a čas provedení operace zničení, 4. počet zničených dokumentů a spisů v rámci dílu typového spisu nebo určeného časového období věcné skupiny, ve které došlo ke zničení entit. |
| 7.3.9 | ESSL poskytuje zprávy o množství dokumentů, spisů a dílů typových spisů za stanovené období, kterým ke stanovenému datu uplynula skartační lhůta. |

# *Transakční protokol*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.4.1 | ESSL vede po celou dobu provozu transakční protokol a nepřipustí změnu nebo zničení údajů v něm. ESSL na vyžádání správcovské role ztvární úplný obsah transakčního protokolu do XML za zadané časové období. XML schéma transakčního protokolu je popsané v příloze č. 6.  *ESSL v případě technických omezení rozdělí ztvárnění transakčního protokolu do více samostatných komponent, přičemž jejich obsahy na sebe musí plynule navazovat.* |
| 7.4.2 | ESSL zapisuje do transakčního protokolu alespoň údaje o přístupu k entitě, pokusu o přístup k entitě, každé změně stavu nebo manipulaci s entitami, změně metadat entity (zaznamená nový stav), včetně uživatelských záznamů a pokynů pro schvalování a oběh entity. |
| 7.4.3 | ESSL zapisuje do transakčního protokolu alespoň údaje o vlastních změnách, změnách své konfigurace, nastavení a o změnách uživatelských oprávnění.  *Tento požadavek umožňuje jednoznačně identifikovat verzi eSSL a čas jejího nasazení do produkčního provozu, změny konfigurace a nastavení eSSL.* |
| 7.4.4 | ESSL zapisuje do transakčního protokolu veškeré automaticky prováděné operace. |
| 7.4.5 | ESSL zapisuje do transakčního protokolu veškeré operace se záznamy ve jmenném rejstříku, zejména jejich vytváření, úpravy, zničení a nahlížení na záznamy. |
| 7.4.6 | požadavek zrušen |
| 7.4.7 | Pokud posuzovatel skartační operace zavede, nebo odstraní pozastavení skartační operace, eSSL zapisuje do transakčního protokolu   1. datum, kdy bylo pozastavení zavedeno, nebo odstraněno, 2. identifikaci oprávněného uživatele, 3. důvod pozastavení, nebo důvod odstranění pozastavení. |
| 7.4.8 | ESSL zapisuje změnu spisového znaku věcné skupiny do transakčního protokolu, pokud provádí import podle požadavku [6.3.5.](#_bookmark173) |
| 7.4.9 | ESSL zapisuje do transakčního protokolu údaje o zničení (fyzickém vymazání) dokumentu podle požadavku [7.2.7](#_bookmark180). |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 7.4.10 | ESSL zajistí, že každý záznam v transakčním protokolu obsahuje údaj o uživateli, který změnu stavu nebo manipulaci provedl, a o času provedení změny nebo manipulace. |
| 7.4.11 | ESSL zapisuje do transakčního protokolu údaje o každém přihlášení nebo odhlášení uživatele. |
| 7.4.12 | ESSL zajišťuje dostupnost transakčního protokolu tak, aby byl na výzvu správcovské role znázorněn a ztvárněn. |
| 7.4.13 | ESSL při každé změně komponenty zapisuje do transakčního protokolu její hash a název použité hashovací funkce. |

## ROZHRANÍ PRO PROPOJENÍ INFORMAČNÍCH SYSTÉMŮ SPRAVUJÍCÍCH DOKUMENTY

# *Vazby mezi informačními systémy spravujícími dokumenty*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 8.1.1 | Rozhraní umožňuje synchronní i asynchronní komunikaci mezi informačními systémy spravujícími dokumenty původce, přičemž toto rozhraní je realizováno prostřednictvím webových služeb a schémat XSD uvedených v příloze č. 1. |
| 8.1.2 | Každý informační systém spravující dokumenty (včetně eSSL) má pro účely komunikace původcem přidělen jednoznačný identifikátor, který je používán pro označení zdroje a cíle komunikace. |
| 8.1.3 | Informační systém spravující dokumenty umožňuje, aby identifikace podle požadavku  [8.1.2](#_bookmark191) mohla být rozšířena o zajišťovací prvky, které mohou být volitelně použity při zabezpečení dávek XML. |
| 8.1.4 | Rozhraní mezi informačními systémy spravujícími dokumenty je založeno na nedělitelných událostech podle požadavků [8.1.8](#_bookmark193) a [8.1.10](#_bookmark195) a pracuje s entitami a jejich metadaty. Každá událost je označena identifikátorem; identifikátor události je jednoznačný v rámci daného systému a jeho součástí je jednoznačný identifikátor systému podle požadavku [8.1.2](#_bookmark191). |
| 8.1.5 | Při synchronní komunikaci volaná strana okamžitě vykoná požadovanou událost. Výsledek události je vrácen volající straně jako výsledek volání webové služby. |
| 8.1.6 | V rámci jednoho volání synchronní webové služby podle požadavku [8.1.8](#_bookmark193) musí být jednotlivá událost buď zcela a bezezbytku zpracována, nebo v případě vzniku chyby nebo stavu, kdy příjemce aktivně odmítne událost zpracovat, nesmí být zpracována vůbec. Částečné zpracování události je nepřípustné. |
| 8.1.7 | Při opakovaném příjmu identické události (události s identickým jednoznačným identifikátorem), která již byla jednou úspěšně provedena, musí volaná strana vrátit vždy stejný výsledek. Takové opakování se nesmí považovat za chybu. V případě, že je obsahem události vytvoření nové instance entity (například DokumentZalozeni, SpisZalozeni, DokumentPostoupeniZadost, SpisPostoupeniZadost, OsobaZalozeni), volaná strana událost podruhé nezpracuje, ale pouze volajícímu vrátí stejnou výslednou informaci jako při prvním úspěšném zpracování události. |
| 8.1.8 | Rozhraní eSSL poskytuje alespoň následující funkce:   1. **SpisZalozeni** – založení spisu nad dokumentem. Je možné založit celý spis i s dokumenty v něm, nebo je spis založen nad existujícím dokumentem. 2. **DokumentZalozeni** – zaevidování nového dokumentu přijatého nebo vzniklého v informačním systému spravujícím dokumenty. Nepřenáší kompletní profil dokumentu, ale jen údaje, které dávají smysl při založení popsané typem tProfilDokumentuZalozeni. 3. **DokumentPostoupeniZadost** – žádost o postoupení dokumentu (převzetí dokumentu do výhradní správy volajícím systémem). 4. **SpisPostoupeniZadost** – žádost o postoupení spisu (převzetí spisu do výhradní správy volajícím systémem). 5. **SpisVraceniZadost** – žádost o vrácení spisu do výhradní správy. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. **ProfilDokumentuZadost** – žádost o poskytnutí detailních informací o dokumentu. 2. **DokumentVraceniZadost** – žádost o vrácení dokumentu do výhradní správy. 3. **ProfilSpisuZadost** – žádost o poskytnutí detailních informací o spisu. 4. **ProfilTypovehoSpisuZadost** – žádost o poskytnutí detailních informací o typovém spisu. 5. **TypovySpisZalozeni** – služba pro založení typového spisu. 6. **SouborZadost** – žádost o poskytnutí obsahu zadané komponenty (pojem   „soubor“ v kontextu popisu rozhraní je identický s pojmem „komponenta“).   1. **CiselnikZadost** – žádost o poskytnutí číselníku. Kód (název) číselníku   zpravidla odpovídá názvu elementu, k němuž se číselník vztahuje. Pro určení číselníku se používá element IdCiselniku a ne Kod. Položky číselníku mohou přenášet větší množství nepovinných položek podle potřeby.   1. **CiselnikySeznam** - služba vrací seznam všech dostupných číselníků. 2. **DavkySeznam** – služba umožní volajícímu systému získat seznam dávek, které jsou ve volaném systému pro daný volající systém připraveny. 3. **DavkaZadost** – služba umožní volajícímu systému získat z volaného systému dávku. 4. **Udalosti** – žádost o okamžité vykonání předaného pole událostí. 5. **WsTest** – funkce pro otestování komunikace. Pouze informuje o aktuální dostupnosti volaného systému. 6. **PrideleneSeznam** – funkce pro zaslání seznamu všech entit konkrétního uživatele v daném systému. Funkce umožňuje filtrování podle identifikátoru, druhu entity, data vytvoření a data poslední změny. 7. **ProfilOsobyZadost** – žádost o poskytnutí detailních informací o osobě ve jmenném rejstříku. 8. **OsobaUprava** – žádost o úpravu dat osoby ve jmenném rejstříku. 9. **OsobySeznam** – služba pro vyhledání osoby ve jmenném rejstříku. 10. **OsobaZalozeni** – založení osoby ve jmenném rejstříku. 11. **ermsAsyn** – přenos dávek obsahujících události a zprávy podle požadavku [8.1.9.](#_bookmark194) |
| 8.1.9 | Rozhraní v rámci asynchronní komunikace sdružuje události do dávek. Součástí dávek jsou též zprávy o zpracování přijatých událostí. Dávka může obsahovat   1. události, 2. zprávy, nebo 3. události a zprávy. |
| 8.1.10 | Rozhraní podporuje příjem alespoň následujících událostí:   1. **DokumentZalozeni –** založení nového dokumentu. 2. **DokumentUprava** – úprava metadat existujícího dokumentu. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. **DokumentZruseni** – znepřístupnění existujícího dokumentu, který nikdy nebyl zařazen do spisu. 2. **DokumentOtevreni** – otevření dříve vyřízeného dokumentu. 3. **DokumentVyrizeni** – označení dokumentu za vyřízený. Podle konfigurace jiného informačního systému spravujícího dokumenty, resp. eSSL může být vyřízení dokumentu spojeno také s jeho uzavřením. 4. **DokumentPostoupeni** – předání dokumentu do výhradní správy jiného informačního systému spravujícího dokumenty, resp. eSSL (uplatní se vždy, když je předávána výhradní správa, tj. jak při předání z eSSL na informační systém spravující dokumenty, tak při předání z informačního systému spravujícího dokumenty na eSSL nebo mezi dvěma informačními systémy spravující dokumenty. 5. **DokumentVraceni** – vrácení zpracování dokumentu do eSSL. Reverzní událost k DokumentPostoupeni. 6. **DokumentVlozeniDoSpisu** – vložení dokumentu do spisu. Spis nesmí být uzavřen. 7. **DokumentVyjmutiZeSpisu** – vyjmutí dokumentu ze spisu. Dokument a spis musí existovat, spis nesmí být uzavřen. 8. **DokumentZmenaZpracovatele** – předání dokumentu jinému zpracovateli. Při předání mezi uživateli je v elementu „Autorizace“ původní zpracovatel, element „Prebirajici“ obsahuje údaje o novém zpracovateli. Při administrativním přidělení je administrátor v elementu „Autorizace“ a v elementu „Prebirajici“ je nový zpracovatel dokumentu. Pokud k události došlo jindy než v okamžiku zaevidování, je možno do elementu „predanoKdy“ uvést skutečné datum události. 9. **DokumentExterniSpousteciUdalost** – předání informace, že nastala událost, kterou je podmíněn začátek běhu skartační lhůty. 10. **DokumentSkartacniNavrh** – informace o zařazení dokumentu do skartačního návrhu s možností vynuceného vyjmutí ze skartačního návrhu v odpovědi na volání události. 11. **DokumentSkartovano** – předání informace, že nad dokumentem proběhlo skartační řízení. 12. **SpisZalozeni** – založení spisu. Nepřenáší kompletní profil spisu, ale jen údaje, které dávají smysl při založení popsané typem tProfilSpisuZalozeni. 13. **SpisUprava** – úprava metadat existujícího spisu. 14. **SpisPostoupeni** – předání spisu do výhradní správy jiného informačního systému spravujícího dokumenty, respektive eSSL. 15. **SpisVraceni** – vrácení zpracování spisu do eSSL. Reverzní událost ke SpisPostoupeni 16. **SpisOtevreni** – otevření dříve uzavřeného spisu. 17. **SpisUzavreni** – uzavření vyřízeného spisu. 18. **SpisZruseni** – znepřístupnění spisu, který neobsahuje dokumenty. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. **SpisVyrizeni** – vyřízení spisu včetně všech vložených dokumentů. Podle konfigurace eSSL může být vyřízení spisu spojeno také s jeho uzavřením. 2. **SpisZmenaZpracovatele** – předání spisu a všech vložených dokumentů jinému zpracovateli. Při předání mezi uživateli je v elementu „Autorizace“ původní zpracovatel, element „Prebirajici“ obsahuje údaje o novém zpracovateli. Při administrativním přidělení je administrátor v elementu   „Autorizace“ a v elementu „Prebirajici“ je nový zpracovatel spisu. Pokud k události došlo jindy než v okamžiku zaevidování, je možno do elementu  „predanoKdy“ uvést skutečné datum události.   1. **SpisExterniSpousteciUdalost** – předání informace, že nastala událost, kterou je podmíněn začátek běhu skartační lhůty. 2. **SpisSkartacniNavrh** – informace o zařazení spisu do skartačního návrhu s možností vynuceného vyjmutí ze skartačního návrhu v odpovědi na volání události. 3. **SpisSkartovano** – předání informace, že nad spisem proběhlo skartační řízení. 4. **SpisVlozeniDoTypovehoSpisu** – vložení spisu do součásti typového spisu (otevřeného dílu součásti). Součást nesmí být uzavřena. 5. **SpisVyjmutiZTypovehoSpisu** – vyjmutí spisu ze součásti typového spisu. Spis a součást typového spisu musí existovat. Díl typového spisu nesmí být uzavřen. 6. **DoruceniUprava** – změna metadat dokumentu týkajících se informací o přijetí původcem. 7. **VypraveniZalozeni** – vytvoření zásilky pro odeslání dokumentu. Stav nové zásilky je „nevypraveno“. 8. **VypraveniUprava** – úprava metadat zásilky. 9. **VypraveniVypraveno** – předání informace, že zásilka byla vypravena. 10. **VypraveniDoruceno** – zápis informací o doručení k zásilce. 11. **VypraveniZruseni** – znepřístupnění zásilky. 12. **VypraveniPredatVypravne** – pokyn k předání zásilky do výpravny k vypravení.   ii) **SouborZalozeni** – založení komponenty. Událost je potřeba použít před použitím komponenty v dalších událostech, například DokumentPostoupeni. V události může být předán elektronický obsah přímo nebo pouze odkaz (identifikátor) na soubor a v takovém případě zdrojová evidence dokumentů poskytuje cílové evidenci dokumentů REST službu (adresu URL), která na základě identifikátoru vrátí elektronický obsah komponenty včetně mimeType. REST služba musí podporovat metodu GET, názvy parametrů jsou  „HodnotaID“ a „ZdrojID“.   1. **SouborNovaVerze** – nahrazení stávající komponenty novou. 2. **SouborZruseni** – odstranění komponenty. 3. **SouborVlozitKDokumentu** – přiložení existující komponenty k dokumentu. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. **SouborVyjmoutZDokumentu** – odstranění komponenty z dokumentu. Komponenta nesmí být u tohoto dokumentu součástí zásilky, která je předána k vypravení. 2. **SouborVlozitKVypraveni** – určení komponenty, že bude součástí zásilky. 3. **SouborVyjmoutZVypraveni** – určení komponenty, že nebude dále součástí zásilky. 4. **SouborOdemkniFinal** – událost zruší příznak konečného tvaru komponenty. 5. **OdkazVytvoreni** – vytvoření nebo úprava pevného nebo volného křížového odkazu. 6. **OdkazZruseni** – odstranění pevného nebo volného křížového odkazu. 7. **UzivateleSeznam** – vrací seznam uživatelů systému. 8. **FunkcniMista** – vrací funkční místa jednoho uživatele systému. |
| 8.1.11 | V případě zpracování událostí v dávkách při asynchronní komunikaci jsou transakce realizovány na úrovni událostí, nikoliv dávek. Jedná se o rozdíl oproti synchronní komunikaci podle požadavku [8.1.6.](#_bookmark192) |
| 8.1.12 | Po odeslání jedné dávky při asynchronní komunikaci nemusí odesílatel čekat s odesláním dalších dávek až do příjmu potvrzení o zpracování předchozí odeslané dávky příjemcem. Lze odesílat i několik po sobě jdoucích dávek bez čekání na jejich zpracování a potvrzení protistranou. |
| 8.1.13 | Číslování dávek je unikátní jen pro každou komunikaci přes rozhraní eSSL. Dávky jsou číslovány vzestupnou řadou s přírůstkem 1 (jedna). Pořadová čísla dávek na sebe musí navazovat v nepřerušené, spojité řadě. |
| 8.1.14 | Pořadí dávek musí odpovídat pořadí dávek podle položky DatumVzniku uvedené v hlavičce každé dávky. |
| 8.1.15 | Události jsou číslovány vzestupnou řadou v rámci každé dávky. Pořadová čísla událostí nesmí svým pořadím odporovat pořadí zápisu událostí v XML souboru dávky. Číslo události nemusí být unikátní pro různé dávky. Počáteční hodnota, přírůstek ani spojitost číselné řady nejsou pro číslování událostí vyžadovány. |
| 8.1.16 | Dávky musí být vždy zpracovávány sekvenčně. Následující dávku lze zpracovat, jen pokud byla úspěšně zpracována dávka předchozí. Pokud nastane při zpracování dávky chyba, potom se zpracování všech dávek zastaví a musí se realizovat opravné zaslání a zpracování dávky, ve které byla detekována chyba; poté musí následovat sekvenční odeslání všech následujících dávek, a to i v případě, že již byly dříve zaslány. Tedy od chybně zpracované dávky se musí znovu poslat postupně všechny dávky znovu, přičemž první musí být poslána opravená dávka, ve které byla detekována chyba. |
| 8.1.17 | Každá dávka musí ve své hlavičce obsahovat identifikaci zdroje a cíle dávky. |
| 8.1.18 | Události jsou zpracovávány důsledně v pořadí, ve kterém jsou zapsány v dávce. Toto pořadí (umístění v dávce) musí odpovídat pořadí číselného označení událostí podle požadavku [8.1.15.](#_bookmark197) |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 8.1.19 | Událost musí být zpracována zcela, nebo nesmí být zpracována vůbec. Není přípustné částečné, neúplné zpracování jedné události. Jedná se o obdobu požadavku [8.1.6](#_bookmark192) pro asynchronní komunikaci. |
| 8.1.20 | Událost lze považovat za úspěšně odeslanou a zpracovanou příjemcem pouze v případě, že je zpracování potvrzeno v některé z následujících přijatých dávek. |
| 8.1.21 | Dávku lze považovat za zpracovanou pouze v případě, že všechny v ní obsažené události byly protistranou potvrzeny jako úspěšně zpracované. |
| 8.1.22 | Při potvrzení událostí je povoleno použít následující zjednodušení: Pokud je potvrzeno úspěšné zpracování poslední události v dávce, potom jsou tímto potvrzena úspěšná zpracování všech událostí této dávky. |
| 8.1.23 | Komunikace podle požadavku [8.1.1](#_bookmark190) probíhá prostřednictvím protokolu https. Jako vyšší stupeň zabezpečení může https server při komunikaci vyžadovat autentizaci klienta klientským certifikátem. |
| 8.1.24 | ESSL umožňuje zabezpečení integrity dat přenášených XML dávek elektronickou pečetí ve standardu podle platných právních předpisů. Použití nebo nepoužití tohoto zabezpečení závisí na konkrétní vazbě a eSSL musí umožňovat toto nastavení samostatně pro každou vazbu na jiný informační systém spravující dokumenty. Vztah mezi označením zdroje komunikace a konkrétním certifikátem elektronického podpisu nebo elektronické pečeti se nastaví při zavádění rozhraní, a to jako součást výchozí konfigurace komunikujících eSSL a informačním systémem spravujícím dokumenty. |
| 8.1.25 | Přístup k entitám je vždy výhradní, tedy události týkající se dané entity smí vytvářet pouze systém, který má aktuálně entitu ve své výhradní správě. Změna výhradní správy z jednoho systému na druhý je možná pouze prostřednictvím příslušných událostí. Výjimka je přípustná pouze jedna a je popsána požadavkem [8.1.27](#_bookmark198). |
| 8.1.26 | Systém s aktuálně nevýhradní správou může požádat voláním synchronní metody rozhraní o postoupení spisu a/nebo dokumentu z výhradní správy druhého systému do své výhradní správy. Této žádosti o postoupení výhradní správy spisu a/nebo dokumentu druhý systém může, a nemusí vyhovět. V případě zamítnuté žádosti o převzetí do výhradní správy musí volaný systém navrátit chybový kód, který bude popisovat zdůvodnění takového odmítnutí. |
| 8.1.27 | ESSL musí obsahovat správcovskou funkci, která zruší příznak výhradní správy entity informačním systémem spravujícím dokumenty (zejména v případě nefunkčnosti tohoto systému). U každé této servisní operace je třeba evidovat důvod a zaznamenat jej spolu s ostatními metadaty operace do transakčního protokolu. |
| 8.1.28 | V rámci konfigurace vazby mezi eSSL a informačním systémem spravujícím dokumenty musí být   1. sjednoceny všechny hodnoty ve všech propojených systémech, nebo 2. vytvořeny a implementovány převodní můstky mezi hodnotami použitými v jednotlivých systémech.   Jedná se alespoň o následující metadata:   * 1. uživatel („provedlKdo“, „novyZpracovatel“, „VlastniKdo“),   2. spisový a skartační plán („SpisovyPlan“), |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | 1. spisový znak („SpisovyZnak“), 2. druh dokumentu („DruhDokumentu“), 3. podací deník („PodaciDenik“), 4. způsob vyřízení spisu nebo dokumentu („ZpusobVyrizeni“), 5. skartační režim, 6. spouštěcí událost. |
| 8.1.29 | ESSL umožní pomocí rozhraní postoupit entitu ke zpracování informačnímu systému spravujícímu dokumenty na žádost uživatele podanou prostřednictvím informačního systému spravujícího dokumenty. Uživatel informačního systému spravujícího dokumenty si může vyžádat seznam přidělených dokumentů, spisů a součástí typových spisů prostřednictvím informačního systému spravujícího dokumenty bez toho, že by musel pracovat s eSSL. |
| 8.1.30 | Identifikátor entity přiděluje vždy ten informační systém spravující dokumenty, který entitu zaeviduje jako první. Ostatní systémy musí identifikátor převzít. |
| 8.1.31 | Označení zdroje identifikátoru podle požadavku [8.1.30](#_bookmark199) je shodné s identifikací podle požadavku [8.1.2](#_bookmark191) a musí být v rámci původce unikátní. |
| 8.1.32 | V případech, kdy je nutné mezi eSSL a informačním systémem spravujícím dokumenty vyměňovat, popřípadě modifikovat metadata nad rámec specifikace jednotlivých funkcí (požadavek [8.1.8](#_bookmark193)) nebo událostí (požadavky [8.1.10](#_bookmark195) a [8.1.11](#_bookmark196)), jsou funkce a události vybaveny obecným elementem „DoplnujiciData“, který slouží pro specifikaci takovýchto metadat. Výčet a rozsah následného užití těchto metadat závisí na implementaci rozhraní mezi eSSL a informačním systémem spravujícím dokumenty. |

## METADATA

# *Obecné požadavky na metadata*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 9.1.1 | ESSL umožňuje správcovské roli stanovit další metadata entit nad rámec přílohy č. 8 a definovat, který prvek metadat je povinný a který volitelný. |
| 9.1.2 | ESSL podporuje alespoň následující formáty prvků metadat:   1. alfabetické, 2. alfanumerické, 3. numerické, 4. časové, 5. logické („ANO/NE“). |
| 9.1.3 | ESSL umožňuje správcovské roli stanovit, které hodnoty prvků metadat mají být zapsány a udržovány ručně a které výběrem z číselníku. |

# *Požadavky na metadata datových balíčků SIP*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 9.2.1 | ESSL zajistí vytvoření datového balíčku SIP přílohy č. 2 skládajícího se z adresáře (složky)   1. pro provedení skartačního řízení (výběr archiválií), 2. pro předání dokumentů do archivu.   *Datový balíček SIP (LABEL="Datový balíček pro předávání dokumentů a jejich metadat do archivu") vytvořený podle písm. b) může být použit i pro provedení skartačního řízení (pro výběr archiválií).* |
| 9.2.2 | ESSL zajistí, že datový balíček SIP je tvořen   1. právě jedním dílem typového spisu, a to případně včetně entit, které k němu byly podle předchozí právní úpravy připojeny pevnými křížovými odkazy, 2. právě jedním spisem, 3. spisy, pokud jsou navzájem propojeny pevnými křížovými odkazy, 4. právě jedním samostatným dokumentem, pokud byl podle předchozí právní úpravy zatříděn přímo do věcné skupiny.   *Písmeno d) se použije obdobně i na dokumenty samostatné evidence dokumentů, která sama nevytváří spisy.* |
| 9.2.3 | ESSL zajistí, že datový balíček SIP obsahuje veškerá metadata a komponenty vložených entit. |
| 9.2.4 | ESSL zajistí, že součástí datového balíčku SIP jsou příslušné části transakčního protokolu ve formátu XML, které se týkají vložených entit. |
| 9.2.5 | ESSL zajistí, že adresář (složka) obsahuje soubor XML a případně adresář pro uložení dalších komponent. Do adresáře pro uložení dalších souborů, pokud je vytvářen, se vždy vkládají alespoň všechny verze komponenty, které již jsou ve výstupním datovém formátu. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 9.2.6 | ESSL zajistí, že soubor XML je pojmenován „mets.xml“.  *Příklad: jednoznacny\_nazev\_sip [dir]*  *|-mets.xml* |
| 9.2.7 | ESSL zajistí, že každý soubor XML popisuje právě jeden datový balíček SIP. Není možné v jednom souboru XML popisovat více datových balíčků SIP. |
| 9.2.8 | ESSL zajistí, že základní logická struktura souboru XML podle přílohy č. 2 odpovídá předepsanému schématu XML METS 1.12. Obsah souboru XML je dále specifikován podmínkami použití prvků schématu XML METS podle přílohy č. 2, část 2. Tyto podmínky jsou závazné pro určení správnosti datového balíčku SIP. |
| 9.2.9 | ESSL zajistí, že znakovou sadou souboru XML je Unicode/UCS v kódování UTF 8 bez BOM (Byte order mark). |
| 9.2.10 | ESSL zajistí, že komponenty se ukládají do adresáře (složky) s názvem  „komponenty“.  *Příklad: jednoznacny\_nazev\_sip [dir]*  *|-komponenty [dir]*  *|-nazev\_souboru\_pdfA.pdf*  *|-mets.xml* |
| 9.2.11 | ESSL zajistí, že datový balíček SIP je komprimován do souboru v datovém formátu ZIP. ESSL zajistí, že soubor ZIP je pojmenován stejným způsobem jako adresář (složka) datového balíčku SIP.  *Příklad: jednoznacny\_nazev\_sip.zip*  *|- jednoznacny\_nazev\_sip [dir]*  *|-komponenty [dir]*  *|-nazev\_souboru\_pdfA.pdf*  *|-mets.xml* |
| 9.2.12 | ESSL zajistí, že název datového balíčku SIP je v rámci eSSL jedinečný, přičemž obsahuje pouze písmena latinské abecedy bez diakritiky, čísla a znaky „\_“ (podtržítko) a „–“ (pomlčka) a jeho délka nepřekročí 64 znaků. |
| 9.2.13 | ESSL zajistí, že v případě použití datového balíčku SIP pro předávání dokumentů a jejich metadat do příslušného archivu se hodnoty metadat neliší od metadat použitých v datovém balíčku SIP pro provedení skartačního řízení, s výjimkou informací o ukládacích jednotkách, množství, komponentách a skartačním řízení.  Datový balíček SIP pro předávání dokumentů a jejich metadat do příslušného archivu musí vždy obsahovat alespoň komponenty, které byly do výběru navrženy a které byly vybrány za archiválie. Datový balíček SIP může obsahovat komponenty navíc, například jinou verzi komponenty, komponentu s novým pořadovým číslem apod. |

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
|  | *Datové formáty všech komponent předávaných k trvalému uložení do příslušného archivu se řídí Formátovými pravidly Národního archivu. Aktuální Formátová pravidla Národního archivu jsou dostupná na* [*https://portal.nacr.cz/cro/uvodni-*](https://portal.nacr.cz/cro/uvodni-)*stranka/formatova-pravidla-narodniho-archivu/* |

# *Přílohy*

|  |  |  |
| --- | --- | --- |
| **Číslo** | **Název** | **Poznámka** |
| 1 | Schéma XML pro výměnu dokumentů a jejich metadat (WS API) | Schéma je určeno pro výměnu dokumentů a jejich metadat mezi informačními systémy spravujícími dokumenty a eSSL, přičemž se použije také pro export, import a přenos dokumentů. V tom případě se využijí pouze datové prvky definované ve schématu. |
| 2 | Schéma XML pro vytvoření datového balíčku SIP a pro zaznamenání popisných metadat uvnitř datového balíčku SIP | Příloha vznikla sloučením původních příloh č. 2 a 3. V příloze je odkazováno na standard METS. |
| 3 | příloha zrušena | příloha zrušena |
| 4 | Schéma XML pro zasílání údajů o rozhodnutí ve skartačním řízení a potvrzení přejímky s identifikátory digitálního archivu původci | Schéma je určeno pro zasílání seznamu entit vybraných za archiválie nebo entit určených ke zničení. Poskytuje tak informace pro doplnění metadat příslušných entit v eSSL. Druhou funkcí schématu je zaslání identifikátoru digitálního archivu po provedení přenosu nebo exportu k zaznamenání do eSSL. |
| 5 | Schéma XML pro export a import spisového a skartačního plánu | Schéma je určeno pro export spisového plánu, metadat věcných skupin a jejich skartačních režimů. |
| 6 | Schéma XML pro ztvárnění transakčního protokolu | Schéma je určeno pro ztvárnění obsahu transakčního protokolu nebo příslušné části transakčního protokolu. |
| 7 | Schéma XML pro migraci dat mezi elektronickými systémy spisové služby | Schéma je určeno pro migraci dat mezi elektronickými systémy spisové služby, migraci dat při spisové rozluce nebo migraci dat ze starého do nového systému (exit plán). Příloha naplňuje požadavky 2.1.4, 2.7.3, 6.3.1,  6.3.4, 6.3.5 a 6.3.6. |
| 8 | Metadata entit | Popis metadat jednotlivých entit a metadat tvořících hlavičku metadat. |

## DOKUMENTACE ŽIVOTNÍHO CYKLU

# *Dokumentace informačního systému spravujícího dokumenty*

|  |  |
| --- | --- |
| **Číslo** | **Požadavek** |
| 10.1.1 | Dokumentace informačního systému spravujícího dokumenty vedená původcem obsahuje alespoň tyto údaje:   1. název a verze informačního systému spravujícího dokumenty jako obchodního produktu (pokud je informační systém spravující dokumenty tvořen více obchodními produkty, pak musí být uvedeny všechny názvy obchodních produktů a jejich verzí), 2. obchodní firma dodavatele informačního systému spravujícího dokumenty, 3. datum uvedení informačního systému spravujícího dokumenty do zkušebního provozu, 4. datum uvedení informačního systému spravujícího dokumenty do řádného provozu, 5. datum získání atestu eSSL a verze eSSL pro kterou atest platí, 6. početní nebo kapacitní omezení uváděná dodavatelem, alespoň tato:    * nejvyšší možný počet dokumentů, které je možné uložit a zpracovat v celém systému za stanovené časové období podle požadavku [2.7.2,](#_bookmark81)    * nejvyšší možný počet dokumentů, které je možné vložit do jednoho spisu vedeného v systému,    * nejvyšší možný počet spisů, který je možné založit a zpracovat v celém systému za stanovené časové období podle požadavků [2.7.2](#_bookmark81) a [3.3.9](#_bookmark122),    * maximálně možná datová velikost komponenty,    * nejvyšší možný počet uživatelů,    * nejvyšší možný počet uživatelských a správcovských rolí,    * nejvyšší možný počet věcných skupin a jejich úrovní hierarchie, které je možné založit a zpracovat v celém systému,    * nejvyšší možný počet skartačních režimů, které je možné založit a zpracovávat v celém systému. 7. informace, zda byla do informačního systému spravujícího dokumenty migrována data z předcházejícího systému, a charakteristika těchto dat (zejména v jakém časovém rozmezí byla v dřívějším systému pořizována), 8. informace, zda je informační systém spravující dokumenty pouze evidencí, nebo spravuje komponenty, 9. odkaz na jiný informační systém spravující dokumenty, pokud je informační systém spravující dokumenty s ním propojen, a informace, zda se tak děje prostřednictvím rozhraní podle kapitoly [8.1](#_bookmark189), 10. informace o významných změnách informačního systému spravujícího dokumenty (například informace o změnách datové struktury a migracích eSSL na jeho nové verze), 11. datum ukončení provozu informačního systému spravujícího dokumenty, |

|  |  |
| --- | --- |
|  | 1. technická charakteristika informačního systému spravujícího dokumenty, zejména použité technologie a databáze, 2. věcná charakteristika informačního systému spravujícího dokumenty, zejména určení části agendy původce, na niž se vztahuje (rozsah zpracovávaných dat), 3. přehled právních předpisů vztahujících se k obsahu informačního systému spravujícího dokumenty, pokud se nejedná o eSSL, 4. údaje o poskytování otevřených dat nebo přístupu externích subjektů do informačního systému spravujícího dokumenty, 5. přehled správcovských rolí a správců informačního systému spravujícího dokumenty a jejich zařazení v organizační struktuře původce, 6. přehled uživatelských rolí a jejich charakteristika. |
| 10.1.2 | Dokumentace informačního systému spravujícího dokumenty vedená původcem musí být uložena v takové podobě, která zajistí její dostupnost a čitelnost lidskými smysly i v případě havárie informačního systému spravujícího dokumenty.  *Požadavek neznamená, že předepsaná dokumentace musí být pouze v listinné podobě. Dokumentace může být i v elektronické podobě, ale musí být uložena mimo informační systém spravující dokumenty, kterého se týká.* |
| 10.1.3 | ESSL vede po celou dobu provozu detailní popis umožňující původci identifikovat   1. verzi atestované eSSL (případně všech jejích částí), 2. aktuálně provozovanou verzi eSSL nasazenou v produkčním prostředí, 3. popis a rozsah změn provozované eSSL oproti atestované verzi, 4. jaké patche byly aplikovány a 5. zda byla s novou verzí změněna funkčnost eSSL, s uvedením důvodů a důsledků těchto změn pro původce. |