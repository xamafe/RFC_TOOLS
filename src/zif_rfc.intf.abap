INTERFACE zif_rfc
  PUBLIC .
  METHODS get_rfcdes RETURNING VALUE(r_rfcdes) TYPE rfcdes.
  METHODS ping RETURNING VALUE(r_is_reachable) TYPE abap_bool.
  METHODS set_rfcdes IMPORTING i_rfcdes TYPE rfcdes.

ENDINTERFACE.
