FUNCTION z_recn_bp_cockpit_gui.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_INTRENO) TYPE  VVINTRENO
*"----------------------------------------------------------------------

* local Data
  TYPE-POOLS: abap.
  DATA:
    lo_cn                 TYPE REF TO if_recn_contract,
    lo_notice_mngr        TYPE REF TO if_retm_notice_mngr,
    lo_notice_proc_mngr   TYPE REF TO if_retm_notice_proc_mngr,
    lo_specific_term_mngr TYPE REF TO if_retm_specific_term_mngr,
    lo_period_mngr        TYPE REF TO if_retm_period_mngr,
    lo_term_mngr          TYPE REF TO if_retm_term_mngr,
* condition
    lo_has_cond           TYPE REF TO if_recd_has_condition,
    lo_condition_mngr     TYPE REF TO if_recd_condition_mngr,
    lt_ntrule             TYPE re_t_notice_proc_uni,
    ls_ntrule             LIKE LINE OF lt_ntrule,
    lt_ntsim              TYPE re_t_notice_sim,
    ls_ntsim              LIKE LINE OF lt_ntsim,
    ls_contract           TYPE bapi_re_contract_int,
    lt_term_rhythm        TYPE bapi_re_t_term_rh_int,
    ls_term_rhythm        LIKE LINE OF lt_term_rhythm,
    lt_term_payment       TYPE bapi_re_t_term_py_int,
    ls_term_payment       LIKE LINE OF lt_term_payment,
    lt_condition          TYPE bapi_re_t_condition_int,
    ls_condition          LIKE LINE OF lt_condition,
    lt_object_rel         TYPE bapi_re_t_object_rel_int,
    ls_object_rel         LIKE LINE OF lt_object_rel,
    lt_partner            TYPE bapi_re_t_partner_int,
    ls_partner            LIKE LINE OF lt_partner,
    lt_partner_be         TYPE bapi_re_t_partner_int,
    ls_partner_be         LIKE LINE OF lt_partner_be,
    lt_partner_bu         TYPE bapi_re_t_partner_int,
    ls_partner_bu         LIKE LINE OF lt_partner_bu,
    lt_partner_ro         TYPE bapi_re_t_partner_int,
    ls_partner_ro         LIKE LINE OF lt_partner_ro,
    lt_main_partner       TYPE bapi_re_t_partner_int,
    ls_main_partner       LIKE LINE OF lt_main_partner,
    lt_status             TYPE bapi_re_t_status_int,
    ls_ci_data            TYPE  recn_contract_ci,
    lt_ext_data           TYPE  re_t_ext_data,
    ls_ext_data           LIKE LINE OF  lt_ext_data,
    lt_objnr              TYPE re_t_objnr,
    ls_objnr              LIKE LINE OF lt_objnr,
    lt_iflo               TYPE TABLE OF iflo,
    ls_iflo               LIKE LINE OF lt_iflo,
*    lt_oppcteil           TYPE TABLE OF /promos/oppcteil,
*    ls_oppcteil           LIKE LINE OF lt_oppcteil,
    ls_status             LIKE LINE OF lt_status,
    lt_bsid               TYPE TABLE OF bsid,
    ls_bsid               LIKE LINE OF lt_bsid,
*    lt_code_all           TYPE /promos/tt_all_codes_wd,
*    ls_code_all           LIKE LINE OF lt_code_all,
*    ls_codes              TYPE /promos/s_codes_wd,
*    lt_codes              TYPE TABLE OF /promos/s_codes_wd,
    ld_manst              TYPE mahns_d,
    lt_tivbdmeast         TYPE TABLE OF tivbdmeast,
    ls_tivbdmeast         TYPE tivbdmeast,
    ld_tabix              LIKE sy-tabix.
*
  DATA: lt_reexkunnrcn TYPE TABLE OF v_reexkunnrcn,
        ls_reexkunnrcn LIKE LINE OF lt_reexkunnrcn,
        ld_partner     TYPE bu_partner,
        lt_vicncn      TYPE TABLE OF vicncn,
        ls_vicncn      LIKE LINE OF lt_vicncn,
        ls_but000      TYPE but000,
        ls_but020      TYPE but020,
        lt_but0bk      TYPE TABLE OF  but0bk,
        ls_but0bk      TYPE but0bk,
        ls_tiban       TYPE tiban,
        ls_adrc        TYPE adrc,
        ls_adr2        TYPE adr2,
        ls_adr6        TYPE adr6,
        ls_tiv2f       TYPE  tiv2f,
        ls_recn        LIKE gs_recn,
        ld_termtype    TYPE  retm_term-termtype,
        ls_period_x    TYPE retm_period_x.
*        ld_bk01iban    TYPE reyacabk01iban.
* Konditionen
  DATA:
    lt_cond_x TYPE re_t_recd_condition_x,
    ls_cond_x TYPE recd_condition_x,
    lt_color  TYPE lvc_t_scol,
    ls_color  TYPE lvc_s_scol.

  DATA: ls_rental_object  TYPE  bapi_re_rental_object_int,
        ls_ci_data_ro     TYPE  rebd_rental_object_ci,
        lt_measurement    TYPE  bapi_re_t_measurement_int,
        ls_measurement    LIKE LINE OF lt_measurement,
        ls_object_address TYPE  bapi_re_obj_address_int,
        lt_obj_assign     TYPE  bapi_re_t_obj_assign_int,
        ls_obj_assign     LIKE LINE OF lt_obj_assign,
        ls_vibdbe         TYPE vibdbe,
        ls_vibdbu         TYPE vibdbu,
        ld_years          TYPE i,
        ls_tiv3h          TYPE tiv3h.
