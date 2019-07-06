unit uCLEO2;


interface uses
  SysUtils, Windows, SanApi, cmxMP3;


procedure CLEO2; stdcall

var
  __CollectNumberParams,
  __WriteResult,
    __GetActorPointer,
    __GetCarPointer,
    __GetObjectPointer,
    __SetUserDirToCurrent,
    __GetStringParam,
    __SetConditionResult,
    __GetVariablePos,
    __SetJumpLocation,
    __BlockRead, __BlockWrite,
    __Null, __ChDir, __fopen, __fclose,
    CActors, CVehicles, CObjects: LongInt;
  isVersionOriginal: ByteBool;
  ParamsPtr: array[0..31] of LongInt;

implementation


function LoadMp3(const APath: PChar): TcmxMp3; stdcall;
begin
  Result := TcmxMP3.Create(APath);
end;

procedure PerformMp3Action(const AMp3: TcmxMP3; const AFlag: Byte); stdcall;
begin
  case AFlag of
    0: AMp3.Stop;
    1: AMp3.Play;
    2: AMp3.Pause;
    3: AMp3.Resume;
  end;
end;

procedure ReleaseMp3(const AMp3: TcmxMP3); stdcall;
begin
  AMp3.Destroy;
end;

function GetMp3Length(const AMp3: TcmxMP3): Integer; stdcall;
begin
  Result := AMp3.LengthInSeconds;
end;


procedure CLEO2; stdcall
asm

   MOV  eax, [esp+4]
   SUB  ax, $0A8C
   JMP  dword ptr @@CLEOII_Pointers[eax*4]


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CLEO Pointers Table
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Pointers:
  DD @@CLEOII_Opcode0A8C  DD @@CLEOII_Opcode0A8D  DD @@CLEOII_Opcode0A8E  DD @@CLEOII_Opcode0A8F
  DD @@CLEOII_Opcode0A90  DD @@CLEOII_Opcode0A91  DD @@CLEOII_Opcode0A92  DD @@CLEOII_Opcode0A93
  DD @@CLEOII_Opcode0A94  DD @@CLEOII_Opcode0A95  DD @@CLEOII_Opcode0A96  DD @@CLEOII_Opcode0A97
  DD @@CLEOII_Opcode0A98  DD @@CLEOII_Opcode0A99  DD @@CLEOII_Opcode0A9A  DD @@CLEOII_Opcode0A9B
  DD @@CLEOII_Opcode0A9C  DD @@CLEOII_Opcode0A9D  DD @@CLEOII_Opcode0A9E  DD @@CLEOII_Opcode0A9F
  DD @@CLEOII_Opcode0AA0  DD @@CLEOII_Opcode0AA1  DD @@CLEOII_Opcode0AA2  DD @@CLEOII_Opcode0AA3
  DD @@CLEOII_Opcode0AA4  DD @@CLEOII_Opcode0AA5  DD @@CLEOII_Opcode0AA6  DD @@CLEOII_Opcode0AA7
  DD @@CLEOII_Opcode0AA8  DD @@CLEOII_Opcode0AA9  DD @@CLEOII_Opcode0AAA  DD @@CLEOII_Opcode0AAB
  DD @@CLEOII_Opcode0AAC  DD @@CLEOII_Opcode0AAD  DD @@CLEOII_Opcode0AAE  DD @@CLEOII_Opcode0AAF
  DD @@CLEOII_Opcode0AB0

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A8C
 0A8C: write_memory <dword> size <byte> value <dword> virtual_protect <bool>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A8C:

    PUSH   ebx
    PUSH   4
    CALL   [__CollectNumberParams]
    MOV    ebx, dword ptr ParamsPtr[3*4]
    CMP    byte ptr [ebx], 1
    JNZ    @0A8CMOV
    PUSH   4
    CALL   @@VirtualProtect
    POP    eax

    @0A8CMOV:
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    ecx, dword ptr [ParamsPtr[1*4]]
    MOV    eax, dword ptr [ParamsPtr[2*4]]
    MOV    edx, [edx] // address
    MOV    ecx, [ecx] // size
    MOV    eax, [eax] // value
    CMP    ecx, 1
    JNZ    @0A8CW
    MOV    byte ptr [edx], al
    JMP    @0A8CVP

    @0A8CW:
    CMP    ecx, 2
    JNZ    @0A8CDW
    MOV    word ptr [edx], ax
    JMP    @0A8CVP

    @0A8CDW:
    MOV    dword ptr [edx], eax

    @0A8CVP:
    CMP    dword ptr [ebx], 1
    JNZ    @ret
    MOV    eax, dword ptr [ParamsPtr[31*4]]
    PUSH [ eax]
    CALL   @@VirtualProtect
    POP    eax

    @RET:
    POP    ebx
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 CLEO 2 Virtual Protect Subroutine
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@VirtualProtect:
    PUSH   dword ptr [ParamsPtr[31*4]]
    PUSH   [esp+8]
    MOV    eax, dword ptr [ParamsPtr[1*4]]
    PUSH   [eax]
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]
    CALL   VirtualProtect
    RET

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A8D
 0A8D: <var> = read_memory <dword> size <byte> virtual_protect <bool>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A8D:

    PUSH   ebx
    PUSH   3
    CALL   [__CollectNumberParams]
    MOV    ebx, dword ptr [ParamsPtr[2*4]]
    CMP    [ebx], 1
    JNZ    @0A8D_GET_PARAMS
    PUSH   4
    CALL   @@VirtualProtect
    POP    eax

    @0A8D_GET_PARAMS:
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    MOV    eax, [eax]
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], 0
    MOV    ecx, dword ptr [ParamsPtr[1*4]]
    CMP    [ecx], 1
    JNZ    @0A8D_WORD
    MOV    al, [eax]
    MOV    [edx], al
    JMP    @0A8D_VIRTUAL_PROTECT

    @0A8D_WORD:
    CMP    [ecx], 2
    JNZ    @0A8D_DWORD
    MOV    ax, [eax]
    MOV    [edx], ax
    JMP    @0A8D_VIRTUAL_PROTECT

    @0A8D_DWORD:
    MOV    eax, [eax]
    MOV    [edx], eax

    @0A8D_VIRTUAL_PROTECT:
    CMP    [ebx], 1
    JNZ    @0A8D_WRITE_RESULT
    MOV    eax, dword ptr [ParamsPtr[31*4]]
    PUSH   [eax]
    CALL   @@VirtualProtect
    POP    eax

    @0A8D_WRITE_RESULT:
    PUSH   1
    MOV    ecx, esi
    CALL   [__WriteResult]
    POP    ebx
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A8E
  0A8E: (1) = (2) + (3) // int
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A8E:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A8F
  0A8F: (1) = (2) - (3) // int
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A8F:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A90
  0A90: (1) = (2) * (3) // int
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A90:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A91
  0A91: (1) = (2) / (3) // int
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A91:

    PUSH   eax
    PUSH   2
    CALL   [__CollectNumberParams]
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    MOV    eax, [eax]
    MOV    edx, dword ptr [ParamsPtr[1*4]]
    MOV    edx, [edx]
    POP    ecx
    SUB    ecx, 2
    JMP    dword ptr @OPCODES_0A8E_0A8E_TABLE[ecx*4]

