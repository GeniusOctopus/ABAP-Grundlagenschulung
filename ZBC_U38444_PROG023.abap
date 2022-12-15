*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG023
*&---------------------------------------------------------------------*
*& Einfacher Rechner mit Globalen Datentypen
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog023.

* Datendeklaration und Selektionsbild
PARAMETERS: lz_1 TYPE i,
            lz_2 TYPE i,
            p_op TYPE ZBC_U38444_DE01.
DATA lr_1 TYPE p DECIMALS 2.

* Verarbeitungsblock
START-OF-SELECTION.

* Mehrfachverzweigung
  CASE p_op.
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
      IF lz_2 NE 0. " <> oder NE entspricht ungleich
        lr_1 = lz_1 / lz_2.
        WRITE:/ TEXT-001, lr_1.
      ELSE.
        WRITE:/ TEXT-002.
      ENDIF.
    WHEN OTHERS.
      WRITE:/ TEXT-003.
  ENDCASE.