*  DATA: lt_crm_ticket_be TYPE /promos/tt_crm_ticket,
*        ls_crm_ticket_be LIKE LINE OF lt_crm_ticket_be.

*  DATA: lt_data_status TYPE zreiscn_daten,
*        ls_data_status LIKE LINE OF lt_data_status.

  DATA lt_tel           TYPE TABLE OF bapiadtel.
  DATA lt_fax           TYPE TABLE OF bapiadfax.
  DATA lt_smtp_addr     TYPE TABLE OF bapiadsmtp.
  DATA lt_remark        TYPE TABLE OF bapicomrem.
  DATA ls_tel           TYPE bapiadtel.
  DATA ls_fax           TYPE bapiadfax.
  DATA ls_smtp_addr     TYPE bapiadsmtp.
  DATA ls_remark        TYPE bapicomrem.
  DATA lt_return TYPE TABLE OF  bapiret2.

** ranges
*  DATA: lrt_objkey TYPE RANGE OF /promos/oppc_objkey,
*        lrs_objkey LIKE LINE  OF lrt_objkey.
* Tickets
*  DATA: lt_crm_ticket_list    TYPE /promos/tt_crm_ticket_wd,
*        ls_crm_ticket_list    LIKE LINE OF lt_crm_ticket_list,
*        lt_crm_tree_table     TYPE /promos/tt_ct_data_wd,
*        lt_crm_fl_ticket_list TYPE /promos/tt_crm_ticket_wd,
*        ls_crm_fl_ticket_list LIKE LINE OF lt_crm_fl_ticket_list,
*        lt_crm_fl_tree_table  TYPE /promos/tt_ct_data_wd,
*        ls_children_be        TYPE /promos/s_ct_data,
*        ls_children_wd        TYPE /promos/s_ct_data_wd,
*        lv_not_refreshed      TYPE wdy_boolean.
  DATA: lr_elemdescr TYPE REF TO cl_abap_elemdescr,
        lt_values    TYPE ddfixvalues,
        ls_values    TYPE ddfixvalue.
*----------------------------------------
  CLEAR: gd_ticket_ro_new.
* get cn data
  CALL FUNCTION 'API_RE_CN_GET_DETAIL'
    EXPORTING
      id_intreno          = im_intreno
      id_detail_data_from = sy-datum
    IMPORTING
      es_contract         = ls_contract
      et_term_rhythm      = lt_term_rhythm
      et_term_payment     = lt_term_payment
      et_condition        = lt_condition
      et_object_rel       = lt_object_rel
      et_partner          = lt_partner
      et_main_partner     = lt_main_partner
      et_status           = lt_status
      es_ci_data          = ls_ci_data
      et_ext_data         = lt_ext_data
    EXCEPTIONS
      error               = 1
      OTHERS              = 2.
  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  CLEAR gs_vn.
  MOVE-CORRESPONDING ls_contract TO gs_vn-vn.
  MOVE-CORRESPONDING ls_contract TO gs_recn.
*  gs_recn-ih_stopp = ls_ci_data-zzih_stop.
*  gs_recn-ih_kommentar = ls_ci_data-zz_kommentar.

* Systemstatus
  CLEAR:gs_recn-sttxt_int, gs_recn-status.
  LOOP AT lt_status INTO ls_status.
    CONCATENATE gs_recn-status ls_status-txt04 INTO gs_recn-status
    SEPARATED BY '/'.
  ENDLOOP.
  IF sy-subrc = 0.
    SHIFT gs_recn-status LEFT BY 1 PLACES.
  ENDIF.
  IF ls_contract-recnendabs = reca0_date-max.
*   gs_recn-recnendabs = 'unbefr.'.
    CLEAR gs_recn-recnendabs.
* Laufzeit holen
    CALL METHOD cl_reca_date=>get_date_diff
      EXPORTING
        id_date_from = ls_contract-recnbeg
        id_date_to   = sy-datum
      IMPORTING
        ed_years     = ld_years.
    gs_recn-lfz_jahre = ld_years.
  ELSE.
    WRITE ls_contract-recnendabs TO gs_recn-recnendabs.
    gs_recn-lfz_jahre = ls_contract-recnendabs - ls_contract-recnbeg.
* Laufzeit holen
    CALL METHOD cl_reca_date=>get_date_diff
      EXPORTING
        id_date_from = ls_contract-recnbeg
        id_date_to   = ls_contract-recnendabs
      IMPORTING
        ed_years     = ld_years.
    gs_recn-lfz_jahre = ld_years.
  ENDIF.

  gs_contract  = ls_contract.
  gs_recn-identkey = ls_contract-identkey.
* Statuskennzeichen
*Daten Selektion
*-Statuse-lesen-------------------------------------------------------------------------------------------*
  DATA: ld_container TYPE c LENGTH 960.
*  DATA: ld_tatus_txt  TYPE    zreca_status_txt,
*        lo_status_ext TYPE REF TO /prorex/cl_ex_ca_bd_ass.
*  DATA : zrecastatus_alv_t TYPE TABLE OF zrecastatus_alv.
*  FIELD-SYMBOLS:
*    <fs_tables>   TYPE /prorex/cl_ex_ca_bd_ass=>ts_tables,
*    <ft_data_new> LIKE zrecastatus_alv_t,
*    <fs_data_new> LIKE LINE OF zrecastatus_alv_t.

*  LOOP AT lt_ext_data INTO ls_ext_data WHERE
*  extid = 'ZRECASTATUS'.

**   convert string data (flat) to structured data for extension
*    ld_container = ls_ext_data-data.
*    CALL METHOD cl_abap_container_utilities=>read_container_c
*      EXPORTING
*        im_container = ld_container
*      IMPORTING
*        ex_value     = ld_tatus_txt
*      EXCEPTIONS
*        OTHERS       = 0.
*  ENDLOOP.


