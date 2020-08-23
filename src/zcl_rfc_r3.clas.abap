CLASS zcl_rfc_r3 DEFINITION
  PUBLIC
  INHERITING FROM zcl_rfc__base
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_rfc__factory .

  PUBLIC SECTION.
    METHODS zif_rfc~ping REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_rfc_r3 IMPLEMENTATION.

  METHOD zif_rfc~ping.
    data(rfcdes) = zif_rfc~get_rfcdes( ).
    CALL FUNCTION 'RFC_PING' DESTINATION rfcdes-rfcdest.
  ENDMETHOD.

ENDCLASS.
