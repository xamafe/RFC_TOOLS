INTERFACE zif_async
  PUBLIC .
  CONSTANTS mc_no_system_running TYPE I VALUE 0.
  CLASS-DATA running_tasks TYPE i READ-ONLY .
  CLASS-METHODS start_all_async.
  methods free.
  METHODS is_running RETURNING VALUE(r_is_running) TYPE abap_bool.
  METHODS START_ASYNC_call.
  METHODS: get_count_rfc_retry RETURNING value(r_result) TYPE i,
           set_count_rfc_retry IMPORTING i_count_rfc_retry TYPE i,
           set_is_running IMPORTING i_is_running TYPE abap_bool,
           set_wait_secs_until_retry IMPORTING i_wait_secs_until_retry TYPE i,
           get_wait_secs_until_retry RETURNING value(r_result) TYPE i,
           get_is_running RETURNING value(r_result) TYPE abap_bool,
           get_taskname RETURNING value(r_result) TYPE ze_taskname,
           set_taskname IMPORTING i_taskname TYPE ze_taskname.
  EVENTS function_called
      EXPORTING
        VALUE(ev_message) TYPE bapi_msg
        VALUE(ev_subrc) TYPE sy-subrc.
  EVENTS function_received
      EXPORTING
          VALUE(ev_message) TYPE bapi_msg
          VALUE(ev_subrc) TYPE sy-subrc.
  EVENTS rfc_insufficient_ressources
    EXPORTING
      VALUE(ev_act_retries) TYPE i .


ENDINTERFACE.