* Kündigung simulieren
  CALL METHOD cf_recn_contract=>find_by_intreno
    EXPORTING
      id_intreno  = im_intreno
    RECEIVING
      ro_instance = lo_cn
    EXCEPTIONS
      error       = 1
      OTHERS      = 2.
  IF NOT lo_cn IS BOUND.
    RETURN.
  ENDIF.

*  lo_status_ext ?= lo_cn->if_reca_storable~get_extension( zcl_im_recn_status_01=>mc_objname_ext ).
*  LOOP AT lo_status_ext->mt_tables ASSIGNING <fs_tables> "nur max. ein richtigiger Eintrag
*    WHERE post_struct IS NOT INITIAL
*      AND alv_tabname = 'ZRECASTATUS_ALV'.
*    ASSIGN <fs_tables>-data_new->* TO <ft_data_new>.
*    IF sy-subrc = 0.
*      LOOP AT <ft_data_new> ASSIGNING <fs_data_new>.
*        IF gs_recn-zreca_status_txt IS INITIAL.
*          gs_recn-zreca_status_txt = <fs_data_new>-status_kz_txt.
*        ELSE.
*          CONCATENATE gs_recn-zreca_status_txt ',' INTO gs_recn-zreca_status_txt.
*          CONCATENATE gs_recn-zreca_status_txt   <fs_data_new>-status_kz_txt INTO gs_recn-zreca_status_txt
*            SEPARATED BY space.
*
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.
* Kündigung

*Instanz global übergeben
  go_cn ?= lo_cn.
*   get notice manager
  CALL METHOD lo_cn->get_term_notice_mngr
    RECEIVING
      ro_notice_mngr = lo_notice_mngr.
* Kündigungsmanager holen
* get term manager
  lo_term_mngr = lo_cn->get_term_mngr( ).
  ld_termtype = '1000'.
  CALL METHOD lo_term_mngr->get_specific_term_mngr
    EXPORTING
      id_termtype   = ld_termtype
    RECEIVING
      ro_instance   = lo_specific_term_mngr
    EXCEPTIONS
      not_supported = 1
      OTHERS        = 2.
  lo_period_mngr ?= lo_specific_term_mngr.
  CALL METHOD lo_period_mngr->get_detail_x
*   EXPORTING
*     ID_LANGU    = SY-LANGU
    RECEIVING
      rs_detail_x = ls_period_x.
  IF sy-subrc = 0.
    gs_recn-sttxt_int = ls_period_x-xpestate.
  ENDIF.

* Kündigungsmanager holen
  CALL METHOD lo_notice_mngr->get_notice_proc_mngr
    EXPORTING
      id_termno           = ' '
    RECEIVING
      ro_notice_proc_mngr = lo_notice_proc_mngr
    EXCEPTIONS
      not_found           = 1
      OTHERS              = 2.
  IF sy-subrc = 0.

* Eigentümer
    CALL METHOD lo_notice_proc_mngr->set_sim_defaults
      EXPORTING
        id_sim_ntprocprty = retm2_ntprocprty-landlord.
* Simulation
    CALL METHOD lo_notice_proc_mngr->calc_date_list
      EXPORTING
        if_simulate = abap_false
      IMPORTING
        et_ntsim    = lt_ntsim
      EXCEPTIONS
        error       = 1
        OTHERS      = 2.

    SORT lt_ntsim BY ntreceiptfrom DESCENDING.
    LOOP AT lt_ntsim INTO ls_ntsim WHERE
    ntreceiptfrom LE sy-datum.
      WRITE ls_ntsim-ntcalculated TO gs_recn-ntcalculated_geber.
*       gs_recn-ntcalculated_geber = ls_ntsim-ntcalculated.
      EXIT.
    ENDLOOP.

    REFRESH lt_ntrule.
* Mieter
    CALL METHOD lo_notice_proc_mngr->set_sim_defaults
      EXPORTING
        id_sim_ntprocprty = retm2_ntprocprty-tenant.
* Simulation
    CALL METHOD lo_notice_proc_mngr->calc_date_list
      EXPORTING
        if_simulate = abap_false
      IMPORTING
        et_ntsim    = lt_ntsim
      EXCEPTIONS
        error       = 1
        OTHERS      = 2.
    SORT lt_ntsim BY  ntreceiptfrom DESCENDING.
    LOOP AT lt_ntsim INTO ls_ntsim WHERE
    ntreceiptfrom LE sy-datum.
*       gs_recn-ntcalculated_nehmer = ls_ntsim-ntcalculated.
      WRITE ls_ntsim-ntcalculated TO gs_recn-ntcalculated_nehmer .
      EXIT.
    ENDLOOP.
  ENDIF.
* Konditionen holen
  TRY.
      lo_has_cond ?= lo_cn.
    CATCH cx_sy_move_cast_error.
  ENDTRY.
* get condition manager
  lo_condition_mngr = lo_has_cond->get_condition_mngr( ).
  CALL METHOD lo_condition_mngr->get_list
    EXPORTING
*     if_incl_booking_context = mf_incl_booking_context
*     if_incl_booking_min_max = mf_incl_booking_context
*     if_incl_lock_context    = abap_false
*     if_incl_note_exists     = abap_false
      if_incl_adjustable_flag = abap_false
      id_keydate              = reca0_date-min
    IMPORTING
      et_detail_x             = lt_cond_x.

  REFRESH gt_cond.
  LOOP AT  lt_cond_x INTO ls_cond_x.
    ld_tabix = sy-tabix.
    CLEAR gs_cond.
    MOVE-CORRESPONDING ls_cond_x TO gs_cond.
    IF  ls_cond_x-condvalidfrom LE sy-datum AND
        ls_cond_x-condvalidto GE sy-datum.
