
PROCESS BEFORE OUTPUT.

  MODULE status_9501.

  CALL SUBSCREEN search     INCLUDING gx_kc->s_screens-prog_search
                                    gx_kc->s_screens-scr_search.
  CALL SUBSCREEN partner    INCLUDING gx_kc->s_screens-prog_partner
                                    gx_kc->s_screens-scr_partner.

PROCESS AFTER INPUT.
  MODULE exit_9501 AT EXIT-COMMAND.

  CALL SUBSCREEN search.
  CALL SUBSCREEN partner.

  MODULE user_command_9501.
