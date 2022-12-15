*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG064
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog064.

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

* Freiplatzberechnung in FORM up2
  PERFORM up2 CHANGING gt_struc2.

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

*** Ende des Rahmenprogramms

*&---------------------------------------------------------------------*
*& Form up1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_STRUC2_SEATSMAX
*&      --> GS_STRUC2_SEATSOCC
*&      <-- GS_STRUC2_FREIPLATZ
*&---------------------------------------------------------------------*
FORM up1  USING    p_seatsmax " dynamische Typisierung -> by reference
                   p_seatsocc " dynamische Typisierung -> by reference
          CHANGING VALUE(p_freiplatz). " dynamische Typisierung -> by value

  p_freiplatz = p_seatsmax - p_seatsocc.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form up2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_STRUC2
*&---------------------------------------------------------------------*
FORM up2  CHANGING p_struc2 TYPE zbc_u38444_tt_struc2. " exakte Typisierung -> call by ref
  DATA: ps_struc2 LIKE LINE OF p_struc2.

  LOOP AT p_struc2 INTO ps_struc2.

    PERFORM up1
    USING ps_struc2-seatsmax
          ps_struc2-seatsocc
    CHANGING ps_struc2-freiplatz. " call by ref

    MODIFY p_struc2 FROM ps_struc2. " Änderung der internen Tabelle
  ENDLOOP.

ENDFORM.
