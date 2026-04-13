PROCESS BEFORE OUTPUT.
  MODULE status_0200.
  MODULE pbo_0200.
*
PROCESS AFTER INPUT.
  MODULE user_command_0200 AT EXIT-COMMAND.
  CHAIN.
    FIELD  gs_dynpro_cn_01-code
    MODULE set_code ON INPUT.
  ENDCHAIN.
  CHAIN.
    FIELD: gs_dynpro_cn_01-prio
    MODULE set_prio_01 ON INPUT.
  ENDCHAIN.
  MODULE pai_0200.

*PROCESS ON VALUE-REQUEST.
*  FIELD gs_dynpro_cn_01-code MODULE set_code.
