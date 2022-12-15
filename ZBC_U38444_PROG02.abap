*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog02.

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
  l_op = '/'.

* Mehrfachverzweigung
  CASE l_op.
    WHEN '+'.
      lr_1 = lz_1 + lz_2.
      WRITE: / 'Ergebnis:', lr_1. " WRITE kann nicht ausgelagert werden, da Ausgabe in den Listenpuffer geschrieben wird und erst nach dem Case an den Output geschickt
    WHEN '-'.
      lr_1 = lz_1 - lz_2.
      WRITE: / 'Ergebnis:', lr_1.
    WHEN '*'.
      lr_1 = lz_1 * lz_2.
      WRITE: / 'Ergebnis:', lr_1.
    WHEN '/'.
      IF lz_2 NE 0. " <> oder ne entspricht ungleich
        lr_1 = lz_1 / lz_2.
        WRITE: / 'Ergebnis:', lr_1.
      ELSE.
        WRITE: / 'DIV_NULL ist nicht erlaubt'.
      ENDIF.
    WHEN OTHERS.
      WRITE: / 'unbekannter Operator'.
  ENDCASE.
