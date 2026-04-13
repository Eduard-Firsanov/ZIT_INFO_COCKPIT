*&---------------------------------------------------------------------*
*& Include          LZRECN_BP_COCKPITD01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_events
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_events DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
* weitere Verträge
* hotspot
      handle_hotspot_recn
        FOR EVENT link_click OF cl_salv_events_table  "Hotspot
        IMPORTING row column,
* double-click
      handle_double_click_recn
        FOR EVENT double_click OF cl_salv_events_table  "Double-Click
        IMPORTING row column,
* Ticket
      handle_double_click_ticket_cn
        FOR EVENT double_click OF cl_salv_events_table  "Double-Click
        IMPORTING row column,
* Ticket
      handle_double_click_ticket_ro
        FOR EVENT double_click OF cl_salv_events_table  "Double-Click
        IMPORTING row column,
** weiter Partner
*      handle_hotspot_partner
*                  FOR EVENT hotspot_click OF cl_gui_alv_grid
*        IMPORTING e_row_id e_column_id,
** Ansprechpartner
*      handle_hotspot_clerk
*                  FOR EVENT hotspot_click OF cl_gui_alv_grid
*        IMPORTING e_row_id e_column_id,
* Ticket
      handle_hotspot_ticket_cn
        FOR EVENT link_click OF cl_salv_events_table  "Hotspot
        IMPORTING row column,
* Ticket RO
      handle_hotspot_ticket_ro
        FOR EVENT link_click OF cl_salv_events_table  "Hotspot
        IMPORTING row column.
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
CLASS lcl_events IMPLEMENTATION.
* weitere Verträge
  METHOD handle_hotspot_recn.
    DATA: ls_recn LIKE gs_recn.
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
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.                    "handle_hotspot_recn
* Vertragstickets
  METHOD handle_hotspot_ticket_cn.

    CHECK NOT row IS INITIAL.
    CHECK column = 'TEILNR_CHILD'.
    CLEAR column.
    READ TABLE gt_ticket_cn INTO gs_ticket_cn INDEX row.
    IF sy-subrc = 0.
      PERFORM on_double_ticket_cn  USING
                                    column
                                    row.
    ENDIF.

  ENDMETHOD.                    "handle_hotspot_ticket_cn
* Mietobjekt Ticket
  METHOD handle_hotspot_ticket_ro.
    CHECK column = 'TEILNR'.
    CLEAR column.
    CHECK NOT row IS INITIAL.
    READ TABLE gt_ticket_ro INTO gs_ticket_ro INDEX row.
    IF sy-subrc = 0.
      PERFORM on_double_ticket_ro  USING
                                    column
                                    row.
    ENDIF.

  ENDMETHOD.                    "handle_hotspot_ticket_cn
* weitere Verträge
  METHOD handle_double_click_recn.
    CHECK row IS INITIAL.
    READ TABLE gt_recn INTO gs_recn INDEX row.
    IF sy-subrc = 0.
      PERFORM on_double_click_recn  USING gs_recn-intreno
                                    column
                                    row.
    ENDIF.
  ENDMETHOD.                    "handle_hotspot_ticket_cn.
* Ticket Vertrag
  METHOD  handle_double_click_ticket_cn.
    CHECK NOT row IS INITIAL.
    READ TABLE gt_ticket_cn INTO gs_ticket_cn INDEX row.
    IF sy-subrc = 0.
      PERFORM on_double_ticket_cn  USING
                                    column
                                    row.
    ENDIF.
  ENDMETHOD.                    " handle_double_click_ticket_cn
  METHOD  handle_double_click_ticket_ro.
    CHECK NOT row IS INITIAL.
    READ TABLE gt_ticket_ro INTO gs_ticket_ro INDEX row.
    IF sy-subrc = 0.
      PERFORM on_double_ticket_ro  USING
                                    column
                                    row.
    ENDIF.
  ENDMETHOD.                    " handle_double_click_ticket_cn

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
CLASS cl_tree_event_receiver DEFINITION.

  PUBLIC SECTION.
*   double click item
    METHODS handle_double_click
      FOR EVENT node_double_click OF cl_gui_alv_tree_SIMPLE
      IMPORTING index_outtab
                grouplevel.
*   Drag
    METHODS handle_on_drag
      FOR EVENT on_drag OF cl_gui_alv_tree_SIMPLE
      IMPORTING drag_drop_object
                fieldname
                index_outtab
                grouplevel.
  PRIVATE SECTION.
ENDCLASS.
*---------------------------------------------------------------------*
*       CLASS CL_TREE_EVENT_RECEIVER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS cl_tree_event_receiver IMPLEMENTATION.
* handle double_click
  METHOD handle_double_click.
    CHECK NOT index_outtab IS INITIAL.
*   PERFORM DISPLAY_FLIGHTS USING INDEX_OUTTAB GROUPLEVEL.
  ENDMETHOD.
* Drag & Drop
  METHOD handle_on_drag.
    CHECK NOT index_outtab IS INITIAL.
*   PERFORM DISPLAY_FLIGHTS USING INDEX_OUTTAB GROUPLEVEL.
    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code =
                   fcode_entr.
  ENDMETHOD.
ENDCLASS.
*
DATA: tree_event_receiver TYPE REF TO cl_tree_event_receiver.
