# Abhaengigkeiten und Risiken fuer den Import von ZIT_INFO_COCKPIT

## Kurzfazit

- Das Repository ist fachlich stark an SAP RE-FX, Business Partner und SAP GUI Dynpro gebunden.
- Der Import ist technisch sinnvoll, aber ohne vorhandene Fremdobjekte sind Teilaktivierungen oder Laufzeitfehler wahrscheinlich.
- Neben Standardabhaengigkeiten gibt es mehrere kundeneigene Objekte, die nicht in diesem Repository enthalten sind.
- Die Oberflaechenlogik setzt klassischen SAP GUI Zugriff voraus und ist nicht als reine Hintergrundlogik ausgelegt.

## Verifizierte technische Hauptabhaengigkeiten

### RE-FX und Vertragsumfeld

Direkte Verwendungen aus dem RE-FX- und Vertragskontext sind im Repository sichtbar.

Verifiziert:

- Tabellen und Views wie `VICNCN`, `V_REEXKUNNRCN`, `VIBPOBJREL`, `VIBDOBJASS`, `VIBDRO`
- Funktionsbausteine `RECA_GUI_BUSOBJ_APPL`, `REBP_MAINTAIN_MAINTAIN`, `RECD_GUI_CONDITIONS_PBO`
- RE-FX-nahe BAPI-Typen wie `BAPI_RE_T_PARTNER_INT` und `BAPI_RE_CONTRACT_INT`

Beispiele im Repository:

- `src/zit_notdienst_cockpit.prog.abap`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpitf01.abap`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpittop.abap`

Bewertung:

- Ohne RE-FX-nahe Objekte ist das Repository fachlich nur eingeschraenkt nutzbar.
- Aktivierungs- und Funktionstests muessen in einem RE-FX-faehigen Zielsystem erfolgen.

### Business Partner und Address Services

Die Anwendung arbeitet direkt mit Business-Partner-, Adress- und Kommunikationsdaten.

Verifiziert:

- Tabellen `BUT000`, `BUT020`, `ADRC`
- Funktionsbausteine `BUPA_ADDRESS_GET_DETAIL`, `BAPI_BUPA_CENTRAL_GETDETAIL`, `BAPI_BUPA_ADDRESS_CHANGE`, `BUPA_CENTRAL_GET_DETAIL`
- Sperr- und Transaktionsbausteine `ENQUEUE_EXKNA1`, `DEQUEUE_EXKNA1`, `BAPI_TRANSACTION_COMMIT`, `BAPI_TRANSACTION_ROLLBACK`

Beispiele im Repository:

- `src/zit_notdienst_cockpit.prog.abap`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpitf01.abap`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpiti01.abap`

Bewertung:

- Der erste Importtest sollte in einem System mit gepflegten BP-Stammdaten erfolgen.
- Schreibende BP-Funktionen erhoehen das Risiko spaeterer Laufzeitprobleme, auch wenn die reine Aktivierung gelingt.

### SAP GUI, Dynpro und ALV

Die Oberflaeche basiert auf klassischer Dynpro- und Control-Framework-Technik.

Verifiziert:

- `CALL SCREEN` in mehreren Funktionsgruppen
- GUI-Klassen wie `CL_GUI_CUSTOM_CONTAINER`, `CL_GUI_DOCKING_CONTAINER`, `CL_GUI_ALV_GRID`, `CL_GUI_ALV_TREE_SIMPLE`, `CL_GUI_TEXTEDIT`
- Control-Framework-Aufrufe wie `CL_GUI_CFW=>FLUSH`

Beispiele im Repository:

