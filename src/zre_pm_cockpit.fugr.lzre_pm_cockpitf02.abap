*----------------------------------------------------------------------*
***INCLUDE /DATRAIN/LKC_MAINF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  alv_user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_user_command                                       "#EC CALLED
            USING r_ucomm     LIKE sy-ucomm                 "#EC NEEDED
                  rs_selfield TYPE slis_selfield.

  CALL METHOD gx_kc->set_selected_alv_row
    EXPORTING
      iv_tabix = rs_selfield-tabindex.
  rs_selfield-exit = 'X'.

ENDFORM.                    " alv_user_command
*&---------------------------------------------------------------------*
*&      Form  ALV_Q_HIST_USER_COMMAND
*&---------------------------------------------------------------------*
FORM alv_q_hist_user_command                                "#EC CALLED
            USING r_ucomm     LIKE sy-ucomm
                  rs_selfield TYPE slis_selfield.

  CASE r_ucomm.
    WHEN '&IC1'.
      CALL METHOD gx_kc->set_selected_q_hist_row
        EXPORTING
          iv_tabix = rs_selfield-tabindex.
*      RS_SELFIELD-EXIT = 'X'.

      rs_selfield-refresh = 'X'.

    WHEN 'CHGNOT'.
      CALL METHOD gx_kc->change_selected_q_hist_row
        EXPORTING
          iv_tabix = rs_selfield-tabindex.

      rs_selfield-refresh = 'X'.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.                    " ALV_Q_HIST_USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  SET_PF_STATUS_LIST_PART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM set_pf_status_list_part
                       USING rt_extab TYPE slis_t_extab.    "#EC CALLED
  CLEAR rt_extab.
*  SET PF-STATUS 'PF_SEARCH'.
  SET PF-STATUS 'LIST_PART2'.
ENDFORM.                    "SET_PF_STATUS_LIST_PART

*&---------------------------------------------------------------------*
*&      Form  SET_PF_STATUS_SEARCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM set_pf_status_search USING rt_extab TYPE slis_t_extab. "#EC CALLED
  CLEAR rt_extab.
  SET PF-STATUS 'PF_SEARCH'.
ENDFORM.                    "SET_PF_STATUS_LIST_PART

*&---------------------------------------------------------------------*
*&      Form  ALV_Q_HIST_USER_COMMAND
*&---------------------------------------------------------------------*
FORM alv_list_part_user_command                             "#EC CALLED
            USING r_ucomm     LIKE sy-ucomm
                  rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&IC1'.
      CALL METHOD gx_kc->set_selected_list_part_row
        EXPORTING
          iv_tabix = rs_selfield-tabindex.
*      RS_SELFIELD-EXIT = 'X'.


    WHEN OTHERS.

  ENDCASE.

ENDFORM.                    " ALV_LIST_PART_USER_COMMAND

*-----------------------------------------------------------------------
*    FORM PF_STATUS_SET
*-----------------------------------------------------------------------
FORM qmel_hist USING  extab TYPE slis_t_extab.              "#EC CALLED
  SET PF-STATUS 'QMEL_HIST' EXCLUDING extab.
ENDFORM.                    "QMEL_HIST
*&---------------------------------------------------------------------*
*&      Form  SHOW_PARTNER_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_partner_list .
*  DATA: lt_fcat            TYPE lvc_t_fcat,
*        ls_layout          TYPE lvc_s_layo.

  IF gv_init_7500 IS INITIAL.
    IF gx_alv_sl_container IS NOT INITIAL.
      FREE gx_alv_sl_container.
    ENDIF.

    CREATE OBJECT gx_alv_sl_container
      EXPORTING
        container_name = 'SCR_CONT_7500'.

    CREATE OBJECT gx_alv
      EXPORTING
        i_parent = gx_alv_sl_container.

    CALL METHOD gx_partner->show_partner_list
      EXPORTING
        ix_alv = gx_alv.
    gv_init_7500 = 'X'.
  ENDIF.
ENDFORM.                    " SHOW_PARTNER_LIST
*&---------------------------------------------------------------------*
*&      Form  SET_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_partner .
  DATA: lt_index_rows	TYPE lvc_t_row,
        ls_index_row  TYPE lvc_s_row,
        lt_row_no	    TYPE lvc_t_roid,
        lv_lines      TYPE i,
        lv_tabix      TYPE sytabix.

  CALL METHOD gx_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_index_rows
      et_row_no     = lt_row_no.

  DESCRIBE TABLE lt_row_no LINES lv_lines.

  IF lv_lines EQ 1.
    READ TABLE lt_index_rows INTO ls_index_row INDEX 1.
    lv_tabix = ls_index_row-index.
    CALL METHOD gx_kc->set_selected_row_7500
      EXPORTING
        iv_tabix = lv_tabix.

  ELSE.
    MESSAGE s011(/datrain/kc_be).
  ENDIF.
