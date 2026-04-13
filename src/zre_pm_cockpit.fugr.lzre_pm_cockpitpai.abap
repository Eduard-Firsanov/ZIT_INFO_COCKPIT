*----------------------------------------------------------------------*
***INCLUDE /DATRAIN/LKC_MAINPAI .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  exit_command_1000  INPUT
*&---------------------------------------------------------------------*
MODULE exit_command_1000 INPUT.
  CASE gv_save_code.
    WHEN 'BEEN'.
      CALL METHOD gx_kc->exit_kc.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT'.
      CALL METHOD gx_kc->exit_kc.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                 " exit_command_1000  INPUT
*&---------------------------------------------------------------------*
*&      Module  pre_command_1000  INPUT
*&---------------------------------------------------------------------*
MODULE pre_command_1000 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.
  CLEAR gv_sub_code.
  CLEAR gv_feld.
  IF gv_save_code <> 'ERROR'.
    CALL METHOD gx_log->refresh_return.
  ENDIF.
  CLEAR gv_line.
ENDMODULE.                 " pre_command_1000  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1000 INPUT.
***********************************************************************
** OLUEDERS 20180516
**   Korrespondenzvorfälle sollen auch bei Folgebelege angelegt werden
**   hierzu muss der Aufruf des Korrespndenzvorfalls und der Meldungs-
**   abschluss nach dem FuBa-Aufruf Online erfolgen, Hierzu wird der
**   neue OKCode MELD_RFC2 genutzt
***********************************************************************
  DATA:
    lv_clear TYPE flag,
    lv_tree  TYPE flag.
  IF gv_save_code(4) = 'ACBX'.
    gv_acbx_okcode = gv_save_code.
    gv_save_code   = 'ACBX'.
  ENDIF.
  CASE gv_sub_code.
    WHEN 'CLR_PART'.
*     Löschen der Partnerdaten
      CALL METHOD gx_kc->clear_partner
        CHANGING
          cs_search_partner = gx_kc->s_search_partner
          cs_partner        = gx_kc->s_partner
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.

    WHEN OTHERS.

  ENDCASE.


  CALL BADI gx_scr_exit->get_data_from_screen
    CHANGING
      cs_partner        = gx_kc->s_partner
      cs_zuordnung      = gx_kc->s_zuordnung
      cs_zusatz         = gx_kc->s_zusatz
      cs_search_partner = gx_kc->s_search_partner
    EXCEPTIONS
      reserved          = 01.

* neuer Technischer Platz
  IF gv_new_tplnr = 'X'.
    IF gx_kc->s_settings-new_partner IS INITIAL.
* Bei Bestandskunden TP-Daten inkl. Partnersuche
      CALL METHOD gx_kc->read_tplnr
        EXPORTING
          is_zuordnung      = gx_kc->s_zuordnung
        CHANGING
          cs_zusatz         = gx_kc->s_zusatz
          cs_partner        = gx_kc->s_partner
          cs_search_partner = gx_kc->s_search_partner.
    ELSE.
* Bei Bestandskunden TP-Daten ohne Partnersuche
      CALL METHOD gx_kc->read_tplnr_simple
        EXPORTING
          is_zuordnung = gx_kc->s_zuordnung
        CHANGING
          cs_zusatz    = gx_kc->s_zusatz.
    ENDIF.
    CLEAR gv_new_tplnr.
  ENDIF.


  IF gv_new_recnnr = 'X'.
    CALL METHOD gx_kc->read_recnnr
      EXPORTING
        is_zuordnung      = gx_kc->s_zuordnung
      CHANGING
        cs_zusatz         = gx_kc->s_zusatz
        cs_partner        = gx_kc->s_partner
        cs_search_partner = gx_kc->s_search_partner.
    CLEAR gv_new_recnnr.
  ENDIF.
  IF gv_new_partner = 'X'.
    CALL METHOD gx_kc->read_partner( ).
    CLEAR gv_new_partner.
  ENDIF.

  IF gv_new_code = 'X'.


    CALL METHOD gx_kc->new_f4code
      EXPORTING
        iv_new_code  = gv_new_code
      CHANGING
        cs_zusatz    = gx_kc->s_zusatz
        cs_zuordnung = gx_kc->s_zuordnung.
    gv_feld = 'GX_KC->S_ZUSATZ-MNGRP'.
    CLEAR gv_new_code.
  ENDIF.


  CASE gv_save_code.
    WHEN 'BACK'.
*     "Zurück"-Navigation (F3)
      CALL METHOD gx_kc->exit_kc.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'BEEN'.
*     " Beenden (Shft F3)
      CALL METHOD gx_kc->exit_kc.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT'.
*     Abbrechen (12)
      CALL METHOD gx_kc->exit_kc.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'QMAR'.
*     Neue Meldungsart (Radiobutton)
      CALL METHOD gx_kc->set_notif_type
        CHANGING
          cs_zuordnung = gx_kc->s_zuordnung
          cs_zusatz    = gx_kc->s_zusatz.

    WHEN 'SUCH'.
*     evtl. Meldungen vom Löschen der Daten löschgen
      CALL METHOD gx_log->refresh_return.
*     Partnersuche
      CALL METHOD gx_kc->search_partner
        IMPORTING
          es_partner        = gx_kc->s_partner
        CHANGING
          cs_search_partner = gx_kc->s_search_partner
          cs_zusatz         = gx_kc->s_zusatz
          cs_zuordnung      = gx_kc->s_zuordnung.
      IF gx_kc->s_partner-partner IS NOT INITIAL.
        gv_feld = 'GX_KC->S_ZUSATZ-MNGRP'.
      ENDIF.
    WHEN 'CNTF'.
*     Ändern der Meldung
      CALL METHOD gx_kc->edit_notification
        EXPORTING
          iv_qmnum = gv_qmnum.

    WHEN 'MVAN'.
*     Anzeige des MIetcontracts
      CALL METHOD gx_kc->show_contract
        EXPORTING
          iv_bukrs  = gx_kc->s_partner-bukrs
          iv_recnnr = gx_kc->s_partner-recnnr
          iv_objnr  = gx_kc->s_partner-objnr.
    WHEN 'MVCG'.
*     Ändern des MIetkontrakts
      CALL METHOD gx_kc->change_contract
        EXPORTING
          iv_bukrs  = gx_kc->s_partner-bukrs
          iv_recnnr = gx_kc->s_partner-recnnr
          iv_objnr  = gx_kc->s_partner-objnr.
    WHEN 'MIAU'.
