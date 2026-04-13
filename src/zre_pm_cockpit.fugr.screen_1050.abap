PROCESS BEFORE OUTPUT.
  module pbo_wb_manager.
  MODULE STATUS_1000.

  CALL SUBSCREEN customer   INCLUDING gx_kc->s_screens-prog_CUST
                                    gx_kc->s_screens-scr_CUST.
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

  module exit_command_1000 AT EXIT-COMMAND.
  module pai_wb_manager.
  module pre_command_1000.

  CALL SUBSCREEN search.
  CALL SUBSCREEN partner.
  CALL SUBSCREEN zuordnung.
  CALL SUBSCREEN zusatz.
  CALL SUBSCREEN ltext.
  CALL SUBSCREEN customer.

  MODULE USER_COMMAND_1000.
  MODULE PAI_1000.
