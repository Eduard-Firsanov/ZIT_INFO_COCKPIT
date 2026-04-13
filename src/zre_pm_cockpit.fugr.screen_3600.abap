
PROCESS BEFORE OUTPUT.
  MODULE status_3600.
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
  MODULE user_command_3000.
  MODULE user_command_3600.

PROCESS ON VALUE-REQUEST.
  FIELD gx_kc->s_partner-recnnr MODULE f4_recncn.
