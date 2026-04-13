*&---------------------------------------------------------------------*
*& Report ZIT_NOTDIENST_COCKPIT
*&---------------------------------------------------------------------*
* PROGRAMMTYP:    Report Infosystem / Anlage Tickets
* FUNKTION:       Auswertungscockpit externe Notdienstleister          *
*----------------------------------------------------------------------*
* ANGEFORDET VON: Herr Keil(COVIVIO)                                   *
* REALISIERER:    Richard Daxlberger                                   *
* ERSTELLT AM:    27.02.2023                                           *
*----------------------------------------------------------------------*
* KURZBESCHREIBUNG:                                                    *
* Kundenübersicht (Cockpit) für die Vertragsübersicht
*----------------------------------------------------------------------*
* DATUM  BENUTZER MOD TEXT                                             *
*----------------------------------------------------------------------*
* 270223 DAXLBRI1      Erstversion                                     *
*----------------------------------------------------------------------*
REPORT zit_notdienst_cockpit.

TABLES: vicncn, vibdro, aufk, but000, adrc, but020.
DATA: lt_but000      TYPE TABLE OF but000,
      lt_but000_bak  TYPE TABLE OF but000,
      ls_but000      LIKE LINE OF lt_but000,
      lt_but020      TYPE TABLE OF but020,
      lt_but020_bak  TYPE TABLE OF but020,
      ls_but020      LIKE LINE OF lt_but020,
      lt_vicncn      TYPE TABLE OF vicncn,
      lt_vicncn_nd   TYPE TABLE OF vicncn,
      ls_vicncn      LIKE LINE OF lt_vicncn,
      lt_adrc        TYPE TABLE OF adrc,
      ls_adrc        LIKE LINE OF lt_adrc,
      lt_vibpobjrel  TYPE TABLE OF  vibpobjrel,
      ls_vibpobjrel  LIKE LINE OF lt_vibpobjrel,
      lt_reexkunnrcn TYPE TABLE OF v_reexkunnrcn,
      ls_reexkunnrcn LIKE LINE OF lt_reexkunnrcn.
DATA: ld_recnnr   TYPE recnnr,
      l_tabix     LIKE sy-tabix,
      l_sel       LIKE sy-tabix,
      ls_canceled.
DATA: lt_dynp TYPE TABLE OF dynpread,
      ls_dynp LIKE LINE OF lt_dynp.

FIELD-SYMBOLS: <vicncn> TYPE vicncn.
*=======================================================================
* selection-scrren
*=======================================================================
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.

  PARAMETERS:
    p_bukrs  TYPE vicncn-bukrs, " MEMORY ID buk,
    p_recnnr TYPE vicncn-recnnr. " MEMORY ID recnnr.
SELECTION-SCREEN END  OF BLOCK b1.
*PARAMETERS:
*p_ticket    TYPE crmt_object_id_db.
*, "
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-s02.
  SELECT-OPTIONS:
    s_namla FOR but000-name_last NO INTERVALS NO-EXTENSION,
    s_namfi FOR but000-name_first NO INTERVALS NO-EXTENSION,
    s_city    FOR adrc-city1 NO INTERVALS NO-EXTENSION,
    s_street FOR adrc-street NO INTERVALS NO-EXTENSION,
    s_housnr FOR adrc-house_num1 NO INTERVALS NO-EXTENSION,
    s_postlz FOR  adrc-post_code1 NO INTERVALS NO-EXTENSION.

SELECTION-SCREEN END  OF BLOCK b2.


**=======================================================================
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_ticket.
**=======================================================================
*  PERFORM pov_qmnum.

*=======================================================================
START-OF-SELECTION.
*=======================================================================
  DATA: lt_namla LIKE TABLE OF s_namla.
*------------------------------------*
  IF NOT p_recnnr IS INITIAL.
