unit chf.db.connector;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, StrUtils, TypInfo, SQLDB, IBConnection, mysql80conn,
  MSSQLConn, PQConnection, SQLite3Conn, mysql51conn, mysql55conn, SQLDBLib;

type
  TChfDBEventOnLog = procedure(AMensagem : String) of object;

  TChfDBType = (dbtFirebird, dbtMSSQLServer, dbtOracle, dbtPostgreSQL, dbtSQLite3,
                dbtODBC, dbtSybase, dbtMySQL51, dbtMySQL55, dbtMySQL80);

  { TChfDBConnection }

  TChfDBConnection = class

  private
    FCharset: String;
    FDatabaseName: String;
    FDBConn : TSQLConnection;
    FDBLib : TSQLDBLibraryLoader;
    FDefPrimaryKeyFieldType: TFieldType;
    FDefPrimaryKeyName: String;
    FDefPrimaryKeySize: Integer;
    FDefTrans : TSQLTransaction;
    FLibraryName: String;
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
    procedure addLog(const AMensagem : String); virtual;
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
                        const AAutoActive : Boolean = True;
                        const APacketRecords : Integer = -1;
                        ATrans : TSQLTransaction = nil):TSQLQuery; virtual;
    function getServeTime : TTime; virtual;
    function getServeDate : TDate; virtual;
    function getServeDateTime : TDateTime; virtual;
    function getStrSQLFieldType(const ADataType : TFieldType;
                                const ASize : Integer = 0;
                                const ARequired : Boolean = False):String;
    function getStrSQLFieldTypeFromDB(const ATableName: string;
                                      const AFieldName: string;
                                      ATrans : TSQLTransaction = nil):String;
    function getFieldFromDB(const ATableName: string;
                            const AFieldName: string;
                            ATrans : TSQLTransaction = nil):TFieldDef;
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
    procedure addFieldForeignKey(const AForeignKey:String;
                                 const ATableName : String;
                                 const AFieldName : String;
                                 const ATableNameRef : String;
                                 const AFieldNameRef : String;
                                 const ADataType : TFieldType;
                                 const ASize : Integer = 0;
                                 const ARequired : Boolean = False;
                                 ATrans : TSQLTransaction = nil);
    procedure addSequence(const ASequenceName: string;
                          const ANumStart : Integer = 0;
                          const ANumInc : Integer = 1;
                          ATrans : TSQLTransaction = nil);
    procedure addForeignKey(const AForeignKeyName:String;
                           const ATableName : String;
                           const AFieldName : String;
                           const ATableNameRef : String;
                           const AFieldNameRef : String;
                           ATrans : TSQLTransaction = nil); virtual;
    procedure addFieldUnique(const AUniqueName:String;
                            const ATableName : String;
                            const AFieldName : String;
                            const ADataType : TFieldType;
                            const ASize : Integer = 0;
                            const ARequired : Boolean = False;
                            ATrans : TSQLTransaction = nil);
    procedure addUnique(const AUniqueName:String;
                        const ATableName : String;
                        const AFieldName : String;
                        ATrans : TSQLTransaction = nil);
    //
    procedure dropTable(const ATableName : string;
                        ATrans : TSQLTransaction = nil);
    procedure dropField(const ATableName: string;
                        const AFieldName: string;
                        ATrans : TSQLTransaction = nil);
    procedure dropForeignKey(const AForeignKeyName:String;
                             const ATableName : String;
                             ATrans : TSQLTransaction = nil);
    procedure dropIndex(const ATableName : String;
                        const AIndexName : String;
                        ATrans : TSQLTransaction = nil);
    //
    procedure renameField(const ATableName:String;
                          const AFieldName:String;
                          const ANewFieldName:String;
                          ATrans : TSQLTransaction = nil);
    procedure renametable(const ATableName:String;
                          const ANewTableName:String;
                          ATrans : TSQLTransaction = nil);
    //
    function existTable(const ATableName: String;
                        ATrans : TSQLTransaction = nil): Boolean;
    function existField(const ATableName: string;
                        const AFieldName: string;
                        ATrans : TSQLTransaction = nil):Boolean;
    function existForeignKey(const AForeignKeyName: String;
                             ATrans : TSQLTransaction = nil): Boolean;
    function existSequence(const ASequenceName: string;
                           ATrans : TSQLTransaction = nil): Boolean;
    //
    procedure setFieldNotNull(const ATableName : String;
                              const AFieldName : String;
                              const ADefValue: Variant;
                              ATrans : TSQLTransaction = nil); virtual;
    procedure setFieldNull(const ATableName : String;
                           const AFieldName : String;
                           ATrans : TSQLTransaction = nil); virtual;
    procedure setFieldPrimaryKey(const ATableName : String;
                                 const AFieldName : String;
                                 ATrans : TSQLTransaction = nil); virtual;
    function getCloneConnector: TChfDBConnection;
    // Propertys
    property DBConn : TSQLConnection read FDBConn;
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
  //
  if not FLibraryName.IsEmpty then
  begin
    FDBLib := TSQLDBLibraryLoader.Create(nil);
    FDBLib.LibraryName := FLibraryName;
    FDBLib.Enabled := True;
  end;
  //
  case FDBType of
       dbtFirebird : FDBConn := TIBConnection.Create(nil);
    dbtMSSQLServer : FDBConn := TMSSQLConnection.Create(nil);
     dbtPostgreSQL : FDBConn := TPQConnection.Create(nil);
        dbtSQLite3 : FDBConn := TSQLite3Connection.Create(nil);
        dbtMySQL51 : FDBConn := TMySQL51Connection.Create(nil);
        dbtMySQL55 : FDBConn := TMySQL55Connection.Create(nil);
        dbtMySQL80 : FDBConn := TMySQL80Connection.Create(nil);
  end;
  //
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
        if not LoScript.Strings[LiCount].Trim.IsEmpty then
        begin
          LoQuery.SQL.Clear;
          LoQuery.SQL.Add(LoScript.Strings[LiCount]);
          LoQuery.ExecSQL;
        end;
        Inc(LiCount);
      until LiCount = LoScript.Count;
      if not Assigned(ATrans) then
        LoQuery.SQLTransaction.Commit;
    except
      on E: Exception do
        raise Exception.Create('Error: CONN-0004'+#13+e.Message);
    end;
  finally
    FreeAndNil(LoScript);
    FreeAndNil(LoQuery);
  end;
end;

function TChfDBConnection.getTransaction(AOwner: TComponent): TSQLTransaction;
begin
  if not Assigned(AOwner) then
    AOwner := FDBConn;
  Result := TSQLTransaction.Create(AOwner);
  Result.SQLConnection := FDBConn;
end;

function TChfDBConnection.getSequence(const ASequenceName: string): String;
var
  LsSQL : string = '';
  LoQuery : TSQLQuery;
begin
  case DBType of
    dbtFirebird : LsSQL := 'select gen_id('+ASequenceName.ToUpper+', 1) as seq from RDB$DATABASE';
    dbtMSSQLServer : LsSQL := 'SELECT NEXT VALUE FOR dbo.'+ASequenceName.ToUpper+' as seq;';
    dbtPostgreSQL : LsSQL := 'SELECT nextval('+QuotedStr('"'+ASequenceName.ToLower+'"')+') as seq;';
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
  Result.SQLTransaction := FDefTrans;
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
  const AAutoActive : Boolean; const APacketRecords : Integer;
  ATrans: TSQLTransaction): TSQLQuery;