*
      CALL METHOD gx_kc->partner_report
        EXPORTING
          is_partner = gx_kc->s_partner.
    WHEN 'LST_PAR'.
*     Historie zum Partner
      CALL METHOD gx_kc->list_partner_hist
        EXPORTING
          is_partner = gx_kc->s_partner.
    WHEN 'PART'.
*     Kommunikationsdaten zum Partner
      CALL METHOD gx_kc->change_comm_data
        CHANGING
          cs_partner = gx_kc->s_partner.
    WHEN 'LST_VOR'.
*     Historie zum Techn. Platz
      CALL METHOD gx_kc->list_tplnr_hist
        EXPORTING
          iv_tplnr = gx_kc->s_zusatz-tplnr.

    WHEN 'PRED'.
      CALL METHOD gx_log->refresh_return.
*     untergeordnete techn. PLätze
      CALL METHOD gx_kc->get_lower_hier
        EXPORTING
          is_zuordnung      = gx_kc->s_zuordnung
        CHANGING
          cs_zusatz         = gx_kc->s_zusatz
          cs_partner        = gx_kc->s_partner
          cs_search_partner = gx_kc->s_search_partner.
    WHEN 'IHHL'.
      CALL METHOD gx_log->refresh_return.
*     übergeordnete techn. Plätze
      CALL METHOD gx_kc->get_upper_hier
        EXPORTING
          is_zuordnung      = gx_kc->s_zuordnung
        CHANGING
          cs_zusatz         = gx_kc->s_zusatz
          cs_partner        = gx_kc->s_partner
          cs_search_partner = gx_kc->s_search_partner.
    WHEN 'MELD'.

      " E.Firsanov Set Zusatzinformation für Info-Email          " EF CH2411-0044
      gs_info_context_zusatz-s_zusatz = gx_kc->s_zusatz.         " EF CH2411-0044
      gs_info_context_zusatz-s_partner = gx_kc->s_partner.       " EF CH2411-0044
      gs_info_context_zusatz-s_recn = CORRESPONDING #( gs_recn )." EF CH2411-0044

*     Anlegen der Meldung
      CLEAR gv_new_qmnum.
      CALL METHOD gx_kc->create_notif
        EXPORTING
          is_partner        = gx_kc->s_partner
          is_search_partner = gx_kc->s_search_partner
        IMPORTING
          ev_qmnum          = gv_new_qmnum
        CHANGING
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.
      IF gx_kc->s_partner-partner IS NOT INITIAL.
        gv_feld = 'GV_QMNUM'.
      ENDIF.
      CALL METHOD gx_kc->save_log
        EXPORTING
          iv_progid = 'KC_CN'.

      gs_info_context_zusatz-new_qmnum = gv_new_qmnum.           " EF CH2411-0044
      DELETE FROM ztmp_sendeemail.                               " EF CH2411-0044
      DATA ls_tmp_sendeemail TYPE ztmp_sendeemail.               " EF CH2411-0044
      ls_tmp_sendeemail-qmnum = gv_new_qmnum.                    " EF CH2411-0044
      ls_tmp_sendeemail-sende_email = abap_false.                " EF CH2411-0044
      INSERT ztmp_sendeemail FROM ls_tmp_sendeemail.             " EF CH2411-0044
    WHEN 'MELD_RFC'.
*     Anlegen der Meldung
      CLEAR gv_new_qmnum.
      CALL METHOD gx_kc->create_notif_background
        EXPORTING
          is_partner        = gx_kc->s_partner
          is_search_partner = gx_kc->s_search_partner
        IMPORTING
          ev_qmnum          = gv_new_qmnum
        CHANGING
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.

      IF gx_kc->s_partner-partner IS NOT INITIAL.
        gv_feld = 'GV_QMNUM'.
      ENDIF.
* INS OLUEDERS 20180516
    WHEN 'MELD_RFC2'.
*     Anlegen der Meldung
      CLEAR gv_new_qmnum.
      CALL METHOD gx_kc->create_notif_background_2
        EXPORTING
          is_partner        = gx_kc->s_partner
          is_search_partner = gx_kc->s_search_partner
        IMPORTING
          ev_qmnum          = gv_new_qmnum
        CHANGING
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.

      IF gx_kc->s_partner-partner IS NOT INITIAL.
        gv_feld = 'GV_QMNUM'.
      ENDIF.
* END INS OLUEDERS 20180516
    WHEN 'YMB1'.
*     Mietkontenblatt anzeigen
      CALL METHOD gx_kc->get_mietkontenblatt
        EXPORTING
          is_partner = gx_kc->s_partner
          is_zusatz  = gx_kc->s_zusatz.
    WHEN 'CLR_DATA'.
*     Löschen der Daten
      CALL METHOD gx_kc->clear_global_data
        CHANGING
          cs_search_partner = gx_kc->s_search_partner
          cs_partner        = gx_kc->s_partner
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.
      gv_feld = 'GX_KC->S_SEARCH_PARTNER-NAME_LAST'.
      REFRESH: gt_clerk, gt_occupancy, gt_wartung, gt_wartung_geb, gt_wartung_we,
               gt_charact, gt_charact_ro, gt_charact_be, gt_ro, gt_kessel, gt_notdienst,
               gt_bestellung.
      CLEAR: gs_recn, gs_heizung_dialog, gd_tp_txt.
      IF go_alv_clerk IS BOUND.
        go_alv_clerk->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_occupancy IS BOUND.
        go_alv_occupancy->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_wartung IS BOUND.
        go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_wartung_geb IS BOUND.
        go_alv_wartung_geb->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_charact IS BOUND.
        go_alv_charact->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_charact_ro IS BOUND.
        go_alv_charact_ro->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_charact_we IS BOUND.
        go_alv_charact_we->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_ro IS BOUND.
        go_alv_ro->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_kessel IS BOUND.
        go_alv_kessel->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_bestellung IS BOUND.
        go_alv_bestellung->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_wartung_geb IS BOUND.
        go_alv_wartung_geb->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_wartung_we IS BOUND.
        go_alv_wartung_we->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.
      IF go_alv_notdienst IS BOUND.
        go_alv_notdienst->refresh( refresh_mode =  if_salv_c_refresh=>full ).
      ENDIF.

    WHEN 'LST_PART'.