* Immobilienvertrag

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT SINGLE * FROM vicncn INTO ls_vicncn
*    WHERE bukrs = p_bukrs AND
*    recnnr = p_recnnr.

    SELECT * FROM vicncn INTO ls_vicncn UP TO 1 ROWS
     WHERE bukrs = p_bukrs AND recnnr = p_recnnr
     ORDER BY PRIMARY KEY .
    ENDSELECT.
* End of Quick Fix

    IF sy-subrc NE 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*      SELECT SINGLE * FROM vicncn INTO ls_vicncn
*       WHERE recnnr = p_recnnr.

      SELECT * FROM vicncn INTO ls_vicncn UP TO 1 ROWS
       WHERE recnnr = p_recnnr
       ORDER BY PRIMARY KEY .
      ENDSELECT.
* End of Quick Fix

      IF sy-subrc NE 0.
        MESSAGE s061(recaap) WITH 'Vertrag:' p_recnnr.
        RETURN.
      ENDIF.
    ENDIF.

  ELSE.
    IF NOT s_namla[] IS INITIAL OR  NOT s_namfi[] IS INITIAL.
* Partner
* Groß/Klein Schreibung
      lt_namla[] = s_namla[].
      LOOP AT lt_namla ASSIGNING FIELD-SYMBOL(<namla>).
        TRANSLATE <namla>-low     TO UPPER CASE.
      ENDLOOP.
* DB abfrage
      SELECT * FROM but000 INTO TABLE lt_but000
      WHERE
            name_last IN s_namla AND
            name_first IN s_namfi.
      IF sy-subrc NE 0.
* Suchhilfefeld 1 (Name 1/Nachname)
        SELECT * FROM but000 INTO TABLE lt_but000
        WHERE
              mc_name1 IN lt_namla.

      ENDIF.
      SELECT * FROM but000 APPENDING TABLE  lt_but000
      WHERE
            name_org1 IN s_namla AND
            name_org2 IN s_namfi.
      IF sy-subrc NE 0.
* Suchhilfefeld 1 (Name 1/Nachname)
        SELECT * FROM but000 APPENDING TABLE  lt_but000
        WHERE
             name_org1 IN lt_namla.
      ENDIF.

* Fehlermeldung
      IF lt_but000[] IS INITIAL.
        MESSAGE s209(r1).
        RETURN.
      ENDIF.
    ENDIF.

    IF s_namla IS INITIAL AND ( NOT s_city[] IS INITIAL  OR  NOT s_street[] IS INITIAL  OR
       NOT s_housnr[]  IS INITIAL OR NOT s_postlz[] IS INITIAL ).
      CLEAR l_sel.
      READ TABLE s_city INDEX 1.
      IF sy-subrc = 0.
        l_sel = l_sel + 1.
      ENDIF.
      READ TABLE s_street INDEX 1.
      IF sy-subrc = 0.
        l_sel = l_sel + 1.
      ENDIF.
      READ TABLE s_housnr INDEX 1.
      IF sy-subrc = 0.
        l_sel = l_sel + 1.
      ENDIF.
      READ TABLE s_postlz INDEX 1.
      IF sy-subrc = 0.
        l_sel = l_sel + 1.
      ENDIF.
      IF l_sel LT 2.
        MESSAGE i000(r1) WITH 'Bitte mindestens zwei Adresskriterien angeben'.
        RETURN.
      ENDIF.
      IF  NOT lt_but000[] IS INITIAL.
