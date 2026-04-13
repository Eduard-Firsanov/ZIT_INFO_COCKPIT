*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       Kundenübersicht
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.
* data lokal
  DATA: ld_objnr             TYPE recaobjnr,
        lo_contract          TYPE REF TO if_recn_contract,
        ls_reca_bus_object_x TYPE reca_bus_object_x,
        ls_object            TYPE borident.
*-------------------------------*

  CASE sy-ucomm.

*=========================================================================
*   Dynpro Verlassen
*=========================================================================
    WHEN '&F03' OR
         '&F15' OR
         '&F12' .
      SET PARAMETER ID 'UCOMM' FIELD sy-ucomm.
      SET SCREEN 0.
      LEAVE TO SCREEN 0.

*=========================================================================
*  Wirtschaftseinheit anzeigen
*=========================================================================
    WHEN 'PUSH_BE'.

      ld_objnr = gs_recn-objnr_be.
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
          id_activity = '03'
          id_objnr    = ld_objnr
        EXCEPTIONS
          error       = 1
          OTHERS      = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*=========================================================================
*  Gebäude anzeigen
*=========================================================================
    WHEN 'PUSH_BU'.
*      CONCATENATE 'IB' gs_daten-bukrs_obj gs_daten-swenr gs_daten-sgenr
*      INTO gd_objnr.
      ld_objnr = gs_recn-objnr_bu.
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
          id_activity = '03'
          id_objnr    = ld_objnr
        EXCEPTIONS
          error       = 1
          OTHERS      = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*=========================================================================
*  Grundstück
*=========================================================================
    WHEN 'PUSH_PR'.
*      CONCATENATE 'IB' gs_daten-bukrs_obj gs_daten-swenr gs_daten-sgenr
*      INTO gd_objnr.
      IF NOT gs_recn-objnr_pr IS INITIAL.
        ld_objnr = gs_recn-objnr_pr.
        CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
          EXPORTING
            id_activity = '03'
            id_objnr    = ld_objnr
          EXCEPTIONS
            error       = 1
            OTHERS      = 2.

        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ELSE.
        MESSAGE i061(recaap) WITH 'Grundstück' 'zum Vertrag'.
      ENDIF.
*=========================================================================
*  Mietobjekt anzeigen
*=========================================================================
    WHEN 'PUSH_RO'.
      ld_objnr = gs_recn-objnr_ro.
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
          id_activity = '03'
          id_objnr    = ld_objnr
        EXCEPTIONS
          error       = 1
          OTHERS      = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*=========================================================================
*  Mietvertrag anzeigen
*=========================================================================
    WHEN 'PUSH_CN'.
* Objennummer
      ld_objnr = gs_contract-objnr.
      CALL FUNCTION 'RECA_GUI_BUSOBJ_APPL'
        EXPORTING
          id_activity = '03'
          id_objnr    = ld_objnr
        EXCEPTIONS
          error       = 1
          OTHERS      = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
*=========================================================================
*  Mieterkontenbaltt
*=========================================================================
    WHEN 'PUSH_SAL'.
* Objennummer
      ld_objnr = gs_contract-objnr.
      CALL METHOD cf_recn_contract=>find_by_objnr
        EXPORTING
          id_objnr    = ld_objnr
        RECEIVING
          ro_instance = lo_contract
        EXCEPTIONS
          error       = 1
          OTHERS      = 2.
      IF sy-subrc = 0.
*        CALL FUNCTION 'REEX_GUI_ACCT_SHEET_SHOW'
*          EXPORTING
*            io_busobj = lo_contract
**           ID_PARTNER       =
*          EXCEPTIONS
*            error     = 1
*            OTHERS    = 2.
*        IF sy-subrc <> 0.
** Implement suitable error handling here
*        ENDIF.
*        CALL FUNCTION 'Z_PD_ACCT_SHEET_SHOW'
*          EXPORTING
*            io_busobj = lo_contract
**           ID_PARTNER         =
** IMPORTING
**           ES_SUBSCREEN       =
*          .


      ENDIF.
    WHEN 'PUSH_KORR'.
      IF 1 = 2.
*        DATA: lf_msgv1 TYPE sy-msgv1,
*              lf_msgv2 TYPE sy-msgv2,
*              lf_msgv3 TYPE sy-msgv3.
*        DATA: gs_lporb TYPE sibflporb.
*        gs_lporb-typeid = 'BUS1505'.
*        CONCATENATE gs_contract-bukrs gs_contract-recnnr INTO
*              gs_lporb-instid..
*        TRY.
*            DATA(lo_mfdwin_call) = NEW zcl_zrms_mfdwincall(
*              if_object_type = CONV #( gs_lporb-typeid )
*              if_object_id   = gs_lporb-instid
*            )->get_program_call( ).
*
*            lo_mfdwin_call->get_call_params( IMPORTING ef_parameters = DATA(lf_call_params) ).
*
*            lo_mfdwin_call->call_programm( ).
*
*            IF sy-sysid = 'HW4' OR sy-sysid = 'HW2'.
*              MESSAGE ID 'ZRMS' TYPE 'S' NUMBER '068' WITH lf_call_params.
*            ENDIF.
*
*          CATCH zcx_zrms INTO DATA(lo_fail).
*            DATA(lf_error_text) = lo_fail->get_text( ).
*
*            cl_message_helper=>set_msg_vars_for_clike( lf_error_text ).
*            lf_msgv1 = sy-msgv1.
*            lf_msgv2 = sy-msgv2.
*            lf_msgv3 = sy-msgv3.
*
*            MESSAGE ID 'ZRMS' TYPE 'S' NUMBER '069'
*              WITH lf_call_params lf_msgv1 lf_msgv2 lf_msgv3 DISPLAY LIKE 'W'.
*
*        ENDTRY.
      ELSE.
* Objennummer
        ld_objnr = gs_contract-objnr.
        CALL METHOD cf_recn_contract=>find_by_objnr
          EXPORTING
            id_objnr    = ld_objnr
          RECEIVING
            ro_instance = lo_contract
          EXCEPTIONS
            error       = 1
            OTHERS      = 2.
        CLEAR ls_reca_bus_object_x.
        ls_reca_bus_object_x = lo_contract->get_busdetail_x( ).
        CLEAR ls_object.
        ls_object-objkey = ls_reca_bus_object_x-buskey.
        ls_object-objtype = 'BUS1505'.

        CALL FUNCTION 'GOS_EXECUTE_SERVICE'
          DESTINATION 'NONE'
          EXPORTING
            ip_service       = 'VIEW_ATTA'
            is_object        = ls_object
            ip_no_commit     = 'X'
            ip_popup         = 'X'
*           IT_SERVICE_SELECTION       =
*           IMPORTING
*           EP_EVENT         =
*           EP_STATUS        =
*           EP_ICON          =
          EXCEPTIONS
            execution_failed = 1
            OTHERS           = 2.

      ENDIF.
* Geburtstag
    WHEN 'PUSH_BIRTH'.
      IF gs_recn-debitor IS INITIAL.
        RETURN.
      ENDIF.
      IF gd_edit_birth IS INITIAL.
        CALL FUNCTION 'ENQUEUE_EXKNA1'
          EXPORTING
            mode_kna1      = 'E'
            mandt          = sy-mandt
            kunnr          = gs_recn-debitor
*           X_KUNNR        = ' '
*           _SCOPE         = '2'
*           _WAIT          = ' '
*           _COLLECT       = ' '
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc =  0.
* Dynprofeld eingabebereit
          gd_edit_birth = abap_true.
        ELSE.
          MESSAGE ID 'F2'    TYPE 'E' NUMBER  042 WITH  gs_recn-debitor.
        ENDIF.
      ELSE.
        CALL FUNCTION 'DEQUEUE_EXKNA1'
          EXPORTING
*           MODE_KNA1       = 'E'
            mandt = sy-mandt
            kunnr = gs_recn-debitor.
* Dynprofeld nicht eingabebereit
        gd_edit_birth = abap_false.

      ENDIF.
    WHEN 'PUSH_BIRTH_SAVE'.
      PERFORM set_bupa USING gs_recn
                            sy-ucomm.
* Festnetz
    WHEN 'PUSH_TEL'.
      IF gs_recn-debitor IS INITIAL.
        RETURN.
      ENDIF.
      IF gd_edit_tel IS INITIAL.
        CALL FUNCTION 'ENQUEUE_EXKNA1'
          EXPORTING
            mode_kna1      = 'E'
            mandt          = sy-mandt
            kunnr          = gs_recn-debitor
*           X_KUNNR        = ' '
*           _SCOPE         = '2'
*           _WAIT          = ' '
*           _COLLECT       = ' '
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc =  0.
* Dynprofeld eingabebereit
          gd_edit_tel = abap_true.
        ELSE.
          MESSAGE ID 'F2'    TYPE 'E' NUMBER  042 WITH  gs_recn-debitor.
        ENDIF.
      ELSE.
        CALL FUNCTION 'DEQUEUE_EXKNA1'
          EXPORTING
*           MODE_KNA1       = 'E'
            mandt = sy-mandt
            kunnr = gs_recn-debitor.
* Dynprofeld nicht eingabebereit
        gd_edit_tel = abap_false.
      ENDIF.
    WHEN 'PUSH_TEL_SAVE'.
      PERFORM set_bupa USING gs_recn
                            sy-ucomm.
* Dynprofeld nicht eingabebereit
      gd_edit_tel = abap_false.
* Mobil
    WHEN 'PUSH_MOBIL'.
      IF gs_recn-debitor IS INITIAL.
        RETURN.
      ENDIF.
      IF gd_edit_mobil IS INITIAL.
        CALL FUNCTION 'ENQUEUE_EXKNA1'
          EXPORTING
            mode_kna1      = 'E'
            mandt          = sy-mandt
            kunnr          = gs_recn-debitor
*           X_KUNNR        = ' '
*           _SCOPE         = '2'
*           _WAIT          = ' '
*           _COLLECT       = ' '
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc =  0.
* Dynprofeld eingabebereit
          gd_edit_mobil = abap_true.
        ELSE.
          MESSAGE ID 'F2'    TYPE 'E' NUMBER  042 WITH  gs_recn-debitor.
        ENDIF.
      ELSE.
        CALL FUNCTION 'DEQUEUE_EXKNA1'
          EXPORTING
*           MODE_KNA1       = 'E'
            mandt = sy-mandt
            kunnr = gs_recn-debitor.
* Dynprofeld nicht eingabebereit
        gd_edit_mobil = abap_false.

      ENDIF.
    WHEN 'PUSH_MOBIL_SAVE'.
      PERFORM set_bupa USING gs_recn
                            sy-ucomm.
* Dynprofeld nicht eingabebereit
      gd_edit_mobil = abap_false.

* E-Mail
    WHEN 'PUSH_EMAIL'.
      IF gs_recn-debitor IS INITIAL.
        RETURN.
      ENDIF.
      IF gd_edit_email IS INITIAL.
        CALL FUNCTION 'ENQUEUE_EXKNA1'
          EXPORTING
            mode_kna1      = 'E'
            mandt          = sy-mandt
            kunnr          = gs_recn-debitor
*           X_KUNNR        = ' '
*           _SCOPE         = '2'
*           _WAIT          = ' '
*           _COLLECT       = ' '
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc =  0.
* Dynprofeld eingabebereit
          gd_edit_email = abap_true.
        ELSE.
          MESSAGE ID 'F2'    TYPE 'E' NUMBER  042 WITH  gs_recn-debitor.
        ENDIF.
      ELSE.
        CALL FUNCTION 'DEQUEUE_EXKNA1'
          EXPORTING
*           MODE_KNA1       = 'E'
            mandt = sy-mandt
            kunnr = gs_recn-debitor.
* Dynprofeld nicht eingabebereit
        gd_edit_email = abap_false.

      ENDIF.
    WHEN 'PUSH_EMAIL_SAVE'.
      PERFORM set_bupa USING gs_recn
                            sy-ucomm.
* Dynprofeld nicht eingabebereit
      gd_edit_email = abap_false.
* Erreichbarkeit
    WHEN 'PUSH_AVAIL'.
      IF gs_recn-debitor IS INITIAL.
        RETURN.
      ENDIF.
      IF gd_edit_avail IS INITIAL.
        CALL FUNCTION 'ENQUEUE_EXKNA1'
          EXPORTING
            mode_kna1      = 'E'
            mandt          = sy-mandt
            kunnr          = gs_recn-debitor
*           X_KUNNR        = ' '
*           _SCOPE         = '2'
*           _WAIT          = ' '
*           _COLLECT       = ' '
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc =  0.
* Dynprofeld eingabebereit
          gd_edit_avail = abap_true.
        ELSE.
          MESSAGE ID 'F2'    TYPE 'E' NUMBER  042 WITH  gs_recn-debitor.
        ENDIF.
      ELSE.
        CALL FUNCTION 'DEQUEUE_EXKNA1'
          EXPORTING