*      REFRESH lt_color.
*      CLEAR ls_color.
*      ls_color-fname = space..
*      ls_color-color-col = '5'. "Grün
*      ls_color-color-int = 1.
*      ls_color-color-inv = 1.
*      APPEND ls_color TO lt_color.
*      gs_cond-t_color = lt_color.
    ELSE.
      CONTINUE.
    ENDIF.
    APPEND gs_cond TO gt_cond.
  ENDLOOP.

* Partner holen
  IF lt_main_partner[] IS INITIAL.
    lt_main_partner[] = lt_partner[].
  ENDIF.
  LOOP AT  lt_main_partner INTO  ls_main_partner.
    CHECK  ls_main_partner-validfrom LE sy-datum.
    CHECK  ls_main_partner-validto GT sy-datum.
    ld_partner = ls_main_partner-partner.
    gs_recn-partner = ls_main_partner-partner.
* Vollständiger Name
    gs_recn-xpartner = ls_main_partner-xpartner.
    SELECT SINGLE * FROM but000 INTO ls_but000
    WHERE partner = ls_main_partner-partner.
    IF sy-subrc = 0.
      IF NOT ls_but000-name_last IS INITIAL.
        gs_recn-name_last =  ls_but000-name_last.
      ELSE.
        gs_recn-name_last =  ls_but000-name_org1.
      ENDIF.
      IF NOT ls_but000-name_first IS INITIAL.
        gs_recn-name_first =  ls_but000-name_first.
      ELSE.
        gs_recn-name_first = ls_but000-name_org2.
      ENDIF.
      gs_recn-birthdt =  ls_but000-birthdt.
    ELSE.
      gs_recn-name_last =  ls_main_partner-xname.
    ENDIF.
* Debitor holen
    SELECT SINGLE customer FROM cvi_cust_link INTO gs_recn-debitor
    WHERE partner_guid = ls_but000-partner_guid.

* Adresse

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT SINGLE * FROM but020 INTO ls_but020
*    WHERE partner = ls_main_partner-partner.

    SELECT * FROM but020 INTO ls_but020 UP TO 1 ROWS
     WHERE partner = ls_main_partner-partner
     ORDER BY PRIMARY KEY .
    ENDSELECT.
* End of Quick Fix

    IF sy-subrc = 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*      SELECT SINGLE * FROM adrc INTO ls_adrc
*      WHERE
*      addrnumber = ls_but020-addrnumber.

      SELECT * FROM adrc INTO ls_adrc UP TO 1 ROWS
       WHERE addrnumber = ls_but020-addrnumber
       ORDER BY PRIMARY KEY .
      ENDSELECT.
* End of Quick Fix

      IF sy-subrc = 0.
        gs_recn-city1 = ls_adrc-city1.
        gs_recn-post_code  = ls_adrc-post_code1.
        gs_recn-street  = ls_adrc-street.
        gs_recn-house_num1   = ls_adrc-house_num1.
      ENDIF.
*        gs_recn-phone1   = ls_adrc-tel_number.
**     gs_recn-mobile1  = ls_adrc-mobile1.
*        SELECT SINGLE * FROM adr6 INTO ls_adr6
*        WHERE addrnumber = ls_but020-addrnumber.
*        IF sy-subrc = 0.
*          gs_recn-e_mail  = ls_adr6-smtp_addr .
*        ENDIF.
*      ENDIF.
      CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
        EXPORTING
          businesspartner              = ls_but000-partner
          valid_date                   = sy-datum
        TABLES
          telefondatanonaddress        = lt_tel
          faxdatanonaddress            = lt_fax
          e_maildatanonaddress         = lt_smtp_addr
          communicationnotesnonaddress = lt_remark
          return                       = lt_return.
      .
      LOOP AT lt_tel INTO ls_tel.
        CASE ls_tel-r_3_user .
          WHEN '1'.
            gs_recn-phone1 = ls_tel-telephone.
          WHEN '3'. "Mobile
            gs_recn-mobile1  = ls_tel-telephone.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

      LOOP AT lt_smtp_addr INTO ls_smtp_addr.
        gs_recn-e_mail = ls_smtp_addr-e_mail.
      ENDLOOP.
    ENDIF.
* Bankverbindung

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT * FROM but0bk INTO TABLE lt_but0bk
*    WHERE partner = ls_main_partner-partner.

    SELECT * FROM but0bk INTO TABLE lt_but0bk
        WHERE partner = ls_main_partner-partner ORDER BY PRIMARY KEY .

* End of Quick Fix

  ENDLOOP.

** BK01 besorgen
*  CLEAR ld_bk01iban.
*  SELECT SINGLE * FROM vicncn INTO ls_vicncn
*  WHERE intreno = go_cn->md_intreno.
*  IF sy-subrc = 0.
*    ld_bk01iban = ls_vicncn-bk01iban.
*  ENDIF.
* Buchungsparameter
  LOOP AT lt_term_payment INTO ls_term_payment.
    gs_recn-zlsch = ls_term_payment-pymtmeth.
    gs_recn-mansp = ls_term_payment-dunnblock.