* mit Name
* GP: Adressen
        SELECT * FROM but020 INTO TABLE lt_but020
            FOR ALL ENTRIES IN lt_but000
          WHERE
                partner = lt_but000-partner.
        IF sy-subrc = 0.
          SELECT * FROM adrc INTO TABLE lt_adrc
           FOR ALL ENTRIES IN lt_but020
          WHERE
          addrnumber = lt_but020-addrnumber.
          DELETE lt_adrc WHERE  NOT city1 IN s_city.
          DELETE lt_adrc WHERE  NOT post_code1 IN s_postlz.
          DELETE lt_adrc WHERE  NOT street IN s_street.
          DELETE lt_adrc WHERE  NOT house_num1 IN s_housnr.

          REFRESH lt_but020_bak.
          LOOP AT lt_adrc INTO ls_adrc.
            READ TABLE lt_but020 INTO ls_but020 WITH KEY addrnumber = ls_adrc-addrnumber.
            IF sy-subrc = 0.
              APPEND ls_but020 TO lt_but020_bak.
            ENDIF.
          ENDLOOP.
          REFRESH lt_but000_bak.
          LOOP AT lt_adrc INTO ls_adrc.
            READ TABLE lt_but020 INTO ls_but020 WITH KEY addrnumber = ls_adrc-addrnumber.
            IF sy-subrc = 0.
              READ TABLE lt_but000 INTO ls_but000 WITH KEY partner = ls_but020-partner.
              IF sy-subrc = 0.
                APPEND ls_but000 TO lt_but000_bak.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
        lt_but000[] = lt_but000_bak[].
        lt_but020[] = lt_but020_bak[].
      ELSE.
* ohne Name
*Adressen (Business Address Services)
        SELECT * FROM adrc INTO TABLE lt_adrc
        WHERE
             city1 IN s_city AND
             post_code1 IN s_postlz AND
             street IN s_street AND
             house_num1 IN s_housnr.
        IF sy-subrc NE 0.
          RETURN.
        ENDIF.
* GP: Adressen
        SELECT * FROM but020 INTO TABLE lt_but020
             FOR ALL ENTRIES IN lt_adrc
                WHERE
              addrnumber = lt_adrc-addrnumber.

        IF lt_but000[] IS INITIAL.
*GP: Allgemeine Daten I
          SELECT * FROM but000 INTO TABLE lt_but000
            FOR ALL ENTRIES IN lt_but020
          WHERE
                partner = lt_but020-partner.

        ELSE.
          LOOP AT lt_but000 INTO ls_but000.
            l_tabix = sy-tabix.
            READ TABLE lt_but020 WITH KEY partner = ls_but000-partner TRANSPORTING NO FIELDS.
            IF sy-subrc NE 0.
              DELETE lt_but000 INDEX l_tabix.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

* Partern Vertrag
    IF lt_but000[] IS INITIAL.
      MESSAGE i209(r1).
      RETURN.
    ENDIF.
* ggf. noch Adresse holen
    IF lt_but020[] IS INITIAL.
* GP: Adressen
      SELECT * FROM but020 INTO TABLE lt_but020
           FOR ALL ENTRIES IN lt_but000
              WHERE
            partner  = lt_but000-partner.
      IF sy-subrc = 0.
        SELECT * FROM adrc INTO TABLE lt_adrc
      FOR ALL ENTRIES IN lt_but020
        WHERE
          addrnumber = lt_but020-addrnumber.
      ENDIF.
    ENDIF.

* View für Suchhilfe: Debitor nach Vertragsnummer
    SELECT * FROM v_reexkunnrcn INTO TABLE lt_reexkunnrcn
       FOR ALL ENTRIES IN lt_but000
       WHERE partner = lt_but000-partner.
    IF sy-subrc = 0.
      SELECT * FROM vicncn INTO TABLE lt_vicncn
      FOR ALL ENTRIES IN  lt_reexkunnrcn
      WHERE intreno =  lt_reexkunnrcn-intreno.
    ENDIF.
    SORT lt_reexkunnrcn BY intreno.
    SORT lt_but000 BY partner.
* Vertragsbezeichnung mit Mietername überschreiben
    LOOP AT lt_vicncn  ASSIGNING <vicncn>.
      READ TABLE lt_reexkunnrcn INTO ls_reexkunnrcn WITH KEY intreno = <vicncn>-intreno BINARY SEARCH..
      IF sy-subrc = 0.
        READ TABLE lt_but000 INTO ls_but000 WITH KEY partner = ls_reexkunnrcn-partner BINARY SEARCH..
        IF sy-subrc = 0.
          <vicncn>-industry = 'TR0600'.
          <vicncn>-responsible = ls_but000-partner.
          IF NOT ls_but000-name_org1 IS INITIAL.
            CONCATENATE ls_but000-name_org1 ',' space  ls_but000-name_org2 INTO <vicncn>-recntxt.
          ELSE.
            CONCATENATE ls_but000-name_last ',' space  ls_but000-name_first INTO <vicncn>-recntxt.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
