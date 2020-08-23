*&---------------------------------------------------------------------*
*& Report z_async_example_usage
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_async_example_usage.

class lcl_main DEFINITION.
    PUBLIC SECTION.
    class-methods main.
ENDCLASS.

class lcl_main IMPLEMENTATION.

  METHOD main.
    data async_tasks TYPE STANDARD TABLE OF REF TO zcl_async_example.

    DO 10 TIMES.
        APPEND new #( i_taskname = |No{ sy-index }| ) TO async_tasks.
    ENDDO.
    zcl_async_example=>zif_async~start_all_async( ).

    WAIT UNTIL zcl_async_example=>zif_async~running_tasks = zcl_async_example=>zif_async~mc_no_system_running.

    LOOP AT async_tasks ASSIGNING FIELD-SYMBOL(<task>).
        WRITE / <task>->get_result_text( ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
    lcl_main=>main( ).
