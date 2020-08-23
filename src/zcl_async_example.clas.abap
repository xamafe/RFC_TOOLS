CLASS zcl_async_example DEFINITION "1. Step
  PUBLIC
  INHERITING FROM zcl_async__base
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: get_result_text RETURNING VALUE(r_result) TYPE string. "3. Step
  PROTECTED SECTION.
    METHODS: call_function REDEFINITION, "4. Step
      receive_function REDEFINITION. "5. Step
  PRIVATE SECTION.
    DATA result_text TYPE string.
ENDCLASS.



CLASS zcl_async_example IMPLEMENTATION.
  METHOD call_function.
    "4. Step
    DATA(taskname) = zif_async~get_taskname( ).
    CALL FUNCTION 'Z_ASYNC_EXAMPLE'
      STARTING NEW TASK taskname
      CALLING me->receive_data ON END OF TASK "<---
      EXPORTING
        i_taskname            = taskname
      EXCEPTIONS
        system_failure        = 1 MESSAGE e_message
        communication_failure = 2 MESSAGE e_message
        resource_failure      = 3.
    IF sy-subrc = 3.
      e_insufficient_ressources = abap_true. "<---
    ENDIF.
  ENDMETHOD.

  METHOD receive_function.
    RECEIVE RESULTS FROM FUNCTION 'Z_ASYNC_EXAMPLE'
        IMPORTING
            e_text = result_text.
  ENDMETHOD.

  METHOD get_result_text.
    "5. Step
    r_result = me->result_text.
  ENDMETHOD.

ENDCLASS.