@OPCODES_0A8E_0A8E_TABLE:
DD @opcode0A8E, @opcode0A8F, @opcode0A90, @opcode0A91

    // ADD EAX, EDX
    @opcode0A8E:
    JNZ    @opcode0A8F
    ADD    eax, edx
    JMP    @0A8E_WRITE_RESULT

    // SUB EAX, EDX
    @opcode0A8F:
    JNZ    @opcode0A90
    SUB    eax, edx
    JMP    @0A8E_WRITE_RESULT

    // MUL EAX, EDX
    @opcode0A90:
    JNZ    @opcode0A91
    IMUL   edx
    JMP    @0A8E_WRITE_RESULT

    // DIV EAX, P2
    @opcode0A91:
    CDQ
    MOV    ecx, dword ptr [ParamsPtr[1*4]]
    IDIV   [ecx]

    @0A8E_WRITE_RESULT:
    MOV    ecx, dword ptr [ParamsPtr[0*4]]
    MOV    [ecx], eax
    PUSH   1
    MOV    ecx, esi
    CALL   [__WriteResult]
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A92
  0A92: (1) = (2) + (3) // float
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A92:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A93
  0A93: (1) = (2) - (3) // float
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A93:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A94
  0A94: (1) = (2) * (3) // float
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A94:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A95
  0A95: (1) = (2) / (3) // float
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A95:

    XOR al, al
    RET 4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A96
  0A96: (1) = actor (2) struct
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A96:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A97
  0A97: (1) = car (2) struct
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A97:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A98
  0A98: (1) = object (2) struct
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A98:
    PUSH   eax
    PUSH   1
    CALL   [__CollectNumberParams]
    POP    ecx
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]

    SUB    ecx, 10
    JMP    dword ptr @OPCODES_0A96_0A98_TABLE[ecx*4]

