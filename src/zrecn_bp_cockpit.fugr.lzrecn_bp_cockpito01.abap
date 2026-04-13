*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'MAIN'.
* Title
  SET TITLEBAR 'KUNDEN'  WITH gs_recn-recnnr gs_recn-xpartner.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Bestandskundenstatus
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.
* data lokal
*-------------------------------------------*

* weitere Verträge
  IF NOT go_cc_recn  IS BOUND.

*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_recn
      EXPORTING
        container_name = 'CC_RECN'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_recn
      IMPORTING
        r_salv_table = go_alv_recn
      CHANGING
        t_table      = gt_vicncn.

    PERFORM set_alv USING go_alv_recn.

  ENDIF.
* weitere Partner aus Vertrag
  IF NOT go_cc_partner IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_partner
      EXPORTING
        container_name = 'CC_PARTNER'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_partner
      IMPORTING
        r_salv_table = go_alv_partner
      CHANGING
        t_table      = gt_partner_cn.

    PERFORM set_alv USING go_alv_partner.
  ENDIF.

* Mitarbeiter
*  IF NOT go_cc_clerk IS BOUND.
**   Container 'weitere Verträge'
*    CREATE OBJECT go_cc_clerk
*      EXPORTING
*        container_name = 'CC_CLERK'.
*
**   ALV erzeugen
*    CALL METHOD cl_salv_table=>factory
*      EXPORTING
*        r_container  = go_cc_clerk
*      IMPORTING
*        r_salv_table = go_alv_clerk
*      CHANGING
*        t_table      = gt_clerk.
*
*    PERFORM set_alv USING go_alv_clerk.
*  ENDIF.

* Ticket
  IF NOT go_cc_ticket_cn IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_ticket_cn
      EXPORTING
        container_name = 'CC_TICKET_CN'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_cn
      IMPORTING
        r_salv_table = go_alv_ticket_cn
      CHANGING
        t_table      = gt_ticket_cn.

    PERFORM set_alv USING go_alv_ticket_cn.
  ENDIF.
* Ticket
  IF NOT go_cc_ticket_ro IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_ticket_ro
      EXPORTING
        container_name = 'CC_TICKET_RO'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_ro
      IMPORTING
        r_salv_table = go_alv_ticket_ro
      CHANGING
        t_table      = gt_ticket_ro.

    PERFORM set_alv USING go_alv_ticket_ro.
  ENDIF.
* Auftrag
  IF NOT go_cc_aufr IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_aufr
      EXPORTING
        container_name = 'CC_AUFTRAG'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_aufr
      IMPORTING
        r_salv_table = go_alv_aufr
      CHANGING
        t_table      = gt_aufk.

    PERFORM set_alv USING go_alv_aufr.
  ENDIF.

ENDMODULE.                 " PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE modify_screen_0100 OUTPUT.
*
*  LOOP AT SCREEN.
*    CASE screen-name.
*      WHEN 'GS_RECN-BIRTHDT'.
*        IF gd_edit_birth = abap_false.
*          screen-input = 0. "nicht änderbar
*        ELSE.
*          screen-input = 1. "änderbar
*        ENDIF.
*
*      WHEN 'GS_RECN-PHONE1'.
*        IF gd_edit_tel = abap_false.
*          screen-input = 0. "nicht änderbar
*        ELSE.
*          screen-input = 1. "änderbar
*        ENDIF.
*      WHEN 'GS_RECN-MOBILE1'.
*        IF gd_edit_mobil = abap_false.
*          screen-input = 0. "nicht änderbar
*        ELSE.
*          screen-input = 1. "änderbar
*        ENDIF.
*      WHEN 'GS_RECN-E_MAIL'.
*        IF gd_edit_email = abap_false.
*          screen-input = 0. "nicht änderbar
*        ELSE.
*          screen-input = 1. "änderbar
*        ENDIF.
*      WHEN 'GS_RECN-AVAIL_FROM'.
*        IF gd_edit_avail = abap_false.
*          screen-input = 0. "nicht änderbar
*        ELSE.
*          screen-input = 1. "änderbar
*        ENDIF.
*      WHEN 'GS_RECN-AVAIL_TO'.
*        IF gd_edit_avail = abap_false.
*          screen-input = 0. "nicht änderbar
*        ELSE.
*          screen-input = 1. "änderbar
*        ENDIF.
*      WHEN OTHERS.
*
*
*    ENDCASE.
*    MODIFY SCREEN.
*  ENDLOOP.
** Partner
*  IF NOT gd_show_partner IS INITIAL.
*    gd_dyn_partner = '0400'.
*    LOOP AT SCREEN.
*      IF   screen-name = 'PARTNER_EXPAND'
*        OR screen-name = 'PARTNER_EXPAND_TEXT'.
*        screen-input     = 0.
*        screen-invisible = 1.
*        MODIFY SCREEN.
*      ENDIF.
*      IF screen-name = 'PARTNER_COLLAPSE'.
*        screen-input     = 1.
*        screen-invisible = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ELSE.
*    gd_dyn_cn = '0999'."Leer
*    LOOP AT SCREEN.
*      IF   screen-name = 'PARTNER_EXPAND'
*        OR screen-name = 'PARTNER_EXPAND_TEXT'.
*        screen-input     = 1.
*        screen-invisible = 0.
*        MODIFY SCREEN.
*      ENDIF.
*      IF screen-name = 'PARTNER_COLLAPSE'.
*        screen-input     = 0.
*        screen-invisible = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*
*ENDMODULE.                 " MODIFY_SCREEN_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.

*  IF gd_berecht_checked = abap_false.
*    CALL FUNCTION 'Z_BP_BUTTON_KOMMDATEN_BERECHT'
*      IMPORTING
*        ed_ist_ok = gd_berecht_chgkom.
*
*    gd_berecht_checked = abap_true.
*  ENDIF.

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'GS_RECN-BIRTHDT'.
        IF gd_edit_birth = abap_false.
          screen-input = 0. "nicht änderbar
        ELSE.
          screen-input = 1. "änderbar
        ENDIF.

      WHEN 'GS_RECN-PHONE1'.
        IF gd_edit_tel = abap_false.
          screen-input = 0. "nicht änderbar
        ELSE.
          screen-input = 1. "änderbar
        ENDIF.
      WHEN 'GS_RECN-MOBILE1'.
        IF gd_edit_mobil = abap_false.
          screen-input = 0. "nicht änderbar
        ELSE.
          screen-input = 1. "änderbar
        ENDIF.
      WHEN 'GS_RECN-E_MAIL'.
        IF gd_edit_email = abap_false.
          screen-input = 0. "nicht änderbar
        ELSE.
          screen-input = 1. "änderbar
        ENDIF.
      WHEN 'GS_RECN-AVAIL_FROM'.
        IF gd_edit_avail = abap_false.
          screen-input = 0. "nicht änderbar
        ELSE.
          screen-input = 1. "änderbar
        ENDIF.
      WHEN 'GS_RECN-AVAIL_TO'.
        IF gd_edit_avail = abap_false.
          screen-input = 0. "nicht änderbar
        ELSE.
          screen-input = 1. "änderbar
        ENDIF.
      WHEN OTHERS.

    ENDCASE.

    IF screen-group1 = 'KOM' AND gd_berecht_chgkom = abap_false.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
* Supscreen setzen
  IF  gd_show_partner = abap_true.
* Tickets für Vertrag
    IF gd_show_ticket_cn = abap_true.
      gd_dyn_cn = '0410'."Ausgeklappt Ticket CN