ENDFORM.                    " SET_PARTNER

*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_mlus_user_command                                  "#EC CALLED
            USING r_ucomm     LIKE sy-ucomm                 "#EC NEEDED
                  rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&ONT'.
*      MESSAGE 'Trying to save' TYPE 'S'.
*      PERFORM save_mlus_data.
  ENDCASE.
ENDFORM.                    " alv_user_command
*&---------------------------------------------------------------------*
*&      Form  EDIT_MLUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM edit_mlus .
  CONSTANTS:
        lc_alvid  TYPE /datrain/al_de_alvid VALUE 'MLUS'.

  DATA: lt_fcat   TYPE lvc_t_fcat,
        lt_alv    TYPE /datrain/al_tt_alv,

        ls_fcat   TYPE lvc_s_fcat,
        ls_alv    TYPE /datrain/al_st_alv,
        ls_layout TYPE lvc_s_layo,

        lv_count  TYPE i.

  FIELD-SYMBOLS:
          <fs_fcat> TYPE lvc_s_fcat.

  IF gv_init_7600 IS INITIAL.
    IF gx_alv_mlus IS NOT INITIAL.
      FREE gx_alv_mlus.
    ENDIF.

    CREATE OBJECT gx_alv_mlus
      EXPORTING
        container_name = 'SCR_CONT_7600'.

    CREATE OBJECT gx_alv
      EXPORTING
        i_parent = gx_alv_mlus.

* Erstmal Customizing lesen
    CALL METHOD /datrain/al_cl_read_db=>get_alv_fields2
      EXPORTING
        iv_alvid     = lc_alvid
        iv_appid     = gv_appid
        iv_anwendung = gc_anwendung_2
        iv_structure = '/DATRAIN/KC_ST_MLUS'
      IMPORTING
        et_alv       = lt_alv.

* Jetzt den eigentlichen Feldkatalog aufbauen
    SORT lt_alv BY posnr.

    LOOP AT lt_alv INTO ls_alv.
      ADD 1 TO lv_count.
      CLEAR ls_fcat.
      ls_fcat-col_pos      = lv_count.
      ls_fcat-fieldname    = ls_alv-fieldname.
      ls_fcat-scrtext_l    = ls_alv-fieldlabel.
      ls_fcat-scrtext_m    = ls_alv-fieldlabel.
      ls_fcat-scrtext_s    = ls_alv-fieldlabel.
      ls_fcat-reptext      = ls_alv-fieldlabel.
      ls_fcat-ref_table    = '/DATRAIN/KC_ST_MLUS'.
      ls_fcat-col_opt      = 'A'.
      ls_fcat-no_out       = ls_alv-no_out.
      ls_fcat-tech         = ls_alv-tech.
      ls_fcat-just         = ls_alv-just.
      ls_fcat-tabname      = '/DATRAIN/KC_ST_MLUS'.
      APPEND ls_fcat TO lt_fcat.
    ENDLOOP.

    IF lt_fcat IS INITIAL.
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name = '/DATRAIN/KC_ST_MLUS'
        CHANGING
          ct_fieldcat      = lt_fcat.
    ENDIF.

    LOOP AT lt_fcat ASSIGNING <fs_fcat>.
      CASE  <fs_fcat>-fieldname.
        WHEN 'SMAIL'
          OR 'L_SEX'
          OR 'IMAIL'
          OR 'FINAL'.
          <fs_fcat>-edit     = 'X'.
          <fs_fcat>-checkbox = 'X'.
        WHEN 'PROFL'.
          <fs_fcat>-edit     = 'X'.
*          <fs_fcat>-f4availabl = 'X'.
*          <fs_fcat>-CHECKTABLE =
        WHEN OTHERS.
