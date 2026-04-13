*----------------------------------------------------------------------*
***INCLUDE /DATRAIN/LKC_MAINPBO .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_1000 OUTPUT.
  IF GV_FIRST IS INITIAL.
    PERFORM INIT_KC.
*    perform init_ctrls.
    GV_FIRST = 'X'.
  ENDIF.
  IF GV_INIT_DOCK IS INITIAL AND GX_KC->S_SETTINGS-POPUP IS INITIAL.
    CALL METHOD GX_KC->INIT_DOCKING_CONT
      EXPORTING
        IV_DYNNR = SY-DYNNR
        IV_REPID = SY-REPID.
    GV_INIT_DOCK = 'X'.
  ENDIF.

  IF GV_EXT_CALL = 'X'.
    CALL METHOD GX_KC->CHECK_CHANGE.
    CLEAR GV_EXT_CALL.
  ENDIF.

* PF-Status setzen
  SET PF-STATUS GX_KC->S_SETTINGS-PFSTATUS1000
                              EXCLUDING GX_KC->T_EXCL_FCODE.
* dynamische Texte für Buttons
  PERFORM SET_DYN_BTN_TXT.
* Titel
  SET TITLEBAR  '1000'.

* Cursor aif aktuelles Feld setzen
  IF GV_FELD IS NOT INITIAL AND GV_FELD <> 'CODE_TREE'.
    SET CURSOR FIELD GV_FELD.
  ELSE.
    IF GX_KC->X_CODE_TREE IS NOT INITIAL.
      CALL METHOD CL_GUI_CONTROL=>SET_FOCUS
        EXPORTING
          CONTROL           = GX_KC->X_CODE_TREE
        EXCEPTIONS
          CNTL_ERROR        = 1
          CNTL_SYSTEM_ERROR = 2.
    ENDIF.
  ENDIF.

  CLEAR GV_NEW_TPLNR.
  CLEAR GX_KC->S_ZUSATZ-ARBPL_EXT.
  CALL METHOD GX_KC->NEW_F4CODE
    CHANGING
      CS_ZUSATZ    = GX_KC->S_ZUSATZ
      CS_ZUORDNUNG = GX_KC->S_ZUORDNUNG.


  CALL BADI GX_SCR_EXIT->PUT_DATA_TO_SCREEN
    EXPORTING
      IS_PARTNER        = GX_KC->S_PARTNER
      IS_ZUORDNUNG      = GX_KC->S_ZUORDNUNG
      IS_ZUSATZ         = GX_KC->S_ZUSATZ
      IS_SEARCH_PARTNER = GX_KC->S_SEARCH_PARTNER
    EXCEPTIONS
      RESERVED          = 01.

  GX_KC->S_SCREENS-PROG_SEARCH = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_PARTNER = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_ZUORDNUNG = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_ZUSATZ = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_LTEXT = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_CUST = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_SEARCH_CUST = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_PARTNER_CUST = 'SAPLZRE_PM_COCKPIT'.
*  gx_kc->s_screens-prog_zuordnung_cust = 'SAPLZRE_PM_COCKPIT'.
*  gx_kc->s_screens-scr_zuordnung = '3610'.
  GX_KC->S_SCREENS-PROG_ZUSATZ_CUST = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-PROG_LTEXT_CUST = 'SAPLZRE_PM_COCKPIT'.
  GX_KC->S_SCREENS-SCR_PARTNER = '3600'.
ENDMODULE.                 " STATUS_1000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  init_edit_control  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INIT_EDIT_CONTROL OUTPUT.
  IF GX_EDITOR IS INITIAL.

    CREATE OBJECT GX_ED_CONTROL
      EXPORTING
        CONTAINER_NAME              = 'EDIT_CTRL'
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5.

    CREATE OBJECT GX_EDITOR
      EXPORTING
        PARENT                     = GX_ED_CONTROL
        WORDWRAP_MODE              = CL_GUI_TEXTEDIT=>WORDWRAP_AT_FIXED_POSITION
        WORDWRAP_POSITION          = GX_KC->S_ZUSATZ-LINE_LENGTH
        WORDWRAP_TO_LINEBREAK_MODE = CL_GUI_TEXTEDIT=>TRUE.
    CALL METHOD GX_EDITOR->SET_TEXT_AS_R3TABLE
      EXPORTING
        TABLE = GX_KC->S_ZUSATZ-T_LTEXT.