* Ticket Mietobjekt
      IF gd_show_ticket_ro = abap_true.
        gd_dyn_cn = '0430'."Ausgeklappt Ticket RO
      ENDIF.
    ELSE.
      gd_dyn_cn = '0412'."Eingeklappt Ticket CN
      IF gd_show_ticket_ro = abap_true.
        gd_dyn_cn = '0431'."Ausgeklappt Ticket RO
      ENDIF.
    ENDIF.
  ELSE.
* kein Partner
    IF gd_show_ticket_cn = abap_true.
      gd_dyn_cn = '0420'."Eingeklappt.
      IF gd_show_ticket_ro = abap_true.
        gd_dyn_cn = '0432'."Eingeklappt Partner
      ENDIF.
    ELSE.
      gd_dyn_cn = '0422'."Ausgeklappt
      IF gd_show_ticket_ro = abap_true.
        gd_dyn_cn = '0433'."Ausgeklappt Ticket RO
      ENDIF.
    ENDIF.
  ENDIF.
*  IF  gd_show_ticket_ro IS INITIAL.
*    gd_dyn_ticket_cn = '510'. "Eingeklappt.
*  ELSE.
*    gd_dyn_ticket_cn = '520'. "Ausgeklappt
*  ENDIF.
ENDMODULE.                 " MODIFY_SCREEN_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_0410  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen_0410 OUTPUT.

* Partner
  IF NOT gd_show_partner IS INITIAL.
    gd_dyn_cn = '0410'.
    LOOP AT SCREEN.
      IF   screen-name = 'PARTNER_EXPAND'
        OR screen-name = 'PARTNER_EXPAND_TEXT'
        OR screen-name = 'TICKET_CN_EXPAND'
        OR screen-name = 'TICKET_CN_EXPAND_TEXT'.
        screen-input     = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'PARTNER_COLLAPSE'
        OR screen-name = 'TICKET_CN_EXPAND'.
        screen-input     = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    gd_dyn_cn = '0999'."Leer
    LOOP AT SCREEN.
      IF   screen-name = 'PARTNER_EXPAND'
        OR screen-name = 'PARTNER_EXPAND_TEXT'
        OR screen-name = 'TICKET_CN_EXPAND'
        OR screen-name = 'TICKET_CN_EXPAND_TEXT'.
        screen-input     = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'PARTNER_COLLAPSE'
         OR screen-name = 'TICKET_CN_EXPAND'.
        screen-input     = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " MODIFY_SCREEN_0410  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_0412  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen_0412 OUTPUT.

* Partner
  IF NOT gd_show_ticket_cn IS INITIAL.
    gd_dyn_cn = '0412'.
    LOOP AT SCREEN.
      IF   screen-name = 'TICKET_CN_EXPAND'
        OR screen-name = 'FRAME_TICKET_CN_TEXT'.
        screen-input     = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'TICKET_CN_COLLAPSE'.
        screen-input     = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    gd_dyn_cn = '0999'."Leer
    LOOP AT SCREEN.
      IF   screen-name = 'TICKET_CN_EXPAND'
        OR screen-name = 'TICKET_CN_EXPAND_TEXT'.
        screen-input     = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'TICKET_CN_COLLAPSE'.
        screen-input     = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " MODIFY_SCREEN_0602  OUTPUT
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0200'.
ENDMODULE.
MODULE status_0300 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0300'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form GET_NOTICE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_notice_01.
  DATA:
    ld_text_string TYPE string.
  DATA:
    ld_wordwrap TYPE i VALUE cl_gui_textedit=>false, " weiche Zeilenumbrüche werden beim Speichern ignoriert
    ld_width    TYPE i.
*---------------------
  IF go_dock_notice_01 IS NOT BOUND.
************************************************************************
* Notiz lesen
************************************************************************
    FREE go_dock_notice_01.
    FREE go_cc_notice_01.

* Text holen
    PERFORM notice_create USING ld_text_string.
************************************************************************
* Je nach Anforderung Notiz anzeigen oder ändern
************************************************************************
    IF go_cc_notice_01 IS INITIAL.

      CREATE OBJECT go_cc_notice_01
        EXPORTING
          container_name              = 'CC_NOTICE_01' "Anlegen
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      CREATE OBJECT go_dock_notice_01
        EXPORTING
          parent                     = go_cc_notice_01
          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
          wordwrap_position          = 100
          wordwrap_to_linebreak_mode = ld_wordwrap  " weiche Zeilenumbrüche in harte umwandeln?
        EXCEPTIONS
          error_cntl_create          = 1
          error_cntl_init            = 2
          error_cntl_link            = 3
          error_dp_create            = 4
          gui_type_not_supported     = 5
          OTHERS                     = 6.

      IF sy-subrc = 0.
        cl_gui_cfw=>flush( EXCEPTIONS OTHERS = 1 ).
      ENDIF.

      CHECK NOT go_dock_notice_01 IS INITIAL.

      go_dock_notice_01->set_textstream(
      EXPORTING
        text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
      EXCEPTIONS
        error_cntl_call_method = 1
        not_supported_by_gui   = 2
        OTHERS                 = 3 ).

    ELSE.
      go_dock_notice_01->set_textstream(
        EXPORTING
          text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
        EXCEPTIONS
          error_cntl_call_method = 1
          not_supported_by_gui   = 2
          OTHERS                 = 3
      ).
      IF sy-subrc <> 0.
      ENDIF.

    ENDIF.

*  IF id_anzeigen = 'X'.
    CALL METHOD go_dock_notice_01->set_readonly_mode
      EXPORTING
        readonly_mode          = cl_gui_textedit=>false
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
    ENDIF.

    go_dock_notice_01->set_toolbar_mode( 1 ).

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_NOTICE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_notice_ro_01.
  DATA:
    ld_text_string TYPE string.
  DATA:
    ld_wordwrap TYPE i VALUE cl_gui_textedit=>false, " weiche Zeilenumbrüche werden beim Speichern ignoriert
    ld_width    TYPE i.
*---------------------
  IF go_dock_notice_ro_01 IS NOT BOUND.
************************************************************************
* Notiz lesen
************************************************************************
    FREE go_dock_notice_ro_01.
    FREE go_cc_notice_ro_01.

* Text holen
    PERFORM notice_create USING ld_text_string.
************************************************************************
* Je nach Anforderung Notiz anzeigen oder ändern
************************************************************************
    IF go_cc_notice_ro_01 IS INITIAL.

      CREATE OBJECT go_cc_notice_ro_01
        EXPORTING
          container_name              = 'CC_NOTICE_RO_01' "Anlegen
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      CREATE OBJECT go_dock_notice_ro_01
        EXPORTING
          parent                     = go_cc_notice_ro_01
          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
          wordwrap_position          = 100
          wordwrap_to_linebreak_mode = ld_wordwrap  " weiche Zeilenumbrüche in harte umwandeln?
        EXCEPTIONS
          error_cntl_create          = 1
          error_cntl_init            = 2
          error_cntl_link            = 3
          error_dp_create            = 4
          gui_type_not_supported     = 5
          OTHERS                     = 6.

      IF sy-subrc = 0.
        cl_gui_cfw=>flush( EXCEPTIONS OTHERS = 1 ).
      ENDIF.

      CHECK NOT go_dock_notice_ro_01 IS INITIAL.

      go_dock_notice_ro_01->set_textstream(
      EXPORTING
        text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
      EXCEPTIONS
        error_cntl_call_method = 1
        not_supported_by_gui   = 2
        OTHERS                 = 3 ).

    ELSE.
      go_dock_notice_ro_01->set_textstream(
        EXPORTING
          text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
        EXCEPTIONS
          error_cntl_call_method = 1
          not_supported_by_gui   = 2
          OTHERS                 = 3
      ).
      IF sy-subrc <> 0.
      ENDIF.

    ENDIF.