*          <fs_fcat>-key      = 'X'.
      ENDCASE.
    ENDLOOP.

    ls_layout-no_toolbar = 'X'.
    ls_layout-cwidth_opt = 'X'.

    CALL METHOD gx_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    CALL METHOD gx_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

    CREATE OBJECT gx_alv_events.
    SET HANDLER gx_alv_events->handle_data_changed FOR gx_alv.

    CALL METHOD gx_alv->set_table_for_first_display
      EXPORTING
        i_structure_name = '/DATRAIN/KC_ST_MLUS'
        is_layout        = ls_layout
      CHANGING
        it_outtab        = gt_mlus
        it_fieldcatalog  = lt_fcat.

    CALL METHOD cl_gui_alv_grid=>set_focus
      EXPORTING
        control           = gx_alv
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.

    CALL METHOD cl_gui_cfw=>flush.

    gv_init_7600 = 'X'.
  ENDIF.


ENDFORM.                    " EDIT_MLUS
*&---------------------------------------------------------------------*
*&      Form  DESTROY_CTRL_9500
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM destroy_ctrl_9500 .
  FREE gx_editor.

*     destroy container
  CALL METHOD gx_ed_control->free
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc <> 0.
  ENDIF.
  FREE gx_ed_control.

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc NE 0.
  ENDIF.

ENDFORM.                    " DESTROY_CTRL_9500
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_9500
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_9500 .
  DATA: lv_fieldname TYPE fieldname,
        lv_msgtxt    TYPE c,
*        lv_partner   TYPE bu_partner,

        ls_detail    TYPE vicaintreno,
        ls_identkeys TYPE /datrain/al_st_vrm_value,
        ls_contracts TYPE /datrain/fl_st_re_contr_pa,
        ls_tiv2f     TYPE tiv2f,

        lt_contracts TYPE /datrain/fl_tt_re_contr_pa,
        lt_tiv2f     TYPE TABLE OF tiv2f,

        lx_fl        TYPE REF TO /datrain/fl_cl_ba_relation.

  FIELD-SYMBOLS:
    <fv_intreno> TYPE any,
    <fv_partner> TYPE any.

  CALL METHOD /datrain/al_cl_read_db=>get_field
    EXPORTING
      iv_appid     = gv_appid
      iv_anwendung = gc_anwendung_2
      iv_fieldid   = 'CN_INTRE'
    IMPORTING
      ev_fieldname = lv_fieldname.

  IF lv_fieldname IS INITIAL.
    MESSAGE e005(/datrain/al) WITH 'CN_INTRE'.
*   Es existiert kein Eintrag zu FeldID &1 in Tabelle /DATRAIN/AL_FIAV
    RETURN.
  ENDIF.

  IF gv_intreno IS INITIAL.
    ASSIGN COMPONENT lv_fieldname OF STRUCTURE gs_viqmel TO <fv_intreno>.
    CHECK <fv_intreno> IS ASSIGNED.
    gv_intreno = <fv_intreno>.               "#EC CI_FLDEXT_OK[2215424]
  ENDIF.

  IF gv_partner IS INITIAL.
    CALL METHOD /datrain/al_cl_read_db=>get_field
      EXPORTING
        iv_appid     = gv_appid
        iv_anwendung = gc_anwendung_2
        iv_fieldid   = 'TENANT'
      IMPORTING
        ev_fieldname = lv_fieldname.

    IF lv_fieldname IS INITIAL.
      MESSAGE e005(/datrain/al) WITH 'TENANT'.
*   Es existiert kein Eintrag zu FeldID &1 in Tabelle /DATRAIN/AL_FIAV
      RETURN.
    ENDIF.

    ASSIGN COMPONENT lv_fieldname OF STRUCTURE gs_viqmel TO <fv_partner>.
    CHECK <fv_partner> IS ASSIGNED.
    gv_partner = <fv_partner>.               "#EC CI_FLDEXT_OK[2215424]
  ENDIF.

  IF NOT gt_identkeys IS INITIAL.
    RETURN.
  ENDIF.

  SELECT * FROM tiv2f APPENDING TABLE lt_tiv2f WHERE spras = sy-langu.

************************************************************************
* KC initialisieren
************************************************************************
  PERFORM init_kc.

************************************************************************
* Führt dazu, dass Docking Container des Kundencenters schon im
* Auswahldynpro Folgemeldung/Meldungskopie auftauchen
************************************************************************
*  CALL METHOD gx_kc->check_av
*    EXPORTING
*      iv_repid = sy-repid
*      iv_dynnr = sy-dynnr.

