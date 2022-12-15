*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG021
*&---------------------------------------------------------------------*
*& Einfacher Rechner mit i18n
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog021.

* Datendeklaration
DATA: lz_1 TYPE i,
      lz_2 TYPE i,
      lr_1 TYPE p DECIMALS 2,
      l_op.

* Verarbeitungsblock
START-OF-SELECTION.

* Wertzuweisung

  lz_1 = 5.
  lz_2 = 0.
  l_op = '+'.

* Mehrfachverzweigung
  CASE l_op.
    WHEN '+'.
      lr_1 = lz_1 + lz_2.
      WRITE:/ TEXT-001, lr_1. " WRITE kann nicht ausgelagert werden, da Ausgabe in den Listenpuffer geschrieben wird und erst nach dem Case an den Output geschickt
    WHEN '-'.
      lr_1 = lz_1 - lz_2.
      WRITE:/ TEXT-001, lr_1.
    WHEN '*'.
      lr_1 = lz_1 * lz_2.
      WRITE:/ TEXT-001, lr_1.
    WHEN '/'.
      IF lz_2 NE 0. " <> oder ne entspricht ungleich
        lr_1 = lz_1 / lz_2.
        WRITE:/ TEXT-001, lr_1.
      ELSE.
        WRITE:/ TEXT-002.
      ENDIF.
    WHEN OTHERS.
      WRITE:/ TEXT-003.
  ENDCASE.