*   Alles selektieren

  ELSE.
    CALL METHOD GX_EDITOR->SET_TEXT_AS_R3TABLE
      EXPORTING
        TABLE = GX_KC->S_ZUSATZ-T_LTEXT.
  ENDIF.                               "editor is initial
ENDMODULE.                 " init_edit_control  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  init_edit_control  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INIT_EDIT_CONTROL_6010 OUTPUT.
  IF GX_EDITOR IS INITIAL.

    CREATE OBJECT GX_ED_CONTROL
      EXPORTING
        CONTAINER_NAME              = 'EDIT_CTRL'
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5.

    PERFORM INIT_EDITOR_6010.

  ENDIF.                               "editor is initial
ENDMODULE.                 " init_edit_control_6010  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_2000 OUTPUT.

  IF GV_SHOW_OBJS IS INITIAL.
    LOOP AT SCREEN.
      IF SCREEN-GROUP1 = 'OBS'.
        SCREEN-INVISIBLE = 1.
        MODIFY SCREEN.
      ENDIF.

    ENDLOOP.
  ENDIF.
  IF GV_SHOW_HN2 IS INITIAL.
    LOOP AT SCREEN.
      IF SCREEN-GROUP1 = 'HN2'.
        SCREEN-INVISIBLE = 1.
        SCREEN-INPUT     = 0.
        MODIFY SCREEN.
      ENDIF.

    ENDLOOP.
  ENDIF.

* Customizing der Feldgruppe (SCREEN-GROUP4) beachten
  LOOP AT SCREEN.
    IF SCREEN-GROUP4 IS NOT INITIAL.
      MOVE-CORRESPONDING SCREEN TO GS_SCR_PROP.
      CALL METHOD /DATRAIN/AL_CL_SCREEN=>GET_SCREEN_PROP
        EXPORTING
          IV_APPID    = GV_APPID
          IV_PROG     = SY-REPID
          IV_SCRFGRP  = SCREEN-GROUP4
*         is_influence_data =
        CHANGING
          CS_SCR_PROP = GS_SCR_PROP.
      MOVE-CORRESPONDING GS_SCR_PROP TO SCREEN.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

ENDMODULE.                 " STATUS_2000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_2002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_2002 OUTPUT.

*  if gx_kc->s_search_partner-fl_alle = 'X'.
*    clear: gx_kc->s_search_partner-fl_miet,
*           gx_kc->s_search_partner-fl_eige .
*    loop at screen.
*      IF screen-group1 = 'EIG' or  screen-group1 = 'TEN'.
*        screen-INPUT       = '0'.
*        modify screen.
*      endif.
*    ENDLOOP.
*  else.
*    loop at screen.
*      IF screen-group1 = 'EIG' or  screen-group1 = 'TEN'.
*        screen-INPUT       = '1'.
*        modify screen.
*      endif.
*    ENDLOOP.
*  endif.

*  if gx_kc->s_search_partner-fl_alle = 'X'.
*    clear: gx_kc->s_search_partner-fl_miet,
*           gx_kc->s_search_partner-fl_eige .
*  elseif gx_kc->s_search_partner-fl_miet = 'X'
*            or gx_kc->s_search_partner-fl_eige = 'X'.
*    clear: gx_kc->s_search_partner-fl_alle.
*  endif.
  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

ENDMODULE.                 " STATUS_2002  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  FILL_DD_BOX_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE FILL_DD_BOX_2000 OUTPUT.
  PERFORM FILL_SROLE_LIST.

ENDMODULE.                 " FILL_DD_BOX_2000  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_7100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_7100 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  IF GX_ALV_SL_CONTAINER IS INITIAL.
    CREATE OBJECT GX_ALV_SL_CONTAINER
      EXPORTING
        CONTAINER_NAME = 'ALV_CTRL'.
    CREATE OBJECT GX_ALV
      EXPORTING
        I_PARENT = GX_ALV_SL_CONTAINER.
  ENDIF.

ENDMODULE.                 " STATUS_7100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_3000  OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_3000 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  PERFORM ICON_YMB1.
  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

  IF GX_RECNBTN IS INITIAL.
    CREATE OBJECT GX_RECNBTN
      EXPORTING
        CONTAINER_NAME = 'RECNCTRL'                         "#EC NOTEXT
        LIFETIME       = CL_GUI_CUSTOM_CONTAINER=>LIFETIME_DYNPRO.
    CALL METHOD GX_KC->INIT_RECNTBR
      EXPORTING
        IX_RECNBTN = GX_RECNBTN.

  ENDIF.