*           MODE_KNA1       = 'E'
            mandt = sy-mandt
            kunnr = gs_recn-debitor.
* Dynprofeld nicht eingabebereit
        gd_edit_avail = abap_false.
      ENDIF.
* Aufklappen Partner
    WHEN 'PARTNER_S'.
      gd_show_partner  = abap_true.
* Zuklappen Partner
    WHEN 'PARTNER_H'.
      CLEAR gd_show_partner.
* Aufklappen Ticket_RO
    WHEN 'TICKET_RO_S'.
      gd_show_ticket_ro = abap_true.
* Zuklappen Partner
    WHEN 'TICKET_RO_H'.
      CLEAR  gd_show_ticket_ro.
*   Komplette Detaildaten einblenden
* Aufklappen Ticket_CN
    WHEN 'TICKET_CN_S'.
      gd_show_ticket_cn = abap_true.
* Zuklappen Partner
    WHEN 'TICKET_CN_H'.
      CLEAR  gd_show_ticket_cn.
*   Komplette Detaildaten einblenden
    WHEN 'PUSH_AVAIL_SAVE'.
      PERFORM save_avail USING gs_recn
                              sy-ucomm.
* Notizen
    WHEN 'PUSH_NOTICE'.
*      PERFORM notice_create using ld_text string.

    WHEN 'PUSH_TICKET_CN_01'.
* Ticket anlegen
      CALL SCREEN 0200 STARTING AT 40 9 ENDING AT 150 35.

    WHEN 'PUSH_TICKET_CN_02'.
* Ticket ändern
      CALL SCREEN 0210 STARTING AT 40 9 ENDING AT 150 35.
    WHEN 'PUSH_TICKET_CN_03'.
* Ticket anzeigen
      CALL SCREEN 0220 STARTING AT 40 9 ENDING AT 150 35.
    WHEN 'PUSH_TICKET_RO_02'.
* Ticket RO anzeigen
      CALL SCREEN 0310 STARTING AT 40 9 ENDING AT 150 35.
    WHEN 'PUSH_TICKET_RO_01'.
* Ticket RO anlegen
      CALL SCREEN 0300 STARTING AT 40 9 ENDING AT 150 35.
* Konditionen Popup aufrufen
    WHEN 'PUSH_COND'.
      CALL SCREEN 0600 STARTING AT 40 9 ENDING AT 150 23.
* Flächen Popup aufrufen
    WHEN 'PUSH_AREA'.
      CALL SCREEN 0610 STARTING AT 40 9 ENDING AT 150 23.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_AVAIL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_avail INPUT.

  IF gs_recn-avail_from IS INITIAL AND
  gs_recn-avail_to   IS INITIAL.
* Felder leer->raus
    EXIT.
  ENDIF.
* datum abfragen
  IF gs_recn-avail_from >= gs_recn-avail_to.
    "Bis-Wert muss größer als Von-Wert sein!
    MESSAGE 'Bis-Wert muss größer als Von-Wert sein!' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ELSE.
    IF gs_recn-avail_from < 7
    OR gs_recn-avail_to    > 20.
      "Anrufzeit darf nur im Zeitraum von 7:00 bis 20:00 liegen!
      MESSAGE 'Anrufzeit darf nur im Zeitraum von 7:00 bis 20:00 liegen!' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form NOTICE_CREATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM notice_create USING rd_text TYPE string.
  DATA: lo_text_mngr    TYPE REF TO if_reca_additional_text_mngr,
        lt_add_txt      TYPE re_t_additional_text,
        ls_add_txt      LIKE LINE OF         lt_add_txt,
        lo_text         TYPE REF TO if_reca_text,
        ld_cate         TYPE recatextcate VALUE 'ZKUN',
        ld_string       TYPE char255,
        ld_text_changed TYPE abap_bool,
        lt_datatab      TYPE tdtab_c132,
        lt_text	        TYPE re_t_textline_itf,
        ls_datatab(132) TYPE c,
        l_text          TYPE string.
*----------------------------*

  TRY.
      lo_text_mngr = CAST if_reca_has_additional_text( go_cn )->get_additional_text_mngr( ).
    CATCH cx_sy_move_cast_error.
      RETURN.
  ENDTRY.
  lo_text_mngr->get_list(
     IMPORTING
  et_list = lt_add_txt ).

  IF lt_add_txt[] IS INITIAL.
**   3rd: try ID_INTRENO
*    CALL METHOD cf_recn_contract=>find_by_intreno
*      EXPORTING
*        id_intreno  = gs_recn-intreno
*        id_activity = reca1_activity-change "02
*      RECEIVING
*        ro_instance = go_cn
*      EXCEPTIONS
*        error       = 1.
*    IF sy-subrc NE 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      RETURN.
*    ENDIF.
*    lo_text_mngr->insert_category(
*       EXPORTING
*    id_textcate = ld_cate
*       EXCEPTIONS
*    error = 1
*    OTHERS = 2 ).
*    IF sy-subrc = 0.
*      lo_text_mngr->store(
*         EXPORTING
*            if_in_update_task = abap_false
*        EXCEPTIONS
*           error = 1
*        OTHERS = 2 ).
*
*    ENDIF.
  ENDIF.
* category holen
*  lo_text =  lo_text_mngr->get_text_ref( ld_cate ).
*  IF NOT lo_text IS BOUND.
*    RETURN.
*  ENDIF.
*  lo_text->get_text_as_itf(
*      IMPORTING
*           et_text = lt_text ).
** string generieren
*  rd_text = REDUCE #( INIT ld_string2 TYPE string FOR ls_text IN lt_text
*        NEXT ld_string2 = ld_string && ls_text-tdline && cl_abap_char_utilities=>cr_lf ).
*
*  IF NOT l_text IS INITIAL.
*    SPLIT l_text  AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(lt_text_string).
*    lt_text = VALUE #( FOR ld_string IN lt_text_string tdformat = '*' ( tdline = ld_string ) ).
*  ENDIF.
*  DATA: lt_add_text_categories_cn TYPE re_t_text_category_x,
*        ls_add_text_of            TYPE reca_additional_text,
*        lo_text_of                TYPE REF TO if_reca_text,
*        lo_text_cn                TYPE REF TO if_reca_text.
*
*  CALL METHOD lo_text_mngr->get_categories_for_insert
*    IMPORTING
*      et_list_x = lt_add_text_categories_cn.
*  LOOP AT lt_add_txt INTO ls_add_txt.
*    READ TABLE lt_add_text_categories_cn TRANSPORTING NO FIELDS
*      WITH KEY textcate = ls_add_txt-textcate.
*    IF sy-subrc = 0.
**      CALL METHOD lo_text_mngr->insert_category
**        EXPORTING
**          id_textcate = ls_add_text_of-textcate
**        EXCEPTIONS
**          error       = 1
**          OTHERS      = 2.
**      IF sy-subrc NE 0.
**
**        DATA(ls_text_cate) = VALUE vicaaddtext( mandt = sy-mandt addtextguid = cl_reca_guid=>get_new_guid( ) intreno = gs_recn-intreno textcate = ld_cate ).
**        DATA: lo_bus_obj TYPE REF TO if_reca_bus_object.
**        DATA: lo_text_mngr2 TYPE REF TO if_reca_additional_text_mngr.
**        DATA: lo_text2 TYPE REF TO if_reca_text.
**        CALL FUNCTION 'REDB_VICAADDTEXT_UPDATE_S'
**          EXPORTING
**            is_vicaaddtext       = ls_text_cate
**            id_operation         = 'I'
**          EXCEPTIONS
**            db_failure           = 1
**            db_operation_unknown = 2.
**        IF sy-subrc = 0.
**          COMMIT WORK AND WAIT.
**          lo_bus_obj = cf_reca_bus_object=>find_by_intreno( gs_recn-intreno ).
***         lo_text_mngr2 = CAST if_reca_has_additional_text( lo_bus_obj )->get_additional_text_mngr( ).
**          lo_text_mngr->get_list( IMPORTING et_list = DATA(lt_text_cate_list) ).
**          INSERT ls_text_cate INTO TABLE lt_text_cate_list.
**          lo_text_mngr->set_list( lt_text_cate_list ).
**          lo_text = lo_text_mngr2->get_text_ref( ld_cate ).
**        ENDIF.
*
*
*    ENDIF.
*
*    CALL METHOD lo_text_mngr->get_text_ref
*      EXPORTING
*        id_textcate = ld_cate
*      RECEIVING
*        ro_text     = lo_text_of
*      EXCEPTIONS
*        OTHERS      = 1.
*    IF sy-subrc <> 0.
*      CONTINUE.
*    ENDIF.
*
*    CALL METHOD lo_text_mngr->get_text_ref
*      EXPORTING
*        id_textcate = ld_cate
*      RECEIVING
*        ro_text     = lo_text_cn
*      EXCEPTIONS
*        OTHERS      = 1.
*    IF sy-subrc <> 0.
*      CONTINUE.
*    ENDIF.
*
*    IF lo_text_of->is_empty( ) = abap_false.
*      CALL METHOD lo_text_of->get_text_as_itf
*        IMPORTING
*          et_text = lt_text.
*      CALL METHOD lo_text_cn->set_text_as_itf
*        EXPORTING
*          it_text = lt_text.
*    ELSE.
*      CALL METHOD lo_text_cn->delete_text.
*    ENDIF.
*
*  ENDLOOP.
**    REFRESH lt_text_bak.
**    CALL METHOD lo_text_srv->get_text
**      EXPORTING
**        id_textcate = ls_add_txt-textcate
**      IMPORTING
**        et_text_itf = lt_text_bak.
*** alte Notizen speichern
**    APPEND LINES OF lt_text_bak  TO lt_text.
*
*
**text initialisieren
*  lo_text->init(
*    EXPORTING
*      id_tdobject       = lo_text->md_tdobject    " Application Object
*      id_tdname         = lo_text->md_tdname    " Text name
*      id_tdid           = lo_text->md_tdid    " Text ID
*      id_tdspras        = lo_text->md_tdspras    " Language Key
*      id_activity       = '02'    " Activity: Change/display?
*      if_enqueue        = abap_false    " Tech: Use default blocks?
*      io_text_mngr      = lo_text->mo_text_mngr    " Text Manager
*    EXCEPTIONS
*      text_inconsistent = 1
*      OTHERS            = 2 ).
** Notiz speichern
*  lo_text->set_text_as_itf( it_text = lt_text ).
** FUBA aufrufen
** Text Editor anzeigen
*  CALL FUNCTION 'RECA_GUI_TEXTEDIT_POPUP'
*    EXPORTING
*      io_text               = lo_text
*      if_readonly           = abap_false
*      if_support_formatting = abap_false
*      id_title              = 'Kundenübersicht'
*      id_activity           = reca1_activity-change "02
*    IMPORTING
*      ef_text_changed       = ld_text_changed
*    EXCEPTIONS
*      text_inconsistent     = 1
*      foreign_lock          = 2
*      OTHERS                = 3.
** Besonderheiten WE aktualisieren
*  CALL METHOD lo_text->get_text_as_itf
*    IMPORTING
*      et_text = lt_text.
** store
*  IF lo_text->is_modified( ) = abap_true.
*    CALL METHOD go_cn->store
*      EXPORTING
*        if_in_update_task = abap_false
*      EXCEPTIONS
*        error             = 1
*        OTHERS            = 2.
*    IF sy-subrc = 0.
*      CALL METHOD cf_reca_storable=>commit
*        EXPORTING
*          if_wait         = abap_true
*          if_reset_buffer = abap_true.
*
*    ELSE.
*      go_cn->free( ).
*      RETURN.
*    ENDIF.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_TICKET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_ticket_cn USING p_dynpro.
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
    lt_notice       TYPE TABLE OF string,
    ls_langtext_t   TYPE string,
*    ls_children_wd    TYPE /promos/s_ct_data_wd,
*    ls_initiator      TYPE /promos/s_crm_cust_fields,
*    ls_codes          TYPE /promos/s_codes_wd,
    ls_dynpro_cn_02 LIKE gs_dynpro_cn_01,
    ls_recn         LIKE gs_recn.

  FIELD-SYMBOLS: <ticket_cn> LIKE gs_ticket_cn.
*------------------------

* Metadaten aus dem Customer-Control holen
  CALL METHOD go_alv_ticket_cn->get_metadata."Bei Container rufen
  REFRESH  lt_rows.

* Markierspalte holen
  lo_selections = go_alv_ticket_cn->get_selections( ).  "
  lt_rows = lo_selections->get_selected_rows( ).
  IF lines( lt_rows ) = 0.
    IF NOT gd_row IS INITIAL.
      APPEND   gd_row TO lt_rows.
    ENDIF.
  ENDIF.
  IF lines( lt_rows ) = 0.
    lt_rows = lo_selections->get_selected_rows( ).
    IF lines( lt_rows ) = 0.
      MESSAGE i033(recabc).
      LEAVE TO SCREEN 0.
      RETURN.
    ENDIF.
  ENDIF.

  CLEAR gd_row.

  ls_dynpro_cn_02 =  gs_dynpro_cn_02.
