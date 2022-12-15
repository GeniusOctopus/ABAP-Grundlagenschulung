*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog061.

* Datendeklaration
DATA: gs_struc2 TYPE zbc_u38444_struc2,
      gt_struc2 TYPE zbc_u38444_tt_struc2,
      gs_scarr  TYPE scarr,
      gt_scarr  TYPE zbc_u38444_tt_scarr.

* Variablen für Mehrfachselektion
DATA: car TYPE sflight-carrid,
      con TYPE sflight-connid.
* für ALV
DATA: r_tab TYPE REF TO cl_salv_table.

* Selektionsbild
* Mehrfachselektion
SELECTION-SCREEN BEGIN OF BLOCK Daten WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR car, " interne Tabelle mit Kopfzeile
                  so_con FOR con. " interne Tabelle mit Kopfzeile
SELECTION-SCREEN END OF BLOCK Daten.

SELECTION-SCREEN BEGIN OF BLOCK Disp WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_tsel TYPE tbmaxsel DEFAULT 10.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF BLOCK Sortieren WITH FRAME TITLE TEXT-003.
    PARAMETERS: p_sort TYPE sap_bool DEFAULT 'X',
                p_auf  RADIOBUTTON GROUP sor DEFAULT 'X',
                p_ab   RADIOBUTTON GROUP sor.
  SELECTION-SCREEN END OF BLOCK Sortieren.
  SELECTION-SCREEN BEGIN OF BLOCK alv WITH FRAME TITLE TEXT-004.
    PARAMETERS: p_alv  RADIOBUTTON GROUP abap,
                p_abap RADIOBUTTON GROUP abap DEFAULT 'X'.
  SELECTION-SCREEN END OF BLOCK alv.
SELECTION-SCREEN END OF BLOCK Disp.

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
    IF p_auf IS NOT INITIAL.
      SORT gt_struc2 BY freiplatz ASCENDING.
    ELSE.
      SORT gt_struc2 BY freiplatz DESCENDING.
    ENDIF.
  ENDIF.

*  ULINE.
** mit Indexzugriff
*  LOOP AT gt_struc2 INTO gs_struc2
*    FROM 1 TO p_tsel.
*
*    READ TABLE gt_scarr INTO gs_scarr
*    WITH KEY carrid = gs_struc2-carrid.
*
*    WRITE: / gs_scarr-carrname,
*             gs_struc2-carrid,
*             gs_struc2-connid,
*             gs_struc2-fldate,
*             gs_struc2-seatsmax,
*             gs_struc2-seatsocc,
*             gs_struc2-freiplatz.
*  ENDLOOP.

* ALV-Anzeige
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = p_abap
        IMPORTING
          r_salv_table = r_tab
        CHANGING
          t_table      = gt_struc2.
    CATCH cx_salv_msg.
  ENDTRY.

* Setzen der Funktionen im ALV
  r_tab->get_functions( )->set_all( abap_true ).
* ALV-Ausgabe
  CALL METHOD r_tab->if_salv_gui_om_table_action~display.