*    IF NOT ld_bk01iban IS INITIAL.
*      gs_recn-iban = ld_bk01iban.
*      CALL FUNCTION 'FI_IBAN_F4_FORMATTING'
*        EXPORTING
*          i_iban    = gs_recn-iban
*        IMPORTING
*          e_iban    = gs_recn-iban
*        EXCEPTIONS
*          too_short = 1
*          OTHERS    = 2.
*    ELSE.
    READ TABLE lt_but0bk INTO ls_but0bk
    WITH KEY bkvid = ls_term_payment-bankdetailid.
    IF sy-subrc NE 0.
      READ TABLE lt_but0bk INTO ls_but0bk INDEX 1.
    ENDIF.
    IF sy-subrc = 0.

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*        SELECT SINGLE * FROM tiban
*        INTO ls_tiban
*        WHERE bankl = ls_but0bk-bankl AND
*        bankn = ls_but0bk-bankn.

      SELECT * FROM tiban
       INTO ls_tiban UP TO 1 ROWS WHERE bankl = ls_but0bk-bankl AND bankn = ls_but0bk-bankn
       ORDER BY PRIMARY KEY .
      ENDSELECT.
* End of Quick Fix

      IF sy-subrc = 0.
        gs_recn-iban = ls_tiban-iban.
        CALL FUNCTION 'FI_IBAN_F4_FORMATTING'
          EXPORTING
            i_iban    = gs_recn-iban
          IMPORTING
            e_iban    = gs_recn-iban
          EXCEPTIONS
            too_short = 1
            OTHERS    = 2.
      ENDIF.
    ENDIF.
*    ENDIF.
  ENDLOOP.
* Konditionen holen
  LOOP AT lt_condition INTO ls_condition WHERE condvalidfrom LE sy-datum.
    IF ls_condition-condpurposeext = 'A' OR
    ls_condition-condpurposeext = 'B'.
* okay.
    ELSE.
      CONTINUE.
    ENDIF.
    CASE ls_condition-condtype.
      WHEN '1000'. "Grundmiete
        gs_recn-grundmiete = ls_condition-unitprice. "#EC CI_FLDEXT_OK[2610650]
      WHEN '2000'.
        gs_recn-beko_vz  = ls_condition-unitprice. "#EC CI_FLDEXT_OK[2610650]
      WHEN '2100'.
        gs_recn-heiko_vz  = ls_condition-unitprice. "#EC CI_FLDEXT_OK[2610650]
      WHEN OTHERS.
        gs_recn-sonst_kond  = gs_recn-sonst_kond  + ls_condition-unitprice. "#EC CI_FLDEXT_OK[2610650]
    ENDCASE.
    gs_recn-gesamtmiete  = gs_recn-gesamtmiete  +  ls_condition-unitprice. "#EC CI_FLDEXT_OK[2610650]
  ENDLOOP.

* WEITER Partner aus Vertrag
  LOOP AT  lt_partner INTO  ls_partner.
    CLEAR gs_partner.
    MOVE-CORRESPONDING ls_partner TO gs_partner.
    APPEND gs_partner TO gt_partner.
    CLEAR gs_partner_cn.
    MOVE-CORRESPONDING ls_partner TO  gs_partner_cn.
* Rolle holen
    SELECT SINGLE rltxt FROM tb003t INTO gs_partner_cn-xname
    WHERE spras = sy-langu AND
    role = gs_partner_cn-role.
    APPEND gs_partner_cn TO gt_partner_cn.
  ENDLOOP.
  IF sy-subrc = 0.
    gs_vn-t_partner[] = gt_partner[].
  ENDIF.

* Objnr
  LOOP AT lt_object_rel INTO ls_object_rel.
    CASE ls_object_rel-objtypecn.
      WHEN reca1_objtype-rental_object.
        gs_recn-objnr_ro = ls_object_rel-objnrcn.
      WHEN reca1_objtype-building.
        gs_recn-objnr_bu = ls_object_rel-objnrcn.
      WHEN reca1_objtype-business_entity.
        gs_recn-objnr_be = ls_object_rel-objnrcn.
      WHEN reca1_objtype-property.
        gs_recn-objnr_pr = ls_object_rel-objnrcn.
    ENDCASE.
  ENDLOOP.

* Objektnummern
  IF NOT gs_recn-objnr_ro IS INITIAL.
*API
    CALL FUNCTION 'API_RE_RO_GET_DETAIL'
      EXPORTING
        id_objnr            = gs_recn-objnr_ro
        id_detail_data_from = sy-datum
      IMPORTING
        es_object_address   = ls_object_address
        es_rental_object    = ls_rental_object
        et_measurement      = lt_measurement
        et_obj_assign       = lt_obj_assign
        et_partner          = lt_partner_ro
        es_ci_data          = ls_ci_data_ro
      EXCEPTIONS
        error               = 1
        OTHERS              = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

* Flächen holen
* Bemessungstext holen
    SELECT * FROM tivbdmeast INTO TABLE lt_tivbdmeast
    WHERE spras = sy-langu.
    REFRESH: gt_area.
    LOOP AT lt_measurement INTO ls_measurement.
      CLEAR gs_area.
      CHECK ls_measurement-validto GT sy-datum.
      MOVE-CORRESPONDING ls_measurement TO gs_area.
      READ TABLE lt_tivbdmeast INTO ls_tivbdmeast WITH KEY meas = ls_measurement-meas.
      IF sy-subrc = 0.
        gs_area-xmmeas = ls_tivbdmeast-xmmeas.
      ENDIF.
      APPEND gs_area TO gt_area.
      CASE ls_measurement-meas.
        WHEN 'A100'.
          gs_recn-measvalue = gs_recn-measvalue + ls_measurement-measvalue.
        WHEN 'A200'.
          gs_recn-measvalue = gs_recn-measvalue + ls_measurement-measvalue.
        WHEN 'Z100'.
          gs_recn-anz_zimmer  =  gs_recn-anz_zimmer + ls_measurement-measvalue.
      ENDCASE.
    ENDLOOP.