*Langtext der Notiz initialisieren
  REFRESH: lt_notice.
  LOOP AT lt_rows INTO ld_row.
    READ TABLE gt_ticket_cn ASSIGNING <ticket_cn>  INDEX ld_row.
* Zeile gefunden?
*    IF sy-subrc = 0.
*      MOVE-CORRESPONDING <ticket_cn> TO gs_dynpro_cn_02.
*      gs_dynpro_cn_02-recnnr = <ticket_cn>-relation+4.
** orginal-ticket lesen
*      READ TABLE gt_tickets_bak_cn INTO ls_tickets_bak_cn
*       WITH KEY  id_txt = <ticket_cn>-teilnr_main.
*      IF sy-subrc = 0.
*        lt_notice[] = ls_tickets_bak_cn-langtext_t[].
** orginal-ticket lesen
*        LOOP AT ls_tickets_bak_cn-t_children INTO ls_children_wd.
*          MOVE-CORRESPONDING ls_children_wd TO gs_dynpro_cn_02.
*          gs_dynpro_cn_02-kurztext = ls_children_wd-bezeichnung.
*          lt_notice[] =  ls_children_wd-langtext_t[].
*          gs_dynpro_cn_02-status = ls_children_wd-status.
*          gs_dynpro_cn_02-teilnr = ls_children_wd-id_txt.
*          gs_dynpro_cn_02-prio = ls_children_wd-prio.
*          WRITE ls_children_wd-strmn TO gs_dynpro_cn_02-strmn.
*          WRITE ls_children_wd-ltrmn TO gs_dynpro_cn_02-ltrmn.
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
*          WRITE ls_tickets_bak_cn-strmn TO gs_dynpro_cn_02-strmn.
*          WRITE ls_tickets_bak_cn-ltrmn TO gs_dynpro_cn_02-ltrmn.
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
*        IF gs_dynpro_cn_02-recnnr IS INITIAL.
*          gs_dynpro_cn_02-recnnr  = gs_recn-recnnr.
*        ENDIF.
** Ticket wurden geändert
*        IF NOT ls_dynpro_cn_02-status IS INITIAL.
*          gs_dynpro_cn_02-status = ls_dynpro_cn_02-status.
*        ENDIF.
*        IF NOT ls_dynpro_cn_02-prio  IS INITIAL.
*          gs_dynpro_cn_02-prio = ls_dynpro_cn_02-prio.
*        ENDIF.
** Status
*        READ TABLE gt_status INTO gs_status WITH KEY  low = gs_dynpro_cn_02-status.
*        IF sy-subrc = 0.
*          gs_dynpro_cn_02-status_text = gs_status-ddtext.
*        ENDIF.
*      ENDIF.
*      IF  gs_dynpro_cn_02-recnnr   = gs_recn-recnnr.
*        gs_dynpro_cn_02-recntxt  = gs_recn-xmbez.
*      ELSE.
** VertragsartText holen
*        READ TABLE  gt_recn INTO ls_recn WITH KEY
*        recnnr =  gs_dynpro_cn_02-recnnr.
*        IF sy-subrc = 0.
*          gs_dynpro_cn_02-recntxt  = ls_recn-xmbez.
*        ELSE.
*          gs_dynpro_cn_02-recntxt  = gs_recn-xmbez.
*        ENDIF.
*      ENDIF.
**      gs_dynpro_cn_02-initiator  = ls_tickets_cn-initiator.
**      gs_dynpro_cn_02-recnnr  = <ticket_cn>-bezeichnung.
**      gs_dynpro_cn_02-prio  = <ticket_cn>-bezeichnung.
**      gs_dynpro_cn_02-strmn   = <ticket_cn>-bezeichnung.
**      gs_dynpro_cn_02-ltrmn    = <ticket_cn>-bezeichnung.
**      gs_dynpro_cn_02-code  = <ticket_cn>-bezeichnung.
**      gs_dynpro_cn_02-contact_name  = <ticket_cn>-bezeichnung.
**      gs_dynpro_cn_02-contact_telnumber  = <ticket_cn>-bezeichnung.
**     gs_dynpro_cn_02-kurztext   =  ls_tickets_cn-bezeichnung.
**      gs_dynpro_cn_02-text_add  = <ticket_cn>-bezeichnung.
*
*    ENDIF.

  ENDLOOP.
  IF sy-subrc = 0.
* Ticket mit Notiz anreichern
    PERFORM get_notice_02
        TABLES lt_notice
        USING p_dynpro.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_TICKET
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_ticket_ro USING p_dynpro.
  DATA:
    lo_selections TYPE REF TO cl_salv_selections,
    ls_cell       TYPE salv_s_cell,
    lt_cell       TYPE salv_t_cell,
    lt_rows       TYPE salv_t_row,
    ld_row        TYPE i,
    lt_cols       TYPE salv_t_column,
    ls_cols       LIKE LINE OF lt_cols.
  DATA:
*    ls_tickets_bak_ro LIKE LINE OF gt_tickets_bak_ro,
    lt_notice       TYPE TABLE OF string,
    ls_langtext_t   TYPE string,
*    ls_children_wd    TYPE /promos/s_ct_data_wd,
*    ls_initiator      TYPE /promos/s_crm_cust_fields,
*    ls_codes          TYPE /promos/s_codes_wd,
    ls_dynpro_ro_02 LIKE gs_dynpro_ro_01,
    ls_recn         LIKE gs_recn.

  FIELD-SYMBOLS: <ticket_ro> LIKE gs_ticket_ro.
*------------------------

* Metadaten aus dem Customer-Control holen
  CALL METHOD go_alv_ticket_ro->get_metadata."Bei Container rufen

  REFRESH  lt_rows.
* Markierspalte holen
  lo_selections = go_alv_ticket_ro->get_selections( ).  "
* Zeilen holen
  lt_rows = lo_selections->get_selected_rows( ).

  IF lines( lt_rows ) = 0.
    IF NOT gd_row IS INITIAL.
      APPEND   gd_row TO lt_rows.
    ENDIF.
  ENDIF.
  IF lines( lt_rows ) = 0.
    MESSAGE i033(recabc).
    LEAVE TO SCREEN 0.
    RETURN.
  ENDIF.

  CLEAR gd_row.
  ls_dynpro_ro_02 =  gs_dynpro_ro_02.
*Langtext der Notiz initialisieren
  REFRESH: lt_notice.
  LOOP AT lt_rows INTO ld_row.
    READ TABLE gt_ticket_ro ASSIGNING <ticket_ro>  INDEX ld_row.
* Zeile gefunden?
*    IF sy-subrc = 0.
*      MOVE-CORRESPONDING <ticket_ro> TO gs_dynpro_ro_02.
*      gs_dynpro_ro_02-teilnr_master = <ticket_ro>-teilnr.
**     gs_dynpro_ro_02-tplnr = <ticket_ro>-relation+4.
** orginal-ticket lesen
*      READ TABLE gt_tickets_bak_ro INTO ls_tickets_bak_ro
*       WITH KEY  id_txt = <ticket_ro>-teilnr.
*      IF sy-subrc = 0.
*        lt_notice[] = ls_tickets_bak_ro-langtext_t[].
*        LOOP AT ls_tickets_bak_ro-cust_fields INTO ls_initiator
*        WHERE fieldtext = 'Initiatoren'.
*          gs_dynpro_ro_02-initiator  = ls_initiator-value.
*        ENDLOOP.
** orginal-ticket lesen
*        LOOP AT ls_tickets_bak_ro-t_children INTO ls_children_wd.
*          MOVE-CORRESPONDING ls_children_wd TO gs_dynpro_ro_02.
**     gs_dynpro_ro_02-pltxt  = ls_children_wd-pltxt.
*          gs_dynpro_ro_02-kurztext = ls_children_wd-bezeichnung.
*          lt_notice[] =  ls_children_wd-langtext_t[].
*          gs_dynpro_ro_02-status = ls_children_wd-status.
*          gs_dynpro_ro_02-teilnr = ls_children_wd-id_txt.
*          gs_dynpro_ro_02-prio = ls_children_wd-prio.
*          gs_dynpro_ro_02-pltxt = ls_children_wd-relation_text.
*          WRITE ls_children_wd-strmn TO gs_dynpro_ro_02-strmn.
*          WRITE ls_children_wd-ltrmn TO gs_dynpro_ro_02-ltrmn.
*          CONCATENATE ls_children_wd-codegruppe ls_children_wd-code INTO
*                  gs_dynpro_ro_02-code.
*          READ TABLE gt_codes_all INTO ls_codes WITH KEY
*          codegruppe = ls_children_wd-codegruppe
*          code = ls_children_wd-code.
*          IF sy-subrc = 0.
*            CONCATENATE ls_codes-kurztext_grp  ls_codes-kurztext INTO
*                        gs_dynpro_ro_02-code_text SEPARATED BY '-'.
*          ENDIF.
*        ENDLOOP.
*
*        IF sy-subrc NE 0.
*
*          gs_dynpro_ro_02-urspr  = ls_tickets_bak_ro-urspr .
*          gs_dynpro_ro_02-status =  ls_tickets_bak_ro-status.
*          gs_dynpro_ro_02-kurztext   =  ls_tickets_bak_ro-bezeichnung.
*          gs_dynpro_ro_02-prio  = ls_tickets_bak_ro-prio.
*          WRITE ls_tickets_bak_ro-strmn TO gs_dynpro_ro_02-strmn.
*          WRITE ls_tickets_bak_ro-ltrmn TO gs_dynpro_ro_02-ltrmn.
*          CONCATENATE ls_tickets_bak_ro-codegruppe ls_tickets_bak_ro-code INTO
*          gs_dynpro_ro_02-code.
*          LOOP AT ls_tickets_bak_ro-langtext_t INTO ls_langtext_t.
*            APPEND ls_langtext_t TO lt_notice.
*          ENDLOOP.
*        ENDIF.
*        IF gs_dynpro_ro_02-initiator IS INITIAL.
*          LOOP AT ls_tickets_bak_ro-cust_fields INTO ls_initiator
*          WHERE fieldtext = 'Initiatoren'.
*            gs_dynpro_ro_02-initiator  = ls_initiator-value.
*          ENDLOOP.
*        ENDIF.
** allgemeine Felder übergeben
** Ticket wurden geändert
*        IF NOT ls_dynpro_ro_02-status IS INITIAL.
*          gs_dynpro_ro_02-status = ls_dynpro_ro_02-status.
*        ENDIF.
*        IF NOT ls_dynpro_ro_02-prio  IS INITIAL.
*          gs_dynpro_ro_02-prio = ls_dynpro_ro_02-prio.
*        ENDIF.
** Status
*        READ TABLE gt_status INTO gs_status WITH KEY  low = gs_dynpro_ro_02-status.
*        IF sy-subrc = 0.
*          gs_dynpro_ro_02-status_text = gs_status-ddtext.
*        ENDIF.
*      ENDIF.
*    ELSE.
*
**      gs_dynpro_ro_02-initiator  = ls_tickets_ro-initiator.
**      gs_dynpro_ro_02-recnnr  = <ticket_ro>-bezeichnung.
**      gs_dynpro_ro_02-prio  = <ticket_ro>-bezeichnung.
**      gs_dynpro_ro_02-strmn   = <ticket_ro>-bezeichnung.
**      gs_dynpro_ro_02-ltrmn    = <ticket_ro>-bezeichnung.
**      gs_dynpro_ro_02-code  = <ticket_ro>-bezeichnung.
**      gs_dynpro_ro_02-contact_name  = <ticket_ro>-bezeichnung.
**      gs_dynpro_ro_02-contact_telnumber  = <ticket_ro>-bezeichnung.
**     gs_dynpro_ro_02-kurztext   =  ls_tickets_ro-bezeichnung.
**      gs_dynpro_ro_02-text_add  = <ticket_ro>-bezeichnung.
*
*    ENDIF.

  ENDLOOP.
  IF sy-subrc = 0.
* Ticket mit Notiz anreichern
    PERFORM get_notice_ro_02
        TABLES lt_notice
        USING  p_dynpro.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  PAI_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0200 INPUT.

  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXIT_CN_01'.
      go_dock_notice_01->free( ).
      FREE go_dock_notice_01.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE_CN_01'.
* Ticket speichern
      PERFORM set_ticket_cn.
* ALV neue aufbauen
      PERFORM get_new_ticket_cn.
