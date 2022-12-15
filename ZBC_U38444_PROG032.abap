*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG031
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog032.

" Datendeklaration
DATA: g_sk TYPE zbc_u38444_de05. " Zwischenspeichern Startkapital

" Selektionsbild
PARAMETERS: p_sk TYPE zbc_u38444_de05 DEFAULT 2000, " Startkapital mit Initialwert
            p_zs TYPE zbc_u38444_de06 DEFAULT '2.5'. " Zinssatz mit Initialwert

" Verarbeitungsblock

START-OF-SELECTION.

  " Zwischenspeichern des ST
  g_sk = p_sk.

  " Kapitalberechnung

  WHILE p_sk < 2 * g_sk.
    p_sk = p_sk + p_sk * p_zs / 100.
    WRITE: / sy-index, TEXT-001, p_sk.
  ENDWHILE.