* Mietobjekt
    gs_recn-snunr = ls_rental_object-snunr.
    SELECT SINGLE xmbez FROM tiv0a  INTO  gs_recn-xmbez
    WHERE spras = sy-langu AND
    snunr =  ls_rental_object-snunr.
** spez. Nutzungsart
*    SELECT SINGLE text FROM zrebdro_spsnunrt  INTO  gs_recn-xmbez_spez
*    WHERE spras = sy-langu AND
*    usagetype =  ls_ci_data_ro-zz_sp_utype.
* Adresse
    gs_recn-city1 = ls_object_address-city1.
    gs_recn-post_code  = ls_object_address-post_code1.
    gs_recn-street   = ls_object_address-street.
    gs_recn-house_num1  = ls_object_address-house_num1.
*   gs_recn-address   = ls_object_address-address.
    gs_recn-xstockl  = ls_rental_object-sstockw.
    CONCATENATE gs_recn-street gs_recn-house_num1 INTO gs_recn-address SEPARATED BY space.
    CONCATENATE gs_recn-address ',' INTO gs_recn-address.
*    IF NOT ls_ci_data_ro-zz_lage_ge IS INITIAL.
*      CONCATENATE gs_recn-address ls_ci_data_ro-zz_lage_ge  INTO gs_recn-address SEPARATED BY space.
*      CONCATENATE gs_recn-address  ','  INTO gs_recn-address.
*    ENDIF.
    CONCATENATE gs_recn-address gs_recn-post_code gs_recn-city1
    INTO gs_recn-address SEPARATED BY space.
    SELECT SINGLE  * FROM tiv3h INTO ls_tiv3h
    WHERE spras = sy-langu AND
    rlgesch = ls_rental_object-rlgesch.
    IF sy-subrc = 0.
      gs_recn-xmlgesch   = ls_tiv3h-xmlgesch.
    ENDIF.
* Wirtschatseinehit

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT SINGLE * FROM vibdbe INTO ls_vibdbe
*    WHERE bukrs = ls_rental_object-bukrs AND
*    swenr = ls_rental_object-swenr.

    SELECT * FROM vibdbe INTO ls_vibdbe UP TO 1 ROWS
     WHERE bukrs = ls_rental_object-bukrs AND swenr = ls_rental_object-swenr
     ORDER BY PRIMARY KEY .
    ENDSELECT.
* End of Quick Fix

    IF sy-subrc = 0.
      gs_recn-objnr_be = ls_vibdbe-objnr.
    ENDIF.
* Gebäude

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT SINGLE * FROM vibdbu INTO ls_vibdbu
*    WHERE bukrs = ls_rental_object-bukrs AND
*    swenr = ls_rental_object-swenr AND
*    sgenr = ls_rental_object-sgenr.

    SELECT * FROM vibdbu INTO ls_vibdbu UP TO 1 ROWS
     WHERE bukrs = ls_rental_object-bukrs AND swenr = ls_rental_object-swenr AND sgenr = ls_rental_object-sgenr
     ORDER BY PRIMARY KEY .
    ENDSELECT.
* End of Quick Fix

    IF sy-subrc = 0.
      gs_recn-objnr_bu = ls_vibdbu-objnr.
      gs_recn-ybaujahr  = ls_vibdbu-ybaujahr.
*      gs_recn-finanzierung  = ls_vibdbu-zz_finanzart.
*      SELECT SINGLE  bechreibung  FROM zrebe_custfiartx INTO gs_recn-finanzierung
*      WHERE language = sy-langu AND
*      finanzart = ls_vibdbu-zz_finanzart.
* Gebäude
      CALL FUNCTION 'API_RE_BU_GET_DETAIL'
        EXPORTING
*         ID_BUKRS   =
*         ID_SWENR   =
          id_objnr   = ls_vibdbu-objnr
*         ID_INTRENO =
*         IO_OBJECT  =
*         ID_DETAIL_DATA_FROM          =
*         ID_DETAIL_DATA_TO            =
*         IF_OLD_DATA                  = ' '
        IMPORTING
          et_partner = lt_partner_bu
        EXCEPTIONS
          error      = 1
          OTHERS     = 2.
      DELETE lt_partner_bu WHERE validto LT sy-datum.
    ENDIF.

* Grundstück

* Quick Fix Replace this statement by a SELECT statement with ORDER BY
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT SINGLE objnr FROM vibdpr INTO gs_recn-objnr_pr
*    WHERE bukrs = ls_rental_object-bukrs AND
*    swenr = ls_rental_object-swenr AND
*    sgrnr = ls_rental_object-sgrnr.

    SELECT objnr FROM vibdpr INTO gs_recn-objnr_pr UP TO 1 ROWS
     WHERE bukrs = ls_rental_object-bukrs AND swenr = ls_rental_object-swenr AND sgrnr = ls_rental_object-sgrnr
     ORDER BY PRIMARY KEY .
    ENDSELECT.
* End of Quick Fix

  ENDIF.

* Vertragsarten holen
  SELECT * FROM tiv2f INTO TABLE gt_tiv2f
  WHERE spras = sy-langu.
* Wirtschattseinheit
  CALL FUNCTION 'API_RE_BE_GET_DETAIL'
    EXPORTING
*     ID_BUKRS   =
*     ID_SWENR   =
      id_objnr   = gs_recn-objnr_be
*     ID_INTRENO =
*     IO_OBJECT  =
*     ID_DETAIL_DATA_FROM          =
*     ID_DETAIL_DATA_TO            =
*     IF_OLD_DATA                  = ' '
    IMPORTING
      et_partner = lt_partner_be
    EXCEPTIONS
      error      = 1
      OTHERS     = 2.
  IF sy-subrc = 0.
