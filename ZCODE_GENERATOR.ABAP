REPORT ZCODE_GENERATOR.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_pack TYPE DEVCLASS.
SELECTION-SCREEN COMMENT /35(70) com4 MODIF ID mg4.
PARAMETERS: p_module TYPE char2 DEFAULT 'SD' OBLIGATORY.
SELECTION-SCREEN COMMENT /35(70) com3 MODIF ID mg3.
PARAMETERS: p_prog TYPE char34  OBLIGATORY.
SELECTION-SCREEN COMMENT /35(70) com1 MODIF ID mg1.
PARAMETERS: p_class TYPE char14 OBLIGATORY.
SELECTION-SCREEN COMMENT /35(70) com2 MODIF ID mg2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
PARAMETERS: p_selScn TYPE char1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME.
PARAMETERS: p_alvEvt TYPE char1 AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b3.
DATA(_name) = to_lower( p_class ).
DATA(_module) = to_lower( p_module ).

DATA: code TYPE TABLE OF rssource-line.
DATA: code_data TYPE TABLE OF rssource-line.
DATA: code_dto TYPE TABLE OF rssource-line.
DATA: code_bl TYPE TABLE OF rssource-line.
DATA: code_ui TYPE TABLE OF rssource-line.
* type of an editor line: rssource-line
DATA i_data TYPE char30.
DATA i_dto TYPE char30.
DATA i_bl TYPE char30.
DATA i_ui TYPE char30.

AT SELECTION-SCREEN OUTPUT.
  com1 = 'Örnek Z{Module Adı}_R_{Program Adı} ==> Sadece Program adı kısmını giriniz'.
  com3 = 'Class ve program Ön eki '.
  com2 = 'Örnek: SalesOrder / Fason / Material / MaterialMovments '.
  Com4 = 'Request hangi pakete atılacak'.

START-OF-SELECTION.

APPEND  |REPORT ZGENERATE_DYNAMIC_PROG.| TO code.

APPEND  |"====>CODE START<===| TO code_data.
*APPEND  |**********************************************************************Main Containers>| TO code_data.
*APPEND  |DATA: splitmain TYPE REF TO cl_gui_splitter_container.| TO code_Data.
*APPEND  |DATA: TopContainer TYPE REF TO cl_gui_container.| TO code_data.
*APPEND  |DATA: BottomContainer TYPE REF TO cl_gui_container.| TO code_data.
*APPEND  |**********************************************************************Main Grid| TO code_data.
*APPEND  |DATA: MainGrid TYPE REF TO cl_gui_alv_grid.| TO code_data.
*APPEND  |**********************************************************************| TO code.
*APPEND  |DATA: oTable TYPE REF TO data.| TO code_data.
*APPEND  |FIELD-SYMBOLS: <otable> TYPE STANDARD TABLE.| TO code_data.
APPEND  |**********************************************************************| TO code_data.
APPEND  |TABLES: mara.| TO code_data.
APPEND  |SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE text-001.| TO code_data.
APPEND  |  SELECT-OPTIONS: s_opt FOR mara-matnr.| TO code_data.
APPEND  |SELECTION-SCREEN END OF BLOCK block1.| TO code_data.
APPEND  |**********************************************************************| TO code_data.
APPEND  |"====>CODE END<===| TO code_data.
APPEND space to code_data.



APPEND  space TO code.

i_data =  |z{ _module }_i_{ p_prog }_SELSCR| .
INSERT REPORT 'ZDY_I_CLASS_SEL_SCR' FROM code_data   PROGRAM TYPE 'I'.
APPEND  |INCLUDE ZDY_I_CLASS_SEL_SCR. "Selection Screen| TO code.

