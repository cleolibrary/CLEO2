library cleo;

uses
  Sysutils, Windows, uCLEO2;

{$R *.RES}

procedure LoadCLEDLLs; stdcall;
var
  fs: TSearchRec;
begin
  if Sysutils.FindFirst('cleo\*.cleo', faAnyFile, fs) = 0 then
    repeat
      Windows.LoadLibrary(PChar('cleo\' + fs.name));
    until FindNext(fs) <> 0;
  Sysutils.FindClose(fs);
end;

var
  C: Integer;
begin
  if PLongInt(Ptr($008A6168))^ = $465E60 then
  begin
    isVersionOriginal := True;
    __CollectNumberParams := $464080;
    __WriteResult := $464370;
    __GetObjectPointer := $465040;
    __SetUserDirToCurrent := $538860;
    __Null := $858B54;
    __ChDir := $5387D0;
    __GetStringParam := $463D50;
    __fopen := $538900;
    __SetConditionResult := $4859D0;
    __fclose := $5389D0;
    __GetVariablePos := $464790;
    __BlockRead := $538950;
    __BlockWrite := $538970;
    __SetJumpLocation := $464DA0;

//    __LoadLibrary := $81E412;
//    __FreeLibrary := $81E502;
//    __GetProcAddress := $81E40C;
//    __GetFileSize := $81E418;
//    __VirtualProtect := $836C1C;

    CActors := $B74490;
    CVehicles := $B74494;
    CObjects := $B7449C;
    ParamsPtr[0] := $A43C78;
  end
  else
  begin
    isVersionOriginal := False;
    __CollectNumberParams := $464100;
    __WriteResult := $4643F0;
    __Null := $859B54;
    __GetObjectPointer := $4650C0;
    __ChDir := $538C70;
    __SetUserDirToCurrent := $538D00;
    __GetStringParam := $463DD0;
    __fopen := $538DA0;
    __SetConditionResult := $485A50;
    __fclose := $538E70;
    __GetVariablePos := $464810;
    __BlockRead := $538DF0;
    __BlockWrite := $538E10;
    __SetJumpLocation := $464E20;

//    __LoadLibrary := $81ED12;
//    __FreeLibrary := $81EE02;
//    __GetProcAddress := $81ED0C;
//    __VirtualProtect := $83750C;
//    __GetFileSize := $81ED18;

    CActors := $B76B10;
    CVehicles := $B76B14;
    CObjects := $B76B1C;
    ParamsPtr[0] := $A462F8;


  end;

  __GetCarPointer := $4048E0;
  __GetActorPointer := $404910;

  for C := 1 to 31 do
    ParamsPtr[c] := ParamsPtr[c - 1] + 4;

  if isVersionOriginal then
    PLongInt(Ptr($008A61D4))^ := Integer(@CLEO2)
  else
    PLongInt(Ptr($008A74BC))^ := Integer(@CLEO2);

  LoadCLEDLls;
end.

