unit chf.db.connector;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, IBConnection, MSSQLConn, PQConnection, SQLite3Conn,
  DB, StrUtils, TypInfo;

type
  TChfDBEventOnLog = procedure(AMensagem : String) of object;

  TChfDBType = (dbtFirebird, dbtMSSQLServer, dbtOracle, dbtPostgreSQL, dbtSQLite3,
                dbtODBC, dbtSybase, dbtMySQL);

  { TChfDBConnection }

  TChfDBConnection = class

  private
    FCharset: String;
    FDatabaseName: String;
    FDBConn : TSQLConnection;
    FDefPrimaryKeyFieldType: TFieldType;
    FDefPrimaryKeyName: String;
    FDefPrimaryKeySize: Integer;
    FDefTrans : TSQLTransaction;
    FHostName: String;
    FOnLog: TChfDBEventOnLog;
    FParams: TStringList;
    FParamsEx: TStringList;
    FPassword: String;
    FDBType: TChfDBType;
    FUserName: String;
    function getParams: String;
    procedure setParams(AValue: String);
  protected
    procedure addLog(AMensagem : String); virtual;
    function getConnected: Boolean; virtual;
  public
    constructor Create(const ADBType: TChfDBType); virtual;
    destructor Destroy; override;
    function Connect:Boolean; virtual;
    function Disconnect:Boolean; virtual;
    procedure ExecSQL(const ASQL : string;
                      ATrans : TSQLTransaction = nil); virtual;
    //
    function getTransaction(AOwner: TComponent) : TSQLTransaction;
    function getSequence(const ASequenceName:string) : String; virtual;
    function getQuery(const ASQL : string;
                      ATrans : TSQLTransaction = nil):TSQLQuery; virtual;
    function getDataSet(const ATableName : string;
                        ATrans : TSQLTransaction = nil):TSQLQuery; virtual;
    function getServeTime : TTime; virtual;
    function getServeDate : TDate; virtual;
    function getServeDateTime : TDateTime; virtual;
    function getStrSQLFieldType(const ADataType : TFieldType;
                                const ASize : Integer = 0;
                                const ARequired : Boolean = False):String;
    //
    procedure addTable(const ATableName: string;
                       ATrans : TSQLTransaction = nil); overload;  virtual;
    procedure addTable(const ATableName: string;
                       const ACreatePrimaryKey : Boolean;
                       const AAutoInc : Boolean = False;
                       ATrans : TSQLTransaction = nil); overload;  virtual;
    procedure addTable(const ATableName: string;
                       const APrimaryKeyName : String;
                       const ACreatePrimaryKey : Boolean;
                       const AAutoInc : Boolean = False;
                       const APrimaryKeyFieldType : TFieldType = ftUnknown;
                       const APrimaryKeySize : Integer = 0;
                       ATrans : TSQLTransaction = nil); overload;  virtual;
    procedure addField(const ATableName: string;
                       const AFieldName: string;
                       const AFieldType: TFieldType;
                       const ASize : Integer = 0;
                       const ARequerid : Boolean = False;
                       ATrans : TSQLTransaction = nil); virtual;
    procedure addSequence(const ASequenceName: string;
                          const ANumStart : Integer = 0;
                          const ANumInc : Integer = 1;
                          ATrans : TSQLTransaction = nil);
    //
    procedure dropTable(const ATableName : string;
                        ATrans : TSQLTransaction = nil);
    procedure dropField(const ATableName: string;
                        const AFieldName: string;
                        ATrans : TSQLTransaction = nil);
    //
    function existTable(const ATableName: String;
                        ATrans : TSQLTransaction = nil): Boolean;
    function existField(const ATableName: string;
                        const AFieldName: string;
                        ATrans : TSQLTransaction = nil):Boolean;
    function existSequence(const ASequenceName: string;
                           ATrans : TSQLTransaction = nil): Boolean;
    // Propertys
    property DBType : TChfDBType read FDBType;
    property Params : String read getParams write setParams;
    property OnLog : TChfDBEventOnLog read FOnLog write FOnLog;
    property Connected : Boolean read getConnected;
    property DatabaseName : String read FDatabaseName write FDatabaseName;
    property HostName : String read FHostName write FHostName;
    property UserName : String read FUserName write FUserName;
    property Password : String read FPassword write FPassword;
    property Charset : String read FCharset write FCharset;
    property DefPrimaryKeyName : String read FDefPrimaryKeyName write FDefPrimaryKeyName;
    property DefPrimaryKeyFieldType : TFieldType read FDefPrimaryKeyFieldType write FDefPrimaryKeyFieldType;
    property DefPrimaryKeySize : Integer read FDefPrimaryKeySize write FDefPrimaryKeySize;
