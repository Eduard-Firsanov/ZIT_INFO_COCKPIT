*----------------------------------------------------------------------*
***INCLUDE LZRE_PD_TESTF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form ON_HOTSPOT_RECN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_RECN_INTRENO
*&      --> COLUMN
*&      --> ROW
*&---------------------------------------------------------------------*
FORM on_hotspot_recn  USING    p_gs_recn_intreno TYPE vvintreno
                               p_column "       TYPE salv_de_row
                               p_row."       TYPE salv_de_column.

  CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
    EXPORTING
*     ID_ACTIVITY                = '03'
*     ID_OBJTYPE =
      id_intreno = p_gs_recn_intreno
*     ID_OBJNR   =
*     IF_LEAVE_CURRENT           = ABAP_FALSE
*     IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*     IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*     IS_NAVIGATION_DATA         =
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_DOUBLE_CLICK_RECN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_RECN_INTRENO
*&      --> COLUMN
*&      --> ROW
*&---------------------------------------------------------------------*
FORM on_double_click_recn  USING    p_gs_recn_intreno TYPE vvintreno
                               p_column      "  TYPE salv_de_row
                               p_row."       TYPE salv_de_column.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_DOUBLE_Ticket_CN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_RECN_INTRENO
*&      --> COLUMN
*&      --> ROW
*&---------------------------------------------------------------------*
FORM on_double_ticket_cn  USING
                               p_column      "  TYPE salv_de_row
                               p_row."       TYPE salv_de_column.
* Dynpro aufrufen
  gd_row =  p_row."
  IF 1 = 2.
    CALL SCREEN 0220 STARTING AT 40 9 ENDING AT 150 35.
  ELSE.
    IF NOT gs_ticket_cn-id IS INITIAL.
      CALL FUNCTION '/PROMOS/OPPC_SHOW_TEILPROZESS'
        EXPORTING
          i_teilid              = gs_ticket_cn-id
*         I_SCHRNR              =
*         IF_OHNE_ANZEIGE       =
          i_activity            = 'C'
          id_with_ecl           = 'X'
*      TABLES
*         ET_HTML_TABLE         =
        EXCEPTIONS
          workflow_error        = 1
          system_failure        = 2
          communication_failure = 3
          OTHERS                = 4.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_DOUBLE_Ticket_RO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_RECN_INTRENO
*&      --> COLUMN
*&      --> ROW
*&---------------------------------------------------------------------*
FORM on_double_ticket_ro  USING
                               p_column      "  TYPE salv_de_row
                               p_row."       TYPE salv_de_column.
* Dynpro aufrufen
  gd_row =  p_row.
  IF 1 = 2.
    CALL SCREEN 0320 STARTING AT 40 9 ENDING AT 150 35.
  ELSE.
    IF NOT gs_ticket_ro-id IS INITIAL.
      CALL FUNCTION '/PROMOS/OPPC_SHOW_TEILPROZESS'
        EXPORTING
          i_teilid              = gs_ticket_ro-id
*         I_SCHRNR              =
*         IF_OHNE_ANZEIGE       =
          i_activity            = 'C'
          id_with_ecl           = 'X'
*      TABLES
*         ET_HTML_TABLE         =
        EXCEPTIONS
          workflow_error        = 1
          system_failure        = 2
          communication_failure = 3
          OTHERS                = 4.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_ALV_RECN
*&---------------------------------------------------------------------*
FORM set_alv  USING  ro_alv TYPE REF TO cl_salv_table.

  DATA:
    lo_funct      TYPE REF TO cl_salv_functions_list,
    lo_layout     TYPE REF TO cl_salv_layout,
    lo_events     TYPE REF TO cl_salv_events_table,
    lr_events     TYPE REF TO cl_salv_events_table,
    lv_layout_key TYPE salv_s_layout_key,
    lo_selections TYPE REF TO cl_salv_selections,
    lr_column     TYPE REF TO cl_salv_column_table,
    lr_columns    TYPE REF TO cl_salv_columns_table,
    lr_display    TYPE REF TO cl_salv_display_settings,
    lf_variant    TYPE slis_vari,
    ls_color      TYPE lvc_s_colo,
    ls_ddic       TYPE salv_s_ddic_reference.
*-------------------------------
* Markierspalte einblenden
  lo_selections = ro_alv->get_selections( ).  "
  lo_selections->set_selection_mode(
              if_salv_c_selection_mode=>cell ).  "Multiple row selection
* lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*-- layout stuff
  lo_layout = ro_alv->get_layout( ).
  lo_layout->set_default( abap_true ). "Voreinstellung Layout erlauben
  lv_layout_key-report = sy-cprog.
* Funktionen Toolbar
  lo_funct = ro_alv->get_functions( ).
  lo_funct->set_all( ).

* lv_layout_key-handle = 'MAIN'.
  CASE  ro_alv.
    WHEN go_alv_recn.
      lv_layout_key-handle = 'RECN'.
* Toolbar ausschließen
      TRY.
          lo_funct->set_function( name = '&DETAIL' boolean = abap_false ).
        CATCH cx_salv_wrong_call.                       "#EC NO_HANDLER
      ENDTRY.
      TRY.
          lo_funct->set_function( name = '&SUMC' boolean = abap_false ).
        CATCH cx_salv_wrong_call.                       "#EC NO_HANDLER
      ENDTRY.
      TRY.
          lo_funct->set_function( name = '&MAXIMUM' boolean = abap_false ).
        CATCH cx_salv_wrong_call.                       "#EC NO_HANDLER
      ENDTRY.
      TRY.
          lo_funct->set_function( name = '&FIND_MORE' boolean = abap_false ).
        CATCH cx_salv_wrong_call.                       "#EC NO_HANDLER
      ENDTRY.

    WHEN go_alv_partner.
      lv_layout_key-handle = 'PART'.
    WHEN go_alv_ticket_cn.
      lv_layout_key-handle = 'T_CN'.
    WHEN go_alv_ticket_ro.
      lv_layout_key-handle = 'T_RO'.
    WHEN go_alv_clerk.
      lv_layout_key-handle = 'CLER'.
    WHEN go_alv_cond.
      lv_layout_key-handle = 'COND'.
    WHEN go_alv_area.
      lv_layout_key-handle = 'AREA'.
*    WHEN go_alv_area2.
*      lv_layout_key-handle = 'AREA'.
  ENDCASE.
** Variante übergeben
*  lf_variant = '/Default'.
*  lo_layout->set_initial_layout( lf_variant ).
  lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
  lo_layout->set_key( lv_layout_key ).

*...set status(Fullscreen)
* Default-Werte für den Status
*    ro_alv->set_screen_status(
*    pfstatus      =  'MAIN'
*    report        =  sy-cprog ).


