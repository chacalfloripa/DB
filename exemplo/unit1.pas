unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  SynHighlighterJScript, chf.demobase.gui.main, SQLDB, mysql80conn, DB,
  oracleconnection, SQLite3Conn, PQConnection, MSSQLConn, IBConnection,
  StdCtrls, DBCtrls, SynEdit, DBGrids, chf.db.connector;

type

  { TForm1 }

  TForm1 = class(TCHFDemoBaseGUIMain)
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    cbxObrigatorio: TCheckBox;
    cmbDefTipoPrimaryKey: TComboBox;
    cmbTipoCampo: TComboBox;
    cmbTipoDB: TComboBox;
    cmbTipoPrimaryKey: TComboBox;
    dsTable: TDataSource;
    dsQuery: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    edtDefPrimaryKeyName: TEdit;
    edtDefPrimaryKeySize: TEdit;
    edtExistTabela: TEdit;
    edtNomeTabelaAbrir: TEdit;
    edtFieldSize: TEdit;
    edtNomeCampo: TEdit;
    edtSequenceInicial: TEdit;
    edtSequenceInc: TEdit;
    edtNomeTabelaCampo: TEdit;
    edtNomeSequence: TEdit;
    edtPrimaryKeyName: TEdit;
    edtPrimaryKeySize: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblTesteData: TLabel;
    lblTesteDataHora: TLabel;
    lblTesteHora: TLabel;
    memConfigMSSQL: TSynEdit;
    memConfigPostgreSQL: TSynEdit;
    memConfigSQLite3: TSynEdit;
    memConsultaSQL: TMemo;
    PageControl1: TPageControl;
    SQLQuery1: TSQLQuery;
    tabParamConnSQLite: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pgFuncoesDB: TPageControl;
    ScrollBox1: TScrollBox;
    memConfigFirebird: TSynEdit;
    tabDBFuncoes: TTabSheet;
    tabParamConnFirebird: TTabSheet;
    tabParamConnMSSQL: TTabSheet;
    tabParamsConexao: TTabSheet;
    tabParamConnPostgreSQL: TTabSheet;
    tabParamConnSQLite3: TTabSheet;
    tabEstruturaTabela: TTabSheet;
    tabEstruturaSequence: TTabSheet;
    tabEstruturaCampos: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBox1Click(Sender: TObject);
  private
     FDBConnection : TChfDBConnection;
     FDtsQuery : TSQLQuery;
     FDtsTable : TSQLQuery;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button15Click(Sender: TObject);
