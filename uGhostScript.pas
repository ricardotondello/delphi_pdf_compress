unit uGhostScript;

interface

uses
  WinApi.Windows, System.SysUtils, System.Classes;

const
  gsdll32 = 'gsdll32.dll';

type
  TExceptionGS = class(Exception);

  TGSAPIrevision = packed record
    product: PChar;
    copyright: PChar;
    revision: longint;
    revisiondat: longint;
  end;
  PGSAPIrevision = ^TGSAPIrevision;

  Pgs_main_instance = Pointer;
  APAnsiChar = array of PAnsiChar;

  TGhostScript = class
  private
    FnCode: Integer;
    instance: PGSAPIrevision;
    oDll: THandle;
    procedure LoadDLL;
    procedure NewInstance;
    procedure SetArgEncoding;
    procedure ExecuteGsapiExit;
    procedure DeleteInstance;
    procedure SaveDLLResToFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExecuteWithArgs(const psArgs: APAnsiChar);
  end;

implementation

const
  gsNameMutex = '{8499BD4E-23C5-4FAA-AA9E-AC455C89C1AC}';

var
  sTeste: String;
  goMutex: THandle;

{ TGhostScript }
constructor TGhostScript.Create;
begin
  SaveDLLResToFile;
  LoadDLL;
  NewInstance;
  SetArgEncoding;
end;

destructor TGhostScript.Destroy;
begin
  try
    ExecuteGsapiExit;
    DeleteInstance;
    FreeLibrary(oDll);
  finally
    ReleaseMutex(goMutex);
  end;
  inherited;
end;

procedure TGhostScript.LoadDLL;
begin
  oDll := LoadLibrary(gsdll32);
  if oDll = 0 then
    raise TExceptionGS.Create('Cannot load library (' + gsdll32 + ')');
end;

procedure TGhostScript.NewInstance;
var
  oFunction: function(pinstance: Pgs_main_instance; caller_handle: Pointer): integer; stdcall;
begin
  @oFunction := GetProcAddress(oDll, 'gsapi_new_instance');
  if @oFunction = nil then
    raise TExceptionGS.Create('Cannot execute gsapi_new_instance - @oFunction is nil');

  FnCode := oFunction(@instance, nil);
  if FnCode <> 0 then
    raise TExceptionGS.Create('Cannot attribute gsapi_new_instance to instance. ErrorCode: ' + IntToStr(FnCode));
end;

procedure TGhostScript.SetArgEncoding;
const
  GS_ARG_ENCODING_UTF8 = 1;
var
  oFunction: function(pinstance: Pgs_main_instance; ENCODING: Integer): integer; stdcall;
begin
  @oFunction := GetProcAddress(oDll, 'gsapi_set_arg_encoding');

  if @oFunction = nil then
    raise TExceptionGS.Create('Cannot execute gsapi_set_arg_encoding - @oFunction is nil');

  FnCode := oFunction(instance, GS_ARG_ENCODING_UTF8);
  if FnCode <> 0 then
    raise TExceptionGS.Create('Cannot attribute gsapi_set_arg_encoding to instance. ErrorCode: ' + IntToStr(FnCode));
end;

procedure TGhostScript.SaveDLLResToFile;
var
  sPathToSave: string;
  Res: TResourceStream;
begin
  sPathToSave := ExtractFilePath(ParamStr(0)) + '\GSDLL32.DLL';
  if FileExists(sPathToSave) then
    Exit;

  Res := TResourceStream.Create(Hinstance, 'GSDLL32', RT_RCDATA);
  try
    Res.SavetoFile(sPathToSave);
  finally
    Res.Free;
  end;
end;

procedure TGhostScript.ExecuteGsapiExit;
var
  oFunction: function(pinstance: Pgs_main_instance): integer; stdcall;
begin
  if oDll = 0 then
    Exit;
  @oFunction := GetProcAddress(oDll, 'gsapi_exit');
  if @oFunction = nil then
    raise TExceptionGS.Create('Cannot execute gsapi_exit');

  oFunction(instance);
end;

procedure TGhostScript.DeleteInstance;
var
  oFunction: procedure(pinstance: Pgs_main_instance); stdcall;
begin
  if oDll = 0 then
    Exit;
  @oFunction := GetProcAddress(oDll, 'gsapi_delete_instance');
  if @oFunction = nil then
    raise TExceptionGS.Create('Cannot execute gsapi_delete_instance');

  oFunction(instance);
end;

procedure TGhostScript.ExecuteWithArgs(const psArgs: APAnsiChar);
var
  oFunction:
   function(pinstance: Pgs_main_instance; argc: integer; argv: APAnsiChar): integer; stdcall;
begin
  @oFunction := GetProcAddress(oDll, 'gsapi_init_with_args');

  if @oFunction = nil then
  begin
    raise TExceptionGS.Create('Cannot execute gsapi_init_with_args - @oFunction is nil - args: ' + WideString(psArgs));
  end;

  FnCode := oFunction(instance, length(psArgs), psArgs);
  if FnCode <> 0 then
    raise TExceptionGS.Create('Cannot attribute gsapi_init_with_args into a instance. ErrorCode: ' + IntToStr(FnCode) +
    ' args: ' + WideString(psArgs));
end;

initialization
  goMutex := CreateMutex(nil, False, gsNameMutex);

finalization
  CloseHandle(goMutex);

end.

