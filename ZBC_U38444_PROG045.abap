*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG045
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog045.

* Datendeklaration
DATA: gs_struc1 TYPE zbc_u38444_struc1,          " Strukturvariable
      lt_struc1 TYPE TABLE OF zbc_u38444_struc1. " interne Tabelle

* Selektionsbild
PARAMETERS p_car TYPE spfli-carrid DEFAULT 'LH'.

* Verarbeitungsblock
START-OF-SELECTION.

*  SELECT mandt carrid connid cityfrom airpfrom cityto airpto
*    FROM spfli INTO TABLE lt_struc1
*    WHERE carrid = p_car.

  SELECT mandt, carrid, connid, cityfrom, airpfrom, cityto, airpto
      FROM spfli
      WHERE carrid = @p_car
      INTO TABLE @lt_struc1.

  LOOP AT lt_struc1 INTO gs_struc1.
    WRITE: / sy-tabix,
           gs_struc1-carrid,
           gs_struc1-connid,
           gs_struc1-cityfrom,
           gs_struc1-airpfrom,
           gs_struc1-cityto,
           gs_struc1-airpto.
  ENDLOOP.