* Tabelle neu aufbauen
      CALL METHOD go_alv_ticket_cn->refresh( refresh_mode = 2 ).
      cl_gui_cfw=>flush( ).
      CLEAR gs_dynpro_cn_01.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SET_TICKET_CN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text CT_CONTROLLER METHOD add_ct_work
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_ticket_cn .
*  DATA: lo_nd_ct_work            TYPE REF TO if_wd_context_node,
*        ls_ct_work               TYPE /promos/s_ct_data_wd,
*        ls_ct_work_temp          TYPE /promos/s_ct_data_wd,
*        lo_nd_codes              TYPE REF TO if_wd_context_node,
*        lt_codes                 TYPE /promos/s_codes_wd,
*        lo_nd_ct_ticket_teilproz TYPE REF TO if_wd_context_node,
*        lt_ct_ticket_teilproz    TYPE TABLE OF /promos/s_ct_data_wd,
*        ls_ct_ticket_teilproz    LIKE LINE OF lt_ct_ticket_teilproz,
*        ls_crm_cust              LIKE /promos/crm_cust,
*        lo_fe_badi               TYPE REF TO /promos/crm_fe_badi,
*        lt_cust_field            TYPE /promos/tt_crm_cust_fields,
*        ls_cust_field            LIKE LINE OF lt_cust_field,
*        lv_create_update         TYPE char6,
*        lt_return_badi           TYPE bapiret2_t,
*        lv_error_badi            TYPE oax,
*        ld_fdpos                 TYPE sy-fdpos.
*
*  DATA: lt_msg          TYPE cl_wd_dynamic_tool=>t_check_result_message_tab,
*        li_lines        TYPE i,
*        lt_return       TYPE bapiret2_t,
*        ls_return       TYPE bapiret2,
*        lv_code_allowed TYPE oax,
*        lv_error_found  TYPE oax,
*        lt_lines_text   TYPE texttab,
*        ls_lines_text   LIKE LINE OF lt_lines_text,
*        lt_linetab      TYPE tlinetab,
*        lf_modified     TYPE i.
*
*  DATA: lo_msglist       TYPE REF TO if_reca_message_list.
*  DATA lo_nd_ct_ticket            TYPE REF TO if_wd_context_node.
*  DATA ls_ct_ticket               TYPE /promos/s_ct_data_wd.
*  DATA ld_doc_relation TYPE /promos/e_crm_teilguid.
*  DATA: ls_bupa_work TYPE /promos/s_bupa_data_wd.
*  DATA: ld_datum(10).
*  FIELD-SYMBOLS: <teilpror> TYPE /promos/s_ct_data_wd.
**---------------------------*
** Text holen
*  CALL METHOD go_dock_notice_01->get_text_as_stream
*    EXPORTING
*      only_when_modified = 1
*    IMPORTING
*      text               = lt_lines_text
*      is_modified        = lf_modified.
*
*  CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
*    TABLES
*      text_stream = lt_lines_text
*      itf_text    = lt_linetab.
*
** Ticket aufbauen
*  CLEAR ls_ct_work.
*  IF gs_dynpro_cn_01 IS INITIAL.
*    EXIT.
*  ENDIF.
** Message aufbauen
*  lo_msglist = cf_reca_message_list=>create( ).
** Daten mappen
*  MOVE-CORRESPONDING gs_dynpro_cn_01 TO ls_ct_work.
*  ls_ct_work-bezeichnung = gs_dynpro_cn_01-kurztext.
*  ls_ct_work-partner  = gs_recn-partner.
*  CALL METHOD cl_reca_date=>convert_date_to_internal
*    EXPORTING
*      id_date_external = gs_dynpro_cn_01-strmn
*    IMPORTING
*      ed_date_internal = ls_ct_work-strmn.
** ls_ct_work-strmn = gs_dynpro_cn_01-strmn.
** ls_ct_work-ltrmn = gs_dynpro_cn_01-ltrmn.
*  CALL METHOD cl_reca_date=>convert_date_to_internal
*    EXPORTING
*      id_date_external = gs_dynpro_cn_01-ltrmn
*    IMPORTING
*      ed_date_internal = ls_ct_work-ltrmn.
*  CONCATENATE gs_recn-bukrs gs_dynpro_cn_01-recnnr INTO
*    ls_ct_work-relation.
** ls_ct_work-relation_cn = gs_recn-recnnr.
*  ls_ct_work-relation_own_cn = ls_ct_work-relation.
*  ls_ct_work-ticket_type = '01'.
*  ls_ct_work-ticket_type_lnr = '01'.
** ls_ct_work-objtyp = 'BUS1505'.
*  LOOP AT lt_lines_text INTO ls_lines_text.
*    CONCATENATE  ls_ct_work-langtext  ls_lines_text INTO
*      ls_ct_work-text_add.
*  ENDLOOP.
*  SEARCH gs_dynpro_cn_01-code FOR '-'.
*  IF sy-subrc = 0.
*    ls_ct_work-codegruppe = gs_dynpro_cn_01-code(sy-fdpos).
*    ld_fdpos  = sy-fdpos.
*    ld_fdpos = ld_fdpos + 1.
*    ls_ct_work-code = gs_dynpro_cn_01-code+ld_fdpos.
*  ENDIF.
*
** Plausi-Checks: Sachverhalt, Codegruppe/Code
*  IF ls_ct_work-codegruppe IS INITIAL OR ls_ct_work-code IS INITIAL.
**   Bitte geben Sie einen Sachverhalt (Codegruppe/Code) an.
*    ls_return-type = 'E'.
*    MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '022' INTO ls_return-message.
*    APPEND ls_return TO lt_return.
*    lv_error_found = abap_true.
*  ELSE.
*
**    go_assistance->check_code_by_prio(
**      EXPORTING
**        is_ct_work = ls_ct_work
**      IMPORTING
**        ev_code_allowed = lv_code_allowed ).
*
*    IF lv_code_allowed = abap_false.
**     Wenn es überhaupt Codes gibt, aber keiner davon eingetragen wurde
*      ls_return-type = 'E'.
*      MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '025'
*        WITH ls_ct_work-code ls_ct_work-codegruppe
*        INTO ls_return-message.
*      ls_return-type = 'E'.
*      ls_return-id = '/PROMOS/NK_CRM'.
*      ls_return-number = '025'.
*      ls_return-message_v1 = ls_ct_work-code.
*      ls_return-message_v2 =  ls_ct_work-codegruppe.
*      APPEND ls_return TO lt_return.
*      lv_error_found = abap_true.
** Message aufbauen
*      CALL METHOD lo_msglist->add_from_bapi
*        EXPORTING
*          it_bapiret = lt_return.
*      IF NOT lt_return[] IS INITIAL.
*        LOOP AT lt_return INTO ls_return WHERE
*        type = 'E'.
*          EXIT.
*        ENDLOOP.
*        IF sy-subrc = 0.
*          CALL FUNCTION 'RECA_GUI_MSGLIST_POPUP'
*            EXPORTING
*              io_msglist = lo_msglist.
*        ENDIF.
*      ENDIF.
*      RETURN.
*    ENDIF.
*  ENDIF.
*
** zugeordnetes Objekt
*  IF    ls_ct_work-relation_cn  IS INITIAL
*     AND ls_ct_work-relation_obj IS INITIAL
*     AND ls_ct_work-relation_own_cn IS INITIAL
*     AND ls_ct_work-relation_own_tp IS INITIAL
*     AND ls_ct_work-rel_partner IS INITIAL.
**   Bitte ordnen Sie das Ticket einem Partner, Vertrag, TP oder RE-Obj. zu.
*    ls_return-type = 'E'.
**   CALL FUNCTION 'MESSAGE_TEXT_BUILD'.
*    MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '023' INTO ls_return-message.
*    APPEND ls_return TO lt_return.
*    lv_error_found = abap_true.
*  ENDIF.
*
** Pflichtfeld prüfen,
*  IF ls_ct_work-additional_relation IS INITIAL. "Nur auf Pflichtfeld prüfen, wenn nicht eh ausgefüllt
*
*    READ TABLE go_assistance->mt_crm_cust INTO ls_crm_cust
*      WITH KEY ticket_type = ls_ct_work-ticket_type
*               ticket_type_lnr = ls_ct_work-ticket_type_lnr.
*
*    IF sy-subrc EQ 0
*      AND ls_crm_cust-additional_relation_schrnr IS NOT INITIAL
*      AND ls_crm_cust-additional_relation EQ 2. "Das ist lt. Cust dann ein Pflichtfeld
*
*      ls_return-type = 'E'.
*      MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '009' INTO ls_return-message.
*      APPEND ls_return TO lt_return.
*      lv_error_found = abap_true.
*    ENDIF.
*  ENDIF.
*
*  lv_create_update = 'CREATE'.
*
*  GET BADI lo_fe_badi.
*  CALL BADI lo_fe_badi->check_ticket_before_save
*    EXPORTING
*      iv_create_update = lv_create_update
*      is_ticket        = ls_ct_work
*      it_relations     = go_assistance->mt_relations
*    CHANGING
*      ct_return        = lt_return_badi
*      cv_error         = lv_error_badi.
*
** Fehler, wenn Kennzeichen gesetzt oder mind. eine Fehlermeldung im BADI
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*
*  IF lv_error_badi = abap_true.
*    lv_error_found = abap_true.
*    APPEND LINES OF lt_return_badi TO lt_return.
*  ENDIF.
*
** Customzing-Felder (Initiatoren)
*  ls_cust_field-seq  =   '115'.
*  ls_cust_field-fieldtext  = 'Initiatoren'.
*  ls_cust_field-is_kat  =   'X'.
** ls_cust_field-t_value_help[]  = go_assistance->mt_cust_fields[].
*  ls_cust_field-value   = gs_dynpro_cn_01-initiator.
*  APPEND  ls_cust_field TO ls_ct_work-cust_fields.
*
**Übernahme des Notiztextes erst nach Prüfungen, ls_ct_work übergeben, Langtext muss angefügt werden
*  PERFORM add_text USING ls_ct_work.
*
*  ls_ct_work-objtyp = 'BUS1505'. "Vertrag
*
*  CALL METHOD go_assistance->enrich_ct_line
*    EXPORTING
*      is_ct_data_wd = ls_ct_work
*    IMPORTING
*      es_ct_data_wd = ls_ct_work.
*
** ist der Teilprozess neu, oder schon in der Tabelle (Bearbeitung)
*  IF ls_ct_work-fe_id IS NOT INITIAL.
*    READ TABLE lt_ct_ticket_teilproz WITH KEY fe_id = ls_ct_work-fe_id TRANSPORTING NO FIELDS.
*    IF sy-subrc EQ 0.
*      MODIFY lt_ct_ticket_teilproz INDEX sy-tabix
*        FROM ls_ct_work.
*    ELSE.
*      APPEND ls_ct_work TO lt_ct_ticket_teilproz.
*    ENDIF.
*  ENDIF.
*
** wenn ein übergeordnetes Ticket ausgewählt wurde dessen Daten übernehmen
** IF ls_ct_work-id IS INITIAL OR ls_ct_ticket-bezeichnung IS INITIAL.
*  WRITE sy-datum+ TO
*  ld_datum.
*  CONCATENATE 'Ticket' '[' gs_recn-name_last ']' space '[' ld_datum  ']'
*    INTO ls_ct_work-bezeichnung SEPARATED BY space.
*  CONDENSE ls_ct_work-bezeichnung.
** ENDIF.
*
** Ticket speichern
**   BP erweitern
*  CALL METHOD go_assistance->enrich_bupa_line
*    EXPORTING
*      is_bupa_data    = gs_bupa_data
*    IMPORTING
*      es_bupa_data_wd = ls_bupa_work.
*
*
** clearen und refreshen, damit als Vertrag gespeichert
*  ls_ct_work_temp =  ls_ct_work.
*  CLEAR  ls_ct_work.
*
*  ls_ct_work-bezeichnung = ls_ct_work_temp-bezeichnung.
*  ls_ct_work-partner = ls_ct_work_temp-partner.
*  ls_ct_work-objtyp  = 'BUS1006'.
*  ls_ct_work-urspr =  ls_ct_work_temp-urspr.
*  ls_ct_work-cust_fields[] = ls_ct_work_temp-cust_fields[].
**  CLEAR: ls_ct_work-ticket_type, ls_ct_work-ticket_type_lnr," ls_ct_work-partner,
**  ls_ct_work-codegruppe, ls_ct_work-code, ls_ct_work-prio, ls_ct_work-urspr,
**  ls_ct_work-RELATION.
*  REFRESH:ls_ct_work-langtext_t.
*  LOOP AT lt_ct_ticket_teilproz ASSIGNING <teilpror>.
*    CLEAR: <teilpror>-urspr.
*    REFRESH: <teilpror>-cust_fields.
*  ENDLOOP.
*  CALL METHOD go_assistance->save_crm_ticket
*    EXPORTING
*      is_crm_coverticket = ls_ct_work
*      it_crm_teiltickets = lt_ct_ticket_teilproz
*      iv_doc_relation    = ld_doc_relation
*      is_bupa_work       = ls_bupa_work
*    IMPORTING
*      et_return          = lt_return.
*
** Message
*  CALL METHOD lo_msglist->add_from_bapi
*    EXPORTING
*      it_bapiret = lt_return.
*  IF NOT lt_return[] IS INITIAL.
*    LOOP AT lt_return INTO ls_return WHERE
*    type = 'E'.
*      EXIT.
*    ENDLOOP.
*    IF sy-subrc = 0.
*      CALL FUNCTION 'RECA_GUI_MSGLIST_POPUP'
*        EXPORTING
*          io_msglist = lo_msglist.
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TICKET_RO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text CT_CONTROLLER METHOD add_ct_work
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_ticket_ro .
*  DATA: lo_nd_ct_work            TYPE REF TO if_wd_context_node,
*        ls_ct_work               TYPE /promos/s_ct_data_wd,
*        ls_ct_work_temp          TYPE /promos/s_ct_data_wd,
*        lo_nd_codes              TYPE REF TO if_wd_context_node,
*        lt_codes                 TYPE /promos/s_codes_wd,
*        lo_nd_ct_ticket_teilproz TYPE REF TO if_wd_context_node,
*        lt_ct_ticket_teilproz    TYPE TABLE OF /promos/s_ct_data_wd,
*        ls_ct_ticket_teilproz    LIKE LINE OF lt_ct_ticket_teilproz,
*        ls_crm_cust              LIKE /promos/crm_cust,
*        lo_fe_badi               TYPE REF TO /promos/crm_fe_badi,
*        lt_cust_field            TYPE /promos/tt_crm_cust_fields,
*        ls_cust_field            LIKE LINE OF lt_cust_field,
*        lv_create_update         TYPE char6,
*        lt_return_badi           TYPE bapiret2_t,
*        lv_error_badi            TYPE oax,
*        ld_fdpos                 TYPE sy-fdpos.
*
*  DATA: lt_msg          TYPE cl_wd_dynamic_tool=>t_check_result_message_tab,
*        li_lines        TYPE i,
*        lt_return       TYPE bapiret2_t,
*        ls_return       TYPE bapiret2,
*        lv_code_allowed TYPE oax,
*        lv_error_found  TYPE oax,
*        lt_lines_text   TYPE texttab,
*        ls_lines_text   LIKE LINE OF lt_lines_text,
*        lt_linetab      TYPE tlinetab,
*        lf_modified     TYPE i.
*  DATA: lo_msglist       TYPE REF TO if_reca_message_list.
*  DATA lo_nd_ct_ticket            TYPE REF TO if_wd_context_node.
*  DATA ls_ct_ticket               TYPE /promos/s_ct_data_wd.
*  DATA ld_doc_relation TYPE /promos/e_crm_teilguid.
*  DATA: ls_bupa_work TYPE /promos/s_bupa_data_wd.
*  DATA: ld_datum(10).
*  FIELD-SYMBOLS: <teilpror> TYPE /promos/s_ct_data_wd.
**---------------------------*
** Metadaten aus dem Customer-Control holen
*  CALL METHOD go_alv_ticket_ro->get_metadata."Bei Container rufen
** Text holen
*  CALL METHOD go_dock_notice_ro_01->get_text_as_stream
*    EXPORTING
*      only_when_modified = 1
*    IMPORTING
*      text               = lt_lines_text
*      is_modified        = lf_modified.
*
*  CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
*    TABLES
*      text_stream = lt_lines_text
*      itf_text    = lt_linetab.
*
** Ticket aufbauen
*  CLEAR ls_ct_work.
*  IF gs_dynpro_ro_01 IS INITIAL.
*    EXIT.
*  ENDIF.
** Message initialisieren
*  lo_msglist = cf_reca_message_list=>create( ).
** Daten mappen
*  MOVE-CORRESPONDING gs_dynpro_ro_01 TO ls_ct_work.
*  ls_ct_work-bezeichnung = gs_dynpro_ro_01-kurztext.
*  ls_ct_work-partner  = gs_recn-partner.
*  CALL METHOD cl_reca_date=>convert_date_to_internal
*    EXPORTING
*      id_date_external = gs_dynpro_ro_01-strmn
*    IMPORTING
*      ed_date_internal = ls_ct_work-strmn.
** ls_ct_work-strmn = gs_dynpro_cn_01-strmn.
** ls_ct_work-ltrmn = gs_dynpro_cn_01-ltrmn.
*  CALL METHOD cl_reca_date=>convert_date_to_internal
*    EXPORTING
*      id_date_external = gs_dynpro_ro_01-ltrmn
*    IMPORTING
*      ed_date_internal = ls_ct_work-ltrmn.
*
*  ls_ct_work-relation = gs_dynpro_ro_01-tplnr.
** ls_ct_work-relation_cn = gs_recn-recnnr.
*  ls_ct_work-relation_own_cn = ls_ct_work-relation.
*  ls_ct_work-ticket_type = '02'.
*  ls_ct_work-ticket_type_lnr = '06'.
*  ls_ct_work-objtyp = 'BUS1006'.
*  LOOP AT lt_lines_text INTO ls_lines_text.
*    CONCATENATE  ls_ct_work-langtext  ls_lines_text INTO
*      ls_ct_work-text_add.
*  ENDLOOP.
*  SEARCH gs_dynpro_ro_01-code FOR '-'.
*  IF sy-subrc = 0.
*    ls_ct_work-codegruppe = gs_dynpro_ro_01-code(sy-fdpos).
*    ld_fdpos  = sy-fdpos.
*    ld_fdpos = ld_fdpos + 1.
*    ls_ct_work-code = gs_dynpro_ro_01-code+ld_fdpos.
*  ENDIF.
*
** Plausi-Checks: Sachverhalt, Codegruppe/Code
*  IF ls_ct_work-codegruppe IS INITIAL OR ls_ct_work-code IS INITIAL.
**   Bitte geben Sie einen Sachverhalt (Codegruppe/Code) an.
*    ls_return-type = 'E'.
*    MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '022' INTO ls_return-message.
*    APPEND ls_return TO lt_return.
*    lv_error_found = abap_true.
*  ELSE.
*
*    go_assistance->check_code_by_prio(
*      EXPORTING
*        is_ct_work = ls_ct_work
*      IMPORTING
*        ev_code_allowed = lv_code_allowed ).
*
*    IF lv_code_allowed = abap_false.
*      REFRESH lt_return.
**     Wenn es überhaupt Codes gibt, aber keiner davon eingetragen wurde
*      MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '025'
*        WITH ls_ct_work-code ls_ct_work-codegruppe
*        INTO ls_return-message.
*      ls_return-type = 'E'.
*      ls_return-id = '/PROMOS/NK_CRM'.
*      ls_return-number = '025'.
*      ls_return-message_v1 = ls_ct_work-code.
*      ls_return-message_v2 =  ls_ct_work-codegruppe.
*      APPEND ls_return TO lt_return.
*      lv_error_found = abap_true.
** Message aufbauen
*      CALL METHOD lo_msglist->add_from_bapi
*        EXPORTING
*          it_bapiret = lt_return.
*      IF NOT lt_return[] IS INITIAL.
*        LOOP AT lt_return INTO ls_return WHERE
*        type = 'E'.
*          EXIT.
*        ENDLOOP.
*        IF sy-subrc = 0.
*          CALL FUNCTION 'RECA_GUI_MSGLIST_POPUP'
*            EXPORTING
*              io_msglist = lo_msglist.
*        ENDIF.
*      ENDIF.
*      RETURN.
*    ENDIF.
*  ENDIF.
*
** zugeordnetes Objekt
*  IF    ls_ct_work-relation_cn  IS INITIAL
*     AND ls_ct_work-relation_obj IS INITIAL
*     AND ls_ct_work-relation_own_cn IS INITIAL
*     AND ls_ct_work-relation_own_tp IS INITIAL
*     AND ls_ct_work-rel_partner IS INITIAL.
**   Bitte ordnen Sie das Ticket einem Partner, Vertrag, TP oder RE-Obj. zu.
*    ls_return-type = 'E'.
**   CALL FUNCTION 'MESSAGE_TEXT_BUILD'.
*    MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '023' INTO ls_return-message.
*    APPEND ls_return TO lt_return.
*    lv_error_found = abap_true.
*  ENDIF.
*
** Pflichtfeld prüfen,
*  IF ls_ct_work-additional_relation IS INITIAL. "Nur auf Pflichtfeld prüfen, wenn nicht eh ausgefüllt
*
*    READ TABLE go_assistance->mt_crm_cust INTO ls_crm_cust
*      WITH KEY ticket_type = ls_ct_work-ticket_type
*               ticket_type_lnr = ls_ct_work-ticket_type_lnr.
*
*    IF sy-subrc EQ 0
*      AND ls_crm_cust-additional_relation_schrnr IS NOT INITIAL
*      AND ls_crm_cust-additional_relation EQ 2. "Das ist lt. Cust dann ein Pflichtfeld
*
*      ls_return-type = 'E'.
*      MESSAGE ID '/PROMOS/NK_CRM' TYPE 'E' NUMBER '009' INTO ls_return-message.
*      APPEND ls_return TO lt_return.
*      lv_error_found = abap_true.
*    ENDIF.
*  ENDIF.
*
*  lv_create_update = 'CREATE'.
*
*  GET BADI lo_fe_badi.
*  CALL BADI lo_fe_badi->check_ticket_before_save
*    EXPORTING
*      iv_create_update = lv_create_update
*      is_ticket        = ls_ct_work
*      it_relations     = go_assistance->mt_relations
*    CHANGING
*      ct_return        = lt_return_badi
*      cv_error         = lv_error_badi.
*
** Fehler, wenn Kennzeichen gesetzt oder mind. eine Fehlermeldung im BADI
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*
*  IF lv_error_badi = abap_true.
*    lv_error_found = abap_true.
*    APPEND LINES OF lt_return_badi TO lt_return.
*  ENDIF.
*
** Customzing-Felder (Initiatoren)
*  ls_cust_field-seq  =   '115'.
*  ls_cust_field-fieldtext  = 'Initiatoren'.
*  ls_cust_field-is_kat  =   'X'.
** ls_cust_field-t_value_help[]  = go_assistance->mt_cust_fields[].
*  ls_cust_field-value   = gs_dynpro_ro_01-initiator.
*  APPEND  ls_cust_field TO ls_ct_work-cust_fields.
*
**Übernahme des Notiztextes erst nach Prüfungen, ls_ct_work übergeben, Langtext muss angefügt werden
*  PERFORM add_text USING ls_ct_work.
*
*  CALL METHOD go_assistance->enrich_ct_line
*    EXPORTING
*      is_ct_data_wd = ls_ct_work
*    IMPORTING
*      es_ct_data_wd = ls_ct_work.
**
**Aufbaeu Childen
*  ls_ct_work-objtyp = 'BUS0010'.
*  ls_ct_work-relation = gs_dynpro_ro_01-tplnr.
*  CLEAR:
*    ls_ct_work-relation_cn,
*    ls_ct_work-relation_obj,
*    ls_ct_work-relation_own_cn,
*    ls_ct_work-relation_own_tp.
*  CLEAR  ls_ct_work-objkey.
** ist der Teilprozess neu, oder schon in der Tabelle (Bearbeitung)
*  IF ls_ct_work-fe_id IS NOT INITIAL.
*    READ TABLE lt_ct_ticket_teilproz WITH KEY fe_id = ls_ct_work-fe_id TRANSPORTING NO FIELDS.
*    IF sy-subrc EQ 0.
*      MODIFY lt_ct_ticket_teilproz INDEX sy-tabix
*        FROM ls_ct_work.
*    ELSE.
*      APPEND ls_ct_work TO lt_ct_ticket_teilproz.
*    ENDIF.
*  ENDIF.
*
** REFRESH ls_ct_work-cust_fields.
** wenn ein übergeordnetes Ticket ausgewählt wurde dessen Daten übernehmen
** IF ls_ct_work-id IS INITIAL OR ls_ct_ticket-bezeichnung IS INITIAL.
*  WRITE sy-datum+ TO
*  ld_datum.
*  CONCATENATE 'Ticket' '[' gs_recn-name_last ']' space '[' ld_datum  ']'
*    INTO ls_ct_work-bezeichnung SEPARATED BY space.
*  CONDENSE ls_ct_work-bezeichnung.
** ENDIF.
*
** Ticket speichern
**   BP erweitern
*  CALL METHOD go_assistance->enrich_bupa_line
*    EXPORTING
*      is_bupa_data    = gs_bupa_data
*    IMPORTING
*      es_bupa_data_wd = ls_bupa_work.
*
*
** clearen und refreshen, damit als Vertrag gespeichert
*  ls_ct_work-objtyp  = 'BUS1006'.
*  ls_ct_work-cust_fields[] = ls_ct_work_temp-cust_fields[].
*  ls_ct_work-objkey = ls_ct_work-partner.
*  ls_ct_work-relation = ls_ct_work-partner.
*  CLEAR:
*    ls_ct_work-relation_cn,
*    ls_ct_work-relation_obj,
*    ls_ct_work-relation_own_cn,
*    ls_ct_work-relation_own_tp.
**  CLEAR: ls_ct_work-ticket_type, ls_ct_work-ticket_type_lnr," ls_ct_work-partner,
**  ls_ct_work-codegruppe, ls_ct_work-code, ls_ct_work-prio, ls_ct_work-urspr,
**  ls_ct_work-RELATION.
*  REFRESH:ls_ct_work-langtext_t.
*  LOOP AT lt_ct_ticket_teilproz ASSIGNING <teilpror>.
**   CLEAR: <teilpror>-urspr.
*    REFRESH: <teilpror>-cust_fields.
*  ENDLOOP.
*  CALL METHOD go_assistance->save_crm_ticket
*    EXPORTING
*      is_crm_coverticket = ls_ct_work
*      it_crm_teiltickets = lt_ct_ticket_teilproz
*      iv_doc_relation    = ld_doc_relation
*      is_bupa_work       = ls_bupa_work
*    IMPORTING
*      et_return          = lt_return.
*
** Message aufbauen
*  CALL METHOD lo_msglist->add_from_bapi
*    EXPORTING
*      it_bapiret = lt_return.
*  IF NOT lt_return[] IS INITIAL.
*    LOOP AT lt_return INTO ls_return WHERE
*    type = 'E'.
*      EXIT.
*    ENDLOOP.
*    IF sy-subrc = 0.
*      CALL FUNCTION 'RECA_GUI_MSGLIST_POPUP'
*        EXPORTING
*          io_msglist = lo_msglist.
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR
         'EXIT_CN_01' OR
         'EXIT_RO_01'.
      IF go_dock_notice_01 IS BOUND.
        go_dock_notice_01->free( ).
        FREE go_dock_notice_01.
      ENDIF.
      IF go_dock_notice_02 IS BOUND.
        go_dock_notice_02->free( ).
        FREE go_dock_notice_02.
      ENDIF.
      IF go_dock_notice_ro_01 IS BOUND.
        go_dock_notice_ro_01->free( ).
        FREE go_dock_notice_ro_01.
      ENDIF.
      IF go_dock_notice_ro_02 IS BOUND.
        go_dock_notice_ro_02->free( ).
        FREE go_dock_notice_ro_02.
      ENDIF.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_code INPUT.

  PERFORM set_code.

