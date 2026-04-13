*&---------------------------------------------------------------------*
*&  Include  LZRE_PM_COCKPITI01
*&---------------------------------------------------------------------*

*&SPWIZARD: INPUT MODULE FOR TS 'TABS_INFO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GETS ACTIVE TAB
MODULE TABS_INFO_ACTIVE_TAB_GET INPUT.
  GV_OK_CODE = SY-UCOMM.
  CASE GV_OK_CODE.
    WHEN C_TABS_INFO-TAB1.
      G_TABS_INFO-PRESSED_TAB = C_TABS_INFO-TAB1.
    WHEN C_TABS_INFO-TAB2.
      G_TABS_INFO-PRESSED_TAB = C_TABS_INFO-TAB2.
    WHEN C_TABS_INFO-TAB3.
      G_TABS_INFO-PRESSED_TAB = C_TABS_INFO-TAB3.
    WHEN C_TABS_INFO-TAB4.
      G_TABS_INFO-PRESSED_TAB = C_TABS_INFO-TAB4.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_5990  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PAI_5990 INPUT.
  PERFORM PAI_5990.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_INFO_CONTEXT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE GET_INFO_CONTEXT INPUT.
  PERFORM GET_INFO_CONTEXT.
ENDMODULE.
