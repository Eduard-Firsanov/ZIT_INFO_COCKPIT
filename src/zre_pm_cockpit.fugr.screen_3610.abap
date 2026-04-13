
PROCESS BEFORE OUTPUT.
  MODULE status_3610.
*&SPWIZARD: PBO FLOW LOGIC FOR TABSTRIP 'TABS_INFO'
* TABSTRIPS aufrufen
  MODULE tabs_info_active_tab_set.
  CALL SUBSCREEN:
       1001_sca INCLUDING g_tabs_info-prog '1001',
       1002_sca INCLUDING g_tabs_info-prog '1002',
       1003_sca INCLUDING g_tabs_info-prog '1003',
       1004_sca INCLUDING g_tabs_info-prog '1004'.
*
PROCESS AFTER INPUT.
*&SPWIZARD: PAI FLOW LOGIC FOR TABSTRIP 'TABS_INFO'
  CALL SUBSCREEN:
       1001_sca,
       1002_sca,
       1003_sca,
       1004_sca.
  MODULE tabs_info_active_tab_get.

  MODULE exit_command_1000 AT EXIT-COMMAND.

  MODULE pre_command_1000.