ENDMODULE.
MODULE set_code_0310 INPUT.
  PERFORM set_code_ro.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form ADD_TEXT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_text USING cs_ct_work TYPE any. "/promos/s_ct_data_wd.
*
*  DATA lv_datum             TYPE string.
*  DATA lv_uzeit             TYPE string.
*  DATA lv_tmp               TYPE string.
*  DATA lo_nd_ct_work        TYPE REF TO if_wd_context_node.
*  DATA ls_ct_work           TYPE /promos/s_ct_data_wd.
*
*
***********************************************
** #29847, Piet Schwalenberg, 02.01.2018
** aus Parameter, wenn der Aufrufer CT_WORK bereits bearbeitet, sonst selbst laden.
** wenn wir immer selbst laden, überschreibt der Aufrufer anderenfalls "unsere" Änderung wieder...
*  IF cs_ct_work IS NOT INITIAL.
*    ls_ct_work = cs_ct_work.
*  ELSE.
*    RETURN.
*  ENDIF.
*
** Neuen Text an Langtext hängen und in kontext schreiben
*  IF ls_ct_work-text_add IS NOT INITIAL.
*    CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4) INTO lv_datum SEPARATED BY '.'.
*    CONCATENATE sy-uzeit(2) sy-uzeit+2(2) sy-uzeit+4(2) INTO lv_uzeit SEPARATED BY ':'.
**    lv_tmp = sy-uname.
**    CONDENSE lv_tmp.
**    CONCATENATE '>' lv_tmp INTO lv_tmp.
**    CONCATENATE lv_tmp lv_datum lv_uzeit INTO lv_tmp SEPARATED BY '; ' RESPECTING BLANKS.
**    CONCATENATE lv_tmp
**      cl_abap_char_utilities=>newline lS_CT_WORK-text_add
**      cl_abap_char_utilities=>newline cl_abap_char_utilities=>newline lS_CT_WORK-langtext
**      INTO lS_CT_WORK-langtext.
*    IF ls_ct_work-add_langtext IS NOT INITIAL.
*      CONCATENATE ls_ct_work-add_langtext cl_abap_char_utilities=>newline ls_ct_work-text_add
*        INTO ls_ct_work-add_langtext.
*    ELSE.
*      ls_ct_work-add_langtext = ls_ct_work-text_add.
*    ENDIF.
*    CONCATENATE '----------------------------------- Änderung von ' sy-uname ' am ' lv_datum ' um ' lv_uzeit ' -----------------------------------'
*      INTO lv_tmp SEPARATED BY space.
*    CONCATENATE lv_tmp cl_abap_char_utilities=>newline cl_abap_char_utilities=>newline ls_ct_work-add_langtext cl_abap_char_utilities=>newline cl_abap_char_utilities=>newline ls_ct_work-langtext
*      INTO ls_ct_work-compl_langtext.
*
*    CLEAR ls_ct_work-text_add.
*
**   ********************************************
**   #29847, Piet Schwalenberg, 02.01.2018
**   Siehe oben: Langtext in CT_WORK übernehmen, wenn der Aufrufer das nicht macht.
**   Sonst zurück an den Aufrufer
*    IF cs_ct_work IS INITIAL.
*      lo_nd_ct_work->set_static_attributes(
*      EXPORTING
*        static_attributes = ls_ct_work ).
*    ELSE.
*      cs_ct_work = ls_ct_work.
*    ENDIF.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  PAI_0210  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0210 INPUT.

  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXIT_CN_02'.
      go_dock_notice_02->free( ).
      FREE go_dock_notice_02.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE_CN_02'.
      PERFORM change_ticket_cn.