*     Lesen der Partner zum Technischen Platz
      CALL METHOD gx_kc->list_tp_partner
        EXPORTING
          is_zusatz = gx_kc->s_zusatz.
    WHEN 'F4CODE'.
*     Codierungssuche
*      CLEAR gv_feld.
      gv_feld = 'GX_KC->S_ZUSATZ-MNGRP'.
      CLEAR lv_clear.
      CALL METHOD gx_kc->f4_coding
        EXPORTING
          iv_repid       = sy-repid
          iv_dynnr       = sy-dynnr
        IMPORTING
          ev_clear_gfeld = lv_clear
          ev_tree        = lv_tree
        CHANGING
          cs_zusatz      = gx_kc->s_zusatz
          cs_zuordnung   = gx_kc->s_zuordnung.
      IF lv_tree = 'X'.
        gv_feld = 'CODE_TREE'.
      ENDIF.
    WHEN 'COMP_SHW'.
      IF sy-uname = 'JBECKMANN'.                            "#EC *
        CALL FUNCTION '/DATRAIN/TD_BE_SHOW_STPO'
          EXPORTING
            iv_trtyp    = 'V'
*           IS_STPO     =
            iv_popup    = 'X'
            iv_deviceid = gx_kc->s_zusatz-deviceid.

      ELSE.
        CLEAR gx_td_cont.
        CALL SCREEN '7200' STARTING AT 1 1.
      ENDIF.
    WHEN 'PRUS'.
      CALL METHOD gx_kc->maint_userdata.
    WHEN 'MLUS'.
      CALL METHOD gx_kc->maint_maildata.
    WHEN 'ACBX'.
      CALL METHOD gx_kc->actionbox
        EXPORTING
          iv_ucomm = gv_acbx_okcode.
    WHEN 'PAR_PART'.
      IF gx_kc->s_search_partner-fl_miet = 'X'
                OR gx_kc->s_search_partner-fl_eige = 'X'.
        CLEAR: gx_kc->s_search_partner-fl_alle.
      ENDIF.
    WHEN 'ALL_PART'.
      IF gx_kc->s_search_partner-fl_alle = 'X'.
        CLEAR: gx_kc->s_search_partner-fl_miet,
               gx_kc->s_search_partner-fl_eige .
      ENDIF.
    WHEN 'NEW_PART'.
      CALL METHOD gx_kc->new_partner.
    WHEN 'AV_POPUP'.
*     Arbeitsvorrat wieder in Trefferliste stellen
      CALL METHOD gx_kc->show_av_again.
    WHEN 'AV_CREA_NO'.
*     Meldungsanlage für markierte Zeilen aus AV
      CALL METHOD gx_kc->create_av_notif.

    WHEN 'SHOW_AV'.
*     AVcontainer ab-/anschalten
      CALL METHOD gx_kc->toggle_display.
    WHEN 'SHOW_HIST'.
*     Historiencontainer ab-/anschalten
      CALL METHOD gx_kc->toggle_display_hist.
    WHEN 'CHLP'.
* Langtext zur Codierung anzeigen
      CALL METHOD gx_kc->show_cd_ltxt.

    WHEN '9100_LTEXT'.
*      GET CURSOR LINE gv_line.
      gv_act_line = gv_line + gx_9100-top_line - 1.
      CALL METHOD gx_kc->ltext_add_fields
        EXPORTING
          iv_act_line = gv_act_line.

    WHEN '9100_F4FIELD'.
*      GET CURSOR LINE gv_line.
      gv_act_line = gv_line + gx_9100-top_line - 1.
      CALL METHOD gx_kc->f4_add_fields
        EXPORTING
          iv_act_line = gv_act_line.
    WHEN 'ASSIGN_PARTNER'.
      CALL METHOD gx_kc->assign_new_partner.

    WHEN OTHERS.

  ENDCASE.

* Dynamische Buttons
  IF gv_save_code(7) EQ 'ADD_BTN'.
    CALL METHOD gx_kc->handle_add_btn
      EXPORTING
        iv_fcode          = gv_save_code
      CHANGING
        cs_search_partner = gx_kc->s_search_partner
        cs_zusatz         = gx_kc->s_zusatz
        cs_zuordnung      = gx_kc->s_zuordnung
        cs_partner        = gx_kc->s_partner
        cs_screens        = gx_kc->s_screens.

  ENDIF.

  IF gx_log->errors IS INITIAL.


    CALL METHOD gx_kc->closing_operation
      CHANGING
        cs_zusatz    = gx_kc->s_zusatz
        cs_partner   = gx_kc->s_partner
        cs_zuordnung = gx_kc->s_zuordnung.
  ENDIF.


  CALL METHOD gx_kc->check_change.


ENDMODULE.                 " USER_COMMAND_1000  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_3000 INPUT.

  IF gv_feld IS INITIAL.
    GET CURSOR FIELD gv_feld.
  ENDIF.

  CASE gv_save_code.
    WHEN 'PICK'.
      CASE gv_feld.
        WHEN 'GX_KC->S_PARTNER-PARTNER'.
          CALL METHOD gx_kc->pick_partner
            EXPORTING
              iv_partner = gx_kc->s_partner-partner.
        WHEN 'GX_KC->S_PARTNER-RECNNR'.
          IF gx_kc->s_partner-recnnr IS INITIAL
                  OR gx_kc->s_partner-bukrs IS INITIAL.
            EXIT.
          ENDIF.
          SELECT objnr FROM vicncn INTO gv_objnr
                                  UP TO 1 ROWS
                            WHERE bukrs  = gx_kc->s_partner-bukrs
                              AND recnnr = gx_kc->s_partner-recnnr.
          ENDSELECT.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
*     Mietvertrag anzeigen
          CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
            EXPORTING
              id_activity          = '03'
*             ID_OBJTYPE           =
*             ID_INTRENO           =
              id_objnr             = gv_objnr
*             IF_LEAVE_CURRENT     = ABAP_FALSE
*             IF_NEW_EXTERNAL_MODE = 'X'
              if_new_internal_mode = 'X'
*             IS_NAVIGATION_DATA   =
            EXCEPTIONS
              error                = 0
              OTHERS               = 0.
        WHEN OTHERS.

      ENDCASE.

    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_3000  INPUT

