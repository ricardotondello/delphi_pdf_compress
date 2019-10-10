unit uCompressPDF;

interface

uses
  System.SysUtils, uGhostScript, System.Classes;

type

  TCompressPDF = class
  private
    FsPathOutput: String;
    FsPathInput: String;
    function GetArgs: APAnsiChar;
    procedure AddArg(var poParams: APAnsiChar; const psParam: AnsiString);
    procedure WriteLog(const psMessage: String);
  public
    function Execute: Boolean;
    property PathOutput: String write FsPathOutput;
    property PathInput: String write FsPathInput;
  end;

implementation

function TCompressPDF.Execute: Boolean;
var
  oGS: TGhostScript;
begin
  result := False;
  try
    try
      oGS := TGhostScript.Create;

      oGS.ExecuteWithArgs(GetArgs);
      result := True;
    finally
      FreeAndNil(oGS);
    end;
  except
    on E: TExceptionGS do
    begin
      WriteLog(e.Message);
    end;
  end;
end;

function TCompressPDF.GetArgs: APAnsiChar;
var
  oArgs: APAnsiChar;
begin
  setlength(oArgs, 0);
  AddArg(oArgs, 'CompressPDF');
  AddArg(oArgs, '-dSAFER');
  AddArg(oArgs, '-dBATCH');
  AddArg(oArgs, '-dNOPAUSE');
  AddArg(oArgs, '-sDEVICE=pdfwrite');
  AddArg(oArgs, '-dPDFSETTINGS=/ebook');
  AddArg(oArgs, '-dCompressFonts=true \');
  AddArg(oArgs, '-dEmbedAllFonts=true \');
  AddArg(oArgs, '-dSubsetFonts=true \');
  AddArg(oArgs, '-dAutoRotatePages=/None');
  AddArg(oArgs, '-dDownsampleColorImages=true \');
  AddArg(oArgs, '-dDownsampleGrayImages=true \');
  AddArg(oArgs, '-dColorImageDownsampleThreshold=1.0 \');
  AddArg(oArgs, '-dGrayImageDownsampleThreshold=1.0 \');
  AddArg(oArgs, '-dMonoImageDownsampleThreshold=1.0 \');
  AddArg(oArgs, '-dNumRenderingThreads=8 \');
  AddArg(oArgs, '-sOutputFile=' + AnsiString(fsPathOutput));
  AddArg(oArgs, '-f');
  AddArg(oArgs, AnsiString(fsPathInput));
  result := oArgs;
end;

procedure TCompressPDF.WriteLog(const psMessage: String);
var
  oFile: TextFile;
  sPathLog: String;
  sPathDirectory: String;
begin
  if psMessage = EmptyStr then
    Exit;

  sPathDirectory := ParamStr(3);
  if sPathDirectory = EmptyStr then
    sPathDirectory := ExtractFilePath(ParamStr(0)) + 'logs\';
  sPathLog := sPathDirectory + ExtractFileName(ParamStr(1)) + '.log';

  ForceDirectories(sPathDirectory);
  try
    AssignFile(oFile, sPathLog);
    if FileExists(sPathLog) then
      Append(oFile)
    else
      Rewrite(oFile);
    WriteLn(oFile, DateTimeToStr(now) + ': Message: ' + psMessage);
  Finally
    CloseFile(oFile);
  end;
end;

procedure TCompressPDF.AddArg(var poParams: APAnsiChar; const psParam: AnsiString);
begin
  setlength(poParams, length(poParams) + 1);
  poParams[high(poParams)] := PAnsiChar(psParam);
end;

end.