APPEND space to code_dto.
APPEND  |"====>INCLUDE zsd_i_{ _name }_dto    ===>CODE START<===| TO code_dto.
APPEND  |"====>"INTERFACE<===| TO code_dto.
APPEND  |INTERFACE if_{ _Name }.| TO code_dto.
APPEND  |"Tipler| TO code_dto.
APPEND  |types: BEGIN OF ty_data,| TO code_dto.
APPEND  |       mara TYPE mara-matnr,| TO code_dto.
APPEND  |END OF ty_data.| TO code_dto.
APPEND  |TYPES: tt_data TYPE TABLE OF ty_data WITH DEFAULT KEY.| TO code_dto.
APPEND  |"Data Acess katmanı| TO code_dto.
APPEND  |METHODS: Get_data RETURNING VALUE(Result) TYPE tt_data.| TO code_dto.
APPEND  |ENDINTERFACE.| TO code_dto.
APPEND  space to code_dto.
APPEND  |"====>DTO<===| TO code_dto.
APPEND  |CLASS { _name }_dto DEFINITION.| TO code_dto.
APPEND  | PUBLIC SECTION.| TO code_dto.
APPEND  |    INTERFACES: if_{ _name }.| TO code_dto.
APPEND  |    METHODS:Constructor.| TO code_dto.
APPEND  | PROTECTED SECTION.| TO code_dto.
APPEND  | PRIVATE SECTION.| TO code_dto.
APPEND  |ENDCLASS.| TO code_dto.
APPEND space to code_dto.
APPEND  |CLASS { _name }_dto IMPLEMENTATION.| TO code_dto.
APPEND  |   METHOD Constructor.| TO code_dto.
APPEND  |   ENDMETHOD.| TO code_dto.
APPEND  |  METHOD if_{ _name }~get_data.| TO code_dto.
APPEND  |   "Get data From Database| TO code_dto.
APPEND  |   SELECT MATNR  INTO TABLE RESULT FROM MARA UP TO 10 ROWS.| TO code_dto.
APPEND  |  ENDMETHOD.| TO code_dto.
APPEND  |ENDCLASS.| TO code_dto.
APPEND  |"====>INCLUDE zsd_i_{ _name }_dto    ===>CODE END<===| TO code_dto.
APPEND  space TO code_dto.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
i_dto =  |Z{ _module }_I_{ _name }_CLS_DTO| .
INSERT REPORT 'ZDY_I_CLASS_DTO' FROM code_dto  PROGRAM TYPE 'I'.
APPEND  |INCLUDE ZDY_I_CLASS_DTO."Data Erişim Katmanı| TO code.

APPEND  |CLASS { _name }_bl DEFINITION.| TO code_bl.
APPEND  | PUBLIC SECTION.| TO code_bl.
APPEND  | INTERFACES: if_{ _name }.| TO code_bl.
APPEND  |    METHODS:Constructor.| TO code_bl.
APPEND  | PROTECTED SECTION.| TO code_bl.
APPEND  | PRIVATE SECTION.| TO code_bl.
APPEND  | DATA: _{ _name }_dto TYPE REF TO { _name }_dto.| TO code_bl.
APPEND  |ENDCLASS.| TO code_bl.
APPEND space to code_bl.
APPEND  |CLASS { _name }_bl IMPLEMENTATION.| TO code_bl.
APPEND  |   METHOD Constructor.| TO code_bl.
APPEND  |   _{ _name }_dto = NEW #(  ).| TO code_bl.
APPEND  |   ENDMETHOD.| TO code_bl.
APPEND  |  METHOD if_{ _name }~get_data.| TO code_bl.
APPEND  |  "AddRules| TO code_bl.
APPEND  |  "AddValidation| TO code_bl.
APPEND  |  "Business Logic| TO code_bl.
APPEND  |  result = _{ _name }_dto->if_{ _name }~get_data(  ).| TO code_bl.
APPEND  |  ENDMETHOD.| TO code_bl.
APPEND  |ENDCLASS.| TO code_bl.

i_bl =  |Z{ _module }_I_{ _name }_CLS_BL| .
INSERT REPORT 'ZDY_I_CLASS_BL' FROM code_bl   PROGRAM TYPE 'I'.
APPEND  |INCLUDE ZDY_I_CLASS_BL. "iş kuralları katmanı| TO code.