begin
  Result := getQuery('select * from '+ATableName.ToUpper, ATrans);
  Result.ReadOnly := False;
  Result.PacketRecords := APacketRecords;
  if AAutoActive then
    Result.Open;
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
    dbtFirebird : LsSQL := 'select first 1 LOCALTIMESTAMP as datetime from RDB$DATABASE';
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
        if DBType = dbtMSSQLServer then
          Result := 'TINYINT'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'BOOLEAN'+IfThen(ARequired, ' NOT NULL DEFAULT 0 ', '');;
      end;
    ftCurrency :
      begin
        if DBType = dbtFirebird then
          Result := 'NUMERIC(12,2)'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtMSSQLServer then
          Result := 'NUMERIC(12,2)'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'NUMERIC'+IfThen(ARequired, ' NOT NULL  DEFAULT 0 ', '');
      end;
    ftFloat :
      begin
        if DBType = dbtFirebird then
          Result := 'NUMERIC(12,2)'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtMSSQLServer then
          Result := 'NUMERIC(12,2)'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'NUMERIC'+IfThen(ARequired, ' NOT NULL  DEFAULT 0 ', '');
      end;
    ftTime :
      begin
        if DBType in [dbtFirebird, dbtMSSQLServer] then
          Result := 'TIME'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'DATETIME';
      end;
    ftDate :
      begin
        if DBType in [dbtFirebird, dbtMSSQLServer, dbtPostgreSQL] then
          Result := 'DATE'+IfThen(ARequired, ' NOT NULL', '');;
      end;
    ftDateTime :
      begin
        if DBType = dbtFirebird then
          Result := 'TIMESTAMP'+IfThen(ARequired, ' NOT NULL', '');;
        if DBType = dbtMSSQLServer then
          Result := 'DATETIME';
        if DBType = dbtSQLite3 then
          Result := 'DATETIME';
        if DBType = dbtPostgreSQL then
          Result := 'TIMESTAMP';
      end;
    ftInteger :
      begin
        if DBType in [dbtFirebird, dbtMSSQLServer, dbtPostgreSQL] then
          Result := 'INT'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := 'INTEGER'+IfThen(ARequired, ' NOT NULL DEFAULT 0 ', '');
      end;
    ftSmallint :
      begin
        if DBType in [dbtFirebird, dbtMSSQLServer, dbtPostgreSQL] then
          Result := 'smallint'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          raise Exception.Create('Tipo ftSmallint não implementado para SQLite.');
      end;
    ftLargeint :
      begin
        if DBType in [dbtFirebird, dbtMSSQLServer, dbtPostgreSQL] then
          Result := 'BIGINT'+IfThen(ARequired, ' NOT NULL', '');
        if DBType = dbtSQLite3 then
          raise Exception.Create('Tipo ftSmallint não implementado para SQLite.');
      end;
    ftString :
      begin
        if DBType = dbtFirebird then
          Result := 'VARCHAR('+IntToStr(ASize)+') CHARACTER SET ISO8859_1 '+IfThen(ARequired, 'NOT NULL', '')+' COLLATE PT_BR ';
        if DBType = dbtPostgreSQL then
          Result := 'VARCHAR('+IntToStr(ASize)+')'+IfThen(ARequired, 'NOT NULL', '');
        if DBType = dbtSQLite3 then
          Result := ' TEXT ' +  IfThen(ARequired, 'NOT NULL DEFAULT '''' ', 'NULL');
        if DBType = dbtMSSQLServer then
        begin
          if ASize <= 8000 then
            Result := 'VARCHAR('+IntToStr(ASize)+')'+IfThen(ARequired, 'NOT NULL', '')
          else
            Result := 'TEXT '+IfThen(ARequired, 'NOT NULL', 'NULL');
        end;
      end;
    ftBlob :
      begin
        if DBType in [dbtFirebird] then
          Result := 'BLOB SUB_TYPE 1 SEGMENT SIZE 16384 CHARACTER SET ISO8859_1 ';
        if DBType in [dbtMSSQLServer] then
          Result := 'BINARY';
        if DBType = dbtSQLite3 then
          raise Exception.Create('Tipo ftSmallint não implementado para SQLite.');
      end;
  end;
end;

function TChfDBConnection.getStrSQLFieldTypeFromDB(const ATableName: string;
  const AFieldName: string; ATrans: TSQLTransaction): String;
var
  LoQuery : TSQLQuery;
  LsSQL : String = '';
begin
  if DBType in [dbtSQLite3, dbtPostgreSQL, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(getStrSQLFieldTypeFromDB) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));
  if not existTable(ATableName, ATrans) then
     raise Exception.Create('A tabela "'+ATableName.ToUpper+'" não existe.');
  if not existField(ATableName, AFieldName, ATrans) then
     raise Exception.Create('A o campo "'+AFieldName+'" não existe na tabela "'+ATableName.ToUpper+'".');

  LoQuery := getQuery('select '+AFieldName+' from '+ATableName+' where '+AFieldName+' is null', ATrans);
  try
    LoQuery.Open;
    if LoQuery.Fields.Count > 0 then
    begin
      Result := getStrSQLFieldType(LoQuery.FieldByName(AFieldName).DataType,
                                   LoQuery.FieldByName(AFieldName).DataSize,
                                   LoQuery.FieldByName(AFieldName).Required);
    end;
  finally
    FreeAndNil(LoQuery);
  end;
end;

function TChfDBConnection.getFieldFromDB(const ATableName: string;
  const AFieldName: string; ATrans: TSQLTransaction): TFieldDef;
var
  LoQuery : TSQLQuery = nil;
  LsSQL : String = '';
begin
  if not existTable(ATableName, ATrans) then
     raise Exception.Create('A tabela "'+ATableName.ToUpper+'" não existe.');
  if not existField(ATableName, AFieldName, ATrans) then
     raise Exception.Create('A o campo "'+AFieldName+'" não existe na tabela "'+ATableName.ToUpper+'".');

  LoQuery := getQuery('select '+AFieldName+' from '+ATableName+' where '+AFieldName+' is null', ATrans);
  try
    LoQuery.Open;
    if LoQuery.Fields.Count > 0 then
    begin
      Result := TFieldDef.Create(nil,
                                 LoQuery.FieldByName(AFieldName).FieldName,
                                 LoQuery.FieldByName(AFieldName).DataType,
                                 LoQuery.FieldByName(AFieldName).Size,
                                 LoQuery.FieldByName(AFieldName).Required,
                                 LoQuery.FieldByName(AFieldName).FieldNo);

    end;
    LoQuery.Close;
  finally
    FreeAndNil(LoQuery);
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
  addLog('Criando a tabela '+ATableName);
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
    LsSQL := LsSQL + ')';
    ExecSQL(LsSQL, ATrans);
    //
    // Firebird, MSSQL
    if DBType in [dbtFirebird, dbtMSSQLServer, dbtPostgreSQL] then
    begin
      if ACreatePrimaryKey then
      begin
        setFieldPrimaryKey(ATableName, LsFieldName, ATrans);
        //LsSQL := ' ALTER TABLE '+ UpperCase(ATableName);
        //LsSQL := LsSQL + ' ADD CONSTRAINT PK_'+UpperCase( ATableName )+LsFieldName;
        //LsSQL := LsSQL + ' PRIMARY KEY ( '+LsFieldName+' ) ';
        //ExecSQL(LsSQL, ATrans);
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

procedure TChfDBConnection.addFieldForeignKey(const AForeignKey: String;
  const ATableName: String; const AFieldName: String; const ATableNameRef: String;
  const AFieldNameRef: String; const ADataType: TFieldType; const ASize: Integer;
  const ARequired: Boolean; ATrans: TSQLTransaction);
begin
  addField(ATableName, AFieldName, ADataType, ASize, ARequired);
  addForeignKey(AForeignKey, ATableName, AFieldName, ATableNameRef, AFieldNameRef);
end;

procedure TChfDBConnection.addSequence(const ASequenceName: string;
  const ANumStart: Integer; const ANumInc: Integer;
  ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  addLog('Criando a tabela '+ASequenceName);
  if not existSequence(ASequenceName, ATrans) then
  begin
    case DBType of
         dbtFirebird : LsSQL := 'CREATE GENERATOR '+ASequenceName.ToUpper+'; '+
                                'SET GENERATOR '+ASequenceName.ToUpper+' TO '+ANumStart.ToString;
       dbtPostgreSQL : LsSQL := 'CREATE SEQUENCE "'+ASequenceName.ToLower+'" INCREMENT '+ANumInc.ToString()+' START '+ANumStart.ToString()+' MINVALUE 0;'+
                                 'ALTER SEQUENCE "'+ASequenceName.ToLower+'" OWNER TO postgres;';
      dbtMSSQLServer :
        begin
          LsSQL := 'CREATE SEQUENCE '+ASequenceName.ToUpper+
                   '    START WITH 1'+
                   '  INCREMENT BY '+ANumInc.ToString;
          if (ANumStart <> 0) then
          begin
            LsSQL := LsSQL + ';';
            LsSQL := LsSQL + 'ALTER SEQUENCE '+ASequenceName.ToUpper+' RESTART WITH '+ANumStart.ToString+';';
          end;
        end;
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

procedure TChfDBConnection.addForeignKey(const AForeignKeyName: String;
  const ATableName: String; const AFieldName: String;
  const ATableNameRef: String; const AFieldNameRef: String;
  ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  if DBType in [dbtSQLite3, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(addForeignKey) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));
  if not existTable(ATableName, ATrans) then
    raise Exception.Create('Tabela "'+ATableName+'" não existe.');
  if not existTable(ATableNameRef, ATrans) then
    raise Exception.Create('Tabela "'+ATableNameRef+'" não existe.');
  if not existfield(ATableName, AFieldName, ATrans) then
    raise Exception.Create('Campo "'+AFieldName+'" não existe na tabela "'+ATableName+'".');
  if not existfield(ATableNameRef, AFieldNameRef, ATrans) then
    raise Exception.Create('Campo "'+AFieldNameRef+'" não existe na tabela "'+ATableNameRef+'".');
  //
  if not existForeignKey(AForeignKeyName, ATrans) then
  begin
    case DBType of
         dbtFirebird :
           begin
             if AFieldNameRef.Length > 26 then
               raise Exception.Create('O tamanho do nome de uma ForeignKey para o banco Firebird é de no máximo 26 caracteres.');
             LsSQL := 'ALTER TABLE '+ATableName.ToUpper+' '+
                      'ADD CONSTRAINT '+AForeignKeyName.ToUpper+' '+
                      'FOREIGN KEY ('+AFieldName.ToUpper+') '+
                      'REFERENCES '+ATableNameRef.ToUpper+'('+AFieldNameRef.ToUpper+')';

           end;
       dbtPostgreSQL : LsSQL := 'ALTER TABLE '+ATableName.ToUpper+' '+
                                'ADD CONSTRAINT '+AForeignKeyName.ToUpper+' '+
                                'FOREIGN KEY ('+AFieldName.ToUpper+') '+
                                'REFERENCES '+ATableNameRef.ToUpper+'('+AFieldNameRef.ToUpper+')';
                                //
      dbtMSSQLServer : LsSQL := 'ALTER TABLE dbo.'+ATableName.ToUpper+' '+
                                'ADD CONSTRAINT '+AForeignKeyName.ToUpper+' '+
                                'FOREIGN KEY ('+AFieldName.ToUpper+') '+
                                'REFERENCES  dbo.'+ATableNameRef.ToUpper+'('+AFieldNameRef.ToUpper+')';
    end;
    if not LsSQL.IsEmpty then
      ExecSQL(LsSQL, ATrans)
    else
      raise Exception.Create('Error: CONN-0008'+#13+'Função não existe para o DB');
  end;
end;

procedure TChfDBConnection.addFieldUnique(const AUniqueName: String;
  const ATableName: String; const AFieldName: String; const ADataType: TFieldType;
  const ASize: Integer; const ARequired: Boolean; ATrans: TSQLTransaction
  );
begin
  if DBType in [dbtSQLite3, dbtPostgreSQL, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(addFieldUnique) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));
  addField(ATableName, AFieldName, ADataType, ASize, ARequired, ATrans);
  addUnique(AUniqueName, ATableName, AFieldName, ATrans);
end;

procedure TChfDBConnection.addUnique(const AUniqueName: String;
  const ATableName: String; const AFieldName: String; ATrans: TSQLTransaction);
var
  LsSQL : String;
begin
  if DBType in [dbtSQLite3, dbtPostgreSQL, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(addUnique) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));

  case DBType of
    dbtFirebird : LsSQL := ' ALTER TABLE '+ATableName.ToUpper+
                           ' ADD CONSTRAINT '+AUniqueName.ToUpper+
                           ' UNIQUE ('+AFieldName.ToUpper+') '+
                           ' USING INDEX IDX_'+AUniqueName.ToUpper;
    dbtMSSQLServer : LsSQL := ' ALTER TABLE dbo.'+ATableName.ToUpper+
                              ' ADD CONSTRAINT '+AUniqueName.ToUpper+
                              ' UNIQUE ('+AFieldName.ToUpper+')';
  end;
  if existField(ATableName, AFieldName) then
  begin
    ExecSQL(LsSQL, ATrans);
  end;
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
  if existField(ATableName, AFieldName, ATrans) then
  begin
    case DBType of
     dbtFirebird : LsSQL := 'alter table '+ ATableName.ToUpper + ' drop ' + AFieldName.ToUpper;
     dbtMSSQLServer : LsSQL := 'alter table '+ ATableName.ToUpper + ' drop column ' + AFieldName.ToUpper;
    end;
    ExecSQL(LsSQL, ATrans);
  end;
end;

procedure TChfDBConnection.dropForeignKey(const AForeignKeyName: String;
  const ATableName: String; ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  if existForeignKey(AForeignKeyName.ToUpper, ATrans) then
  begin
    LsSQL := ' ALTER TABLE '+ATableName.ToUpper+
             ' DROP CONSTRAINT '+AForeignKeyName.ToUpper;
    ExecSQL(LsSQL, ATrans);
  end
  else
    raise Exception.Create('Error: CONN-0012'+#13+'Função não existe para o DB');
end;

procedure TChfDBConnection.dropIndex(const ATableName: String;
  const AIndexName : String; ATrans: TSQLTransaction);
var
  LsSQL : string;
begin
  case DBType of
    dbtFirebird : LsSQL := ' DROP INDEX '+AIndexName.ToUpper;
    dbtMSSQLServer : LsSQL := ' DROP INDEX '+ATableName.ToUpper+'.'+AIndexName.ToUpper;
  end;
  ExecSQL(LsSQL, ATrans);
end;

procedure TChfDBConnection.renameField(const ATableName: String;
  const AFieldName: String; const ANewFieldName: String; ATrans: TSQLTransaction
  );
var
  LsSQL : String = '';
begin
  case DBType of
   dbtFirebird :
      begin
        LsSQL := 'ALTER TABLE '+ATableName.ToUpper+' ALTER COLUMN '+AFieldName.ToUpper+' TO '+ANewFieldName.ToUpper;
      end;
    dbtMSSQLServer :
      begin
        LsSQL := 'exec sp_rename '+QuotedStr(ATableName.ToUpper+'.'+AFieldName)+ ', '+QuotedStr(ANewFieldName.ToUpper);
      end;
  end;
  ExecSQL(LsSQL, ATrans);
end;

procedure TChfDBConnection.renametable(const ATableName: String;
  const ANewTableName: String; ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  case DBType of
   dbtFirebird :
      begin
        LsSQL := ' UPDATE RDB$RELATIONS SET RDB$RELATION_NAME='+QuotedStr(ANewTableName.ToUpper)+
                 '  WHERE RDB$RELATION_NAME='+QuotedStr(ATableName.ToUpper)+';'+
                 ' UPDATE RDB$RELATION_FIELDS SET RDB$RELATION_NAME='+QuotedStr(ANewTableName.ToUpper)+
                 '  WHERE RDB$RELATION_NAME='+QuotedStr(ATableName.ToUpper)+' AND RDB$SYSTEM_FLAG=0;';

      end;
    dbtMSSQLServer :
      begin
        LsSQL := 'exec sp_rename '+QuotedStr(ATableName.ToUpper)+ ', '+QuotedStr(ANewTableName.ToUpper);
      end;
  end;
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
    dbtPostgreSQL : LsSQL := 'select * from pg_class where relname = '+QuotedStr(LowerCase(ATableName));
  end;
  LoQuery := getQuery(LsSQL, ATrans);
  try
    try
      LoQuery.Open;
      if not LoQuery.IsEmpty then
        Result := True;
      LoQuery.Close;
    except
      on e:  Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
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
      dbtPostgreSQL : LsSQL := 'select column_name from information_schema.columns ' +
                               ' where table_name = '+QuotedStr(ATableName.ToLower)+
                               '   and column_name = '+QuotedStr(AFieldName.ToLower);
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

function TChfDBConnection.existForeignKey(const AForeignKeyName: String;
  ATrans: TSQLTransaction): Boolean;
var
  LsSQL : string;
  LoQuery : TSQLQuery;
begin
  Result := False;
  if DBType = dbtSQLite3 then
    raise Exception.Create('Banco SQLite3 sem suporte a ForeignKey.');

  case DBType of
       dbtFirebird : LsSQL := 'select 0 '+
                              '  from RDB$RELATION_CONSTRAINTS  '+
                              ' where RDB$CONSTRAINT_NAME =  '+ QuotedStr(AForeignKeyName.ToUpper);
    dbtMSSQLServer : LsSQL := 'SELECT name '+
                              '  FROM sys.foreign_keys '+
                              ' where name = '+QuotedStr(AForeignKeyName.ToUpper);
     dbtPostgreSQL : LsSQL := 'select * from information_schema.referential_constraints where constraint_name = '+AForeignKeyName.ToLower.QuotedString;
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
    raise Exception.Create('Error: CONN-0009'+#13+'Função não existe para o DB');
(*
    if (UpperCase(Driver) = UpperCase(ctDriveFB)) then
  begin
    Result := False;
    sSQL := 'select 0 '+
            '  from RDB$RELATION_CONSTRAINTS  '+
            ' where RDB$CONSTRAINT_NAME =  '+ QuotedStr(ForeignKeyName);
    with getQuery(sSQL) do
    begin
      if not IsEmpty then
        Result := True;
      Close;
      Free;
    end;
  end; *)
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
     dbtPostgreSQL : LsSQL := 'select oid from pg_class where relname = '+QuotedStr(ASequenceName.ToLower);
    dbtMSSQLServer : LsSQL := 'select object_id '+
                              '  from sys.sequences '+
                              ' where object_id = object_id('+QuotedStr('dbo.'+ASequenceName.ToUpper)+')';
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

procedure TChfDBConnection.setFieldNotNull(const ATableName: String;
  const AFieldName: String; const ADefValue: Variant; ATrans: TSQLTransaction);
var
  LsSQL : String = '';
  LoField : TFieldDef = nil;
  LoQyery : TSQLQuery;
begin
  if DBType in [dbtSQLite3, dbtPostgreSQL, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(setFieldNotNull) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));
  case DBType of
       dbtFirebird : LsSQL := 'ALTER TABLE '+ATableName.ToUpper+' ALTER '+AFieldName.ToUpper+' SET NOT NULL';
    dbtMSSQLServer :
      begin
        LsSQL := 'ALTER TABLE '+ATableName.ToUpper+
                 ' ALTER COLUMN '+AFieldName.ToUpper + ' ';
        LoField := getFieldFromDB(ATableName, AFieldName, ATrans);
        LsSQL := LsSQL + getStrSQLFieldType(LoField.DataType, LoField.Size, True);
      end;
  end;
  if not LsSQL.IsEmpty then
  begin
    LoQyery := getQuery('', ATrans);
    try
      LoQyery.Options := [sqoAutoApplyUpdates, sqoAutoCommit];
      LoQyery.SQL.Clear;
      LoQyery.SQL.Add('update '+ATableName.ToUpper+
                      '   set '+AFieldName.ToUpper+' = :DefValue '+
                      ' where '+AFieldName.ToUpper+' is null ');
      LoQyery.ParamByName('DefValue').Value := ADefValue;
      LoQyery.ExecSQL;
      //
      LoQyery.SQL.Clear;
      LoQyery.SQL.Add(LsSQL);
      LoQyery.ExecSQL;
    finally
      FreeAndNil(LoField);
      FreeAndNil(LoQyery);
    end;
  end
  else
    raise Exception.Create('Error: CONN-0010'+#13+'Função não existe para o DB');
end;

procedure TChfDBConnection.setFieldNull(const ATableName: String;
  const AFieldName: String; ATrans: TSQLTransaction);
var
  LsSQL : String = '';
  LoField : TFieldDef = nil;
begin
  if DBType in [dbtSQLite3, dbtPostgreSQL, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(setFieldNull) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));

  case DBType of
       dbtFirebird : LsSQL := 'ALTER TABLE '+ATableName.ToUpper+' ALTER '+AFieldName.ToUpper+' SET NULL';
    dbtMSSQLServer :
      begin
        LsSQL := 'ALTER TABLE '+ATableName.ToUpper+
                 ' ALTER COLUMN '+AFieldName.ToUpper + ' ';
        LoField := getFieldFromDB(ATableName.ToUpper, AFieldName.ToUpper, ATrans);
        try
          LsSQL := LsSQL + getStrSQLFieldType(LoField.DataType, LoField.Size, False);
        finally
          FreeAndNil(LoField);
        end;
      end;
  end;

  if not LsSQL.IsEmpty then
  begin
    ExecSQL(LsSQL, ATrans);
  end
  else
    raise Exception.Create('Error: CONN-0011'+#13+'Função não existe para o DB');
end;

procedure TChfDBConnection.setFieldPrimaryKey(const ATableName: String;
  const AFieldName: String; ATrans: TSQLTransaction);
var
  LsSQL : String = '';
begin
  if DBType in [dbtSQLite3, dbtMySQL51, dbtMySQL55, dbtMySQL80, dbtODBC, dbtOracle, dbtSybase] then
    raise Exception.Create('Função(setFieldPK) não implementada para o banco '+GetEnumName(TypeInfo(TChfDBType), Ord(DBType)));

  case DBType of
       dbtFirebird : LsSQL := 'ALTER TABLE '+ ATableName.ToUpper+
                              ' ADD CONSTRAINT PK_'+ATableName.ToUpper+'_ID'+
                              ' PRIMARY KEY ( '+AFieldName.ToUpper+' ) ';
    dbtMSSQLServer : LsSQL := 'ALTER TABLE '+ ATableName.ToUpper+
                              ' ADD CONSTRAINT PK_'+ATableName.ToUpper+'_ID'+
                              ' PRIMARY KEY ( '+AFieldName.ToUpper+' ) ';
     dbtPostgreSQL : LsSQL := 'ALTER TABLE '+ ATableName.ToUpper+
                              ' ADD CONSTRAINT PK_'+ATableName.ToUpper+'_ID'+
                              ' PRIMARY KEY ( '+AFieldName.ToUpper+' ) ';
  end;

  if not LsSQL.IsEmpty then
  begin
    ExecSQL(LsSQL, ATrans);
  end
  else
    raise Exception.Create('Error: CONN-0012'+#13+'Função não existe para o DB');
end;

function TChfDBConnection.getCloneConnector: TChfDBConnection;
begin
  Result := TChfDBConnection.Create(Self.DBType);
  Result.Params := Self.Params;
  Result.Connect;
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
      FHostName := Trim(FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1))
    else
    if FParams.Strings[LiCount].StartsWith('DatabaseName=') then
      FDatabaseName := Trim(FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1))
    else
    if FParams.Strings[LiCount].StartsWith('UserName=') then
      FUserName := Trim(FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1))
    else
    if FParams.Strings[LiCount].StartsWith('Password=') then
      FPassword := Trim(FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1))
    else
    if FParams.Strings[LiCount].StartsWith('Charset=') then
      FCharset := Trim(FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1))
    else
    if FParams.Strings[LiCount].StartsWith('LibraryName=') then
      FLibraryName := Trim(FParams.Strings[LiCount].Substring(FParams.Strings[LiCount].IndexOf('=')+1))
    else
      FParamsEx.Add(Trim(FParams.Strings[LiCount].ToLower));

    addLog('Carregando parâmetro: '+FParams.Strings[LiCount]);
    Inc(LiCount);
  until LiCount = FParams.Count;
end;

procedure TChfDBConnection.addLog(const AMensagem: String);
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
