*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog044.

* Datendeklaration
DATA: gs_struc1 TYPE zbc_u38444_struc1,          " Strukturvariable
      lt_struc1 TYPE TABLE OF zbc_u38444_struc1. " interne Tabelle

* Selektionsbild
PARAMETERS p_car TYPE spfli-carrid DEFAULT 'LH'.

* Verarbeitungsblock
START-OF-SELECTION.

* Blockweises lesen als ARRAY-FETCH
* Mindert Last auf RDBMS
  SELECT * FROM spfli INTO CORRESPONDING FIELDS OF TABLE lt_struc1
    WHERE carrid = p_car.

  LOOP AT lt_struc1 INTO gs_struc1.
    WRITE: / sy-tabix,
           gs_struc1-carrid,
           gs_struc1-connid,
           gs_struc1-cityfrom,
           gs_struc1-airpfrom,
           gs_struc1-cityto,
           gs_struc1-airpto.
  ENDLOOP.
