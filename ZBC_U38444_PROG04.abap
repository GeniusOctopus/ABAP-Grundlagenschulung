*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog04.

* Datendeklaration
DATA: gs_spfli TYPE spfli.

* Selektionsbild
PARAMETERS p_car TYPE spfli-carrid.

* Verarbeitungsblock
START-OF-SELECTION.

* Satzweises lesen und auf den Listenpuffer schreiben
* Problem: Programm bleibt stehen, wenn ein Datenbankfehler auftritt
* ACHTUNG: ist ineffektiv => Performance-Killer
SELECT * FROM spfli INTO gs_spfli
  WHERE carrid = p_car.
* Ausgabe von gs_spfli
  WRITE: / gs_spfli-carrid,
           gs_spfli-connid,
           gs_spfli-cityfrom,
           gs_spfli-airpfrom,
           gs_spfli-cityto,
           gs_spfli-airpto.
ENDSELECT.
