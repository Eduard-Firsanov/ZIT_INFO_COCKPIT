PROCESS BEFORE OUTPUT.

CALL SUBSCREEN suchliste     INCLUDING '/DATRAIN/SAPLKC_MAIN_2008'
                                   gx_kc->s_screens-scr_suchliste.



PROCESS AFTER INPUT.

  CALL SUBSCREEN suchliste.

* MODULE USER_COMMAND_7000.