* Build alv
  lr_columns = ro_alv->get_columns( ).
  lr_columns->set_optimize( abap_true ).

* try Farben
  TRY.
      lr_columns->set_color_column( 'T_COLOR' ). "Spalte mit Farben kennzeichnen
    CATCH cx_salv_data_error.                           "#EC NO_HANDLER
  ENDTRY.

* Hotspot für Kostenstelle setzen
  TRY.
      lr_column ?= lr_columns->get_column( 'RECNNR' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'PARTNER' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'PARTNER_CLERK' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'TEILNR' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'TEILNR_CHILD' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
* Bezeichnung
  TRY.
      lr_column ?= lr_columns->get_column( 'EDATUM' ).
      lr_column->set_long_text( 'Erfasst am' ).
      lr_column->set_short_text( 'Erfasst' ).
      lr_column->set_medium_text( 'Erfasst am' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'RECNENDABS' ).
      lr_column->set_long_text( 'Vertragsende' ).
      lr_column->set_short_text( 'Ende' ).
      lr_column->set_medium_text( 'Vertragsende' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'TEILNR_MAIN' ).
      lr_column->set_long_text( 'Hauptprozess' ).
      lr_column->set_short_text( 'Haupt' ).
      lr_column->set_medium_text( 'Hauptprozess' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'TEILNR_CHILD' ).
      lr_column->set_long_text( 'Teilprozess' ).
      lr_column->set_short_text( 'Teil' ).
      lr_column->set_medium_text( 'Teilprozess' ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.
* Farben
* Spalten
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'PARTNER' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'PARTNER_CLERK' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'RECNNR' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'TEILNR_CHILD' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'TEILNR' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
* Konditionen
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'CONDTYPE' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'CONDVALIDFROM' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
* Flächen
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'VALIDFROM' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      ls_color-col = 1. "Blau
      ls_color-int = 1.
      ls_color-inv = 0.
      lr_column ?= lr_columns->get_column( 'MEAS' ).
      lr_column->set_color( ls_color ).
    CATCH cx_salv_not_found.
  ENDTRY.
* technischer Felder
  TRY.
      lr_column ?= lr_columns->get_column( 'INTRENO' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'OBJNR' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'OBJTYPE' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'OBJID' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'SUBROLE' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'ADDRTYPE' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'BRUTEIL' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'PANTEIL' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'BMITEIG' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
  TRY.
      lr_column ?= lr_columns->get_column( 'RFAKT' ).
      lr_column->set_technical( abap_true ). "technische Felder
    CATCH cx_salv_not_found.
  ENDTRY.
* F4 Hilfe
  ls_ddic-table = '/PROMOS/S_CRM_TICKET_WD'.
  ls_ddic-field = 'STATUS'.

  TRY.
      lr_column ?= lr_columns->get_column( 'STATUS' ).
      lr_column->set_ddic_reference( ls_ddic ).
      lr_column->set_f4( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.
  ENDTRY.
* events
  lo_events = ro_alv->get_event( ).
*  CREATE OBJECT lr_events._ticket_cn
  SET HANDLER lcl_events=>handle_hotspot_recn   FOR lo_events. "HOTSPOT
  SET HANDLER lcl_events=>handle_double_click_ticket_cn FOR lo_events ACTIVATION abap_true. "Double Click
  SET HANDLER lcl_events=>handle_double_click_ticket_ro FOR lo_events ACTIVATION abap_true. "Double Click
  SET HANDLER lcl_events=>handle_hotspot_ticket_cn   FOR lo_events. "HOTSPOT
  SET HANDLER lcl_events=>handle_hotspot_ticket_ro   FOR lo_events. "HOTSPOT
*  SET HANDLER lcl_events=>handle_hotspot_clerk   FOR lo_events. "HOTSPOT
*  SET HANDLER lcl_events=>handle_hotspot_partner FOR lo_events. "HOTSPOT
*    SET HANDLER _on_double_click FOR lo_events ACTIVATION abap_true. "Double Click
** Top of Page für den Batch Lauf setzen, da dort USER-COMMAND aufgerufen wird
*    SET HANDLER _on_top_of_page_batch  FOR lo_events ACTIVATION abap_true. "Top of page
**... §6.1 register to the event USER_COMMAND
*    SET HANDLER _on_added_function FOR lo_events ACTIVATION abap_true. "User command

* Ausgabe ALV
  CALL METHOD ro_alv->display.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_HOTSPOT_PARTNER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_PARTNER_PARTNER
*&      --> COLUMN
*&      --> ROW
*&---------------------------------------------------------------------*
FORM on_hotspot_partner  USING    p__partner_partner TYPE bu_partner
                                  VALUE(p_column)
                                  VALUE(p_row).

  CHECK NOT gs_partner-partner IS INITIAL.

  CALL FUNCTION 'REBP_MAINTAIN_MAINTAIN'
    EXPORTING
*     IO_BUSOBJ  =
*     ID_BUKRS   =
      id_partner = gs_partner-partner
*     ID_VALIDFROM              =
*     ID_VALIDTO =
      id_aktyp   = '03'
*     ID_APPL    =
*     ID_OBJTYPE =
*     ID_OBJTYPEDIFF            = ' '
      id_role    = gs_partner-role
*     ID_ROLECAT =
*     ID_RLGROUP =
*     ID_VALDT   = SY-DATUM
*     ID_TYPE    = ' '
*     ID_HANDLE_PRIM            =
*     IO_PARTNER_MNGR           =
*     IF_WITHOUT_SEARCH         = ABAP_FALSE
*     IF_WITHOUT_PRIM_BDT       = ABAP_FALSE
*     IF_SAVE_DIRECT            = ABAP_FALSE
* IMPORTING
*     ED_PARTNER =
*     ED_ROLE    =
*     ET_ROLES   =
*     ED_RLGROUP =
    EXCEPTIONS
      bdt_error  = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_HOTSPOT_PARTNER_CLERK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_PARTNER_PARTNER
*&      --> COLUMN
*&      --> ROW
*&---------------------------------------------------------------------*
FORM on_hotspot_partner_clerk  USING    p__partner_partner TYPE bu_partner
                                  VALUE(p_column)
                                  VALUE(p_row).

  CHECK NOT gs_clerk-partner_clerk IS INITIAL.

  CALL FUNCTION 'REBP_MAINTAIN_MAINTAIN'
    EXPORTING
*     IO_BUSOBJ  =
*     ID_BUKRS   =
      id_partner = gs_clerk-partner_clerk
*     ID_VALIDFROM              =
*     ID_VALIDTO =
*     ID_AKTYP   = '03'
*     ID_APPL    =
*     ID_OBJTYPE =
*     ID_OBJTYPEDIFF            = ' '
      id_role    = gs_clerk-role
*     ID_ROLECAT =
*     ID_RLGROUP =
*     ID_VALDT   = SY-DATUM
*     ID_TYPE    = ' '
*     ID_HANDLE_PRIM            =
*     IO_PARTNER_MNGR           =
*     IF_WITHOUT_SEARCH         = ABAP_FALSE
*     IF_WITHOUT_PRIM_BDT       = ABAP_FALSE
*     IF_SAVE_DIRECT            = ABAP_FALSE
* IMPORTING
*     ED_PARTNER =
*     ED_ROLE    =
*     ET_ROLES   =
*     ED_RLGROUP =
    EXCEPTIONS
      bdt_error  = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_BUPA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_UCOMM
*&---------------------------------------------------------------------*
FORM set_bupa  USING ps_daten TYPE tt_recn
                     pd_ucomm TYPE sy-ucomm.



* lokale Daten
  DATA ls_bupa_address      TYPE bapibus1006_address.
  DATA lt_return            TYPE bapirettab.
  DATA ls_return            LIKE LINE OF lt_return.

  DATA lt_bapiadtel         TYPE STANDARD TABLE OF bapiadtel.
  DATA lt_bapiadtel_ins   TYPE STANDARD TABLE OF bapiadtel.
  DATA lt_bapiadtel_change  TYPE STANDARD TABLE OF bapiadtel.
  DATA ls_bapiadtel         TYPE                   bapiadtel.
  DATA lt_bapiadtel_x       TYPE STANDARD TABLE OF bapiadtelx.
  DATA lt_bapiadsmtp        TYPE STANDARD TABLE OF bapiadsmtp.
  DATA lt_bapiadsmtp_ins    TYPE STANDARD TABLE OF bapiadsmtp.
  DATA lt_bapiadsmtp_change TYPE STANDARD TABLE OF bapiadsmtp.
  DATA ls_bapiadsmtp        TYPE                   bapiadsmtp.
  DATA lt_bapiadsmtp_x      TYPE STANDARD TABLE OF bapiadsmtx.

* DATA ls_conf          TYPE /promos/crm_conf.

*  DATA: lv_timestamp            TYPE timestamp.
  DATA: lv_timestamp(15)            TYPE c.
  DATA: lv_datum      TYPE systdatlo.

  FIELD-SYMBOLS: <ls_bapiadtel>  TYPE             bapiadtel.
  FIELD-SYMBOLS: <ls_bapiadsmtp> TYPE             bapiadsmtp.

  CLEAR: lt_bapiadtel,   lt_bapiadsmtp,
         lt_bapiadtel_x, lt_bapiadsmtp_x.

* Adresse zum Stichtag lesen
  CALL FUNCTION 'BUPA_ADDRESS_GET_DETAIL'
    EXPORTING
      iv_partner = ps_daten-partner
      iv_valdt   = sy-datum
    IMPORTING
      es_address = ls_bupa_address.
*    TABLES
*      et_adtel   = lt_bapiadtel
*      et_adsmtp  = lt_bapiadsmtp.

  CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
    EXPORTING
      businesspartner       = ps_daten-partner
      valid_date            = sy-datum
    TABLES
      telefondatanonaddress = lt_bapiadtel
      e_maildatanonaddress  = lt_bapiadsmtp
      return                = lt_return.

*   Kommunikation setzen
****************************************************************************
* Festnetztelefon
****************************************************************************
  LOOP AT lt_bapiadtel ASSIGNING <ls_bapiadtel> WHERE r_3_user   = ' ' "Telefon ist Festnetztelefon
                                                   OR r_3_user   = '1'. "Telefon ist Standard unter den Festnetztelefonen
*    "Telefon 1
    " nur wenn die Nummer geändert wurde speichern
    IF gs_bupa_bak-phone1 NE ps_daten-phone1.
      <ls_bapiadtel>-telephone = ps_daten-phone1.
      APPEND  <ls_bapiadtel> TO lt_bapiadtel_change.
    ENDIF.

  ENDLOOP.

  "Es gab noch keine Nummer! Dann einen neuen Satz einfügen
  "Telefon 1
  IF gs_bupa_bak-phone1 IS INITIAL AND ps_daten-phone1 IS NOT INITIAL.
    CLEAR: ls_bapiadtel.
    lv_datum = sy-datlo.
    CONCATENATE lv_datum '000000' INTO lv_timestamp.
    ls_bapiadtel-country    = ls_bupa_address-country.
    ls_bapiadtel-telephone  = ps_daten-phone1.
    ls_bapiadtel-r_3_user   = '1'.
    ls_bapiadtel-valid_from = lv_timestamp.
    APPEND ls_bapiadtel TO lt_bapiadtel_ins.
  ENDIF.

****************************************************************************
*Mobiltelefon
****************************************************************************
  LOOP AT lt_bapiadtel ASSIGNING <ls_bapiadtel> WHERE r_3_user   = '2' "Telefon ist Mobiltelefon, aber nicht Standard-Mobiltelefon
                                                  OR r_3_user   = '3'. "Telefon ist Standard-Mobiltelefon
    "Mobil Telefon 1
    " nur wenn die Nummer geändert wurde speichern
    IF gs_bupa_bak-mobile1 NE ps_daten-mobile1.
      <ls_bapiadtel>-telephone = ps_daten-mobile1.
      APPEND  <ls_bapiadtel> TO lt_bapiadtel_change.
    ENDIF.

  ENDLOOP.

  "Es gab noch keine Nummer! Dann einen neuen Satz einfügen
  "Mobil Telefon 1
  IF gs_bupa_bak-mobile1 IS INITIAL AND ps_daten-mobile1 IS NOT INITIAL.
    CLEAR: ls_bapiadtel.
    lv_datum = sy-datlo.
    CONCATENATE lv_datum '000000' INTO lv_timestamp.
    ls_bapiadtel-country    = ls_bupa_address-country.
    ls_bapiadtel-telephone  = ps_daten-mobile1.
    ls_bapiadtel-r_3_user   = '3'.
    ls_bapiadtel-valid_from = lv_timestamp.
    APPEND ls_bapiadtel TO lt_bapiadtel_ins.
  ENDIF.

****************************************************************************
*E-Mail Addresse
****************************************************************************
  LOOP AT lt_bapiadsmtp ASSIGNING <ls_bapiadsmtp>.
*    IF <ls_bapiadsmtp>-e_mail EQ gs_kom_old-e_mail.
    " nur wenn die Nummer geändert wurde speichern
    IF gs_bupa_bak-e_mail NE ps_daten-e_mail.
      " nur wenn die Nummer geändert wurde speichern
      <ls_bapiadsmtp>-e_mail     = ps_daten-e_mail.
      APPEND  <ls_bapiadsmtp> TO lt_bapiadsmtp_change.
    ENDIF.
*    ENDIF.
  ENDLOOP.

  "Es gab noch keine Mail! Dann einen neuen Satz einfügen
  "E-Mail
  IF gs_bupa_bak-e_mail IS INITIAL AND ps_daten-e_mail IS NOT INITIAL.
    CLEAR: ls_bapiadsmtp.
    lv_datum = sy-datlo.
    CONCATENATE lv_datum '000000' INTO lv_timestamp.
    ls_bapiadsmtp-e_mail     = ps_daten-e_mail.
*    ls_bapiadsmtp-consnumber = lv_consnr_smtp.
    ls_bapiadsmtp-home_flag  = 'X'.
    ls_bapiadsmtp-std_no     = 'X'.
    ls_bapiadsmtp-valid_from = lv_timestamp.
    APPEND ls_bapiadsmtp TO lt_bapiadsmtp_ins.
  ENDIF.

*  SELECT SINGLE *
*    FROM /promos/crm_conf
*    INTO ls_conf
*  WHERE active EQ 'X'.
*****************************************************************************
** X-Tabellen füllen UPDATE
*****************************************************************************
  IF ls_bupa_address IS NOT INITIAL.
    IF lt_bapiadtel_change[] IS INITIAL AND
      lt_bapiadsmtp_change[] IS INITIAL AND
       lt_bapiadsmtp_ins[] IS INITIAL AND
       lt_bapiadtel_ins[] IS INITIAL.
      RETURN.
    ENDIF.
    CLEAR: lt_bapiadtel_x, lt_bapiadsmtp_x.
* Update
    PERFORM x_tabellen_fuellen TABLES lt_bapiadtel_change
                                      lt_bapiadsmtp_change
                                      lt_bapiadtel_x
                                      lt_bapiadsmtp_x
                              USING 'U'.
* Insert
    PERFORM x_tabellen_fuellen TABLES lt_bapiadtel_ins
                                  lt_bapiadsmtp_ins
                                  lt_bapiadtel_x
                                  lt_bapiadsmtp_x
                          USING 'I'.
* Tabellen übergeben
    APPEND LINES OF lt_bapiadtel_ins TO lt_bapiadtel_change.
    APPEND LINES OF lt_bapiadsmtp_ins TO lt_bapiadsmtp_change.

    CLEAR: ls_bapiadtel, ls_bapiadsmtp.
*
*    IF ls_conf-bp_save_central EQ 'X'.
*      CALL FUNCTION 'BAPI_BUPA_CENTRAL_CHANGE'
*        EXPORTING
*          businesspartner        = ps_daten-partner
*        TABLES
*          telefondatanonaddress  = lt_bapiadtel_change
**         faxdatanonaddress      = lt_fax
*          e_maildatanonaddress   = lt_bapiadsmtp_change
**         communicationnotesnonaddress  = lt_remark
*          telefondatanonaddressx = lt_bapiadtel_x
**         faxdatanonaddressx     = lt_faxx
*          e_maildatanonaddressx  = lt_bapiadsmtp_x
**         communicationnotesnonaddressx = lt_remarkx
*          return                 = lt_return.
*    ELSE.
* Adressse updaten
    CALL FUNCTION 'BAPI_BUPA_ADDRESS_CHANGE'
      EXPORTING
        businesspartner        = ps_daten-partner
        addressdata            = ls_bupa_address
        duplicate_message_type = 'E'
        accept_error           = abap_true
      TABLES
        bapiadtel              = lt_bapiadtel_change
        bapiadsmtp             = lt_bapiadsmtp_change
        bapiadtel_x            = lt_bapiadtel_x
        bapiadsmt_x            = lt_bapiadsmtp_x
        return                 = lt_return.
*    ENDIF.
** Erfolgsmeldung oder Fehlermeldung
    LOOP AT lt_return INTO ls_return WHERE type EQ 'E'
                                     OR    type EQ 'A'.
    ENDLOOP.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      CALL FUNCTION 'DEQUEUE_EXKNA1'
        EXPORTING
          kunnr = ps_daten-partner.

      ps_daten-phone1  = gs_bupa_bak-phone1.
      ps_daten-mobile1 = gs_bupa_bak-mobile1.
      ps_daten-e_mail  = gs_bupa_bak-e_mail.
      CLEAR: gd_edit_tel, gd_edit_mobil, gd_edit_email.

      MESSAGE 'Komunikationsdaten wurden nicht gespeichert' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      CALL FUNCTION 'DEQUEUE_EXKNA1'
        EXPORTING
          kunnr = ps_daten-debitor.
      gs_bupa_bak-phone1  = ps_daten-phone1.
      gs_bupa_bak-mobile1 = ps_daten-mobile1.
      gs_bupa_bak-e_mail  = ps_daten-e_mail.
      CLEAR: gd_edit_tel, gd_edit_mobil, gd_edit_email.
      MESSAGE 'Komunikationsdaten wurden gespeichert' TYPE 'S'.
    ENDIF.

****************************************************************************
* X-Tabellen füllen INSERT
****************************************************************************
  ELSE.
    CLEAR: lt_bapiadtel_x, lt_bapiadsmtp_x.

    PERFORM x_tabellen_fuellen TABLES lt_bapiadtel_ins
                                      lt_bapiadsmtp_ins
                                      lt_bapiadtel_x
                                      lt_bapiadsmtp_x
                                USING 'I'.

*    IF ls_conf-bp_save_central EQ 'X'.
*      CALL FUNCTION 'BAPI_BUPA_CENTRAL_CHANGE'
*        EXPORTING
*          businesspartner        = ps_daten-partner
*        TABLES
*          telefondatanonaddress  = lt_bapiadtel_ins
**         faxdatanonaddress      = lt_fax
*          e_maildatanonaddress   = lt_bapiadsmtp_ins
**         communicationnotesnonaddress  = lt_remark
*          telefondatanonaddressx = lt_bapiadtel_x
**         faxdatanonaddressx     = lt_faxx
*          e_maildatanonaddressx  = lt_bapiadsmtp_x
**         communicationnotesnonaddressx = lt_remarkx
*          return                 = lt_return.
*    ELSE.
*   Kommunikation speichern
    CALL FUNCTION 'BAPI_BUPA_ADDRESS_CHANGE'
      EXPORTING
        businesspartner        = ps_daten-partner
        addressdata            = ls_bupa_address
        duplicate_message_type = 'E'
      TABLES
        bapiadtel              = lt_bapiadtel_ins
        bapiadsmtp             = lt_bapiadsmtp_ins
        bapiadtel_x            = lt_bapiadtel_x
        bapiadsmt_x            = lt_bapiadsmtp_x
        return                 = lt_return.
*   ENDIF.
* Erfolgsmeldung oder Fehlermeldung
    LOOP AT lt_return INTO ls_return WHERE type EQ 'E'
                                     OR    type EQ 'A'.
    ENDLOOP.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      CALL FUNCTION 'DEQUEUE_EXKNA1'
        EXPORTING
          kunnr = ps_daten-debitor.

      ps_daten-phone1  = gs_bupa_bak-phone1.
      ps_daten-mobile1 = gs_bupa_bak-mobile1.
      ps_daten-e_mail  = gs_bupa_bak-e_mail.
      CLEAR: gd_edit_tel, gd_edit_mobil, gd_edit_email.
      MESSAGE 'Komunikationsdaten wurden nicht gespeichert' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      CALL FUNCTION 'DEQUEUE_EXKNA1'
        EXPORTING
          kunnr = ps_daten-debitor.
      gs_bupa_bak-phone1  = ps_daten-phone1.
      gs_bupa_bak-mobile1 = ps_daten-mobile1.
      gs_bupa_bak-e_mail  = ps_daten-e_mail.
      CLEAR: gd_edit_tel, gd_edit_mobil, gd_edit_email.
      MESSAGE 'Komunikationsdaten wurden gespeichert' TYPE 'S'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form X_TABELLEN_FUELLEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_BAPIADTEL_DEL
*&      --> LT_BAPIADSMTP_DEL
*&      --> LT_BAPIADTEL_X
*&      --> LT_BAPIADSMTP_X
*&      --> P_

FORM x_tabellen_fuellen  TABLES   pt_bapiadtel STRUCTURE bapiadtel
                                  pt_bapiadsmtp STRUCTURE bapiadsmtp
                                  pt_bapiadtel_x STRUCTURE bapiadtelx
                                  pt_bapiadsmtp_x STRUCTURE bapiadsmtx
                         USING   pv_updateflag.

  DATA ls_bapiadtel        TYPE                   bapiadtel.
  DATA ls_bapiadtel_x      TYPE                   bapiadtelx.
  DATA ls_bapiadsmtp       TYPE                   bapiadsmtp.
  DATA ls_bapiadsmtp_x     TYPE                   bapiadsmtx.

*  Telefon
  LOOP AT pt_bapiadtel INTO ls_bapiadtel.
*    IF ls_bapiadtel-country IS NOT INITIAL.
*      ls_bapiadtel_x-country = 'X'.
*    ENDIF.
*
*    IF ls_bapiadtel-countryiso IS NOT INITIAL.
*      ls_bapiadtel_x-countryiso = 'X'.
*    ENDIF.
*
**    IF ls_bapiadtel-std_no IS NOT INITIAL.
*    ls_bapiadtel_x-std_no = 'X'.
**    ENDIF.

    IF ls_bapiadtel-telephone IS NOT INITIAL.
      ls_bapiadtel_x-telephone = 'X'.
    ENDIF.

    IF ls_bapiadtel-extension IS NOT INITIAL.
      ls_bapiadtel_x-extension = 'X'.
    ENDIF.

    IF ls_bapiadtel-tel_no IS NOT INITIAL.
      ls_bapiadtel_x-tel_no = 'X'.
    ENDIF.

    IF ls_bapiadtel-caller_no IS NOT INITIAL.
      ls_bapiadtel_x-caller_no = 'X'.
    ENDIF.
*
*    IF ls_bapiadtel-std_recip IS NOT INITIAL.
*      ls_bapiadtel_x-std_recip = 'X'.
*    ENDIF.
*
**    IF ls_bapiadtel-r_3_user IS NOT INITIAL.
*    ls_bapiadtel_x-r_3_user = 'X'.
**    ENDIF.
*
*    IF ls_bapiadtel-home_flag IS NOT INITIAL.
*      ls_bapiadtel_x-home_flag = 'X'.
*    ENDIF.
*
*    IF ls_bapiadtel-consnumber IS NOT INITIAL.
*      ls_bapiadtel_x-consnumber = 'X'.
**    ENDIF.
*
*
*    IF ls_bapiadtel-flg_nouse IS NOT INITIAL.
*      ls_bapiadtel_x-flg_nouse = 'X'.
*    ENDIF.
*
*    IF ls_bapiadtel-valid_from IS NOT INITIAL.
*      ls_bapiadtel_x-valid_from = 'X'.
*    ENDIF.
*
*    IF ls_bapiadtel-valid_to IS NOT INITIAL.
*      ls_bapiadtel_x-valid_to = 'X'.
*    ENDIF.

    ls_bapiadtel_x-updateflag = pv_updateflag. "Insert
*    ls_bapiadtel_x-updateflag = 'I'. "Insert

    APPEND ls_bapiadtel_x TO pt_bapiadtel_x.
    CLEAR: ls_bapiadtel, ls_bapiadtel_x.
  ENDLOOP.

*  Mail
  LOOP AT pt_bapiadsmtp INTO ls_bapiadsmtp.
*    IF ls_bapiadsmtp-std_no IS NOT INITIAL.
*      ls_bapiadsmtp_x-std_no = 'X'.
*    ENDIF.

    IF ls_bapiadsmtp-e_mail IS NOT INITIAL.
      ls_bapiadsmtp_x-e_mail = 'X'.
    ENDIF.

*    IF ls_bapiadsmtp-email_srch IS NOT INITIAL.
*      ls_bapiadsmtp_x-email_srch = 'X'.
*    ENDIF.

**    IF ls_bapiadsmtp-std_recip IS NOT INITIAL.
*    ls_bapiadsmtp_x-std_recip = 'X'.
**    ENDIF.
*
*    IF ls_bapiadsmtp-r_3_user IS NOT INITIAL.
*      ls_bapiadsmtp_x-r_3_user = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-encode IS NOT INITIAL.
*      ls_bapiadsmtp_x-encode = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-tnef IS NOT INITIAL.
*      ls_bapiadsmtp_x-tnef = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-home_flag IS NOT INITIAL.
*      ls_bapiadsmtp_x-home_flag = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-consnumber IS NOT INITIAL.
*      ls_bapiadsmtp_x-consnumber = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-flg_nouse IS NOT INITIAL.
*      ls_bapiadsmtp_x-flg_nouse = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-valid_from IS NOT INITIAL.
*      ls_bapiadsmtp_x-valid_from = 'X'.
*    ENDIF.
*
*    IF ls_bapiadsmtp-valid_to IS NOT INITIAL.
*      ls_bapiadsmtp_x-valid_to = 'X'.
*    ENDIF.

    ls_bapiadsmtp_x-updateflag = pv_updateflag. "Insert
*    ls_bapiadsmtp_x-updateflag = 'I'. "Insert
    APPEND ls_bapiadsmtp_x TO pt_bapiadsmtp_x.
    CLEAR: ls_bapiadsmtp, ls_bapiadsmtp_x.
  ENDLOOP.

ENDFORM.                    " X_TABELLEN_FUELLEN
*&---------------------------------------------------------------------*
*& Form SET_ENDDATUM_SMTP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_BAPIADSMTP
*&---------------------------------------------------------------------*
FORM set_enddatum_smtp  CHANGING cs_bapiadsmtp TYPE bapiadsmtp.

  DATA: lv_timestamp(15)            TYPE c.
  DATA: lv_datum      TYPE systdatlo.

  lv_datum = sy-datlo - 1.

  DO.
    CONCATENATE lv_datum '235959' INTO lv_timestamp.
    cs_bapiadsmtp-valid_to   = lv_timestamp.

    IF cs_bapiadsmtp-valid_to LT cs_bapiadsmtp-valid_from.
      lv_datum = lv_datum + 1.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.

ENDFORM.                    " SET_ENDDATUM_SMTP
*&---------------------------------------------------------------------*
*& Form SET_ENDDATUM_TEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_BAPIADTEL
*&---------------------------------------------------------------------*
FORM set_enddatum_tel  CHANGING cs_bapiadtel TYPE bapiadtel.

  DATA: lv_timestamp(15)            TYPE c.
  DATA: lv_datum      TYPE systdatlo.

  lv_datum = sy-datlo - 1.

  DO.
    CONCATENATE lv_datum '235959' INTO lv_timestamp.
    cs_bapiadtel-valid_to   = lv_timestamp.

    IF cs_bapiadtel-valid_to LT cs_bapiadtel-valid_from.
      lv_datum = lv_datum + 1.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.

ENDFORM.                    " SET_ENDDATUM_TEL
*&---------------------------------------------------------------------*
*& Form SET_BUPA_CENTRAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_RECN
*&      --> SY_UCOMM
*&---------------------------------------------------------------------*
FORM set_bupa_central  USING  ps_daten TYPE tt_recn
                              pd_ucomm TYPE sy-ucomm.

* lokale Daten
  DATA ls_data_person  TYPE  bapibus1006_central_person.
  DATA ls_data_person_x   TYPE  bapibus1006_central_person_x.
  DATA lt_return            TYPE bapirettab.
  DATA ls_return            LIKE LINE OF lt_return.

*  DATA: lv_timestamp            TYPE timestamp.
  DATA: lv_timestamp(15)            TYPE c.
  DATA: lv_datum      TYPE systdatlo.

  FIELD-SYMBOLS: <ls_data_person>  TYPE  bapibus1006_central_person.

  CLEAR: ls_data_person, ls_data_person_x.

* Adresse zum Stichtag lesen
  CALL FUNCTION 'BUPA_CENTRAL_GET_DETAIL'
    EXPORTING
      iv_partner     = ps_daten-partner
      iv_valid_date  = sy-datlo
    IMPORTING
      es_data_person = ls_data_person.

*   Kommunikation setzen
****************************************************************************
* Geburtstag
****************************************************************************

  IF gs_bupa_bak-birthdt NE ls_data_person-birthdate.
* Geburtstag übergeben
    ls_data_person-birthdate = ls_data_person-birthdate.
    ls_data_person_x-birthdate = 'U'.

    CALL FUNCTION 'BAPI_BUPA_CENTRAL_CHANGE'
      EXPORTING
        businesspartner     = ps_daten-partner
        centraldata         = ls_data_person
        centraldataperson_x = ls_data_person_x
      TABLES
        return              = lt_return.

* Erfolgsmeldung oder Fehlermeldung
    LOOP AT lt_return INTO ls_return WHERE type EQ 'E'
                                     OR    type EQ 'A'.
    ENDLOOP.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      ps_daten-birthdt = gs_bupa_bak-birthdt     .
      MESSAGE 'Geburtsdatum wurden nicht gespeichert' TYPE 'S' DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      gs_bupa_bak-birthdt  = ps_daten-birthdt.
      MESSAGE 'Geburtsdatum wurden gespeichert' TYPE 'S'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_AVAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_RECN
*&      --> SY_UCOMM
*&---------------------------------------------------------------------*
FORM save_avail  USING  ps_daten TYPE tt_recn
                        pd_ucomm TYPE sy-ucomm.
  DATA:
    ls_bus000_eew   TYPE bus000_eew,
    ls_bus000_eew_x TYPE bus000_eew_x,
    lt_return       TYPE bus_bapiret2_t,
    ls_return       TYPE bapiret2.

  IF ps_daten-avail_from >= ps_daten-avail_to.
    "Bis-Wert muss größer als Von-Wert sein!
    MESSAGE 'Bis-Wert muss größer als Von-Wert sein!' TYPE 'S' DISPLAY LIKE 'E'.

    RETURN.
  ELSE.
    IF ps_daten-avail_from < 7
    OR ps_daten-avail_to  > 20.
      "Anrufzeit darf nur im Zeitraum von 7:00 bis 20:00 liegen!
      MESSAGE 'Anrufzeit darf nur im Zeitraum von 7:00 bis 20:00 liegen!' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
  ENDIF.

*
*    ls_bus000_eew-partnr_guid   = gs_daten-partner_guid.
*    ls_bus000_eew_x-partnr_guid = gs_daten-partner_guid.
*
*    CALL FUNCTION 'BUPA_CENTRAL_CI_CHANGE'
*      EXPORTING
*        is_bus000_eew   = ls_bus000_eew
*        is_bus000_eew_x = ls_bus000_eew_x
*      IMPORTING
*        et_return       = lt_return[].
*
*    LOOP AT lt_return INTO ls_return WHERE type = 'E'
*                                     OR    type = 'A'.
*      EXIT.
*    ENDLOOP.
*    IF sy-subrc = 0.
*      MESSAGE 'Anrufzeiten wurden nicht gespeichert' TYPE 'S' DISPLAY LIKE 'E'.
*    ELSE.
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = abap_true.
*    ENDIF.
*
*    CALL FUNCTION 'DEQUEUE_EXKNA1'
*      EXPORTING
*        kunnr = gs_daten-partner.
*  ELSE.
*    CALL FUNCTION 'DEQUEUE_EXKNA1'
*      EXPORTING
*        kunnr = gs_daten-partner.
*  ENDIF.

  gd_edit_avail = abap_false.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_0400
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_0400 .
  DATA:
    lo_selections TYPE REF TO cl_salv_selections,
    ls_cell       TYPE salv_s_cell,
    lt_cell       TYPE salv_t_cell,
    lt_rows       TYPE salv_t_row,
    ld_row        TYPE i,
    lt_cols       TYPE salv_t_column,
    ls_cols       LIKE LINE OF lt_cols.
  DATA:
*    ls_tickets_bak_cn LIKE LINE OF gt_tickets_bak_cn,
    lt_notice     TYPE TABLE OF string,
    ls_langtext_t TYPE string.
*    ls_children_wd TYPE /promos/s_ct_data_wd,
*    ls_initiator   TYPE /promos/s_crm_cust_fields,
*    ls_codes       TYPE /promos/s_codes_wd.

  FIELD-SYMBOLS: <ticket_cn> LIKE gs_ticket_cn.
*------------------------

* Metadaten aus dem Customer-Control holen
  CALL METHOD go_alv_ticket_cn->get_metadata."Bei Container rufen

* Markierspalte holen
  lo_selections = go_alv_ticket_cn->get_selections( ).  "

  lt_rows = lo_selections->get_selected_rows( ).
  IF lines( lt_rows ) = 0.
    MESSAGE i033(recabc).
    LEAVE TO SCREEN 0.
    RETURN.
  ENDIF.
*Langtext der Notiz initialisieren
  REFRESH: lt_notice.
  LOOP AT lt_rows INTO ld_row.
    READ TABLE gt_ticket_cn ASSIGNING <ticket_cn>  INDEX ld_row.
* Zeile gefunden?
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <ticket_cn> TO gs_dynpro_cn_02.
* orginal-ticket lesen
*      READ TABLE gt_tickets_bak_cn INTO ls_tickets_bak_cn
*       WITH KEY  id_txt = <ticket_cn>-teilnr_main.
*      IF sy-subrc = 0.
*        lt_notice[] = ls_tickets_bak_cn-langtext_t[].
** orginal-ticket lesen
*        LOOP AT ls_tickets_bak_cn-t_children INTO ls_children_wd.
*          MOVE-CORRESPONDING ls_children_wd TO gs_dynpro_cn_02.
*          gs_dynpro_cn_02-kurztext = ls_children_wd-bezeichnung.
*          lt_notice[] =  ls_children_wd-langtext_t[].
*          CONCATENATE ls_children_wd-codegruppe ls_children_wd-code INTO
*                  gs_dynpro_cn_02-code.
*          READ TABLE gt_codes INTO ls_codes WITH KEY
*          codegruppe = ls_children_wd-codegruppe
*          code = ls_children_wd-code.
*          IF sy-subrc = 0.
*            CONCATENATE ls_codes-kurztext_grp  ls_codes-kurztext INTO
*                        gs_dynpro_cn_02-code_text SEPARATED BY '-'.
*          ENDIF.
*          LOOP AT ls_children_wd-cust_fields INTO ls_initiator
*          WHERE fieldtext = 'Initiatoren'.
*            gs_dynpro_cn_02-initiator  = ls_initiator-value.
*          ENDLOOP.
*        ENDLOOP.
*
*        IF sy-subrc NE 0.
*
*          gs_dynpro_cn_02-urspr  = ls_tickets_bak_cn-urspr .
*          gs_dynpro_cn_02-status =  ls_tickets_bak_cn-status.
*          gs_dynpro_cn_02-kurztext   =  ls_tickets_bak_cn-bezeichnung.
*          gs_dynpro_cn_02-prio  = ls_tickets_bak_cn-prio.
*          gs_dynpro_cn_02-strmn   = ls_tickets_bak_cn-bezeichnung.
*          gs_dynpro_cn_02-ltrmn    = ls_tickets_bak_cn-bezeichnung.
*          CONCATENATE ls_tickets_bak_cn-codegruppe ls_tickets_bak_cn-code INTO
*          gs_dynpro_cn_02-code.
*          LOOP AT ls_tickets_bak_cn-langtext_t INTO ls_langtext_t.
*            APPEND ls_langtext_t TO lt_notice.
*          ENDLOOP.
*        ENDIF.
*        IF gs_dynpro_cn_02-initiator IS INITIAL.
*          LOOP AT ls_tickets_bak_cn-cust_fields INTO ls_initiator
*          WHERE fieldtext = 'Initiatoren'.
*            gs_dynpro_cn_02-initiator  = ls_initiator-value.
*          ENDLOOP.
*        ENDIF.
** allgemeine Felder übergeben
*        gs_dynpro_cn_02-recnnr  = gs_recn-recnnr.
*        READ TABLE gt_status INTO gs_status WITH KEY  low = gs_dynpro_cn_02-status.
*        IF sy-subrc = 0.
*          gs_dynpro_cn_02-status_text = gs_status-ddtext.
*        ENDIF.
*      ENDIF.

*      gs_dynpro_cn_02-initiator  = ls_tickets_cn-initiator.
*      gs_dynpro_cn_02-recnnr  = <ticket_cn>-bezeichnung.
*      gs_dynpro_cn_02-prio  = <ticket_cn>-bezeichnung.
*      gs_dynpro_cn_02-strmn   = <ticket_cn>-bezeichnung.
*      gs_dynpro_cn_02-ltrmn    = <ticket_cn>-bezeichnung.
*      gs_dynpro_cn_02-code  = <ticket_cn>-bezeichnung.
*      gs_dynpro_cn_02-contact_name  = <ticket_cn>-bezeichnung.
*      gs_dynpro_cn_02-contact_telnumber  = <ticket_cn>-bezeichnung.
*     gs_dynpro_cn_02-kurztext   =  ls_tickets_cn-bezeichnung.
*      gs_dynpro_cn_02-text_add  = <ticket_cn>-bezeichnung.

    ENDIF.

  ENDLOOP.
  IF sy-subrc = 0.
* Ticket mit Notiz anreichern
    PERFORM get_notice_02 TABLES lt_notice
                          USING '03'.
  ENDIF.
ENDFORM.
*FORM show_tree_code.
*
*  DATA: lo_salv_wd_table TYPE REF TO   iwci_salv_wd_table,
*        lo_ct_work       TYPE REF TO if_wd_context_node,
*        lo_ct_code_save  TYPE REF TO if_wd_context_node,
*        lo_ct_codes      TYPE REF TO if_wd_context_node,
*        ls_crm_cust      TYPE /promos/crm_cust,
*        lt_crm_cust      TYPE STANDARD TABLE OF /promos/crm_cust,
*        lv_code_count    TYPE sy-tabix,
*        lv_expand_all    TYPE oax,
*        lt_codes         TYPE STANDARD TABLE OF /promos/s_codes_wd.
*
*  lo_salv_wd_table            = wd_this->wd_cpifc_alv_codes( ).
*
*  IF first_time EQ 'X'.
***********************************************************************
** Eintellungen für Code-Auswahl-Tree:
*
*    DATA: ls_ct_work TYPE wd_this->element_ct_work.
*    wd_context->get_child_node(
*      EXPORTING
*        name       =  'CT_WORK'
*      RECEIVING
*        child_node = lo_ct_work ).
*
**   Customizing zum aktuellen Reiter ermitteln
*    lo_ct_work->get_static_attributes( IMPORTING static_attributes = ls_ct_work ).
*    wd_assist->get_crm_customizing( IMPORTING et_crm_cust = lt_crm_cust ).
*    READ TABLE lt_crm_cust INTO ls_crm_cust WITH KEY ticket_type = ls_ct_work-ticket_type ticket_type_lnr = ls_ct_work-ticket_type_lnr.
*
**   Codegruppen/Codes holen
*    lo_ct_work->get_child_node(
*      EXPORTING
*        name       =  'CODES'
*      RECEIVING
*        child_node = lo_ct_codes  ).
*    lo_ct_codes->get_static_attributes_table( IMPORTING table = lt_codes ).
*    lv_code_count = lo_ct_codes->get_element_count( ).
*
**   pschwalen, 24.03.2023, #43201,
**   Anhand des Customizings festlegen, ob Codegruppe/Code auf- oder zugeklappt werden sollen
**            Default (Codes anzeigen bis 160 Codes)
**       TT  Codes anzeigen bis 25 Codes
**       WW  Codes anzeigen bis 15 Codes
**       ZZ  Nur Codegruppen anzeigen
*    IF ls_crm_cust-code_popup = /promos/cl_crm_constants=>cc_code_popup_expand_all   AND lv_code_count <= 160.
*      lv_expand_all = abap_true.
*    ELSE.
*      lv_expand_all = abap_false.
*    ENDIF.
*
*
*
**   die anzuzeigenden Codes (Grundgesamtheit) noch mal merken, damit wir nach dem Filtern
**   alles wiederherstellen können.
*    wd_context->get_child_node( EXPORTING name = 'CT_CODES_SAVE' RECEIVING child_node = lo_ct_code_save ).
*    lo_ct_code_save->invalidate( ).
*    lo_ct_code_save->bind_table( EXPORTING new_items = lt_codes ).
*
*    CALL METHOD /promos/cl_crm_util=>build_code_alv
*      EXPORTING
*        io_alv        = lo_salv_wd_table
*        io_wd_assist  = wd_assist
*        iv_expand_all = lv_expand_all.
*
*
*  ELSE.
**   #35661, wenn eine neue Sicht gespeichert wird, geht die "Hierarchie"-Darstellung verloren,
**   deswegen selbige hier noch mal setzen
*    CALL METHOD /promos/cl_crm_util=>set_code_alv_to_hierarchy
*      EXPORTING
*        io_alv       = lo_salv_wd_table
*        io_wd_assist = wd_assist.
*
*  ENDIF.
*
*ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATETREECONTROL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM createtreecontrol .
* create Event Receiver
  CREATE OBJECT tree_event_receiver.
* create tree control
  CREATE OBJECT tree1
    EXPORTING
      i_parent                    = g_container_object
      i_node_selection_mode       = cl_gui_column_tree=>node_sel_mode_single
      i_item_selection            = ''
      i_no_html_header            = ''
      i_no_toolbar                = ''
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.
  IF sy-subrc <> 0.
*
  ENDIF.
* fields for tree
  PERFORM create_fieldcat.
* header for tree
  PERFORM create_header.
* Sorttable for tree
  PERFORM built_sort_table.
* handle for D'n'D
  gs_layout_tree-s_dragdrop-row_ddid = g_handle_tree.
* fill tree with data
  CALL METHOD tree1->set_table_for_first_display
    EXPORTING
      it_list_commentary = gt_header[]
*     I_BACKGROUND_ID    = 'ALV_BACKGROUND'
      is_layout          = gs_layout_tree
    CHANGING
      it_sort            = gt_sort[]
      it_outtab          = gt_codes[]
      it_fieldcatalog    = gt_fieldcat_lvc[].
* register events
  PERFORM register_events.
* set handler for tree1
  SET HANDLER tree_event_receiver->handle_double_click FOR tree1.
  SET HANDLER tree_event_receiver->handle_on_drag FOR tree1.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_fieldcat .
* get fieldcatalog
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = '/PROMOS/S_CODES_WD'
    CHANGING
      ct_fieldcat      = gt_fieldcat_lvc[].
* change fieldcatalog
  DATA: ls_fieldcatalog TYPE lvc_s_fcat.
  LOOP AT gt_fieldcat_lvc INTO ls_fieldcatalog.
    CASE ls_fieldcatalog-fieldname.
      WHEN 'CHECKED' OR 'GRP_TXT'.
        ls_fieldcatalog-no_out = selected.
        ls_fieldcatalog-key    = ''.
    ENDCASE.
    MODIFY gt_fieldcat_lvc FROM ls_fieldcatalog.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_header .
  CLEAR gt_header.
  gt_header-typ = 'H'.
  gt_header-info = TEXT-007.
  APPEND gt_header.
  CLEAR gt_header.
  gt_header-typ = 'S'.
  gt_header-key = TEXT-008.
  gt_header-info = TEXT-009.
  APPEND gt_header.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILT_SORT_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM built_sort_table .
  DATA ls_sort_wa TYPE lvc_s_sort.
* CARRID
  ls_sort_wa-spos = 1.
  ls_sort_wa-fieldname = 'CODEGRUPPE'.
  ls_sort_wa-up = selected.
  ls_sort_wa-subtot = ''.
  APPEND ls_sort_wa TO gt_sort.
* CONNID
  ls_sort_wa-spos = 2.
  ls_sort_wa-fieldname = 'CODE'.
  ls_sort_wa-up = selected.
  ls_sort_wa-subtot = ''.
  APPEND ls_sort_wa TO gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form REGISTER_EVENTS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events .
  DATA: lt_events TYPE cntl_simple_events,
        l_event   TYPE cntl_simple_event.
* define the events which will be passed to the backend
  CLEAR l_event.
  l_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  l_event-appl_event = selected.
  APPEND l_event TO lt_events.
  CLEAR l_event.
  l_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  APPEND l_event TO lt_events.
  CLEAR l_event.
  l_event-eventid = cl_gui_column_tree=>eventid_header_click.
  APPEND l_event TO lt_events.
  CLEAR l_event.
* register events
  CALL METHOD tree1->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.
    MESSAGE x534(0k).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATEDOCKINGCONTROL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM createdockingcontrol .
* create container for alv-tree
  CREATE OBJECT g_container_object
    EXPORTING
      side      = cl_gui_docking_container=>dock_at_left
      extension = 270
      repid     = sy-repid
      dynnr     = '0550'.
ENDFORM.
