*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog042.

* Datendeklaration
DATA: gs_sflight TYPE sflight,
      lt_sflight TYPE TABLE OF sflight.

* Selektionsbild
PARAMETERS: p_car TYPE sflight-carrid DEFAULT 'LH',
            p_con TYPE sflight-connid DEFAULT '0400'.

* Verarbeitungsblock
START-OF-SELECTION.

  SELECT * FROM sflight INTO TABLE lt_sflight
    WHERE carrid = p_car
    AND connid = p_con.

  LOOP AT lt_sflight INTO gs_sflight.
    WRITE: / gs_sflight-carrid,
             gs_sflight-connid,
             gs_sflight-fldate,
             gs_sflight-seatsmax,
             gs_sflight-seatsocc.
  ENDLOOP.