* ALV neue aufbauen
      PERFORM get_new_ticket_cn.
* Flushen
      CALL METHOD go_alv_ticket_cn->refresh( refresh_mode = 2 ).
      cl_gui_cfw=>flush( ).
      CLEAR gs_dynpro_cn_02.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0320 INPUT.

  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXIT_RO_02'.
*     FREE go_dock_notice_ro_02 .
* FREE go_cc_notice_ro_02.
      go_dock_notice_ro_02->free( ).
      FREE go_dock_notice_ro_02 .
      LEAVE TO SCREEN 0.

    WHEN 'SAVE_RO_02'.
*     PERFORM change_ticket_cn.
* ALV neue aufbauen
      PERFORM get_new_ticket_ro.
* Flushen
      CALL METHOD go_alv_ticket_cn->refresh( refresh_mode = 2 ).
      cl_gui_cfw=>flush( ).
      CLEAR gs_dynpro_ro_02.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0310  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0310 INPUT.

  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXIT_RO_02'.
      go_dock_notice_ro_02->free( ).
      FREE go_dock_notice_ro_02 .
      LEAVE TO SCREEN 0.

    WHEN 'SAVE_RO_02'.
      PERFORM change_ticket_ro.
* ALV neue aufbauen
      PERFORM get_new_ticket_ro.
* Flushen
      CALL METHOD go_alv_ticket_cn->refresh( refresh_mode = 2 ).
      cl_gui_cfw=>flush( ).
      CLEAR gs_dynpro_ro_02.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form CHANGE_TICKET_CN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_ticket_cn .
*  DATA: lo_nd_ct_work            TYPE REF TO if_wd_context_node,
*        ls_ct_work               TYPE /promos/s_ct_data_wd,
*        lo_nd_codes              TYPE REF TO if_wd_context_node,
*        lt_codes                 TYPE /promos/s_codes_wd,
*        lo_nd_ct_ticket_teilproz TYPE REF TO if_wd_context_node,
*        lt_ct_ticket_teilproz    TYPE TABLE OF /promos/s_ct_data_wd,
*        ls_ct_ticket_teilproz    LIKE LINE OF lt_ct_ticket_teilproz,
*        ls_crm_cust              LIKE /promos/crm_cust,
*        lo_fe_badi               TYPE REF TO /promos/crm_fe_badi,
*        ls_tickets_bak_cn        LIKE LINE OF gt_tickets_bak_cn,
*        ls_children              TYPE /promos/s_ct_data_wd,
*        ls_langext               TYPE tdline,
*        lv_create_update         TYPE char6,
*        lt_return_badi           TYPE bapiret2_t,
*        lv_error_badi            TYPE oax,
*        ld_fdpos                 TYPE sy-fdpos,
*        ld_id_txt                TYPE /promos/e_crm_ticket_id_txt.
*
*  DATA: lt_msg          TYPE cl_wd_dynamic_tool=>t_check_result_message_tab,
*        li_lines        TYPE i,
*        lt_return       TYPE bapiret2_t,
*        ls_return       TYPE bapiret2,
*        lv_code_allowed TYPE oax,
*        lv_error_found  TYPE oax,
*        lt_lines_text   TYPE texttab,
*        ls_lines_text   LIKE LINE OF lt_lines_text,
*        lt_linetab      TYPE tlinetab,
*        ls_linetab      LIKE LINE OF lt_linetab,
*        lf_modified     TYPE i,
*        ld_index        TYPE sy-index,
*        ld_string       TYPE string,
*        ld_text         TYPE string,
*        lt_text         TYPE re_t_textline_itf.
*
*  DATA lo_nd_ct_ticket            TYPE REF TO if_wd_context_node.
*  DATA ls_ct_ticket               TYPE /promos/s_ct_data_wd.
*  DATA ld_doc_relation TYPE /promos/e_crm_teilguid.
*  DATA: ls_bupa_work TYPE /promos/s_bupa_data_wd.
*
*  FIELD-SYMBOLS: <teilproz> LIKE LINE OF lt_ct_ticket_teilproz.
**---------------------------*
** Text holen
*  CALL METHOD go_dock_notice_02->get_text_as_stream
*    EXPORTING
*      only_when_modified = 1
*    IMPORTING
*      text               = lt_lines_text
*      is_modified        = lf_modified.
*
*  CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
**   EXPORTING
**     STREAM_LINES       =
**     LANGUAGE    = SY-LANGU
**     LF          = ' '
**      iv_fw       = 72
**      iv_lw       = 132
*    TABLES
*      text_stream = lt_lines_text
*      itf_text    = lt_linetab.
** string generieren
*  ld_text = REDUCE #( INIT ld_string2 TYPE string FOR ls_text IN lt_linetab
*        NEXT ld_string2 = ld_string && ls_text-tdline && cl_abap_char_utilities=>cr_lf ).
**  CLEAR ld_text.
**  LOOP AT lt_lines_text INTO ls_lines_text.
**    CONCATENATE  ld_text  ls_lines_text INTO
**      ld_text.
**  ENDLOOP.
*
**  IF NOT ld_text IS INITIAL.
**    SPLIT ld_text  AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(lt_text_string).
**    lt_text = VALUE #( FOR ld_string3 IN lt_text_string tdformat = '*' ( tdline = ld_string ) ).
**  ENDIF.
*
** Ticket aufbauen
*  CLEAR ls_ct_work.
*  IF gs_dynpro_cn_02 IS INITIAL.
*    EXIT.
*  ENDIF.
** orginal-ticket lesen
*  ld_id_txt = gs_dynpro_cn_02-teilnr. "Unterschiedliche Länger der Felder
*  ld_id_txt =   ld_id_txt  - 1. "Children finden
*  READ TABLE gt_tickets_bak_cn INTO ls_tickets_bak_cn
*   WITH KEY  id_txt = ld_id_txt.
*  IF sy-subrc NE 0.
*    MESSAGE 'Änderungen wurden nicht gespeichert' TYPE 'I' DISPLAY LIKE 'E'.
*    RETURN.
*  ENDIF.
*  MOVE-CORRESPONDING ls_tickets_bak_cn TO ls_ct_work.
*  MOVE-CORRESPONDING gs_dynpro_cn_02 TO ls_ct_work.
*  ls_ct_work-codegruppe = ls_tickets_bak_cn-codegruppe.
*  ls_ct_work-code = ls_tickets_bak_cn-code.
*  ls_ct_work-bezeichnung = gs_dynpro_cn_02-kurztext.
*  ls_ct_work-prio  = gs_dynpro_cn_02-prio.
*  ls_ct_work-status = gs_dynpro_cn_02-status.
*  ls_ct_work-contact_name = gs_dynpro_cn_02-contact_name.
*  ls_ct_work-contact_telnumber = gs_dynpro_cn_02-contact_telnumber .
*  ls_ct_work-relation = gs_recn-recnnr.
** ls_ct_work-relation_cn = gs_recn-recnnr.
*  ls_ct_work-relation_own_cn = gs_recn-recnnr.