* Geschäftspartner-Objektbeziehung
    SELECT * FROM vibpobjrel INTO TABLE lt_vibpobjrel
      FOR ALL ENTRIES IN lt_but000
       WHERE partner = lt_but000-partner AND
             role = 'TR0601'.
    IF sy-subrc = 0.
* Immobilienvertrag
      SELECT * FROM vicncn INTO TABLE lt_vicncn_nd
      FOR ALL ENTRIES IN lt_vibpobjrel
      WHERE intreno = lt_vibpobjrel-intreno.
      IF sy-subrc = 0.
        LOOP AT lt_vicncn_nd ASSIGNING <vicncn>.
          READ TABLE lt_vibpobjrel INTO ls_vibpobjrel WITH KEY intreno = <vicncn>-intreno.
          IF sy-subrc = 0.
            <vicncn>-responsible = ls_vibpobjrel-partner.
            <vicncn>-industry = 'TR0601'.
            READ TABLE lt_but000 INTO ls_but000 WITH KEY partner =  ls_vibpobjrel-partner BINARY SEARCH..
            IF sy-subrc = 0.
              IF NOT ls_but000-name_org1 IS INITIAL.
                CONCATENATE ls_but000-name_org1 ',' space  ls_but000-name_org2 INTO <vicncn>-recntxt.
              ELSE.
                CONCATENATE ls_but000-name_last ',' space  ls_but000-name_first INTO <vicncn>-recntxt.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
        APPEND LINES OF  lt_vicncn_nd TO  lt_vicncn.
      ENDIF.
    ENDIF.
    IF NOT lt_vicncn[] IS INITIAL.
*      SORT lt_vicncn BY bukrs recnnr.
*      DELETE ADJACENT DUPLICATES FROM lt_vicncn COMPARING bukrs recnnr.
* Aufruf Auswahl der Verträge
      PERFORM popup_ask_for_mv2 TABLES
          lt_vicncn
        CHANGING
          ls_vicncn
          ls_canceled.
      IF ls_canceled = abap_false.
        p_bukrs = ls_vicncn-bukrs.
        p_recnnr = ls_vicncn-recnnr.
*
        IF 1 = 2.
* Ausgewähle Daten übergeben
          CLEAR ls_dynp.
          ls_dynp-fieldname = 'P_BUKRS'.
          ls_dynp-fieldvalue = ls_vicncn-bukrs.
          APPEND ls_dynp TO lt_dynp.
          ls_dynp-fieldname = 'P_RECNNR'.
          ls_dynp-fieldvalue = ls_vicncn-recnnr.
          APPEND ls_dynp TO lt_dynp.

          CALL FUNCTION 'DYNP_VALUES_UPDATE'
            EXPORTING
              dyname               = sy-cprog
              dynumb               = sy-dynnr
            TABLES
              dynpfields           = lt_dynp
            EXCEPTIONS
              invalid_abapworkarea = 1
              invalid_dynprofield  = 2
              invalid_dynproname   = 3
              invalid_dynpronummer = 4
              invalid_request      = 5
              no_fielddescription  = 6
              undefind_error       = 7
              OTHERS               = 8.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  IF NOT ls_vicncn-intreno IS INITIAL.
    SET PARAMETER ID 'RECNNR' FIELD  ls_vicncn-recnnr.
    SET PARAMETER ID 'BUK' FIELD  ls_vicncn-bukrs.
