program GsCompressPDF;

{$APPTYPE CONSOLE}

{$R *.res}
{$IFDEF IMPLICITBUILDING This IFDEF should not be used by users}
{$ALIGN 1}
{$ASSERTIONS ON}
{$BOOLEVAL OFF}
{$DEBUGINFO ON}
{$EXTENDEDSYNTAX ON}
{$IMPORTEDDATA ON}
{$IOCHECKS ON}
{$LOCALSYMBOLS ON}
{$LONGSTRINGS ON}
{$OPENSTRINGS ON}
{$OPTIMIZATION OFF}
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}
{$DEFINITIONINFO ON}
{$SAFEDIVIDE OFF}
{$STACKFRAMES ON}
{$TYPEDADDRESS OFF}
{$VARSTRINGCHECKS ON}
{$WRITEABLECONST ON}
{$MINENUMSIZE 1}
{$IMAGEBASE $400000}
{$DEFINE DEBUG}
{$ENDIF IMPLICITBUILDING}
{$DESCRIPTION 'uCompressPDF'}
{$IMPLICITBUILD OFF}

{$R *.dres}

uses
  System.SysUtils,
  uCompressPDF in 'uCompressPDF.pas',
  uGhostScript in 'uGhostScript.pas';

var
  oCompressPDF: TCompressPDF;

begin
  if ParamCount <> 2 then
  begin
    Writeln('Invalid ParamCount. PathInput and PathOutput needed.');
    Halt(0);
  end;

  oCompressPDF := TCompressPDF.Create;
  oCompressPDF.PathInput := ParamStr(1);
  oCompressPDF.PathOutput := ParamStr(2);
  oCompressPDF.Execute;
end.


