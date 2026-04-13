PROCESS BEFORE OUTPUT.
* Datenbeschaffung
  MODULE status_1000.
  MODULE get_data_1000.

*&SPWIZARD: PBO FLOW LOGIC FOR TABSTRIP 'TABS_INFO'
* TABSTRIPS aufrufen
  MODULE tabs_info_active_tab_set.
  CALL SUBSCREEN:
       1001_sca INCLUDING g_tabs_info-prog '1001',
       1002_sca INCLUDING g_tabs_info-prog '1002',
       1003_sca INCLUDING g_tabs_info-prog '1003',
       1004_sca INCLUDING g_tabs_info-prog '1004',
       1005_sca INCLUDING g_tabs_info-prog '1005',
       1006_sca INCLUDING g_tabs_info-prog '1006',
       1007_sca INCLUDING g_tabs_info-prog '1007',
       1008_sca INCLUDING g_tabs_info-prog '1008',
       1009_sca INCLUDING g_tabs_info-prog '1009',
       1011_sca INCLUDING g_tabs_info-prog '1011',
       1012_sca INCLUDING g_tabs_info-prog '1012'.
* SUBSCREEN
  CALL SUBSCREEN customer   INCLUDING gx_kc->s_screens-prog_cust
                                    gx_kc->s_screens-scr_cust.
  CALL SUBSCREEN search     INCLUDING gx_kc->s_screens-prog_search
                                    gx_kc->s_screens-scr_search.
  CALL SUBSCREEN partner    INCLUDING gx_kc->s_screens-prog_partner
                                    gx_kc->s_screens-scr_partner.
*  CALL SUBSCREEN zuordnung  INCLUDING gx_kc->s_screens-prog_zuordnung
*                                    gx_kc->s_screens-scr_zuordnung.
  CALL SUBSCREEN zusatz     INCLUDING gx_kc->s_screens-prog_zusatz
                                    gx_kc->s_screens-scr_zusatz.
  CALL SUBSCREEN ltext      INCLUDING gx_kc->s_screens-prog_ltext
                                    gx_kc->s_screens-scr_ltext.


PROCESS AFTER INPUT.
*&SPWIZARD: PAI FLOW LOGIC FOR TABSTRIP 'TABS_INFO'
  CALL SUBSCREEN:
       1001_sca,
       1002_sca,
       1003_sca,
       1004_sca,
       1005_sca,
       1006_sca,
       1007_sca,
       1008_sca,
       1009_sca,
       1011_sca,
       1012_sca.
  MODULE tabs_info_active_tab_get.

  MODULE exit_command_1000 AT EXIT-COMMAND.

  MODULE pre_command_1000.

  CALL SUBSCREEN search.
  CALL SUBSCREEN partner.
*  CALL SUBSCREEN zuordnung.
  CALL SUBSCREEN zusatz.
  CALL SUBSCREEN ltext.
  CALL SUBSCREEN customer.

  MODULE user_command_1000.
* Meldungsausgabe
  MODULE pai_1000.
