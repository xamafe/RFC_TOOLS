CLASS zcl_rfc__base DEFINITION
  PUBLIC
  ABSTRACT
  CREATE public
  Global FRIENDS zcl_rfc__factory .

  PUBLIC SECTION.
    INTERFACES zif_rfc.
  PROTECTED SECTION.
  PRIVATE SECTION.
    data rfcdes TYPE rfcdes.
ENDCLASS.

CLASS zcl_rfc__base IMPLEMENTATION.
    METHOD zif_rfc~get_rfcdes.
    r_rfcdes = rfcdes.
  ENDMETHOD.

  METHOD zif_rfc~set_rfcdes.
    rfcdes = i_rfcdes.
  ENDMETHOD.

ENDCLASS.
