PROCESS BEFORE OUTPUT.
  MODULE status_0300.
  MODULE pbo_0300.
*
PROCESS AFTER INPUT.
  MODULE user_command_0200 AT EXIT-COMMAND.
  CHAIN.
    FIELD  gs_dynpro_ro_01-code
    MODULE set_code_0310 ON INPUT.
  ENDCHAIN.
  CHAIN.
    FIELD: gs_dynpro_ro_01-prio
    MODULE set_prio_01_ro ON INPUT.
  ENDCHAIN.
  CHAIN.
    FIELD: gs_dynpro_ro_01-tplnr
    MODULE set_tplnr_ro_01 ON INPUT.
  ENDCHAIN.
  MODULE pai_0300.

*PROCESS ON VALUE-REQUEST.
*  FIELD gs_dynpro_cn_01-code MODULE set_code.