* Mitarbeiter
    LOOP AT lt_partner_be INTO ls_partner_be.
      CLEAR gs_clerk.
* Gebäude
      READ TABLE lt_partner_bu INTO ls_partner_bu
        WITH KEY role = ls_partner_be-role.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_partner_bu TO ls_partner_be.
      ENDIF.
* Mietobjekt
      READ TABLE lt_partner_ro INTO ls_partner_ro
        WITH KEY role = ls_partner_be-role.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_partner_ro TO ls_partner_be.
      ENDIF.

      MOVE-CORRESPONDING ls_partner_be TO gs_clerk.
      gs_clerk-partner_clerk = ls_partner_be-partner.
      SELECT SINGLE rltxt FROM tb003t INTO gs_clerk-xname
      WHERE spras = sy-langu AND
      role = ls_partner_be-role.
* Telefon
      REFRESH lt_tel.
      CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
        EXPORTING
          businesspartner       = ls_partner_be-partner
          valid_date            = sy-datum
        TABLES
          telefondatanonaddress = lt_tel
          return                = lt_return.
      .

      LOOP AT lt_tel INTO ls_tel.
        IF NOT gs_clerk-telefon IS INITIAL.
          EXIT.
        ENDIF.
        CASE ls_tel-r_3_user .
          WHEN '1'.
            gs_clerk-telefon = ls_tel-telephone.
          WHEN '3'. "Mobile
            gs_clerk-telefon  = ls_tel-telephone.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
      APPEND gs_clerk TO gt_clerk.
    ENDLOOP.
    IF sy-subrc = 0.
      gs_vn-t_clerk[] = gt_clerk[].
    ENDIF.
  ENDIF.

* weitere Verträge holen
  REFRESH lt_reexkunnrcn.
  SELECT * FROM v_reexkunnrcn INTO TABLE lt_reexkunnrcn
  WHERE partner = ld_partner.

* Quick Fix Insert a SORT statement after the SELECT statement
* 30.04.2024 09:37:31 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
  SORT lt_reexkunnrcn BY intreno recnnr bukrs recntype recnbeg recnendabs recnnotper recntxtold recnnrcollect recntxt role partner bu_sort1 bu_sort2 name_org1 name_org2 name_last name_first mc_name1 mc_name2 kunnr begru ktokd.

* End of Quick Fix
  IF sy-subrc = 0.

* Quick Fix Append ORDER BY PRIMARY KEY to the SELECT statement
* 29.04.2024 17:44:50 DEB56322
* Transport XS4K900004 W-20240402: P1CL3 ATC P44 Objekte                     => PS4
* Replaced Code:
*    SELECT * FROM vicncn INTO TABLE lt_vicncn
*    FOR ALL ENTRIES IN lt_reexkunnrcn
*    WHERE intreno = lt_reexkunnrcn-intreno.

    SELECT * FROM vicncn INTO TABLE lt_vicncn
        FOR ALL ENTRIES IN lt_reexkunnrcn
        WHERE intreno = lt_reexkunnrcn-intreno ORDER BY PRIMARY KEY .

* End of Quick Fix

    IF sy-subrc = 0.
      LOOP AT lt_vicncn INTO ls_vicncn.
        CLEAR gs_vicncn.
        CHECK ls_vicncn-intreno NE ls_contract-intreno.
        CLEAR ls_recn.
        MOVE-CORRESPONDING ls_vicncn TO ls_recn.
        MOVE-CORRESPONDING ls_vicncn TO gs_vicncn.
        ls_recn-swenr = ls_vicncn-benocn.
        WRITE ls_vicncn-recnendabs TO ls_recn-recnendabs.
*
        READ TABLE  gt_tiv2f INTO ls_tiv2f WITH KEY
        smvart =  ls_vicncn-recntype.
        IF sy-subrc = 0.
          ls_recn-xmbez = ls_tiv2f-xmbez.
          gs_vicncn-xmbez = ls_tiv2f-xmbez.
          ls_vicncn-recntxt = ls_tiv2f-xmbez.
        ENDIF.
        APPEND ls_recn TO gt_recn.
* Weiteren Vertäge
        APPEND gs_vicncn TO gt_vicncn.
      ENDLOOP.
      IF sy-subrc = 0.
        gs_vn-t_recn[] = gt_recn[].
      ENDIF.
    ENDIF.
  ENDIF.

* Debitorensaldo
  READ TABLE lt_reexkunnrcn INTO ls_reexkunnrcn INDEX 1.
  IF sy-subrc = 0.
    SELECT * FROM bsid INTO TABLE lt_bsid
    WHERE bukrs = ls_vicncn-bukrs AND
    kunnr = ls_reexkunnrcn-kunnr.
*   DELETE lt_bsid WHERE vertn NE ls_contract-recnnr.
    DELETE lt_bsid WHERE blart = 'UA'.
    DELETE lt_bsid WHERE umskz = 'K'.
    DELETE lt_bsid WHERE umskz = 'L'.
    LOOP AT lt_bsid INTO ls_bsid.
      IF ls_bsid-shkzg = 'S'.
        gs_recn-saldo_debitor = gs_recn-saldo_debitor + ls_bsid-dmbtr.
      ELSE.
        gs_recn-saldo_debitor = gs_recn-saldo_debitor - ls_bsid-dmbtr.
      ENDIF.
      CHECK ls_bsid-vertn = ls_contract-recnnr.
      IF NOT ls_bsid-manst IS INITIAL AND ld_manst LT ls_bsid-manst.
        ld_manst = ls_bsid-manst.
      ENDIF.
      IF ls_bsid-shkzg = 'S'.
        gs_recn-saldo = gs_recn-saldo + ls_bsid-dmbtr.
      ELSE.
        gs_recn-saldo = gs_recn-saldo - ls_bsid-dmbtr.
      ENDIF.
    ENDLOOP.
  ENDIF.
  gs_recn-manst = ld_manst.
  gd_partner = ld_partner.
