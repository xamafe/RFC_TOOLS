
FUNCTION Z_ASYNC_EXAMPLE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_TASKNAME) TYPE  ZE_TASKNAME
*"  EXPORTING
*"     VALUE(E_TEXT) TYPE  STRING
*"----------------------------------------------------------------------
  e_text = |Hello World, this is task { i_taskname }|.

ENDFUNCTION.
