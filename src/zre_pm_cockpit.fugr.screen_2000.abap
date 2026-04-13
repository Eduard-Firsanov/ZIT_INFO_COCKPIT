
PROCESS BEFORE OUTPUT.
  MODULE status_2000.

  CALL SUBSCREEN search_cust   INCLUDING
                  gx_kc->s_screens-prog_search_cust
                  gx_kc->s_screens-scr_search_cust
                .

*
PROCESS AFTER INPUT.
  CALL SUBSCREEN search_cust.
  CHAIN.
    FIELD gx_kc->s_search_partner-name_last.
    FIELD gx_kc->s_search_partner-name_first.
    FIELD gx_kc->s_search_partner-street.
    FIELD gx_kc->s_search_partner-house_num1.
    FIELD gx_kc->s_search_partner-post_code1.
    FIELD gx_kc->s_search_partner-city1.
    MODULE clear_partner ON CHAIN-REQUEST.
  ENDCHAIN.
  MODULE user_command_2000.