* Customizing der Feldgruppe (SCREEN-GROUP4) beachten
  LOOP AT SCREEN.
    IF SCREEN-GROUP4 IS NOT INITIAL.
      MOVE-CORRESPONDING SCREEN TO GS_SCR_PROP.
      CALL METHOD /DATRAIN/AL_CL_SCREEN=>GET_SCREEN_PROP
        EXPORTING
          IV_APPID          = GV_APPID
          IV_PROG           = SY-REPID
          IV_SCRFGRP        = SCREEN-GROUP4
          IS_INFLUENCE_DATA = GX_KC->S_SCR_3000
        CHANGING
          CS_SCR_PROP       = GS_SCR_PROP.
      MOVE-CORRESPONDING GS_SCR_PROP TO SCREEN.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

ENDMODULE.                 " STATUS_3000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_4000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_4000 OUTPUT.
  PERFORM GET_STATUS_ICON_IDNRK.

  LOOP AT SCREEN.
    IF SCREEN-NAME+21(6) = '_QMART'.
      GV_NUM2 = SCREEN-NAME+28(2).
      READ TABLE GX_KC->T_QMAR INTO GS_QMAR
                WITH KEY POSNR = GV_NUM2.                   "#EC *
      IF SY-SUBRC = 0.
        SCREEN-INVISIBLE = '0'.
      ELSE.
        SCREEN-INVISIBLE = '1'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

* Priotabelle füllen
  PERFORM FILL_PRIO_LIST.

  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

* Customizing der Feldgruppe (SCREEN-GROUP4) beachten
  LOOP AT SCREEN.
    IF SCREEN-GROUP4 IS NOT INITIAL.
      MOVE-CORRESPONDING SCREEN TO GS_SCR_PROP.
      CALL METHOD /DATRAIN/AL_CL_SCREEN=>GET_SCREEN_PROP
        EXPORTING
          IV_APPID    = GV_APPID
          IV_PROG     = SY-REPID
          IV_SCRFGRP  = SCREEN-GROUP4
*         is_influence_data =
        CHANGING
          CS_SCR_PROP = GS_SCR_PROP.
      MOVE-CORRESPONDING GS_SCR_PROP TO SCREEN.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENHANCEMENT-POINT /datrain/kc_ep_main_2008_02 SPOTS /datrain/kc_es_main_2008_02 .

ENDMODULE.                 " STATUS_4000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_5000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_5000 OUTPUT.

  IF GX_TPBTN IS INITIAL.
    CREATE OBJECT GX_TPBTN
      EXPORTING
        CONTAINER_NAME = 'TPCTRL'                           "#EC NOTEXT
        LIFETIME       = CL_GUI_CUSTOM_CONTAINER=>LIFETIME_DYNPRO.
    CALL METHOD GX_KC->INIT_TPTBR
      EXPORTING
        IX_TPBTN = GX_TPBTN.

  ENDIF.


  READ TABLE GX_KC->T_QMAR INTO GS_QMAR
            WITH KEY QMART = GX_KC->S_ZUORDNUNG-QMART.
  IF GS_QMAR-SHOW_COMP IS INITIAL.
    LOOP AT SCREEN.
      IF SCREEN-GROUP1 = 'KMP'.
        SCREEN-INVISIBLE = '1'.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ELSE.
    IF GX_KC->S_ZUSATZ-IDNRK IS INITIAL.
      LOOP AT SCREEN.
        IF SCREEN-GROUP2 = 'KM1'.
          SCREEN-INVISIBLE = '1'.
        ENDIF.
        MODIFY SCREEN.
      ENDLOOP.
    ELSE.
      IF GX_KC->S_ZUSATZ-DEVICEID(1) <> 'T'.
        LOOP AT SCREEN.
          IF SCREEN-GROUP2 = 'KM1'.
            SCREEN-INPUT = '0'.
          ENDIF.
          MODIFY SCREEN.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
  IF GX_KC->T_PART IS INITIAL.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'PARTNERLISTE'.
        SCREEN-INVISIBLE = '1'.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
  GET PARAMETER ID 'QMI' FIELD GV_QMNUM.                    "#EC EXISTS

  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

