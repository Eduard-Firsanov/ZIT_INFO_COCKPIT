
PROCESS BEFORE OUTPUT.
  MODULE status_4000.
  CALL SUBSCREEN zuordnung_cust   INCLUDING
                  gx_kc->s_screens-prog_zuordnung_cust
                  gx_kc->s_screens-scr_zuordnung_cust
                .
*
PROCESS AFTER INPUT.
  CALL SUBSCREEN zuordnung_cust.
  MODULE user_command_4000.