******************+
** Tickets Vertrag
*  DATA(lo_assistance) = NEW /promos/cl_crm_assistance( ).
*  go_assistance ?= lo_assistance.
*  IF go_assistance IS BOUND.
*    go_assistance->init( ).
*  ENDIF.

* Tickets zentral holen, für den refresh beim Anlegen der Tickets.
  PERFORM get_new_ticket_cn.

*  REFRESH: lt_crm_fl_ticket_list, lt_crm_fl_tree_table.
*  CALL METHOD go_assistance->get_crm_ticket_list
*    EXPORTING
*      iv_partner           = ld_partner
*    IMPORTING
*      et_crm_ticket        = lt_crm_ticket_list "lt_crm_ticket_list
*      et_crm_tree_table    = lt_crm_tree_table "lt_crm_ticket_tree.
*      et_crm_fl_ticket     = lt_crm_fl_ticket_list
*      et_crm_fl_tree_table = lt_crm_fl_tree_table.
*
*
** Vertrags Tickets
*  REFRESH: gt_tickets_bak_cn.
*  LOOP AT lt_crm_ticket_list INTO ls_crm_ticket_list.
*    CLEAR gs_ticket_cn.
*    APPEND ls_crm_ticket_list TO  gt_tickets_bak_cn.
*    MOVE-CORRESPONDING  ls_crm_ticket_list TO gs_ticket_cn.
*    gs_ticket_cn-teilnr = ls_crm_ticket_list-id_txt.
*    LOOP AT ls_crm_ticket_list-t_children INTO ls_children_wd.
*      MOVE-CORRESPONDING ls_children_wd TO gs_ticket_cn.
*      gs_ticket_cn-bezeichnung = ls_children_wd-bezeichnung.
*    ENDLOOP.
*    APPEND gs_ticket_cn TO gt_ticket_cn.
*  ENDLOOP.

** IH-Historie jetzt über neue Logik!
*  go_assistance->ms_crm_conf-add_ih_tickets = abap_true.
** Daten aus Backend holen
*  CALL METHOD go_assistance->get_add_infos_ct
*    EXPORTING
*      iv_partner = ld_partner
*    IMPORTING
*      et_return  = lt_return.
*
** Alle Tickets zur TPs holen
*  REFRESH: lt_crm_fl_ticket_list, lt_crm_fl_tree_table, gt_tickets_bak_ro.
** Tickets aus Klasse holen
*  CALL METHOD go_assistance->get_crm_fl_ticket_list
*    EXPORTING
*      is_ticket_selection  = gd_selection
*      iv_partner           = ld_partner
*    IMPORTING
*      ev_not_refreshed     = lv_not_refreshed
*    CHANGING
*      ct_crm_fl_ticket     = lt_crm_fl_ticket_list
*      ct_crm_fl_tree_table = lt_crm_fl_tree_table.
*
*  LOOP AT lt_crm_fl_ticket_list INTO ls_crm_fl_ticket_list.
*    CLEAR gs_ticket_ro.
*    MOVE-CORRESPONDING ls_crm_fl_ticket_list TO gs_ticket_ro.
*    gs_ticket_ro-teilnr = ls_crm_fl_ticket_list-id_txt.
*    LOOP AT ls_crm_fl_ticket_list-t_children INTO ls_children_wd
*    WHERE objtyp = 'BUS0010'.
*      MOVE-CORRESPONDING ls_children_wd TO gs_ticket_ro.
*      gs_ticket_ro-bezeichnung = ls_children_wd-bezeichnung.
*      gs_ticket_ro-tplnr = ls_children_wd-relation.
*      gs_ticket_ro-pltxt = ls_children_wd-relation_text.
*    ENDLOOP.
*    IF sy-subrc NE 0.
*      CONTINUE.
*    ENDIF.
*    gs_ticket_ro-teilnr = ls_crm_fl_ticket_list-id_txt.
*    APPEND gs_ticket_ro TO gt_ticket_ro.
** BAK Tabelle aufbauen
*    APPEND ls_crm_fl_ticket_list TO gt_tickets_bak_ro.
*  ENDLOOP.
*  IF sy-subrc  = 0.
*    SORT gt_ticket_ro BY statusdatum DESCENDING teilnr DESCENDING.
*  ENDIF.
** Codegruppe
*  LOOP AT go_assistance->mt_all_codes INTO ls_code_all.
*    LOOP AT ls_code_all-codes INTO ls_codes.
*      COLLECT ls_codes INTO lt_codes.
*    ENDLOOP.
** Code zentral übergeben für Texte
*    gt_codes_all[] = lt_codes[].
*  ENDLOOP.

* BAK-Struktur für Änderungen übergeben
  MOVE-CORRESPONDING gs_recn TO gs_bupa_bak.
** Partnerdaten holen
*  CALL FUNCTION '/PROMOS/FM_GET_BUPA_DETAIL'
*    EXPORTING
*      ip_partner   = gs_recn-partner
*    IMPORTING
*      es_bupa_data = gs_bupa_data.
* allgemeine Tabellen holen
* Status
** Domänenwerte holen
*  TRY.
*      lr_elemdescr ?= cl_abap_typedescr=>describe_by_name( '/PROMOS/OPPC_STATUS' ).
*    CATCH cx_root.
*  ENDTRY.
*  gt_status = lr_elemdescr->get_ddic_fixed_values( sy-langu  ).
* Dynpro
  CALL SCREEN 0100.

ENDFUNCTION.
