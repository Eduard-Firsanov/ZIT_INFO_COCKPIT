
PROCESS BEFORE OUTPUT.
  MODULE status_5000.

*
PROCESS AFTER INPUT.
  FIELD gx_kc->s_zusatz-tplnr MODULE read_tpname ON REQUEST.

  CHAIN.
    FIELD gx_kc->s_zusatz-mngrp.
    FIELD gx_kc->s_zusatz-mncod.
  ENDCHAIN.
  CHAIN.
    FIELD gx_kc->s_zusatz-idnrk.
    FIELD gx_kc->s_zusatz-maktx.
    MODULE new_idnrk ON CHAIN-REQUEST.
  ENDCHAIN.

  MODULE user_command_5000.

PROCESS ON VALUE-REQUEST.
  FIELD gx_kc->s_zusatz-mngrp MODULE f4_code.
  FIELD gx_kc->s_zusatz-mncod MODULE f4_code.
