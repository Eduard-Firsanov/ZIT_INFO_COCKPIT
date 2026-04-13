FUNCTION-POOL zrecn_bp_cockpit.                  "MESSAGE-ID ..

TABLES: vicncn, v_reexkunnrcn.

* REFX Objekte
DATA:
  go_cn         TYPE REF TO if_recn_contract.
*  go_assistance TYPE REF TO  /promos/cl_crm_assistance.
* Container definieren
DATA:
  go_cc_recn         TYPE REF TO cl_gui_custom_container, "weitere Verträge
  go_cc_partner      TYPE REF TO cl_gui_custom_container, "weitere Partner
  go_cc_clerk        TYPE REF TO cl_gui_custom_container, "Ansprechpartner
  go_cc_ticket_cn    TYPE REF TO cl_gui_custom_container, "Ticket
  go_cc_aufr         TYPE REF TO cl_gui_custom_container, "Aufträge
  go_cc_ticket_ro    TYPE REF TO cl_gui_custom_container, "Ticket
  go_cc_condition    TYPE REF TO cl_gui_custom_container, "Kondition
* go_cc_condition2   TYPE REF TO cl_gui_custom_container, "Kondition Popup
  go_cc_area         TYPE REF TO cl_gui_custom_container, "Flächen
*  go_cc_area2        TYPE REF TO cl_gui_custom_container, "Flächen Popup
  go_cc_notice_01    TYPE REF TO cl_gui_custom_container, "Notizen anlegen
  go_cc_notice_02    TYPE REF TO cl_gui_custom_container, "Notizen ändern
  go_cc_notice_ro_01 TYPE REF TO cl_gui_custom_container, "Notizen RO
  go_cc_notice_ro_02 TYPE REF TO cl_gui_custom_container. "Notizen RO

DATA:
  gx_tpbtn TYPE REF TO cl_gui_custom_container,
  gx_kc    TYPE REF TO /datrain/kc_cl_main_2008.
* ALV definieren
DATA:
  go_alv_recn      TYPE REF TO cl_salv_table,
  go_alv_partner   TYPE REF TO cl_salv_table,
  go_alv_clerk     TYPE REF TO cl_salv_table,
  go_alv_ticket_cn TYPE REF TO cl_salv_table,
  go_alv_ticket_ro TYPE REF TO cl_salv_table,
  go_alv_aufr      TYPE REF TO cl_salv_table,
  go_alv_cond      TYPE REF TO cl_salv_table,
* go_alv_cond2     TYPE REF TO cl_salv_table,
  go_alv_area      TYPE REF TO cl_salv_table.
* go_alv_area2     TYPE REF TO cl_salv_table.

* Notiz
DATA:
  go_dock_notice_01    TYPE REF TO cl_gui_textedit,
  go_dock_notice_02    TYPE REF TO cl_gui_textedit,
  go_dock_notice_ro_01 TYPE REF TO cl_gui_textedit,
  go_dock_notice_ro_02 TYPE REF TO cl_gui_textedit.
*ALV Strukturen
DATA: gt_fcat_recn    TYPE lvc_t_fcat,
      gt_fcat_partner TYPE lvc_t_fcat,
      gt_fcat_clerk   TYPE lvc_t_fcat,
      gt_fcat_ticket  TYPE lvc_t_fcat,
      gt_fcat_aufk    TYPE lvc_t_fcat.

* Hilffelder
DATA: gd_ok             TYPE sy-ucomm,
      gd_tabix          TYPE sy-tabix,
      gd_show_partner   TYPE c VALUE abap_true,
      gd_show_ticket_cn TYPE c VALUE abap_true,
      gd_show_ticket_ro TYPE c VALUE abap_false,
      gd_dyn_cn         TYPE sy-dynnr,
      gd_dyn_ticket_cn  TYPE sy-dynnr,
      gd_dyn_ticket_ro  TYPE sy-dynnr,
      gd_row            TYPE i,
      gs_message        TYPE recamsg.