*&---------------------------------------------------------------------*
*&      Module  read_tpname  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE read_tpname INPUT.
  gv_new_tplnr = 'X'.


ENDMODULE.                 " read_tpname  INPUT
*&---------------------------------------------------------------------*
*&      Module  f4_code  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_code INPUT.
  PERFORM f4_code.


ENDMODULE.                 " f4_code  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_5000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_5000 INPUT.
  DATA: ls_viqmel TYPE viqmel,
        ld_prctr  LIKE  aufk-prctr.
  IF gv_feld IS INITIAL.
    GET CURSOR FIELD gv_feld.
  ENDIF.

  CASE gv_save_code.
    WHEN 'PICK'.
      GET CURSOR FIELD gv_feld.
      CASE gv_feld.
        WHEN 'GX_KC->S_ZUSATZ-TPLNR'.
          CALL METHOD gx_kc->pick_tplnr
            EXPORTING
              iv_tplnr = gx_kc->s_zusatz-tplnr.
        WHEN 'GX_KC->S_ZUSATZ-EQUNR'.
          CALL METHOD gx_kc->pick_equnr
            EXPORTING
              iv_equnr = gx_kc->s_zusatz-equnr.
        WHEN 'GV_QMNUM'.
*         Ändern der Meldung
          CALL METHOD gx_kc->edit_notification
            EXPORTING
              iv_qmnum = gv_qmnum.


          " E.Firsanov " EF CH2411-0044 Erweiterung ZRE_PM_COCKPIT Notdienstportal Lubitz
          " nach dem die PM-Meldung angelegt ist wird eine Info-Email an zuständigen Geschäftspartner verschickt.
          DATA et_status_x TYPE re_t_status_x.                                " EF CH2411-0044

*
          SELECT sende_email FROM ztmp_sendeemail                             " EF CH2411-0044
            WHERE qmnum = @gs_info_context_zusatz-new_qmnum                   " EF CH2411-0044
            INTO @DATA(ld_sende_email) UP TO 1 ROWS.                          " EF CH2411-0044
          ENDSELECT.                                                          " EF CH2411-0044

          IF ld_sende_email = abap_true AND                                   " EF CH2411-0044
             zst_info_context-INFOMAIL = abap_true.                           " EF IN2508-0344
            zcl_infocockpit_services=>sende_info_email(                       " EF CH2411-0044
              EXPORTING                                                       " EF CH2411-0044
                is_info_context   = zst_info_context                          " EF CH2411-0044
                is_info_zusatz    = gs_info_context_zusatz                    " EF CH2411-0044
                if_in_update_task = abap_true                                 " EF CH2411-0044
              EXCEPTIONS                                                      " EF CH2411-0044
                error             = 1                                         " EF CH2411-0044
                OTHERS            = 2                                         " EF CH2411-0044
                   ).                                                         " EF CH2411-0044
            IF sy-subrc <> 0.                                                 " EF CH2411-0044
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno               " EF CH2411-0044
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.   " EF CH2411-0044
            ELSE.                                                             " EF CH2411-0044
              MESSAGE |Info Mail ist erfolgreich gesendet.| TYPE 'I'.         " EF CH2411-0044
            ENDIF.                                                            " EF CH2411-0044
            " Info Mail Content löschen
            CLEAR: zst_info_context, gs_info_context_zusatz.                  " EF CH2411-0044
            DELETE FROM ztmp_sendeemail.                                      " EF CH2411-0044
          ENDIF.                                                              " EF CH2411-0044
        WHEN OTHERS.

      ENDCASE.
    WHEN 'CHANGE_TP'.
      IF gx_kc->s_zusatz-tplnr =  gd_objnr_tpl_bu.
        gx_kc->s_zusatz-tplnr =  gd_objnr_tpl_ro.
        gd_tp_txt = 'Mietobj:'.
      ELSE.
        gx_kc->s_zusatz-tplnr =  gd_objnr_tpl_bu.
        gd_tp_txt = 'Gebäude:'.
      ENDIF.

    WHEN 'PUSH_HW'.
* Handwertker aufrufen
      MOVE-CORRESPONDING gx_kc->s_zusatz TO ls_viqmel.
      ls_viqmel-qmgrp = gx_kc->s_zusatz-mngrp.
      ls_viqmel-qmcod = gx_kc->s_zusatz-mncod.
      ld_prctr = gs_recn-kdst.
      CALL FUNCTION 'Z_PM_HANDWERKERAUSWAHL'
        EXPORTING
          viqmel_imp  = ls_viqmel
          gewerk_imp  = ls_viqmel-zzmat
          prctr_imp   = ld_prctr
          id_activity = reca1_activity-change
        IMPORTING
          lifnr_exp   = gx_kc->s_zusatz-lifnr
          hwk_exp     = ls_viqmel-zzhwk
        EXCEPTIONS
          not_found   = 1
          OTHERS      = 2.
      IF sy-subrc <> 0.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                    "USER_COMMAND_5000 INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_6000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_6000 INPUT.

  IF gv_feld IS INITIAL.
    GET CURSOR FIELD gv_feld.
  ENDIF.

* Lesen des Textes aus dem Editor
  CALL METHOD gx_editor->get_text_as_r3table
    IMPORTING
      table                  = gx_kc->s_zusatz-t_ltext
    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      error_dp_create        = 3
      potential_data_loss    = 4
      OTHERS                 = 5.
  IF sy-subrc <> 0.                                         "#EC NEEDED

  ENDIF.
ENDMODULE.                 " USER_COMMAND_6000  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_8000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_8000 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.

  CASE gv_save_code.
    WHEN 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'UEBER'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'VERW'.
      gs_comm_data_new = gs_comm_data_old.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_8000  INPUT
*&---------------------------------------------------------------------*
*&      Module  clear_partner  INPUT
*&---------------------------------------------------------------------*
MODULE clear_partner INPUT.
  gv_sub_code = 'CLR_PART'.

ENDMODULE.                 " clear_partner  INPUT
*&---------------------------------------------------------------------*
*&      Module  new_idnrk  INPUT
*&---------------------------------------------------------------------*
MODULE new_idnrk INPUT.
  CLEAR: gx_kc->s_zusatz-maktx.
  SELECT SINGLE maktx FROM makt INTO gx_kc->s_zusatz-maktx
                    WHERE matnr  = gx_kc->s_zusatz-idnrk
                      AND spras  = sy-langu.