* Customizing der Feldgruppe (SCREEN-GROUP4) beachten
  LOOP AT SCREEN.

    IF SCREEN-GROUP4 IS NOT INITIAL.
      MOVE-CORRESPONDING SCREEN TO GS_SCR_PROP.
      CALL METHOD /DATRAIN/AL_CL_SCREEN=>GET_SCREEN_PROP
        EXPORTING
          IV_APPID          = GV_APPID
          IV_PROG           = SY-REPID
          IV_SCRFGRP        = SCREEN-GROUP4
          IS_INFLUENCE_DATA = GX_KC->S_SCR_5000
        CHANGING
          CS_SCR_PROP       = GS_SCR_PROP.
      MOVE-CORRESPONDING GS_SCR_PROP TO SCREEN.
      IF SCREEN-GROUP4 = 'CDX' AND GX_KC->S_ZUSATZ-LTEXTV = ABAP_FALSE.
        SCREEN-INPUT = 0.
      ENDIF.
    ENDIF.
    IF GX_KC->S_ZUSATZ-EQUNR IS NOT INITIAL.
      IF SCREEN-NAME = 'GX_KC->S_ZUSATZ-TPLNR'.
        SCREEN-INPUT = 0.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

  IF GX_KC->T_FIELD_VALUE_SCR IS INITIAL.
     gv_scr_add = '1999'.
  ELSE.
    GV_SCR_ADD = '9100'.

  ENDIF.

ENDMODULE.                 " STATUS_5000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_1500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_1500 OUTPUT.                                  "#EC NEEDED
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_1500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_6000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_6000 OUTPUT.

  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

ENDMODULE.                 " STATUS_6000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_8000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_8000 OUTPUT.
  SET PF-STATUS '8000'.
  SET TITLEBAR '8000'.

ENDMODULE.                 " STATUS_8000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_7200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_7200 OUTPUT.
  SET PF-STATUS '7200'.
  SET TITLEBAR  '7200'.
  IF GX_TD_CONT IS INITIAL.
    CREATE OBJECT GX_TD_CONT
      EXPORTING
        CONTAINER_NAME              = 'DD_CONT'
        LIFETIME                    = CL_GUI_CONTROL=>LIFETIME_DYNPRO
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5
        OTHERS                      = 6.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    CALL METHOD GX_KC->SHOW_TD
      EXPORTING
        IS_ZUSATZ = GX_KC->S_ZUSATZ
        IX_CONT   = GX_TD_CONT
        IV_SHOW   = 'X'.
  ENDIF.
ENDMODULE.                 " STATUS_7200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_WB_MANAGER  OUTPUT
*&---------------------------------------------------------------------*
MODULE PBO_WB_MANAGER OUTPUT.

  CALL METHOD CL_RECA_WB_MANAGER=>MANAGER_PBO
    EXPORTING
      ID_REPID = SY-REPID
      ID_DYNNR = SY-DYNNR.
ENDMODULE.                 " PBO_WB_MANAGER  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_1010  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_1010 OUTPUT.

  SET PF-STATUS '1010'.
  SET TITLEBAR  '1000'.

  GV_APPID = '1P'.
  CALL METHOD GX_KC->GET_SCREENS_FOR_POP_UP
    EXPORTING
      IV_APPID   = GV_APPID
    CHANGING
      CS_SCREENS = GX_KC->S_SCREENS.

ENDMODULE.                 " PBO_1010  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_7500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_7500 OUTPUT.
  IF GX_KC->S_CONST_PARV-NEW_PART = 'X'.
    SET PF-STATUS 'PF2_7500'.
  ELSE.
    SET PF-STATUS 'PF_7500'.
  ENDIF.
  PERFORM SHOW_PARTNER_LIST.

ENDMODULE.                 " PBO_7500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_1090  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_1090 OUTPUT.
* Titel
  SET TITLEBAR  '1000'.

