PROCESS BEFORE OUTPUT.
  MODULE status_0210.
  MODULE pbo_0210.
*
PROCESS AFTER INPUT.
  MODULE user_command_0200 AT EXIT-COMMAND.
  CHAIN.
    FIELD  gs_dynpro_cn_02-code
    MODULE set_code ON INPUT.
  ENDCHAIN.
  CHAIN.
    FIELD  gs_dynpro_cn_02-prio
    MODULE set_prio_02 ON INPUT.
  ENDCHAIN.
  MODULE pai_0210.

*PROCESS ON VALUE-REQUEST.
*  FIELD gs_dynpro_cn_01-code MODULE set_code.