ENDMODULE.                 " new_idnrk  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

  IF gv_feld IS INITIAL.
    GET CURSOR FIELD gv_feld.
  ENDIF.
  CASE gv_save_code.
    WHEN 'ENTE'.
      IF gv_feld(23) = 'GX_KC->S_SEARCH_PARTNER'.
        gv_save_code = 'SUCH'.
      ENDIF.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_4000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_4000 INPUT.

  IF gv_feld IS INITIAL.
    GET CURSOR FIELD gv_feld.
  ENDIF.
  CALL METHOD gx_kc->check_resp.
ENDMODULE.                 " USER_COMMAND_4000  INPUT
*&---------------------------------------------------------------------*
*&      Module  NEW_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE new_code INPUT.
  gv_new_code = 'X'.
ENDMODULE.                " NEW_CODE  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_7200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_7200 INPUT.
  gv_save_code = gv_td_code.
  CLEAR gv_td_code.

  CASE gv_save_code.
    WHEN 'ENTE'.
      CALL METHOD gx_td_cont->free
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2
          OTHERS            = 3.
      IF sy-subrc <> 0.                                     "#EC NEEDED
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      CLEAR gx_td_cont.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_7200  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_WB_MANAGER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_wb_manager INPUT.
  DATA:
    lv_okcode     TYPE syucomm,
    lx_wb_request TYPE REF TO cl_reca_wb_request.

  lv_okcode = gv_ok_code.
  CALL METHOD cl_reca_wb_manager=>manager_pai
    IMPORTING
      eo_wb_request = lx_wb_request
    CHANGING
      cd_okcode     = lv_okcode
    EXCEPTIONS
      error         = 1
      OTHERS        = 2.
* handle a possible exit request
  IF ( lx_wb_request               IS BOUND              ) AND
     ( lx_wb_request->md_operation = recaw_operation-end ).
    SET SCREEN 0.
    LEAVE SCREEN.
  ELSE.
    CASE lv_okcode.
*     -------------------------------------------------- CANCEL pressed
      WHEN recaw_fcode-cancel.
*       cancel -> navigate BACK
        CLEAR lv_okcode.
        CALL METHOD cl_reca_wb_manager=>navigate_back
          IMPORTING
            eo_todo_request = lx_wb_request
          EXCEPTIONS
            not_possible    = 1
            OTHERS          = 2.
        IF sy-subrc <> 0.
*          mac_symsg_send_as_type 'S'.
        ELSEIF ( lx_wb_request               IS BOUND           ) AND
               ( lx_wb_request->md_operation = recaw_operation-end ).
          SET SCREEN 0.
          LEAVE SCREEN.
        ENDIF.
    ENDCASE.
  ENDIF.
ENDMODULE.                 " PAI_WB_MANAGER  INPUT
*&---------------------------------------------------------------------*
*&      Module  NEW_RECNNR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE new_recnnr INPUT.
  gv_new_recnnr = 'X'.
ENDMODULE.                 " NEW_RECNNR  INPUT
*&---------------------------------------------------------------------*
*&      Module  NEW_PARTNER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE new_partner INPUT.
  gv_new_partner = 'X'.
ENDMODULE.                 " NEW_PARTNER  INPUT
*&---------------------------------------------------------------------*
*&      Module  F4_RECNCN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_recncn INPUT.


  CLEAR: lt_selops, lt_ret_tab.
  IF gx_kc->s_settings-classic = 'X'.
    ls_selops-shlpname  = 'MRTA'.
    ls_selops-shlpfield = 'SMIVE'.
  ELSE.
    ls_selops-shlpname  = 'RECNCN'.
    ls_selops-shlpfield = 'RECNNR'.
  ENDIF.
  ls_selops-sign      = 'I'.
  CALL FUNCTION 'SWD_DYNPRO_FIELD_GET'
    EXPORTING
      struc = 'GX_KC->S_PARTNER'
      field = 'RECNNR'
*     INDEX =
      repid = sy-repid
      dynnr = '3000'
    IMPORTING
      value = ls_selops-low.
  IF ls_selops-low IS NOT INITIAL.
    IF ls_selops-low CA '+*'.
      ls_selops-option    = 'CP'.
    ELSE.
      ls_selops-option    = 'EQ'.
    ENDIF.
    APPEND ls_selops TO lt_selops.
  ENDIF.


  IF gx_kc->s_settings-classic = 'X'.
    ls_selops-shlpname  = 'MRTA'.
  ELSE.
    ls_selops-shlpname  = 'RECNCN'.
  ENDIF.
  ls_selops-shlpfield = 'BUKRS'.
  ls_selops-sign      = 'I'.
  ls_selops-option    = 'EQ'.
  CALL FUNCTION 'SWD_DYNPRO_FIELD_GET'
    EXPORTING
      struc = 'GX_KC->S_PARTNER'
      field = 'BUKRS'
*     INDEX =
      repid = sy-repid
      dynnr = '3000'
    IMPORTING
      value = ls_selops-low.
  IF ls_selops-low IS NOT INITIAL.
    IF ls_selops-low CA '+*'.
      ls_selops-option    = 'CP'.
    ELSE.
      ls_selops-option    = 'EQ'.
    ENDIF.
    APPEND ls_selops TO lt_selops.
  ENDIF.


  IF gx_kc->s_settings-classic = 'X'.
    CALL FUNCTION 'F4_FIELD_ON_VALUE_REQUEST'
      EXPORTING
        tabname           = '/DATRAIN/KC_ST_PARTNER_08'
        fieldname         = 'RECNNR'
        searchhelp        = 'MRTA'
*       SHLPPARAM         = ' '
*       DYNPPROG          = ' '
*       DYNPNR            = ' '
*       DYNPROFIELD       = ' '
*       STEPL             = 0
*       VALUE             = ' '
*       MULTIPLE_CHOICE   = ' '
*       DISPLAY           = ' '
*       SUPPRESS_RECORDLIST = ' '
*       CALLBACK_PROGRAM  = ' '
*       CALLBACK_FORM     = ' '
*       SELECTION_SCREEN  = ' '
        callback_selopt   = lt_selops
      TABLES
        return_tab        = lt_ret_tab
      EXCEPTIONS
        field_not_found   = 1
        no_help_for_field = 2
        inconsistent_help = 3
        no_values_found   = 4
        OTHERS            = 5.
  ELSE.
    CALL FUNCTION 'F4_FIELD_ON_VALUE_REQUEST'
      EXPORTING
        tabname           = '/DATRAIN/KC_ST_PARTNER_08'
        fieldname         = 'RECNNR'
