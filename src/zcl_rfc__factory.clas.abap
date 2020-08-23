CLASS zcl_rfc__factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    CONSTANTS c_connectiontype_r3 TYPE rfcdes-rfctype VALUE '3'.
    CLASS-METHODS create_by_rfcdest IMPORTING i_rfcdest       TYPE rfcdest
                                    RETURNING VALUE(r_result) TYPE REF TO zif_rfc.
    CLASS-METHODS get_by_rfcdest IMPORTING i_rfcdest       TYPE rfcdest
                                RETURNING VALUE(r_result) TYPE REF TO zif_rfc.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF mts_connections,
             rfcdest TYPE rfcdest,
             obj TYPE REF TO zif_rfc,
           END OF mts_connections,
           mtt_connections TYPE SORTED TABLE OF mts_connections WITH UNIQUE KEY rfcdest.

    CLASS-DATA rfcdests TYPE mtt_connections.

    CLASS-METHODS create_r3_by_rfcdest IMPORTING i_rfcdes        TYPE rfcdes
                                       RETURNING VALUE(r_result) TYPE REF TO zif_rfc.

ENDCLASS.

CLASS zcl_rfc__factory IMPLEMENTATION.
  METHOD create_by_rfcdest.
    r_result = get_by_rfcdest( i_rfcdest ).
    CHECK r_result IS NOT BOUND.

    SELECT SINGLE FROM rfcdes
         FIELDS *
          WHERE rfcdest = @i_rfcdest
           INTO @data(rfcdes).
    "Exception?
    CHECK sy-subrc = 0.

    case rfcdes-rfctype.
      when c_connectiontype_r3.
        r_result = create_r3_by_rfcdest( rfcdes ).
      when OTHERS.
        EXIT.
    endcase.
    INSERT value #( rfcdest = i_rfcdest obj = r_result ) INTO TABLE rfcdests.
  ENDMETHOD.

  METHOD get_by_rfcdest.
    READ TABLE rfcdests ASSIGNING FIELD-SYMBOL(<connection>) WITH TABLE KEY rfcdest = i_rfcdest.
    CHECK sy-subrc = 0.
    r_result = <connection>-obj.
  ENDMETHOD.

  METHOD create_r3_by_rfcdest.
     data(r3_destination) = NEW zcl_r3_rfc( ).
     r3_destination->zif_rfc~set_rfcdes( i_rfcdes ).
     r_result = r3_destination.
  ENDMETHOD.

ENDCLASS.
