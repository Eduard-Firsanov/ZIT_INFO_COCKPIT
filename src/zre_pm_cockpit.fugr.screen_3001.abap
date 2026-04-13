
PROCESS BEFORE OUTPUT.
  MODULE status_3000.
  CALL SUBSCREEN PARTNER_CUST   INCLUDING
                  gx_kc->s_screens-prog_PARTNER_CUST
                  gx_kc->s_screens-SCR_PARTNER_CUST
                .
*
PROCESS AFTER INPUT.
  CHAIN.
    FIELD gx_kc->s_partner-bukrs.
    FIELD gx_kc->s_partner-recnnr.
    MODULE new_recnnr ON CHAIN-REQUEST.
  ENDCHAIN.
  CHAIN.
    FIELD gx_kc->s_partner-partner.
    MODULE new_partner ON CHAIN-REQUEST.
  ENDCHAIN.
  CALL SUBSCREEN PARTNER_CUST.
  MODULE user_command_3000.

PROCESS ON VALUE-REQUEST.
  FIELD gx_kc->s_partner-recnnr MODULE f4_recncn.