*  IF id_anzeigen = 'X'.
    CALL METHOD go_dock_notice_ro_01->set_readonly_mode
      EXPORTING
        readonly_mode          = cl_gui_textedit=>false
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
    ENDIF.

    go_dock_notice_ro_01->set_toolbar_mode( 1 ).

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module PBO_200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0200 OUTPUT.
* Listbox setzen
  PERFORM get_listbox USING '01'.

* Notiz lesen
  PERFORM get_notice_01.


ENDMODULE. "pbo_200 OUTPUT.
*&---------------------------------------------------------------------*
*& Module STATUS_0210 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0210 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0210'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0210 OUTPUT.
  DATA:
   ls_values    TYPE ddfixvalue.
*--------------*

* Listbox setzen
  PERFORM get_listbox USING '02'.

* Notiz lesen
  PERFORM get_ticket_cn USING '02'. "Ändern

ENDMODULE. "pbo_300 OUTPUT.
*&---------------------------------------------------------------------*
*& Form GET_NOTICE_02
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_notice_02  TABLES pt_notice
                    USING p_dynpro.

  DATA: ld_text_string TYPE string.
*-----------------------*

* Bereits gelesen
  IF go_dock_notice_02 IS NOT BOUND.
************************************************************************
* Notiz lesen
************************************************************************
    FREE go_dock_notice_02.
    FREE go_cc_notice_02.
* Text holen
*   PERFORM notice_create USING ld_text_string.
    CONCATENATE LINES OF  pt_notice
    INTO ld_text_string SEPARATED BY cl_abap_char_utilities=>cr_lf.
************************************************************************
* Je nach Anforderung Notiz anzeigen oder ändern
************************************************************************
    IF go_cc_notice_02 IS INITIAL.
*      gd_teilnr = gs_dynpro_cn_02-teilnr.

      CREATE OBJECT go_cc_notice_02
        EXPORTING
          container_name              = 'CC_NOTICE_02' "Anlegen
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      CREATE OBJECT go_dock_notice_02
        EXPORTING
          parent                     = go_cc_notice_02
          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
          wordwrap_position          = 100
          wordwrap_to_linebreak_mode = cl_gui_textedit=>true
        EXCEPTIONS
          error_cntl_create          = 1
          error_cntl_init            = 2
          error_cntl_link            = 3
          error_dp_create            = 4
          gui_type_not_supported     = 5
          OTHERS                     = 6.

      IF sy-subrc <> 0.
      ENDIF.
    ENDIF.
  ENDIF.
  CHECK NOT go_dock_notice_02 IS INITIAL.
* Stream ermitteln
  CONCATENATE LINES OF  pt_notice
  INTO ld_text_string SEPARATED BY cl_abap_char_utilities=>cr_lf.

  go_dock_notice_02->set_textstream(
  EXPORTING
    text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
  EXCEPTIONS
    error_cntl_call_method = 1
    not_supported_by_gui   = 2
    OTHERS                 = 3 ).
