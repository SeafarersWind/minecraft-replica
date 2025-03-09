;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;extern
 
 extern _ExitProcess@4
 
 extern _GetStdHandle@4
 extern _WriteFile@20
 extern _ReadFile@20
 extern _FlushFileBuffers@4
 
 extern _Sleep@4
 extern _CreateSolidBrush@4
 
 extern _CreateWindowExA@48
 extern _DefWindowProcA@16
 extern _DispatchMessageA@4
 extern _PeekMessageA@20
 extern _GetModuleHandleA@4
 extern _IsDialogMessageA@8
 extern _LoadIconA@8
 extern _LoadCursorA@8
 extern _PostQuitMessage@4
 extern _RegisterClassExA@4
 extern _ShowWindow@8
 extern _TranslateMessage@4
 extern _UpdateWindow@4
 extern _MessageBoxA@16
 extern _SetTimer@16
 extern _GetSystemTimeAsFileTime@4
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 %define f(x)  (__?float32?__(x))
 %define d(x)  (__?float64?__(x))
 %define dl(x) ((__?float64?__(x))&0xFFFFFFFF)
 %define dh(x) ((__?float64?__(x))>>32)
 %define tl(x) ((__?float80m?__(x))&0xFFFFFFFF)
 %define tm(x) ((__?float80m?__(x))>>32)
 %define th(x) (__?float80e?__(x))
 
 %define u(x) (__?utf16?__(x))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Startup/Shutdown
 
 STD_OUTPUT_HANDLE EQU -11
 STD_INPUT_HANDLE  EQU -10
 NULL              EQU 0
 
 section .bss
 _StdOutHandle resd 1
 _StdInHandle  resd 1
 _Instance     resd 1
 _buffer       resd 1152
 _zeros        resd 1024
 _debug resd 1
 
 section .data
 float2 dd 2.0
 float1_62 dd 1.62
 float0_01 dd 0.01
 tloat0_005 dt 0.005
 tloat0_02 dt 0.02
 qloat256 dq 256.0
 qloat64  dq 64.0
 tloat3 dt 3.0
 
 section .text
 fStartup:
  push  STD_OUTPUT_HANDLE						; 
  call  _GetStdHandle@4							; 
  mov   dword[_StdOutHandle],eax				; 
  
  push  STD_INPUT_HANDLE						; 
  call  _GetStdHandle@4							; 
  mov   dword[_StdInHandle],eax					; 
  
  push  NULL									; 
  call  _GetModuleHandleA@4						; 
  mov   dword[_Instance],eax					; 
  
  mov   dword[DtRngSeed],0x12345678
  
  call fRandgaussianinit
  
  ret
 
 fShutdown:										;
  section .data									;
  .t db "Quit..."								;
  section .text									;
  
  push  0										;
  push  _buffer									;
  push  7										;
  push  .t										;
  push  dword[_StdOutHandle]					;
  call  _WriteFile@20							;
  
  ;push 2000										;
  ;call _Sleep@4									;
  
  push  dword 0									;
  call  _ExitProcess@4							;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Print
 
 EM    EQU 0
 LN    EQU 10
 PS    EQU 255
 
 section .text
 fPrint:										; eax string to write
  xor   ebx,ebx									; [esp+4] special print parameters
  jmp   fPrintLengthLs
  fPrintLengthL:
   inc   eax
   inc   ebx
  fPrintLengthLs:
   cmp   byte [eax],PS
   je    fPrintSpecial
   cmp   byte [eax],EM
   jne   fPrintLengthL
  sub eax,ebx
  												
  push  NULL									; 5th parameter - overlapped structure (null)
  push  _buffer								; 4th parameter - # of bytes written
  push  ebx										; 3rd parameter - # of bytes to write
  push  eax										; 2nd parameter - string to write from
  push  dword[_StdOutHandle]						; 1st parameter - handle
  call  _WriteFile@20							; call
  
  ret
  
   section .bss
   fPrintRet  resd 1
   fPrintResa resd 1
   section .text
  
  fPrintSpecial:
   push  eax
   sub   eax,ebx								; print what's so far
   push  NULL									;
   push  _buffer								;
   push  ebx									;
   push  eax									;
   push  dword [_StdOutHandle]					;
   call  _WriteFile@20							;
   pop   eax
   
   pop   dword [fPrintRet]						; preserve return address
   inc   eax
   mov   [fPrintResa],eax						; preserve string location
   
   xor   ebx,ebx								; table the index
   mov   bl,byte[eax]							;
   shl   bx,2									;
   add   ebx,fPrintSpecialTable					;
   call  dword[ebx]								; call special print function
   
   push  dword [fPrintRet]						; restore return address
   mov   eax,[fPrintResa]						; restore string location
   inc   eax
   
   jmp fPrint									; print the rest

   section .data
   fPrintSpecialTable:
   dd    fPrintstr		;00
   dd    fPrintdec		;01
   dd    fPrinthex32	;02
   dd    fPrintbin32	;03
   dd    fPrinthex16	;04
   dd    fPrintbin16	;05
   dd    fPrinthex8 	;06
   dd    fPrintbin8 	;07
   dd    fSleep			;08
   dd    fPrintchar		;09
   						;...
   						;FE
   PSSTRNG equ 0
   PSDEC   equ 1
   PSHEX32 equ 2
   PSBIN32 equ 3
   PSHEX16 equ 4
   PSBIN16 equ 5
   PSHEX8  equ 6
   PSBIN8  equ 7
   PSSLP   equ 8
   PSCHAR  equ 9
   section .text
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;str
 
 fPrintstr:										; [esp+4] string address
  mov   eax,[esp+4]
  xor   ebx,ebx
  jmp   fPrintstrLengthLs
  fPrintstrLengthL:
   inc   eax
   inc   ebx
  fPrintstrLengthLs:
   cmp   byte [eax],EM
   jne   fPrintstrLengthL
  sub eax,ebx
  
  push  NULL
  push  _buffer
  push  ebx
  push  eax
  push  dword[_StdOutHandle]
  call  _WriteFile@20
  
  ret   4
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;dec
 
 fPrintdec:										; [esp+4] number
  mov   ebx,fPrintbaseString					;ebx character position
  mov   eax,dword[esp+4]						;eax number
  
  test  eax,2147483648	;sign
  jns   fPrintdecSignD							; sign
   mov   byte[ebx],"-"
   inc   ebx
   not   eax
   inc   eax
  fPrintdecSignD:
  
  mov   ecx,1									; get the digit to divide by
  cmp   eax,10									;
  jl    fPrintdecDivL1							;
   mov   ecx,10									;
  cmp   eax,100									;
  jl    fPrintdecDigitD							;
   mov   ecx,100								;
  cmp   eax,1000								;
  jl    fPrintdecDigitD							;
   mov   ecx,1000								;
  cmp   eax,10000								;
  jl    fPrintdecDigitD							;
   mov   ecx,10000								;
  cmp   eax,100000								;
  jl    fPrintdecDigitD							;
   mov   ecx,100000								;
  cmp   eax,1000000								;
  jl    fPrintdecDigitD							;
   mov   ecx,1000000							;
  cmp   eax,10000000							;
  jl    fPrintdecDigitD							;
   mov   ecx,10000000							;
  cmp   eax,100000000							;
  jl    fPrintdecDigitD							;
   mov   ecx,100000000							;
  cmp   eax,1000000000							;
  jl    fPrintdecDigitD							;
   mov   ecx,1000000000							;
  fPrintdecDigitD:								;
  
  fPrintdecDivL:
   xor   edx,edx								; divide and build the string
   div   ecx									;
  fPrintdecDivL1:
   add   al,"0"									;
   mov   byte[ebx],al							;
   inc   ebx									;
   push  edx									;
   mov   eax,ecx								;
   mov   ecx,10									;
   xor   edx,edx								;
   div   ecx									;
   mov   ecx,eax								;
   pop   eax									;
   cmp   ecx,1									;
   jae   fPrintdecDivL							;
 
  sub ebx,fPrintbaseString
  push  NULL									; print the decimal number
  push  _buffer									;
  push  ebx										;
  push  fPrintbaseString						;
  push  dword[_StdOutHandle]					;
  call  _WriteFile@20							;
  
  ret   4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;hex/bin
 
 fPrinthex32:									; [esp+4] number
  mov   cl,8									;ecx # of digits
  mov   ebx,fPrintbaseString					;ebx character position
  mov   eax,dword[esp+4]						;eax number
  												
  fPrinthex32L:									; shift and build the string
   xor   dl,dl									;
   shld  edx,eax,4								;
   shl   eax,4									
   cmp   dl,10									; 0-9 or A-F
   jae   fPrinthex32LLet						;
    add   dl,"0"								;
   jmp   fPrinthex32LNumD						;
   fPrinthex32LLet:								;
    add   dl,"A"-10								;
   fPrinthex32LNumD:							;
   mov   byte[ebx],dl							; put character
   inc   ebx									;
   dec   cl										;
   jnz   fPrinthex32L							;
   
   push  NULL
   push  _buffer
   push  8
   push  fPrintbaseString
   push  dword[_StdOutHandle]
   call  _WriteFile@20
  
  ret   4
 
 
 
 fPrintbin32:									; [esp+4] number
  mov   cl,32									;ecx # of digits
  mov   ebx,fPrintbaseString					;ebx character position
  mov   eax,dword[esp+4]						;eax number
  												
  fPrintbin32L:									; shift and build the string
   xor   dl,dl									;
   shld  edx,eax,1								;
   shl   eax,1									;
   add   dl,"0"									;
   mov   byte[ebx],dl							; put character
   inc   ebx									;
   dec   cl										;
   jnz   fPrintbin32L							;
  
  push  NULL
  push  _buffer
  push  32
  push  fPrintbaseString
  push  dword[_StdOutHandle]
  call  _WriteFile@20
  
  ret   4
 
 
 
 fPrinthex16:									; [esp+4] number
  mov   cl,4									;ecx # of digits
  mov   ebx,fPrintbaseString					;ebx character position
  mov   ax,word[esp+4]							;eax number
  												
  fPrinthex16L:									; shift and build the string
   xor   dl,dl									;
   shld  dx,ax,4								;
   shl   ax,4									;
   cmp   dl,10									; 0-9 or A-F
   jae   fPrinthex16LLet						;
    add   dl,"0"								;
   jmp   fPrinthex16LNumD						;
   fPrinthex16LLet:								;
    add   dl,"A"-10								;
   fPrinthex16LNumD:							;
   mov   byte[ebx],dl							; put character
   inc   ebx									;
   dec   cl										;
   jnz   fPrinthex16L							;
  
  push  NULL
  push  _buffer
  push  4
  push  fPrintbaseString
  push  dword[_StdOutHandle]
  call  _WriteFile@20
  
  ret   4



 fPrintbin16:									; [esp+4] number
  mov   cl,16									;ecx # of digits
  mov   ebx,fPrintbaseString					;ebx character position
  mov   ax,word[esp+4]							;eax number
  												
  fPrintbin16L:									; shift and build the string
   xor   dl,dl									;
   shld  dx,ax,1								;
   shl   ax,1									;
   add   dl,"0"									;
   mov   byte[ebx],dl							; put character
   inc   ebx									;
   dec   cl										;
   jnz   fPrintbin16L							;
  
  push  NULL
  push  _buffer
  push  16
  push  fPrintbaseString
  push  dword[_StdOutHandle]
  call  _WriteFile@20
  
  ret   4
 
 
 
 fPrinthex8:									; [esp+4] number
  mov   cl,2									;ecx # of digits
  mov   ebx,fPrintbaseString					;ebx character position
  mov   al,byte[esp+4]							;eax number
  
  fPrinthex8L:									; shift and build the string
   xor   ah,ah									;
   shl   ax,4									;
   cmp   ah,10									; 0-9 or A-F
   jae   fPrinthex8LLet							;
    add   ah,"0"								;
   jmp   fPrinthex8LNumD						;
   fPrinthex8LLet:								;
    add   ah,"A"-10								;
   fPrinthex8LNumD:								;
   mov   byte[ebx],ah							; put character
   inc   ebx									;
   dec   cl										;
   jnz   fPrinthex8L							;
  
 push  NULL
 push  _buffer
 push  2
 push  fPrintbaseString
 push  dword[_StdOutHandle]
 call  _WriteFile@20
 
 ret   4
 
 
 
 fPrintbin8:									; [esp+4] number
  mov   cl,8									;ecx # of digits
  mov   ebx,fPrintbaseString					;ebx character position
  mov   al,byte[esp+4]							;eax number
  
  fPrintbin8L:									; shift and build the string
   xor   ah,ah									;
   shl   ax,1									;
   add   ah,"0"									;
   mov   byte[ebx],ah							; put character
   inc   ebx									;
   dec   cl										;
   jnz   fPrintbin8L							;
  
   push  NULL
   push  _buffer
   push  8
   push  fPrintbaseString
   push  dword[_StdOutHandle]
   call  _WriteFile@20
   
   ret   4
  
   section .bss
   fPrintbaseString resb 32
   section .text
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;float
 
 fPrintfloats:									;
  pop  eax										;return
  pop  ebx										;f
  pop  ecx										;f
  pop  dx										;f
  push eax										;f
  push dx										;f
  push ecx										;f
  push ebx										;return
  
  jmp fPrintfloat1
 
 fPrintfloat:									;
  sub esp,10									;
  fstp tword[esp]								;[esp] float
  
  fPrintfloat1:
  
 ;push dword[esp]
 ;push dword[esp+4+4]
 ;xor  eax,eax
 ;mov  ax,[esp+8+8]
 ;push eax
 ;call fPrinthex16
 ;call fPrinthex32
 ;call fPrinthex32
 ;push dword[tChars+LN]
 ;call fPrintchar
  
  mov  ax,[esp+8]	;bytes 8-9					;ax exponent
  and  ax,0x7FFF								;
  cmp  ax,0x7FFF								;
  je   .nan										;
  
  times 1024 push 0								; allocate space
  
  inc  ax										;
  xor  dx,dx									;
  mov  bx,32									;
  div  bx										;
  xor  esi,esi									;
  mov  si,ax									;si index
  mov  cl,dl									;cl shift
  inc  cl										;
  
  mov  eax,[esp+1024*4]		;bytes 0-3			;eax lo
  mov  ebx,[esp+1024*4+4]	;bytes 4-7			;ebx hi
  xor  edx,edx									;
  shld edx,ebx,cl								;
  shld ebx,eax,cl								;
  shl  eax,cl									;
  shl  esi,2									;
  add  esi,esp									;
  mov  [esi-8],eax								;[esp] bignum
  mov  [esi-4],ebx								;
  mov  [esi],edx								;
  
  mov  byte[_buffer+512],"."					;
  mov  edi,_buffer+512							;edi string
  
  add  esp,512*4								;[esp] bignum center
  cmp  esi,esp									;
  jb   .fractionpoint							;
  
  
  .wholeL:										;esi bignum top
   mov  ebx,esi									;ebx bignum dividing
   xor  edx,edx									;edx remainder
   mov  ecx,1000000000							;ecx 1000000000
   .wholeLL:									;
    mov  eax,[ebx]								;
    div  ecx									;
    mov  [ebx],eax								;
    sub  ebx,4									;
    cmp  ebx,esp								;
    jae  .wholeLL								;
   mov  eax,edx									;eax remainder
   mov  ecx,10									;ecx 10
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-1],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-2],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-3],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-4],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-5],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-6],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-7],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-8],dl								;char to string
   xor  edx,edx									;
   div  ecx										;
   add  dl,"0"									;
   mov  [edi-9],dl								;char to string
   sub  edi,9									;
   test dword[esi],~0							;
   jne  .wholeL									;
   sub  esi,4									;
   cmp  esi,esp									;
   jae  .wholeL									;
  .wholeextrazerosL:							;
   cmp  byte[edi],"0"							;
   jne  .wholeextrazerosLD						;
   inc  edi										;
   jmp  .wholeextrazerosL						;
   .wholeextrazerosLD:							;
  
  .sign:										;
  test byte[esp+512*4+9],0x80	;byte 9			;
  je   .negativeD								;
   .negative:									;
   dec  edi										;
   mov  byte[edi],"-"							; negative
   .negativeD:									;
  mov  [_buffer],edi							;[_buffer] string bottom
  
  mov  edi,_buffer+512							;edi string
  mov  esi,esp									;
  sub  esi,512-4								;
  .lowestL:										;
   add  esi,4									; pass over zeros
   cmp  esi,esp									;
   jae	.nofraction								;
   test dword[esi],~0							;
   je   .lowestL								;
  
  sub  esp,4									;esp bignum fraction top
  .fractionL:									;esi bignum bottom
   mov  ebx,esi									;ebx bignum multiplying
   xor  edx,edx									;edx carry
   cmp  ebx,esp									;
   jae  .fractionLLD							;
   .fractionLL:									; multiply each limb by 1000000000 and add the carry
    mov  ecx,1000000000							;ecx 1000000000
    push edx									;
    mov  eax,[ebx]								;
    mul  ecx									;edx carry
    pop  ecx									;ecx previous carry
    add  eax,ecx								;
    mov  [ebx],eax								;
    add  ebx,4									;
    cmp  ebx,esp								;
    jb   .fractionLL							;
    .fractionLLD:								;
   push edx										; multiply [ebx] by 10 nine times
   xor  edx,edx									;edx decimal digits
   mov  eax,[ebx]								;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+1],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+2],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+3],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+4],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+5],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+6],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+7],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+8],edx								;
   xor  dl,dl									;
   mov  ecx,eax									;;*10
   shld edx,eax,2								;;
   shl  eax,2									;;
   add  eax,ecx									;;
   adc  dl,0									;;
   shld edx,eax,1								;;
   shl  eax,1									;;
   add  dl,"0"									;
   mov  [edi+9],edx								;
   xor  dl,dl									;
   add  edi,9									;
   pop  ecx										; add remainder
   add  eax,ecx									;
   mov  [ebx],eax								;
   test dword[esi],~0							; check zero
   jne  .fractionL								;
   add  esi,4									;
   cmp  esi,esp									;
   jb   .fractionL								;
  .fractionextrazerosL:							;
   cmp  byte[edi],"0"							;
   jne  .fractionextrazerosLD					;
   dec  edi										;
   jmp  .fractionextrazerosL					;
   .fractionextrazerosLD:						;
  mov  byte[edi+1],0							;
  
  add  esp,513*4+10								;
  push dword[_buffer]							; string bottom
  call fPrintstr								;print it
  ;IT SHOULD RUN NOW!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  ret
  
  .fractionpoint:								;
   mov  byte[_buffer+511],"0"					;
   dec  edi										;
   jmp  .sign									;
  
  .nofraction:									;
   mov  byte[edi],0								;
   
   add  esp,512*4+10							;
   push dword[_buffer]							; string bottom
   call fPrintstr								;print it
   
   ret
 
 .nan:											;
  add  esp,10									;
  
  push tNan										;
  call fPrintstr								;
  
  ret
 
 section .data
 tNan db "NaN",0
 section .text
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;char
 
 fPrintchar:
  xor   eax,eax
  mov   al,byte[esp+4]
  add   eax,tChars
  
  push  NULL
  push  _buffer
  push  1
  push  eax
  push  dword[_StdOutHandle]
  call  _WriteFile@20
  
  ret 4
 
 section .data
 tChars db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,EM
 section .text
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Sleep
 
 SLEEPLEN          EQU 500
 
 fSleep:
  push dword SLEEPLEN
  call _Sleep@4
  
  ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Rand
 
 section .bss
 DtRngSeed    resd 1
 _randomseed  resq 1
 
 section .data
 qinttofloat dq 0x4340000000000000
 ;qinttofloat dq 0x0020000000000000
 
 section .text
 
 fRandgaussianinit:								;
  
  finit											;
  
  sub  esp,8									;
  push esp										;
  call _GetSystemTimeAsFileTime@4				;
  pop  ecx										;ecx low
  pop  eax										;eax high
  xor  edx,edx									;
  mov  esi,10000								;
  div  esi										;
  mov  ebx,eax									;
  mov  eax,ecx									;
  mov  esi,10000								;
  div  esi										; / 10000
  sub  edx,11643609600000>>32					;
  sub  eax,11643609600000&0xFFFFFFFF			; - 11,643,609,600,000
  												;ebx:eax time
  xor  eax,0x00000005DEECE66D&0xFFFFFFFF		;
  xor  ebx,0x00000005DEECE66D>>32				;
  ;and eax,0x0000FFFFFFFFFFFF&0xFFFFFFFF		;
  and  ebx,0x0000FFFFFFFFFFFF>>32				;
  mov  [_randomseed],eax						;
  mov  [_randomseed+4],ebx						;
  
  ret
 
 fRandgaussianf:								;
  
  mov  ebx,[_randomseed]						;
  
  mov  eax,ebx
  mov  edx,0x00000005DEECE66D&0xFFFFFFFF		;
  mul  edx										;
  mov  ecx,eax									;ecx low cumulative
  mov  eax,ebx									;
  mov  ebx,edx									;ebx high cumulative
  
  mov  edx,0x00000005DEECE66D>>32				;
  mul  edx										;
  mov  ebx,eax									; high cumulate
  
  mov  eax,[_randomseed+4]						;
  mov  edx,0x00000005DEECE66D&0xFFFFFFFF		;
  mul  edx										;
  mov  ebx,eax									; high cumulate
  
  ;and eax,0x0000FFFFFFFFFFFF&0xFFFFFFFF		;
  and  ebx,0x0000FFFFFFFFFFFF>>32				;
  
  mov  [_randomseed],ecx						; update seed
  mov  [_randomseed+4],ebx						;
  
  and  ecx,0xFFFFFFFFFFC00000&0xFFFFFFFF		;
  ;and ebx,0xFFFFFFFFFFC00000>>32				;
  
  shld ebx,ecx,5								;
  shl  ecx,5									;
  
  mov  esi,ecx									;esi low 1
  mov  edi,ebx									;edi hight 1
  
  ;;;;;;;;										;
  
  mov  ebx,[_randomseed]						;
  
  mov  eax,ebx
  mov  edx,0x00000005DEECE66D&0xFFFFFFFF		;
  mul  edx										;
  mov  ecx,eax									;ecx low cumulative
  mov  eax,ebx									;
  mov  ebx,edx									;ebx high cumulative
  
  mov  edx,0x00000005DEECE66D>>32				;
  mul  edx										;
  mov  ebx,eax									; high cumulate
  
  mov  eax,[_randomseed+4]						;
  mov  edx,0x00000005DEECE66D&0xFFFFFFFF		;
  mul  edx										;
  mov  ebx,eax									; high cumulate
  
  ;and eax,0x0000FFFFFFFFFFFF&0xFFFFFFFF		;
  and  ebx,0x0000FFFFFFFFFFFF>>32				;
  
  mov  [_randomseed],ecx						;
  mov  [_randomseed+4],ebx						;
  
  shrd ecx,ebx,21								;ecx low 2
  shr  ebx,21									;ebx high 2
  
  ;;;;;;;;										;
  
  add  ecx,esi									;
  adc  ebx,edi									;ebx:ecx integer result
  
  mov  [_buffer],ecx							;
  mov  [_buffer+4],ebx							;
  fild qword[_buffer]							; result
  
  fld  qword[qinttofloat]						; / 0x0020000000000000f
  
  fdivp st1,st0									;st0 float result 0..1
  ;fstp  qword[_buffer]							;[_buffer] float result 0..1
  
  ret
 
 
 
 fRand32:
  mov   eax,dword[DtRngSeed]
  mov   edx,1103515245
  mul   edx
  shl   edx,16
  add   eax,12345
  adc   edx,0xFFFF
  mov   dword[DtRngSeed],eax
  shr   eax, 16
  and   edx,0xFFFF0000
  or    eax,edx
  ret
 
 
 
 fRandCapp8:
  push  eax
  
  mov   eax,dword[DtRngSeed]
  mov   edx,1103515245
  mul   edx
  shl   edx,16
  add   eax,12345
  adc   edx,0xFFFF
  mov   dword[DtRngSeed],eax
  shr   eax, 16
  and   edx,0xFFFF0000
  or    eax,edx
  
  and  eax,0x000000FF
  pop   edx
  div   dl
  mov   al,ah
  
  ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Window
 
 WS_EX_COMPOSITED    equ 2000000h	;window styles
 WS_OVERLAPPEDWINDOW equ 0x0CF0000	;
 WS_VISIBLE          equ 0x10000000	;
 WS_MAXIMIZE         equ 0x01000000 ;
 WM_CLOSE            equ 0x0010		;messages
 WM_QUIT             equ 0x0012		;
 PM_REMOVE           equ 0x0001		;message parameter
 CS_VREDRAW          equ 0x0001		;class styles
 CS_HREDRAW          equ 0x0002		;
 CW_USEDEFAULT       equ 0x80000000	;window cosntant
 IDI_APPLICATION     equ 0x7F00		;icon id
 SW_SHOWNORMAL       equ 0x01		;showwindow parameter
 SW_SHOWMAXIMIZED    equ 0x03
 WindowWidth         equ 640
 WindowHeight        equ 480
 
  section .data
 tWnName db "Secrets",EM
 tWnClassname db "Window",EM
 tWnError db "Failed to register window.",EM
 
 
  section .bss
 sWn resd 12									; Window class
 %define sWn.cbSize         sWn					; Size
 %define sWn.style          sWn+4				; Style
 %define sWn.lpfnWndProc    sWn+8				; Window Procedure
 %define sWn.cbClsExtra     sWn+12				; extra bytes post Class
 %define sWn.cbWndExtra     sWn+16				; extra bytes post Instance
 %define sWn.hInstance      sWn+20				; Instance
 %define sWn.hIcon          sWn+24				; Icon
 %define sWn.hCursor        sWn+28				; Cursor
 %define sWn.hbrBackground  sWn+32				; Background Brush
 %define sWn.lpszMenuName   sWn+36				; Menu Name
 %define sWn.lpszClassName  sWn+40				; Class Name
 %define sWn.hIconSm        sWn+44				; Small Icon
 
 sWm resd 7										; Window Message structure
 %define sWm.hwnd           sWm					; Window handle
 %define sWm.message        sWm+4				; Message identifier
 %define sWm.wParam         sWm+8				; Parameter
 %define sWm.lParam         sWm+12				; Parameter
 %define sWm.time           sWm+16				; Time when posted
 %define sWm.pt.x           sWm+20				; Cursor position when posted
 %define sWm.pt.y           sWM+24				; Cursor position when posted
 
 hWn resd 1
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Create Window
 
  section .text
 fWnCreate:
  mov  dword[sWn.cbSize],48						;Define Window class
  mov  dword[sWn.style],CS_HREDRAW|CS_VREDRAW	;
  mov  dword[sWn.lpfnWndProc],prWn				;
  mov  dword[sWn.cbClsExtra],NULL				;
  mov  dword[sWn.cbWndExtra],NULL				;
  mov  eax,dword[_Instance]						;
  mov  dword[sWn.hInstance],eax					;
  												;
  push IDI_APPLICATION							;
  push NULL										;
  call _LoadIconA@8								;
  mov  dword[sWn.hIcon],eax						;
  												;
  push IDI_APPLICATION							;
  push NULL										;
  call _LoadCursorA@8							;
  mov  dword[sWn.hCursor],eax					;
  												;
  push 0x006E77FA								;
  call _CreateSolidBrush@4						;
  mov  dword[sWn.hbrBackground],eax				;
  												;
  mov  dword[sWn.lpszMenuName],NULL				;
  mov  dword[sWn.lpszClassName],tWnClassname	;
  												;
  push IDI_APPLICATION							;
  push NULL										;
  call _LoadIconA@8								;
  mov  dword[sWn.hIconSm],eax					;
  
  lea  eax,[sWn]								;
  push eax										;
  call _RegisterClassExA@4						;Register window class
  cmp  eax,0									;
  je   fWnErrorRegister							; check for error
  
  push NULL										; Message
  push dword[_Instance]							; Instance handle
  push NULL										; Menu handle
  push NULL										; Parent handle
  push WindowHeight								; Height
  push WindowWidth								; Width
  push CW_USEDEFAULT							; Vertical
  push CW_USEDEFAULT							; Horizontal
  push WS_OVERLAPPEDWINDOW|WS_MAXIMIZE			; Style
  push tWnName									; Title
  push tWnClassname								; Class Name
  push WS_EX_COMPOSITED							; Extended Style
  call _CreateWindowExA@48						;Create Window
  mov  dword[hWn],eax							; Window handle
  
  push SW_SHOWMAXIMIZED							;
  push dword[hWn]								;
  call _ShowWindow@8							;Show Window
  
  push dword[hWn]								;
  call _UpdateWindow@4							;Update Window
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Message Loop
 
  fWnUpdate:
   lea  eax,[sWm]								 ;
   push PM_REMOVE								 ;
   push NULL									 ;
   push NULL									 ;
   push NULL									 ;
   push eax										 ;
   call _PeekMessageA@20						 ;Peek Message
   cmp  eax,0									 ;Null>Return
   je   fWnMsgL1								 ;
   
   cmp dword[sWm.message], WM_QUIT				 ;Quit>Exit
   je fWnMsgLD									 ;
   
   lea  eax,[sWm]								 ;
   push eax										 ;
   call _TranslateMessage@4						 ;Translate Message
   
   lea  eax,[sWm]								 ;
   push eax										 ;
   call _DispatchMessageA@4						 ;Dispatch Message
   
   fWnMsgL1:									 ;
   ret
  
  fWnMsgLD:
   call fShutdown
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Error
 
  fWnErrorRegister:								;
   push 0										;
   push tWnName									;
   push tWnError								;
   push 0										;
   call _MessageBoxA@16							;Error message
   
   ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Procedure
 
 prWn:
  push ebp
  mov ebp,esp
  
 %define hWnd    ebp+8							; Window handler
 %define uMsg    ebp+12							; Message
 %define wParam  ebp+16							; parameter
 %define lParam  ebp+20							; parameter
  
  cmp  dword[uMsg],WM_CLOSE						;Check for destroy
  je   prWnDestroy								;
  
 DefaultMessage:
  push dword[lParam]							; 
  push dword[wParam]							; 
  push dword[uMsg]								; 
  push dword[hWnd]								; 
  call _DefWindowProcA@16						;Default Window Procedure
  
  mov  esp,ebp
  pop  ebp
  ret  16
  
  prWnDestroy:
  push NULL
  call _PostQuitMessage@4
  
  mov  esp,ebp
  pop  ebp
  ret  16
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;