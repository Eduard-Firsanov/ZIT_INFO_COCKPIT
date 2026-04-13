*----------------------------------------------------------------------*
***INCLUDE /DATRAIN/LKC_MAINF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  init_kc
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM INIT_KC .
  CONSTANTS:
    LC_KCFX_OBJ TYPE SEOCLSNAME
                            VALUE '/DATRAIN/KC_CL_MAIN_2008',
    LC_KCCL_OBJ TYPE SEOCLSNAME
                            VALUE '/DATRAIN/KC_CL_MAIN_CLASSIC'.
  DATA:
    LV_ORG_OBJ  TYPE SEOCLSNAME,
    LV_EAACTIVE TYPE REMIEAACTIVE,
    LV_OBJNAME  TYPE SEOCLSNAME,
    LV_PVALUE   TYPE /DATRAIN/AL_DE_PVALUE,
    LX_OBJ      TYPE REF TO OBJECT.
  DATA:
    LT_PARV   TYPE /DATRAIN/AL_TT_PARV,
    LS_PARV   TYPE /DATRAIN/AL_ST_PARV,
    LT_RETURN TYPE BAPIRET2_T.
*-----------------------*
  CALL METHOD /DATRAIN/AL_CL_APPID=>GET_APPID
    EXPORTING
      IV_ANWENDUNG = GC_ANWENDUNG_2
      IV_UNAME     = SY-UNAME
    IMPORTING
      EV_APPID     = GV_APPID.
  IF GV_APPID IS INITIAL.
    MESSAGE E000(/DATRAIN/KC).
*   Interner Fehler! KundenID konnte nicht ermittelt werden.
  ENDIF.
  CLEAR: GX_PARTNER, GX_RECNBTN, GX_TD_CONT, GX_TPBTN.
  CALL METHOD /DATRAIN/KC_CL_MAIN_2008=>FACTORY
    EXPORTING
      IV_APPID     = GV_APPID
      IV_ANWENDUNG = GC_ANWENDUNG_2
    IMPORTING
      EX_KC        = GX_KC
    CHANGING
      CX_LOG       = GX_LOG.

  CALL METHOD GX_KC->INIT_KC
    EXPORTING
      IV_APPID          = GV_APPID
      IV_REPID          = SY-REPID
      IV_DYNNR          = '1000'
      IV_ANWENDUNG      = GC_ANWENDUNG_2
    IMPORTING
      ES_SCREENS        = GX_KC->S_SCREENS
      ES_SEARCH_PARTNER = GX_KC->S_SEARCH_PARTNER
      ES_ZUORDNUNG      = GX_KC->S_ZUORDNUNG
      ES_ZUSATZ         = GX_KC->S_ZUSATZ
    CHANGING
      CX_LOG            = GX_LOG.

  CALL METHOD /DATRAIN/AL_CL_PARV=>GET_SINGLE_PARV
    EXPORTING
      IV_APPID     = GV_APPID
      IV_ANWENDUNG = GC_ANWENDUNG_2
      IV_PNAME     = 'KC_SWOBS'
    IMPORTING
      EV_PVALUE    = LV_PVALUE
    CHANGING
      CX_LOG       = GX_LOG.
  GV_SHOW_OBJS = LV_PVALUE.

  CALL METHOD /DATRAIN/AL_CL_PARV=>GET_SINGLE_PARV
    EXPORTING
      IV_APPID     = GV_APPID
      IV_ANWENDUNG = GC_ANWENDUNG_2
      IV_PNAME     = 'KC_SWHN2'
    IMPORTING
      EV_PVALUE    = LV_PVALUE
    CHANGING
      CX_LOG       = GX_LOG.
  GV_SHOW_HN2 = LV_PVALUE.

* Badi für Screenexits holen
  GET BADI GX_SCR_EXIT.
  CALL BADI GX_SCR_EXIT->INIT_CLASS
    EXPORTING
      IX_LOG = GX_LOG.
* Allgemeiner Erweiterungsscreen
  TRY.
      CALL METHOD CL_ENH_BADI_RUNTIME_FUNCTIONS=>GET_PROG_AND_DYNP_FOR_SUBSCR
        EXPORTING
          BADI_NAME       = '/DATRAIN/KC_BA_SCREEN_EXIT'
          CALLING_DYNPRO  = '1000'
          CALLING_PROGRAM = '/DATRAIN/SAPLKC_MAIN_2008'
          SUBSCREEN_AREA  = 'CUSTOMER'
*         filter_values   =
        IMPORTING
          CALLED_DYNPRO   = GX_KC->S_SCREENS-SCR_CUST
          CALLED_PROGRAM  = GX_KC->S_SCREENS-PROG_CUST.
    CATCH CX_ENH_BADI_INCONSISTENT .                    "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NO_SUCH_EXTENSION .               "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NOT_FOUND .                       "#EC NO_HANDLER
    CATCH CX_ENH_BADI_MULITPLE_IMPLS .                  "#EC NO_HANDLER
    CATCH CX_ENH_BADI_FILTER_MISSING .                  "#EC NO_HANDLER
  ENDTRY.
* Erweierungsscreen - Suchfelder
  TRY.
      CALL METHOD CL_ENH_BADI_RUNTIME_FUNCTIONS=>GET_PROG_AND_DYNP_FOR_SUBSCR
        EXPORTING
          BADI_NAME       = '/DATRAIN/KC_BA_SCREEN_EXIT'
          CALLING_DYNPRO  = '2000'
          CALLING_PROGRAM = '/DATRAIN/SAPLKC_MAIN_2008'
          SUBSCREEN_AREA  = 'SEARCH_CUST'
*         filter_values   =
        IMPORTING
          CALLED_DYNPRO   = GX_KC->S_SCREENS-SCR_SEARCH_CUST
          CALLED_PROGRAM  = GX_KC->S_SCREENS-PROG_SEARCH_CUST.
    CATCH CX_ENH_BADI_INCONSISTENT .                    "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NO_SUCH_EXTENSION .               "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NOT_FOUND .                       "#EC NO_HANDLER
    CATCH CX_ENH_BADI_MULITPLE_IMPLS .                  "#EC NO_HANDLER
    CATCH CX_ENH_BADI_FILTER_MISSING .                  "#EC NO_HANDLER
  ENDTRY.
* Erweierungsscreen - Partnerdaten
  TRY.
      CALL METHOD CL_ENH_BADI_RUNTIME_FUNCTIONS=>GET_PROG_AND_DYNP_FOR_SUBSCR
        EXPORTING
          BADI_NAME       = '/DATRAIN/KC_BA_SCREEN_EXIT'
          CALLING_DYNPRO  = '3000'
          CALLING_PROGRAM = '/DATRAIN/SAPLKC_MAIN_2008'
          SUBSCREEN_AREA  = 'PARTNER_CUST'
*         filter_values   =
        IMPORTING
          CALLED_DYNPRO   = GX_KC->S_SCREENS-SCR_PARTNER_CUST
          CALLED_PROGRAM  = GX_KC->S_SCREENS-PROG_PARTNER_CUST.
    CATCH CX_ENH_BADI_INCONSISTENT .                    "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NO_SUCH_EXTENSION .               "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NOT_FOUND .                       "#EC NO_HANDLER
    CATCH CX_ENH_BADI_MULITPLE_IMPLS .                  "#EC NO_HANDLER
    CATCH CX_ENH_BADI_FILTER_MISSING .                  "#EC NO_HANDLER
  ENDTRY.
* Erweierungsscreen - Zuordnung
  TRY.
      CALL METHOD CL_ENH_BADI_RUNTIME_FUNCTIONS=>GET_PROG_AND_DYNP_FOR_SUBSCR
        EXPORTING
          BADI_NAME       = '/DATRAIN/KC_BA_SCREEN_EXIT'
          CALLING_DYNPRO  = '4000'
          CALLING_PROGRAM = '/DATRAIN/SAPLKC_MAIN_2008'
          SUBSCREEN_AREA  = 'ZUORDNUNG_CUST'
*         filter_values   =
        IMPORTING
          CALLED_DYNPRO   = GX_KC->S_SCREENS-SCR_ZUORDNUNG_CUST
          CALLED_PROGRAM  = GX_KC->S_SCREENS-PROG_ZUORDNUNG_CUST.
    CATCH CX_ENH_BADI_INCONSISTENT .                    "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NO_SUCH_EXTENSION .               "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NOT_FOUND .                       "#EC NO_HANDLER
    CATCH CX_ENH_BADI_MULITPLE_IMPLS .                  "#EC NO_HANDLER
    CATCH CX_ENH_BADI_FILTER_MISSING .                  "#EC NO_HANDLER
  ENDTRY.
* Erweiterungsscreen - Zusatzfelder
  TRY.
      CALL METHOD CL_ENH_BADI_RUNTIME_FUNCTIONS=>GET_PROG_AND_DYNP_FOR_SUBSCR
        EXPORTING
          BADI_NAME       = '/DATRAIN/KC_BA_SCREEN_EXIT'
          CALLING_DYNPRO  = '5000'
          CALLING_PROGRAM = '/DATRAIN/SAPLKC_MAIN_2008'
          SUBSCREEN_AREA  = 'ZUSATZ_CUST'
*         filter_values   =
        IMPORTING
          CALLED_DYNPRO   = GX_KC->S_SCREENS-SCR_ZUSATZ_CUST
          CALLED_PROGRAM  = GX_KC->S_SCREENS-PROG_ZUSATZ_CUST.
    CATCH CX_ENH_BADI_INCONSISTENT .                    "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NO_SUCH_EXTENSION .               "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NOT_FOUND .                       "#EC NO_HANDLER
    CATCH CX_ENH_BADI_MULITPLE_IMPLS .                  "#EC NO_HANDLER
    CATCH CX_ENH_BADI_FILTER_MISSING .                  "#EC NO_HANDLER
  ENDTRY.
* Erweiterungsscreen - Langtext
  TRY.
      CALL METHOD CL_ENH_BADI_RUNTIME_FUNCTIONS=>GET_PROG_AND_DYNP_FOR_SUBSCR
        EXPORTING
          BADI_NAME       = '/DATRAIN/KC_BA_SCREEN_EXIT'
          CALLING_DYNPRO  = '6000'
          CALLING_PROGRAM = '/DATRAIN/SAPLKC_MAIN_2008'
          SUBSCREEN_AREA  = 'LTEXT_CUST'
*         filter_values   =
        IMPORTING
          CALLED_DYNPRO   = GX_KC->S_SCREENS-SCR_LTEXT_CUST
          CALLED_PROGRAM  = GX_KC->S_SCREENS-PROG_LTEXT_CUST.
    CATCH CX_ENH_BADI_INCONSISTENT .                    "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NO_SUCH_EXTENSION .               "#EC NO_HANDLER
    CATCH CX_ENH_BADI_NOT_FOUND .                       "#EC NO_HANDLER
    CATCH CX_ENH_BADI_MULITPLE_IMPLS .                  "#EC NO_HANDLER
    CATCH CX_ENH_BADI_FILTER_MISSING .                  "#EC NO_HANDLER
  ENDTRY.

* Aktionen im DDockingcontainer?
  IF GX_KC->S_SETTINGS-DOCKING = 'X'.
    CALL METHOD GX_KC->INIT_ACTIONBOX
      EXPORTING
        IV_REPID = SY-REPID
        IV_DYNNR = SY-DYNNR.

  ENDIF.

ENDFORM.                    " init_kc

*&---------------------------------------------------------------------*
*&      Form  fill_prio_list
*&---------------------------------------------------------------------*
FORM FILL_PRIO_LIST .

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GX_KC->S_ZUORDNUNG-PRIOK'
      VALUES = GX_KC->T_PRIO
    EXCEPTIONS
      OTHERS = 0.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GX_KC->S_ZUORDNUNG-MELDT'
      VALUES = GX_KC->T_MELD
    EXCEPTIONS
      OTHERS = 0.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GX_KC->S_ZUORDNUNG-KTWEG'
      VALUES = GX_KC->T_KTWEG
    EXCEPTIONS
      OTHERS = 0.

ENDFORM.                    " fill_prio_list

*&---------------------------------------------------------------------*
*&      Form  fill_srole_list
*&---------------------------------------------------------------------*
FORM FILL_SROLE_LIST .

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'GX_KC->S_SEARCH_PARTNER-ROLE_SONST'
      VALUES = GX_KC->T_SROLE
    EXCEPTIONS
      OTHERS = 0.


ENDFORM.                    " fill_srole_list

*&---------------------------------------------------------------------*
*&      Form  icon_ymb1
*&---------------------------------------------------------------------*
FORM ICON_YMB1 .
  DATA: LV_ACTUAL(10)   TYPE C,
        LV_COMPLETE(10) TYPE C,
        LV_ICON(40)     TYPE C,
        LV_INFO         TYPE ICONQUICK.


  IF GX_KC->S_ZUSATZ-ICON_SALDO IS INITIAL.
    LV_ICON = 'ICON_DUMMY'.
  ELSE.
    LV_ICON = GX_KC->S_ZUSATZ-ICON_SALDO.
    WRITE: GX_KC->S_ZUSATZ-ACTUAL   TO LV_ACTUAL
                             CURRENCY GX_KC->S_ZUSATZ-WAERS,
           GX_KC->S_ZUSATZ-COMPLETE TO LV_COMPLETE
                             CURRENCY GX_KC->S_ZUSATZ-WAERS.
    CONCATENATE LV_ACTUAL ';' LV_COMPLETE GX_KC->S_ZUSATZ-WAERS
                              INTO LV_INFO.
  ENDIF.
  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME                  = LV_ICON
      TEXT                  = ' '
      INFO                  = LV_INFO
      ADD_STDINF            = ' '
    IMPORTING
      RESULT                = GV_ICON_SALDO
    EXCEPTIONS
      ICON_NOT_FOUND        = 1
      OUTPUTFIELD_TOO_SHORT = 2
      OTHERS                = 3.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                                                    " icon_ymb1
*&---------------------------------------------------------------------*
*&      Form  get_status_icon_idnrk
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_STATUS_ICON_IDNRK .
  DATA: LV_ICON_NAME(20) TYPE C,
        LV_ICON_TEXT(20) TYPE C.
  IF GX_KC->S_ZUSATZ-IDNRK IS INITIAL.
    LV_ICON_NAME = 'ICON_DUMMY'.
    LV_ICON_TEXT =  SPACE.
  ELSE.
    CASE GX_KC->S_ZUSATZ-DEVICEID(1).
* Bestandteil der TP-Stückliste
      WHEN 'T' .
        LV_ICON_NAME = 'ICON_PRESENCE'.
        LV_ICON_TEXT =  TEXT-002.
      WHEN OTHERS.
        LV_ICON_NAME = 'ICON_ABSENCE'.
        LV_ICON_TEXT =  TEXT-001.
    ENDCASE.
  ENDIF.


  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME                  = LV_ICON_NAME
      INFO                  = LV_ICON_TEXT
      ADD_STDINF            = 'X'
    IMPORTING
      RESULT                = GV_ICON_IDNRK
    EXCEPTIONS
      ICON_NOT_FOUND        = 0
      OUTPUTFIELD_TOO_SHORT = 0
      OTHERS                = 0.

ENDFORM.                    " get_status_icon_idnrk
*&---------------------------------------------------------------------*
*&      Form  SHOW_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_LOG .
  DATA: LT_RETURN           TYPE BAPIRET2_T.
* Meldungsausgabe
  CLEAR: GV_SAVE_CODE, GV_SUB_CODE.

  CLEAR LT_RETURN.
  CALL METHOD GX_LOG->GET_RETURN
    IMPORTING
      ET_RETURN = LT_RETURN.

  " E.Firsanov Bei WEG Objekten sind Technische Plätze Gebäude inaktiv.
  " Fehler-Meldung soll geändert werden.                                                  " EF CH2412-0018
  IF GS_RECN-WEG = 'X'.                                                                   " EF CH2412-0018
    SELECT FLTYP FROM IFLOT                                                               " EF CH2412-0018
      WHERE TPLNR = @GX_KC->S_ZUSATZ-TPLNR                                                " EF CH2412-0018
      INTO @DATA(LD_FLTYP).                                                               " EF CH2412-0018
    ENDSELECT.                                                                            " EF CH2412-0018
    IF LD_FLTYP = 'H'. " Haus                                                             " EF CH2412-0018
      " suche und korrigiere die Fehlermeldung                                            " EF CH2412-0018
      READ TABLE LT_RETURN TRANSPORTING NO FIELDS WITH KEY TYPE = 'E'                     " EF CH2412-0018
                                                           ID   = 'BS'                    " EF CH2412-0018
                                                           NUMBER = '013'.                " EF CH2412-0018
      IF SY-SUBRC = 0.                                                                    " EF CH2412-0018
         MESSAGE E001(ZMSG_INFO_COCKPIT) WITH GX_KC->S_ZUSATZ-TPLNR into data(dummy).      " EF CH2412-0018
        "  Fehler: „Gebäude & nicht aktiv WEG-Verwaltung“
        CALL METHOD gx_log->add_msg.
      ENDIF.                                                                                " EF CH2412-0018
    ENDIF.                                                                                  " EF CH2412-0018
  ENDIF.                                                                                    " EF CH2412-0018

  IF LT_RETURN IS NOT INITIAL.
    CALL METHOD GX_LOG->SHOW_LOG
      EXPORTING
        IV_SINGLE_STATUS = 'X'
        IV_SUBST         = 'X'.
    CALL METHOD GX_LOG->REFRESH_RETURN.

  ENDIF.