*       SEARCHHELP        = ' '
*       SHLPPARAM         = ' '
*       DYNPPROG          = ' '
*       DYNPNR            = ' '
*       DYNPROFIELD       = ' '
*       STEPL             = 0
*       VALUE             = ' '
*       MULTIPLE_CHOICE   = ' '
*       DISPLAY           = ' '
*       SUPPRESS_RECORDLIST = ' '
*       CALLBACK_PROGRAM  = ' '
*       CALLBACK_FORM     = ' '
*       SELECTION_SCREEN  = ' '
        callback_selopt   = lt_selops
      TABLES
        return_tab        = lt_ret_tab
      EXCEPTIONS
        field_not_found   = 1
        no_help_for_field = 2
        inconsistent_help = 3
        no_values_found   = 4
        OTHERS            = 5.
  ENDIF.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    READ TABLE lt_ret_tab INTO ls_ret_tab
                            WITH KEY fieldname = 'BUKRS'.
    IF sy-subrc = 0.
      gx_kc->s_partner-bukrs = ls_ret_tab-fieldval.
    ENDIF.
    IF gx_kc->s_settings-classic = 'X'.
      READ TABLE lt_ret_tab INTO ls_ret_tab
                            WITH KEY fieldname = 'SMIVE'.
    ELSE.
      READ TABLE lt_ret_tab INTO ls_ret_tab
                            WITH KEY fieldname = 'RECNNR'.
    ENDIF.
    IF sy-subrc = 0.
      gx_kc->s_partner-recnnr = ls_ret_tab-fieldval.
    ENDIF.
    CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
      EXPORTING
        struc = 'GX_KC->S_PARTNER'
        field = 'RECNNR'
*       INDEX =
        value = gx_kc->s_partner-recnnr.

    CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
      EXPORTING
        struc = 'GX_KC->S_PARTNER'
        field = 'BUKRS'
*       INDEX =
        value = gx_kc->s_partner-bukrs.
    CALL FUNCTION 'SWD_DYNPRO_FIELDS_SEND'
      EXPORTING
        repid = '/DATRAIN/SAPLKC_MAIN_2008'
        dynnr = '3600'.
  ENDIF.



ENDMODULE.                 " F4_RECNCN  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_1010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_1010 INPUT.
  IF gv_act_okcode EQ 'MELD'.
    IF gx_log->errors NE 'X'.
      gv_booked = 'X'.
      SET SCREEN 0.
      LEAVE SCREEN.
    ELSE.
* bei Fehlern, Meldungen ausgeben
      PERFORM show_log.
    ENDIF.
  ELSEIF gv_act_okcode EQ 'EXIT'.
    SET SCREEN 0.
    LEAVE SCREEN.
  ELSE.
* Meldungen ausgeben
    PERFORM show_log.
  ENDIF.
ENDMODULE.                 " PAI_1010  INPUT
*&---------------------------------------------------------------------*
*&      Module  PRE_COMMAND_1010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pre_command_1010 INPUT.
  gv_act_okcode = gv_ok_code.
  IF gv_ok_code = 'MELD'.
    gv_ok_code = 'MELD_RFC'.
  ENDIF.
ENDMODULE.                 " PRE_COMMAND_1010  INPUT
*&---------------------------------------------------------------------*
*&      Module  PRE_COMMAND_1092  INPUT
*&---------------------------------------------------------------------*
*       OLUEDERS 20180516
*       Meldungsanlage soll in separater LUW erfolgen, allerdings
*       muss hierfür die Korrespondenz und der Abschluss ausgelagert
*       werden
*----------------------------------------------------------------------*
MODULE pre_command_1092 INPUT.
  gv_act_okcode = gv_ok_code.
  IF gv_ok_code = 'MELD'.
    gv_ok_code = 'MELD_RFC2'.
  ENDIF.
ENDMODULE.                 " PRE_COMMAND_1010  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_1000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_1000 INPUT.
  PERFORM show_log.
ENDMODULE.                 " PAI_1000  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_7500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_7500 INPUT.
  CASE gv_save_code.
    WHEN 'EXIT'.
      gv_exit = 'X'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OKAY'.
      PERFORM set_partner.
*      MOVE-CORRESPONDING gx_kc->s_partner TO gx_kc->s_search_partner.

      CALL METHOD gx_kc->switch_kc_partner_type
        IMPORTING
          es_screens = gx_kc->s_screens.

      gv_exit = 'X'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OKA2'.
      PERFORM set_partner.
*      MOVE-CORRESPONDING gx_kc->s_partner TO gx_kc->s_search_partner.

      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'NEW_PARTN'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'TAKE'.
      SET SCREEN 0.
      LEAVE SCREEN.

    WHEN OTHERS.

  ENDCASE.

ENDMODULE.                 " PAI_7500  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHANGE_ARBPL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE change_arbpl INPUT.
*  break olueders.
ENDMODULE.                 " CHANGE_ARBPL  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.

  CASE gv_save_code.
    WHEN 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'ENTE'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  MODIFY_ADD_ROW  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_add_row INPUT.
  IF gs_field_value_scr-replaced IS INITIAL.
    gs_field_value_scr-fieldvalue = gs_field_value_scr-fieldscr.
  ENDIF.
  MODIFY gx_kc->t_field_value_scr FROM gs_field_value_scr
                      INDEX gx_9100-current_line.
ENDMODULE.                 " MODIFY_ADD_ROW  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9100 INPUT.
  CASE gv_save_code.
    WHEN '9100_LTEXT'.
      GET CURSOR LINE gv_line.
    WHEN '9100_F4FIELD'.
      GET CURSOR LINE gv_line.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9100  INPUT
*&---------------------------------------------------------------------*
*&      Module  F4_ARBPL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_arbpl INPUT.


  CLEAR: lt_selops, lt_ret_tab.
  ls_selops-shlpname  = 'CRAM'.
  ls_selops-shlpfield = 'ARBPL'.

  ls_selops-sign      = 'I'.
  CALL FUNCTION 'SWD_DYNPRO_FIELD_GET'
    EXPORTING
      struc = 'GX_KC->S_ZUSATZ'
      field = 'ARBPL_DIF'
