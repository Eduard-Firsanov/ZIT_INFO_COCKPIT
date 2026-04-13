# abapGit Import-Checkliste fuer ZIT_INFO_COCKPIT

## Repository-Daten

- Repository-URL: `https://github.com/Eduard-Firsanov/ZIT_INFO_COCKPIT.git`
- Repository-Name in `.abapgit.xml`: `ZIT_INFO_COCKPIT`
- Starting Folder: `/src/`
- Master Language: `D`
- Paketbeschreibung: `Auswertungscockpit externen Dienstleister`

## Import in SAP

1. Transaktion `ZABAPGIT` oder `ABAPGIT` starten.
2. `New Online` waehlen.
3. URL `https://github.com/Eduard-Firsanov/ZIT_INFO_COCKPIT.git` eintragen.
4. Standard-Branch `main` verwenden.
5. Zielpaket `ZIT_INFO_COCKPIT` waehlen oder ein passendes Z-Paket zuordnen.
6. Pruefen, dass abapGit den Startordner `src` erkennt.
7. Repository anlegen und den Import mit `Pull` oder `Clone` ausfuehren.
8. Transport- und Originalsystem-Abfragen gemaess Systemvorgaben bestaetigen.

## Pruefungen waehrend des Imports

1. Tritt bereits beim Deserialisieren ein Fehler gegen unbekannte Z-Objekte auf, Import nicht blind fortsetzen.
2. Aktivierungsfehler gegen fehlende Fremdobjekte separat protokollieren.
3. RE-FX-, BP- und GUI-nahe Fehler priorisiert behandeln, weil sie weite Teile der Anwendung blockieren.

## Pruefungen nach dem Import

1. Aktivierungsprotokoll in abapGit pruefen.
2. DDIC-Objekte zuerst nachaktivieren.
3. Danach Funktionsgruppen, Klassen und Reports erneut aktivieren.
4. Fehler gegen nicht gelieferte Z-Objekte oder `/PROMOS/`-Objekte gesondert klaeren.
5. Anschliessend Transaktion und Report fachlich testen.

## Wichtige Einstiegspunkte

| Einstieg | Technischer Start | Zweck |
| --- | --- | --- |
| `ZRE_PM_COCKPIT` | `SAPLZRE_PM_COCKPIT`, Dynpro `1000` | Hauptcockpit |
| `ZIT_NOTDIENST_COCKPIT` | Report | Notdienst- und Vertragssuche |
| `ZCL_INFOCOCKPIT_SERVICES` | Klassenmethode | Mail- und Kommunikationslogik |

## Vorpruefung im Zielsystem

1. RE-FX-relevante Tabellen, Views und Funktionsbausteine sind vorhanden.
2. Business-Partner-Funktionen und Address Services sind verfuegbar.
3. Die SAP-GUI-Dynpro-Nutzung ist im Zielsystem zulaessig und testbar.
4. Fremdobjekte wie `Z_PM_HANDWERKERAUSWAHL`, `ZCL_ADMIN_SERVICES`, `ZCL_ISCN_WF_NOTICE`, `ZPMHW` und `ZPD_ZTHEIZ_ANGSL` existieren bereits oder werden separat geliefert.
5. Der fremde Namespace-Aufruf `/PROMOS/OPPC_SHOW_TEILPROZESS` ist im Zielsystem vorhanden oder fachlich entbehrlich.

## Empfohlene Importstrategie

1. Zuerst einen technischen Import in ein Sandbox- oder QS-System durchfuehren.
2. Aktivierungsfehler gegen Fremdobjekte als separate Lieferliste sammeln.
3. Erst nach erfolgreicher Grundaktivierung die GUI-Einstiege testen.
4. Mailversand und Lieferantenkommunikation nur in einem geeigneten Testsystem pruefen.