ENDFORM.                    " SHOW_LOG
*&---------------------------------------------------------------------*
*&      Form  SET_DYN_BTN_TXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_DYN_BTN_TXT .
  DATA: LS_ABTN TYPE /DATRAIN/KC_ST_PF_BTN_TXT.

  READ TABLE GX_KC->T_ADD_BTN INTO LS_ABTN WITH KEY BTNID = 'ADD_BTN1'.
  IF SY-SUBRC = 0.
    GV_ADD_BTN1_TXT = LS_ABTN-BTN_TXT.
  ELSE.
    CLEAR GV_ADD_BTN1_TXT.
  ENDIF.
  READ TABLE GX_KC->T_ADD_BTN INTO LS_ABTN WITH KEY BTNID = 'ADD_BTN2'.
  IF SY-SUBRC = 0.
    GV_ADD_BTN2_TXT = LS_ABTN-BTN_TXT.
  ELSE.
    CLEAR GV_ADD_BTN2_TXT.
  ENDIF.
  READ TABLE GX_KC->T_ADD_BTN INTO LS_ABTN WITH KEY BTNID = 'ADD_BTN3'.
  IF SY-SUBRC = 0.
    GV_ADD_BTN3_TXT = LS_ABTN-BTN_TXT.
  ELSE.
    CLEAR GV_ADD_BTN3_TXT.
  ENDIF.
  READ TABLE GX_KC->T_ADD_BTN INTO LS_ABTN WITH KEY BTNID = 'ADD_BTN4'.
  IF SY-SUBRC = 0.
    GV_ADD_BTN4_TXT = LS_ABTN-BTN_TXT.
  ELSE.
    CLEAR GV_ADD_BTN4_TXT.
  ENDIF.
  READ TABLE GX_KC->T_ADD_BTN INTO LS_ABTN WITH KEY BTNID = 'ADD_BTN5'.
  IF SY-SUBRC = 0.
    GV_ADD_BTN5_TXT = LS_ABTN-BTN_TXT.
  ELSE.
    CLEAR GV_ADD_BTN5_TXT.
  ENDIF.
ENDFORM.                    " SET_DYN_BTN_TXT
*&---------------------------------------------------------------------*
*&      Form  INIT_EDITOR_6010
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM INIT_EDITOR_6010 .
  TYPES:
    BEGIN OF T_SOURCE,
      LINE TYPE EDPLINE,
    END OF T_SOURCE.
  DATA:
    LT_LTEXT_TMP TYPE TABLE OF T_SOURCE,
    LV_LINES     TYPE I.
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
  CALL METHOD GX_EDITOR->GET_TEXT_AS_R3TABLE
    IMPORTING
      TABLE                  = LT_LTEXT_TMP
    EXCEPTIONS
      ERROR_DP               = 1
      ERROR_CNTL_CALL_METHOD = 2
      ERROR_DP_CREATE        = 3
      POTENTIAL_DATA_LOSS    = 4
      OTHERS                 = 5.
  IF SY-SUBRC <> 0.
*     Implement suitable error handling here
  ENDIF.
  DESCRIBE TABLE LT_LTEXT_TMP LINES LV_LINES.
  APPEND INITIAL LINE TO LT_LTEXT_TMP.

  CHECK LV_LINES GT 0.
  CALL METHOD GX_EDITOR->SET_TEXT_AS_R3TABLE
    EXPORTING
      TABLE = LT_LTEXT_TMP.
  CALL METHOD GX_EDITOR->PROTECT_LINES
    EXPORTING
      FROM_LINE                     = 1
*     protect_mode                  = TRUE
      TO_LINE                       = LV_LINES
      ENABLE_EDITING_PROTECTED_TEXT = CL_GUI_TEXTEDIT=>FALSE
    EXCEPTIONS
      ERROR_CNTL_CALL_METHOD        = 1
      INVALID_PARAMETER             = 2
      OTHERS                        = 3.
  IF SY-SUBRC <> 0.
*     Implement suitable error handling here
  ENDIF.

  LV_LINES = LV_LINES + 1.
  CALL METHOD GX_EDITOR->PROTECT_LINES
    EXPORTING
      FROM_LINE                     = LV_LINES
      PROTECT_MODE                  = CL_GUI_TEXTEDIT=>FALSE
      TO_LINE                       = LV_LINES
      ENABLE_EDITING_PROTECTED_TEXT = CL_GUI_TEXTEDIT=>FALSE
    EXCEPTIONS
      ERROR_CNTL_CALL_METHOD        = 1
      INVALID_PARAMETER             = 2
      OTHERS                        = 3.
  IF SY-SUBRC <> 0.
*     Implement suitable error handling here
  ENDIF.

ENDFORM.                    " INIT_EDITOR_6010
*&---------------------------------------------------------------------*
*&      Form  F4_CODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F4_CODE .
  DATA:
    LV_IDNRK   TYPE MATNR.
  IF GX_KC->S_ZUSATZ-SUBMT IS INITIAL.
    LV_IDNRK = GX_KC->S_ZUSATZ-IDNRK.
  ELSE.
    LV_IDNRK = GX_KC->S_ZUSATZ-SUBMT.
  ENDIF.
  CALL METHOD GX_KC->F4_CODE
    EXPORTING
      IV_IDNRK     = LV_IDNRK
    CHANGING
      CS_ZUSATZ    = GX_KC->S_ZUSATZ
      CS_ZUORDNUNG = GX_KC->S_ZUORDNUNG.
  CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
    EXPORTING
      STRUC = 'GX_KC->S_ZUSATZ'
      FIELD = 'MNGRP'
*     INDEX =
      VALUE = GX_KC->S_ZUSATZ-MNGRP.
  CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
    EXPORTING
      STRUC = 'GX_KC->S_ZUSATZ'
      FIELD = 'MNCOD'
*     INDEX =
      VALUE = GX_KC->S_ZUSATZ-MNCOD.

  CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
    EXPORTING
      STRUC = 'GX_KC->S_ZUSATZ'
      FIELD = 'GES_TXT'
*     INDEX =
      VALUE = GX_KC->S_ZUSATZ-GES_TXT.

  CALL FUNCTION 'SWD_DYNPRO_FIELD_SET'
    EXPORTING
      STRUC = 'GX_KC->S_ZUSATZ'
      FIELD = 'QMTXT'
*     INDEX =
      VALUE = GX_KC->S_ZUSATZ-QMTXT.

  CALL FUNCTION 'SWD_DYNPRO_FIELDS_SEND'
    EXPORTING
      REPID = '/DATRAIN/SAPLKC_MAIN_2008'
      DYNNR = '5000'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  STATUS_9200
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM STATUS_9200 .
  DATA:
    LV_IDNRK   TYPE MATNR.
  IF GX_KC->S_ZUSATZ-SUBMT IS INITIAL.
    LV_IDNRK = GX_KC->S_ZUSATZ-IDNRK.
  ELSE.
    LV_IDNRK = GX_KC->S_ZUSATZ-SUBMT.
  ENDIF.
  SET PF-STATUS '9200'.
  SET TITLEBAR  '9200'.
  IF GX_CONT_9200 IS INITIAL.
    CREATE OBJECT GX_CONT_9200
      EXPORTING
        CONTAINER_NAME              = 'CONT_CODE'
        LIFETIME                    = CL_GUI_CONTROL=>LIFETIME_DYNPRO
      EXCEPTIONS
        CNTL_ERROR                  = 1
        CNTL_SYSTEM_ERROR           = 2
        CREATE_ERROR                = 3
        LIFETIME_ERROR              = 4
        LIFETIME_DYNPRO_DYNPRO_LINK = 5
        OTHERS                      = 6.
    IF SY-SUBRC <> 0.
      EXIT.
    ENDIF.
    CALL METHOD GX_KC_TMP->F4_CODE_TREE
      EXPORTING
        IV_REPID     = SY-REPID
        IV_DYNNR     = SY-DYNNR
        IX_CONT_CODE = GX_CONT_9200
        IV_IDNRK     = LV_IDNRK
      CHANGING
        CS_ZUSATZ    = GX_KC_TMP->S_ZUSATZ
        CS_ZUORDNUNG = GX_KC_TMP->S_ZUORDNUNG.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NOTIF_ATTC_MERGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM NOTIF_ATTC_MERGE .

  DATA:
    LT_DOC_OBJ   TYPE /DATRAIN/DO_TT_DOC_OBJ,

    LS_DOC_OBJ   TYPE /DATRAIN/DO_ST_DOC_OBJ,
    LS_DOCS      TYPE /DATRAIN/DO_ST_DOCS,
    LS_FILETABLE TYPE /DATRAIN/NO_ST_ATTC,

    LV_OBJ_KEY   TYPE BDS_TYPEID,

    LX_DOC       TYPE REF TO /DATRAIN/DO_CL_MAIN2.

  CALL METHOD /DATRAIN/DO_CL_MAIN2=>FACTORY
    EXPORTING
      IV_APPID     = GV_APPID
      IV_ANWENDUNG = GC_ANWENDUNG_2
      IV_DOCLASS   = 'ALLN'
    IMPORTING
      EX_DO        = LX_DOC
    CHANGING
      CX_LOG       = GX_LOG.

  LS_DOC_OBJ-OBJECT_TYPE = 'NO'.
  LS_DOC_OBJ-OBJECT_ID   = GS_VIQMEL-QMNUM.
  APPEND LS_DOC_OBJ TO LT_DOC_OBJ.

  CALL METHOD LX_DOC->GET_DOCUMENTS
    EXPORTING
      IV_OBJ_KEY = LV_OBJ_KEY
      IT_DOC_OBJ = LT_DOC_OBJ.

  LOOP AT LX_DOC->T_DOCS INTO LS_DOCS.
    MOVE-CORRESPONDING LS_DOCS TO LS_FILETABLE.
    READ TABLE GT_FILETABLE WITH KEY LS_FILETABLE TRANSPORTING NO FIELDS.
    IF SY-SUBRC <> 0.
      APPEND LS_FILETABLE TO GT_FILETABLE.
    ENDIF.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  NOTIF_NEW_MERGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM NOTIF_NEW_MERGE .
  DATA:
    LX_DOC       TYPE REF TO /DATRAIN/DO_CL_HANDLE_DOC,
    LV_SUBGR     TYPE /DATRAIN/DO_DE_SUBDOCGRP,
    LS_FILETABLE TYPE /DATRAIN/NO_ST_ATTC.

  CALL METHOD /DATRAIN/DO_CL_HANDLE_DOC=>FACTORY
    EXPORTING
      IV_APPID     = GV_APPID
      IV_ANWENDUNG = GC_ANWENDUNG_2
    IMPORTING
      EX_DOC       = LX_DOC
    CHANGING
      CX_LOG       = GX_LOG.

  IF GX_LOG->ERRORS NE ABAP_FALSE.
    RETURN.
  ENDIF.

*DOCGR  Type  /DATRAIN/DO_DE_DOCGRP
*BEZEI  Type  TEXT40
*DOC_ID Type  BDS_DOCID
*COMP_ID  Type  BDS_COMPID
*MIMETYPE Type  BDS_MIMETP
*FILENAME Type  SDOK_FILNM
*ERDAT  Type  ERDAT
*ERNAME Type  UNAME
*ARCHIV_ID  Type  SAEARCHIVI
*DOC_TYPE Type  /DATRAIN/AL_DE_DOC_TYPE
*KEYWORD  Type  BDS_PROPVA
*OBJECT_ID  Type  /DATRAIN/DO_DE_OBJID
*INTERFACE  Type  SEOCLSNAME
*
*IV_DOCGR	TYPE /DATRAIN/DO_DE_DOCGRP
*IV_SUBGR	TYPE /DATRAIN/DO_DE_SUBDOCGRP
*IV_OBJ_KEY	TYPE BDS_TYPEID
*IV_NOCOMMIT  TYPE FLAG
*IV_DOCID	TYPE BDS_DOCID
*IV_ARCHIV_ID	TYPE SAEARCHIVI OPTIONAL
*IV_DOCART  TYPE /DATRAIN/DO_DE_DOCART
*IV_FILENAME  TYPE STRING OPTIONAL
*CT_SET_CODES	TYPE /DATRAIN/DO_TT_SET_CODES OPTIONAL


  LOOP AT GT_FILETABLE INTO LS_FILETABLE WHERE MARK = 'X'.
    CALL METHOD LX_DOC->ASSIGN_DOC
      EXPORTING
        IV_DOCGR     = LS_FILETABLE-DOCGR
        IV_SUBGR     = LV_SUBGR
        IV_ARCHIV_ID = LS_FILETABLE-ARCHIV_ID
        IV_OBJ_KEY   = |{ GV_NEW_QMNUM }|
        IV_NOCOMMIT  = 'X'
        IV_DOCID     = |{ LS_FILETABLE-DOC_ID }|
        IV_DOCART    = |{ LS_FILETABLE-DOC_TYPE }|
        IV_FILENAME  = |{ LS_FILETABLE-FILENAME }|.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GO_ALV_CLERK  text
*----------------------------------------------------------------------*
FORM SET_ALV   USING  RO_ALV TYPE REF TO CL_SALV_TABLE.

  DATA:
    LO_FUNCT      TYPE REF TO CL_SALV_FUNCTIONS_LIST,
    LO_LAYOUT     TYPE REF TO CL_SALV_LAYOUT,
    LO_EVENTS     TYPE REF TO CL_SALV_EVENTS_TABLE,
    LR_EVENTS     TYPE REF TO CL_SALV_EVENTS_TABLE,
    LV_LAYOUT_KEY TYPE SALV_S_LAYOUT_KEY,
    LO_SELECTIONS TYPE REF TO CL_SALV_SELECTIONS,
    LR_COLUMN     TYPE REF TO CL_SALV_COLUMN_TABLE,
    LR_COLUMNS    TYPE REF TO CL_SALV_COLUMNS_TABLE,
    LR_DISPLAY    TYPE REF TO CL_SALV_DISPLAY_SETTINGS,
    LF_VARIANT    TYPE SLIS_VARI,
    LS_COLOR      TYPE LVC_S_COLO,
    LS_DDIC       TYPE SALV_S_DDIC_REFERENCE,
    LT_COLUMNS    TYPE SALV_T_COLUMN_REF.
  FIELD-SYMBOLS: <LS_COLUM> LIKE LINE OF LT_COLUMNS.
*-------------------------------
* Markierspalte einblenden
  LO_SELECTIONS = RO_ALV->GET_SELECTIONS( ).  "
  LO_SELECTIONS->SET_SELECTION_MODE(
              IF_SALV_C_SELECTION_MODE=>CELL ).  "Multiple row selection
* lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*-- layout stuff
  LO_LAYOUT = RO_ALV->GET_LAYOUT( ).
  LO_LAYOUT->SET_DEFAULT( ABAP_TRUE ). "Voreinstellung Layout erlauben
  LV_LAYOUT_KEY-REPORT = SY-CPROG.
* Funktionen Toolbar
  LO_FUNCT = RO_ALV->GET_FUNCTIONS( ).
  LO_FUNCT->SET_ALL( ).

* lv_layout_key-handle = 'MAIN'.
  CASE  RO_ALV.
    WHEN GO_ALV_PARTNER.
      LV_LAYOUT_KEY-HANDLE = 'PART'.
    WHEN GO_ALV_CLERK.
      LV_LAYOUT_KEY-HANDLE = 'CLER'.
    WHEN GO_ALV_COND.
      LV_LAYOUT_KEY-HANDLE = 'COND'.
    WHEN GO_ALV_AREA.
      LV_LAYOUT_KEY-HANDLE = 'AREA'.
    WHEN GO_ALV_OCCUPANCY.
      LV_LAYOUT_KEY-HANDLE = 'OCCUPANCY'.
    WHEN GO_ALV_NOTDIENST.
      LV_LAYOUT_KEY-HANDLE = 'NOTDIENST'.
    WHEN GO_ALV_WARTUNG.
      LV_LAYOUT_KEY-HANDLE = 'WARTUNG'. "Wartungsverträge RO
      RO_ALV->GET_COLUMNS( )->SET_COLUMN_POSITION( COLUMNNAME = 'ICON_DETAIL' POSITION = 1 ). "
    WHEN GO_ALV_WARTUNG_GEB.
      LV_LAYOUT_KEY-HANDLE = 'WARTUNG_GEB'. "Wartungsverträge BU
      RO_ALV->GET_COLUMNS( )->SET_COLUMN_POSITION( COLUMNNAME = 'ICON_DETAIL' POSITION = 1 ). "
    WHEN GO_ALV_CHARACT.
      LV_LAYOUT_KEY-HANDLE = 'CHARACT'.
    WHEN GO_ALV_CHARACT_WE.
      LV_LAYOUT_KEY-HANDLE = 'CHARACT_WE'.
    WHEN GO_ALV_CHARACT_WE.
      LV_LAYOUT_KEY-HANDLE = 'CHARACT_RO'.
    WHEN GO_ALV_RO.
      LV_LAYOUT_KEY-HANDLE = 'RO'. "Objekt pro Gebäude
    WHEN GO_ALV_KESSEL.
      LV_LAYOUT_KEY-HANDLE = 'KESSEL'. "Kessel angeschlossene Objekte
* Summen aktivieren
      RO_ALV->GET_AGGREGATIONS( )->CLEAR( ).
* Summen
      RO_ALV->GET_AGGREGATIONS( )->ADD_AGGREGATION( 'HEIZFLAECHE' ).
    WHEN GO_ALV_BESTELLUNG.
* Bestellung
      LV_LAYOUT_KEY-HANDLE = 'BEST'. "Bestellung WE
  ENDCASE.
