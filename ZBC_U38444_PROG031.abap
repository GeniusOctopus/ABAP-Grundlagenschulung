*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG031
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC_U38444_PROG031.

" Datendeklaration
DATA: g_sk TYPE zbc_u38444_de05. " Zwischenspeichern Startkapital

" Selektionsbild
PARAMETERS: p_sk TYPE zbc_u38444_de05, " Startkapital
            p_zs TYPE zbc_u38444_de06. " Zinssatz

" Verarbeitungsblock

START-OF-SELECTION.

  " Zwischenspeichern des ST
  g_sk = p_sk.

  " Kapitalberechnung

  DO 10 TIMES.
    COMPUTE p_sk = p_sk + p_sk * p_zs / 100.
    WRITE: / sy-index, TEXT-001, p_sk.
  ENDDO.
