*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog041.

* Datendeklaration
DATA: gs_spfli TYPE spfli,          " Strukturvariable
      lt_spfli TYPE TABLE OF spfli. " interne Tabelle

* Selektionsbild
PARAMETERS p_car TYPE spfli-carrid DEFAULT 'LH'.

* Verarbeitungsblock
START-OF-SELECTION.

* Blockweises lesen als ARRAY-FETCH
* Mindert Last auf RDBMS
  SELECT * FROM spfli INTO TABLE lt_spfli
    WHERE carrid = p_car.

  LOOP AT lt_spfli INTO gs_spfli.
    WRITE: / sy-tabix, " Zeilenindex der internen Tabelle ACHTUNG: geht nicht mit jeder internen Tabelle
           gs_spfli-carrid,
           gs_spfli-connid,
           gs_spfli-cityfrom,
           gs_spfli-airpfrom,
           gs_spfli-cityto,
           gs_spfli-airpto.
  ENDLOOP.
