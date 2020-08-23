CLASS zcl_async__base DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_async.
    METHODS constructor IMPORTING i_taskname TYPE ze_taskname OPTIONAL.
    METHODS receive_data IMPORTING p_task TYPE clike.
  PROTECTED SECTION.
    METHODS call_function
          ABSTRACT
      EXPORTING
        !e_subrc                   TYPE sy-subrc
        !e_message                 TYPE bapi_msg
        !e_insufficient_ressources TYPE abap_bool .
    METHODS receive_function
          ABSTRACT
      IMPORTING
        !p_task    TYPE clike
      EXPORTING
        !e_subrc   TYPE sy-subrc
        !e_message TYPE bapi_msg .

  PRIVATE SECTION.
    CLASS-DATA async_calls TYPE STANDARD TABLE OF REF TO zcl_async__base.
    DATA count_rfc_max_retry TYPE i VALUE 10.
    DATA is_running TYPE abap_bool.
    DATA taskname TYPE ze_taskname.
    DATA wait_secs_until_retry TYPE i VALUE 1.

    METHODS add_me_to_running.
    METHODS remove_async_running_data .

ENDCLASS.



CLASS zcl_async__base IMPLEMENTATION.
  METHOD constructor.
    zif_async~set_taskname( i_taskname ).
    APPEND me TO async_calls.
  ENDMETHOD.

  METHOD zif_async~is_running.
    r_is_running = is_running.
  ENDMETHOD.

  METHOD zif_async~start_all_async.
    LOOP AT async_calls ASSIGNING FIELD-SYMBOL(<caller>).
      <caller>->zif_async~start_async_call( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD zif_async~start_async_call.
    DATA insufficient_ressources TYPE abap_bool.
    DATA retry_count TYPE sy-index.
    DATA: call_subrc        TYPE sy-subrc,
          rfc_error_message TYPE bapi_msg.

    add_me_to_running( ).

    DO.
      retry_count = sy-index.
      FREE insufficient_ressources.
      call_function( IMPORTING
                         e_subrc                   = call_subrc
                         e_message                 = rfc_error_message
                         e_insufficient_ressources = insufficient_ressources
                   ).
      IF call_subrc = 0.
        EXIT.
      ELSEIF insufficient_ressources = abap_true.
        IF retry_count >= count_rfc_max_retry.
          remove_async_running_data( ).
          "Exception?
          EXIT.
        ELSE.
          RAISE EVENT zif_async~rfc_insufficient_ressources
            EXPORTING
              ev_act_retries = retry_count.
          WAIT UP TO wait_secs_until_retry SECONDS.
          CONTINUE.
        ENDIF.
      ELSEIF call_subrc <> 0.
        remove_async_running_data( ).
        "Exception?
        EXIT.
      ENDIF.
    ENDDO.

    RAISE EVENT zif_async~function_called
      EXPORTING
        ev_message = rfc_error_message
        ev_subrc   = call_subrc.

  ENDMETHOD.

  METHOD zif_async~get_count_rfc_retry.
    r_result = me->count_rfc_max_retry.
  ENDMETHOD.

  METHOD zif_async~set_count_rfc_retry.
    me->count_rfc_max_retry = i_count_rfc_retry.
  ENDMETHOD.

  METHOD zif_async~get_wait_secs_until_retry.
    r_result = me->wait_secs_until_retry.
  ENDMETHOD.

  METHOD zif_async~set_wait_secs_until_retry.
    me->wait_secs_until_retry = i_wait_secs_until_retry.
  ENDMETHOD.

  METHOD zif_async~get_is_running.
    r_result = me->is_running.
  ENDMETHOD.

  METHOD zif_async~set_is_running.
    me->is_running = i_is_running.
  ENDMETHOD.

  METHOD zif_async~free.
    DELETE TABLE async_calls FROM me.
  ENDMETHOD.

  METHOD add_me_to_running.
    zif_async~set_is_running( abap_true ).
    zif_async~running_tasks = zif_async~running_tasks + 1.
  ENDMETHOD.

  METHOD remove_async_running_data.
    zif_async~set_is_running( abap_false ).
    zif_async~running_tasks = zif_async~running_tasks - 1.
  ENDMETHOD.

  METHOD zif_async~get_taskname.
    r_result = me->taskname.
  ENDMETHOD.

  METHOD zif_async~set_taskname.
    CHECK i_taskname IS NOT INITIAL.
    me->taskname = i_taskname.
  ENDMETHOD.

  METHOD receive_data.
    "DO NOT call this method from somewhere else, but the "CALL FUNCTION" statement!
    DATA: receive_result    TYPE sy-subrc,
          rfc_error_message TYPE bapi_msg.

    CHECK p_task IS NOT INITIAL.
    receive_function( EXPORTING p_task = p_task
                      IMPORTING e_subrc   = receive_result
                                e_message = rfc_error_message ).
    remove_async_running_data( ).
    RAISE EVENT zif_async~function_received EXPORTING ev_subrc   = receive_result
                                                      ev_message = rfc_error_message.
  ENDMETHOD.

ENDCLASS.