APPEND  |CLASS { _name }_ui DEFINITION.| TO code_ui.
APPEND  | PUBLIC SECTION.| TO code_ui.
APPEND  |   CLASS-DATA: _FieldCatalog TYPE lvc_T_fcat.| TO code_ui.
APPEND  |   CLASS-DATA: splitmain TYPE REF TO cl_gui_splitter_container.| TO code_ui.
APPEND  |   CLASS-DATA: TopContainer TYPE REF TO cl_gui_container.| TO code_ui.
APPEND  |   CLASS-DATA: BottomContainer TYPE REF TO cl_gui_container.| TO code_ui.
APPEND  |   CLASS-DATA: MainGrid TYPE REF TO cl_gui_alv_grid.| TO code_ui.
APPEND  |   CLASS-DATA: oTable TYPE REF TO data.| TO code_ui.
APPEND      space TO code_ui.
APPEND  |    METHODS:Constructor.| TO code_ui.
APPEND  |    CLASS-METHODS: CreateContainers,| TO code_ui.
APPEND  |    CreateGrids CHANGING  Grid TYPE REF TO cl_gui_alv_grid| TO code_ui.
APPEND  |                          Container TYPE REF TO cl_gui_container.| TO code_ui.
APPEND  | CLASS-METHODS: initialization.| TO code_ui.

APPEND  | METHODS: Start.| TO code_ui.
APPEND  | CLASS-METHODS: UserCommand IMPORTING ucomm TYPE sy-ucomm,| TO code_ui.
APPEND  |                status,| TO code_ui.
APPEND  |                CreateAlv.| TO code_ui.
*APPEND  | METHODS: GetData RETURNING VALUE(Result) TYPE REF TO data.| TO code_ui.
APPEND  |  CLASS-METHODS: ShowAlv IMPORTING is_layout TYPE lvc_s_layo| TO code_ui.
APPEND  |                 CHANGING  outtab TYPE REF TO data| TO code_ui.
APPEND  |                           fieldcatalog TYPE lvc_t_fcat.| TO code_ui.
APPEND  | PROTECTED SECTION.| TO code_ui.
APPEND  | PRIVATE SECTION.| TO code_ui.
APPEND  | DATA: _{ _name }_bl TYPE REF TO { _name }_bl.| TO code_ui.
APPEND  |ENDCLASS.| TO code_ui.



APPEND  |CLASS { _name }_ui IMPLEMENTATION.| TO code_ui.
APPEND  |   METHOD Constructor.| TO code_ui.
APPEND  |   _{ _name }_bl = NEW #(  ).| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.

APPEND  |   METHOD initialization.| TO code_ui.
APPEND  |     DATA(iu) = NEW { _name }_ui( ).| TO code_ui.
APPEND  |     iu->CreateContainers( ).| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.


APPEND  |   METHOD CreateContainers.| TO code_ui.
APPEND  |     CHECK splitmain IS INITIAL.| TO code_ui.
APPEND  |      SplitMain = NEW cl_gui_splitter_container(| TO code_ui.
APPEND  |                  parent = NEW cl_gui_custom_container(| TO code_ui.
APPEND  |                  container_name = 'CONTAINER' )| TO code_ui.
APPEND  |                      rows = 2 columns = 1  ).| TO code_ui.
APPEND  |      splitmain->set_row_height( id = 1 height = '10' ).| TO code_ui.
APPEND  |      TopContainer = SplitMain->get_container( row  =  1 column =  1 ).| TO code_ui.
APPEND  |      Bottomcontainer = SplitMain->get_container( row    =  2 | TO code_ui.
APPEND  |                                                  column =  1 ).| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.

APPEND  |   METHOD creategrids.| TO code_ui.
APPEND  |****************** Main Grid| TO code_ui.
APPEND  | IF grid IS INITIAL.| TO code_ui.
APPEND  | grid = NEW cl_gui_alv_grid( i_parent =  container  ).| TO code_ui.
APPEND  | ELSE.| TO code_ui.
APPEND  |  grid->refresh_table_display( is_stable = VALUE #( row = abap_true | TO code_ui.
APPEND  |                                                    col = abap_true ) ).| TO code_ui.
APPEND  |     ENDIF.| TO code_ui.
APPEND  |   Endmethod.| TO code_ui.

APPEND  |   METHOD usercommand.| TO code_ui.
APPEND  |     CASE ucomm.| TO code_ui.
APPEND  |        WHEN 'REFRESH'.| TO code_ui.
APPEND  |         "PERFORM data_select.| TO code_ui.
APPEND  |          MainGrid->refresh_table_display( ).| TO code_ui.
APPEND  |       WHEN OTHERS.| TO code_ui.
APPEND  |           leave TO SCREEN 0.| TO code_ui.
APPEND  |     ENDCASE.| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.

