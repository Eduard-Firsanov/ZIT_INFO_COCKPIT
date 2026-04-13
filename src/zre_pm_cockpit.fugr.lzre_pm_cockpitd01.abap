*----------------------------------------------------------------------*
***INCLUDE LZRE_PM_COCKPITD01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_events
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_events_info DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
* weitere Verträge
* hotspot
      handle_hotspot_recn
        FOR EVENT link_click OF cl_salv_events_table  "Hotspot
        IMPORTING row column.
** double-click
*      handle_double_click_recn
*                  FOR EVENT double_click OF cl_salv_events_table  "Double-Click
*        IMPORTING row column,
** Ticket
*      handle_double_click_ticket_cn
*                  FOR EVENT double_click OF cl_salv_events_table  "Double-Click
*        IMPORTING row column,
** Ticket
*      handle_double_click_ticket_ro
*                  FOR EVENT double_click OF cl_salv_events_table  "Double-Click
*        IMPORTING row column,
** weiter Partner
*      handle_hotspot_partner
*                  FOR EVENT hotspot_click OF cl_gui_alv_grid
*        IMPORTING e_row_id e_column_id,
** Ansprechpartner
*      handle_hotspot_clerk
*                  FOR EVENT hotspot_click OF cl_gui_alv_grid
*        IMPORTING e_row_id e_column_id,
* Ticket
*      handle_hotspot_ticket_cn
*                  FOR EVENT link_click OF cl_salv_events_table  "Hotspot
*        IMPORTING row column,
* Ticket RO
*      handle_hotspot_ticket_ro
*                  FOR EVENT link_click OF cl_salv_events_table  "Hotspot
*        IMPORTING row column.
** Aufträge
*      handle_hotspot_aufk
*                  FOR EVENT hotspot_click OF cl_gui_alv_grid
*        IMPORTING e_row_id e_column_id.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_events_impl
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_events_info IMPLEMENTATION.
* weitere Verträge
  METHOD handle_hotspot_recn.
    DATA: ls_recn  LIKE gs_recn,
          ld_tcode LIKE sy-tcode.

    FIELD-SYMBOLS: <any> TYPE any,
                   <aw>  TYPE any.
*------------------------*
    CHECK NOT row IS INITIAL.
    CASE column.
      WHEN 'PARTNER'.

        CLEAR gs_partner.
        READ TABLE gt_partner INTO gs_partner INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_partner USING gs_partner-partner
                                        column
                                        row.
        ENDIF.
      WHEN 'PARTNER_CLERK'.

        CLEAR gs_clerk.
        READ TABLE gt_clerk INTO gs_clerk  INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_partner_clerk USING gs_clerk-partner_clerk
                                        column
                                        row.
        ENDIF.
      WHEN 'RECNNR'.
        READ TABLE gt_recn INTO ls_recn INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_recn USING ls_recn-intreno
                                        column
                                        row.
        ENDIF.
      WHEN 'IDENTKEY_RO'.
        READ TABLE gt_occupancy INTO gs_occupancy INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_objnr USING gs_occupancy-objnr_ro
                                        column
                                        row.
        ENDIF.
      WHEN 'IDENTKEY_RO_RO'.
        READ TABLE gt_ro INTO gs_ro INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_objnr USING gs_ro-objnr_ro
                                        column
                                        row.
        ENDIF.
      WHEN 'IDENTKEY_CN'.
        READ TABLE gt_occupancy INTO gs_occupancy INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_objnr USING gs_occupancy-objnr_cn
                                        column
                                        row.
        ENDIF.
      WHEN 'IDENTKEY_CN_RO'.
        READ TABLE gt_ro INTO gs_ro INDEX row.
        IF sy-subrc = 0.
          PERFORM on_hotspot_objnr USING gs_ro-objnr_cn
                                        column
                                        row.
        ENDIF.
      WHEN 'IDENTKEY_WE'.

      WHEN 'DOC_BEST'.
* Beleg Bestellung
* Bestellung anzeigen
        READ TABLE gt_bestellung INTO gs_bestellung INDEX row.
        IF sy-subrc = 0.