*     INDEX =
      repid = sy-repid
      dynnr = '4001'
    IMPORTING
      value = ls_selops-low.
  IF ls_selops-low IS NOT INITIAL.
    IF ls_selops-low CA '+*'.
      ls_selops-option    = 'CP'.
    ELSE.
      ls_selops-option    = 'EQ'.
    ENDIF.
    APPEND ls_selops TO lt_selops.
  ENDIF.


  ls_selops-shlpfield = 'WERKS'.
  ls_selops-sign      = 'I'.
  ls_selops-option    = 'EQ'.
  CALL FUNCTION 'SWD_DYNPRO_FIELD_GET'
    EXPORTING
      struc = 'GX_KC->S_ZUSATZ'
      field = 'WERKS'
*     INDEX =
      repid = sy-repid
      dynnr = '4001'
    IMPORTING
      value = ls_selops-low.
  IF ls_selops-low IS NOT INITIAL.
    IF ls_selops-low CA '+*'.
      ls_selops-option    = 'CP'.
    ELSE.
      ls_selops-option    = 'EQ'.
    ENDIF.
    APPEND ls_selops TO lt_selops.
  ENDIF.


  CALL FUNCTION 'F4_FIELD_ON_VALUE_REQUEST'
    EXPORTING
      tabname           = '/DATRAIN/KC_ST_ZUSATZ_08'
      fieldname         = 'ARBPL_DIF'
      searchhelp        = 'CRAM'
*     SHLPPARAM         = ' '
*     DYNPPROG          = ' '
*     DYNPNR            = ' '
*     DYNPROFIELD       = ' '
*     STEPL             = 0
*     VALUE             = ' '
*     MULTIPLE_CHOICE   = ' '
*     DISPLAY           = ' '
*     SUPPRESS_RECORDLIST = ' '
*     CALLBACK_PROGRAM  = ' '
*     CALLBACK_FORM     = ' '
*     SELECTION_SCREEN  = ' '
      callback_selopt   = lt_selops
    TABLES
      return_tab        = lt_ret_tab
    EXCEPTIONS
      field_not_found   = 1
      no_help_for_field = 2
      inconsistent_help = 3
      no_values_found   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    READ TABLE lt_ret_tab INTO ls_ret_tab
                            WITH KEY fieldname = 'WERKS'.
    IF sy-subrc = 0.
      gx_kc->s_zusatz-werks = ls_ret_tab-fieldval.
    ENDIF.
    READ TABLE lt_ret_tab INTO ls_ret_tab
                          WITH KEY fieldname = 'ARBPL'.
    IF sy-subrc = 0.
      gx_kc->s_zusatz-arbpl_dif = ls_ret_tab-fieldval.
    ENDIF.
    CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
      EXPORTING
        struc = 'GX_KC->S_ZUSATZ'
        field = 'ARBPL_DIF'
*       INDEX =
        value = gx_kc->s_zusatz-arbpl_dif.

    CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
      EXPORTING
        struc = 'GX_KC->S_ZUSATZ'
        field = 'WERKS'
*       INDEX =
        value = gx_kc->s_zusatz-werks.
    CALL FUNCTION 'SWD_DYNPRO_FIELDS_SEND'
      EXPORTING
        repid = '/DATRAIN/SAPLKC_MAIN_2008'
        dynnr = '4001'.
  ENDIF.

ENDMODULE.                 " F4_ARBPL  INPUT

*&---------------------------------------------------------------------*
*&      Module  PAI_7500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_7600 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.

  CASE gv_save_code.
    WHEN 'OKAY'.
      SET SCREEN 0.
      LEAVE SCREEN.

    WHEN OTHERS.

  ENDCASE.

ENDMODULE.                 " PAI_7600  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CLEAR gv_save_code.
  gv_exit = 'X'.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDMODULE.                 " EXIT  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9500 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.

  CASE gv_save_code.
    WHEN 'ENTE'.
      CALL METHOD gx_editor->get_text_as_r3table
        IMPORTING
          table = gt_ltext.

      IF gv_noabs = 'X' AND gt_ltext IS INITIAL.
        MESSAGE e176(/datrain/kc_be).
*   Bitte geben Sie eine Begründung an!
        RETURN.
      ENDIF.
      IF gv_noabs = space AND NOT gt_ltext IS INITIAL.
        MESSAGE w177(/datrain/kc_be).
*   Der eingegebene Text wird ignoriert
*(nur bei Meldungsabschluss sinnvoll)
      ENDIF.

      PERFORM destroy_ctrl_9500.

      IF NOT gv_art_cp IS INITIAL.
        PERFORM set_copy_data.
      ENDIF.

      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'SRCH'.
      CALL SCREEN 9501 STARTING AT 1 1.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9500  INPUT

*----------------------------------------------------------------------*
*  MODULE exit_9500 INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE exit_9500 INPUT.

  PERFORM destroy_ctrl_9500.

  CLEAR gv_save_code.
  gv_exit = 'X'.
  LEAVE TO SCREEN 0.
ENDMODULE.                 " EXIT  INPUT
*----------------------------------------------------------------------*
*  MODULE exit_9501 INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE exit_9501 INPUT.
  CALL METHOD gx_kc->clear_global_data
    CHANGING
      cs_search_partner = gx_kc->s_search_partner
      cs_partner        = gx_kc->s_partner
      cs_zuordnung      = gx_kc->s_zuordnung
      cs_zusatz         = gx_kc->s_zusatz.

  CLEAR gv_save_code.
  gv_exit = 'X'.
  LEAVE TO SCREEN 0.
ENDMODULE.                 " EXIT  INPUT

*----------------------------------------------------------------------*
*  MODULE user_command_9501 INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE user_command_9501 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.

  CASE gv_save_code.
    WHEN 'SUCH'.