@OPCODES_0A96_0A98_TABLE:
DD @opcode0A96, @opcode0A97, @opcode0A98

    // 0A96:   ACTOR.STRUCT
@opcode0A96:
    MOV    ecx, [CActors]
    MOV    ecx, [ecx]
    CALL   [__GetActorPointer]
    JMP    @0A98_WRITE_RESULT
    // 0A97:   CAR.STRUCT
@opcode0A97:
    MOV    ecx, [CVehicles]
    MOV    ecx, [ecx]
    CALL   [__GetCarPointer]
    JMP    @0A98_WRITE_RESULT
    // 0A98:   OBJECT.STRUCT
@opcode0A98:
    MOV    ecx, [CObjects]
    MOV    ecx, [ecx]
    CALL   [__GetObjectPointer]
@0A98_WRITE_RESULT:
    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax
    CALL   [__WriteResult]
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A99
  0A99: chdir <flag>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A99:
    PUSH   1
    CALL   [__CollectNumberParams]
    // TEST flag
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    MOV    eax, [eax]
    TEST   eax, eax
    JZ     @opcode0A99_Root
    CMP    eax, 1
    JNZ    @opcode0A99_Exit
    // FLAG=1; UserDir
    CALL   [__SetUserDirToCurrent]
    JMP    @opcode0A99_Exit
    // FLAG=0; RootDir
@opcode0A99_Root:
    PUSH   __Null
    CALL   [__ChDir]
    ADD    esp, 4
@opcode0A99_Exit:
    XOR    al, al
    RET    4



{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A9A
  0A9A: <var> = openfile "path" mode <dword>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A9A:
    SUB    esp, 128
    PUSH   100
    LEA    eax, [esp+4]
    PUSH   eax

    CALL   [__GetStringParam]
    PUSH   1
    MOV    ecx, esi
    CALL   [__CollectNumberParams]

    PUSH   dword ptr [ParamsPtr[0*4]]
    LEA    eax, [esp+4]
    PUSH   eax

    CALL   [__fopen]

    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax
    XOR    edx, edx
    TEST   eax, eax
    SETNZ  dl
    PUSH   edx
    CALL   [__SetConditionResult]
    CALL   [__WriteResult]


    ADD    esp, 136
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A9B
  0A9B: closefile <hFile>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A9B:
    PUSH   1
    CALL   [__CollectNumberParams]
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]
    CALL   [__fclose]
    POP    eax
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A9C
  0A9C: <var> = file <hFile> size
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A9C:
    PUSH   1
    CALL   [__CollectNumberParams]
    PUSH   0
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]
    CALL   GetFileSize
    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax
    CALL   [__WriteResult]
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A9D
  0A9D: readfile <hFile> size <dword> to <var>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A9D:
{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A9E
  0A9E: writefile <hFile> size <dword> from <var>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A9E:
    PUSH   eax
    PUSH   2
    CALL   [__CollectNumberParams]
    PUSH   2
    CALL   [__GetVariablePos]
    POP    ecx
    MOV    edx, dword ptr [ParamsPtr[1*4]]
    PUSH   [edx]
    PUSH   eax
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    PUSH   [edx]
    CMP    ecx, 17
    JNZ    @opcode0A9E
    CALL   [__BlockRead]
    JMP    @opcode0A9E_Exit

@opcode0A9E:
    CALL   [__BlockWrite]

@opcode0A9E_Exit:
    ADD    esp, 12
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0A9F
  0A9F: <var> = current_thread_address
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0A9F:
    PUSH   1
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], esi
    CALL   [__WriteResult]
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA0
  0AA0: gosub_if_false <label>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA0:

    PUSH   1
    CALL   [__CollectNumberParams]
    MOV    al, [esi+$C5]
    TEST   al, al
    JNZ    @Opcode0AA0_True

    MOVZX  eax, [esi+$38]
    MOV    edx, [esi+$14]
    MOV    [esi+eax*4+$18], edx
    INC    word ptr [esi+$38]
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]
    CALL   [__SetJumpLocation]

@Opcode0AA0_True:
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA1
  0AA1: return_if_false
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA1:

    MOV    al, [esi+$C5]
    TEST   al, al
    JNZ    @Opcode0AA1_True

    DEC    word ptr [esi+$38]
    MOVZX  eax, [esi+$38]
    MOV    edx, [esi+eax*4+$18]
    MOV    [esi+$14], edx