(*    //

    procedure ExecScript(const ASQLs : array of string); virtual; abstract;

    function addForeignKey(const AForeignKeyName:String;
                           const ATableName : String;
                           const AFieldName : String;
                           const ATableNameRef : String;
                           const AFieldNameRef : String):Boolean; virtual;
    function addFieldUnique(const AUnique:String;
                            const ATable : String;
                            const AField : String;
                            ADataType : TFieldType;
                            ASize : Integer = 0;
                            ARequired : Boolean = False):Boolean;
    function addUnique(const prUnique:String;
                       const prTable : String;
                       const prField : String):Boolean;
    function addFieldfk(const AForeignKey:String;
                         const ATable : String;
                         const AField : String;
                         const ATableRef : String;
                         const AFieldRef : String;
                         ADataType : TFieldType;
                         ASize : Integer = 0;
                         ARequired : Boolean = False):Boolean;
    function addSequence(const AGenName: string): Boolean;
    //

    function dropIndex(const AIndexName : String):Boolean;
    function dropForeignKey(const AForeignKey:String;
                            const ATable : String):Boolean;
    //
    procedure setFieldPrimaryKey(const ATableName: string;
                                 const AFieldName: string);
    procedure setDefaultValue(const ATableName: string;
                              const AFieldName: string;
                              const AValue : string);
    function setFieldNotNull(const ATable : String;
                             const AField : String;
                             const AValorPadrao: string):Boolean; virtual;
    function setFieldNull(const ATable : String;
                          const AField : String):Boolean; virtual;
    function setFieldPK(const ATable : String;
                        const AField : String):Boolean; virtual;
    //

    function existTrigger(const ATableName: string;
                          const ATriggerName: string):Boolean;
    function existForeignKey(const AForeignKeyName: String): Boolean;
    function existPrimaryKey(const APrimaryKeyName: string): Boolean;
    //

    //
    function renameField(const ATable:String;
                         const AField:String;
                         const ANewField:String):Boolean;
    function renametable(const ATable:String;
                         const ANewTable:String):Boolean;
    //
    property UseIDLargeint : Boolean read FUseIDLargeint write FUseIDLargeint *)
  end;

implementation

uses
  DateUtils;

{ TChfDBConnection }

constructor TChfDBConnection.Create(const ADBType: TChfDBType);
begin
  FParams := TStringList.Create;
  FParamsEx := TStringList.Create;
  FDBType := ADBType;
  Charset := 'UTF8';
  DefPrimaryKeyName := 'ID';
  DefPrimaryKeyFieldType := ftInteger;
  DefPrimaryKeySize := 0;
end;

destructor TChfDBConnection.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FParamsEx);
  FreeAndNil(FDefTrans);
  FreeAndNil(FDBConn);
  inherited Destroy;
end;

function TChfDBConnection.Connect: Boolean;
begin
  addLog('Inicio TChfDBConnection.Connect');
  case FDBType of
       dbtFirebird : FDBConn := TIBConnection.Create(nil);
    dbtMSSQLServer : FDBConn := TMSSQLConnection.Create(nil);
     dbtPostgreSQL : FDBConn := TPQConnection.Create(nil);
        dbtSQLite3 : FDBConn := TSQLite3Connection.Create(nil);
  end;
  if Assigned(FDBConn) then
  begin
    if not Assigned(FDefTrans) then
      FDefTrans := getTransaction(FDBConn);

    FDBConn.Connected:= False;
    FDBConn.Transaction := FDefTrans;
    FDBConn.KeepConnection:= True;
    FDBConn.HostName := HostName;
    FDBConn.DatabaseName := DatabaseName;
    FDBConn.UserName := UserName;
    FDBConn.Password := Password;
    FDBConn.CharSet := Charset;
    FDBConn.Params.Text := FParamsEx.Text;
    //
    FDBConn.Connected := True;
    Result := FDBConn.Connected;
  end
  else
    raise Exception.Create('TChfDBConnector.Error:0001');
  addLog('Depois de conectar TChfDBConnection.Connect');
end;

function TChfDBConnection.Disconnect: Boolean;
begin
  if Assigned(FDBConn) then
    FDBConn.Connected := False;