* Aufruf der Kundenübersicht
    CALL FUNCTION 'Z_RECN_BP_COCKPIT_GUI'
      EXPORTING
        im_intreno = ls_vicncn-intreno.
  ELSE.
    MESSAGE i209(r1).
  ENDIF.
*&---------------------------------------------------------------------*
*& Form POPUP_ASK_FOR_MV2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_VICNCN
*&      <-- LD_RECNNR
*&      <-- CANCELED
*&---------------------------------------------------------------------*
FORM popup_ask_for_mv2  TABLES   p_lt_vicncn STRUCTURE vicncn
                        CHANGING p_ls_vicncn  STRUCTURE vicncn
                                 p_canceled TYPE c..

  DATA: lt_help   TYPE TABLE OF dfies,
        ls_help   LIKE LINE OF lt_help,
        lt_tiv2f  TYPE TABLE OF tiv2f,
        ls_tiv2f  LIKE LINE OF lt_tiv2f,
        lt_ret    TYPE TABLE OF  ddshretval,
        ls_ret    LIKE LINE OF lt_ret,
        ls_vicncn TYPE vicncn,
        ld_recnnr TYPE recnnr,
        ld_tabix  LIKE sy-tabix.

  DATA: lt_vibdobjass TYPE TABLE OF vibdobjass,
        ls_vibdobjass TYPE vibdobjass,
        lt_vibdro     TYPE TABLE OF vibdro,
        ls_vibdro     TYPE vibdro.

  DATA: BEGIN OF ls_val,
          line TYPE char80,
        END OF ls_val,
        lt_val LIKE TABLE OF ls_val.

*---------------------------------------------*
  CLEAR p_canceled.
  CLEAR p_ls_vicncn.

  SELECT * FROM tiv2f  INTO TABLE lt_tiv2f.
* H-Lage besorgen
  SELECT * FROM vibdobjass INTO TABLE lt_vibdobjass
  FOR ALL ENTRIES IN p_lt_vicncn
  WHERE objnrsrc = p_lt_vicncn-objnr.
  IF sy-subrc = 0.
* Nur Mieteinheiten
    DELETE lt_vibdobjass WHERE  objnrtrg(2) NE 'IM'.
    SORT lt_vibdobjass BY objnrsrc.
    IF NOT lt_vibdobjass[] IS INITIAL.
      SELECT * FROM vibdro INTO TABLE lt_vibdro
      FOR ALL ENTRIES IN lt_vibdobjass
      WHERE objnr = lt_vibdobjass-objnrtrg.
      SORT lt_vibdro BY objnr.
    ENDIF.
  ENDIF.

* Anzeige aufbauen
  REFRESH lt_help.
  CLEAR ls_help.
  ls_help-tabname = 'VICNCN'.
  ls_help-fieldname = 'BUKRS'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'VICNCN'.
  ls_help-fieldname = 'RECNNR'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'TIV2F'.
  ls_help-fieldname = 'XKBEZ'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'VICNCN'.
  ls_help-fieldname = 'RECNBEG'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'VICNCN'.
  ls_help-fieldname = 'RECNENDABS'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'VICNCN'.
  ls_help-fieldname = 'RECNTXT'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'BUT000'.
  ls_help-fieldname = 'PARTNER'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'VIBPOBJREL'.
  ls_help-fieldname = 'ROLE'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'ADRC'.
  ls_help-fieldname = 'CITY1'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'ADRC'.
  ls_help-fieldname = 'POST_CODE1'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'ADRC'.
  ls_help-fieldname = 'STREET'.
  APPEND ls_help TO lt_help.
  ls_help-tabname = 'ADRC'.
  ls_help-fieldname = 'HOUSE_NUM1'.
  APPEND ls_help TO lt_help.
* sortieren
  SORT lt_reexkunnrcn BY intreno.
  SORT lt_vibpobjrel BY intreno.
  SORT lt_tiv2f BY spras smvart.
  SORT lt_but000 BY partner.
  SORT lt_but020 BY partner.
  SORT lt_adrc BY addrnumber.
