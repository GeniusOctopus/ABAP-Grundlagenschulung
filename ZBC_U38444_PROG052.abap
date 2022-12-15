*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG052
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog052.

* Datendeklaration
DATA: gs_struc2 TYPE zbc_u38444_struc2,
      gt_struc2 TYPE zbc_u38444_tt_struc2,
      gs_scarr  TYPE scarr,
      gt_scarr  TYPE zbc_u38444_tt_scarr.

* Selektionsbild
PARAMETERS: p_car  TYPE sflight-carrid DEFAULT 'LH',
            p_con  TYPE sflight-connid DEFAULT '0400',
            p_tsel TYPE tbmaxsel DEFAULT 10.

* Verarbeitungsblock
START-OF-SELECTION.

  SELECT mandt, carrid, connid, fldate, seatsmax, seatsocc
    FROM sflight
    WHERE carrid = @p_car
    AND connid = @p_con
     INTO TABLE @gt_struc2.

  SELECT * FROM scarr INTO TABLE gt_scarr.

  LOOP AT gt_struc2 INTO gs_struc2.
    gs_struc2-freiplatz = gs_struc2-seatsmax - gs_struc2-seatsocc.
* Ändern des aktuellen Datensatzes
    MODIFY gt_struc2 FROM gs_struc2.
  ENDLOOP.
  ULINE.
* Sortieren nach Freiplatz
  SORT gt_struc2 BY freiplatz.

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
  ULINE.
* alle Datensätze mit Freiplatz > 10
  LOOP AT gt_struc2 INTO gs_struc2
  WHERE freiplatz > 200.

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
