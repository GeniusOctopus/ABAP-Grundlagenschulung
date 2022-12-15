*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG046
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog046.

* Datendeklaration
DATA: gs_struc2 TYPE zbc_u38444_struc2,
      lt_struc2 TYPE TABLE OF zbc_u38444_struc2.

* Selektionsbild
PARAMETERS: p_car TYPE sflight-carrid DEFAULT 'LH',
            p_con TYPE sflight-connid DEFAULT '0400'.

* Verarbeitungsblock
START-OF-SELECTION.

  SELECT mandt, carrid, connid, fldate, seatsmax, seatsocc
    FROM sflight
    WHERE carrid = @p_car
    AND connid = @p_con
     INTO TABLE @lt_struc2.

  LOOP AT lt_struc2 INTO gs_struc2.
    gs_struc2-freiplatz = gs_struc2-seatsmax - gs_struc2-seatsocc.
    WRITE: / gs_struc2-carrid,
             gs_struc2-connid,
             gs_struc2-fldate,
             gs_struc2-seatsmax,
             gs_struc2-seatsocc,
             gs_struc2-freiplatz.
  ENDLOOP.
