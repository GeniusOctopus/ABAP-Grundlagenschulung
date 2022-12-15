*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog01.

* Datendeklaration
DATA  lv_1 TYPE  i VALUE 5.     " i = Integer
"Kettensatz
DATA: lv_2 LIKE lv_1,           " LIKE vererbt Datentyp von lv_1 an lv_2
      lv_3 TYPE c LENGTH 20,    " c = Character mit Länge 20 (mit Leerzeichen aufgefüllt)
      lv_4,                     " Character Länge 1 -> Standard
      lv_5 TYPE p DECIMALS 2,   " Gepackter Datentyp -> Festkomma mit 2 Nachkommastellen und insgesamt 10 Zeichen
      lv_6, lv_7, lv_8 TYPE i.  " Character Länge 1, Character Länge 1, Integer
* Verarbeitungsblock
START-OF-SELECTION.
  WRITE:/ lv_1, lv_2.           " / = Carriage Return
  COMPUTE lv_2 = lv_1 + 4.      " lv_2 = lv_1 + 4. compute kann weggelassen werden
  WRITE:/ lv_1, lv_2.
  lv_3 = 'Marktredwitz'.
  lv_4 = lv_3.
  WRITE:/ lv_4, lv_3.
  lv_5 = lv_1 / lv_2.
  WRITE:/ lv_1, lv_2, lv_5.
  MOVE lv_1 TO lv_8.            " lv_6 = lv_1
  WRITE:/ lv_1, lv_8.
  ADD 3 TO lv_8.                " lv_8 = lv_8 + 3
  WRITE:/ lv_1, lv_8.
  CLEAR: lv_1, lv_3.            " setzt Variablen auf den typgerechten Initialwert
  WRITE:/ lv_1, lv_3.
