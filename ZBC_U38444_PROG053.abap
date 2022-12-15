*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG053
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog053.

* Datendeklaration
DATA: gs_struc2 TYPE zbc_u38444_struc2,
      gt_struc2 TYPE zbc_u38444_tt_struc2,
      gs_scarr  TYPE scarr,
      gt_scarr  TYPE zbc_u38444_tt_scarr.

* Variablen für Mehrfachselektion
DATA: car TYPE sflight-carrid,
      con TYPE sflight-connid.

* Selektionsbild
* Mehrfachselektion
SELECT-OPTIONS: so_car FOR car, " interne Tabelle mit Kopfzeile
                so_con FOR con. " interne Tabelle mit Kopfzeile
PARAMETERS: p_tsel TYPE tbmaxsel DEFAULT 10,          " Anzahl der anzuzeigenden Einträge
            p_sort TYPE sap_bool DEFAULT 'X'.         " X = True

* Verarbeitungsblock
START-OF-SELECTION.

  SELECT mandt, carrid, connid, fldate, seatsmax, seatsocc
    FROM sflight
    WHERE carrid IN @so_car
    AND connid IN @so_con
     INTO TABLE @gt_struc2.

  SELECT * FROM scarr INTO TABLE gt_scarr.

  LOOP AT gt_struc2 INTO gs_struc2.
    gs_struc2-freiplatz = gs_struc2-seatsmax - gs_struc2-seatsocc.
* Ändern des aktuellen Datensatzes
    MODIFY gt_struc2 FROM gs_struc2.
  ENDLOOP.

  IF p_sort IS NOT INITIAL.
    SORT gt_struc2 BY freiplatz.
  ENDIF.

  ULINE.
* mit Indexzugriff
  LOOP AT gt_struc2 INTO gs_struc2
    FROM 1 TO p_tsel.

    READ TABLE gt_scarr INTO gs_scarr
    WITH KEY carrid = gs_struc2-carrid.

    WRITE: / gs_scarr-carrname,
             gs_struc2-carrid,
             gs_struc2-connid,
             gs_struc2-fldate,
             gs_struc2-seatsmax,
             gs_struc2-seatsocc,
             gs_struc2-freiplatz.
  ENDLOOP.
