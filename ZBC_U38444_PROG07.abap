*&---------------------------------------------------------------------*
*& Report ZBC_U38444_PROG07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_u38444_prog07.

* Datendeklaration
DATA: gs_view TYPE zbc_u38444_v1,
      lt_view TYPE TABLE OF zbc_u38444_v1.

* Variablen für Mehrfachselektion
DATA: car TYPE zbc_u38444_v1-id,
      con TYPE zbc_u38444_v1-verbindung.
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

  SELECT *
    FROM zbc_u38444_v1
    WHERE id IN @so_car
    AND verbindung IN @so_con
     INTO TABLE @lt_view
    UP TO @p_tsel ROWS.

  IF p_sort IS NOT INITIAL.
    IF p_auf IS NOT INITIAL.
      SORT lt_view BY datum ASCENDING.
    ELSE.
      SORT lt_view BY datum DESCENDING.
    ENDIF.
  ENDIF.

* ALV-Anzeige
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = p_abap
        IMPORTING
          r_salv_table = r_tab
        CHANGING
          t_table      = lt_view.
    CATCH cx_salv_msg.
  ENDTRY.

* Setzen der Funktionen im ALV
  r_tab->get_functions( )->set_all( abap_true ).
* ALV-Ausgabe
  CALL METHOD r_tab->if_salv_gui_om_table_action~display.
