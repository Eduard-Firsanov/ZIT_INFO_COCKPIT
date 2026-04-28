# ZIT_INFO_COCKPIT

## Ueberblick

Dieses Repository enthaelt die ABAP-Entwicklung `Auswertungscockpit externen Dienstleister` im abapGit-Format.

## Technische Ablage

- `.abapgit.xml` verweist auf `/src/` als Startordner.
- `src/package.devc.xml` beschreibt das Hauptpaket `Auswertungscockpit externen Dienstleister`.
- `src/` enthaelt die exportierten ABAP-Objekte.
- `docs/` enthaelt technische Erstpruefung, Risikoanalyse und Importhinweise.

## Dokumentation

- `docs/import-review.md`
- `docs/abhaengigkeiten-risiken.md`
- `docs/abapgit-import-checkliste.md`

## Inhalt und Schwerpunkte

- Auswertungscockpit mit zentralen Einstiegspunkten ueber Transaktion `ZRE_PM_COCKPIT`, Report `ZIT_NOTDIENST_COCKPIT` und Hilfsklasse `ZCL_INFOCOCKPIT_SERVICES`
- exportierter Entwicklungsumfang vollstaendig unter `src/`
- technische Begleitdokumentation fuer Import und Abhaengigkeiten unter `docs/`

## Arbeitsweise

Das Repository kann direkt als abapGit-Quelle verwendet werden. Vor einem Import in ein SAP-Zielsystem sollten die Dokumente unter `docs/` fuer Erstpruefung, Risiken und Importablauf herangezogen werden.