end;

procedure TChfDBConnection.ExecSQL(const ASQL: string; ATrans: TSQLTransaction);
var
  LoQuery : TSQLQuery;
  LoScript : TStringList;
  LiCount : Integer = 0;
begin
  LoScript := TStringList.Create;
  LoQuery := getQuery('', ATrans);
  try
    try
      LoScript.AddDelimitedText(ASQL, ';', True);
      LoQuery.Options := [];
      if not LoQuery.SQLTransaction.Active then
        LoQuery.SQLTransaction.StartTransaction;
      repeat
        LoQuery.SQL.Clear;
        LoQuery.SQL.Add(LoScript.Strings[LiCount]);
        LoQuery.ExecSQL;
        Inc(LiCount);
      until LiCount = LoScript.Count;
      LoQuery.SQLTransaction.Commit;
    except
      on E: Exception do
        raise Exception.Create('Error: CONN-0004'+#13+e.Message);
    end;
  finally
     FreeAndNil(LoQuery);
  end;
end;

function TChfDBConnection.getTransaction(AOwner: TComponent): TSQLTransaction;
begin
  addLog('Inicio TChfDBConnection.getTransaction');
  if not Assigned(AOwner) then
    AOwner := FDBConn;
  Result := TSQLTransaction.Create(AOwner);
  Result.SQLConnection := FDBConn;
  addLog('Fim do TChfDBConnection.getTransaction');
end;

function TChfDBConnection.getSequence(const ASequenceName: string): String;
var
  LsSQL : string = '';
  LoQuery : TSQLQuery;
begin
  case DBType of
    dbtFirebird : LsSQL := 'select gen_id('+ASequenceName.ToUpper+', 1) as seq from RDB$DATABASE';
    dbtMSSQLServer : LsSQL := 'SELECT NEXT VALUE FOR dbo.'+ASequenceName.ToUpper+' as seq;';
  end;

  LoQuery := getQuery(LsSQL, nil);
  try
    try
      LoQuery.Open;
      if not LoQuery.IsEmpty then
        Result := LoQuery.FieldByName('seq').AsString
      else
        raise Exception.Create('Error: CONN-0006');
      LoQuery.Close;
    except
      on e: Exception do
        raise Exception.Create('Error: CONN-0007'+#13+e.Message);
    end;
  finally
     FreeAndNil(LoQuery);
  end;
end;

function TChfDBConnection.getQuery(const ASQL: string; ATrans: TSQLTransaction
  ): TSQLQuery;
begin
  Result := TSQLQuery.Create(nil);

  Result.SQLTransaction := ATrans;
  if not Assigned(ATrans) then
    Result.SQLTransaction := getTransaction(Result);

  Result.DataBase := FDBConn;
  Result.ReadOnly := False;
  if not ASQL.IsEmpty then
  begin
    Result.Close;
    result.SQL.Text := ASQL;
    Result.Prepare;
    result.Options := [sqoAutoApplyUpdates, sqoAutoCommit];
  end;
end;

function TChfDBConnection.getDataSet(const ATableName: string;
  ATrans: TSQLTransaction): TSQLQuery;
begin
  result := getQuery('select * from '+ATableName.ToUpper, ATrans);
end;

function TChfDBConnection.getServeTime: TTime;
begin
  Result := TimeOf(getServeDateTime);
end;

function TChfDBConnection.getServeDate: TDate;
begin
  Result := DateOf(getServeDateTime);
end;

function TChfDBConnection.getServeDateTime: TDateTime;
var
  LsSQL : String;
  LoQuery : TSQLQuery;
begin
  case FDBType of
    dbtFirebird : LsSQL := 'select first 1 current_timestamp as datetime from RDB$DATABASE';
    dbtMSSQLServer : LsSQL := 'select GETDATE()  as datetime';
    dbtSQLite3 : LsSQL := 'select DATETIME() as datetime';
    dbtPostgreSQL : LsSQL := 'select CURRENT_TIMESTAMP as datetime';
  end;
  if not LsSQL.IsEmpty then
  begin
    LoQuery := getQuery(LsSQL, nil);
    try
      LoQuery.Open;
      if not LoQuery.IsEmpty then
        Result := LoQuery.FieldByName('datetime').AsDateTime;
      LoQuery.Close;
    finally
      FreeAndNil(LoQuery);
    end;
  end;
end;

function TChfDBConnection.getStrSQLFieldType(const ADataType: TFieldType;
  const ASize: Integer; const ARequired: Boolean): String;
begin
  case ADataType of
    ftGuid :
      begin
        if DBType = dbtFirebird then
          Result := 'VARCHAR(32) '+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtMSSQLServer then
          Result := 'UNIQUEIDENTIFIER '+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'UNIQUEIDENTIFIER '+IfThen(ARequired, ' NOT NULL', '');
      end;
    ftBoolean :
      begin
        if DBType = dbtFirebird then
          Result := 'SMALLINT'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'BOOLEAN'+IfThen(ARequired, ' NOT NULL DEFAULT 0 ', '');;
      end;
    ftCurrency :
      begin
        if DBType = dbtFirebird then
          Result := 'NUMERIC(12,2)'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'NUMERIC'+IfThen(ARequired, ' NOT NULL  DEFAULT 0 ', '');
      end;
    ftTime :
      begin
        if DBType = dbtFirebird then
          Result := 'TIME'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'DATETIME';
      end;
    ftDate :
      begin
        Result := 'DATE'+IfThen(ARequired, ' NOT NULL', '');;
      end;
    ftDateTime :
      begin
        if DBType = dbtFirebird then
          Result := 'TIMESTAMP'+IfThen(ARequired, ' NOT NULL', '');;
        if DBType = dbtSQLite3 then
          Result := 'DATETIME';
      end;
    ftInteger :
      begin
        if DBType = dbtFirebird then
          Result := 'INT'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'INTEGER'+IfThen(ARequired, ' NOT NULL DEFAULT 0 ', '');
      end;
    ftSmallint :
      begin
        if DBType = dbtFirebird then
          Result := 'smallint'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          raise Exception.Create('Tipo ftSmallint não implementado para SQLite.');
      end;
    ftLargeint :
      begin
        Result := 'BIGINT'+IfThen(ARequired, ' NOT NULL', '');
      end;
    ftString :
      begin
        if DBType = dbtFirebird then
          Result := 'VARCHAR('+IntToStr(ASize)+') CHARACTER SET ISO8859_1 '+IfThen(ARequired, 'NOT NULL', '')+' COLLATE PT_BR ';
        if DBType = dbtSQLite3 then
          Result := ' TEXT ' +  IfThen(ARequired, 'NOT NULL DEFAULT '''' ', '');
        if DBType = dbtMSSQLServer then
        begin
          if ASize <= 8000 then
            Result := 'VARCHAR('+IntToStr(ASize)+')'+IfThen(ARequired, 'NOT NULL', '')
          else
            Result := 'TEXT '+IfThen(ARequired, 'NOT NULL', '');
        end;
      end;
    ftBlob :
      begin
        Result := 'BLOB SUB_TYPE 1 SEGMENT SIZE 16384 CHARACTER SET ISO8859_1 ';
      end;
  end;
end;

procedure TChfDBConnection.addTable(const ATableName: string;
  ATrans : TSQLTransaction = nil);
begin
  addTable(ATableName, True, True, ATrans);
end;

procedure TChfDBConnection.addTable(const ATableName: string;
  const ACreatePrimaryKey: Boolean; const AAutoInc: Boolean;
  ATrans : TSQLTransaction = nil);
begin
  addTable(ATableName, DefPrimaryKeyName, ACreatePrimaryKey, AAutoInc, ftUnknown, 0, ATrans);
end;

procedure TChfDBConnection.addTable(const ATableName: string;
  const APrimaryKeyName: String; const ACreatePrimaryKey: Boolean;
  const AAutoInc: Boolean; const APrimaryKeyFieldType : TFieldType;
  const APrimaryKeySize : Integer; ATrans : TSQLTransaction);
var
  LsSQL : string = '';
  LsFieldName : String;
  LoFieldType : TFieldType;
  LiSizeField : Integer;
begin
  if not existTable(ATableName) then
  begin
    LsFieldName := IfThen(DefPrimaryKeyName.IsEmpty, DefPrimaryKeyName, APrimaryKeyName);
    if not APrimaryKeyName.IsEmpty then
      LsFieldName := APrimaryKeyName;
    //
    LoFieldType := DefPrimaryKeyFieldType;
    if APrimaryKeyFieldType <> ftUnknown then
      LoFieldType := APrimaryKeyFieldType;
    //
    LiSizeField := DefPrimaryKeySize;
    if APrimaryKeySize > 0 then
      LiSizeField := APrimaryKeySize;

    if (APrimaryKeyFieldType in [ftString, ftGuid]) and (LiSizeField = 0)then
      raise Exception.Create('O tamanho do field deve ser maior que zero para os tipos: ftString e ftGuid.');
    //
    LsSQL := LsSQL + 'create table '+UpperCase(ATableName)+' ';
    LsSQL := LsSQL + ' ('+LsFieldName+' '+getStrSQLFieldType(LoFieldType, LiSizeField, True);
    //
    // SQLite
    if DBType = dbtSQLite3 then
    begin
      if ACreatePrimaryKey then
      begin
        if not AAutoInc then
          LsSQL := LsSQL + ', PRIMARY KEY('+LsFieldName+')'
        else
          LsSQL := LsSQL + IfThen(AAutoInc, ' PRIMARY KEY AUTOINCREMENT ', '');
      end;
    end;
    //
    LsSQL := LsSQL + '); ';
    ExecSQL(LsSQL, ATrans);
    //
    // Firebird, MSSQL
    if DBType in [dbtFirebird, dbtMSSQLServer] then
    begin
      if ACreatePrimaryKey then
      begin
        LsSQL := ' ALTER TABLE '+ UpperCase(ATableName);
        LsSQL := LsSQL + ' ADD CONSTRAINT PK_'+UpperCase( ATableName )+LsFieldName;
        LsSQL := LsSQL + ' PRIMARY KEY ( '+LsFieldName+' ); ';
        ExecSQL(LsSQL, ATrans);
      end;
    end;
  end;
end;

procedure TChfDBConnection.addField(const ATableName: string;
  const AFieldName: string; const AFieldType: TFieldType; const ASize: Integer;
  const ARequerid: Boolean; ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  if not existField(ATableName, AFieldName, ATrans) then
  begin
    LsSQL := 'alter table '+UpperCase(ATableName)+
                    ' add '+UpperCase(AFieldName)+' '+ getStrSQLFieldType(AFieldType, ASize, ARequerid);
    ExecSQL(LsSQL, ATrans);
  end;
end;

procedure TChfDBConnection.addSequence(const ASequenceName: string;
  const ANumStart: Integer; const ANumInc: Integer;
  ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  if not existSequence(ASequenceName, ATrans) then
  begin
    case DBType of
         dbtFirebird : LsSQL := 'CREATE GENERATOR '+ASequenceName.ToUpper+'; '+
                                'SET GENERATOR '+ASequenceName.ToUpper+' TO '+ANumStart.ToString;
      dbtMSSQLServer : LsSQL := 'CREATE SEQUENCE '+QuotedStr(ASequenceName.ToUpper)+
                                '    START WITH '+ANumStart.ToString+
                                '  INCREMENT BY '+ANumInc.ToString;
    end;
    if not LsSQL.IsEmpty then
    begin
      ExecSQL(LsSQL, ATrans);
    end
    else
      raise Exception.Create('Error: CONN-0005'+#13+'Função não existe para o DB.');
  end
  else
    raise Exception.Create('Error: CONN-0003'+#13+'Sequence('+ASequenceName.ToUpper+') já existe no banco de dados.');
end;

procedure TChfDBConnection.dropTable(const ATableName: string;
  ATrans: TSQLTransaction);
var
  LsSQL : string;
begin
  LsSQL := 'drop table '+ATableName.ToUpper;
  ExecSQL(LsSQL, ATrans);
end;

procedure TChfDBConnection.dropField(const ATableName: string;
  const AFieldName: string; ATrans: TSQLTransaction);
var
  LsSQL : string;
begin
  LsSQL := 'alter table '+ ATableName.ToUpper + ' drop ' + AFieldName.ToUpper;
  ExecSQL(LsSQL, ATrans);
end;

function TChfDBConnection.existTable(const ATableName: String;
  ATrans: TSQLTransaction): Boolean;
var
  LsSQL : String;
  LoQuery : TSQLQuery;
begin
  Result := False;
  case DBType of
    dbtFirebird : LsSQL := 'select RDB$RELATION_NAME '+
                           '  from RDB$RELATIONS '+
                           '  where RDB$RELATION_NAME = '+QuotedStr(ATableName.ToUpper);
    dbtMSSQLServer : LsSQL := 'SELECT * FROM information_schema.tables '+
                              ' where TABLE_CATALOG  = '+QuotedStr(DatabaseName.ToUpper)+
                              '   and TABLE_SCHEMA = '+QuotedStr('dbo')+
                              '   and TABLE_NAME = '+QuotedStr(ATableName.ToUpper);
    dbtSQLite3 : LsSQL := '';
    dbtPostgreSQL : LsSQL := '';
  end;
  LoQuery := getQuery(LsSQL, ATrans);
  try
    LoQuery.Open;
    if not LoQuery.IsEmpty then
      Result := True;
    LoQuery.Close;
  finally
    FreeAndNil(LoQuery);
  end;
end;

function TChfDBConnection.existField(const ATableName: string;
  const AFieldName: string; ATrans: TSQLTransaction): Boolean;
var
  LsSQL : String;
  LoQuery : TSQLQuery;
begin
  Result := False;
  if existTable(ATableName) then
  begin
    case DBType of
      dbtFirebird : LsSQL := 'select RDB$FIELD_NAME '+
                             '  from RDB$RELATION_FIELDS '+
                             ' where RDB$RELATION_NAME = '+QuotedStr(ATableName.ToUpper)+
                             '   and RDB$FIELD_NAME = '+QuotedStr(AFieldName.ToUpper);
      dbtMSSQLServer : LsSQL := 'select column_name FROM INFORMATION_SCHEMA.COLUMNS '+
                                ' where TABLE_CATALOG  = '+QuotedStr(DatabaseName.ToUpper)+
                                '   and TABLE_SCHEMA = '+QuotedStr('dbo')+
                                '   and TABLE_NAME = '+QuotedStr(ATableName.ToUpper)+
                                '   and COLUMN_NAME = '+QuotedStr(AFieldName.ToUpper);
      dbtSQLite3 : LsSQL := '';
      dbtPostgreSQL : LsSQL := '';
    end;
    LoQuery := getQuery(LsSQL, ATrans);
    try
      LoQuery.Open;
      if not LoQuery.IsEmpty then
        Result := True;
      LoQuery.Close;
    finally
      FreeAndNil(LoQuery);
    end;
  end;
end;

function TChfDBConnection.existSequence(const ASequenceName: string;
  ATrans: TSQLTransaction): Boolean;
var
  LsSQL : String = '';
  LoQuery : TSQLQuery;
begin
  Result := False;
  case DBType of
       dbtFirebird : LsSQL := 'select a.RDB$GENERATOR_NAME '+
                              ' from RDB$GENERATORS a '+
                              'where a.RDB$GENERATOR_NAME = '+QuotedStr(ASequenceName.ToUpper);
    dbtMSSQLServer : LsSQL := 'select object_id '+
                              '  from sys.sequences '+
                              ' where object_id = object_id('+'dbo.'+QuotedStr(ASequenceName.ToUpper)+')';
  end;
  if not LsSQL.IsEmpty then
  begin
    LoQuery := getQuery(LsSQL, ATrans);
    try
      LoQuery.Open;
      if not LoQuery.IsEmpty then
        Result := True;
      LoQuery.Close;
    finally
      FreeAndNil(LoQuery);
    end;
  end
  else
    raise Exception.Create('Error: CONN-0002'+#13+'Função não existe para o DB');
end;

function TChfDBConnection.getParams: String;
begin
  Result := FParams.Text;
end;

procedure TChfDBConnection.setParams(AValue: String);
var
  LiCount : Integer;
begin
  FParams.Clear;
  FParams.Text := AValue;
  //
  FParamsEx.Clear;
  LiCount := 0;
  repeat
    if FParams.Strings[LiCount].StartsWith('HostName=') then
      FHostName := FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1)
    else
    if FParams.Strings[LiCount].StartsWith('DatabaseName=') then
      FDatabaseName := FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1)
    else
    if FParams.Strings[LiCount].StartsWith('UserName=') then
      FUserName := FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1)
    else
    if FParams.Strings[LiCount].StartsWith('Password=') then
      FPassword := FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1)
    else
    if FParams.Strings[LiCount].StartsWith('Charset=') then
      FCharset := FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1)
    else
      FParamsEx.Add(FParams.Strings[LiCount].ToLower);

    addLog('Carregando parâmetro: '+FParams.Strings[LiCount]);
    Inc(LiCount);
  until LiCount = FParams.Count;
end;

procedure TChfDBConnection.addLog(AMensagem: String);
begin
  if Assigned(FOnLog) then
    FOnLog(AMensagem);
end;

function TChfDBConnection.getConnected: Boolean;
begin
  if Assigned(FDBConn) then
    Result := FDBConn.Connected;
end;

end.