*

  IF p_dynpro = '02'.
    CALL METHOD go_dock_notice_02->set_readonly_mode
      EXPORTING
        readonly_mode          = cl_gui_textedit=>false
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
    ENDIF.
  ELSE.
    CALL METHOD go_dock_notice_02->set_readonly_mode
      EXPORTING
        readonly_mode          = cl_gui_textedit=>true
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
    ENDIF.
  ENDIF.
  go_dock_notice_02->set_toolbar_mode( 1 ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_NOTICE_02
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_notice_ro_02  TABLES pt_notice
                    USING p_dynpro.

  DATA: ld_text_string TYPE string.
*-----------------------*

* Bereits gelesen
  IF go_dock_notice_ro_02 IS NOT BOUND.
************************************************************************
* Notiz lesen
************************************************************************
* Text holen^
    FREE go_dock_notice_ro_02.
    FREE go_cc_notice_ro_02.
*   PERFORM notice_create USING ld_text_string.
    CONCATENATE LINES OF  pt_notice
    INTO ld_text_string SEPARATED BY cl_abap_char_utilities=>cr_lf.
************************************************************************
* Je nach Anforderung Notiz anzeigen oder ändern
************************************************************************
    IF go_cc_notice_ro_02  IS INITIAL.
*      gd_teilnr = gs_dynpro_ro_02-teilnr.

      CREATE OBJECT go_cc_notice_ro_02
        EXPORTING
          container_name              = 'CC_NOTICE_RO_02' "Anlegen
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      CREATE OBJECT go_dock_notice_ro_02
        EXPORTING
          parent                     = go_cc_notice_ro_02
          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
          wordwrap_position          = 100
          wordwrap_to_linebreak_mode = cl_gui_textedit=>true
        EXCEPTIONS
          error_cntl_create          = 1
          error_cntl_init            = 2
          error_cntl_link            = 3
          error_dp_create            = 4
          gui_type_not_supported     = 5
          OTHERS                     = 6.

      IF sy-subrc <> 0.
      ENDIF.
    ENDIF.
*   CALL METHOD go_dock_notice_ro_02->free
*  EXCEPTIONS
*    cntl_error        = 1
*    cntl_system_error = 2
*    others            = 3
    .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
  CHECK NOT go_dock_notice_ro_02 IS INITIAL.
* Stream ermitteln
  CONCATENATE LINES OF  pt_notice
  INTO ld_text_string SEPARATED BY cl_abap_char_utilities=>cr_lf.

  go_dock_notice_ro_02->set_textstream(
  EXPORTING
    text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
  EXCEPTIONS
    error_cntl_call_method = 1
    not_supported_by_gui   = 2
    OTHERS                 = 3 ).
*

  IF p_dynpro =  '02'.
    CALL METHOD go_dock_notice_ro_02->set_readonly_mode
      EXPORTING
        readonly_mode          = cl_gui_textedit=>false
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
    ENDIF.
  ELSE.
    CALL METHOD go_dock_notice_ro_02->set_readonly_mode
      EXPORTING
        readonly_mode          = cl_gui_textedit=>true
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
    ENDIF.
  ENDIF.
  go_dock_notice_ro_02->set_toolbar_mode( 1 ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_NOTICE_02
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM get_notice_ro_01  TABLES pt_notice
*                    USING p_dynpro.
*
*  DATA: ld_text_string TYPE string.
**-----------------------* _01
*
** Bereits gelesen
*  IF go_dock_notice_ro_01 IS NOT BOUND.
*************************************************************************
** Notiz lesen
*************************************************************************
** Text holen
**   PERFORM notice_create USING ld_text_string.
*    CONCATENATE LINES OF  pt_notice
*    INTO ld_text_string SEPARATED BY cl_abap_char_utilities=>cr_lf.
*************************************************************************
** Je nach Anforderung Notiz anzeigen oder ändern
*************************************************************************
*    IF go_cc_notice_ro_01  IS INITIAL.
*      gd_teilnr = gs_dynpro_ro_01-teilnr.
*
*      CREATE OBJECT go_cc_notice_ro_01
*        EXPORTING
*          container_name              = 'CC_NOTICE_RO_01' "Anlegen
*        EXCEPTIONS
*          cntl_error                  = 1
*          cntl_system_error           = 2
*          create_error                = 3
*          lifetime_error              = 4
*          lifetime_dynpro_dynpro_link = 5
*          OTHERS                      = 6.
*
*      IF sy-subrc <> 0.
*        RETURN.
*      ENDIF.
*
*      CREATE OBJECT go_dock_notice_ro_01
*        EXPORTING
*          parent                     = go_cc_notice_ro_01
*          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
*          wordwrap_position          = 100
*          wordwrap_to_linebreak_mode = cl_gui_textedit=>true
*        EXCEPTIONS
*          error_cntl_create          = 1
*          error_cntl_init            = 2
*          error_cntl_link            = 3
*          error_dp_create            = 4
*          gui_type_not_supported     = 5
*          OTHERS                     = 6.
*
*      IF sy-subrc <> 0.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*  CHECK NOT go_dock_notice_ro_01 IS INITIAL.
** Stream ermitteln
*  CONCATENATE LINES OF  pt_notice
*  INTO ld_text_string SEPARATED BY cl_abap_char_utilities=>cr_lf.
*
*  go_dock_notice_ro_01->set_textstream(
*  EXPORTING
*    text                   = ld_text_string    " Text as String with Carriage Returns and Linefeeds
*  EXCEPTIONS
*    error_cntl_call_method = 1
*    not_supported_by_gui   = 2
*    OTHERS                 = 3 ).
**
*
*  IF p_dynpro =  '02'.
*    CALL METHOD go_dock_notice_ro_01->set_readonly_mode
*      EXPORTING
*        readonly_mode          = cl_gui_textedit=>false
*      EXCEPTIONS
*        error_cntl_call_method = 1
*        invalid_parameter      = 2
*        OTHERS                 = 3.
*
*    IF sy-subrc <> 0.
*    ENDIF.
*  ELSE.
*    CALL METHOD go_dock_notice_ro_01->set_readonly_mode
*      EXPORTING
*        readonly_mode          = cl_gui_textedit=>true
*      EXCEPTIONS
*        error_cntl_call_method = 1
*        invalid_parameter      = 2
*        OTHERS                 = 3.
*
*    IF sy-subrc <> 0.
*    ENDIF.
*  ENDIF.
*  go_dock_notice_ro_01->set_toolbar_mode( 1 ).
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Module PBO_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0220 OUTPUT.
* Listbox setzen
  PERFORM get_listbox USING '02'.
  PERFORM get_ticket_cn USING '03'. "Anzeigen
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0400 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0220 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0220'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0320 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0320 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0320'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0310 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0310 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR '0310'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form GET_LISTBOX
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_listbox USING p_dynpro.
  TYPE-POOLS : vrm.
  DATA: ld_field   TYPE vrm_id,
        lt_listbox TYPE vrm_values,
        ls_listbox LIKE LINE OF lt_listbox.
  DATA:
*        lt_code_all   TYPE /promos/tt_all_codes_wd,
*        ls_code_all   LIKE LINE OF lt_code_all,
*        lt_cn         TYPE /promos/tt_cn_wd,
*        ls_cn         LIKE LINE OF lt_cn,
*        ls_list_cn    LIKE LINE OF gt_recn,
*        lt_fields_ext TYPE /promos/tt_crm_cust_fields_ext,
*        ls_fields_ext LIKE LINE OF lt_fields_ext,
*        lt_initiator  TYPE /promos/tt_key_value,
*        ls_initiator  LIKE LINE OF lt_initiator,
*        lt_urspr      TYPE /promos/tt_key_value,
*        ls_urspr      LIKE LINE OF lt_urspr,
*        ls_codes      TYPE /promos/s_codes_wd,
*        lt_codes      TYPE TABLE OF /promos/s_codes_wd,
*        ls_prio       TYPE /promos/s_ct_prios,
    ld_num      TYPE i,
    ld_name(80).
  FIELD-SYMBOLS: <comp> TYPE any.
*--------------------------*
** Daten übergeben
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-RECNNR' INTO ld_name.
*  ASSIGN (ld_name) TO <comp>.
** Vertragsnummer
*  <comp> =  gs_recn-recnnr.

* Listfelder übergeben
  REFRESH: lt_listbox.
** Eingang
*  IF gt_urspr[] IS INITIAL.
** von DB lesen, da in der klasse /PROMOS/CL_CRM_ASSISTANCE
** als Privat gekennzeichnet
*    SELECT opct_urspr AS pair_key opct_ursprtxt AS pair_value
*      FROM /promos/opctumt AS urs "/promos/opctumt
*      INTO CORRESPONDING FIELDS OF TABLE gt_urspr
*        WHERE spras EQ sy-langu.
*  ENDIF.
*  LOOP AT gt_urspr INTO  ls_urspr.
*    ls_listbox-key = ls_urspr-pair_key. "Schlüssel
*    ls_listbox-text = ls_urspr-pair_value. "Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-URSPR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
*  ld_field =  <comp>.
** Wert setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

** Initiatoren
*  REFRESH: lt_listbox,  lt_fields_ext, lt_initiator.
*  lt_fields_ext[] = go_assistance->mt_cust_fields[].
*  LOOP AT  lt_fields_ext INTO  ls_fields_ext.
*    LOOP AT ls_fields_ext-t_value_help INTO ls_initiator.
*      ls_listbox-key = ls_initiator-pair_key. "Schlüssel
*      ls_listbox-text = ls_initiator-pair_value. "Beschreibung
*      APPEND ls_listbox TO lt_listbox.
*    ENDLOOP.
*  ENDLOOP.
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-INITIATOR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  REFRESH: lt_listbox.
** Prioritägen
*  IF gt_prio IS INITIAL.
*    SELECT *
*      FROM t356
*      JOIN t356_t
*        ON t356_t~spras EQ sy-langu
*       AND t356_t~artpr EQ t356~artpr
*       AND t356_t~priok EQ t356~priok
*      INTO CORRESPONDING FIELDS OF TABLE gt_prio.
*  ENDIF.
*
*  LOOP AT gt_prio  INTO  ls_prio WHERE artpr = 'PM'.
*    ls_listbox-key = ls_prio-priok."Schlüssel
*    ls_listbox-text = ls_prio-priokx. "Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-PRIO' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
** Codegruppe
*  REFRESH: lt_listbox, lt_codes.
*  lt_code_all[] = go_assistance->mt_all_codes[].
*  LOOP AT lt_code_all INTO ls_code_all WHERE
*     ticket_type = '01'.
*    LOOP AT ls_code_all-codes INTO ls_codes.
*      COLLECT ls_codes INTO lt_codes.
*    ENDLOOP.
** Code zentral übergeben für Texte
*    gt_codes[] = lt_codes[].
*  ENDLOOP.
*
*  CLEAR ld_num.
*  LOOP AT lt_codes INTO ls_codes.
*    CONCATENATE ls_codes-codegruppe ls_codes-code INTO
*        ls_listbox-key  SEPARATED BY '-'.
*    CONCATENATE ls_codes-kurztext_grp ls_codes-kurztext INTO
*        ls_listbox-text SEPARATED BY '-'.
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-CODE' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


* Verträge
  REFRESH: lt_listbox.
*  lt_cn[] = go_assistance->mt_cn[].
*
*  ls_listbox-key = gs_recn-recnnr."Schlüssel
*  ls_listbox-text = gs_recn-xmbez. "Beschreibung
*  APPEND ls_listbox TO lt_listbox.
*  LOOP AT gt_recn INTO ls_list_cn.
*    ls_listbox-key = ls_list_cn-recnnr."Schlüssel
*    ls_listbox-text = ls_list_cn-xmbez. "Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-RECNNR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id     = ld_field
*      values = lt_listbox.
*  IF sy-subrc =  0.
*    LOOP AT lt_listbox INTO  ls_listbox
*    WHERE key = gs_dynpro_cn_01-recnnr.
*      gs_dynpro_cn_01-recntxt = ls_listbox-text.
*      EXIT.
*    ENDLOOP.
*  ENDIF.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-CODE' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Feld spezifieren
** Betreff seten
*  CALL FUNCTION 'VRM_GET_VALUES'
*    EXPORTING
*      id           = ld_field
*    IMPORTING
*      values       = lt_listbox
*    EXCEPTIONS
*      id_not_found = 1
*      OTHERS       = 2.
*
*  IF sy-subrc =  0.
*    LOOP AT lt_listbox INTO  ls_listbox
*    WHERE key = gs_dynpro_cn_01-code.
*      gs_dynpro_cn_01-kurztext = ls_listbox-text.
*      EXIT.
*    ENDLOOP.
*  ENDIF.
*
** Status
*  REFRESH: lt_listbox.
** Status des Tickets
*  IF NOT gt_status IS INITIAL.
*    LOOP AT gt_status INTO gs_status.
*      ls_listbox-key = gs_status-low."Schlüssel
*      ls_listbox-text = gs_status-ddtext. "Beschreibung
*      APPEND ls_listbox TO lt_listbox.
*    ENDLOOP.
*  ENDIF.
*
*  READ TABLE gt_status INTO gs_status WITH KEY low = gs_dynpro_cn_02-status.
*  IF sy-subrc = 0.
*    gs_dynpro_cn_02-status_text = gs_status-ddtext.
*  ENDIF.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-STATUS' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-STATUS_TEXT' INTO ld_name.
*  ASSIGN (ld_name) TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
*  READ TABLE gt_status INTO gs_status WITH KEY low = gs_dynpro_cn_02-status.
*  IF sy-subrc = 0.
*    <comp> = gs_status-ddtext.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_PRIO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_prio USING p_dynpro.
  DATA: lt_dynp_field TYPE STANDARD TABLE OF dynpread,
        ls_dynp_field LIKE LINE OF  lt_dynp_field,
        ld_strmn      TYPE strmn,
        ld_ltrmn      TYPE ltrmn,
*       ld_priok      TYPE priok,
        ld_name(80),
        ld_date(10).
  STATICS:  ld_priok      TYPE priok.

  FIELD-SYMBOLS: <comp> TYPE any.
*--------------------------*
* Daten übergeben
  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-PRIO' INTO ld_name.
  ASSIGN (ld_name) TO <comp>.
*-----------------------*
  IF ld_priok = <comp>.
    RETURN.
  ENDIF.
  ld_priok = <comp>.
*   Wenn Datum inital und Prio nicht, die Datum berechnen lassen
  CALL FUNCTION 'CALCULATE_PRIORITY'
    EXPORTING
      i_artpr             = 'PM' "ls_crm_cust-artpr "'QM'
      i_priok             = ld_priok
      i_strmn             = sy-datum
    IMPORTING
      e_strmn             = ld_strmn
      e_ltrmn             = ld_ltrmn
    EXCEPTIONS
      invalid_prio        = 1
      invalid_date        = 2
      dimension_not_found = 3
      unit_not_found      = 4
      OTHERS              = 5.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.
  CLEAR  ls_dynp_field.
  REFRESH lt_dynp_field.
* Daten übergeben
* Von-Datum
  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-STRMN' INTO ld_name.
  ASSIGN (ld_name) TO <comp>.
  WRITE ld_strmn TO <comp>.
* Keine Vorbeleung falls Wert bereits vergeben wurde

  ls_dynp_field-fieldname =  ld_name.
  ls_dynp_field-fieldvalue = <comp>.
  APPEND ls_dynp_field TO lt_dynp_field.

* Bis-Datum
  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-LTRMN' INTO ld_name.
  ASSIGN (ld_name) TO <comp>.
  WRITE ld_ltrmn TO <comp>.
  ls_dynp_field-fieldname =  ld_name.
  ls_dynp_field-fieldvalue = <comp>.
  APPEND ls_dynp_field TO lt_dynp_field.

* Dynpro updaten
  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynp_field
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
* Implement suitable error handling here
  ENDIF.
ENDFORM.
FORM set_prio_ro USING p_dynpro.
  DATA: lt_dynp_field TYPE STANDARD TABLE OF dynpread,
        ls_dynp_field LIKE LINE OF  lt_dynp_field,
        ld_strmn      TYPE strmn,
        ld_ltrmn      TYPE ltrmn,
*       ld_priok      TYPE priok,
        ld_name(80),
        ld_date(10).
  STATICS:  ld_priok      TYPE priok.

  FIELD-SYMBOLS: <comp> TYPE any.
*--------------------------*
* Daten übergeben
  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-PRIO' INTO ld_name.
  ASSIGN (ld_name) TO <comp>.
*-----------------------*
  IF ld_priok = <comp>.
    RETURN.
  ENDIF.
  ld_priok = <comp>.
*   Wenn Datum inital und Prio nicht, die Datum berechnen lassen
  CALL FUNCTION 'CALCULATE_PRIORITY'
    EXPORTING
      i_artpr             = 'PM' "ls_crm_cust-artpr "'QM'
      i_priok             = ld_priok
      i_strmn             = sy-datum
    IMPORTING
      e_strmn             = ld_strmn
      e_ltrmn             = ld_ltrmn
    EXCEPTIONS
      invalid_prio        = 1
      invalid_date        = 2
      dimension_not_found = 3
      unit_not_found      = 4
      OTHERS              = 5.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.
  CLEAR  ls_dynp_field.
  REFRESH lt_dynp_field.
* Daten übergeben
* Von-Datum
  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-STRMN' INTO ld_name.
  ASSIGN (ld_name) TO <comp>.
  WRITE ld_strmn TO <comp>.
* Keine Vorbeleung falls Wert bereits vergeben wurde

  ls_dynp_field-fieldname =  ld_name.
  ls_dynp_field-fieldvalue = <comp>.
  APPEND ls_dynp_field TO lt_dynp_field.

* Bis-Datum
  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-LTRMN' INTO ld_name.
  ASSIGN (ld_name) TO <comp>.
  WRITE ld_ltrmn TO <comp>.
  ls_dynp_field-fieldname =  ld_name.
  ls_dynp_field-fieldvalue = <comp>.
  APPEND ls_dynp_field TO lt_dynp_field.

* Dynpro updaten
  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynp_field
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
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_CODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_code .
  DATA: lt_dynp_field TYPE STANDARD TABLE OF dynpread,
        ls_dynp_field LIKE LINE OF  lt_dynp_field.
*-----------------------*

  CLEAR  ls_dynp_field.
  REFRESH lt_dynp_field.
  ls_dynp_field-fieldname  = 'GS_DYNPRO_CN_01-KURZTEXT'.
  ls_dynp_field-fieldvalue = gs_dynpro_cn_01-code.
  APPEND ls_dynp_field TO lt_dynp_field.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_dynp_field
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
* Implement suitable error handling here
  ENDIF.

ENDFORM.
FORM set_code_ro.
  DATA: lt_dynp_field TYPE STANDARD TABLE OF dynpread,
        ls_dynp_field LIKE LINE OF  lt_dynp_field,
        ls_code       LIKE LINE OF gt_codes,
        ld_fdpos      LIKE sy-fdpos.
*-----------------------*
*  SEARCH gs_dynpro_ro_01-code FOR '-'.
*  IF sy-subrc = 0.
*    ls_code-codegruppe = gs_dynpro_ro_01-code(sy-fdpos).
*    ld_fdpos  = sy-fdpos.
*    ld_fdpos = ld_fdpos + 1.
*    ls_code-code = gs_dynpro_ro_01-code+ld_fdpos.
*  ENDIF.
*  READ TABLE gt_codes_all INTO ls_code WITH KEY
*  codegruppe = ls_code-codegruppe
*  code = ls_code-code.
*  IF sy-subrc = 0.
*    CONCATENATE ls_code-kurztext_grp  ls_code-kurztext INTO
*                gs_dynpro_ro_01-code_text SEPARATED BY '-'.
*    gs_dynpro_ro_01-kurztext = ls_code-kurztext.
*  ENDIF.
*
*  CLEAR  ls_dynp_field.
*  REFRESH lt_dynp_field.
*  ls_dynp_field-fieldname  = 'GS_DYNPRO_RO_01-KURZTEXT'.
*  ls_dynp_field-fieldvalue = gs_dynpro_ro_01-code_text.
*  APPEND ls_dynp_field TO lt_dynp_field.
*
*  CALL FUNCTION 'DYNP_VALUES_UPDATE'
*    EXPORTING
*      dyname               = sy-repid
*      dynumb               = sy-dynnr
*    TABLES
*      dynpfields           = lt_dynp_field
*    EXCEPTIONS
*      invalid_abapworkarea = 1
*      invalid_dynprofield  = 2
*      invalid_dynproname   = 3
*      invalid_dynpronummer = 4
*      invalid_request      = 5
*      no_fielddescription  = 6
*      undefind_error       = 7
*      OTHERS               = 8.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module PBO_0320 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0320 OUTPUT.
* Listbox setzen
  PERFORM get_listbox_ro USING '02'.
  PERFORM get_ticket_ro USING '03'. "Anzeigen
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0320 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0310 OUTPUT.
* Listbox setzen
  PERFORM get_listbox_ro USING '02'.
  PERFORM get_ticket_ro USING '02'. "Anzeigen
ENDMODULE.

*&---------------------------------------------------------------------*
*& Form GET_LISTBOX
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_listbox_ro USING p_dynpro.
  TYPE-POOLS : vrm.
  DATA: ld_field   TYPE vrm_id,
        lt_listbox TYPE vrm_values,
        ls_listbox LIKE LINE OF lt_listbox.
  DATA:
*        lt_code_all   TYPE /promos/tt_all_codes_wd,
*        ls_code_all   LIKE LINE OF lt_code_all,
*        lt_cn         TYPE /promos/tt_cn_wd,
*        ls_cn         LIKE LINE OF lt_cn,
*        ls_list_cn    LIKE LINE OF gt_recn,
*        lt_fields_ext TYPE /promos/tt_crm_cust_fields_ext,
*        ls_fields_ext LIKE LINE OF lt_fields_ext,
*        lt_initiator  TYPE /promos/tt_key_value,
*        ls_initiator  LIKE LINE OF lt_initiator,
*        lt_urspr      TYPE /promos/tt_key_value,
*        ls_urspr      LIKE LINE OF lt_urspr,
*        ls_codes      TYPE /promos/s_codes_wd,
*        lt_codes      TYPE TABLE OF /promos/s_codes_wd,
*        ls_prio       TYPE /promos/s_ct_prios,
*        lt_relation   TYPE /promos/tt_ct_relations_wd,
*        ls_relation   LIKE LINE OF lt_relation,
    ld_num      TYPE i,
    ld_name(80).
  FIELD-SYMBOLS: <comp> TYPE any.
*--------------------------*
** Daten übergeben
*  CONCATENATE 'GS_DYNPRO_CN_' p_dynpro '-RECNNR' INTO ld_name.
*  ASSIGN (ld_name) TO <comp>.
** Vertragsnummer
*  <comp> =  gs_recn-recnnr.
* technische Plätze
*  REFRESH: lt_listbox, lt_relation.
*  lt_relation[] = go_assistance->mt_relations[].
*  LOOP AT lt_relation INTO  ls_relation
*    WHERE value01(2) = 'IF'.
*    ls_listbox-key = ls_relation-value. "Schlüsse
*    ls_listbox-text = ls_relation-value02."Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-TPLNR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
*  ld_field =  <comp>.
** Wert setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
** Text technischer Platz übergeben
*  LOOP AT lt_relation INTO  ls_relation
*    WHERE value = gs_dynpro_ro_01-tplnr.
*    EXIT.
*  ENDLOOP.
*  IF sy-subrc = 0.
*    gs_dynpro_ro_01-pltxt = ls_relation-value02.
*  ENDIF.
*
** Listfelder übergeben
*  REFRESH: lt_listbox.
** Eingang
*  IF gt_urspr[] IS INITIAL.
** von DB lesen, da in der klasse /PROMOS/CL_CRM_ASSISTANCE
** als Privat gekennzeichnet
*    SELECT opct_urspr AS pair_key opct_ursprtxt AS pair_value
*      FROM /promos/opctumt AS urs "/promos/opctumt
*      INTO CORRESPONDING FIELDS OF TABLE gt_urspr
*        WHERE spras EQ sy-langu.
*  ENDIF.
*  LOOP AT gt_urspr INTO  ls_urspr.
*    ls_listbox-key = ls_urspr-pair_key. "Schlüssel
*    ls_listbox-text = ls_urspr-pair_value. "Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-URSPR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
*  ld_field =  <comp>.
** Wert setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
** Initiatoren
*  REFRESH: lt_listbox,  lt_fields_ext, lt_initiator.
*  lt_fields_ext[] = go_assistance->mt_cust_fields[].
*  LOOP AT  lt_fields_ext INTO  ls_fields_ext.
*    LOOP AT ls_fields_ext-t_value_help INTO ls_initiator.
*      ls_listbox-key = ls_initiator-pair_key. "Schlüssel
*      ls_listbox-text = ls_initiator-pair_value. "Beschreibung
*      APPEND ls_listbox TO lt_listbox.
*    ENDLOOP.
*  ENDLOOP.
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-INITIATOR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  REFRESH: lt_listbox.
** Prioritägen
*  IF gt_prio IS INITIAL.
*    SELECT *
*      FROM t356
*      JOIN t356_t
*        ON t356_t~spras EQ sy-langu
*       AND t356_t~artpr EQ t356~artpr
*       AND t356_t~priok EQ t356~priok
*      INTO CORRESPONDING FIELDS OF TABLE gt_prio.
*  ENDIF.
*
*  LOOP AT gt_prio  INTO  ls_prio WHERE artpr = 'PM'.
*    ls_listbox-key = ls_prio-priok."Schlüssel
*    ls_listbox-text = ls_prio-priokx. "Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-PRIO' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
** Codegruppe
*  REFRESH: lt_listbox, lt_codes.
*  lt_code_all[] = go_assistance->mt_all_codes[].
*  LOOP AT lt_code_all INTO ls_code_all WHERE
*  ticket_type = '02' AND
* ticket_type_lnr = '06'.
*
*    LOOP AT ls_code_all-codes INTO ls_codes.
*      COLLECT ls_codes INTO lt_codes.
*    ENDLOOP.
** Code zentral übergeben für Texte
*    gt_codes[] = lt_codes[].
*  ENDLOOP.
*
*  CLEAR ld_num.
*  LOOP AT lt_codes INTO ls_codes.
*    CONCATENATE ls_codes-codegruppe ls_codes-code INTO
*        ls_listbox-key  SEPARATED BY '-'.
*    CONCATENATE ls_codes-kurztext_grp ls_codes-kurztext INTO
*        ls_listbox-text SEPARATED BY '-'.
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-CODE' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

*
** Verträge
*  REFRESH: lt_listbox.
**  lt_cn[] = go_assistance->mt_cn[].
*
*  ls_listbox-key = gs_recn-recnnr."Schlüssel
*  ls_listbox-text = gs_recn-xmbez. "Beschreibung
*  APPEND ls_listbox TO lt_listbox.
*  LOOP AT gt_recn INTO ls_list_cn.
*    ls_listbox-key = ls_list_cn-recnnr."Schlüssel
*    ls_listbox-text = ls_list_cn-xmbez. "Beschreibung
*    APPEND ls_listbox TO lt_listbox.
*  ENDLOOP.
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-RECNNR' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id     = ld_field
*      values = lt_listbox.
*  IF sy-subrc =  0.
*    LOOP AT lt_listbox INTO  ls_listbox
*    WHERE key = gs_dynpro_cn_01-recnnr.
*      gs_dynpro_cn_01-recntxt = ls_listbox-text.
*      EXIT.
*    ENDLOOP.
*  ENDIF.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-CODE' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Feld spezifieren
** Betreff seten
*  CALL FUNCTION 'VRM_GET_VALUES'
*    EXPORTING
*      id           = ld_field
*    IMPORTING
*      values       = lt_listbox
*    EXCEPTIONS
*      id_not_found = 1
*      OTHERS       = 2.
*
*  IF sy-subrc =  0.
*    LOOP AT lt_listbox INTO  ls_listbox
*    WHERE key = gs_dynpro_cn_01-code.
*      gs_dynpro_cn_01-kurztext = ls_listbox-text.
*      EXIT.
*    ENDLOOP.
*  ENDIF.
*
** Status
*  REFRESH: lt_listbox.
** Status des Tickets
*  IF NOT gt_status IS INITIAL.
*    LOOP AT gt_status INTO gs_status.
*      ls_listbox-key = gs_status-low."Schlüssel
*      ls_listbox-text = gs_status-ddtext. "Beschreibung
*      APPEND ls_listbox TO lt_listbox.
*    ENDLOOP.
*  ENDIF.
*
*  READ TABLE gt_status INTO gs_status WITH KEY low = gs_dynpro_cn_02-status.
*  IF sy-subrc = 0.
*    gs_dynpro_cn_02-status_text = gs_status-ddtext.
*  ENDIF.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-STATUS' INTO ld_name.
*  ASSIGN  ld_name  TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
** Value setzen
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = ld_field
*      values          = lt_listbox
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
** Feld spezifieren
*  CONCATENATE 'GS_DYNPRO_RO_' p_dynpro '-STATUS_TEXT' INTO ld_name.
*  ASSIGN (ld_name) TO <comp>.
** Feld spezifieren
*  ld_field = <comp>.
*  READ TABLE gt_status INTO gs_status WITH KEY low = gs_dynpro_cn_02-status.
*  IF sy-subrc = 0.
*    <comp> = gs_status-ddtext.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module PBO_0500 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0300 OUTPUT.
* Listbox setzen
  PERFORM get_listbox_ro USING '01'.
  PERFORM get_notice_ro_01.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SET_TPLNR_RO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_tplnr_ro USING p_dynpro.

  DATA: lt_dynp_field TYPE STANDARD TABLE OF dynpread,
        ls_dynp_field LIKE LINE OF  lt_dynp_field.
*        lt_relation   TYPE /promos/tt_ct_relations_wd,
*        ls_relation   LIKE LINE OF lt_relation.
*-----------------------*
*  lt_relation[] = go_assistance->mt_relations[].
*  LOOP AT lt_relation INTO  ls_relation
*    WHERE value = gs_dynpro_ro_01-tplnr.
*    EXIT.
*  ENDLOOP.
*  IF sy-subrc NE 0.
*    RETURN.
*  ENDIF.
*  CLEAR  ls_dynp_field.
*  REFRESH lt_dynp_field.
*
*  ls_dynp_field-fieldname  = 'GS_DYNPRO_RO_01-PLTXT'.
*  ls_dynp_field-fieldvalue = ls_relation-value02.
*  APPEND ls_dynp_field TO lt_dynp_field.
*  gs_dynpro_ro_01-pltxt = ls_relation-value02.
*  CALL FUNCTION 'DYNP_VALUES_UPDATE'
*    EXPORTING
*      dyname               = sy-repid
*      dynumb               = sy-dynnr
*    TABLES
*      dynpfields           = lt_dynp_field
*    EXCEPTIONS
*      invalid_abapworkarea = 1
*      invalid_dynprofield  = 2
*      invalid_dynproname   = 3
*      invalid_dynpronummer = 4
*      invalid_request      = 5
*      no_fielddescription  = 6
*      undefind_error       = 7
*      OTHERS               = 8.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module PBO_0600 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0400 OUTPUT.
* weitere Mitarbeiter
  IF NOT go_cc_clerk IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_clerk
      EXPORTING
        container_name = 'CC_CLERK'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_clerk
      IMPORTING
        r_salv_table = go_alv_clerk
      CHANGING
        t_table      = gt_clerk.

    PERFORM set_alv USING go_alv_clerk.
    go_alv_partner->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_partner->refresh( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0410 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0410 OUTPUT.

* weitere Mitarbeiter Clerk
  IF NOT go_cc_clerk IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_clerk
      EXPORTING
        container_name = 'CC_CLERK'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_clerk
      IMPORTING
        r_salv_table = go_alv_clerk
      CHANGING
        t_table      = gt_clerk.

    PERFORM set_alv USING go_alv_clerk.
    go_alv_partner->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_partner->refresh( ).
  ENDIF.
* Ticket Vertrag
  IF NOT go_cc_ticket_cn IS BOUND.
*   Container 'TICKET_CN'
    CREATE OBJECT go_cc_ticket_cn
      EXPORTING
        container_name = 'CC_TICKET_CN'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_cn
      IMPORTING
        r_salv_table = go_alv_ticket_cn
      CHANGING
        t_table      = gt_ticket_cn.

    PERFORM set_alv USING go_alv_ticket_cn.
    go_alv_ticket_cn->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_ticket_cn->refresh( ).
  ENDIF.
* Tickets Mietobjet
  IF NOT go_cc_ticket_cn IS BOUND.
*   Container 'TICKET_RO'
    CREATE OBJECT go_cc_ticket_ro
      EXPORTING
        container_name = 'CC_TICKET_RO'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_ro
      IMPORTING
        r_salv_table = go_alv_ticket_ro
      CHANGING
        t_table      = gt_ticket_ro.

    PERFORM set_alv USING go_alv_ticket_ro.
    go_alv_ticket_ro->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_ticket_ro->refresh( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0510 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0510 OUTPUT.

* Ticket Vertrag
  IF NOT go_cc_ticket_cn IS BOUND.
*   Container 'TICKET_CN'
    CREATE OBJECT go_cc_ticket_cn
      EXPORTING
        container_name = 'CC_TICKET_CN'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_cn
      IMPORTING
        r_salv_table = go_alv_ticket_cn
      CHANGING
        t_table      = gt_ticket_cn.

    PERFORM set_alv USING go_alv_ticket_cn.
    go_alv_ticket_cn->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_ticket_cn->refresh( ).
  ENDIF.
* Tickets Mietobjet
  IF NOT go_cc_ticket_cn IS BOUND.
*   Container 'TICKET_RO'
    CREATE OBJECT go_cc_ticket_ro
      EXPORTING
        container_name = 'CC_TICKET_RO'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_ro
      IMPORTING
        r_salv_table = go_alv_ticket_ro
      CHANGING
        t_table      = gt_ticket_ro.

    PERFORM set_alv USING go_alv_ticket_ro.
    go_alv_ticket_ro->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_ticket_ro->refresh( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0610 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0610 OUTPUT.
*   Container 'aktuelle Flächen' Popup
  IF NOT go_cc_area IS BOUND.
    CREATE OBJECT go_cc_area
      EXPORTING
        container_name = 'CC_AREA'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_area
      IMPORTING
        r_salv_table = go_alv_area
      CHANGING
        t_table      = gt_area.

    PERFORM set_alv USING go_alv_area.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0615 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0615 OUTPUT.
* weitere Mitarbeiter
  IF NOT go_cc_ticket_cn IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_ticket_ro
      EXPORTING
        container_name = 'CC_TICKET_RO'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ticket_ro
      IMPORTING
        r_salv_table = go_alv_ticket_ro
      CHANGING
        t_table      = gt_ticket_ro.

    PERFORM set_alv USING go_alv_ticket_ro.
    go_alv_ticket_ro->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
  ELSE.
    go_alv_ticket_ro->refresh( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0510 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0510 OUTPUT.
  LOOP AT SCREEN.
    IF   screen-name = 'TICKET_RO_EXPAND'
      OR screen-name = 'TICKET_RO_TEXT'.
      screen-input     = 1.
      screen-invisible = 0.
      MODIFY SCREEN.
    ENDIF.
    IF screen-name = 'TICKET_RO_COLLAPSE'.
      screen-input     = 0.
      screen-invisible = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0520 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0520 OUTPUT.
  LOOP AT SCREEN.
    IF   screen-name = 'TICKET_RO_EXPAND'
      OR screen-name = 'TICKET_RO_EXPAND_TEXT'.
      screen-input     = 0.
      screen-invisible = 1.
      MODIFY SCREEN.
    ENDIF.
    IF screen-name = 'TICKET_RO_COLLAPSE'.
      screen-input     = 1.
      screen-invisible = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module GET_510 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE get_510 OUTPUT.
*  DATA:lt_return             TYPE TABLE OF  bapiret2,
*       lt_crm_tree_table     TYPE /promos/tt_ct_data_wd,
*       lt_crm_fl_ticket_list TYPE /promos/tt_crm_ticket_wd,
*       ls_crm_fl_ticket_list LIKE LINE OF lt_crm_fl_ticket_list,
*       lt_crm_fl_tree_table  TYPE /promos/tt_ct_data_wd,
*       ls_children_be        TYPE /promos/s_ct_data,
*       ls_children_wd        TYPE /promos/s_ct_data_wd,
*       lv_not_refreshed      TYPE wdy_boolean.
*--------------------------------*
*  IF gd_ticket_ro_new IS INITIAL.
** Nur einmal beim Aufklappen nachlesen.
*    gd_ticket_ro_new = abap_true.
** IH-Historie jetzt über neue Logik!
*    go_assistance->ms_crm_conf-add_ih_tickets = abap_true.
** Daten aus Backend holen
*    CALL METHOD go_assistance->get_add_infos_ct
*      EXPORTING
*        iv_partner = gd_partner
*      IMPORTING
*        et_return  = lt_return.
*
** Alle Tickets zur TPs holen
*    REFRESH: lt_crm_fl_ticket_list, lt_crm_fl_tree_table, gt_tickets_bak_ro, gt_ticket_ro.
** Tickets aus Klasse holen
*    CALL METHOD go_assistance->get_crm_fl_ticket_list
*      EXPORTING
*        is_ticket_selection  = gd_selection
*        iv_partner           = gd_partner
*      IMPORTING
*        ev_not_refreshed     = lv_not_refreshed
*      CHANGING
*        ct_crm_fl_ticket     = lt_crm_fl_ticket_list
*        ct_crm_fl_tree_table = lt_crm_fl_tree_table.
*
*    LOOP AT lt_crm_fl_ticket_list INTO ls_crm_fl_ticket_list.
*      CLEAR gs_ticket_ro.
*      MOVE-CORRESPONDING ls_crm_fl_ticket_list TO gs_ticket_ro.
*      gs_ticket_ro-teilnr = ls_crm_fl_ticket_list-id_txt.
*      LOOP AT ls_crm_fl_ticket_list-t_children INTO ls_children_wd
*      WHERE objtyp = 'BUS0010'.
*        MOVE-CORRESPONDING ls_children_wd TO gs_ticket_ro.
*        gs_ticket_ro-bezeichnung = ls_children_wd-bezeichnung.
*        gs_ticket_ro-tplnr = ls_children_wd-relation.
*        gs_ticket_ro-pltxt = ls_children_wd-relation_text.
*      ENDLOOP.
*      IF sy-subrc NE 0.
*        CONTINUE.
*      ENDIF.
*      gs_ticket_ro-teilnr = ls_crm_fl_ticket_list-id_txt.
*      APPEND gs_ticket_ro TO gt_ticket_ro.
** BAK Tabelle aufbauen
*      APPEND ls_crm_fl_ticket_list TO gt_tickets_bak_ro.
*    ENDLOOP.
*    IF sy-subrc  = 0.
*      SORT gt_ticket_ro BY statusdatum DESCENDING teilnr DESCENDING.
*    ENDIF.
*  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form GET_COND_PBO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_cond_pbo .
  DATA:
    lo_condition_mngr  TYPE REF TO if_recd_condition_mngr.
*--------------------------------*
  CHECK go_cn IS BOUND.
  CALL METHOD go_cn->if_recd_has_condition~get_condition_mngr
    RECEIVING
      ro_condition_mngr = lo_condition_mngr.
  CHECK lo_condition_mngr IS BOUND.

  CALL FUNCTION 'RECD_GUI_CONDITIONS_PBO'
    EXPORTING
      io_condition_mngr = lo_condition_mngr
      id_support        = abap_false
      id_subscreen      = abap_true
*     id_alvgrid        = abap_true  "abap_false
*     if_cond_hide_enabled = abap_false
    IMPORTING
      es_subscreen      = gs_gui-subscreen_condition.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module TREE_AND_DOCKING OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE tree_0550  OUTPUT.

  IF controls_created IS INITIAL.
*   docking control
    PERFORM createdockingcontrol.
*   tree control
    PERFORM createtreecontrol.
    controls_created = selected.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0420 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0420 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0600 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0600 OUTPUT.
  SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0610 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0610 OUTPUT.
  SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0600 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0600 OUTPUT.
  IF NOT go_cc_condition IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_condition
      EXPORTING
        container_name = 'CC_CONDITION'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_condition
      IMPORTING
        r_salv_table = go_alv_cond
      CHANGING
        t_table      = gt_cond.

    PERFORM set_alv USING go_alv_cond.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0550 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0550 OUTPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module ALV_DISPLAY OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE alv_display OUTPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_5000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_5000 OUTPUT.

ENDMODULE.
