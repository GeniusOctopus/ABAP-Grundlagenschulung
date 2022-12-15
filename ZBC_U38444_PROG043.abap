*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog043.

* Datendeklaration
DATA: gs_sflight TYPE sflight,
      lt_sflight TYPE TABLE OF sflight.

* Referenz für ALV
DATA: r_tab TYPE REF TO cl_salv_table. " Referenzvariable bzw Objekt

* Selektionsbild
PARAMETERS: p_car TYPE sflight-carrid DEFAULT 'LH',
            p_con TYPE sflight-connid DEFAULT '0400'.

* Verarbeitungsblock
START-OF-SELECTION.

  SELECT * FROM sflight INTO TABLE lt_sflight
    WHERE carrid = p_car
    AND connid = p_con.

* LOOP AT lt_sflight INTO gs_sflight.
*    WRITE: / gs_sflight-carrid,
*             gs_sflight-connid,
*             gs_sflight-fldate,
*             gs_sflight-seatsmax,
*             gs_sflight-seatsocc.
*  ENDLOOP.

* ALV-Table (Muster -> ABAP Objects Muster -> [Bestätigen] -> Klasse: CL_SALV_TABLE; Methode: FACTORY
*TRY.
CALL METHOD cl_salv_table=>factory
  EXPORTING
    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
  IMPORTING
    r_salv_table   = r_tab
  CHANGING
    t_table        = lt_sflight
    .
*  CATCH cx_salv_msg.
*ENDTRY.

* Ausgabe ALV
* CALL METHOD r_tab->display
CALL METHOD r_tab->if_salv_gui_om_table_action~display
    .
