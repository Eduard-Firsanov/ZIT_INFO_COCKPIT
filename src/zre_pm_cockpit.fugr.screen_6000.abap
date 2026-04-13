PROCESS BEFORE OUTPUT.
  module init_edit_control.
  MODULE STATUS_6000.
*
  CALL SUBSCREEN LTEXT_CUST   INCLUDING
                  gx_kc->s_screens-prog_LTEXT_CUST
                  gx_kc->s_screens-SCR_LTEXT_CUST
                .

PROCESS AFTER INPUT.
  CALL SUBSCREEN LTEXT_CUST.
  MODULE USER_COMMAND_6000.
