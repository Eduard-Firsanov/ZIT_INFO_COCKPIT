
PROCESS BEFORE OUTPUT.
  MODULE status_5000.
  CALL SUBSCREEN zusatz_cust   INCLUDING
                  gx_kc->s_screens-prog_zusatz_cust
                  gx_kc->s_screens-scr_zusatz_cust.

*
PROCESS AFTER INPUT.
  FIELD gx_kc->s_zusatz-tplnr MODULE read_tpname ON REQUEST.

  CHAIN.
    FIELD gx_kc->s_zusatz-mngrp.
    FIELD gx_kc->s_zusatz-mncod.
    MODULE new_code ON CHAIN-REQUEST.
  ENDCHAIN.

  CHAIN.
    FIELD gx_kc->s_zusatz-idnrk.
    FIELD gx_kc->s_zusatz-maktx.
    MODULE new_idnrk ON CHAIN-REQUEST.
  ENDCHAIN.

  CALL SUBSCREEN zusatz_cust.

  MODULE user_command_5000.
*PROCESS ON VALUE-REQUEST.
*  FIELD gX_KC->s_zusatz-mngrp MODULE f4_code.
*  FIELD gX_KC->s_zusatz-mncod MODULE f4_code.