** Variante übergeben
*  lf_variant = '/Default'.
*  lo_layout->set_initial_layout( lf_variant ).
  LO_LAYOUT->SET_SAVE_RESTRICTION( IF_SALV_C_LAYOUT=>RESTRICT_NONE ).
  LO_LAYOUT->SET_KEY( LV_LAYOUT_KEY ).

*...set status(Fullscreen)
* Default-Werte für den Status
*    ro_alv->set_screen_status(
*    pfstatus      =  'MAIN'
*    report        =  sy-cprog ).


* Build alv
  LR_COLUMNS = RO_ALV->GET_COLUMNS( ).
  LR_COLUMNS->SET_OPTIMIZE( ABAP_TRUE ).

* try Farben
  TRY.
      LR_COLUMNS->SET_COLOR_COLUMN( 'T_COLOR' ). "Spalte mit Farben kennzeichnen
    CATCH CX_SALV_DATA_ERROR.                           "#EC NO_HANDLER
  ENDTRY.

* Hotspot für Kostenstelle setzen
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'RECNNR' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'PARTNER' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'PARTNER_CLERK' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
*      lr_column->set_icon( if_salv_c_bool_sap=>true ).
*      lr_column->set_long_text( 'Belegnummer' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_RO' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
      LR_COLUMN->SET_LONG_TEXT( 'Mietobjekt' ).
      LR_COLUMN->SET_SHORT_TEXT( 'MO' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Mietobjekt' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_RO_RO' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
      LR_COLUMN->SET_LONG_TEXT( 'Mietobjekt' ).
      LR_COLUMN->SET_SHORT_TEXT( 'MO' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Mietobjekt' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_WE' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
      LR_COLUMN->SET_LONG_TEXT( 'Wirtschaftseinheit' ).
      LR_COLUMN->SET_SHORT_TEXT( 'WE' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Wirtschaftseinheit' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_GEB' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
      LR_COLUMN->SET_LONG_TEXT( 'Gebäude' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Geb' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Gebäude' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_CN' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
      LR_COLUMN->SET_LONG_TEXT( 'Vertrag' ).
      LR_COLUMN->SET_SHORT_TEXT( 'VN' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Vertrag' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_CN_RO' ).
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
      LR_COLUMN->SET_LONG_TEXT( 'Vertrag' ).
      LR_COLUMN->SET_SHORT_TEXT( 'VN' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Vertrag' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
* Bezeichnung
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'EDATUM' ).
      LR_COLUMN->SET_LONG_TEXT( 'Erfasst am' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Erfasst' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Erfasst am' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'RECNENDABS' ).
      LR_COLUMN->SET_LONG_TEXT( 'Vertragsende' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Ende' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Vertragsende' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'MEASVALUE' ).
      LR_COLUMN->SET_LONG_TEXT( 'Fläche' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Fläche' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Fläche' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'KELLERNR' ).
      LR_COLUMN->SET_LONG_TEXT( 'Keller-Nummer' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Keller' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Keller-Nummer' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
* Bestllung
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'DOC_BEST' ).
      LR_COLUMN->SET_LONG_TEXT( 'Bestellung Beleg' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Bestell' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Bestellung Beleg' ). "#EC NO_HANDLER
*      lr_column->set_cell_type( if_salv_c_cell_type=>button ). "<-- This
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'DOC_WART' ).
      LR_COLUMN->SET_LONG_TEXT( 'Wartung Beleg' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Wartung' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Wartung Beleg' ).    "#EC NO_HANDLER
*      lr_column->set_cell_type( if_salv_c_cell_type=>button ). "<-- This
      LR_COLUMN->SET_CELL_TYPE( IF_SALV_C_CELL_TYPE=>HOTSPOT ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'KZWI2' ).
      LR_COLUMN->SET_LONG_TEXT( 'Nachtrag' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Nachtrag' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Nachtrag' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'KZWI4' ).
      LR_COLUMN->SET_LONG_TEXT( 'Abschlag' ).
      LR_COLUMN->SET_SHORT_TEXT( 'Abschlag' ).
      LR_COLUMN->SET_MEDIUM_TEXT( 'Abschlag' ).
    CATCH CX_SALV_NOT_FOUND.                            "#EC NO_HANDLER
  ENDTRY.

* Farben
* Spalten
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'PARTNER' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.

  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'PARTNER_CLERK' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'RECNNR' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_RO' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'IDENTKEY_BU' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'TEILNR' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
* Konditionen
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'CONDTYPE' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'CONDVALIDFROM' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
* Flächen
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'VALIDFROM' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'MEAS' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LS_COLOR-COL = 1. "Blau
      LS_COLOR-INT = 1.
      LS_COLOR-INV = 0.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'DOC_BEST' ).
      LR_COLUMN->SET_COLOR( LS_COLOR ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
* technischer Felder
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'INTRENO' ).
      LR_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "technische Felder
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'OBJNR' ).
      LR_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "technische Felder
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'OBJTYPE' ).
      LR_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "technische Felder
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'OBJID' ).
      LR_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "technische Felder
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'SUBROLE' ).
      LR_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "technische Felder
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'ADDRTYPE' ).
      LR_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "technische Felder
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.


  TRY.
      LR_COLUMN ?= LR_COLUMNS->GET_COLUMN( 'STATUS' ).
      LR_COLUMN->SET_DDIC_REFERENCE( LS_DDIC ).
      LR_COLUMN->SET_F4( IF_SALV_C_BOOL_SAP=>TRUE ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
* events
  LT_COLUMNS = LR_COLUMNS->GET( ).
* Ausblenden
  LOOP AT LT_COLUMNS ASSIGNING <LS_COLUM>.
    CASE <LS_COLUM>-COLUMNNAME.
      WHEN 'OBJNR' OR 'OBJNR_RO' OR 'OBJNR_CN' OR 'INTRENO' OR 'INTRENO_CN' OR
           'BUKRS' OR 'SWENR' OR 'SMENR' OR 'OBJNR_BEST'.
        <LS_COLUM>-R_COLUMN->SET_TECHNICAL( ABAP_TRUE ). "Ausblenden
        <LS_COLUM>-R_COLUMN->SET_VISIBLE( ABAP_FALSE ).
      WHEN  'WEIGHT' OR 'MODERNMEASURE' OR 'FFCTACCURATE' OR 'CHARACTAMTAREA' OR
           'CHARACTPERCENT' OR 'CHARACTAMTABS'.
        <LS_COLUM>-R_COLUMN->SET_TECHNICAL( ABAP_FALSE ). "Ausblenden
        <LS_COLUM>-R_COLUMN->SET_VISIBLE( ABAP_FALSE ).
      WHEN OTHERS.
        <LS_COLUM>-R_COLUMN->SET_TECHNICAL( ABAP_FALSE ). "Ausblenden
        <LS_COLUM>-R_COLUMN->SET_VISIBLE( ABAP_TRUE ).
    ENDCASE.

  ENDLOOP.

* events
  LO_EVENTS = RO_ALV->GET_EVENT( ).
*  CREATE OBJECT lr_events._ticket_cn
  SET HANDLER LCL_EVENTS_INFO=>HANDLE_HOTSPOT_RECN   FOR LO_EVENTS. "HOTSPOT

*  SET HANDLER lcl_events=>handle_hotspot_clerk   FOR lo_events. "HOTSPOT
*  SET HANDLER lcl_events=>handle_hotspot_partner FOR lo_events. "HOTSPOT
*    SET HANDLER _on_double_click FOR lo_events ACTIVATION abap_true. "Double Click
** Top of Page für den Batch Lauf setzen, da dort USER-COMMAND aufgerufen wird
*    SET HANDLER _on_top_of_page_batch  FOR lo_events ACTIVATION abap_true. "Top of page
**... §6.1 register to the event USER_COMMAND
*    SET HANDLER _on_added_function FOR lo_events ACTIVATION abap_true. "User command

* Ausgabe ALV
  CALL METHOD RO_ALV->DISPLAY.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ON_HOTSPOT_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_PARTNER_PARTNER  text
*      -->P_COLUMN  text
*      -->P_ROW  text
*----------------------------------------------------------------------*
FORM ON_HOTSPOT_PARTNER  USING    P__PARTNER_PARTNER TYPE BU_PARTNER
                                  VALUE(P_COLUMN)
                                  VALUE(P_ROW).

  CHECK NOT GS_PARTNER-PARTNER IS INITIAL.

  CALL FUNCTION 'REBP_MAINTAIN_MAINTAIN'
    EXPORTING
*     IO_BUSOBJ  =
*     ID_BUKRS   =
      ID_PARTNER = GS_PARTNER-PARTNER
*     ID_VALIDFROM              =
*     ID_VALIDTO =
      ID_AKTYP   = '03'
*     ID_APPL    =
*     ID_OBJTYPE =
*     ID_OBJTYPEDIFF            = ' '
      ID_ROLE    = GS_PARTNER-ROLE
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
      BDT_ERROR  = 1
      OTHERS     = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ON_HOTSPOT_PARTNER_CLERK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_CLERK_PARTNER_CLERK  text
*      -->P_COLUMN  text
*      -->P_ROW  text
*----------------------------------------------------------------------*
FORM ON_HOTSPOT_PARTNER_CLERK  USING    P__PARTNER_PARTNER TYPE BU_PARTNER
                                  VALUE(P_COLUMN)
                                  VALUE(P_ROW).

  CHECK NOT GS_CLERK-PARTNER_CLERK IS INITIAL.

  CALL FUNCTION 'REBP_MAINTAIN_MAINTAIN'
    EXPORTING
*     IO_BUSOBJ  =
*     ID_BUKRS   =
      ID_PARTNER = GS_CLERK-PARTNER_CLERK
*     ID_VALIDFROM              =
*     ID_VALIDTO =
*     ID_AKTYP   = '03'
*     ID_APPL    =
*     ID_OBJTYPE =
*     ID_OBJTYPEDIFF            = ' '
      ID_ROLE    = GS_CLERK-ROLE
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
      BDT_ERROR  = 1
      OTHERS     = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ON_HOTSPOT_RECN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_RECN_INTRENO  text
*      -->P_COLUMN  text
*      -->P_ROW  text
*----------------------------------------------------------------------*
FORM ON_HOTSPOT_RECN  USING    P_GS_RECN_INTRENO TYPE VVINTRENO
                               P_COLUMN "       TYPE salv_de_row
                               P_ROW."       TYPE salv_de_column.

  CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
    EXPORTING
*     ID_ACTIVITY                = '03'
*     ID_OBJTYPE =
      ID_INTRENO = P_GS_RECN_INTRENO
*     ID_OBJNR   =
*     IF_LEAVE_CURRENT           = ABAP_FALSE
*     IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*     IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*     IS_NAVIGATION_DATA         =
    EXCEPTIONS
      ERROR      = 1
      OTHERS     = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_RE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_OBJEKT_PARTNER.
  DATA: LS_T001             TYPE T001,
        LS_VIBDBE           TYPE VIBDBE,
        LS_VIBDBU           TYPE VIBDBU,
        LS_VIBDRO           TYPE VIBDRO,
        LS_VICNCN           TYPE VICNCN,
        LT_VIBPOBJREL       TYPE TABLE OF VIBPOBJREL,
        LS_VIBPOBJREL       LIKE LINE OF LT_VIBPOBJREL,
        LT_VIBDOBJASS       TYPE TABLE OF VIBDOBJASS,
        LS_VIBDOBJASS       LIKE LINE OF LT_VIBDOBJASS,
        LT_IFLOT            TYPE TABLE OF IFLOT,
        LS_IFLOT            LIKE LINE OF LT_IFLOT,
        LS_PORTFOLIOT       TYPE ZTC_PORTFOLIOT,
        LS_RECP_PARTNER_C   TYPE RECP_PARTNER_C,
        LS_ROLE             TYPE REBPC_ROLE_X,
        LT_STATUS           TYPE  BAPI_RE_T_STATUS_INT,
        LS_STATUS           LIKE LINE OF LT_STATUS,
        LT_ZTHEIZUNG        TYPE TABLE OF ZTHEIZUNG,
        LS_ZTHEIZUNG        LIKE LINE OF LT_ZTHEIZUNG,
        LT_ZTHEIZ_ANGSL     TYPE TABLE OF ZTHEIZ_ANGSL,
        LT_ZTHEIZ_ANGSL_BAK TYPE TABLE OF ZTHEIZ_ANGSL,
        LS_ZTHEIZ_ANGSL     LIKE LINE OF LT_ZTHEIZ_ANGSL,
        LS_SELECT_X         TYPE ZST_HEIZUNG_SELX,
        LD_TABIX            TYPE SY-TABIX.
  DATA:
    LO_PARTNER       TYPE REF TO IF_REBP_PARTNER,
    LS_PARTNER       TYPE RECP_PARTNER_C,
    LT_PARTNER_BE    TYPE BAPI_RE_T_PARTNER_INT,
    LS_PARTNER_BE    LIKE LINE OF LT_PARTNER_BE,
    LT_TEL           TYPE TABLE OF BAPIADTEL,
    LS_TEL           TYPE BAPIADTEL,
    LS_ZRE_OBJEKT_ME TYPE ZRE_OBJEKT_ME,
    LT_RETURN        TYPE TABLE OF  BAPIRET2.
  DATA: LS_BUT000     TYPE BUT000,
        LT_BUT020     TYPE TABLE OF BUT020,
        LS_ADRC       TYPE ADRC,
        LT_ADRC       TYPE TABLE OF  ADRC,
        LS_TB008      TYPE TB008,
        LS_BUS000     TYPE BUS000,
        LS_BUS000_INT TYPE BUS000_INT,
        LS_BUS020_ADR TYPE BUS020_EXT,
        LS_BUS020_IND TYPE BUS020_EXT.
  DATA:
    LT_BAPIADTEL      LIKE BAPIADTEL  OCCURS 0 WITH HEADER LINE,
    LT_BAPIADSMTP     LIKE BAPIADSMTP OCCURS 0 WITH HEADER LINE,
    LS_BUS021         TYPE BUT021_FS,
    LS_BUT020         TYPE BUT020,
    LV_OBJ_ID         TYPE BAPI4002_1-OBJKEY,
    LV_OBJ_ID_EXT(70) TYPE C.
* Localle Datendeklaration
  DATA:
    L_TAB_HEIZUNG   TYPE  Z_T_ZTHEIZUNG,
    LS_HEIZUNG      LIKE LINE OF L_TAB_HEIZUNG,
    L_TAB_ANGSL     TYPE  Z_T_ZTHEIZ_ANGSL,
    LS_ANGSL        LIKE LINE OF L_TAB_ANGSL,
    L_TAB_AUSGSL    TYPE  Z_T_ZTHEIZ_AUSGSL,
    L_TAB_WWSP      TYPE  Z_T_ZTWARMWASSSP,
    L_TAB_WART      TYPE  Z_T_ZTWARTUNG,
    L_TAB_MESSWERT  TYPE  Z_T_ZTMESSWERT,
    L_TAB_WARTVERTR TYPE  Z_T_ZTWARTBEST,
    L_TAB_KUEVERTR  TYPE  Z_T_ZTWARTBEST,
    L_TAB_NOTE      TYPE  Z_T_ZST_HEIZUNG_NOTE,
    L_TAB_SENDFORM  TYPE  Z_T_ZTSENDFORM,
    L_TAB_ZAHLER    TYPE  Z_T_ZTZAHLER.
*------------------*
  IF  GX_KC->S_PARTNER IS INITIAL.
    RETURN.
  ENDIF.
  CLEAR GS_RECN.
  MOVE-CORRESPONDING GX_KC->S_PARTNER TO GS_RECN.
  MOVE-CORRESPONDING GX_KC->S_ZUSATZ TO GS_RECN.
  IF GD_TP_TXT IS INITIAL.
    GD_TP_TXT = 'Mietobj:'.
  ENDIF.
*  IF gx_kc->s_partner-partner IS INITIAL.
* ggf. aus Berechtigungsgründen keinen Partner gefunden
  SELECT * FROM VIBPOBJREL INTO TABLE LT_VIBPOBJREL
    WHERE INTRENO = GS_RECN-INTRENO.
  SORT LT_VIBPOBJREL BY VALIDTO DESCENDING.
  LOOP AT LT_VIBPOBJREL INTO LS_VIBPOBJREL
          WHERE ROLE = 'TR0600' OR
                ROLE = 'TR0603'.
* Partner über Klasse holen (Achtung Berechtigungsabfrage)
    CALL METHOD CL_RECP_MISC_BP=>GET_PARTNER
      EXPORTING
        ID_PARTNER  = LS_VIBPOBJREL-PARTNER
        ID_ROLE     = LS_VIBPOBJREL-ROLE
        ID_SUBROLE  = LS_VIBPOBJREL-SUBROLE
        ID_ADDRTYPE = LS_VIBPOBJREL-ADDRTYPE
        ID_SELDATE  = SY-DATUM
        ID_LANGU    = SY-LANGU
      IMPORTING
        ES_PARTNER  = LS_RECP_PARTNER_C.
* direktes Lesen der Telefonnummer
    IF LS_RECP_PARTNER_C-TEL_NUMBER IS INITIAL.
* Tabelle TB008 (GP-Rolle->Adressart): Einzelzugriff
      CALL FUNCTION 'BUP_TB008_SELECT_SINGLE'
        EXPORTING
          I_RLTYP = LS_VIBPOBJREL-ROLE
*         I_XDINP =
        IMPORTING
          E_TB008 = LS_TB008
        EXCEPTIONS
          OTHERS  = 0.
*Geschäftspartner: gepufferter Datenzugriff Tabelle BUT021_FS
      CALL FUNCTION 'FSBP_READ_BUT021_FS'
        EXPORTING
          I_PARTNER   = LS_VIBPOBJREL-PARTNER
          I_ADR_KIND  = LS_TB008-ADR_KIND
          I_DATE      = SY-DATUM
        IMPORTING
          E_BUT021_FS = LS_BUS021
        EXCEPTIONS
          OTHERS      = 0.
      IF SY-SUBRC = 0.
        SELECT SINGLE  * FROM BUT020 INTO LS_BUT020
         WHERE PARTNER = LS_VIBPOBJREL-PARTNER AND
               ADDRNUMBER = LS_BUS021-ADDRNUMBER.
        IF SY-SUBRC = 0.
          LV_OBJ_ID+0   = SY-MANDT.
          LV_OBJ_ID+3   = LS_BUT020-PARTNER.
          LV_OBJ_ID_EXT = LS_BUT020-ADDRESS_GUID.
        ENDIF.
        SELECT SINGLE * FROM BUT000 INTO LS_BUT000
          WHERE PARTNER = LS_VIBPOBJREL-PARTNER.
        IF SY-SUBRC = 0.
          IF LS_BUT000-TYPE NE 1.
            CALL FUNCTION 'BAPI_ADDRESSORG_GETDETAIL'
              EXPORTING
                OBJ_TYPE   = 'BUS1006' "Ownerobjekt zur Adresse
                OBJ_ID     = LV_OBJ_ID
                OBJ_ID_EXT = LV_OBJ_ID_EXT
*            IMPORTING
*               address_number       = lv_addrnumber
              TABLES
                BAPIADTEL  = LT_BAPIADTEL
                BAPIADSMTP = LT_BAPIADSMTP
                RETURN     = LT_RETURN.
          ELSE.
            CALL FUNCTION 'BAPI_ADDRESSPERS_GETDETAIL'
              EXPORTING
                OBJ_TYPE   = 'BUS1006' "Ownerobjekt zur Adresse
                OBJ_ID     = LV_OBJ_ID
                OBJ_ID_EXT = LV_OBJ_ID_EXT
                CONTEXT    = '4'
*            IMPORTING
*               address_number       = lv_addrnumber
              TABLES
                BAPIADTEL  = LT_BAPIADTEL
                BAPIADSMTP = LT_BAPIADSMTP
                RETURN     = LT_RETURN.
          ENDIF.
        ENDIF.
        LOOP AT LT_BAPIADTEL.
          LS_RECP_PARTNER_C-TEL_NUMBER = LT_BAPIADTEL-TEL_NO.
          EXIT.
        ENDLOOP.
        LOOP AT LT_BAPIADSMTP.
          LS_RECP_PARTNER_C-SMTP_ADDR = LT_BAPIADSMTP-E_MAIL.
        ENDLOOP.
      ENDIF.
    ENDIF.
* Daten übergeben
    GX_KC->S_PARTNER-TEL_NUMBER = LS_RECP_PARTNER_C-TEL_NUMBER.
    GX_KC->S_PARTNER-SMTP_ADDR = LS_RECP_PARTNER_C-SMTP_ADDR.
    GX_KC->S_PARTNER-PARTNER = LS_VIBPOBJREL-PARTNER.
    EXIT.
  ENDLOOP.
*  ENDIF.
* RE Objekte Kundendienststelle

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM ZRE_OBJEKT_ME INTO LS_ZRE_OBJEKT_ME
*    WHERE OBJNR_MO = GX_KC->S_PARTNER-MO_OBJNR.

SELECT * FROM ZRE_OBJEKT_ME INTO LS_ZRE_OBJEKT_ME UP TO 1 ROWS
 WHERE OBJNR_MO = GX_KC->S_PARTNER-MO_OBJNR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC = 0.
* Kundendienststelle
*    GS_RECN-KDST = LS_ZRE_OBJEKT_ME-KUNDEN_D_STELLE. " EF Anpassung an HANA
     GS_RECN-KDST = LS_ZRE_OBJEKT_ME-KDST_WE.          " EF Anpassung an HANA
  ENDIF.
*Buchungskreise
  SELECT SINGLE * FROM T001 INTO LS_T001
   WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS.
  IF SY-SUBRC NE 0.
    SELECT SINGLE * FROM T001 INTO LS_T001
    WHERE BUKRS = GX_KC->S_PARTNER-BUKRS.
  ENDIF.
  IF SY-SUBRC = 0.
    GS_RECN-BUTXT = LS_T001-BUTXT.
  ENDIF.
* Wirtschaftseinheit

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDBE INTO LS_VIBDBE
*    WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND
*          SWENR = GX_KC->S_ZUSATZ-SWENR.

SELECT * FROM VIBDBE INTO LS_VIBDBE UP TO 1 ROWS
 WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND SWENR = GX_KC->S_ZUSATZ-SWENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC NE 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*    SELECT SINGLE * FROM VIBDBE INTO LS_VIBDBE
*      WHERE BUKRS = GX_KC->S_PARTNER-BUKRS AND
*            SWENR = GX_KC->S_PARTNER-BENOCN.

SELECT * FROM VIBDBE INTO LS_VIBDBE UP TO 1 ROWS
 WHERE BUKRS = GX_KC->S_PARTNER-BUKRS AND SWENR = GX_KC->S_PARTNER-BENOCN
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  ENDIF.
  IF SY-SUBRC = 0.
    MOVE-CORRESPONDING LS_VIBDBE TO GS_RECN.
    GS_RECN-OBJNR_BE = LS_VIBDBE-OBJNR.
  ENDIF.

* Mietobjekt
  CLEAR LS_VIBDRO.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDRO INTO LS_VIBDRO
*    WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR.

SELECT * FROM VIBDRO INTO LS_VIBDRO UP TO 1 ROWS
 WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC = 0.
    GS_RECN-ZZPORTFOLIO = LS_VIBDRO-ZZPORTFOLIONAME.
    GS_RECN-OBJNR_RO = LS_VIBDRO-OBJNR.
    GS_RECN-SMENR = LS_VIBDRO-SMENR.
    GS_RECN-XMETXT = LS_VIBDRO-XMETXT.
    GS_RECN-SSTOCKW = LS_VIBDRO-SSTOCKW.
* Sprachtabelle zu Geschossen (TIV37)
    SELECT SINGLE XSTOCKL FROM TIV3G INTO GS_RECN-XSTOCKL
      WHERE SPRAS = SY-LANGU AND
            SSTOCKW = LS_VIBDRO-SSTOCKW.
    GS_RECN-RLGESCH = LS_VIBDRO-RLGESCH.
* Lage im Geschoß, Texte
    SELECT SINGLE XMLGESCH FROM TIV3H INTO GS_RECN-XMLGESCH
      WHERE SPRAS = SY-LANGU AND
            RLGESCH = LS_VIBDRO-RLGESCH.

    SHIFT GS_RECN-SMENR LEFT DELETING LEADING '0'.
* Technischer Platz holen
    REFRESH LT_VIBDOBJASS.
    SELECT * FROM VIBDOBJASS INTO TABLE LT_VIBDOBJASS
      WHERE OBJNRSRC = LS_VIBDRO-OBJNR AND
            OBJASSTYPE = '61'. "Zuordnung technischer Platz
    SORT LT_VIBDOBJASS BY VALIDTO DESCENDING.
    READ TABLE LT_VIBDOBJASS INTO LS_VIBDOBJASS INDEX 1.
    IF SY-SUBRC = 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*      SELECT SINGLE * FROM IFLOT INTO LS_IFLOT
*        WHERE OBJNR = LS_VIBDOBJASS-OBJNRTRG.

SELECT * FROM IFLOT INTO LS_IFLOT UP TO 1 ROWS
 WHERE OBJNR = LS_VIBDOBJASS-OBJNRTRG
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

      IF SY-SUBRC = 0.
        GD_OBJNR_TPL_RO = LS_IFLOT-TPLNR.
      ENDIF.
    ENDIF.
  ENDIF.

* Gebäude

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDBU INTO LS_VIBDBU
*    WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND
*          SWENR = GX_KC->S_ZUSATZ-SWENR AND
*          SGENR = GX_KC->S_ZUSATZ-SGENR.

SELECT * FROM VIBDBU INTO LS_VIBDBU UP TO 1 ROWS
 WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND SWENR = GX_KC->S_ZUSATZ-SWENR AND SGENR = GX_KC->S_ZUSATZ-SGENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC NE 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*    SELECT SINGLE * FROM VIBDBU INTO LS_VIBDBU
*  WHERE BUKRS = LS_VIBDRO-BUKRS AND
*        SWENR = LS_VIBDRO-SWENR AND
*        SGENR = LS_VIBDRO-SGENR.

SELECT * FROM VIBDBU INTO LS_VIBDBU UP TO 1 ROWS
 WHERE BUKRS = LS_VIBDRO-BUKRS AND SWENR = LS_VIBDRO-SWENR AND SGENR = LS_VIBDRO-SGENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  ENDIF.
  IF SY-SUBRC = 0.
    MOVE-CORRESPONDING LS_VIBDBU TO GS_RECN.
    GS_RECN-OBJNR_BU = LS_VIBDBU-OBJNR.
    IF NOT LS_VIBDBU-ZZSGEBT IS INITIAL.
      SELECT SINGLE XGEBK INTO GS_RECN-ZZSGEBT FROM TIV1B
        WHERE SPRAS = SY-LANGU AND
              SGEBT = LS_VIBDBU-ZZSGEBT.
    ENDIF.
* Technischer Platz holen
    REFRESH LT_VIBDOBJASS.
    SELECT * FROM VIBDOBJASS INTO TABLE LT_VIBDOBJASS
      WHERE OBJNRSRC = LS_VIBDBU-OBJNR AND
            OBJASSTYPE = '61'. "Zuordnung technischer Platz
    SORT LT_VIBDOBJASS BY VALIDTO DESCENDING.
    READ TABLE LT_VIBDOBJASS INTO LS_VIBDOBJASS INDEX 1.
    IF SY-SUBRC = 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*      SELECT SINGLE * FROM IFLOT INTO LS_IFLOT
*        WHERE OBJNR = LS_VIBDOBJASS-OBJNRTRG.

SELECT * FROM IFLOT INTO LS_IFLOT UP TO 1 ROWS
 WHERE OBJNR = LS_VIBDOBJASS-OBJNRTRG
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

      IF SY-SUBRC = 0.
        GD_OBJNR_TPL_BU = LS_IFLOT-TPLNR.
      ENDIF.
    ENDIF.
  ENDIF.
* Vertrag
  SELECT SINGLE * FROM VICNCN INTO LS_VICNCN
    WHERE INTRENO = GX_KC->S_PARTNER-INTRENO.
  IF SY-SUBRC = 0.
    MOVE-CORRESPONDING LS_VICNCN TO GS_RECN.
  ENDIF.
* Priorität
  GX_KC->S_ZUORDNUNG-PRIOK = 'N'. "Notdienst

  REFRESH: GT_CLERK, LT_PARTNER_BE.
  IF NOT LS_VIBDBE-INTRENO IS INITIAL.
* Wirtschattseinheit
    IF 1 = 1.
      SELECT * FROM VIBPOBJREL INTO TABLE LT_VIBPOBJREL
        WHERE INTRENO = LS_VIBDBE-INTRENO.
      LOOP AT LT_VIBPOBJREL INTO LS_VIBPOBJREL.
        CLEAR LS_PARTNER_BE.
        MOVE-CORRESPONDING LS_VIBPOBJREL TO LS_PARTNER_BE.
        APPEND LS_PARTNER_BE TO LT_PARTNER_BE.
      ENDLOOP.
    ELSE.
      CALL FUNCTION 'API_RE_BE_GET_DETAIL'
        EXPORTING
          ID_INTRENO          = LS_VIBDBE-INTRENO
          ID_DETAIL_DATA_FROM = SY-DATUM
          ID_DETAIL_DATA_TO   = SY-DATUM
        IMPORTING
          ET_PARTNER          = LT_PARTNER_BE
        EXCEPTIONS
          ERROR               = 1
          OTHERS              = 2.
    ENDIF.

    IF NOT LT_PARTNER_BE[] IS INITIAL.
* Mitarbeiter
      LOOP AT LT_PARTNER_BE INTO LS_PARTNER_BE.
        CLEAR GS_CLERK.
        MOVE-CORRESPONDING LS_PARTNER_BE TO GS_CLERK.
        GS_CLERK-PARTNER_CLERK = LS_PARTNER_BE-PARTNER.
        SELECT SINGLE RLTXT FROM TB003T INTO GS_CLERK-XNAME
        WHERE SPRAS = SY-LANGU AND
        ROLE = LS_PARTNER_BE-ROLE.
* Telefon
        IF 1 = 1.
          CALL METHOD CL_RECP_MISC_BP=>GET_PARTNER
            EXPORTING
              ID_PARTNER  = LS_PARTNER_BE-PARTNER
              ID_ROLE     = LS_PARTNER_BE-ROLE
              ID_SUBROLE  = LS_PARTNER_BE-SUBROLE
              ID_ADDRTYPE = LS_PARTNER_BE-ADDRTYPE
              ID_SELDATE  = SY-DATUM
              ID_LANGU    = SY-LANGU
            IMPORTING
              ES_PARTNER  = LS_RECP_PARTNER_C.
* direktes Lesen der Telefonnummer
*         IF ls_recp_partner_c-tel_number IS INITIAL
* Tabelle TB008 (GP-Rolle->Adressart): Einzelzugriff
          CALL FUNCTION 'BUP_TB008_SELECT_SINGLE'
            EXPORTING
              I_RLTYP = LS_PARTNER_BE-ROLE
*             I_XDINP =
            IMPORTING
              E_TB008 = LS_TB008
            EXCEPTIONS
              OTHERS  = 0.
*Geschäftspartner: gepufferter Datenzugriff Tabelle BUT021_FS
          CALL FUNCTION 'FSBP_READ_BUT021_FS'
            EXPORTING
              I_PARTNER   = LS_PARTNER_BE-PARTNER
              I_ADR_KIND  = LS_TB008-ADR_KIND
              I_DATE      = SY-DATUM
            IMPORTING
              E_BUT021_FS = LS_BUS021
            EXCEPTIONS
              OTHERS      = 0.
          IF SY-SUBRC = 0.
            SELECT SINGLE  * FROM BUT020 INTO LS_BUT020
             WHERE PARTNER = LS_PARTNER_BE-PARTNER AND
                   ADDRNUMBER = LS_BUS021-ADDRNUMBER.
            IF SY-SUBRC = 0.
              LV_OBJ_ID+0   = SY-MANDT.
              LV_OBJ_ID+3   = LS_BUT020-PARTNER.
              LV_OBJ_ID_EXT = LS_BUT020-ADDRESS_GUID.
            ENDIF.
            SELECT SINGLE * FROM BUT000 INTO LS_BUT000
              WHERE PARTNER = LS_PARTNER_BE-PARTNER.
            IF SY-SUBRC = 0.
              IF LS_BUT000-TYPE NE 1.
                CALL FUNCTION 'BAPI_ADDRESSORG_GETDETAIL'
                  EXPORTING
                    OBJ_TYPE   = 'BUS1006' "Ownerobjekt zur Adresse
                    OBJ_ID     = LV_OBJ_ID
                    OBJ_ID_EXT = LV_OBJ_ID_EXT
*            IMPORTING
*                   address_number       = lv_addrnumber
                  TABLES
                    BAPIADTEL  = LT_BAPIADTEL
                    BAPIADSMTP = LT_BAPIADSMTP
                    RETURN     = LT_RETURN.
              ELSE.
                CALL FUNCTION 'BAPI_ADDRESSPERS_GETDETAIL'
                  EXPORTING
                    OBJ_TYPE   = 'BUS1006' "Ownerobjekt zur Adresse
                    OBJ_ID     = LV_OBJ_ID
                    OBJ_ID_EXT = LV_OBJ_ID_EXT
                    CONTEXT    = '4'
*            IMPORTING
*                   address_number       = lv_addrnumber
                  TABLES
                    BAPIADTEL  = LT_BAPIADTEL
                    BAPIADSMTP = LT_BAPIADSMTP
                    RETURN     = LT_RETURN.
              ENDIF.
            ENDIF.
            LOOP AT LT_BAPIADTEL.
              IF LS_RECP_PARTNER_C-TEL_NUMBER IS INITIAL AND
                 LT_BAPIADTEL-STD_NO = ABAP_TRUE.
                LS_RECP_PARTNER_C-TEL_NUMBER = LT_BAPIADTEL-TEL_NO.
*                ls_recp_partner_c-yymob_number = lt_bapiadtel-yymob_number.
              ENDIF.
              IF LS_RECP_PARTNER_C-YYMOB_NUMBER IS INITIAL AND
                 LT_BAPIADTEL-STD_NO = ABAP_FALSE.
                LS_RECP_PARTNER_C-YYMOB_NUMBER = LT_BAPIADTEL-TEL_NO.
              ENDIF.
            ENDLOOP.
            LOOP AT LT_BAPIADSMTP.
              LS_RECP_PARTNER_C-SMTP_ADDR = LT_BAPIADSMTP-E_MAIL.
            ENDLOOP.
          ENDIF.
*          ENDIF.
* Daten übergeben
          GS_CLERK-YYMOB_NUMBER = LS_RECP_PARTNER_C-YYMOB_NUMBER.
          GS_CLERK-TELEFON = LS_RECP_PARTNER_C-TEL_NUMBER.
          GS_CLERK-SMTP_ADDR = LS_RECP_PARTNER_C-SMTP_ADDR.
          GS_CLERK-XNAME = LS_RECP_PARTNER_C-XNAME.
          CLEAR LS_ROLE.
          CALL METHOD CL_REBPC_ROLE=>GET_DETAIL_X
            EXPORTING
              ID_ROLE     = LS_PARTNER_BE-ROLE
              ID_LANGU    = SY-LANGU
            RECEIVING
              RS_DETAIL_X = LS_ROLE.
          GS_CLERK-RLTXT = LS_ROLE-RLTXT.
        ELSE.
          REFRESH LT_TEL.
          CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
            EXPORTING
              BUSINESSPARTNER       = LS_PARTNER_BE-PARTNER
              VALID_DATE            = SY-DATUM
            TABLES
              TELEFONDATANONADDRESS = LT_TEL
              RETURN                = LT_RETURN.
          .

          LOOP AT LT_TEL INTO LS_TEL.
            IF NOT GS_CLERK-TELEFON IS INITIAL.
              EXIT.
            ENDIF.
            CASE LS_TEL-R_3_USER .
              WHEN '1'.
                GS_CLERK-TELEFON = LS_TEL-TELEPHONE.
              WHEN '3'. "Mobile
                GS_CLERK-TELEFON  = LS_TEL-TELEPHONE.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.
        ENDIF.
        APPEND GS_CLERK TO GT_CLERK.
      ENDLOOP.
    ENDIF.
  ENDIF.
* Gebäude
  IF NOT LS_VIBDBU-INTRENO IS INITIAL.
* Gebäude
    CALL FUNCTION 'API_RE_BU_GET_DETAIL'
      EXPORTING
        ID_INTRENO          = LS_VIBDBU-INTRENO
        ID_DETAIL_DATA_FROM = SY-DATUM
        ID_DETAIL_DATA_TO   = SY-DATUM
      IMPORTING
        ET_STATUS           = LT_STATUS
      EXCEPTIONS
        ERROR               = 1
        OTHERS              = 2.
    IF SY-SUBRC = 0.
      READ TABLE  LT_STATUS INTO LS_STATUS WITH KEY STAT = 'E0011'
                                                    INACT = ''.
      IF SY-SUBRC = 0.
        GS_RECN-WEG = ABAP_TRUE.
      ENDIF.
    ENDIF.
*
    LS_SELECT_X-TAB_HEIZUNG = ABAP_TRUE.
    LS_SELECT_X-TAB_ANGSL = ABAP_TRUE.
    LS_SELECT_X-TAB_AUSGSL = ABAP_TRUE.
* Erst Heizung auf dem Mietobjekt lesen
    SELECT * FROM ZTHEIZUNG INTO TABLE LT_ZTHEIZUNG
      WHERE OBJNR = LS_VIBDRO-OBJNR.
*            anlagen_id = ls_vibdbu-sgenr.
    IF SY-SUBRC NE 0.
* Heizungdatenbank Anwendungstabelle
      SELECT * FROM ZTHEIZUNG INTO TABLE LT_ZTHEIZUNG
        WHERE OBJNR = LS_VIBDBU-OBJNR.

* Vielleicht ist das Gebäude eine angeschlossendes Objekt
      REFRESH LT_ZTHEIZ_ANGSL.
      SELECT * FROM ZTHEIZ_ANGSL INTO TABLE LT_ZTHEIZ_ANGSL_BAK
             WHERE "objnr = ls_vibdbu-objnr.
                   SWENR = LS_VIBDBU-SWENR AND
                   SGENR = LS_VIBDBU-SGENR.
      IF SY-SUBRC = 0.
* Angeschlossene RE-Objekte an Heizanlagen (Über Anlagen ID)
        SELECT * FROM ZTHEIZ_ANGSL INTO TABLE LT_ZTHEIZ_ANGSL
           FOR ALL ENTRIES IN LT_ZTHEIZ_ANGSL_BAK
           WHERE ANLAGEN_ID = LT_ZTHEIZ_ANGSL_BAK-ANLAGEN_ID.
        IF SY-SUBRC = 0.
          SELECT * FROM ZTHEIZUNG APPENDING TABLE LT_ZTHEIZUNG
              FOR ALL ENTRIES IN LT_ZTHEIZ_ANGSL
              WHERE KESSEL_GUID = LT_ZTHEIZ_ANGSL-KESSEL_GUID.
          SORT LT_ZTHEIZUNG BY KESSEL_GUID OBJNR.
          DELETE ADJACENT DUPLICATES FROM LT_ZTHEIZUNG COMPARING KESSEL_GUID OBJNR.
        ENDIF.
      ENDIF.
    ENDIF.
    REFRESH GT_KESSEL.
    LOOP AT LT_ZTHEIZUNG INTO LS_ZTHEIZUNG.
      CALL FUNCTION 'ZFB_API_HEIZUNG_GET_DETAIL'
        EXPORTING
          ID_ANLAGEN_ID = LS_ZTHEIZUNG-ANLAGEN_ID
          ID_STICHTAG   = SY-DATUM
          SELECT_X      = LS_SELECT_X
        IMPORTING
          TAB_HEIZUNG   = L_TAB_HEIZUNG
          TAB_ANGSL     = L_TAB_ANGSL
          TAB_AUSGSL    = L_TAB_AUSGSL
          TAB_WWSP      = L_TAB_WWSP
          TAB_WART      = L_TAB_WART
          TAB_MESSWERT  = L_TAB_MESSWERT
          TAB_WARTVERTR = L_TAB_WARTVERTR
          TAB_KUEVERTR  = L_TAB_KUEVERTR
          TAB_NOTE      = L_TAB_NOTE
          TAB_SENDFORM  = L_TAB_SENDFORM
          TAB_ZAHLER    = L_TAB_ZAHLER
        EXCEPTIONS
          ERROR         = 1
          OTHERS        = 2.
      IF SY-SUBRC NE 0.
        CONTINUE.
      ENDIF.
      READ TABLE L_TAB_HEIZUNG INTO  LS_HEIZUNG INDEX 1.
      IF SY-SUBRC = 0.
        MOVE-CORRESPONDING LS_HEIZUNG TO GS_HEIZUNG_DIALOG.
        SHIFT GS_HEIZUNG_DIALOG-SGENR LEFT DELETING LEADING '0'.

* Texttabelle für Versorgungsart
        SELECT SINGLE VERSARTBEZ FROM ZTVERSARTT INTO GS_HEIZUNG_DIALOG-VERSARTBEZ
          WHERE SPRAS = SY-LANGU AND
                VERSART = GS_HEIZUNG_DIALOG-VERSART.
* Texttabelle für Energieart
        SELECT SINGLE HEIZBAUARTBEZ FROM ZTCBAUARTT INTO GS_HEIZUNG_DIALOG-HEIZUNGSART_X
          WHERE SPRAS = SY-LANGU AND
                HEIZBAUART = GS_HEIZUNG_DIALOG-HEIZBAUART.

* Kessel angeschlossene Objekte
        LOOP AT L_TAB_ANGSL INTO LS_ANGSL.
          CLEAR GS_KESSEL.
          MOVE-CORRESPONDING LS_ANGSL TO GS_KESSEL.
          APPEND GS_KESSEL TO GT_KESSEL.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDIF.

* Anrede
  CALL FUNCTION 'ADDR_TSAD3T_READ'
    EXPORTING
      TITLE_KEY  = GX_KC->S_PARTNER-TITLE
      LANGUAGE   = SY-LANGU
    IMPORTING
      TITLE_TEXT = GS_RECN-TITLE_MEDI
    EXCEPTIONS
      OTHERS     = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BELEGUNG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_BELEGUNG_DATA .
  DATA: LO_BUSOBJ         TYPE REF TO IF_REBD_RENTAL_OBJECT,
        LO_OCCUPANCY_MNGR TYPE REF TO IF_REBD_OCCUPANCY_MNGR,
        LT_OCCUPANCY_X    TYPE RE_T_OCCUPANCY_X,
        LS_OCCUPANCY_X    LIKE LINE OF LT_OCCUPANCY_X,
        LS_VICNCN         TYPE VICNCN.
*-------------------*
*   2nd: try ID_OBJNR
  GS_RECN-OBJNR_RO = GX_KC->S_PARTNER-MO_OBJNR.
  IF GS_RECN-OBJNR_RO IS INITIAL.
    RETURN.
  ENDIF.

  CALL METHOD CF_REBD_RENTAL_OBJECT=>FIND_BY_OBJNR
    EXPORTING
      ID_OBJNR       = GS_RECN-OBJNR_RO
      ID_ACTIVITY    = '03'
      IF_AUTH_CHECK  = ABAP_TRUE
      IF_ENQUEUE     = ABAP_TRUE
      IF_USE_ARCHIVE = ABAP_TRUE
    RECEIVING
      RO_INSTANCE    = LO_BUSOBJ
    EXCEPTIONS
      ERROR          = 1
      OTHERS         = 2.

  IF SY-SUBRC = 0.
    REFRESH: LT_OCCUPANCY_X, GT_OCCUPANCY.
    CALL METHOD LO_BUSOBJ->GET_OCCUPANCY_MNGR
      RECEIVING
        RO_OCCUPANCY_MNGR = LO_OCCUPANCY_MNGR.

    CALL METHOD LO_OCCUPANCY_MNGR->GET_LIST_X
      IMPORTING
        ET_LIST_X = LT_OCCUPANCY_X.
    LOOP AT LT_OCCUPANCY_X INTO LS_OCCUPANCY_X.
      CLEAR GS_OCCUPANCY.
      MOVE-CORRESPONDING LS_OCCUPANCY_X TO  GS_OCCUPANCY.
* Mietobjekt
      SHIFT LS_OCCUPANCY_X-SWENR LEFT DELETING LEADING '0'.
      SHIFT LS_OCCUPANCY_X-SMENR LEFT DELETING LEADING '0'.
      CONCATENATE LS_OCCUPANCY_X-BUKRS LS_OCCUPANCY_X-SWENR LS_OCCUPANCY_X-SMENR INTO
      GS_OCCUPANCY-IDENTKEY_RO SEPARATED BY '/'.
      GS_OCCUPANCY-OBJNR_RO = LS_OCCUPANCY_X-OBJNR.
* Vertrag
      IF LS_OCCUPANCY_X-OCCRECNNR IS INITIAL.
        GS_OCCUPANCY-IDENTKEY_CN = 'Leestand'.
      ELSE.
* Vertragstext holen

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*        SELECT SINGLE * FROM VICNCN INTO LS_VICNCN
*          WHERE BUKRS = LS_OCCUPANCY_X-OCCCNBUKRS AND
*                RECNNR = LS_OCCUPANCY_X-OCCRECNNR.

SELECT * FROM VICNCN INTO LS_VICNCN UP TO 1 ROWS
 WHERE BUKRS = LS_OCCUPANCY_X-OCCCNBUKRS AND RECNNR = LS_OCCUPANCY_X-OCCRECNNR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

        IF SY-SUBRC = 0.
          GS_OCCUPANCY-RECNTXT = LS_VICNCN-RECNTXT.
          GS_OCCUPANCY-OBJNR_CN = LS_VICNCN-OBJNR.
        ELSE.
*          CONTINUE.
        ENDIF.
        SHIFT LS_OCCUPANCY_X-OCCRECNNR LEFT DELETING LEADING '0'.
        CONCATENATE LS_OCCUPANCY_X-OCCCNBUKRS LS_OCCUPANCY_X-OCCRECNNR INTO
        GS_OCCUPANCY-IDENTKEY_CN SEPARATED BY '/'.
      ENDIF.
      APPEND GS_OCCUPANCY TO GT_OCCUPANCY.
    ENDLOOP.
* Daten global übergeben
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_WARTUNG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_WARTUNG_DATA .
  DATA:
    LO_BUSOBJ           TYPE REF TO IF_RECA_BUS_OBJECT,
    LT_OBJNR            TYPE RE_T_OBJNR,
    LT_WARTBEST_UEB     TYPE Z_T_WARTBEST_UEB,
    LS_WARTBEST_UEB     LIKE LINE OF LT_WARTBEST_UEB,
    LS_VIBDRO           TYPE VIBDRO,
    LD_SWENR            TYPE SWENR,
    LD_SGENR            TYPE SGENR,
    LT_VIBDBU           TYPE TABLE OF VIBDBU,
    LS_VIBDBU           TYPE VIBDBU,
    LS_VIBDBE           TYPE  VIBDBE,
    LT_ZTHEIZ_ANGSL     TYPE TABLE OF ZTHEIZ_ANGSL,
    LT_ZTHEIZ_ANGSL_BAK TYPE TABLE OF ZTHEIZ_ANGSL,
    LS_ZTHEIZ_ANGSL     LIKE LINE OF LT_ZTHEIZ_ANGSL.
*-----------------------------------*
  REFRESH: GT_WARTUNG, GT_WARTUNG_GEB.
  IF GX_KC->S_PARTNER-MO_OBJNR IS INITIAL.
    RETURN.
  ENDIF.
  REFRESH LT_OBJNR.
  APPEND GX_KC->S_PARTNER-MO_OBJNR TO LT_OBJNR.
* Wartungsverträge Mietobjekt
  CALL METHOD ZCL_PD_WARTBEST_SERVICES=>GET_WARTBEST_REOBJ
    EXPORTING
      IT_OBJNR        = LT_OBJNR
    RECEIVING
      ET_WARTBEST_UEB = LT_WARTBEST_UEB.
* Keine alten oder gelöschen Wartungspläne
  DELETE LT_WARTBEST_UEB WHERE EREKZ = ABAP_TRUE.
  DELETE LT_WARTBEST_UEB WHERE LOEKZ NE ABAP_FALSE.
  SORT LT_WARTBEST_UEB BY XWARTUNGSART EBELN EBELP.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDRO INTO LS_VIBDRO
*    WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR.

SELECT * FROM VIBDRO INTO LS_VIBDRO UP TO 1 ROWS
 WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC = 0.
    LOOP AT LT_WARTBEST_UEB INTO LS_WARTBEST_UEB.
      CLEAR GS_WARTUNG.
      SHIFT LS_VIBDRO-SWENR LEFT DELETING LEADING '0'.
      SHIFT LS_VIBDRO-SMENR LEFT DELETING LEADING '0'.
      CONCATENATE LS_VIBDRO-BUKRS LS_VIBDRO-SWENR LS_VIBDRO-SMENR INTO
      GS_WARTUNG-IDENTKEY_RO SEPARATED BY '/'.
      MOVE-CORRESPONDING LS_WARTBEST_UEB TO GS_WARTUNG.
      APPEND GS_WARTUNG TO GT_WARTUNG.
    ENDLOOP.
  ENDIF.

* Wirtschaftseinheit
  IF 1 = 2.
* wird über Bestellungsart LB abgebildet

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*    SELECT SINGLE * FROM VIBDBE INTO LS_VIBDBE
*      WHERE BUKRS = LS_VIBDRO-BUKRS AND
*            SWENR = LS_VIBDRO-SWENR.

SELECT * FROM VIBDBE INTO LS_VIBDBE UP TO 1 ROWS
 WHERE BUKRS = LS_VIBDRO-BUKRS AND SWENR = LS_VIBDRO-SWENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

    IF SY-SUBRC = 0.
      REFRESH: LT_OBJNR, LT_WARTBEST_UEB.
      APPEND LS_VIBDBE-OBJNR TO LT_OBJNR.
* Wartungsverträge Wirtschaftseinheit
      CALL METHOD ZCL_PD_WARTBEST_SERVICES=>GET_WARTBEST_REOBJ
        EXPORTING
          IT_OBJNR        = LT_OBJNR
        RECEIVING
          ET_WARTBEST_UEB = LT_WARTBEST_UEB.
* Keine alten oder gelöschen Wartungspläne
      DELETE LT_WARTBEST_UEB WHERE EREKZ = ABAP_TRUE.
      DELETE LT_WARTBEST_UEB WHERE LOEKZ NE ABAP_FALSE.

      SORT LT_WARTBEST_UEB BY XWARTUNGSART EBELN EBELP.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*      SELECT SINGLE * FROM VIBDRO INTO LS_VIBDRO
*        WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR.

SELECT * FROM VIBDRO INTO LS_VIBDRO UP TO 1 ROWS
 WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

      IF SY-SUBRC = 0.
        LOOP AT LT_WARTBEST_UEB INTO LS_WARTBEST_UEB.
          CLEAR GS_WARTUNG_WE.
          SHIFT LS_VIBDRO-SWENR LEFT DELETING LEADING '0'.
          CONCATENATE LS_VIBDRO-BUKRS LS_VIBDRO-SWENR INTO
          GS_WARTUNG_WE-IDENTKEY_WE SEPARATED BY '/'.
          MOVE-CORRESPONDING LS_WARTBEST_UEB TO GS_WARTUNG_WE.
          " E.Firsanov get Kommunikationsdaten zum Lieferant
          ZCL_INFOCOCKPIT_SERVICES=>GET_KOMMUNIKDATEN_LIEFERANT(
            EXPORTING
              ID_LIFNR     = GS_WARTUNG_WE-LIFNR
            IMPORTING
              ED_TELF1     = GS_WARTUNG_WE-TELF1
              ED_TELFX     = GS_WARTUNG_WE-TELFX
              ED_SMTP_ADDR = GS_WARTUNG_WE-SMTP_ADDR
                 ).

          APPEND GS_WARTUNG_WE TO GT_WARTUNG_WE.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
* Gebäude
  LD_SWENR = LS_VIBDRO-SWENR.
  LD_SGENR = LS_VIBDRO-SGENR.
* Konvertierungs-Exit ALPHA, extern->intern
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT  = LD_SWENR
    IMPORTING
      OUTPUT = LD_SWENR.
* Konvertierungs-Exit ALPHA, extern->intern
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      INPUT  = LD_SGENR
    IMPORTING
      OUTPUT = LD_SGENR.
* Gebäude
  SELECT * FROM VIBDBU INTO TABLE LT_VIBDBU
    WHERE "bukrs = ls_vibdro-bukrs AND
          SWENR = LD_SWENR AND
          SGENR = LD_SGENR.
  IF SY-SUBRC = 0.
* Gebäude Objnr speichern
    REFRESH LT_OBJNR.
    LOOP AT LT_VIBDBU INTO LS_VIBDBU.
      COLLECT LS_VIBDBU-OBJNR INTO LT_OBJNR.
    ENDLOOP.
* Prüfen, ob es angeschlossene Objekte gibt. (Über Objektnummer)
    SELECT * FROM ZTHEIZ_ANGSL INTO TABLE LT_ZTHEIZ_ANGSL_BAK
      FOR ALL ENTRIES IN LT_VIBDBU
      WHERE OBJNR = LT_VIBDBU-OBJNR.
    IF SY-SUBRC = 0.
* Angeschlossene RE-Objekte an Heizanlagen (Über Anlagen ID)
      SELECT * FROM ZTHEIZ_ANGSL INTO TABLE LT_ZTHEIZ_ANGSL
         FOR ALL ENTRIES IN LT_ZTHEIZ_ANGSL_BAK
         WHERE ANLAGEN_ID = LT_ZTHEIZ_ANGSL_BAK-ANLAGEN_ID.
      IF SY-SUBRC = 0.
        REFRESH LT_VIBDBU.
        LOOP AT LT_ZTHEIZ_ANGSL INTO LS_ZTHEIZ_ANGSL.
          COLLECT LS_ZTHEIZ_ANGSL-OBJNR INTO LT_OBJNR.
        ENDLOOP.
      ENDIF.
    ENDIF.
* Wartungsverträge Gebäude
    CALL METHOD ZCL_PD_WARTBEST_SERVICES=>GET_WARTBEST_REOBJ
      EXPORTING
        IT_OBJNR        = LT_OBJNR
      RECEIVING
        ET_WARTBEST_UEB = LT_WARTBEST_UEB.
* Keine alten oder gelöschen Wartungspläne
    DELETE LT_WARTBEST_UEB WHERE EREKZ = ABAP_TRUE.
    DELETE LT_WARTBEST_UEB WHERE LOEKZ NE ABAP_FALSE.
    SORT LT_WARTBEST_UEB BY XWARTUNGSART EBELN EBELP.
    LOOP AT LT_WARTBEST_UEB INTO LS_WARTBEST_UEB.
      CLEAR GS_WARTUNG_GEB.
      SHIFT LS_WARTBEST_UEB-SWENR LEFT DELETING LEADING '0'.
      SHIFT LS_WARTBEST_UEB-SGENR LEFT DELETING LEADING '0'.
      CONCATENATE LS_WARTBEST_UEB-BUKRS LS_WARTBEST_UEB-SWENR LS_WARTBEST_UEB-SGENR INTO
      GS_WARTUNG_GEB-IDENTKEY_BU SEPARATED BY '/'.
      MOVE-CORRESPONDING LS_WARTBEST_UEB TO GS_WARTUNG_GEB.

      " E.Firsanov get Kommunikationsdaten zum Lieferant
      ZCL_INFOCOCKPIT_SERVICES=>GET_KOMMUNIKDATEN_LIEFERANT(
        EXPORTING
          ID_LIFNR     = GS_WARTUNG_GEB-LIFNR
        IMPORTING
          ED_TELF1     = GS_WARTUNG_GEB-TELF1
          ED_TELFX     = GS_WARTUNG_GEB-TELFX
          ED_SMTP_ADDR = GS_WARTUNG_GEB-SMTP_ADDR
             ).

      APPEND GS_WARTUNG_GEB TO GT_WARTUNG_GEB.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_NOTDIENST_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_NOTDIENST_DATA .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ON_HOTSPOT_OBJNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_OCCUPANCY_OBJNR_RO  text
*      -->P_COLUMN  text
*      -->P_ROW  text
*----------------------------------------------------------------------*
FORM ON_HOTSPOT_OBJNR  USING    P_GS_OCCUPANCY_OBJNR_RO
                                P_COLUMN
                                P_ROW.
  CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
    EXPORTING
*     ID_ACTIVITY                = '03'
*     ID_OBJTYPE =
*     id_intreno = p_gs_recn_intreno
      ID_OBJNR = P_GS_OCCUPANCY_OBJNR_RO
*     IF_LEAVE_CURRENT           = ABAP_FALSE
*     IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*     IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*     IS_NAVIGATION_DATA         =
    EXCEPTIONS
      ERROR    = 1
      OTHERS   = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CHARACT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_CHARACT .
  DATA: LS_VIBDBU       TYPE VIBDBU,
        LS_VIBDRO       TYPE VIBDRO,
        LS_VIBDBE       TYPE VIBDBE,
        LO_BUSOBJ       TYPE REF TO IF_REBD_BUILDING,
        LO_BUSOBJ_RO    TYPE REF TO IF_REBD_RENTAL_OBJECT,
        LO_CHARACT_MNGR TYPE REF TO IF_REBD_CHARACT_MNGR,
        LT_CHARACT_X    TYPE  RE_T_CHARACT_X,
        LS_CHARACT_X    LIKE LINE OF LT_CHARACT_X.
*-------------------*
* Ausstattungsmerkmale
  IF GS_RECN-BUKRS IS INITIAL.
    RETURN.
  ENDIF.
* Wirtschaftseinheit

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDBE INTO LS_VIBDBE
*    WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND
*          SWENR = GX_KC->S_ZUSATZ-SWENR.

SELECT * FROM VIBDBE INTO LS_VIBDBE UP TO 1 ROWS
 WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND SWENR = GX_KC->S_ZUSATZ-SWENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC = 0.
    CALL METHOD CF_REBD_BUILDING=>FIND_BY_OBJNR
      EXPORTING
        ID_OBJNR       = LS_VIBDBE-OBJNR
        ID_ACTIVITY    = '03'
        IF_AUTH_CHECK  = ABAP_TRUE
        IF_ENQUEUE     = ABAP_TRUE
        IF_USE_ARCHIVE = ABAP_TRUE
      RECEIVING
        RO_INSTANCE    = LO_BUSOBJ
      EXCEPTIONS
        ERROR          = 1
        OTHERS         = 2.

    IF SY-SUBRC = 0.
      REFRESH: LT_CHARACT_X, GT_CHARACT.
      CALL METHOD LO_BUSOBJ->GET_CHARACT_MNGR
        RECEIVING
          RO_CHARACT_MNGR = LO_CHARACT_MNGR.

      CALL METHOD LO_CHARACT_MNGR->GET_LIST_X
        IMPORTING
          ET_LIST_X = LT_CHARACT_X.
      LOOP AT LT_CHARACT_X INTO LS_CHARACT_X.
        CLEAR GS_CHARACT.
        MOVE-CORRESPONDING LS_CHARACT_X TO GS_CHARACT.
* Objektidenfikation
        SHIFT LS_VIBDBE-SWENR LEFT DELETING LEADING '0'.
        CONCATENATE LS_VIBDBU-BUKRS LS_VIBDBE-SWENR INTO
                    GS_CHARACT-IDENTKEY_BU SEPARATED BY '/'.
        APPEND GS_CHARACT TO GT_CHARACT_BE.
* Aufzug vorhanden?
        IF LS_CHARACT_X-FIXFITCHARACT = '455'. "Personenaufzug
          GS_RECN-AUFZUG = ABAP_TRUE.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

* Gebäude

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDBU INTO LS_VIBDBU
*    WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND
*          SWENR = GX_KC->S_ZUSATZ-SWENR AND
*          SGENR = GX_KC->S_ZUSATZ-SGENR.

SELECT * FROM VIBDBU INTO LS_VIBDBU UP TO 1 ROWS
 WHERE BUKRS = GX_KC->S_ZUSATZ-BUKRS AND SWENR = GX_KC->S_ZUSATZ-SWENR AND SGENR = GX_KC->S_ZUSATZ-SGENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC = 0.
    CALL METHOD CF_REBD_BUILDING=>FIND_BY_OBJNR
      EXPORTING
        ID_OBJNR       = LS_VIBDBU-OBJNR
        ID_ACTIVITY    = '03'
        IF_AUTH_CHECK  = ABAP_TRUE
        IF_ENQUEUE     = ABAP_TRUE
        IF_USE_ARCHIVE = ABAP_TRUE
      RECEIVING
        RO_INSTANCE    = LO_BUSOBJ
      EXCEPTIONS
        ERROR          = 1
        OTHERS         = 2.

    IF SY-SUBRC = 0.
      REFRESH: LT_CHARACT_X, GT_CHARACT.
      CALL METHOD LO_BUSOBJ->GET_CHARACT_MNGR
        RECEIVING
          RO_CHARACT_MNGR = LO_CHARACT_MNGR.

      CALL METHOD LO_CHARACT_MNGR->GET_LIST_X
        IMPORTING
          ET_LIST_X = LT_CHARACT_X.
      LOOP AT LT_CHARACT_X INTO LS_CHARACT_X.
        CLEAR GS_CHARACT.
        MOVE-CORRESPONDING LS_CHARACT_X TO GS_CHARACT.
* Objektidenfikation
        SHIFT LS_VIBDBU-SWENR LEFT DELETING LEADING '0'.
        SHIFT LS_VIBDBU-SGENR LEFT DELETING LEADING '0'.
        CONCATENATE LS_VIBDBU-BUKRS LS_VIBDBU-SWENR LS_VIBDBU-SGENR INTO
                    GS_CHARACT-IDENTKEY_BU SEPARATED BY '/'.
        APPEND GS_CHARACT TO GT_CHARACT.
* Aufzug vorhanden?
        IF LS_CHARACT_X-FIXFITCHARACT = '455'. "Personenaufzug
          GS_RECN-AUFZUG = ABAP_TRUE.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

* Ausstattungsmerkmale Mietobjekt

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*  SELECT SINGLE * FROM VIBDRO INTO LS_VIBDRO
*    WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR.

SELECT * FROM VIBDRO INTO LS_VIBDRO UP TO 1 ROWS
 WHERE OBJNR = GX_KC->S_PARTNER-MO_OBJNR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

  IF SY-SUBRC = 0.
    CALL METHOD CF_REBD_RENTAL_OBJECT=>FIND_BY_OBJNR
      EXPORTING
        ID_OBJNR       = LS_VIBDRO-OBJNR
        ID_ACTIVITY    = '03'
        IF_AUTH_CHECK  = ABAP_TRUE
        IF_ENQUEUE     = ABAP_TRUE
        IF_USE_ARCHIVE = ABAP_TRUE
      RECEIVING
        RO_INSTANCE    = LO_BUSOBJ_RO
      EXCEPTIONS
        ERROR          = 1
        OTHERS         = 2.

    IF SY-SUBRC = 0.
      REFRESH: LT_CHARACT_X, GT_CHARACT_RO.
      CALL METHOD LO_BUSOBJ_RO->GET_CHARACT_MNGR
        RECEIVING
          RO_CHARACT_MNGR = LO_CHARACT_MNGR.

      CALL METHOD LO_CHARACT_MNGR->GET_LIST_X
        IMPORTING
          ET_LIST_X = LT_CHARACT_X.
      LOOP AT LT_CHARACT_X INTO LS_CHARACT_X.
        CLEAR GS_CHARACT_RO.
        MOVE-CORRESPONDING LS_CHARACT_X TO GS_CHARACT_RO.
* Objektidenfikation
        SHIFT LS_VIBDRO-SWENR LEFT DELETING LEADING '0'.
        SHIFT LS_VIBDRO-SGENR LEFT DELETING LEADING '0'.
        SHIFT LS_VIBDRO-SMENR LEFT DELETING LEADING '0'.
        CONCATENATE LS_VIBDRO-BUKRS LS_VIBDRO-SWENR LS_VIBDRO-SMENR INTO
                    GS_CHARACT_RO-IDENTKEY_RO SEPARATED BY '/'.
        APPEND GS_CHARACT_RO TO GT_CHARACT_RO.
* Aufzug vorhanden?
        IF LS_CHARACT_X-FIXFITCHARACT = '455'. "Personenaufzug
          GS_RECN-AUFZUG = ABAP_TRUE.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_RO_SGENR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_RO_SGENR .
  DATA: LT_VIBDRO      TYPE TABLE OF VIBDRO,
        LS_VIBDRO      LIKE LINE OF LT_VIBDRO,
        LT_VIBDOBJASS  TYPE TABLE OF VIBDOBJASS,
        LS_VIBDOBJASS  TYPE VIBDOBJASS,
        LT_VIBDMEAS    TYPE TABLE OF VIBDMEAS,
        LS_VIBDMEAS    LIKE LINE OF LT_VIBDMEAS,
        LT_VIBDCHARACT TYPE TABLE OF VIBDCHARACT,
        LS_VIBDCHARACT LIKE LINE OF LT_VIBDCHARACT,
        LT_VICNCN      TYPE TABLE OF VICNCN,
        LS_VICNCN      LIKE LINE OF LT_VICNCN,
        LT_REEXKUNNRCN TYPE TABLE OF V_REEXKUNNRCN,
        LS_REEXKUNNRCN LIKE LINE OF LT_REEXKUNNRCN,
        LT_BUT000      TYPE TABLE OF BUT000,
        LS_BUT000      TYPE BUT000.
  DATA:
    LO_PARTNER      TYPE REF TO IF_REBP_PARTNER,
    LS_MAIL_ADDRESS TYPE RECACOMMMAILPAR,
    LS_TEL_ADDRESS  TYPE RECACOMMTELPAR,
    LS_FAX_ADDRESS  TYPE RECACOMMFAXPAR.

  FIELD-SYMBOLS: <RO> LIKE GS_RO.
*-------------------------------*
  IF GS_RECN-BUKRS IS INITIAL.
    RETURN.
  ENDIF.
* Gebäude
  SELECT * FROM VIBDRO INTO TABLE LT_VIBDRO
    WHERE BUKRS = GS_RECN-BUKRS AND
          SWENR = GS_RECN-SWENR AND
          SGENR = GS_RECN-SGENR.
  IF SY-SUBRC = 0.
* Verträge holen
    REFRESH LT_VIBDOBJASS.
    SELECT * FROM VIBDOBJASS INTO TABLE LT_VIBDOBJASS
          FOR ALL ENTRIES IN LT_VIBDRO
    WHERE OBJNRTRG = LT_VIBDRO-OBJNR AND
       OBJASSTYPE = '10'."Vertrag => Objekt(gruppe)
    DELETE LT_VIBDOBJASS WHERE VALIDFROM GT SY-DATUM.
    DELETE LT_VIBDOBJASS WHERE VALIDTO LT SY-DATUM.
    IF NOT LT_VIBDOBJASS[] IS INITIAL.
      SELECT * FROM VICNCN INTO TABLE LT_VICNCN
            FOR ALL ENTRIES IN LT_VIBDOBJASS WHERE
                OBJNR = LT_VIBDOBJASS-OBJNRSRC.
      DELETE LT_VICNCN WHERE RECNENDABS LE SY-DATUM.
    ENDIF.
* Fläche holen
    SELECT * FROM VIBDMEAS INTO TABLE LT_VIBDMEAS
        FOR ALL ENTRIES IN LT_VIBDRO
      WHERE INTRENO = LT_VIBDRO-INTRENO.
    DELETE  LT_VIBDMEAS WHERE MEAS NE '0002'. "Wohnfläche
    SORT  LT_VIBDMEAS BY INTRENO MEAS VALIDTO DESCENDING.
    DELETE ADJACENT DUPLICATES FROM LT_VIBDMEAS COMPARING INTRENO MEAS.
* Ausstattungsmerkmale
    SELECT * FROM VIBDCHARACT INTO TABLE LT_VIBDCHARACT
    FOR ALL ENTRIES IN LT_VIBDRO
  WHERE INTRENO = LT_VIBDRO-INTRENO.
    DELETE  LT_VIBDCHARACT WHERE FIXFITCHARACT NE 'ROOM56'. "Keller
    SORT  LT_VIBDCHARACT BY INTRENO FIXFITCHARACT VALIDTO DESCENDING.
    DELETE ADJACENT DUPLICATES FROM LT_VIBDCHARACT COMPARING INTRENO FIXFITCHARACT.
* Sortierung für binary search
    SORT LT_VIBDMEAS BY INTRENO.
    SORT LT_VIBDCHARACT BY INTRENO.
    SORT LT_VIBDOBJASS BY OBJNRTRG.
    SORT LT_VICNCN BY OBJNR.
* Mieteinheiten pro Gebäude
    CLEAR GS_RO-OBJNR_CN.
    LOOP AT LT_VIBDRO INTO LS_VIBDRO.
      CLEAR GS_RO.
* Mietobjekt
      SHIFT LS_VIBDRO-SWENR LEFT DELETING LEADING '0'.
      SHIFT LS_VIBDRO-SMENR LEFT DELETING LEADING '0'.
      CONCATENATE LS_VIBDRO-BUKRS LS_VIBDRO-SWENR LS_VIBDRO-SMENR INTO
      GS_RO-IDENTKEY_RO_RO SEPARATED BY '/'.
      GS_RO-XMETXT = LS_VIBDRO-XMETXT.
      GS_RO-OBJNR_RO = LS_VIBDRO-OBJNR.
      GS_RO-KELLERNR =  LS_VIBDRO-ZZUSR07.
      GS_RO-SSTOCKW = LS_VIBDRO-SSTOCKW.
* Sprachtabelle zu Geschossen (TIV37)
      SELECT SINGLE XSTOCKL FROM TIV3G INTO GS_RO-XSTOCKL
        WHERE SPRAS = SY-LANGU AND
              SSTOCKW = LS_VIBDRO-SSTOCKW.
      GS_RO-RLGESCH = LS_VIBDRO-RLGESCH.
* Lage im Geschoß, Texte
      SELECT SINGLE XMLGESCH FROM TIV3H INTO GS_RO-XMLGESCH
        WHERE SPRAS = SY-LANGU AND
              RLGESCH = LS_VIBDRO-RLGESCH.
      LOOP AT LT_VIBDOBJASS INTO LS_VIBDOBJASS WHERE
             OBJNRTRG =  LS_VIBDRO-OBJNR AND
             VALIDTO GT SY-DATUM.
* Vertag übergeben
        READ TABLE LT_VICNCN INTO LS_VICNCN WITH KEY
        OBJNR = LS_VIBDOBJASS-OBJNRSRC BINARY SEARCH.
        IF SY-SUBRC = 0.
          GS_RO-RECNTXT = LS_VICNCN-RECNTXT.
          CONCATENATE LS_VICNCN-BUKRS LS_VICNCN-RECNNR INTO
         GS_RO-IDENTKEY_CN_RO SEPARATED BY '/'.
          GS_RO-OBJNR_CN = LS_VICNCN-OBJNR.
          GS_RO-INTRENO_CN = LS_VICNCN-INTRENO.
          GS_RO-RECNBEG = LS_VICNCN-RECNBEG.
          GS_RO-RECNENDABS = LS_VICNCN-RECNENDABS.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF SY-SUBRC NE 0 OR GS_RO-OBJNR_CN IS INITIAL.
* Kein Mietvertrag->Leerstand
        GS_RO-IDENTKEY_CN_RO = 'Leerstand'.
      ENDIF.
* Fläche
      READ TABLE LT_VIBDMEAS INTO LS_VIBDMEAS
      WITH KEY INTRENO =  LS_VIBDRO-INTRENO BINARY SEARCH.
      IF SY-SUBRC = 0.
        GS_RO-MEASVALUE =  LS_VIBDMEAS-MEASVALUE.
      ENDIF.
* Objekt im Gebäude speichern
      APPEND GS_RO TO GT_RO.
    ENDLOOP.
* Name holen
    IF NOT LT_VICNCN[] IS INITIAL.
      SELECT * FROM V_REEXKUNNRCN INTO TABLE LT_REEXKUNNRCN
    FOR ALL ENTRIES IN LT_VICNCN
         WHERE INTRENO = LT_VICNCN-INTRENO.
      IF SY-SUBRC = 0.
        SELECT * FROM BUT000 INTO TABLE LT_BUT000
         FOR ALL ENTRIES IN LT_REEXKUNNRCN
         WHERE PARTNER = LT_REEXKUNNRCN-PARTNER.

        SORT LT_BUT000 BY PARTNER.
* Daten zusammenfügen
        LOOP AT GT_RO ASSIGNING <RO> WHERE
          OBJNR_CN IS NOT INITIAL.
          READ TABLE LT_REEXKUNNRCN INTO LS_REEXKUNNRCN
          WITH KEY INTRENO = <RO>-INTRENO_CN.
          IF SY-SUBRC = 0.
* Partner holen
            READ TABLE LT_BUT000 INTO LS_BUT000 WITH KEY
             PARTNER = LS_REEXKUNNRCN-PARTNER BINARY SEARCH.
            IF SY-SUBRC = 0.
              IF NOT LS_BUT000-NAME_LAST IS INITIAL.
                <RO>-XNAME =  LS_BUT000-NAME_LAST.
              ELSE.
                <RO>-XNAME =  LS_BUT000-NAME_ORG1.
              ENDIF.
              IF NOT LS_BUT000-NAME_FIRST IS INITIAL.
                CONCATENATE LS_BUT000-NAME_FIRST <RO>-XNAME INTO <RO>-XNAME SEPARATED BY SPACE.
              ELSE.
                CONCATENATE <RO>-XNAME LS_BUT000-NAME_ORG2 INTO <RO>-XNAME SEPARATED BY SPACE.
              ENDIF.
* Telefon holen
              LO_PARTNER = CF_REBP_PARTNER=>FIND( ID_PARTNER = LS_REEXKUNNRCN-PARTNER ).

              CLEAR: LS_TEL_ADDRESS, LS_MAIL_ADDRESS, LS_FAX_ADDRESS,  <RO>-TELEFON.
              LO_PARTNER->GET_COMMUNICATION_DATA(
                IMPORTING
                  ES_MAIL_ADDRESS = LS_MAIL_ADDRESS
                  ES_TEL_ADDRESS  = LS_TEL_ADDRESS
                  ES_FAX_ADDRESS  = LS_FAX_ADDRESS
                EXCEPTIONS
                  OTHERS          = 0 ).
              IF SY-SUBRC = 0.
                <RO>-TELEFON = LS_TEL_ADDRESS-TEL_NUMBER_LONG.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
* Führende Nullen entfernen
  SHIFT GS_RECN-SWENR LEFT DELETING LEADING '0'.
  SHIFT GS_RECN-SGENR LEFT DELETING LEADING '0'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_NOTDIENST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_NOTDIENST .
  DATA: LT_ZPMHW         TYPE TABLE OF ZPMHW,
        LS_ZPMHW         LIKE LINE OF LT_ZPMHW,
        LT_LFA1          TYPE TABLE OF LFA1,
        LS_LFA1          LIKE LINE OF LT_LFA1,
        LT_CVI_VEND_LINK TYPE TABLE OF CVI_VEND_LINK,
        LS_CVI_VEND_LINK LIKE LINE OF LT_CVI_VEND_LINK,
        LT_BUT020        TYPE STANDARD TABLE OF BUT020,
        LS_BUT020        LIKE LINE OF LT_BUT020,
        LT_BUT000        TYPE STANDARD TABLE OF BUT000,
        LS_BUT000        LIKE LINE OF LT_BUT000,
        LT_RETURN        TYPE BAPIRET2_T.
  DATA:
    LT_BAPIADTEL      LIKE BAPIADTEL  OCCURS 0 WITH HEADER LINE,
    LT_BAPIADSMTP     LIKE BAPIADSMTP OCCURS 0 WITH HEADER LINE,
    LS_BUS021         TYPE BUT021_FS,
    LV_OBJ_ID         TYPE BAPI4002_1-OBJKEY,
    LV_OBJ_ID_EXT(70) TYPE C.
*------------------*
  IF GS_RECN-KDST IS INITIAL.
    RETURN.
  ENDIF.
* Zuordnung Handwerker zu Kundendienststellen
  SELECT * FROM ZPMHW INTO TABLE LT_ZPMHW
    WHERE ZZPRCTR = GS_RECN-KDST.
  IF SY-SUBRC = 0.
    DELETE  LT_ZPMHW WHERE ZZNOTKZ = ABAP_FALSE.
    IF NOT LT_ZPMHW IS INITIAL.
* Lieferantenstamm (allgemeiner Teil)
      SELECT * FROM LFA1 INTO TABLE LT_LFA1
        FOR ALL ENTRIES IN LT_ZPMHW
        WHERE LIFNR = LT_ZPMHW-ZZLIFNR.
      IF SY-SUBRC = 0.
        SELECT * FROM CVI_VEND_LINK INTO TABLE LT_CVI_VEND_LINK
          FOR ALL ENTRIES IN LT_LFA1
           WHERE VENDOR = LT_LFA1-LIFNR.
        IF SY-SUBRC = 0.
          SELECT * FROM BUT000 INTO TABLE LT_BUT000
          FOR ALL ENTRIES IN LT_CVI_VEND_LINK
          WHERE PARTNER_GUID = LT_CVI_VEND_LINK-PARTNER_GUID.
          IF SY-SUBRC = 0.
            SELECT * FROM BUT020 INTO TABLE LT_BUT020
            FOR ALL ENTRIES IN LT_BUT000
            WHERE PARTNER = LT_BUT000-PARTNER.
          ENDIF.
        ENDIF.
      ENDIF.
      LOOP AT LT_ZPMHW INTO LS_ZPMHW.
        CLEAR GS_NOTDIENST.
        MOVE-CORRESPONDING  LS_ZPMHW TO GS_NOTDIENST.
        READ TABLE LT_LFA1 INTO LS_LFA1
        WITH KEY LIFNR = LS_ZPMHW-ZZLIFNR.
        IF SY-SUBRC = 0.
          MOVE-CORRESPONDING LS_LFA1 TO GS_NOTDIENST.
          READ TABLE LT_CVI_VEND_LINK INTO LS_CVI_VEND_LINK
          WITH KEY VENDOR = LS_LFA1-LIFNR.
          IF SY-SUBRC = 0.
            READ TABLE LT_BUT000 INTO LS_BUT000 WITH KEY
               PARTNER_GUID = LS_CVI_VEND_LINK-PARTNER_GUID.
            IF SY-SUBRC = 0.
              READ TABLE LT_BUT020 INTO LS_BUT020 WITH KEY
                         PARTNER = LS_BUT000-PARTNER.
              IF SY-SUBRC = 0.
                LV_OBJ_ID+0   = SY-MANDT.
                LV_OBJ_ID+3   = LS_BUT020-PARTNER.
                LV_OBJ_ID_EXT = LS_BUT020-ADDRESS_GUID.
                SELECT SINGLE * FROM BUT000 INTO LS_BUT000
                  WHERE PARTNER = LS_BUT020-PARTNER.
                IF SY-SUBRC = 0.
                  IF LS_BUT000-TYPE NE 1.
                    CALL FUNCTION 'BAPI_ADDRESSORG_GETDETAIL'
                      EXPORTING
                        OBJ_TYPE   = 'BUS1006' "Ownerobjekt zur Adresse
                        OBJ_ID     = LV_OBJ_ID
                        OBJ_ID_EXT = LV_OBJ_ID_EXT
*            IMPORTING
*                       address_number       = lv_addrnumber
                      TABLES
                        BAPIADTEL  = LT_BAPIADTEL
                        BAPIADSMTP = LT_BAPIADSMTP
                        RETURN     = LT_RETURN.
                  ELSE.
                    CALL FUNCTION 'BAPI_ADDRESSPERS_GETDETAIL'
                      EXPORTING
                        OBJ_TYPE   = 'BUS1006' "Ownerobjekt zur Adresse
                        OBJ_ID     = LV_OBJ_ID
                        OBJ_ID_EXT = LV_OBJ_ID_EXT
                        CONTEXT    = '4'
*            IMPORTING
*                       address_number       = lv_addrnumber
                      TABLES
                        BAPIADTEL  = LT_BAPIADTEL
                        BAPIADSMTP = LT_BAPIADSMTP
                        RETURN     = LT_RETURN.
                  ENDIF.
                ENDIF.
                LOOP AT LT_BAPIADTEL.
                  GS_NOTDIENST-TELF_NOT = LT_BAPIADTEL-TEL_NO.
                  EXIT.
                ENDLOOP.
                LOOP AT LT_BAPIADSMTP.
                  GS_NOTDIENST-SMTP_ADDR = LT_BAPIADSMTP-E_MAIL.
                ENDLOOP.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
* Bezeichnungen zu Warengruppen
        SELECT SINGLE WGBEZ INTO GS_NOTDIENST-WGBEZ
             FROM T023T
          WHERE SPRAS = SY-LANGU AND
             MATKL =  GS_NOTDIENST-ZZMATKL.
        APPEND GS_NOTDIENST TO GT_NOTDIENST.
      ENDLOOP.
    ENDIF..
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_TP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_RECN_OBJNR_RO  text
*      -->P_WHEN  text
*      -->P_2599   text
*----------------------------------------------------------------------*
FORM SHOW_TP  USING  P_OBJNR TYPE RECAOBJNR.
  DATA: LT_VIBDOBJASS TYPE TABLE OF VIBDOBJASS,
        LS_VIBDOBJASS LIKE LINE OF LT_VIBDOBJASS.
*-----------------------*
  SELECT * FROM VIBDOBJASS INTO TABLE LT_VIBDOBJASS
    WHERE OBJNRSRC = P_OBJNR AND
          OBJASSTYPE = '61'. "Zuordnung technischer Platz
  SORT LT_VIBDOBJASS BY VALIDTO DESCENDING.
  IF SY-SUBRC = 0.
    READ TABLE LT_VIBDOBJASS INTO LS_VIBDOBJASS INDEX 1.
    IF SY-SUBRC = 0.
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
*         ID_ACTIVITY                = '03'
*         ID_OBJTYPE =
*         id_intreno = p_gs_recn_intreno
          ID_OBJNR = LS_VIBDOBJASS-OBJNRTRG
*         IF_LEAVE_CURRENT           = ABAP_FALSE
*         IF_NEW_EXTERNAL_MODE       = ABAP_FALSE
*         IF_NEW_INTERNAL_MODE       = ABAP_FALSE
*         IS_NAVIGATION_DATA         =
        EXCEPTIONS
          ERROR    = 1
          OTHERS   = 2.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BESTELLUNG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_BESTELLUNG .
  DATA: LS_VIBDBE       TYPE VIBDBE,
        LT_EKKN         TYPE TABLE OF EKKN,
        LS_EKKN         LIKE LINE OF LT_EKKN,
        LT_EKPO         TYPE TABLE OF EKPO,
        LS_EKPO         LIKE LINE OF LT_EKPO,
        LT_EKKO         TYPE TABLE OF EKKO,
        LS_EKKO         LIKE LINE OF LT_EKKO,
        LT_WARTBEST_NB  TYPE Z_T_WARTBEST_UEB,
        LT_WARTBEST_LB  TYPE Z_T_WARTBEST_UEB,
        LS_WARTBEST_UEB LIKE LINE OF LT_WARTBEST_NB,
        LT_LFA1         TYPE STANDARD TABLE OF LFA1,
        LS_LFA1         LIKE LINE OF LT_LFA1,
        LT_ADRC         TYPE TABLE OF ADRC,
        LS_ADRC         LIKE LINE OF LT_ADRC,
        LS_BESTELLUNG   LIKE GS_BESTELLUNG,
        LT_BESTELLUNG   LIKE TABLE OF GS_BESTELLUNG,
        LT_VISCSU       TYPE TABLE OF VISCSU,
        LS_VISCSU       LIKE LINE OF LT_VISCSU,
        LT_IMKEY        TYPE TABLE OF IMKEY,
        LD_IMKEY        LIKE LINE OF LT_IMKEY,
        LD_SWENR        TYPE SWENR.

  FIELD-SYMBOLS: <EKPO> TYPE EKPO.
*------------------------*

  IF GS_RECN-SWENR IS INITIAL.
    RETURN.
  ENDIF.

  CLEAR LS_VIBDBE.
  IF GS_RECN-RECNNR(4) = 'LVMV'.
* Wirtschaftseinheit Co-Living Verträgen
    LD_SWENR =  GX_KC->S_PARTNER-BENOCN.
    SHIFT LD_SWENR LEFT DELETING LEADING '0'.
    CONCATENATE '9' LD_SWENR INTO LD_SWENR.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = LD_SWENR
      IMPORTING
        OUTPUT = LD_SWENR.
* Wirtschaftseinheit Co-Living Verträgen

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*    SELECT SINGLE * FROM VIBDBE INTO LS_VIBDBE
*      WHERE BUKRS = '9109' AND
*            SWENR = LD_SWENR.

SELECT * FROM VIBDBE INTO LS_VIBDBE UP TO 1 ROWS
 WHERE BUKRS = '9109' AND SWENR = LD_SWENR
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

    IF SY-SUBRC NE 0.
      CLEAR LS_VIBDBE.
    ELSE.
* Imkey speichern
      REFRESH LT_IMKEY.
      APPEND LS_VIBDBE-IMKEY TO LT_IMKEY.
* Alle AES zur WE holen
      SELECT * FROM VISCSU INTO TABLE LT_VISCSU
        WHERE BUKRS = GX_KC->S_PARTNER-BUKRS AND
              SWENR = GX_KC->S_PARTNER-BENOCN.
      IF SY-SUBRC = 0.
* Imkey der AE speichern
        LOOP AT LT_VISCSU INTO LS_VISCSU.
          APPEND LS_VISCSU-IMKEY TO LT_IMKEY.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
  IF LS_VIBDBE IS INITIAL.
* Wirtschaftseinheit

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* Replaced Code:
*    SELECT SINGLE * FROM VIBDBE INTO LS_VIBDBE
*      WHERE BUKRS = GX_KC->S_PARTNER-BUKRS AND
*            SWENR = GX_KC->S_PARTNER-BENOCN.

SELECT * FROM VIBDBE INTO LS_VIBDBE UP TO 1 ROWS
 WHERE BUKRS = GX_KC->S_PARTNER-BUKRS AND SWENR = GX_KC->S_PARTNER-BENOCN
 ORDER BY PRIMARY KEY .
 ENDSELECT.
* End of Quick Fix

    IF SY-SUBRC NE 0.
      RETURN.
    ENDIF.
* Imkey speichern
    REFRESH LT_IMKEY.
    APPEND LS_VIBDBE-IMKEY TO LT_IMKEY.
* Alle AES zur WE holen
    SELECT * FROM VISCSU INTO TABLE LT_VISCSU
      WHERE BUKRS = GX_KC->S_PARTNER-BUKRS AND
            SWENR = GX_KC->S_PARTNER-BENOCN.
    IF SY-SUBRC = 0.
* Imkey der AE speichern
      LOOP AT LT_VISCSU INTO LS_VISCSU.
        APPEND LS_VISCSU-IMKEY TO LT_IMKEY.
      ENDLOOP.
    ENDIF.
  ENDIF.
  IF LT_IMKEY[] IS INITIAL.
    RETURN.
  ENDIF.
* Kontierung im Einkaufsbeleg
  SELECT * FROM EKKN INTO TABLE LT_EKKN
    FOR ALL ENTRIES IN LT_IMKEY
  WHERE IMKEY = LT_IMKEY-TABLE_LINE.

  IF SY-SUBRC = 0.
* Einkaufsbelegkopf
    SELECT * FROM EKKO INTO TABLE LT_EKKO
      FOR ALL ENTRIES IN LT_EKKN
      WHERE EBELN = LT_EKKN-EBELN.
    IF SY-SUBRC = 0.
* Lieferantenstamm (allgemeiner Teil)
      SELECT * FROM LFA1 INTO TABLE LT_LFA1
        FOR ALL ENTRIES IN LT_EKKO
        WHERE LIFNR = LT_EKKO-LIFNR.
      SORT LT_LFA1 BY LIFNR.
      IF NOT LT_LFA1[] IS INITIAL.
        SELECT * FROM  ADRC INTO TABLE LT_ADRC
           FOR ALL ENTRIES IN LT_LFA1
           WHERE  ADDRNUMBER  =  LT_LFA1-ADRNR.
      ENDIF.
    ENDIF.
* Nur Normalbestellungen
*    DELETE lt_ekko WHERE bsart NE 'NB'."Normalbestellung
    SORT LT_EKKO BY EBELN.
* Einkaufsbelegposition
    SELECT * FROM EKPO INTO TABLE LT_EKPO
    FOR ALL ENTRIES IN LT_EKKN
      WHERE EBELN = LT_EKKN-EBELN AND
        EBELP = LT_EKKN-EBELP.
    IF SY-SUBRC = 0.
      DELETE LT_EKPO WHERE LOEKZ = 'L'. "S= gesperrt L= gelöscht
      DELETE LT_EKPO WHERE EREKZ = ABAP_TRUE.
      SORT LT_EKPO BY EBELN EBELP.

* Bestellung global speichern
      REFRESH LT_BESTELLUNG.
      LOOP AT LT_EKKN INTO LS_EKKN.
        READ TABLE LT_EKKO INTO LS_EKKO
        WITH KEY EBELN = LS_EKKN-EBELN BINARY SEARCH.
        IF SY-SUBRC NE 0.
          CONTINUE.
        ENDIF.
        CLEAR LS_WARTBEST_UEB.
        READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR = LS_EKKO-LIFNR BINARY SEARCH.
        IF SY-SUBRC = 0.
          CONCATENATE  LS_LFA1-NAME1  LS_LFA1-NAME2 INTO LS_WARTBEST_UEB-NAME1.
          READ TABLE LT_ADRC INTO LS_ADRC WITH KEY  ADDRNUMBER = LS_LFA1-ADRNR.
          IF SY-SUBRC = 0.
            MOVE-CORRESPONDING  LS_ADRC TO LS_WARTBEST_UEB.
          ENDIF.
        ENDIF.
        CASE LS_EKKO-BSART.
          WHEN 'NB'.
* Normalbestellung
            READ TABLE LT_EKPO ASSIGNING <EKPO>
                     WITH KEY EBELN = LS_EKKN-EBELN
                              EBELP = LS_EKKN-EBELP   BINARY SEARCH.
            IF SY-SUBRC = 0.
              CLEAR LS_BESTELLUNG.
              MOVE-CORRESPONDING LS_WARTBEST_UEB TO LS_BESTELLUNG.
              MOVE-CORRESPONDING <EKPO> TO LS_BESTELLUNG.
              MOVE-CORRESPONDING LS_EKKO TO LS_BESTELLUNG.
* Beleg Bestellung aufbauen
              CONCATENATE <EKPO>-BUKRS <EKPO>-EBELN <EKPO>-EBELP <EKPO>-AEDAT(4)
              INTO LS_BESTELLUNG-DOC_BEST SEPARATED BY '/'.
              CALL METHOD ZCL_EMOD_T023=>GET_TEXT
                EXPORTING
                  ID_MATKL  = LS_BESTELLUNG-MATKL
                RECEIVING
                  RD_TEXT   = LS_BESTELLUNG-WGBEZ
                EXCEPTIONS
                  NOT_FOUND = 0
                  OTHERS    = 0.
* Daten Bestellung lokal speichern
        " E.Firsanov get Kommunikationsdaten zum Lieferant
        ZCL_INFOCOCKPIT_SERVICES=>GET_KOMMUNIKDATEN_LIEFERANT(
          EXPORTING
            ID_LIFNR     = LS_BESTELLUNG-LIFNR
          IMPORTING
            ED_TELF1     = LS_BESTELLUNG-TELF1
            ED_TELFX     = LS_BESTELLUNG-TELFX
            ED_SMTP_ADDR = LS_BESTELLUNG-SMTP_ADDR
               ).

              APPEND LS_BESTELLUNG TO LT_BESTELLUNG.
            ENDIF.
          WHEN 'LB'.
* Wartungsverträge WE - Langfristbestellung
            READ TABLE LT_EKPO ASSIGNING <EKPO>
                     WITH KEY EBELN = LS_EKKN-EBELN
                              EBELP = LS_EKKN-EBELP   BINARY SEARCH.
            IF SY-SUBRC = 0.
              MOVE-CORRESPONDING <EKPO> TO LS_WARTBEST_UEB.
              MOVE-CORRESPONDING LS_EKKO TO LS_WARTBEST_UEB.
              CALL METHOD ZCL_PD_ZTCWARTUNGSART=>GET_TEXT
                EXPORTING
                  ID_WARTUNGSART = LS_WARTBEST_UEB-WARTUNGSART
                RECEIVING
                  RD_TEXT        = LS_WARTBEST_UEB-XWARTUNGSART
                EXCEPTIONS
                  NOT_FOUND      = 0
                  OTHERS         = 0.
              CALL METHOD ZCL_EMOD_T023=>GET_TEXT
                EXPORTING
                  ID_MATKL  = LS_WARTBEST_UEB-MATKL
                RECEIVING
                  RD_TEXT   = LS_WARTBEST_UEB-WGBEZ
                EXCEPTIONS
                  NOT_FOUND = 0
                  OTHERS    = 0.
* Daten Wartungsplan WE lokal speichern
              APPEND LS_WARTBEST_UEB TO LT_WARTBEST_LB.
            ENDIF.
          WHEN OTHERS.
            CONTINUE.
        ENDCASE.
      ENDLOOP.
* Wartung Langfristbestellung
      LOOP AT LT_WARTBEST_LB INTO LS_WARTBEST_UEB.
        CLEAR GS_WARTUNG_WE.
        MOVE-CORRESPONDING LS_WARTBEST_UEB TO GS_WARTUNG_WE.
* Beleg Bestellung aufbauen
        CONCATENATE LS_WARTBEST_UEB-BUKRS LS_WARTBEST_UEB-EBELN LS_WARTBEST_UEB-EBELP
        INTO GS_WARTUNG_WE-DOC_WART SEPARATED BY '/'.
        SHIFT LS_VIBDBE-SWENR LEFT DELETING LEADING '0'.
        CONCATENATE LS_VIBDBE-BUKRS LS_VIBDBE-SWENR INTO
        GS_WARTUNG_WE-IDENTKEY_WE SEPARATED BY '/'.
        " E.Firsanov get Kommunikationsdaten zum Lieferant
        ZCL_INFOCOCKPIT_SERVICES=>GET_KOMMUNIKDATEN_LIEFERANT(
          EXPORTING
            ID_LIFNR     = GS_WARTUNG_WE-LIFNR
          IMPORTING
            ED_TELF1     = GS_WARTUNG_WE-TELF1
            ED_TELFX     = GS_WARTUNG_WE-TELFX
            ED_SMTP_ADDR = GS_WARTUNG_WE-SMTP_ADDR
               ).

        APPEND GS_WARTUNG_WE TO GT_WARTUNG_WE.
      ENDLOOP.
* Normalbestellung
      LOOP AT LT_BESTELLUNG INTO LS_BESTELLUNG.
        CLEAR GS_BESTELLUNG.
        MOVE-CORRESPONDING LS_BESTELLUNG TO GS_BESTELLUNG.
        SHIFT LS_VIBDBE-SWENR LEFT DELETING LEADING '0'.
        CONCATENATE LS_VIBDBE-BUKRS LS_VIBDBE-SWENR INTO
        GS_WARTUNG_WE-IDENTKEY_WE SEPARATED BY '/'.
        APPEND GS_BESTELLUNG TO GT_BESTELLUNG.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PBO_5990
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PBO_5990 .
  IF ZST_INFO_CONTEXT-INFOMAIL = ABAP_FALSE.
*    SET  CURSOR  FIELD 'ZST_INFO_CONTEXT-AN'.
    LOOP AT SCREEN.
      IF SCREEN-GROUP1 = 'INM'.
        SCREEN-INPUT = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ELSE.
*    SET CURSOR FIELD 'ZST_INFO_CONTEXT-AN'.
    LOOP AT SCREEN.
      IF SCREEN-GROUP1 = 'INM'.
        SCREEN-INPUT = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PAI_5990
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PAI_5990 .

  CASE SY-UCOMM.
    WHEN 'CC_LUBITZ'.
      GV_FELD = 'ZST_INFO_CONTEXT-CC_LUBITZ_EMAIL'.
      ZST_INFO_CONTEXT-CC_LUBITZ_EMAIL = 'notdienst@lubitz-sanitaer-heizung.de'.
    WHEN 'INFO_MAIL'.
      " Kundenbetreuer immer als E-Mail Empfenger
      PERFORM GET_KUNDENBETREUER CHANGING ZST_INFO_CONTEXT-AN.
      GV_FELD = 'ZST_INFO_CONTEXT-AN'.
      IF ZST_INFO_CONTEXT-INFOMAIL = ABAP_FALSE.
        CLEAR ZST_INFO_CONTEXT.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PBO_5000
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PBO_5000 .
  GS_GUI-SUBSCREEN-REPID = SY-REPID.
  GS_GUI-SUBSCREEN-DYNNR = '5990'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_INFO_CONTEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_INFO_CONTEXT .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  F4_CODE_CC  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE F4_CODE_CC INPUT.
  PERFORM F4_CODE_CC.
  GV_FELD = 'ZST_INFO_CONTEXT-CC'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F4_CODE_CC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F4_CODE_CC .
  DATA: LT_DYN_FIELDS LIKE DYNPREAD   OCCURS 1 WITH HEADER LINE.


* ZST_DMS_DIALOG-FILE_NAME
  DATA: BEGIN OF LT_VALUES OCCURS 10,
          TEXT(100),
        END OF LT_VALUES.


  DATA: LF_REPID LIKE D020S-PROG,
        LF_DYNNR LIKE D020S-DNUM,
        LF_FNAME TYPE HELP_INFO-DYNPROFLD.
  DATA: LT_FIELDCAT  TYPE SLIS_T_FIELDCAT_ALV,
        G_EXIT(1)    TYPE C,
        GS_SELFIELD  TYPE SLIS_SELFIELD,
        LD_SELECTION TYPE CHAR1.

  FIELD-SYMBOLS: <FS_DOKGR> TYPE ZST_DMS_DIALOG-DOKGR.
**----------------------------------------------------------------------


**----------------------------------------------------------------------
** Get entry in dappl,dttrg,filep from dynpro
**----------------------------------------------------------------------
  LF_REPID = SY-REPID.
  LF_DYNNR = SY-DYNNR.

  LF_FNAME = 'ZST_INFO_CONTEXT-CC'.

  DATA LT_CLERK TYPE STANDARD TABLE OF ZST_CLERK_DIALOG.


  CHECK GT_CLERK[] IS NOT INITIAL.

  LT_CLERK = CORRESPONDING #( GT_CLERK ).
  DELETE LT_CLERK WHERE ROLE = 'YYZ001'.

  PERFORM GET_FIELDCATALOG TABLES LT_FIELDCAT.

  LD_SELECTION = ABAP_TRUE.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      I_TITLE               = 'Get CC Benutzer' ##NO_TEXT
      I_SELECTION           = LD_SELECTION
      I_ZEBRA               = 'X'
      I_CHECKBOX_FIELDNAME  = 'SELFELD'
      I_SCREEN_START_COLUMN = 5
      I_SCREEN_START_LINE   = 5
      I_SCREEN_END_COLUMN   = 120
      I_SCREEN_END_LINE     = 25
      I_TABNAME             = 'ZST_CLERK_DIALOG' ##NO_TEXT
*     I_STRUCTURE_NAME      = 'ZST_ALV_SELECT_STANDORT'
      IT_FIELDCAT           = LT_FIELDCAT
*     IS_PRIVATE            = GS_PRIVATE
    IMPORTING
      ES_SELFIELD           = GS_SELFIELD
      E_EXIT                = G_EXIT
    TABLES
      T_OUTTAB              = LT_CLERK
    EXCEPTIONS
      PROGRAM_ERROR         = 1
      OTHERS                = 2.
  IF SY-SUBRC <> 0.
    MESSAGE I000(0K) WITH SY-SUBRC.
  ENDIF.

  CHECK G_EXIT = ABAP_FALSE.

  DATA LD_CNT TYPE SY-TABIX.

  LOOP AT LT_CLERK INTO DATA(LS_CLERK) WHERE SELFELD = ABAP_TRUE.
    ADD 1 TO LD_CNT.
    IF LD_CNT = 1.
      ZST_INFO_CONTEXT-CC = LS_CLERK-SMTP_ADDR.
    ELSE.
      ZST_INFO_CONTEXT-CC = |{ ZST_INFO_CONTEXT-CC }; { LS_CLERK-SMTP_ADDR }|.
    ENDIF.
  ENDLOOP.
** set appl. to screen
*  REFRESH: LT_DYN_FIELDS, LT_VALUES.
*
*  LT_DYN_FIELDS-FIELDNAME = LF_FNAME.
*  LT_DYN_FIELDS-FIELDVALUE = LS_RETURN-FIELDVAL.
*  APPEND LT_DYN_FIELDS.
*
*  LT_DYN_FIELDS-FIELDNAME = 'GS_DMS_DIALOG-DOKGRBEZ'.
*  LT_DYN_FIELDS-FIELDVALUE = GS_DMS_DIALOG-DOKGRBEZ.
*  APPEND LT_DYN_FIELDS.
*
*
*  CALL FUNCTION 'DYNP_VALUES_UPDATE'
*    EXPORTING
*      DYNAME               = LF_REPID
*      DYNUMB               = LF_DYNNR
*    TABLES
*      DYNPFIELDS           = LT_DYN_FIELDS
*    EXCEPTIONS
*      INVALID_ABAPWORKAREA = 1
*      INVALID_DYNPROFIELD  = 2
*      INVALID_DYNPRONAME   = 3
*      INVALID_DYNPRONUMMER = 4
*      INVALID_REQUEST      = 5
*      NO_FIELDDESCRIPTION  = 6
*      UNDEFIND_ERROR       = 7
*      OTHERS               = 8.
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM GET_FIELDCATALOG  TABLES   P_LT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

  DEFINE ZMAC_ALV_FC_POS_SET.                                              " set next position for field (ascending)
*--> &1 = fieldname
*----------------------------------------------------------------------

    READ TABLE CT_FIELDCAT ASSIGNING <LS_FIELDCATALOG>
    WITH KEY FIELDNAME = &1.
* the field MUST be present -> program error
    ASSERT FIELDS 'FIELDNAME' LD_COLPOS &1
    CONDITION SY-SUBRC = 0.

    <LS_FIELDCATALOG>-COL_POS = LD_COLPOS.
    ADD 1 TO LD_COLPOS.

  END-OF-DEFINITION.

  DATA:
        LD_COLPOS         TYPE SYTABIX.                     "#EC NEEDED



  FIELD-SYMBOLS: <LS_FIELDCATALOG> LIKE LINE OF P_LT_FIELDCAT.



  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
*     I_PROGRAM_NAME         = 'ZRE_PM_COCKPIT'
*     I_INTERNAL_TABNAME     = 'GS_CLERK'
      I_STRUCTURE_NAME       = 'ZST_CLERK_DIALOG'
    CHANGING
      CT_FIELDCAT            = P_LT_FIELDCAT[]
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.
  IF SY-SUBRC NE 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
    RAISING ERROR.
  ENDIF.

  LOOP AT P_LT_FIELDCAT ASSIGNING <LS_FIELDCATALOG>.
    IF <LS_FIELDCATALOG>-FIELDNAME  = 'SMTP_ADDR'.
      <LS_FIELDCATALOG>-JUST      = 'L'.
      <LS_FIELDCATALOG>-OUTPUTLEN = 35.
    ENDIF.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_KUNDENBETREUER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ZST_INFO_CONTEXT_AN  text
*----------------------------------------------------------------------*
FORM GET_KUNDENBETREUER  CHANGING P_AN TYPE ZST_INFO_CONTEXT-AN.

  P_AN = VALUE #( GT_CLERK[ ROLE = 'YYZ001' ]-SMTP_ADDR DEFAULT ' ' ).

ENDFORM.
