INTERFACE zif_async
  PUBLIC .
  CONSTANTS mc_no_system_running TYPE i VALUE 0.
  CLASS-DATA running_tasks TYPE i READ-ONLY .
  CLASS-METHODS start_all_async.
  METHODS free.
  METHODS is_running RETURNING VALUE(r_is_running) TYPE abap_bool.
  METHODS start_async_call.
  METHODS: get_count_rfc_retry RETURNING VALUE(r_result) TYPE i,
    set_count_rfc_retry IMPORTING i_count_rfc_retry TYPE i,
    set_is_running IMPORTING i_is_running TYPE abap_bool,
    set_wait_secs_until_retry IMPORTING i_wait_secs_until_retry TYPE i,
    get_wait_secs_until_retry RETURNING VALUE(r_result) TYPE i,
    get_is_running RETURNING VALUE(r_result) TYPE abap_bool,
    get_taskname RETURNING VALUE(r_result) TYPE ze_taskname,
    set_taskname IMPORTING i_taskname TYPE ze_taskname,
    get_rfc_connection RETURNING VALUE(r_result) TYPE REF TO zif_rfc,
    set_rfc_connection IMPORTING rfc_connection TYPE REF TO zif_rfc,
    get_rfc_group RETURNING VALUE(r_result) TYPE rzlli_apcl,
    set_rfc_group IMPORTING rfc_group TYPE rzlli_apcl.
  EVENTS function_called
      EXPORTING
        VALUE(e_message) TYPE bapi_msg
        VALUE(e_subrc) TYPE sy-subrc.
  EVENTS function_received
      EXPORTING
          VALUE(e_message) TYPE bapi_msg
          VALUE(e_subrc) TYPE sy-subrc.
  EVENTS rfc_insufficient_ressources
    EXPORTING
      VALUE(e_act_retries) TYPE i .


ENDINTERFACE.