begin
  if not Assigned(FDBConnection) then
  begin
    case cmbTipoDB.Text of
      'Firebird' :
        begin
          FDBConnection := TChfDBConnection.Create(dbtFirebird);
          FDBConnection.OnLog := @WriteLog;
          FDBConnection.Params:= memConfigFirebird.Text;
        end;
      'MSSQLServer' :
        begin
          FDBConnection := TChfDBConnection.Create(dbtMSSQLServer);
          FDBConnection.OnLog := @WriteLog;
          FDBConnection.Params := memConfigMSSQL.Text;
        end;
      'PostgreSQL' :
        begin
          FDBConnection := TChfDBConnection.Create(dbtPostgreSQL);
          FDBConnection.OnLog := @WriteLog;
          FDBConnection.Params := memConfigPostgreSQL.Text;
        end;
      'SQLite' :
        begin
          FDBConnection := TChfDBConnection.Create(dbtSQLite3);
          FDBConnection.OnLog := @WriteLog;
          FDBConnection.Params := memConfigSQLite3.Text;
        end;
    end;
    FDBConnection.Connect;
    Button15.Caption := 'Disconnect DB';
  end
  else
  begin
    Button15.Caption := 'Connect DB';
    FDBConnection.Disconnect;
    FreeAndNil(FDBConnection);
  end;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtNomeSequence.Text) <> '' then
    begin
      FDBConnection.addSequence(edtNomeSequence.Text,
                                StrToInt(edtSequenceInicial.Text),
                                StrToInt(edtSequenceInc.Text));
      ShowMessage('Sequence criado com sucesso.');
    end
    else
      ShowMessage('O nome do sequence deve ser informado.');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtNomeSequence.Text) <> '' then
    begin
      if FDBConnection.existSequence(edtNomeSequence.Text) then
        ShowMessage('Sequence existe.')
      else
        ShowMessage('Sequence não existe.');
    end
    else
      ShowMessage('O nome do sequence deve ser informado.');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  ShowMessage('Não implementado.');
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  LoFieldType : TFieldType;
  LiFieldSize : Integer;
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    FDBConnection.DefPrimaryKeySize := StrToInt(edtDefPrimaryKeySize.Text);
    case cmbDefTipoPrimaryKey.ItemIndex of
      1 : FDBConnection.DefPrimaryKeyFieldType := ftSmallint;
      2 : FDBConnection.DefPrimaryKeyFieldType := ftInteger;
      3 : FDBConnection.DefPrimaryKeyFieldType := ftLargeint;
      4 : FDBConnection.DefPrimaryKeyFieldType := ftString;
      5 : FDBConnection.DefPrimaryKeyFieldType := ftGuid;
    end;
    case cmbTipoPrimaryKey.ItemIndex of
      0 : LoFieldType := ftUnknown;
      1 : LoFieldType := ftSmallint;
      2 : LoFieldType := ftInteger;
      3 : LoFieldType := ftLargeint;
      4 : LoFieldType := ftString;
      5 : LoFieldType := ftGuid;
    end;
    LiFieldSize := StrToInt(edtPrimaryKeySize.Text);
    if (LoFieldType <> ftUnknown) and (edtPrimaryKeyName.Text <> '') then
    begin
      if (LiFieldSize = 0) and (LoFieldType = ftString) then
      begin
        ShowMessage('O tamanho do field deve ser maior que zero para o tipo ftString');
        Exit;
     end;
      FDBConnection.addTable(edtExistTabela.Text,
                             edtPrimaryKeyName.Text,
                             True, True, LoFieldType, LiFieldSize)
    end
    else
    begin
      if edtPrimaryKeyName.Text <> '' then
        FDBConnection.addTable(edtExistTabela.Text,
                               edtPrimaryKeyName.Text,
                               True, True)
      else
        FDBConnection.addTable(edtExistTabela.Text);
    end;
    ShowMessage('Tabela criada com sucesso');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtNomeTabelaCampo.Text) <> '' then
    begin
      if Trim(edtNomeCampo.Text) <> '' then
      begin
        FDBConnection.dropField(edtNomeTabelaCampo.Text, edtNomeCampo.Text);
      end
      else
        ShowMessage('O nome do campo que será excluido deve ser informado.');
    end
    else
      ShowMessage('O nome da tabela onde o campo será excluido deve ser informado.');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  LoFieldType : TFieldType;
  LiFieldSize : Integer;
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtNomeTabelaCampo.Text) <> '' then
    begin
      if Trim(edtNomeCampo.Text) <> '' then
      begin
        LoFieldType := ftUnknown;;
        case cmbTipoCampo.ItemIndex of
           0 : LoFieldType := ftGuid;
           1 : LoFieldType := ftBoolean;
           2 : LoFieldType := ftCurrency;
           3 : LoFieldType := ftTime;
           4 : LoFieldType := ftDate;
           5 : LoFieldType := ftDateTime;
           6 : LoFieldType := ftInteger;
           7 : LoFieldType := ftSmallint;
           8 : LoFieldType := ftLargeint;
           9 :
             begin
               LiFieldSize := StrToInt(edtFieldSize.Text);
               if LiFieldSize = 0 then
               begin
                 ShowMessage('O tamanho do field deve ser maior que zero para o tipo ftString');
                 Exit;
               end
               else
                 LoFieldType := ftString
             end;
          10 : LoFieldType := ftBlob;
        end;
        FDBConnection.addField(edtNomeTabelaCampo.Text, edtNomeCampo.Text, LoFieldType, LiFieldSize, cbxObrigatorio.Checked);
      end
      else
        ShowMessage('O nome do campo que será criado deve ser informado.');
    end
    else
      ShowMessage('O nome da tabela onde o campo será criado deve ser informado.');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    FreeAndNil(FDtsQuery);
    FDtsTable := FDBConnection.getDataSet(edtNomeTabelaAbrir.Text);
    dsTable.DataSet := FDtsTable;
    FDtsTable.PacketRecords := -1;
    FDtsTable.Open;
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    FreeAndNil(FDtsQuery);
    FDtsQuery := FDBConnection.getQuery(memConsultaSQL.Text);
    dsQuery.DataSet := FDtsQuery;
    FDtsQuery.PacketRecords := -1;
    FDtsQuery.Open;
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
    lblTesteDataHora.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss', FDBConnection.getServeDateTime)
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
    lblTesteData.Caption := FormatDateTime('dd/mm/yyyy', FDBConnection.getServeDate)
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
    lblTesteHora.Caption := FormatDateTime('hh:nn:ss', FDBConnection.getServeTime)
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtExistTabela.Text) <> '' then
    begin
      if FDBConnection.existTable(edtExistTabela.Text) then
        ShowMessage('Tabela existe.')
      else
        ShowMessage('Tabela não existe.');
    end
    else
    begin
      ShowMessage('Preencha o campo nome da tabela para realizar o teste.');
    end;
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtNomeTabelaCampo.Text) <> '' then
    begin
      if Trim(edtNomeCampo.Text) <> '' then
      begin
        if FDBConnection.existField(edtNomeTabelaCampo.Text, edtNomeCampo.Text) then
          ShowMessage('Campo existe na tabela')
        else
          ShowMessage('Campo não existe na tabea.');

      end
      else
        ShowMessage('O nome do campo que será criado deve ser informado.');
    end
    else
      ShowMessage('O nome da tabela onde o campo será criado deve ser informado.');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtNomeTabelaCampo.Text) <> '' then
    begin
      if Trim(edtNomeCampo.Text) <> '' then
      begin
        //
      end
      else
        ShowMessage('O nome do campo que será renomeado deve ser informado.');
    end
    else
      ShowMessage('O nome da tabela onde o campo será renomeado deve ser informado.');
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtExistTabela.Text) <> '' then
    begin
     //
    end
    else
    begin
      ShowMessage('Preencha o campo nome da tabela que será renomeada.');
    end;
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  if Assigned(FDBConnection) and FDBConnection.Connected then
  begin
    if Trim(edtExistTabela.Text) <> '' then
    begin
      try
        FDBConnection.dropTable(edtExistTabela.Text);
        ShowMessage('Tabela eliminada com sucesso.')
      except
      on e : Exception do
        ShowMessage(e.Message);
      end;
    end
    else
    begin
      ShowMessage('Preencha o campo nome da tabela para realizar o teste.');
    end;
  end
  else
    ShowMessage('Sem conexão com o banco de dados.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  inherited;
  cbxLogAtivo.Checked := True;
end;

procedure TForm1.ScrollBox1Click(Sender: TObject);
begin

end;

end.
