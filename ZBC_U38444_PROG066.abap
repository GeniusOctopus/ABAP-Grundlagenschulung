*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG065
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog066.

* Datendeklaration
DATA: gs_struc2 TYPE zbc_u38444_struc2,
      gt_struc2 TYPE zbc_u38444_tt_struc2.

* Variablen für Mehrfachselektion
DATA: car TYPE sflight-carrid,
      con TYPE sflight-connid.

* Selektionsbild
* Mehrfachselektion
SELECTION-SCREEN BEGIN OF BLOCK Daten WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR car, " interne Tabelle mit Kopfzeile
                  so_con FOR con. " interne Tabelle mit Kopfzeile
SELECTION-SCREEN END OF BLOCK Daten.

SELECTION-SCREEN BEGIN OF BLOCK Disp WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_tsel TYPE tbmaxsel.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK Sortieren WITH FRAME TITLE TEXT-003.
    PARAMETERS: p_sort TYPE sap_bool DEFAULT 'X'.
  SELECTION-SCREEN END OF BLOCK Sortieren.
SELECTION-SCREEN END OF BLOCK Disp.

* PAI zum Selektionsbild
AT SELECTION-SCREEN.

* Belegung der Anzahl der Listenzeilen
  IF p_tsel IS INITIAL.
    p_tsel = 100.
  ENDIF.

* Datenprüfung
  SELECT SINGLE carrid " Wird erfolgreich ausgeführt, wenn min 1 Datensatz zurück kommt -> Code 0
    FROM sflight
    WHERE carrid IN @so_car
    AND connid IN @so_con
    INTO @gs_struc2-carrid.

  IF sy-subrc NE 0.
    MESSAGE TEXT-005 TYPE 'E'.
  ENDIF.

* Verarbeitungsblock
START-OF-SELECTION.

  SELECT mandt, carrid, connid, fldate, seatsmax, seatsocc
    FROM sflight
    WHERE carrid IN @so_car
    AND connid IN @so_con
     INTO TABLE @gt_struc2.

  CALL FUNCTION 'Z_BC_U38444_FUBA2'
    CHANGING
      t_struc2 = gt_struc2.

  IF p_sort IS NOT INITIAL.
    SORT gt_struc2 BY freiplatz.
  ENDIF.

  ULINE.
* mit Indexzugriff
  LOOP AT gt_struc2 INTO gs_struc2
    FROM 1 TO p_tsel.

    WRITE: / gs_struc2-carrid,
             gs_struc2-connid,
             gs_struc2-fldate,
             gs_struc2-seatsmax,
             gs_struc2-seatsocc,
             gs_struc2-freiplatz.
  ENDLOOP.
