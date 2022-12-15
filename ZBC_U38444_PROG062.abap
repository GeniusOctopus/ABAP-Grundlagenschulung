*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog062.

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
SELECTION-SCREEN BEGIN OF BLOCK Daten WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_car FOR car, " interne Tabelle mit Kopfzeile
                  so_con FOR con. " interne Tabelle mit Kopfzeile
SELECTION-SCREEN END OF BLOCK Daten.

SELECTION-SCREEN BEGIN OF BLOCK Disp WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_tsel TYPE tbmaxsel.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK Sortieren WITH FRAME TITLE TEXT-003.
    PARAMETERS: p_sort TYPE sap_bool DEFAULT 'X',
                p_auf  RADIOBUTTON GROUP sor DEFAULT 'X',
                p_ab   RADIOBUTTON GROUP sor.
  SELECTION-SCREEN END OF BLOCK Sortieren.
SELECTION-SCREEN END OF BLOCK Disp.

* PAI zum Selektionsbild
AT SELECTION-SCREEN.

* Berechtigungsprüfung
*  AUTHORITY-CHECK OBJECT 'S_CARRID'
*   ID 'CARRID' FIELD 'xxxxxxxx'
*   ID 'ACTVT' FIELD 'xxxxxxxx'.
*  IF sy-subrc <> 0.
**   Implement a suitable exception handling here
*  ENDIF.

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

  IF sy-subrc NE 0. " Wenn kein Datensatz gefunden wurde
    " Message ist ein Dialogbefehl und kann nur im Gui ausgeführt werden
    " Message als Modaler Dialog?
    MESSAGE TEXT-005 TYPE 'E'. " I = Info, Status = S, Fehler = E, Warnung = W, Abbruch = A, Exit = x
  ENDIF.

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