- `src/zre_pm_cockpit.tran.xml`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpitf01.abap`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpito01.abap`
- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpittop.abap`

Bewertung:

- Der produktive Test muss in SAP GUI erfolgen, nicht nur ueber technische Aktivierung.
- GUI-Dynpros und Containersteuerung sind typische Fehlerquellen bei fehlenden Screens oder unvollstaendigen Includes.

### Lieferanten- und Mailversand

Der Mailversand greift auf Lieferanten- und Adressdaten sowie kundeneigene Serviceklassen zu.

Verifiziert:

- Tabelle `LFA1` und CDS/View-Zugriff auf `I_ADDRESS`
- kundeneigene Klassen `ZCL_ADMIN_SERVICES` und `ZCL_ISCN_WF_NOTICE`
- weitere kundeneigene Typen `Z_T_ZUSERKZ`, `ZUSERKZ`, `Z_T_ZVCNBPADRESS`, `ZST_VTMDT_PARTNER`

Beispiel im Repository:

- `src/zcl_infocockpit_services.clas.abap`

Bewertung:

- Die Klasse `ZCL_INFOCOCKPIT_SERVICES` ist ohne die genannten Fremdobjekte nicht voll aktivierbar.
- Der Import kann technisch teilweise durchlaufen, die Mailfunktion bleibt dann aber unvollstaendig.

## Verifizierte kundeneigene Fremdabhaengigkeiten ausserhalb dieses Repositories

Die folgenden Referenzen wurden im Code gefunden, aber als exportierte Objekte nicht im Repository nachgewiesen.

### Fremde Funktionsbausteine und Klassen

Verifiziert:

- `CALL FUNCTION 'Z_PM_HANDWERKERAUSWAHL'`
- `ZCL_ADMIN_SERVICES`
- `ZCL_ISCN_WF_NOTICE`

Fundstellen:

- `src/zre_pm_cockpit.fugr.lzre_pm_cockpitpai.abap`
- `src/zcl_infocockpit_services.clas.abap`

Bewertung:

- Diese Abhaengigkeiten koennen Aktivierungsfehler erzeugen, wenn sie im Zielsystem fehlen.
- Vor dem ersten Fachtest sollte geklaert werden, aus welchem Fremdpaket diese Objekte stammen.

### Fremde Tabellen, Strukturen und Typen

Verifiziert:

- Tabelle oder Struktur `ZPMHW`
- Struktur `ZPD_ZTHEIZ_ANGSL`
- Typen wie `ZTC_PORTFOLIOT`, `ZST_HEIZUNG_SELX`, `ZRE_OBJEKT_ME`, `Z_T_WARTBEST_UEB`

Fundstellen:

- `src/zre_pm_cockpit.fugr.lzre_pm_cockpittop.abap`
- `src/zre_pm_cockpit.fugr.lzre_pm_cockpitf01.abap`

Bewertung:

- Das Repository enthaelt zwar eigene DDIC-Objekte, aber nicht alle verwendeten Z-Objekte.
- Fehlen diese Strukturen oder Tabellen im Zielsystem, scheitern Aktivierung oder spaetere Dynpro-Verarbeitung.

### Fremder Namespace

Verifiziert:

- `CALL FUNCTION '/PROMOS/OPPC_SHOW_TEILPROZESS'`

Fundstellen:

- `src/zrecn_bp_cockpit.fugr.lzrecn_bp_cockpitf01.abap`

Bewertung:

- Hier besteht eine direkte Abhaengigkeit zu einer fremden Namespace-Loesung.
- Falls das Zielsystem dieses Add-on nicht kennt, bleibt mindestens ein Teil der Prozessanzeige unbrauchbar.

## Wichtige Einstiegspunkte fuer den ersten Test

- Transaktion `ZRE_PM_COCKPIT` auf Programm `SAPLZRE_PM_COCKPIT`, Dynpro `1000`
- Report `ZIT_NOTDIENST_COCKPIT`
- Klasse `ZCL_INFOCOCKPIT_SERVICES` fuer Mail- und Kommunikationslogik
- Funktionsgruppe `ZRECN_BP_COCKPIT` fuer BP- und Vertragsdialoge

Technische Fundstellen:

- `src/zre_pm_cockpit.tran.xml`
- `src/zit_notdienst_cockpit.prog.abap`
- `src/zcl_infocockpit_services.clas.abap`
- `src/zrecn_bp_cockpit.fugr.xml`

## Empfohlene Reihenfolge fuer den ersten Importtest

1. DDIC-Objekte aktivieren, die im Repository enthalten sind.
2. Danach Funktionsgruppen, Includes, Klassen und Reports aktivieren.
3. Aktivierungsfehler gegen fehlende Fremdobjekte separat sammeln.
4. Erst dann die Oberflaechen ueber `ZRE_PM_COCKPIT` und `ZIT_NOTDIENST_COCKPIT` testen.
5. Mail- und Lieferantenlogik nur testen, wenn die zusaetzlichen Fremdklassen im Zielsystem vorhanden sind.

## Gesamtbewertung fuer den ersten Import

- Fuer einen technischen Erstimport ist das Repository geeignet.
- Fuer eine vollstaendige Aktivierung reicht dieses Repository allein voraussichtlich nicht aus.
- Die groessten Risiken liegen in kundeneigenen Fremdobjekten, RE-FX-Abhaengigkeiten und klassischer Dynpro-GUI.