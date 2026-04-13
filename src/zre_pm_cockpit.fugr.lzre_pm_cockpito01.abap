*&---------------------------------------------------------------------*
*&  Include  LZRE_PM_COCKPITO01
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TS 'TABS_INFO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: SETS ACTIVE TAB
MODULE tabs_info_active_tab_set OUTPUT.
  tabs_info-activetab = g_tabs_info-pressed_tab.
  CASE g_tabs_info-pressed_tab.
    WHEN c_tabs_info-tab1.
      g_tabs_info-subscreen = '1001'.
    WHEN c_tabs_info-tab2.
      g_tabs_info-subscreen = '1002'.
    WHEN c_tabs_info-tab3.
      g_tabs_info-subscreen = '1003'.
    WHEN c_tabs_info-tab4.
      g_tabs_info-subscreen = '1004'.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_data_1000 OUTPUT.
* Daten holen
  PERFORM get_objekt_partner. " RE-Sammdaten + Partnerdaten
  PERFORM get_belegung_data. "Belegung
  PERFORM get_wartung_data. "Wartung
  PERFORM get_charact. "Ausstattung
  PERFORM get_ro_sgenr. "Gebäude und Mietobjekte
  PERFORM get_notdienst."Notdienste
  PERFORM get_bestellung.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_3600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_3600 OUTPUT.

* ICON setzen
  PERFORM icon_ymb1.
* Immobilienakte
  IF  go_cc_recnbtn IS INITIAL.
    CREATE OBJECT go_cc_recnbtn
      EXPORTING
        container_name = 'ZRECNCTRL'                         "#EC NOTEXT
        lifetime       = cl_gui_custom_container=>lifetime_dynpro.
    CALL METHOD gx_kc->init_recntbr
      EXPORTING
        ix_recnbtn = go_cc_recnbtn.

  ENDIF.
  PERFORM fill_prio_list.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1002 OUTPUT.
* Belegung
*  return.
  IF gt_occupancy[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_occupancy IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_occupancy
      EXPORTING
        container_name = 'CC_OCCUPANCY'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_occupancy
      IMPORTING
        r_salv_table = go_alv_occupancy
      CHANGING
        t_table      = gt_occupancy.
  ENDIF.

  PERFORM set_alv USING go_alv_occupancy.
*  go_alv_occupancy->refresh( refresh_mode =  if_salv_c_refresh=>soft ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1003  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1003 OUTPUT.
* Wartung Gebäude
*  return.
  IF gt_wartung_geb[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_wartung_geb IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_wartung_geb
      EXPORTING
        container_name = 'CC_WARTUNG_GEB'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_wartung_geb
      IMPORTING
        r_salv_table = go_alv_wartung_geb
      CHANGING
        t_table      = gt_wartung_geb.
  ENDIF.

  PERFORM set_alv USING go_alv_wartung_geb.
*  go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1004  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1005 OUTPUT.
* Notdienstfirmen
  IF gt_notdienst[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_notdienst IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_notdienst
      EXPORTING
        container_name = 'CC_NOTDIENST'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_notdienst
      IMPORTING
        r_salv_table = go_alv_notdienst
      CHANGING
        t_table      = gt_notdienst.
  ENDIF.

  PERFORM set_alv USING go_alv_notdienst.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_3610  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_3610 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
  IF 1 = 1.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1005  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1006 OUTPUT.
* Aussttattungsmerkmale Gebäude
  IF gt_charact[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_charact IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_charact
      EXPORTING
        container_name = 'CC_CHARACT'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_charact
      IMPORTING
        r_salv_table = go_alv_charact
      CHANGING
        t_table      = gt_charact.
  ENDIF.

  PERFORM set_alv USING go_alv_charact.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1004  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1004 OUTPUT.
* Wartung Mietobjekt
*  return.
  IF gt_wartung[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_wartung IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_wartung
      EXPORTING
        container_name = 'CC_WARTUNG'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_wartung
      IMPORTING
        r_salv_table = go_alv_wartung
      CHANGING
        t_table      = gt_wartung.
  ENDIF.

  PERFORM set_alv USING go_alv_wartung.
*  go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1007  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1007 OUTPUT.
* Mietobjekt pro Gebäude
*  return.
  IF gt_ro[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_ro IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_ro
      EXPORTING
        container_name = 'CC_RO'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_ro
      IMPORTING
        r_salv_table = go_alv_ro
      CHANGING
        t_table      = gt_ro.
  ENDIF.

  PERFORM set_alv USING go_alv_ro.
*  go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1008  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1008 OUTPUT.
* Kessel angeschlossene Objekte
*  return.
  IF gt_kessel[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_kessel IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_kessel
      EXPORTING
        container_name = 'CC_KESSEL'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_kessel
      IMPORTING
        r_salv_table = go_alv_kessel
      CHANGING
        t_table      = gt_kessel.
  ENDIF.

  PERFORM set_alv USING go_alv_kessel.
*  go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1009  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1009 OUTPUT.
* Aussttattungsmerkmale Mietobjekt
  IF gt_charact_ro[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_charact_ro IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_charact_ro
      EXPORTING
        container_name = 'CC_CHARACT_RO'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_charact_ro
      IMPORTING
        r_salv_table = go_alv_charact_ro
      CHANGING
        t_table      = gt_charact_ro.
  ENDIF.

  PERFORM set_alv USING go_alv_charact_ro.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1011  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1011 OUTPUT.
* Wartung Wirtschaftseinheit
  IF gt_wartung_we[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_wartung_we IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_wartung_we
      EXPORTING
        container_name = 'CC_WARTUNG_WE'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_wartung_we
      IMPORTING
        r_salv_table = go_alv_wartung_we
      CHANGING
        t_table      = gt_wartung_we.
  ENDIF.

  PERFORM set_alv USING go_alv_wartung_we.
*  go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_1012  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_1012 OUTPUT.
* Bestellung Wirtschaftseinheit
  IF gt_bestellung[] IS INITIAL.
    RETURN.
  ENDIF.
  IF NOT go_cc_bestellung IS BOUND.
*   Container 'weitere Verträge'
    CREATE OBJECT go_cc_bestellung
      EXPORTING
        container_name = 'CC_BESTELLUNG'.

*   ALV erzeugen
    CALL METHOD cl_salv_table=>factory
      EXPORTING
        r_container  = go_cc_bestellung
      IMPORTING
        r_salv_table = go_alv_bestellung
      CHANGING
        t_table      = gt_bestellung.
  ENDIF.

  PERFORM set_alv USING go_alv_bestellung.
*  go_alv_wartung->refresh( refresh_mode =  if_salv_c_refresh=>soft ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_5990  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_5990 OUTPUT.
  IF GV_FELD IS NOT INITIAL.
    SET CURSOR FIELD GV_FELD.
  ENDIF.

  perform pbo_5990.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_5000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_5000 OUTPUT.
  PERFORM pbo_5000.
ENDMODULE.