* Loopen
  LOOP AT p_lt_vicncn INTO ls_vicncn.
* Vertrag
    WRITE ls_vicncn-bukrs TO ls_val-line. APPEND ls_val TO lt_val.
    WRITE ls_vicncn-recnnr  TO ls_val-line. APPEND ls_val TO lt_val.
* Texttabelle Vertragsart Immobilien (Tabelle TIV26)
    READ TABLE lt_tiv2f INTO ls_tiv2f WITH KEY spras = sy-langu
                                               smvart =  ls_vicncn-recntype BINARY SEARCH.
    IF sy-subrc = 0.
      WRITE ls_tiv2f-xkbez TO ls_val-line. APPEND ls_val TO lt_val.
    ELSE.
      CLEAR ls_val-line. APPEND ls_val TO lt_val.
    ENDIF.
* Vertragsbeginn
    WRITE ls_vicncn-recnbeg TO ls_val-line. APPEND ls_val TO lt_val.
*   IF  ls_vicncn-recntxt IS INITIAL.
*    READ TABLE lt_reexkunnrcn INTO ls_reexkunnrcn WITH KEY intreno =  ls_vicncn-intreno BINARY SEARCH..
*    IF sy-subrc = 0.
*      READ TABLE lt_but000 INTO ls_but000 WITH KEY partner = ls_reexkunnrcn-partner BINARY SEARCH..
*      IF sy-subrc = 0.
*        CONCATENATE ls_but000-name_last ',' space  ls_but000-name_first INTO ls_vicncn-recntxt.
*      ENDIF.
*    ENDIF.
*   ENDIF.
* Vertragsende
    IF ls_vicncn-recnendabs IS INITIAL OR ls_vicncn-recnendabs = '99991231'.
      CLEAR ls_vicncn-recnendabs.
    ENDIF.
    WRITE ls_vicncn-recnendabs TO ls_val-line.
    IF ls_val-line IS INITIAL.
*     ls_val-line = 'unbefr.'.
    ENDIF.
    APPEND ls_val TO lt_val.
* Name Mieter steht im Vertragstext
    WRITE ls_vicncn-recntxt TO ls_val-line. APPEND ls_val TO lt_val.
* Partner
    WRITE ls_vicncn-responsible TO ls_val-line. APPEND ls_val TO lt_val.
* GP_Rolle
    WRITE ls_vicncn-industry  TO ls_val-line. APPEND ls_val TO lt_val.
* Adresse
    READ TABLE lt_reexkunnrcn INTO ls_reexkunnrcn WITH KEY intreno =  ls_vicncn-intreno BINARY SEARCH..
    IF sy-subrc NE 0.
      READ TABLE  lt_vibpobjrel INTO  ls_vibpobjrel WITH KEY intreno =  ls_vicncn-intreno BINARY SEARCH..
      IF sy-subrc = 0.
        ls_reexkunnrcn-partner = ls_vibpobjrel-partner.
      ENDIF.
    ENDIF.
    IF sy-subrc = 0.
      READ TABLE lt_but020 INTO ls_but020 WITH KEY partner = ls_reexkunnrcn-partner BINARY SEARCH..
      IF sy-subrc = 0.
        READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_but020-addrnumber BINARY SEARCH..
        IF sy-subrc NE 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*          SELECT SINGLE * FROM adrc INTO ls_adrc WHERE addrnumber = ls_but020-addrnumber.

          SELECT * FROM adrc INTO ls_adrc UP TO 1 ROWS WHERE addrnumber = ls_but020-addrnumber
           ORDER BY PRIMARY KEY .
          ENDSELECT.

