PROCESS BEFORE OUTPUT.
  MODULE STATUS_9100.
  loop at gx_kc->t_field_value_scr
                into gs_field_value_scr WITH CONTROL gx_9100
                          cursor gx_9100-current_line.
    module show_add_row.
  endloop.
*
PROCESS AFTER INPUT.
  loop at gx_kc->t_field_value_scr.
    module modify_add_row.
  endloop.
  module user_command_9100.
