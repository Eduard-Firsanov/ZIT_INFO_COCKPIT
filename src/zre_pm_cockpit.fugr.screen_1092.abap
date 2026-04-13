
PROCESS BEFORE OUTPUT.
  MODULE status_1090.
  MODULE pbo_1090.

  CALL SUBSCREEN customer   INCLUDING gx_kc->s_screens-prog_cust
                                    gx_kc->s_screens-scr_cust.
  CALL SUBSCREEN search     INCLUDING gx_kc->s_screens-prog_search
                                    gx_kc->s_screens-scr_search.
  CALL SUBSCREEN partner    INCLUDING gx_kc->s_screens-prog_partner
                                    gx_kc->s_screens-scr_partner.
  CALL SUBSCREEN zuordnung  INCLUDING gx_kc->s_screens-prog_zuordnung
                                    gx_kc->s_screens-scr_zuordnung.
  CALL SUBSCREEN zusatz     INCLUDING gx_kc->s_screens-prog_zusatz
                                    gx_kc->s_screens-scr_zusatz.
  CALL SUBSCREEN ltext      INCLUDING gx_kc->s_screens-prog_ltext
                                    gx_kc->s_screens-scr_ltext.


PROCESS AFTER INPUT.

  MODULE exit_command_1000 AT EXIT-COMMAND.

  MODULE pre_command_1092.
  MODULE pre_command_1000.

  CALL SUBSCREEN search.
  CALL SUBSCREEN partner.
  CALL SUBSCREEN zuordnung.
  CALL SUBSCREEN zusatz.
  CALL SUBSCREEN ltext.
  CALL SUBSCREEN customer.

  MODULE user_command_1000.

  MODULE pai_1010.
