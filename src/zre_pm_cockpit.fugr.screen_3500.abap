
PROCESS BEFORE OUTPUT.
  MODULE status_3000.
  CALL SUBSCREEN partner_cust   INCLUDING
                  gx_kc->s_screens-prog_partner_cust
                  gx_kc->s_screens-scr_partner_cust
                .
*
PROCESS AFTER INPUT.
*  CHAIN.
*    FIELD gx_kc->s_partner-bukrs.
*    FIELD gx_kc->s_partner-recnnr.
*    MODULE new_recnnr ON CHAIN-REQUEST.
*  ENDCHAIN.
  CALL SUBSCREEN partner_cust.
  MODULE user_command_3000.

*PROCESS ON VALUE-REQUEST.
*  FIELD gx_kc->s_partner-recnnr MODULE f4_recncn.