*     Partnersuche
      CALL METHOD gx_kc->search_partner
        IMPORTING
          es_partner        = gx_kc->s_partner
        CHANGING
          cs_search_partner = gx_kc->s_search_partner
          cs_zusatz         = gx_kc->s_zusatz
          cs_zuordnung      = gx_kc->s_zuordnung.
      CALL METHOD gx_log->refresh_return.
    WHEN 'ENTE'.
      IF NOT gx_kc->s_partner-partner IS INITIAL.
        gv_partner = gx_kc->s_partner-partner.
        CLEAR gt_identkeys.
        gv_intreno = gx_kc->s_partner-intreno.
      ENDIF.

      CALL METHOD gx_kc->clear_global_data
        CHANGING
          cs_search_partner = gx_kc->s_search_partner
          cs_partner        = gx_kc->s_partner
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CLAR'.
      CALL METHOD gx_kc->clear_global_data
        CHANGING
          cs_search_partner = gx_kc->s_search_partner
          cs_partner        = gx_kc->s_partner
          cs_zuordnung      = gx_kc->s_zuordnung
          cs_zusatz         = gx_kc->s_zusatz.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9501  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9200 INPUT.
  gv_save_code = gv_ok_code.
  CLEAR gv_ok_code.
  IF gv_save_code = 'ENTE'.
    GET CURSOR FIELD gv_feld.
    IF gv_feld = 'GV_MCCODE'.
      gv_save_code = 'SRCH_CODE'.
    ENDIF.
  ENDIF.
  CASE gv_save_code.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'TAKE_CODE'.

      LEAVE TO SCREEN 0.
    WHEN 'SRCH_CODE'.
      CALL METHOD gx_kc_tmp->filter_code
        EXPORTING
          iv_code_srch = gv_mccode.

    WHEN OTHERS.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  NEW_EQUNR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE new_equnr INPUT.
  CALL METHOD gx_kc->new_equnr.

ENDMODULE.

*&SPWIZARD: INPUT MODUL FOR TC 'GX_9500'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
MODULE gx_9500_mark INPUT.
  DATA: g_gx_9500_wa2 LIKE LINE OF gt_filetable.
  IF gx_9500-line_sel_mode = 1
  AND gs_filetable-mark = 'X'.
    LOOP AT gt_filetable INTO g_gx_9500_wa2
      WHERE mark = 'X'.
      g_gx_9500_wa2-mark = ''.
      MODIFY gt_filetable
        FROM g_gx_9500_wa2
        TRANSPORTING mark.
    ENDLOOP.
  ENDIF.
  MODIFY gt_filetable
    FROM gs_filetable
    INDEX gx_9500-current_line
    TRANSPORTING mark.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_3600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_3600 INPUT.

  CASE gv_save_code.
    WHEN 'SHOW_BE'.
* Wirtschaftseinheit
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
*         ID_ACTIVITY                = '03'
*         ID_OBJTYPE =
*         id_intreno = p_gs_recn_intreno
          id_objnr = gs_recn-objnr_be
*         IF_LEAVE_CURRENT           = ABAP_FALSE
*         IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*         IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*         IS_NAVIGATION_DATA         =
        EXCEPTIONS
          error    = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    WHEN 'SHOW_BU'.
* Gebäude
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
*         ID_ACTIVITY                = '03'
*         ID_OBJTYPE =
*         id_intreno = p_gs_recn_intreno
          id_objnr = gs_recn-objnr_bu
*         IF_LEAVE_CURRENT           = ABAP_FALSE
*         IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*         IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*         IS_NAVIGATION_DATA         =
        EXCEPTIONS
          error    = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    WHEN 'SHOW_CN'.
* Vertrag
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
*         ID_ACTIVITY                = '03'
*         ID_OBJTYPE =
*         id_intreno = p_gs_recn_intreno
          id_objnr = gs_recn-objnr
*         IF_LEAVE_CURRENT           = ABAP_FALSE
*         IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*         IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*         IS_NAVIGATION_DATA         =
        EXCEPTIONS
          error    = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    WHEN 'SHOW_RO'.
* Mietobjekte
* Vertrag
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
*         ID_ACTIVITY                = '03'
*         ID_OBJTYPE =
*         id_intreno = p_gs_recn_intreno
          id_objnr = gs_recn-objnr_ro
*         IF_LEAVE_CURRENT           = ABAP_FALSE
*         IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*         IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*         IS_NAVIGATION_DATA         =
        EXCEPTIONS
          error    = 1
          OTHERS   = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    WHEN 'SHOW_BU2'.
* Gebäude Kesseldetails
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_heizung_dialog-swenr
        IMPORTING
          output = gs_vibdbu-swenr.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_heizung_dialog-sgenr
        IMPORTING
          output = gs_vibdbu-sgenr.

* Gebäude Kessel
      SELECT * FROM vibdbu INTO gs_vibdbu UP TO 1 ROWS
 WHERE bukrs = gs_recn-bukrs AND swenr = gs_vibdbu-swenr AND sgenr = gs_vibdbu-sgenr
 ORDER BY PRIMARY KEY .
      ENDSELECT.
      IF sy-subrc = 0.
        CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
          EXPORTING
*           ID_ACTIVITY                = '03'
*           ID_OBJTYPE =
*           id_intreno = p_gs_recn_intreno
            id_objnr = gs_vibdbu-objnr
*           IF_LEAVE_CURRENT           = ABAP_FALSE
*           IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*           IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*           IS_NAVIGATION_DATA         =
          EXCEPTIONS
            error    = 1
            OTHERS   = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
      ENDIF.
* technische Platz RO
    WHEN 'SHOW_TP_RO'.
      PERFORM show_tp USING gs_recn-objnr_ro.
    WHEN 'SHOW_TP_BU'.
      PERFORM show_tp USING gs_recn-objnr_bu.
    WHEN 'SHOW_TP_BE'.
      PERFORM show_tp USING gs_recn-objnr_be.
    WHEN 'SHOW_MA'.
* Mieter-Akte
      CALL METHOD z_dt_kc_tools=>mv_get_record
        EXPORTING
          iv_fcode     = 'ZSHW_MA'
        CHANGING
          cs_partner   = gx_kc->s_partner
          cs_zusatz    = gx_kc->s_zusatz
          cs_zuordnung = gx_kc->s_zuordnung
          cs_search    = gx_kc->s_search_partner.
    WHEN 'ZSHOW_GE'.
* Gebäude-Akte
      CALL METHOD z_dt_kc_tools=>ge_get_record
        EXPORTING
          iv_fcode     = 'ZSHOW_GE'
        CHANGING
          cs_partner   = gx_kc->s_partner
          cs_zusatz    = gx_kc->s_zusatz
          cs_zuordnung = gx_kc->s_zuordnung
          cs_search    = gx_kc->s_search_partner.
  ENDCASE.
ENDMODULE.