*=======================================================================
DATA:         "gui information (buffered for pbo processing only)
*=======================================================================
  BEGIN OF gs_gui,
    subscreen_condition TYPE recascreen, "conditions
  END OF gs_gui.

* Kommunikation
TYPES: BEGIN OF ty_bupa,
         phone1  TYPE ad_tlnmbr,
         mobile1 TYPE ad_tlnmbr,
         e_mail  TYPE ad_smtpadr,
         birthdt TYPE  bu_birthdt,
       END OF ty_bupa.
* BAK-Stuktur Änderungen
DATA: gs_bupa_bak TYPE ty_bupa.
* allgemeine Strukturen
TYPES: BEGIN OF tt_recn,
         intreno                 TYPE recaintreno,
         bukrs                   TYPE bukrs,
         recnnr                  TYPE recnnumber,
         recntype                TYPE recncontracttype,
         xmbez                   TYPE xmvartm,
         xmbez_spez              TYPE xmvartm,
         recnbeg                 TYPE recncnbeg,
         recnendabs(10),   "TYPE recncnendabs,
         ntcalculated_nehmer(10),   " TYPE retmntcalculated,
         ntcalculated_geber(10),   "  TYPE retmntcalculated,
         lfz_jahre               TYPE gjahr,
         recntxt                 TYPE recntxt,
         swenr                   TYPE  swenr,
         sgenr                   TYPE  sgenr,
         smenr                   TYPE  smenr,
         partner                 TYPE  bu_partner,
         name_first              TYPE bu_namep_f,
         name_last               TYPE  bu_namep_l,
         xpartner                TYPE  rebpxpartner,
         city1                   TYPE ad_city1,
         post_code               TYPE ad_pstcd1,
         street                  TYPE ad_street,
         house_num1              TYPE ad_hsnm1,
         birthdt                 TYPE  bu_birthdt,
         avail_from              TYPE numc2,
         avail_to                TYPE numc2,
         phone1                  TYPE ad_tlnmbr,
         mobile1                 TYPE  ad_tlnmbr,
         e_mail                  TYPE  ad_smtpadr,
         last_notice             TYPE date,
         grundmiete              TYPE  dmbtr,
         beko_vz                 TYPE  dmbtr,
         heiko_vz                TYPE  dmbtr,
         sonst_kond              TYPE  dmbtr,
         gesamtmiete             TYPE  dmbtr,
         saldo                   TYPE  vvsaldo,
         saldo_debitor           TYPE  vvsaldo,
         mahns                   TYPE  faehw_mhnk,
         mansp                   TYPE reradunnblock,
         zlsch                   TYPE rerapymtmeth,
         blz_bp                  TYPE  bankk,
         blz_mv                  TYPE  bankk,
         manst                   TYPE mahns,
         mansp_t                 TYPE text1_040t,
         klagen                  TYPE recabool,
         recnnr_kaut             TYPE  recnnr,
         debitor                 TYPE  kunnr,
         identkey                TYPE  recaidentkey,
         address                 TYPE  char128,
         xstockl                 TYPE  xgmbez,
         ybaujahr                TYPE  vvybaujahr,
         xmlgesch                TYPE  xmlgesch,
         finanzierung            TYPE char40,
         measvalue               TYPE rebdmeasvalue,
         anz_zimmer              TYPE weprz,
         snunr                   TYPE rebdusagetype,
         iban                    TYPE iban,
         bic                     TYPE swift,
         sttxt_int               TYPE co_sttxt,
         objnr_be                TYPE recaobjnr,
         objnr_bu                TYPE recaobjnr,
         objnr_pr                TYPE recaobjnr,
         objnr_ro                TYPE recaobjnr,
*         ih_stopp                TYPE zih_stopp,
*         ih_kommentar            TYPE zkommentar,
*         zreca_status_txt        TYPE zreca_status_txt,
         status                  TYPE j_txt30,
       END OF tt_recn.