** Satz anreichern mit neuen Text
*  LOOP AT  lt_text INTO ls_linetab.
*    ld_index = sy-tabix.
*    READ TABLE ls_tickets_bak_cn-langtext_t INTO ls_langext
*    INDEX ld_index.
*    IF ls_linetab-tdline  = ls_langext.
*      CONTINUE.
*    ENDIF.
*    CONCATENATE  ls_ct_work-langtext  ls_lines_text INTO
*      ls_ct_work-text_add.
*  ENDLOOP.
*  SEARCH gs_dynpro_cn_02-code FOR '-'.
*  IF sy-subrc = 0.
*    ls_ct_work-codegruppe = gs_dynpro_cn_02-code(sy-fdpos).
*    ld_fdpos  = sy-fdpos.
*    ld_fdpos = ld_fdpos + 1.
*    ls_ct_work-code = gs_dynpro_cn_02-code+ld_fdpos.
*  ENDIF.
*
*  lv_create_update = 'UPDATE'.
*
*  GET BADI lo_fe_badi.
*  CALL BADI lo_fe_badi->check_ticket_before_save
*    EXPORTING
*      iv_create_update = lv_create_update
*      is_ticket        = ls_ct_work
*      it_relations     = go_assistance->mt_relations
*    CHANGING
*      ct_return        = lt_return_badi
*      cv_error         = lv_error_badi.
*
** Fehler, wenn Kennzeichen gesetzt oder mind. eine Fehlermeldung im BADI
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*
*  IF lv_error_badi = abap_true.
*    lv_error_found = abap_true.
*    APPEND LINES OF lt_return_badi TO lt_return.
*  ENDIF.
*
** neuen Text übergeben
*  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN ld_text WITH space.
*  ls_ct_work-text_add = ld_text .
*  ls_ct_work-objtyp = 'BUS1505'. "Vertrag
** Übernahme des Notiztextes erst nach Prüfungen, ls_ct_work übergeben, Langtext muss angefügt werden
*  PERFORM add_text USING ls_ct_work.
*
*
*  CALL METHOD go_assistance->enrich_ct_line
*    EXPORTING
*      is_ct_data_wd = ls_ct_work
*    IMPORTING
*      es_ct_data_wd = ls_ct_work.
*
** ist der Teilprozess neu, oder schon in der Tabelle (Bearbeitung)
*  READ TABLE ls_tickets_bak_cn-t_children  INTO ls_children INDEX 1.
*  IF sy-subrc EQ 0.
*    CLEAR ls_ct_ticket_teilproz.
*    MOVE-CORRESPONDING ls_children TO ls_ct_ticket_teilproz.
*    ls_ct_ticket_teilproz-langtext_t[] = ls_ct_work-langtext_t[].
*    ls_ct_ticket_teilproz-add_langtext = ld_text .
*    ls_ct_ticket_teilproz-bezeichnung = gs_dynpro_cn_02-kurztext.
*    ls_ct_ticket_teilproz-contact_name = gs_dynpro_cn_02-contact_name.
*    ls_ct_ticket_teilproz-contact_telnumber = gs_dynpro_cn_02-contact_telnumber.
*    APPEND ls_ct_ticket_teilproz TO lt_ct_ticket_teilproz.
*  ELSE.
*    APPEND ls_ct_work TO lt_ct_ticket_teilproz.
*  ENDIF.
*
*
** Teilprozess der Childen sezten
*  LOOP AT lt_ct_ticket_teilproz ASSIGNING <teilproz>.
*    <teilproz>-ticket_type = '01'.
*    <teilproz>-ticket_type_lnr = '01'.
*  ENDLOOP.
** Ticket speichern
**   BP erweitern
*  CALL METHOD go_assistance->enrich_bupa_line
*    EXPORTING
*      is_bupa_data    = gs_bupa_data
*    IMPORTING
*      es_bupa_data_wd = ls_bupa_work.
*
*
**  CLEAR ls_ct_work-langtext.
**  REFRESH ls_ct_work-langtext_t.
*
*  CALL METHOD go_assistance->save_crm_ticket
*    EXPORTING
*      is_crm_coverticket = ls_ct_work
*      it_crm_teiltickets = lt_ct_ticket_teilproz
*      iv_doc_relation    = ld_doc_relation
*      is_bupa_work       = ls_bupa_work
*    IMPORTING
*      et_return          = lt_return.
*  DATA: lo_msglist       TYPE REF TO if_reca_message_list.
*
*  lo_msglist = cf_reca_message_list=>create( ).
*  CALL METHOD lo_msglist->add_from_bapi
*    EXPORTING
*      it_bapiret = lt_return.
*  IF NOT lt_return[] IS INITIAL.
*    LOOP AT lt_return INTO ls_return WHERE
*    type = 'E'.
*      EXIT.
*    ENDLOOP.
*    IF sy-subrc = 0.
*      CALL FUNCTION 'RECA_GUI_MSGLIST_POPUP'
*        EXPORTING
*          io_msglist = lo_msglist.
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_TICKET_CN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_ticket_ro .
*  DATA: lo_nd_ct_work            TYPE REF TO if_wd_context_node,
*        ls_ct_work               TYPE /promos/s_ct_data_wd,
*        lo_nd_codes              TYPE REF TO if_wd_context_node,
*        lt_codes                 TYPE /promos/s_codes_wd,
*        lo_nd_ct_ticket_teilproz TYPE REF TO if_wd_context_node,
*        lt_ct_ticket_teilproz    TYPE TABLE OF /promos/s_ct_data_wd,
*        ls_ct_ticket_teilproz    LIKE LINE OF lt_ct_ticket_teilproz,
*        ls_crm_cust              LIKE /promos/crm_cust,
*        lo_fe_badi               TYPE REF TO /promos/crm_fe_badi,
*        ls_tickets_bak_ro        LIKE LINE OF gt_tickets_bak_ro,
*        ls_children              TYPE /promos/s_ct_data_wd,
*        ls_langext               TYPE tdline,
*        lv_create_update         TYPE char6,
*        lt_return_badi           TYPE bapiret2_t,
*        lv_error_badi            TYPE oax,
*        ld_fdpos                 TYPE sy-fdpos,
*        ld_id_txt                TYPE /promos/e_crm_ticket_id_txt,
*        lt_cust_field            TYPE /promos/tt_crm_cust_fields,
*        ls_cust_field            LIKE LINE OF lt_cust_field.
*
*  DATA: lt_msg          TYPE cl_wd_dynamic_tool=>t_check_result_message_tab,
*        li_lines        TYPE i,
*        lt_return       TYPE bapiret2_t,
*        ls_return       TYPE bapiret2,
*        lv_code_allowed TYPE oax,
*        lv_error_found  TYPE oax,
*        lt_lines_text   TYPE texttab,
*        ls_lines_text   LIKE LINE OF lt_lines_text,
*        lt_linetab      TYPE tlinetab,
*        ls_linetab      LIKE LINE OF lt_linetab,
*        lf_modified     TYPE i,
*        ld_index        TYPE sy-index,
*        ld_string       TYPE string,
*        ld_text         TYPE string,
*        lt_text         TYPE re_t_textline_itf,
*        ld_master       TYPE flag.
*
*  DATA lo_nd_ct_ticket            TYPE REF TO if_wd_context_node.
*  DATA ls_ct_ticket               TYPE /promos/s_ct_data_wd.
*  DATA ld_doc_relation TYPE /promos/e_crm_teilguid.
*  DATA: ls_bupa_work TYPE /promos/s_bupa_data_wd.
*
*  FIELD-SYMBOLS: <teilproz> LIKE LINE OF lt_ct_ticket_teilproz.
*---------------------------*
** Text holen
*  IF go_dock_notice_ro_02 IS BOUND.
*    CALL METHOD go_dock_notice_ro_02->get_text_as_stream
*      EXPORTING
*        only_when_modified = 1
*      IMPORTING
*        text               = lt_lines_text
*        is_modified        = lf_modified.
*
*    CALL FUNCTION 'CONVERT_STREAM_TO_ITF_TEXT'
**   EXPORTING
**     STREAM_LINES       =
**     LANGUAGE    = SY-LANGU
**     LF          = ' '
**      iv_fw       = 72
**      iv_lw       = 132
*      TABLES
*        text_stream = lt_lines_text
*        itf_text    = lt_linetab.
** string generieren
*    ld_text = REDUCE #( INIT ld_string2 TYPE string FOR ls_text IN lt_linetab
*          NEXT ld_string2 = ld_string && ls_text-tdline && cl_abap_char_utilities=>cr_lf ).
*  ENDIF.
*
** Ticket aufbauen
*  CLEAR:ls_ct_work, ld_master.
*  IF gs_dynpro_ro_02 IS INITIAL.
*    EXIT.
*  ENDIF.
** orginal-ticket lesen
*  ld_id_txt = gs_dynpro_ro_02-teilnr. "Unterschiedliche Länger der Felder
** ld_id_txt =   ld_id_txt  - 1. "Children finden
*  READ TABLE gt_tickets_bak_ro INTO ls_tickets_bak_ro
*   WITH KEY  id_txt = ld_id_txt.
*  IF sy-subrc NE 0.
*    ld_id_txt =   ld_id_txt  - 1. "Children finden
*    READ TABLE gt_tickets_bak_ro INTO ls_tickets_bak_ro
*     WITH KEY  id_txt = ld_id_txt.
*  ENDIF.
*  IF sy-subrc NE 0.
** Master finden
**    READ TABLE gt_tickets_bak_ro INTO ls_tickets_bak_ro
**     WITH KEY  id_txt = gs_dynpro_ro_02-teilnr_master.
**    IF sy-subrc = 0.
**      ld_master = abap_true.
**    ELSE.
*    CLEAR gs_message.
*    MESSAGE 'Änderungen wurden nicht gespeichert' TYPE 'I' DISPLAY LIKE 'E'.
*    RETURN.
**   ENDIF.
*  ENDIF.
*  MOVE-CORRESPONDING ls_tickets_bak_ro TO ls_ct_work.
*  MOVE-CORRESPONDING gs_dynpro_ro_02 TO ls_ct_work.
*  ls_ct_work-cust_fields[] = ls_tickets_bak_ro-cust_fields[].
*  ls_ct_work-partner = gs_recn-partner.
** ls_ct_work-codegruppe = ls_tickets_bak_cn-codegruppe.
** ls_ct_work-code = ls_tickets_bak_cn-code.
*  ls_ct_work-bezeichnung = gs_dynpro_ro_02-kurztext.
** ls_ct_work-prio  = gs_dynpro_ro_02-prio.
** ls_ct_work-status = gs_dynpro_ro_02-status.
*  ls_ct_work-contact_name = gs_dynpro_ro_02-contact_name.
*  ls_ct_work-contact_telnumber = gs_dynpro_ro_02-contact_telnumber .
** Customzing-Felder (Initiatoren)
*  LOOP AT ls_ct_work-cust_fields INTO ls_cust_field
*  WHERE value IS NOT INITIAL.
*
*    EXIT.
*  ENDLOOP.
*  IF sy-subrc NE 0.
*    REFRESH   ls_ct_work-cust_fields.
*    ls_cust_field-seq  =   '115'.
*    ls_cust_field-fieldtext  = 'Initiatoren'.
*    ls_cust_field-is_kat  =   'X'.
** ls_cust_field-t_value_help[]  = go_assistance->mt_cust_fields[].
*    ls_cust_field-value   = gs_dynpro_ro_02-initiator.
*    APPEND  ls_cust_field TO ls_ct_work-cust_fields.
*  ENDIF.
*  lv_create_update = 'UPDATE'.
*
*  GET BADI lo_fe_badi.
*  CALL BADI lo_fe_badi->check_ticket_before_save
*    EXPORTING
*      iv_create_update = lv_create_update
*      is_ticket        = ls_ct_work
*      it_relations     = go_assistance->mt_relations
*    CHANGING
*      ct_return        = lt_return_badi
*      cv_error         = lv_error_badi.
*
** Fehler, wenn Kennzeichen gesetzt oder mind. eine Fehlermeldung im BADI
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*  LOOP AT lt_return_badi TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*    lv_error_badi = abap_true.
*  ENDLOOP.
*
*  IF lv_error_badi = abap_true.
*    lv_error_found = abap_true.
*    APPEND LINES OF lt_return_badi TO lt_return.
*  ENDIF.
*
** neuen Text übergeben
*  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN ld_text WITH space.
*  ls_ct_work-text_add = ld_text .
** ls_ct_work-objtyp = 'BUS1505'. "Vertrag
** Übernahme des Notiztextes erst nach Prüfungen, ls_ct_work übergeben, Langtext muss angefügt werden
*  PERFORM add_text USING ls_ct_work.
*
*
*  CALL METHOD go_assistance->enrich_ct_line
*    EXPORTING
*      is_ct_data_wd = ls_ct_work
*    IMPORTING
*      es_ct_data_wd = ls_ct_work.
*
** ist der Teilprozess neu, oder schon in der Tabelle (Bearbeitung)
*  READ TABLE ls_tickets_bak_ro-t_children  INTO ls_children INDEX 1.
*  IF sy-subrc EQ 0.
*    CLEAR ls_ct_ticket_teilproz.
*    MOVE-CORRESPONDING ls_children TO ls_ct_ticket_teilproz.
*    ls_ct_ticket_teilproz-langtext_t[] = ls_ct_work-langtext_t[].
*    ls_ct_ticket_teilproz-add_langtext = ld_text .
*    ls_ct_ticket_teilproz-bezeichnung = gs_dynpro_ro_02-kurztext.
*    ls_ct_ticket_teilproz-contact_name = gs_dynpro_ro_02-contact_name.
*    ls_ct_ticket_teilproz-contact_telnumber = gs_dynpro_ro_02-contact_telnumber.
*    ls_ct_ticket_teilproz-cust_fields[] = ls_tickets_bak_ro-cust_fields[].
*    APPEND ls_ct_ticket_teilproz TO lt_ct_ticket_teilproz.
*  ELSE.
*    APPEND ls_ct_work TO lt_ct_ticket_teilproz.
*  ENDIF.
*
*
*** Teilprozess der Childen sezten
**  LOOP AT lt_ct_ticket_teilproz ASSIGNING <teilproz>.
**    <teilproz>-ticket_type = '01'.
**    <teilproz>-ticket_type_lnr = '01'.
**  ENDLOOP.
** Ticket speichern
**   BP erweitern
*  CALL METHOD go_assistance->enrich_bupa_line
*    EXPORTING
*      is_bupa_data    = gs_bupa_data
*    IMPORTING
*      es_bupa_data_wd = ls_bupa_work.
*
*
**  CLEAR ls_ct_work-langtext.
**  REFRESH ls_ct_work-langtext_t.
*
*  CALL METHOD go_assistance->save_crm_ticket
*    EXPORTING
*      is_crm_coverticket = ls_ct_work
*      it_crm_teiltickets = lt_ct_ticket_teilproz
*      iv_doc_relation    = ld_doc_relation
*      is_bupa_work       = ls_bupa_work
*    IMPORTING
*      et_return          = lt_return.
*  DATA: lo_msglist       TYPE REF TO if_reca_message_list.
*
*  lo_msglist = cf_reca_message_list=>create( ).
*  CALL METHOD lo_msglist->add_from_bapi
*    EXPORTING
*      it_bapiret = lt_return.
*  IF NOT lt_return[] IS INITIAL.
*    LOOP AT lt_return INTO ls_return WHERE
*    type = 'E'.
*      EXIT.
*    ENDLOOP.
*    IF sy-subrc = 0.
*      CALL FUNCTION 'RECA_GUI_MSGLIST_POPUP'
*        EXPORTING
*          io_msglist = lo_msglist.
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_NEW_TICKET_CN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_new_ticket_cn.
*  DATA: lt_crm_ticket_list    TYPE /promos/tt_crm_ticket_wd,
*        ls_crm_ticket_list    LIKE LINE OF lt_crm_ticket_list,
*        lt_crm_tree_table     TYPE /promos/tt_ct_data_wd,
*        lt_crm_fl_ticket_list TYPE /promos/tt_crm_ticket_wd,
*        ls_crm_fl_ticket_list LIKE LINE OF lt_crm_fl_ticket_list,
*        lt_crm_fl_tree_table  TYPE /promos/tt_ct_data_wd,
*        ls_children_be        TYPE /promos/s_ct_data,
*        ls_children_wd        TYPE /promos/s_ct_data_wd,
*        ld_selection          TYPE /promos/s_ct_ticket_selection,
*        ld_recnnr(30).
*
**-------------------------*
*  REFRESH: lt_crm_fl_ticket_list, lt_crm_fl_tree_table.
*  CALL METHOD go_assistance->get_crm_ticket_list
*    EXPORTING
*      is_ticket_selection  = gd_selection
*      iv_partner           = gs_recn-partner
*    IMPORTING
*      et_crm_ticket        = lt_crm_ticket_list "lt_crm_ticket_list
*      et_crm_tree_table    = lt_crm_tree_table "lt_crm_ticket_tree.
*      et_crm_fl_ticket     = lt_crm_fl_ticket_list
*      et_crm_fl_tree_table = lt_crm_fl_tree_table.
*
*  CONCATENATE gs_recn-bukrs gs_recn-recnnr INTO ld_recnnr.
*
*  DATA lt_cn_be               TYPE /promos/tt_crm_oppc_objkey.
*  DATA: lt_bp_crm_ticket_be TYPE /promos/tt_bp_crm_ticket,
*        ls_bp_crm_ticket_be LIKE LINE OF  lt_bp_crm_ticket_be,
*        lt_return           TYPE bapiret2_t,
*        lo_te               TYPE REF TO /promos/if_oppc_teilprozess,
*        ls_statistik        TYPE /promos/oppc_statistik.
*
*
*  APPEND ld_recnnr TO lt_cn_be.
**   Tickets vom Backend holen
*  CALL FUNCTION '/PROMOS/FM_CT_GET_BP_LIST'
*    EXPORTING
*      it_cn_objkey        = lt_cn_be
*      iv_partner          = gs_recn-partner
*      is_ticket_selection = gd_selection
*    IMPORTING
*      et_tickets          = lt_bp_crm_ticket_be
*      et_return           = lt_return.
*
**  SELECT * FROM /promos/oppcteil                        "#EC CI_NOFIELD
**   APPENDING CORRESPONDING FIELDS OF TABLE lt_crm_ticket_list
**   WHERE ( ( objtyp EQ 'BUS1505' AND objkey EQ ld_recnnr )
**        OR ( ueberobjtyp EQ 'BUS1505' AND ueberobjkey EQ ld_recnnr )
**        OR ( unterobjtyp EQ 'BUS1505' AND unterobjkey EQ ld_recnnr ) )
**     AND ( loeschkz = space )
**     AND ( status IN ('I', 'O' )
**       OR ( status = 'A' ) ).
** Vertrags Tickets
*  REFRESH: gt_tickets_bak_cn, gt_ticket_cn.
*  LOOP AT lt_crm_ticket_list INTO ls_crm_ticket_list.
*    CLEAR gs_ticket_cn.
*    MOVE-CORRESPONDING  ls_crm_ticket_list TO gs_ticket_cn.
*    gs_ticket_cn-teilnr_main = ls_crm_ticket_list-id_txt.
*    LOOP AT ls_crm_ticket_list-t_children INTO ls_children_wd
*      WHERE objtyp = 'BUS1505'. "
**           objtyp = 'BUS0010'.
**           relation = ld_recnnr.
*      MOVE-CORRESPONDING ls_children_wd TO gs_ticket_cn.
*      gs_ticket_cn-teilnr_child = ls_children_wd-id_txt.
*      gs_ticket_cn-bezeichnung = ls_children_wd-bezeichnung.
*    ENDLOOP.
*    IF sy-subrc NE 0.
*      CONTINUE.
*    ENDIF.
*    APPEND ls_crm_ticket_list TO  gt_tickets_bak_cn.
*    APPEND gs_ticket_cn TO gt_ticket_cn.
*  ENDLOOP.
*
*  LOOP AT lt_bp_crm_ticket_be INTO ls_bp_crm_ticket_be.
*    CLEAR gs_ticket_cn.
*    MOVE-CORRESPONDING  ls_bp_crm_ticket_be TO gs_ticket_cn.
*    gs_ticket_cn-teilnr_main = ls_bp_crm_ticket_be-id_txt.
*    gs_ticket_cn-teilnr_child = ls_bp_crm_ticket_be-id_txt.
*
** Teilobjekt instanzieren
*    CALL METHOD /promos/cf_oppc_teilprozess=>find
*      EXPORTING
*        i_teilid           = ls_bp_crm_ticket_be-id
**       i_activity         = 'D'
*      RECEIVING
*        ro_teilprozess     = lo_te
*      EXCEPTIONS
*        not_found          = 1
*        locked             = 2
*        not_supported      = 3
*        keine_berechtigung = 4
*        OTHERS             = 5.
*
*    IF NOT lo_te IS BOUND.
*      CONTINUE.
*    ENDIF.
*
*    CALL METHOD lo_te->get_statistik
*      IMPORTING
*        es_statistik = ls_statistik.
*    gs_ticket_cn-bezeichnung = ls_statistik-teiltypbez.
*    CLEAR ls_crm_ticket_list.
*    MOVE-CORRESPONDING  gs_ticket_cn TO ls_crm_ticket_list.
*    APPEND ls_crm_ticket_list TO  gt_tickets_bak_cn.
*    APPEND gs_ticket_cn TO gt_ticket_cn.
*  ENDLOOP.
*  SORT gt_ticket_cn  BY statusdatum DESCENDING teilnr_child DESCENDING.
** Texteditor initialisieren
*  FREE go_cc_notice_02.
*  FREE go_cc_notice_01.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_NEW_TICKET_RO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_new_ticket_ro.
*  DATA: lt_crm_ticket_list    TYPE /promos/tt_crm_ticket_wd,
*        ls_crm_ticket_list    LIKE LINE OF lt_crm_ticket_list,
*        lt_crm_tree_table     TYPE /promos/tt_ct_data_wd,
*        lt_crm_fl_ticket_list TYPE /promos/tt_crm_ticket_wd,
*        ls_crm_fl_ticket_list LIKE LINE OF lt_crm_fl_ticket_list,
*        lt_crm_fl_tree_table  TYPE /promos/tt_ct_data_wd,
*        ls_children_be        TYPE /promos/s_ct_data,
*        ls_children_wd        TYPE /promos/s_ct_data_wd,
*        ld_recnnr(30).
*
**-------------------------*
** Tickets aus Klasse holen
*
*  REFRESH: lt_crm_fl_ticket_list, lt_crm_fl_tree_table,
*            gt_tickets_bak_ro.
*  CALL METHOD go_assistance->get_crm_ticket_list
*    EXPORTING
*      is_ticket_selection  = gd_selection
*      iv_partner           = gs_recn-partner
*    IMPORTING
*      et_crm_fl_ticket     = lt_crm_fl_ticket_list
*      et_crm_fl_tree_table = lt_crm_fl_tree_table.
*
** Vertrags Tickets
*  REFRESH: gt_ticket_ro.
*  LOOP AT lt_crm_fl_ticket_list INTO ls_crm_ticket_list.
*    CLEAR gs_ticket_ro.
*    MOVE-CORRESPONDING  ls_crm_ticket_list TO gs_ticket_ro.
*    gs_ticket_ro-teilnr = ls_crm_ticket_list-id_txt.
*    LOOP AT ls_crm_ticket_list-t_children INTO ls_children_wd
*      WHERE objtyp ='BUS0010'." and
**           relation = ld_recnnr.
*      MOVE-CORRESPONDING ls_children_wd TO gs_ticket_ro.
*      gs_ticket_ro-bezeichnung = ls_children_wd-bezeichnung.
*      gs_ticket_ro-tplnr = ls_children_wd-relation.
*      gs_ticket_ro-pltxt = ls_children_wd-relation_text.
*    ENDLOOP.
*    IF sy-subrc NE 0.
*      CONTINUE.
*    ENDIF.
*    APPEND ls_crm_ticket_list TO  gt_tickets_bak_ro.
*    APPEND gs_ticket_ro TO gt_ticket_ro.
*  ENDLOOP.

