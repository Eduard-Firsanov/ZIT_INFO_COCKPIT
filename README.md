# ZIT_INFO_COCKPIT

ABAP-Entwicklung im abapGit-Format fuer das Paket `ZIT_INFO_COCKPIT`.

## Inhalt

Der aktuelle Stand enthaelt den exportierten Entwicklungsumfang aus dem SAP-System im Verzeichnis `src/`.

## Struktur

- `src/`: exportierte abapGit-Objekte
- `docs/import-review.md`: technische Erstpruefung des Imports
- `docs/abhaengigkeiten-risiken.md`: verifizierte System- und Fremdabhaengigkeiten
- `docs/abapgit-import-checkliste.md`: empfohlene Schritte fuer den Import ins SAP-System

## Importvoraussetzungen

- Paketname: `ZIT_INFO_COCKPIT`
- Master Language: `D`
- Startverzeichnis: `/src/`
- Folder Logic: `FULL`

## Wichtige Einstiegspunkte

- Transaktion `ZRE_PM_COCKPIT` auf Dynpro `1000`
- Report `ZIT_NOTDIENST_COCKPIT`
- Hilfsklasse `ZCL_INFOCOCKPIT_SERVICES`

## Dokumentation

- Erstpruefung: `docs/import-review.md`
- Risiken und Abhaengigkeiten: `docs/abhaengigkeiten-risiken.md`
- Importablauf: `docs/abapgit-import-checkliste.md`