* Data aufbauen
DATA:
  gt_recn  TYPE TABLE OF tt_recn,
  gs_recn  LIKE LINE OF gt_recn,
* gt_vicncn TYPE TABLE OF vicncn,
  gt_tiv2f TYPE TABLE OF tiv2f.
* weitere Verträge
DATA:
  BEGIN OF gs_vicncn ,
    bukrs	     TYPE bukrs,
    recnnr     TYPE   recnnumber,
    xmbez      TYPE xmvartm,
    recntxt    TYPE recntxt,
    recnbeg    TYPE recncnbeg,
    recnendabs TYPE recncnendabs,
  END OF gs_vicncn,
  gt_vicncn LIKE TABLE OF gs_vicncn.

* Dynpro Pushbutton
DATA:
  gd_edit_birth      TYPE recabool,
  gd_edit_mobil      TYPE recabool,
  gd_edit_tel        TYPE recabool,
  gd_edit_email      TYPE recabool,
  gd_edit_avail      TYPE recabool,
  gd_berecht_chgkom  TYPE abap_bool, "SAP_ALL oder ZBP_CHGKOM/ACTVT/02
  gd_berecht_checked TYPE abap_bool.

* tickets aus der Klasse
DATA:
*  gt_tickets_bak_cn TYPE /promos/tt_crm_ticket_wd,
*  gt_tickets_bak_ro TYPE /promos/tt_crm_ticket_wd,
*      gd_selection      TYPE /promos/s_ct_ticket_selection,
  gd_partner       TYPE bu_partner,
  gd_ticket_ro_new TYPE recabool.

*DATA: gt_codes     TYPE TABLE OF /promos/s_codes_wd,
*      gt_codes_all TYPE TABLE OF /promos/s_codes_wd.
* verkürzte Ticketstruktur für Dynpro
DATA: BEGIN OF gs_ticket_cn,
*        teilnr_child TYPE   /promos/oppc_teilnr,
*        status       TYPE /promos/oppc_status,
*        relation     TYPE /promos/crm_relation_value,
*        statusdatum  TYPE /promos/e_crm_oppc_statusdatum,
*        bezeichnung  TYPE /promos/oppc_teilbez,
*        notiz        TYPE /promos/oppc_notiz,
*        loeschkz     TYPE /promos/oppc_loeschkz,
*        loeschgrund  TYPE /promos/oppc_loeschgrund,
        codegruppe TYPE qcodegrp,
        code       TYPE qcode,
*        rerf         TYPE   /promos/oppc_rerf,
*        derf         TYPE   /promos/oppc_derf,
*        teilnr_main  TYPE   /promos/oppc_teilnr,
        id         TYPE  char2, "/promos/e_crm_teilguid,
      END OF  gs_ticket_cn,
      gt_ticket_cn LIKE TABLE  OF gs_ticket_cn.

* Mietobjekt (technischer Platz)
DATA: BEGIN OF gs_ticket_ro,
*        teilnr      TYPE   /promos/oppc_teilnr,
*        status      TYPE /promos/oppc_status,
*        statusdatum TYPE /promos/e_crm_oppc_statusdatum,
*        relation    TYPE /promos/crm_relation_value,
        tplnr TYPE tplnr,
        pltxt TYPE pltxt,
*        bezeichnung TYPE /promos/oppc_teilbez,
*        notiz       TYPE /promos/oppc_notiz,
*        loeschkz    TYPE /promos/oppc_loeschkz,
*        loeschgrund TYPE /promos/oppc_loeschgrund,
*        rerf        TYPE   /promos/oppc_rerf,
*        derf        TYPE   /promos/oppc_derf,
        id    TYPE  char2, "/promos/e_crm_teilguid,
      END OF  gs_ticket_ro,
      gt_ticket_ro LIKE TABLE OF gs_ticket_ro.