APPEND  |   METHOD status.| TO code_ui.
APPEND  |    CASE sy-dynnr.| TO code_ui.
APPEND  |      WHEN '0100'.| TO code_ui.
APPEND  |       SET PF-STATUS 'STATUS_0100'.| TO code_ui.
APPEND  |       SET TITLEBAR 'TITLEBAR_0100'.| TO code_ui.
APPEND  |      WHEN OTHERS.| TO code_ui.
APPEND  |    ENDCASE.| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.

APPEND  |   METHOD showalv.| TO code_ui.
APPEND  |     FIELD-SYMBOLS: <outtab> TYPE STANDARD TABLE.| TO code_ui.
APPEND  |     ASSIGN outtab->* TO <outtab>.| TO code_ui.

APPEND  |    if maingrid IS INITIAL.| TO code_ui.
APPEND  |     CreateGrids( CHANGING grid = maingrid | TO code_ui.
APPEND  |                               container = BottomContainer  ).| TO code_ui.
APPEND  |     maingrid->set_table_for_first_display(| TO code_ui.
APPEND  |       EXPORTING| TO code_ui.
APPEND  |*         is_variant                    =              | TO code_ui.
APPEND  |         i_save                        =  'A'          | TO code_ui.
APPEND  |         i_default                     = 'X'           | TO code_ui.
APPEND  |         is_layout                     =   is_layout   | TO code_ui.
APPEND  |       CHANGING| TO code_ui.
APPEND  |         it_outtab                     =  <outtab>     | TO code_ui.
APPEND  |         it_fieldcatalog               =  fieldcatalog | TO code_ui.
APPEND  |       EXCEPTIONS| TO code_ui.
APPEND  |         invalid_parameter_combination = 1             | TO code_ui.
APPEND  |         program_error                 = 2             | TO code_ui.
APPEND  |         too_many_lines                = 3             | TO code_ui.
APPEND  |         others                        = 4| TO code_ui.
APPEND  |     ). | TO code_ui.
APPEND  |    ELSE.|  TO code_ui.
APPEND  |      maingrid->refresh_table_display( is_stable =  | TO code_ui.
APPEND  |                  VALUE #( row = abap_true col = abap_true ) ).| TO code_ui.
APPEND  |    ENDIF.| TO code_ui.
APPEND  |     "CALL SCREEN 0100.| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.

APPEND  |   METHOD start.| TO code_ui.
*APPEND  |     DATA: _FieldCatalog TYPE lvc_T_fcat.| TO code_ui.
APPEND  |     """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""| TO code_ui.
APPEND  |     DATA(_{ _name }) = _{ _name }_bl->if_{ _name }~get_data( ).| TO code_ui.
APPEND  |*    "Diğer database erişimleri var ise aşağıdaki şekilde olacak| TO code_ui.
APPEND  |*    _{ _name }_bl->if_{ _name }~get_data( _{ _name } ).| TO code_ui.
APPEND  |*    _{ _name }_bl->if_{ _name }~get_data( _{ _name } ).| TO code_ui.
APPEND  |     """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""| TO code_ui.
APPEND  |     "Uyarlamadan charctersitlik ekle | TO code_ui.
APPEND  |     "DATA(Result) = zcl_sd_config=>add_characteristics( | TO code_ui.
APPEND  |     "                   EXPORTING table  = REF #( _{ _name } )| TO code_ui.
APPEND  |     "                   IMPORTING fieldcatalog = _Fieldcatalog | TO code_ui.
APPEND  |     "                   ).| TO code_ui.
APPEND  |     " yeni tablo yapımızı oTable yapımıza çeviriyoruz.| TO code_ui.
APPEND  |     """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""| TO code_ui.
APPEND  |     "ASSIGN Result->* TO FIELD-SYMBOL(<NewTable>).| TO code_ui.
APPEND  |      GET REFERENCE OF _{ _name }  INTO otable.| TO code_ui.
APPEND  |     """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""| TO code_ui.
APPEND  |   FIELD-SYMBOLS: <_table> TYPE STANDARD TABLE.| TO code_ui.
APPEND  |   ASSIGN otable->* TO <_table>.| TO code_ui.
APPEND  |   cl_salv_table=>factory( IMPORTING r_salv_table = DATA(o_salv)| TO code_ui.
APPEND  |                           CHANGING  t_table      = <_table> ).| TO code_ui.
APPEND  |   _FieldCatalog  = cl_salv_controller_metadata=>get_lvc_fieldcatalog(| TO code_ui.
APPEND  |                   r_columns      = o_salv->get_columns( )| TO code_ui.
APPEND  |                   r_aggregations = o_salv->get_aggregations( ) ).| TO code_ui.
APPEND  |     "Uyarlamadaki Fieldcatalog değişikliklerini uyguluyoruz.| TO code_ui.
APPEND  |      "_fieldcatalog =  zcl_sd_config=>set_fieldcatalog( | TO code_ui.
APPEND  |      "                 fieldcatalog     = _FieldCatalog| TO code_ui.
APPEND  |      "                "Uyarlamada Fielcatalog adı ne ise o gelecek.| TO code_ui.
APPEND  |      "                 fieldcatalogname =  'MAINFIELDCATALOG'| TO code_ui.
APPEND  |*     "                 programname      =| TO code_ui.
APPEND  |*     "                 table            =| TO code_ui.
APPEND  |      "                 ).| TO code_ui.
APPEND  |    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""| TO code_ui.
APPEND  |          CALL SCREEN 0100.| TO code_ui.
APPEND  |    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.
APPEND space TO code_ui.
APPEND  |   METHOD CreateAlv.| TO code_ui.
APPEND  |   { _name }_ui=>ShowAlv( EXPORTING | TO code_ui.
APPEND  |                  is_layout    = VALUE #( zebra = 'X' )| TO code_ui.
APPEND  |                  CHANGING  fieldcatalog = { _name }_ui=>_fieldcatalog| TO code_ui.
APPEND  |                            outtab       =  Otable| TO code_ui.
APPEND  |                ).| TO code_ui.
APPEND  |   ENDMETHOD.| TO code_ui.

APPEND  |ENDCLASS.| TO code_ui.




i_ui =  |Z{ _module }_I_{ _name }_CLS_UI| .
INSERT REPORT 'ZDY_I_CLASS_UI' FROM code_ui    PROGRAM TYPE 'I' .
APPEND  |INCLUDE ZDY_I_CLASS_UI. "Kullanıcı Arayüz katmanı| TO code.
APPEND  space TO code.


APPEND  space TO code.
APPEND  'INITIALIZATION.' TO code.
APPEND  space TO code.
APPEND  |{ _name }_ui=>initialization( ).| TO code.
APPEND  space TO code.
APPEND  space TO code.
APPEND  '"AT SELECTION-SCREEN ON VALUE-REQUEST FOR selopt-low.' TO code.

APPEND  space TO code.
APPEND  space TO code.
APPEND  'START-OF-SELECTION.' TO code.
APPEND  |DATA(UI) = NEW { _name }_ui(  ).| TO code.
APPEND  'UI->Start( ).' TO code.
APPEND  'END-OF-SELECTION.' TO code.
APPEND  space TO code.




APPEND  |MODULE status_0100 OUTPUT.| TO code.
APPEND  |    { _name }_ui=>status( ).| TO code.
APPEND  |ENDMODULE.| TO code.

APPEND  |MODULE user_command_0100 INPUT.| TO code.
APPEND  |   { _name }_ui=>usercommand( sy-ucomm ).| TO code.
APPEND  |ENDMODULE.| TO code.


APPEND  |MODULE pbo_0100 OUTPUT.| TO code.
APPEND  |  IF { _name }_ui=>Maingrid IS NOT BOUND.| TO code.
APPEND  |   { _name }_ui=>CreateAlv( ).| TO code.
APPEND  |  ENDIF.| TO code.
APPEND  |ENDMODULE. | TO code.


DATA(_width) = 255.
INSERT REPORT 'ZGENERATE_DYNAMIC_PROG'   FROM CODE  MAXIMUM WIDTH INTO _width    PROGRAM TYPE '1' .
*GENERATE SUBROUTINE POOL CODE NAME DATA(Prog).
FREE: CODE.
*READ REPORT 'ZEK_010' INTO CODE.
*cl_demo_output=>display( code ).

*WAIT UP TO 2 SECONDS.
*INCLUDE ZEK_I_009.

*PERFORM createstatus USING p_prog.
*WAIT UP TO 2 SECONDS.

*BAPI_CTREQUEST_CREATE