*  SORT gt_ticket_ro  BY statusdatum DESCENDING teilnr DESCENDING.
* Container für die Text löschen
  FREE go_cc_notice_ro_02.
  FREE go_cc_notice_ro_01.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  SET_PRIO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_prio_01 INPUT.
  PERFORM set_prio USING '01'.
ENDMODULE.
MODULE set_prio_01_ro INPUT.
  PERFORM set_prio_ro USING '01'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_PRIO_02  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_prio_02 INPUT.
  PERFORM set_prio USING '02'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_TPLNR_01_RO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_tplnr_ro_01 INPUT.
  PERFORM set_tplnr_ro  USING '01'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0300 INPUT.
  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXIT_RO_01'.
      IF go_dock_notice_ro_01 IS BOUND.
        go_dock_notice_ro_01->free( ).
        FREE go_dock_notice_ro_01 .
      ENDIF.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE_RO_01'.
* Ticket speichern
      PERFORM set_ticket_ro.
* ALV neue aufbauen
      PERFORM get_new_ticket_ro.
* Tabelle neu aufbauen
      CALL METHOD go_alv_ticket_ro->refresh( refresh_mode = 2 ).
      cl_gui_cfw=>flush( ).
      CLEAR gs_dynpro_ro_01.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0430  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0430 INPUT.
  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12' OR 'EXIT_RO_01'.

      LEAVE TO SCREEN 0.

  ENDCASE.
ENDMODULE.