* Cursor aif aktuelles Feld setzen
  IF GV_FELD IS NOT INITIAL AND GV_FELD <> 'CODE_TREE'.
    SET CURSOR FIELD GV_FELD.
  ELSE.
    IF GX_KC->X_CODE_TREE IS NOT INITIAL.
      CALL METHOD CL_GUI_CONTROL=>SET_FOCUS
        EXPORTING
          CONTROL           = GX_KC->X_CODE_TREE
        EXCEPTIONS
          CNTL_ERROR        = 1
          CNTL_SYSTEM_ERROR = 2.
    ENDIF.
  ENDIF.

  CLEAR GV_NEW_TPLNR.

  CALL METHOD GX_KC->NEW_F4CODE
    CHANGING
      CS_ZUSATZ    = GX_KC->S_ZUSATZ
      CS_ZUORDNUNG = GX_KC->S_ZUORDNUNG.


  CALL BADI GX_SCR_EXIT->PUT_DATA_TO_SCREEN
    EXPORTING
      IS_PARTNER        = GX_KC->S_PARTNER
      IS_ZUORDNUNG      = GX_KC->S_ZUORDNUNG
      IS_ZUSATZ         = GX_KC->S_ZUSATZ
      IS_SEARCH_PARTNER = GX_KC->S_SEARCH_PARTNER
    EXCEPTIONS
      RESERVED          = 01.

ENDMODULE.                 " STATUS_1090  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_1090  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_1090 OUTPUT.
  SET PF-STATUS '1010'.
  SET TITLEBAR  '1000'.
ENDMODULE.                 " PBO_1090  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9000 OUTPUT.
  SET PF-STATUS '9000'.
  SET TITLEBAR  '9000'.
  IF GX_CONT_9000 IS INITIAL.
    CREATE OBJECT GX_CONT_9000
      EXPORTING
*       parent                      =
        CONTAINER_NAME              = 'CONT9000'
*       style                       =
        LIFETIME                    = CL_GUI_CONTROL=>LIFETIME_DEFAULT
*       repid                       =
*       dynnr                       =
*       no_autodef_progid_dynnr     =
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5
        OTHERS                      = 6.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
  IF GX_KC->X_SHOW_PART IS INITIAL.
    CALL METHOD GX_KC->INIT_SHOW_PART
      EXPORTING
        IX_CONT = GX_CONT_9000.
  ENDIF.
  CALL METHOD GX_KC->SHOW_TP_PARTNER
    EXPORTING
      IS_ZUSATZ = GX_KC->S_ZUSATZ.

ENDMODULE.                 " STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9100 OUTPUT.
*  SET PF-STATUS '9100'.
*  SET TITLEBAR  '9100'.
  DESCRIBE TABLE GX_KC->T_FIELD_VALUE_SCR
                                    LINES GX_9100-LINES.

ENDMODULE.                 " STATUS_9100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SHOW_ADD_ROW  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SHOW_ADD_ROW OUTPUT.
  CALL METHOD GX_KC->SHOW_ADD_ROW
    CHANGING
      CS_FIELD_VALUE_SCR = GS_FIELD_VALUE_SCR.
  READ TABLE GX_KC->T_ADD_FIELD_PROP INTO GS_ADD_FIELD_PROP
                 WITH KEY FIELDNAME = GS_FIELD_VALUE_SCR-FIELDNAME.
  IF SY-SUBRC = 0.
    IF GS_ADD_FIELD_PROP-SHLP IS INITIAL
          OR GS_ADD_FIELD_PROP-DATATYPE <> 'STRG' .
      LOOP AT SCREEN.
        IF SCREEN-NAME = 'ICON_F4'
                              AND GS_ADD_FIELD_PROP-SHLP IS INITIAL.
          SCREEN-INVISIBLE = '1'.
          SCREEN-INPUT     = 0.
        ENDIF.
        IF SCREEN-NAME = 'ICON_LTEXT'
                              AND GS_ADD_FIELD_PROP-DATATYPE <> 'STRG'.
          SCREEN-INVISIBLE = '1'.
          SCREEN-INPUT     = 0.
        ENDIF.
        MODIFY SCREEN.
      ENDLOOP.
    ENDIF.
    IF GS_ADD_FIELD_PROP-DATATYPE = 'STRG'
              AND GS_FIELD_VALUE_SCR-FIELDLTEXT IS NOT INITIAL.
      LOOP AT SCREEN.
        IF SCREEN-NAME = 'GS_FIELD_VALUE_SCR-FIELDSCR'.
          SCREEN-INPUT     = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.

    ENDIF.
    IF GS_ADD_FIELD_PROP-DISPLAY = 'X'
              OR GS_FIELD_VALUE_SCR-REPLACED = 'X'.
      LOOP AT SCREEN.
        IF SCREEN-NAME = 'GS_FIELD_VALUE_SCR-FIELDSCR'.
          SCREEN-INPUT     = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDIF.


ENDMODULE.                 " SHOW_ADD_ROW  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  PBO_7600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_7600 OUTPUT.
  SET PF-STATUS 'PF_7600'.
  SET TITLEBAR '7600'.
  PERFORM EDIT_MLUS.
