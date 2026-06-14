# Transakční protokol a audit map

| Oblast | Zdroj | Co zkontrolovat |
| --- | --- | --- |
| Přístup a role | Hlavní standard kap. 7 | Kdo může číst, měnit, ničit a administrovat |
| Změny dokumentů | Hlavní standard kap. 7 | Je dohledatelné kdo, kdy a proč změnil stav nebo metadata |
| Zničení a znepřístupnění | Hlavní standard kap. 7 | Zůstává auditní stopa a návaznost na vyřazování |
| Hlášení o stavu eSSL | Hlavní standard kap. 7 | Jak systém prokazuje svůj stav a provozní zdraví |
| Transakční protokol | Hlavní standard kap. 7 + část 6 | Jak se reprezentuje a přenáší auditní stopa |

## Praktická interpretace

- Auditní stopa není jen technický log pro debugging.
- Změny se mají dát přeložit do doménového příběhu dokumentu nebo entity.
- Když se mění export, migrace nebo opravy metadat, ověř i návazný audit.