* AWTYP holen
          ASSIGN COMPONENT 'EBELN' OF STRUCTURE gs_bestellung
                     TO <aw>.
          IF sy-subrc = 0.
            IF  <aw> IS INITIAL.
              RETURN.
            ENDIF.
            SET PARAMETER ID 'BES' FIELD <aw>.
          ELSE.
            RETURN.
          ENDIF.
          ld_tcode = 'ME22N'.
          CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
            EXPORTING
              tcode  = ld_tcode
            EXCEPTIONS
              ok     = 0
              not_ok = 2
              OTHERS = 3.

* Berechtigung nicht vorhanden
          IF sy-subrc <> 0.
            MESSAGE s172(00) WITH ld_tcode.
            CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
* Berechtigung vorhanden
          ELSE.
            CALL TRANSACTION 'ME22N' AND SKIP FIRST SCREEN.
          ENDIF.
        ENDIF.
      WHEN 'DOC_WART'.
* Beleg Bestellung
* Bestellung anzeigen
        READ TABLE gt_wartung_we INTO gs_wartung_we INDEX row.
        IF sy-subrc = 0.
* AWTYP holen
          ASSIGN COMPONENT 'EBELN' OF STRUCTURE gs_wartung_we
                     TO <aw>.
          IF sy-subrc = 0.
            IF  <aw> IS INITIAL.
              RETURN.
            ENDIF.
            SET PARAMETER ID 'BES' FIELD <aw>.
          ELSE.
            RETURN.
          ENDIF.
          ld_tcode = 'ME22N'.
          CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
            EXPORTING
              tcode  = ld_tcode
            EXCEPTIONS
              ok     = 0
              not_ok = 2
              OTHERS = 3.

* Berechtigung nicht vorhanden
          IF sy-subrc <> 0.
            MESSAGE s172(00) WITH ld_tcode.
            CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
* Berechtigung vorhanden
          ELSE.
            CALL TRANSACTION 'ME22N' AND SKIP FIRST SCREEN.
          ENDIF.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.                    "handle_hotspot_recn

** weiter Partner im Vertrag
*  METHOD handle_hotspot_partner.
*    CHECK e_row_id-rowtype IS INITIAL.
*    CLEAR gs_partner.
*    READ TABLE gt_partner INTO gs_partner INDEX e_row_id-index.
*    IF sy-subrc = 0.
**      PERFORM on_hotspot_clerk USING gs_partner-partner
**                                          e_column_id
**                                          e_row_id-index.
*    ENDIF.
*  ENDMETHOD.                    "handle_hotspot_partner
*
** Ansprechpartner
*  METHOD handle_hotspot_clerk.
*    CHECK e_row_id-rowtype IS INITIAL.
*    CLEAR gs_clerk.
*    READ TABLE gt_clerk INTO gs_clerk INDEX e_row_id-index.
*    IF sy-subrc = 0.
**      PERFORM on_hotspot_clerk USING gs_clerk-partner
**                                          e_column_id
**                                          e_row_id-index.
*    ENDIF.
*  ENDMETHOD.                    "handle_hotspot_clerk
*
** Tickets
*  METHOD handle_hotspot_ticket.
*    CHECK e_row_id-rowtype IS INITIAL.
*    CLEAR gs_ticket.
*    READ TABLE gt_ticket INTO gs_ticket INDEX e_row_id-index.
*    IF sy-subrc = 0.
**      PERFORM start_selected_aktion_recnnr USING gs_ticket-teilid
**                                                 e_column_id
**                                                 e_column_id.
*    ENDIF.
*  ENDMETHOD.                    "handle_hotspot_recn
*
*  METHOD handle_hotspot_aufk.
*    CHECK e_row_id-rowtype IS INITIAL.
*    CLEAR gs_aufk.
*    READ TABLE gt_aufk INTO gs_aufk INDEX e_row_id-index.
*    IF sy-subrc = 0.
**      PERFORM start_selected_aktion USING gs_aufk-objnr
**                                          e_column_id
**                                          e_row_id-index.
*    ENDIF.
*  ENDMETHOD.                    "handle_hotspot_auftr

ENDCLASS.