* Aufträge
DATA: gs_aufk TYPE aufk,
      gt_aufk LIKE TABLE OF gs_aufk.
* Partner
DATA:
  gt_partner    TYPE          bapi_re_t_partner_int,
  gs_partner    LIKE LINE OF  gt_partner,
  gt_clerk_bapi TYPE          bapi_re_t_partner_int,
  gs_clerk_bapi LIKE LINE OF  gt_clerk_bapi,
  gs_contract   TYPE bapi_re_contract_int.
*  gs_bupa_data  TYPE  /promos/s_bupa_data.

* Mitarbeiter
DATA:
  BEGIN OF gs_clerk,
    partner_clerk TYPE  bu_partner,
    xname         TYPE  rebpxname,
    telefon       TYPE ad_tlnmbr1,
    xpartner      TYPE  rebpxpartner,
    validfrom     TYPE  rebpvalidfrom,
    validto       TYPE  rebpvalidto,
    role          TYPE  rebprole,
  END OF gs_clerk,
  gt_clerk LIKE TABLE OF gs_clerk,
* Partner
  BEGIN OF gs_partner_cn,
    partner   TYPE  bu_partner,
    role      TYPE  rebprole,
    xname     TYPE  rebpxname,
    xpartner  TYPE  rebpxpartner,
    validfrom TYPE  rebpvalidfrom,
    validto   TYPE  rebpvalidto,
  END OF gs_partner_cn,
  gt_partner_cn LIKE TABLE OF gs_partner_cn.
* Konditionen
DATA:
  BEGIN OF gs_cond,
    condtype         TYPE  recdcondtype,
    condvalidfrom    TYPE  recdvalidfrom,
    xcondition       TYPE recdxcondition,
    unitprice        TYPE recdunitprice,
    objidentcalc     TYPE rebdobjectidentcalc,
    condvalidto      TYPE  recdvalidto,
    xmcondpurposeext TYPE recdxmcondpurposeext,
    xtaxgroup        TYPE reraxmtaxgroup,
    t_color          TYPE lvc_t_scol,
  END OF gs_cond,
  gt_cond LIKE TABLE OF gs_cond.

* Flächen
DATA:
  BEGIN OF gs_area,
    meas      TYPE  rebdmeas,
    validfrom TYPE  rebdmeasvalidfrom,
    validto   TYPE rebdmeasvalidto,
    measvalue TYPE rebdmeasvalue,
    xmmeas    TYPE rebdxmmeas,
    measunit  TYPE rebdmeasunit,
  END OF gs_area,
  gt_area LIKE TABLE OF gs_area.


* Hauptstrukutur
DATA: BEGIN OF gs_vn,
        vn          LIKE gs_recn,
        t_recn      LIKE TABLE OF gs_recn,
        t_partner   LIKE TABLE OF gs_partner,
        t_clerk     LIKE TABLE OF gs_clerk,
        t_ticket_cn LIKE TABLE OF gs_ticket_cn,
        t_ticket_ro LIKE TABLE OF gs_ticket_ro,
        t_aufk      LIKE TABLE OF gs_aufk,
      END OF gs_vn.
* Ticket anlegen
*DATA:
*  gs_ticket_cn_01 TYPE /promos/s_ct_data_wd,
*  gt_urspr        TYPE /promos/tt_key_value,
*  gt_prio         TYPE /promos/tt_ct_prios,
*  gt_status       TYPE ddfixvalues,
*  gs_status       TYPE ddfixvalue,
*  gd_teilnr       TYPE /promos/oppc_teilnr.


