**Schéma XML pro migraci dat mezi elektronickými systémy spisové služby**

## Tato příloha definuje formát dat a pravidla používaná při exportu nebo importu dat. Schéma je určeno pro migraci dat mezi elektronickými systémy spisové služby, migraci dat při spisové rozluce nebo migraci dat ze starého do nového systému (exit plán).

## Normativní části přílohy:

[*Kontejner s dávkou* *2*](#_bookmark0)

[*Přenos entit* *2*](#_bookmark1)

[*Potvrzení přenosu* *2*](#_bookmark2)

[*Schéma XML* *3*](#_bookmark3)

## Doplňující informace:

## Dokumentace schématu je zveřejněna na stránkách MV v sekci „O nás“, podsekce

## „Archivnictví a spisová služba“¨, oblast „Právní předpisy“, odkaz „Národní standard pro elektronické systémy spisové služby.

# Kontejner s dávkou

## Data se přenášejí jako kontejner ve formátu ZIP definovaném ve specifikaci APPNOTE a musí navíc splnit následující požadavky:

## soubory uložené v kontejneru musí být nekomprimované nebo musí používat kompresní metodu „deflate“ popsanou v RFC1951,

## kontejner nesmí používat šifrování,

## kontejner nesmí používat digitální podpisy,

## kontejner nesmí používat funkci „patch data“,

## kontejner nesmí být rozdělen do více souborů,

## jména souborů musí být uložena v kódování UTF-8 a musí být nastaven příznak

## „Language encoding flag“ (bit 11),k

* kontejner musí v kořenovém adresáři obsahovat soubor *manifest.xml*, který obsahuje kořenový element Davka validní vůči schématu *ermsExportPrenos.xsd*.

# Přenos entit

## Všechny entity a jejich metadata se přenášejí uvnitř kontejneru ZIP a je doporučeno je ukládat do vhodné adresářové struktury uvnitř kontejneru. Dávka v souboru *manifest.xml* obsahuje kromě nezbytných metadat také seznam všech entit, které se přenášejí/exportují. Pro každou entitu je zde odkaz na další dokument XML, který popisuje jednu entitu. Soubor s popisem entity musí použít kořenový element *Export* validní vůči schématu *ermsExportPrenos.xsd*.

# Potvrzení přenosu

## Pokud se při spisové rozluce data přenášejí z jednoho systému do druhého, první systém data smaže až poté, když obdrží potvrzení o úspěšném a kompletním přenosu. Potvrzení má podobu dokumentu XML, který má kořenový element *PrenosPotvrzeni* validní vůči schématu *ermsExportPrenos.xsd*.

# Schéma XML

[Extracted XSD snippet to `ermsExportPrenos.xsd`]
