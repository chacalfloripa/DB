unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  SynHighlighterJScript, chf.demobase.gui.main, DB, SQLDB, IBConnection,
  StdCtrls, DBCtrls, SynEdit, DBGrids;

type

  { TForm1 }

  TForm1 = class(TCHFDemoBaseGUIMain)
    btnBuildDatabase: TButton;
    btnBuildSeguranca: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dtExistFieldNomeCampo: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    edtExistFieldNomeTabela: TEdit;
    edtExistTabela: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblTesteData: TLabel;
    lblTesteDataHora: TLabel;
    lblTesteHora: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pgFuncoesDB: TPageControl;
    SynEdit1: TSynEdit;
    tabDBFuncoes: TTabSheet;
    tabParamConnFirebird: TTabSheet;
    tabParamConnMSSQL: TTabSheet;
    tabParamsConexao: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