* End of Quick Fix

        ENDIF.
        IF sy-subrc = 0.
          WRITE ls_adrc-city1 TO ls_val-line. APPEND ls_val TO lt_val.
          WRITE ls_adrc-post_code1 TO ls_val-line. APPEND ls_val TO lt_val.
          WRITE ls_adrc-street TO ls_val-line. APPEND ls_val TO lt_val.
          WRITE ls_adrc-house_num1 TO ls_val-line. APPEND ls_val TO lt_val.
        ELSE.
          CLEAR ls_val-line.
          APPEND ls_val TO lt_val.
          APPEND ls_val TO lt_val.
          APPEND ls_val TO lt_val.
          APPEND ls_val TO lt_val.
        ENDIF.

      ELSE.
        CLEAR ls_val-line.
        APPEND ls_val TO lt_val.
        APPEND ls_val TO lt_val.
        APPEND ls_val TO lt_val.
        APPEND ls_val TO lt_val.
      ENDIF.
    ELSE.
      CLEAR ls_val-line.
      APPEND ls_val TO lt_val.
      APPEND ls_val TO lt_val.
      APPEND ls_val TO lt_val.
      APPEND ls_val TO lt_val.
    ENDIF.
* H-Lage
    READ TABLE lt_vibdobjass INTO ls_vibdobjass WITH KEY objnrsrc =  ls_vicncn-objnr  BINARY SEARCH.
    IF sy-subrc = 0.
      READ TABLE lt_vibdro INTO ls_vibdro WITH KEY objnr = ls_vibdobjass-objnrtrg  BINARY SEARCH.
      IF sy-subrc = 0.
*        WRITE ls_vibdro-zz_lage_ge TO ls_val-line. APPEND ls_val TO lt_val.
      ELSE.
        CLEAR ls_val-line.
        APPEND ls_val TO lt_val.
      ENDIF.
    ELSE.
      CLEAR ls_val-line.
      APPEND ls_val TO lt_val.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'RECNNR'
    TABLES
      value_tab       = lt_val
      field_tab       = lt_help
      return_tab      = lt_ret
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc = 0.
    READ TABLE lt_ret INTO ls_ret INDEX 1.
    IF sy-subrc = 0.
*     LOC_SMIVE = RET_TAB-FIELDVAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_ret-fieldval
        IMPORTING
          output = ld_recnnr.
      READ TABLE p_lt_vicncn INTO ls_vicncn
       WITH KEY
        recnnr = ld_recnnr.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_vicncn TO p_ls_vicncn.
      ENDIF.
    ELSE.
      p_canceled = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.
* F4 Hilfe der Meldung
FORM pov_qmnum.

  DATA: lf_syrepid TYPE sy-repid.
  DATA: lf_sydynnr TYPE sy-dynnr.
  DATA: lt_return_tab TYPE ddshretval OCCURS 0 WITH HEADER LINE.
  DATA: lt_row TYPE lvc_t_row,
        ls_row LIKE LINE OF lt_row.
  DATA: BEGIN OF gt_qmnum OCCURS 0,
          qmnum LIKE qmel-qmnum,
        END OF gt_qmnum.

  DATA: BEGIN OF gt_aufnr OCCURS 0,
          aufnr LIKE afih-aufnr,
        END OF gt_aufnr.
*------------------------*
  lf_syrepid = sy-repid.
  lf_sydynnr = sy-dynnr.

  REFRESH lt_return_tab.
  REFRESH gt_qmnum.
  REFRESH gt_aufnr.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = 'AFIH'
      fieldname         = 'QMNUM'
      searchhelp        = 'QMEG'
*     shlpparam         = 'QMESL '
      dynpprog          = lf_syrepid
      dynpnr            = lf_sydynnr
      dynprofield       = 'P_TICKET'
*     STEPL             = 0
*     VALUE             = ' '
      multiple_choice   = ' '
      display           = 'F'
*     SUPPRESS_RECORDLIST = ' '
*     CALLBACK_PROGRAM  = ' '
*     CALLBACK_FORM     = ' '
    TABLES
      return_tab        = lt_return_tab
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_return_tab.

*   WRITE lt_return_tab-fieldval TO p_ticket RIGHT-JUSTIFIED.
    EXIT.
  ENDLOOP.



ENDFORM.                 " pov_QMNUM