************************************************************************
* weitere Verträge zum Partner
************************************************************************
  CALL METHOD /datrain/fl_cl_ba_relation=>factory
    EXPORTING
      iv_appid     = gv_appid
      iv_anwendung = gc_anwendung_2
    IMPORTING
      ex_fl        = lx_fl
    CHANGING
      cx_log       = gx_log.

  CALL METHOD lx_fl->get_contracts_to_partner
    EXPORTING
      iv_partner   = gv_partner
    IMPORTING
      et_contracts = lt_contracts.

  LOOP AT lt_contracts INTO ls_contracts.
    CALL METHOD cl_redb_vicaintreno=>get_detail
      EXPORTING
        id_intreno = ls_contracts-intreno
*       if_bypassing_buffer =
*       if_reset_buffer     =
*       id_max_buffer_size  = 1000
      RECEIVING
        rs_detail  = ls_detail
      EXCEPTIONS
        not_found  = 1
        OTHERS     = 2.
    IF sy-subrc = 0.
      READ TABLE lt_tiv2f INTO ls_tiv2f WITH KEY
                                    spras  = sy-langu
                                    smvart = ls_contracts-recntype.
      ls_identkeys-key  = ls_detail-intreno.
      CONCATENATE ls_detail-identkey '(' ls_tiv2f-xkbez ')'
                         INTO ls_identkeys-text SEPARATED BY space.
      APPEND ls_identkeys TO gt_identkeys.
    ENDIF.
  ENDLOOP.

  READ TABLE lt_contracts INTO ls_contracts WITH KEY intreno = gv_intreno.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'GV_INTRENO'
      values = gt_identkeys
    EXCEPTIONS
      OTHERS = 0.

  PERFORM notif_attc_merge.

ENDFORM.                    " GET_DATA_9500
*&---------------------------------------------------------------------*
*&      Form  SET_COPY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_copy_data .
  DATA: lv_fieldname TYPE fieldname.

  FIELD-SYMBOLS:
    <fv_intreno> TYPE any,
    <fv_partner> TYPE any.

  CALL METHOD /datrain/al_cl_read_db=>get_field
    EXPORTING
      iv_appid     = gv_appid
      iv_anwendung = gc_anwendung_2
      iv_fieldid   = 'CN_INTRE'
    IMPORTING
      ev_fieldname = lv_fieldname.

  IF lv_fieldname IS INITIAL.
    MESSAGE e005(/datrain/al) WITH 'CN_INTRE'.
*   Es existiert kein Eintrag zu FeldID &1 in Tabelle /DATRAIN/AL_FIAV
    RETURN.
  ENDIF.

  ASSIGN COMPONENT lv_fieldname OF STRUCTURE gs_viqmel TO <fv_intreno>.
  IF <fv_intreno> IS ASSIGNED.
    <fv_intreno> = gv_intreno.
  ENDIF.

  CALL METHOD /datrain/al_cl_read_db=>get_field
    EXPORTING
      iv_appid     = gv_appid
      iv_anwendung = gc_anwendung_2
      iv_fieldid   = 'TENANT'
    IMPORTING
      ev_fieldname = lv_fieldname.

  IF lv_fieldname IS INITIAL.
    MESSAGE e005(/datrain/al) WITH 'TENANT'.
*   Es existiert kein Eintrag zu FeldID &1 in Tabelle /DATRAIN/AL_FIAV
    RETURN.
  ENDIF.

  ASSIGN COMPONENT lv_fieldname OF STRUCTURE gs_viqmel TO <fv_partner>.
  IF <fv_partner> IS ASSIGNED.
    <fv_partner> = gv_partner.
  ENDIF.


  IF NOT gv_intreno IS INITIAL.
    SELECT SINGLE bukrs recnnr FROM vicncn
          INTO (gx_kc->s_partner-bukrs , gx_kc->s_partner-recnnr)
      WHERE intreno = gv_intreno.

    CALL METHOD gx_kc->read_recnnr
      EXPORTING
        is_zuordnung      = gx_kc->s_zuordnung
      CHANGING
        cs_zusatz         = gx_kc->s_zusatz
        cs_partner        = gx_kc->s_partner
        cs_search_partner = gx_kc->s_search_partner.

    gs_viqmel-tplnr = gx_kc->s_zusatz-tplnr.

    CALL METHOD gx_log->refresh_return.

  ENDIF.

*  IF NOT gv_tplnr IS INITIAL.
*    gs_viqmel-tplnr = gv_tplnr.
*  ENDIF.

ENDFORM.                    " SET_COPY_DATA