@Opcode0AA1_True:
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA2
  0AA2: <var> = load_library <path>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA2:
    SUB    esp, 128
    PUSH   100
    LEA    eax, [esp+4]
    PUSH   eax
    CALL   [__GetStringParam]
    LEA    eax, [esp+0]
    PUSH   eax
    CALL   LoadLibrary

    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax
    XOR    edx, edx
    TEST   eax, eax
    SETNZ  dl
    PUSH   edx
    CALL   [__SetConditionResult]
    CALL   [__WriteResult]
    ADD    esp, 128
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA3
  0AA3: free_library <hLib>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA3:
    PUSH   1
    CALL   [__CollectNumberParams]
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]
    CALL   FreeLibrary
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA4
  0AA4: <var> = get_proc_address "name" library <hLib>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA4:
    SUB    esp, 128
    PUSH   100
    LEA    eax, [esp+4]
    PUSH   eax
    CALL   [__GetStringParam]
    PUSH   1
    MOV    ecx, esi
    CALL   [__CollectNumberParams]

    LEA    eax, [esp+0]
    PUSH   eax
    MOV    eax, dword ptr [ParamsPtr[0*4]]
    PUSH   [eax]
    CALL   GetProcAddress

    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax

    XOR    edx, edx
    TEST   eax, eax
    SETNZ  dl
    PUSH   edx
    CALL   [__SetConditionResult]
    CALL   [__WriteResult]
    ADD    esp, 128
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA5
  0AA5: call <address> num_params <byte> pop <byte> [param1, param2...]
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA5:
    PUSH    3
    CALL    [__CollectNumberParams]
    PUSH    ebx
    PUSH    edi
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    MOV     ebx, [eax]
    MOV     eax, dword ptr [ParamsPtr[1*4]]
    MOV     edi, [eax]

    @Opcode0AA5Loop:
    TEST    edi, edi
    JZ      @Opcode0AA5Call
    PUSH    1
    CALL    [__CollectNumberParams]
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    PUSH    [eax]
    DEC     edi
    JMP     @Opcode0AA5Loop

    @Opcode0AA5Call:
    CALL    EBX

    MOV     eax, dword ptr [ParamsPtr[2*4]]
    MOV     eax, [eax]
    IMUL    eax, 4
    ADD     esp, EAX

    POP     edi
    POP     ebx
    INC     dword ptr [esi+$14]
    XOR     al, al
    RET     4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA6
  0AA6: call_method <address> struct <address> num_params <byte> pop <byte> [param1, param2...]
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA6:
    PUSH    3
    CALL    [__CollectNumberParams]
    PUSH    ebx
    PUSH    edi
    PUSH    ecx
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    MOV     ebx, [eax]
    MOV     eax, dword ptr [ParamsPtr[2*4]]
    MOV     edi, [eax]

    @Opcode0AA6Loop:
    TEST    edi, edi
    JZ      @Opcode0AA6Call
    PUSH    1
    CALL    [__CollectNumberParams]
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    PUSH    [eax]
    DEC     edi
    JMP     @Opcode0AA6Loop

    @Opcode0AA6Call:
    MOV     ecx, dword ptr [ParamsPtr[1*4]]
    MOV     ecx, [ecx]
    CALL    EBX

    MOV     eax, dword ptr [ParamsPtr[3*4]]
    MOV     eax, [eax]
    IMUL    eax, 4
    ADD     esp, EAX
    POP     ecx
    POP     edi
    POP     ebx
    INC     dword ptr [esi+$14]
    XOR     al, al
    RET     4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA7
  0AA7: call_function <address> num_params <byte> pop <byte> [param1, param2...] result <var>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA7:
    PUSH    3
    CALL    [__CollectNumberParams]
    PUSH    ebx
    PUSH    edi
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    MOV     ebx, [eax]
    MOV     eax, dword ptr [ParamsPtr[1*4]]
    MOV     edi, [eax]

    @Opcode0AA7Loop:
    TEST    edi, edi
    JZ      @Opcode0AA7Call
    PUSH    1
    CALL    [__CollectNumberParams]
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    PUSH    [eax]
    DEC     edi
    JMP     @Opcode0AA7Loop

    @Opcode0AA7Call:
    CALL    EBX
    PUSH    1
    MOV     ecx, esi
    MOV     edx, dword ptr [ParamsPtr[0*4]]
    MOV     [edx], eax
    CALL    [__WriteResult]

    MOV     eax, dword ptr [ParamsPtr[2*4]]
    MOV     eax, [eax]
    IMUL    eax, 4
    ADD     esp, EAX

    POP     edi
    POP     ebx
    INC     dword ptr [esi+$14]
    XOR     al, al
    RET     4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA8
  0AA8: call_function_method <address> num_params <byte> pop <byte> [param1, param2...] result <var>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA8:
    PUSH    3
    CALL    [__CollectNumberParams]
    PUSH    ebx
    PUSH    edi
    PUSH    ecx
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    MOV     ebx, [eax]
    MOV     eax, dword ptr [ParamsPtr[2*4]]
    MOV     edi, [eax]

    @Opcode0AA8Loop:
    TEST    edi, edi
    JZ      @Opcode0AA8Call
    PUSH    1
    CALL    [__CollectNumberParams]
    MOV     eax, dword ptr [ParamsPtr[0*4]]
    PUSH    [eax]
    DEC     edi
    JMP     @Opcode0AA8Loop

    @Opcode0AA8Call:
    MOV     ecx, dword ptr [ParamsPtr[1*4]]
    MOV     ecx, [ecx]
    CALL    EBX
    PUSH    1
    MOV     ecx, esi
    MOV     edx, dword ptr [ParamsPtr[0*4]]
    MOV     [edx], eax
    CALL    [__WriteResult]

    MOV     eax, dword ptr [ParamsPtr[3*4]]
    MOV     eax, [eax]
    IMUL    eax, 4
    ADD     esp, EAX
    POP     ecx
    POP     edi
    POP     ebx
    INC     dword ptr [esi+$14]
    XOR     al, al
    RET     4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AA9
  0AA9:   is_game_version_original
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AA9:

    XOR    edx, edx
    mov    al, isVersionOriginal
    TEST   al, al
    SETNZ  dl
    PUSH   edx
    CALL   [__SetConditionResult]
    XOR     al, al
    RET     4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AAA
  reserved
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AAA:

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AAB
  0AAB:  file_exists "path"
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AAB:
    SUB    esp, 128
    PUSH   100
    LEA    eax, [esp+4]
    PUSH   eax
    CALL   [__GetStringParam]

    LEA    eax, [esp+0]
    PUSH   eax
    CALL   FileExists

    MOV    ecx, esi
    XOR    edx, edx
    TEST   al, al
    SETNZ  dl
    PUSH   edx
    CALL   [__SetConditionResult]
    ADD    esp, 132
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AAC
  0AAC:  %2d% = load_mp3 "path"
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AAC:
    SUB    esp, 128
    PUSH   100
    LEA    eax, [esp+4]
    PUSH   eax
    CALL   [__GetStringParam]

    LEA    eax, [esp+0]
    PUSH   eax
    call   LoadMp3

    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax
    CALL   [__WriteResult]
    ADD    esp, 128
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AAD
  0AAD: set_mp3 %1d% perform_action %2d%
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AAD:
    PUSH   2
    CALL   [__CollectNumberParams]
    MOV    eax, dword ptr [ParamsPtr[1*4]]
    PUSH   [eax] // aFlag
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    PUSH   [edx] // aMP3
    CALL   PerformMp3Action
    XOR    al, al
    RET    4


{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AAE
  0AAE: release_mp3 %1d%
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AAE:
    PUSH   1
    CALL   [__CollectNumberParams]
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    PUSH   [edx] // aMP3
    CALL   ReleaseMp3
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AAF
  0AAF: %2d% = get_mp3_length %1d%
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AAF:
    PUSH   1
    CALL   [__CollectNumberParams]
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    PUSH   [edx] // aMP3
    CALL   GetMp3Length
    PUSH   1
    MOV    ecx, esi
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    MOV    [edx], eax
    CALL   [__WriteResult]
    XOR    al, al
    RET    4

{
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Opcode 0AB0
  0AB0:  key_pressed %1d%
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
@@CLEOII_Opcode0AB0:
    PUSH   1
    CALL   [__CollectNumberParams]
    MOV    edx, dword ptr [ParamsPtr[0*4]]
    PUSH   [edx]
    CALL   KeyPressed
    MOV    ecx, esi
    PUSH   eax
    CALL   [__SetConditionResult]
    XOR    al, al
    RET    4
  end;



end.