ENDMODULE.                 " PBO_7600  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9500 OUTPUT.
  SET PF-STATUS 'PF_9500'.
  SET TITLEBAR  '9500'.

  LOOP AT SCREEN.
    IF SCREEN-GROUP4 IS NOT INITIAL.
      MOVE-CORRESPONDING SCREEN TO GS_SCR_PROP.
      CALL METHOD /DATRAIN/AL_CL_SCREEN=>GET_SCREEN_PROP
        EXPORTING
          IV_APPID    = GV_APPID
          IV_PROG     = SY-REPID
          IV_SCRFGRP  = SCREEN-GROUP4
*         is_influence_data =
        CHANGING
          CS_SCR_PROP = GS_SCR_PROP.
      MOVE-CORRESPONDING GS_SCR_PROP TO SCREEN.
    ENDIF.

    IF ( SCREEN-GROUP4 = 'NFC' OR SCREEN-GROUP4 = 'MVC' )
                          AND NOT GV_ART_FM IS INITIAL.
      SCREEN-INVISIBLE = 1.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                 " STATUS_9500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INIT_EDIT_CONTROL_9500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INIT_EDIT_CONTROL_9500 OUTPUT.
  IF GX_EDITOR IS INITIAL.
    CREATE OBJECT GX_ED_CONTROL
      EXPORTING
        CONTAINER_NAME              = 'EDIT_CTRL'
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5.

    CREATE OBJECT GX_EDITOR
      EXPORTING
        PARENT                     = GX_ED_CONTROL
        WORDWRAP_MODE              = CL_GUI_TEXTEDIT=>WORDWRAP_AT_FIXED_POSITION
        WORDWRAP_POSITION          = '132'
        WORDWRAP_TO_LINEBREAK_MODE = CL_GUI_TEXTEDIT=>TRUE.
    CALL METHOD GX_EDITOR->SET_TEXT_AS_R3TABLE
      EXPORTING
        TABLE = GT_LTEXT.

    CALL METHOD GX_EDITOR->SET_TOOLBAR_MODE
      EXPORTING
        TOOLBAR_MODE = '0'.
    CALL METHOD GX_EDITOR->SET_STATUSBAR_MODE
      EXPORTING
        STATUSBAR_MODE = '0'.

  ELSE.
    CALL METHOD GX_EDITOR->SET_TEXT_AS_R3TABLE
      EXPORTING
        TABLE = GT_LTEXT.
  ENDIF.                               "editor is initial

ENDMODULE.                 " INIT_EDIT_CONTROL_9500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_DATA_9500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE GET_DATA_9500 OUTPUT.
  PERFORM GET_DATA_9500.
ENDMODULE.                 " GET_DATA_9500  OUTPUT

*----------------------------------------------------------------------*
*  MODULE status_9501 OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE STATUS_9501 OUTPUT.
  SET PF-STATUS 'PF_9501'.
  SET TITLEBAR  TEXT-004.
ENDMODULE.                 " STATUS_9501  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INIT_2500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INIT_2500 OUTPUT.
  IF GV_INIT_2500 IS INITIAL.
    GV_INIT_2500 = 'X'.
    GX_KC->S_SEARCH_PARTNER-PA_CRT = GX_KC->S_CONST_PARV-PA_CRT.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9200 OUTPUT.
  PERFORM STATUS_9200.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'GX_9500'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE GX_9500_CHANGE_TC_ATTR OUTPUT.
  DESCRIBE TABLE GT_FILETABLE LINES GX_9500-LINES.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_3600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_1001 OUTPUT.
* weitere Mitarbeiter Clerk
  IF GT_CLERK[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT GO_CC_CLERK IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT GO_CC_CLERK
      EXPORTING
        CONTAINER_NAME = 'CC_CLERK'.

*   ALV erzeugen
    CALL METHOD CL_SALV_TABLE=>FACTORY
      EXPORTING
        R_CONTAINER  = GO_CC_CLERK
      IMPORTING
        R_SALV_TABLE = GO_ALV_CLERK
      CHANGING
        T_TABLE      = GT_CLERK.
  ENDIF.
* Grid setzen
  PERFORM SET_ALV USING GO_ALV_CLERK.
*  go_alv_clerk->refresh( refresh_mode =  if_salv_c_refresh=>soft ).

ENDMODULE.
