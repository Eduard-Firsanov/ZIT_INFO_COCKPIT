PROCESS BEFORE OUTPUT.
  MODULE STATUS_2000.

  CALL SUBSCREEN SEARCH_CUST   INCLUDING
                  gx_kc->s_screens-prog_SEARCH_CUST
                  gx_kc->s_screens-SCR_SEARCH_CUST
                .
  module fill_dd_box_2000.
*
PROCESS AFTER INPUT.
  CALL SUBSCREEN SEARCH_CUST.
  chain.
    field gx_kc->s_search_partner-NAME_LAST.
    field gx_kc->s_search_partner-NAME_FIRST.
    field gx_kc->s_search_partner-STREET.
    field gx_kc->s_search_partner-HOUSE_NUM1.
    field gx_kc->s_search_partner-POST_CODE1.
    field gx_kc->s_search_partner-CITY1.
    module clear_partner on chain-request.
  endchain.
  MODULE USER_COMMAND_2000.