DATA: BEGIN OF gs_dynpro_cn_01,
        urspr             TYPE char2, "/promos/e_crm_urspr,
        initiator(20),
        recnnr            TYPE recnnr,
        prio(20),"        TYPE priok,
        strmn(10),"      TYPE strmn),
        ltrmn(10),"              TYPE ltrmn,
        code(13),
        code_text(60),
        contact_name      TYPE rebpxname,
        contact_telnumber TYPE ad_telnrlg,
        kurztext          TYPE qtxt_code,
        text_add          TYPE string,
        status(2),
        status_text(20),
        recntxt           TYPE  recntxt,
*        teilnr            TYPE   /promos/oppc_teilnr,
      END OF  gs_dynpro_cn_01.

DATA: gs_dynpro_cn_02 LIKE gs_dynpro_cn_01.

DATA: BEGIN OF gs_dynpro_ro_01,
        urspr             TYPE char2, "/promos/e_crm_urspr,
        initiator(20),
        tplnr             TYPE tplnr,
        pltxt             TYPE pltxt,
        prio(20),"        TYPE priok,
        strmn(10),"      TYPE strmn),
        ltrmn(10),"              TYPE ltrmn,
        code(13),
        code_text(60),
        contact_name      TYPE rebpxname,
        contact_telnumber TYPE ad_telnrlg,
        kurztext          TYPE qtxt_code,
        text_add          TYPE string,
        status(2),
        status_text(20),
*        teilnr            TYPE   /promos/oppc_teilnr,
*        teilnr_master     TYPE   /promos/oppc_teilnr,
      END OF  gs_dynpro_ro_01.
DATA: gs_dynpro_ro_02 LIKE gs_dynpro_ro_01.
*------------------------------------------*
* Tree Codegrupee
*------------------------------------------*
* internal tables
DATA:
  gt_scarr        TYPE TABLE OF char01, "SCARR WITH HEADER LINE,
  gt_codes        TYPE TABLE OF char01, "/PROMOS/S_CODES WITH HEADER LINE,
*      GT_SFLIGHT      TYPE TABLE OF SFLIGHT WITH HEADER LINE,
*      GT_SAPLANE      TYPE TABLE OF SAPLANE WITH HEADER LINE,
  gt_header       TYPE TABLE OF slis_listheader WITH HEADER LINE,
  gt_fieldcat_lvc TYPE lvc_t_fcat WITH HEADER LINE,
  gt_sort         TYPE lvc_t_sort, "Sortiertabelle
  gt_sort_grid    TYPE lvc_t_sort WITH HEADER LINE,
  gt_row_table    TYPE lvc_t_row WITH HEADER LINE.  " selected rows
* global fields
DATA: controls_created,
      dragdrop_tree      TYPE REF TO cl_dragdrop,
      dragdrop_alv       TYPE REF TO cl_dragdrop,
      flg_new,
      grid               TYPE REF TO cl_gui_alv_grid,
      gs_layout_alv      TYPE lvc_s_layo,
      gs_layout_tree     TYPE lvc_s_layo,
      gs_toolbar         TYPE stb_button,
      g_custom_container TYPE REF TO cl_gui_custom_container,
      g_container_object TYPE REF TO cl_gui_docking_container,
      g_dropeffect       TYPE i,
      g_handle_tree      TYPE i,
      g_handle_alv       TYPE i,
      g_repid            LIKE sy-repid,
      ok_code            LIKE sy-ucomm,
      save_ok_code       LIKE sy-ucomm,
      selected           VALUE 'X',
      tree1              TYPE REF TO cl_gui_alv_tree_simple.
* constants
CONSTANTS: fcode_back  LIKE sy-ucomm VALUE 'BACK',
           fcode_disp  LIKE sy-ucomm VALUE 'DISP',
           fcode_end   LIKE sy-ucomm VALUE 'END',
           fcode_entr  LIKE sy-ucomm VALUE 'ENTR',
           fcode_esc   LIKE sy-ucomm VALUE 'ESC',
           fcode_plane LIKE sy-ucomm VALUE 'FLIGHT'.

* lokale Klassen
INCLUDE lzrecn_bp_cockpitd01.
