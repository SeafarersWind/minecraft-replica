Player: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .bss
 
 .xo     resd 1
 .yo     resd 1
 .zo     resd 1
 .x      resd 1
 .y      resd 1
 .z      resd 1
 .xd     resd 1
 .yd     resd 1
 .zd     resd 1
 .yRot   resd 1
 .xRot   resd 1
 .ground resb 1
 
 Player.bb:
 .epsilon resd 1
 .x0      resd 1
 .y0      resd 1
 .z0      resd 1
 .x1      resd 1
 .y1      resd 1
 .z1      resd 1
 
 section .text
 
Player.init: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 call fRandgaussianf
 push f(256.0)									;Level.height
 fld  dword[esp]		;145
 fmulp st1,st0
 
 push f(74.0)									;Level.depth+10
 fld  dword[esp]		;150
 
 call fRandgaussianf
 push f(256.0)									;Level.width
 fld  dword[esp]		;154
 fmulp st1,st0
 
 call Player.setpos
 
 add  esp,12
 
 ret
 
Player.setpos: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 fld  st2
 fst  dword[Player.z]
 fld  st2
 fst  dword[Player.y]
 fld  st2
 fst  dword[Player.x]
 
 push f(0.3)
 fld  dword[esp]
 fsub st1,st0
 fsub st3,st0
 fadd st4,st0
 faddp st6,st0
 push f(0.9)
 fld  dword[esp]
 fsub st2,st0
 faddp st5,st0
 mov  eax,Player.bb
 call AABB.new
 add  esp,8
 
 ret
 
Player.tick: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 mov  eax,[Player.x]							;
 mov  ebx,[Player.y]							;
 mov  ecx,[Player.z]							;
 mov  [Player.xo],eax							;
 mov  [Player.yo],ebx							;
 mov  [Player.zo],ecx							;
 
 fldz											;
 fldz											;
 fld1											;
 test byte[keys+(0x52>>3)],0x01<<(0x52&0x07)	;R key
 jz   .rD										;
  call Player.init								;
  .rD:											;
 test byte[keys+(0x57>>3)],0x01<<(0x57&0x07)	;W key
 jz   .wD										;
  fsub to st2									;ya
  .wD:											;
 test byte[keys+(0x53>>3)],0x01<<(0x53&0x07)	;S key
 jz   .sD										;
  fadd to st2									;ya
  .sD:											;
 test byte[keys+(0x41>>3)],0x01<<(0x41&0x07)	;A key
 jz   .aD										;
  fsub to st1									;xa
  .aD:											;
 test byte[keys+(0x44>>3)],0x01<<(0x44&0x07)	;D key
 jz   .dD										;
  fadd to st1									;xa
  .dD:											;
 test byte[keys+(0x20>>3)],0x01<<(0x20&0x07)	;VK_SPACE
 jz   .spaceD									;
  mov  dword[Player.yd],f(0.12)					;
  .spaceD:										;
 fincstp										;
 ffree st7										;
 
 test byte[Player.ground],0x01					;
 jz   .moverelativegD							;
  fld  tword[tloat0_02]							;
  jmp  .moverelativengD							;
  .moverelativegD:								;
  fld  tword[tloat0_005]						;
  .moverelativengD:								;speed
 call Player.moveRelative						;moveRelative
 
 fld   tword[tloat0_005]						;
 fsubr dword[Player.yd]							;
 fstp  dword[Player.yd]							;yd -= 0.005
 
 fld  dword[Player.zd]							;
 fld  dword[Player.yd]							;
 fld  dword[Player.xd]							;
 call Player.move								;move
 
 push f(0.91)									;
 fld  dword[esp]								;
 fld  st0										;
 fmul dword[Player.xd]							;
 fstp dword[Player.xd]							;xd *= 0.91
 fmul dword[Player.zd]							;
 fstp dword[Player.zd]							;zd *= 0.91
 push f(0.98)									;
 fld  dword[esp]								;
 fmul dword[Player.yd]							;
 fstp dword[Player.yd]							;yd *= 0.98
 add  esp,8										;
 
 test byte[Player.ground],0x01					;
 jz   .groundD									;
  push f(0.8)									;
  fld  dword[esp]								;
  pop  eax
  fld  st0										;
  fmul dword[Player.xd]							;
  fstp dword[Player.xd]							;xd *= 0.8
  fmul dword[Player.zd]							;
  fstp dword[Player.zd]							;zd *= 0.8
  .groundD:										;
 
 ret
 
Player.move: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;st0 xa
;st1 ya
;st2 za
 
 sub  esp,12									;
 fst  dword[esp]								;[esp]   xa
 fincstp										;
 fst  dword[esp+4]								;[esp+4] ya
 fincstp										;
 fst  dword[esp+8]								;[esp+8] za
 fdecstp										;
 fdecstp										;
 
 ;expand...
 
 fld  dword[Player.bb+AABB.x1]					;
 fld  dword[Player.bb+AABB.y1]					;
 fld  dword[Player.bb+AABB.z1]					;
 fld  dword[Player.bb+AABB.x0]					;
 fld  dword[Player.bb+AABB.y0]					;
 
 fdecstp										;st0 za
 ftst											;
 fstsw ax										;
 sahf											;
 jae   .zg										;
  fadd dword[Player.bb+AABB.z0]					;st0 z0
  jmp  .zgD										;
 .zg:											;
  fadd to st3									;st3 z1
  fincstp										;
  ffree st7										;
  fld  dword[Player.bb+AABB.z0]					;
  .zgD:											;
 
 fdecstp										;st0 ya
 ftst											;
 fstsw ax										;
 sahf											;
 jae   .yg										;
  fadd to st2									;st2 y0
  jmp  .ygD										;
 .yg:											;
  fadd to st5									;st5 y1
  .ygD:											;
 ffree st0										;
 
 fdecstp										;st0 xa
 ftst											;
 fstsw ax										;
 sahf											;
 jae   .xg										;
  fadd to st4									;st4 x0
  jmp  .xgD										;
 .xg:											;
  fadd to st7									;st7 x1
  .xgD:											;
 ffree st0										;
 
 fincstp										;
 fincstp										;st0 z0  ;st1 y0  ;st2 x0  ;st3 z1  ;st4 y1  ;st5 x1
 
 ;getCubes...
 
 fld1											;
 fincstp										;st0 z0
 
 sub  esp,2										;
 fstcw word[esp]								;
 and  word[esp],1111011111111111b				;
 or   word[esp],0000010000000000b				;
 fldcw word[esp]								;
 add  esp,2										;
 
 push Level.height-1							;
 push Level.depth-1								;
 push Level.width-1								;
 push 0											;
 push 0											;
 push 0											;
 
 ftst											;st0 z0
 fstsw ax										;
 sahf											;
 ja   .z0nD										;
  fincstp										;
  ffree st7										;
  jmp  .z0lD									;
  .z0nD:										;
  fistp dword[esp+8]							;
  .z0lD:										;st0 y0
 
 ftst											;
 fstsw ax										;
 sahf											;
 ja   .y0nD										;
  fincstp										;
  ffree st7										;
  jmp  .y0lD									;
  .y0nD:										;
  fistp dword[esp+4]							;
  .y0lD:										;st0 x0
 
 ftst											;
 fstsw ax										;
 sahf											;
 ja   .x0nD										;
  fincstp										;
  ffree st7										;
  jmp  .x0lD									;
  .x0nD:										;
  fistp dword[esp+0]							;
  .x0lD:										;st0 z1
 
 fcom qword[qloat256]							;Level.height
 fstsw ax										;
 sahf											;
 jb   .z1bD										;
  fincstp										;
  ffree st7										;
  jmp  .z1sD									;
  .z1bD:										;
  fistp dword[esp+20]							;
  .z1sD:										;st0 y1
 
 fcom qword[qloat64]							;Level.depth
 fstsw ax										;
 sahf											;
 jb   .y1bD										;
  fincstp										;
  ffree st7										;
  jmp  .y1sD									;
  .y1bD:										;
  fistp dword[esp+16]							;
  .y1sD:										;st0 x1
 
 fcom qword[qloat256]							;Level.width
 fstsw ax										;
 sahf											;
 jb   .x1bD										;
  fincstp										;
  ffree st7										;
  jmp  .x1sD									;
  .x1bD:										;
  fistp dword[esp+12]							;
  .x1sD:										;
 fdecstp										;
 fdecstp										;
 fdecstp										;st4 1  ;st5 z0  ;st6 y0  ;st7 z0
 
 ;three big big loops...
 
 xor  eax,eax									;eax yaOrg != ya
 mov  esi,dword[esp+28]							;esi ya
 test esi,~0									;
 jz   .yD										;
 fild dword[esp+0]								;
 mov  edx,[esp+0]								;edx x
 cmp  edx,[esp+12]								;
 ja   .yLD										;
 .yL:											;
  fild dword[esp+4]								;
  mov  ebx,[esp+4]								;ebx y
  cmp  ebx,[esp+16]								;
  ja   .yLLD									;
  .yLL:											;
   fild dword[esp+8]							;st0 z0  ;st1 y0  ;st2 x0    ;st7 1
   mov  ecx,[esp+8]								;ecx z
   cmp  ecx,[esp+20]							;
   ja   .yLLLD									;
   .yLLL:										;
     ;ifsolidtile								;
     mov  edi,ebx								;
     shl  edi,8									;
     add  edi,ecx								;
     shl  edi,8									;
     add  edi,edx								;
     add  edi,Level.blocks						;
     test byte[edi],0x01						;
     jz   .yLLLclipD							;
     ;clipYCollide...							;
     fcom dword[Player.bb+AABB.z1]				;z0 >= Player.bb.z1
     fstsw ax									;
     sahf										;
     jae  .yLLLclipD							;
     fadd st7									;z0 + 1
     fcom dword[Player.bb+AABB.z0]				;z1 <= Player.bb.z0
     fstsw ax									;
     fsub st7									;z0 - 1
     sahf										;
     jbe  .yLLLclipD							;
     
     fincstp									;
     fincstp									;st0 x0
     fcom dword[Player.bb+AABB.x1]				;x0 >= PLayer.bb.x1
     fstsw ax									;
     sahf										;
     jae  .yLLLclipD4							;
     fadd st5									;x0 + 1
     fcom dword[Player.bb+AABB.x0]				;x1 <= Player.bb.x0
     fstsw ax									;
     fsub st5									;x0 - 1
     sahf										;
     jbe  .yLLLclipD4							;
     
     test esi,0x80000000						;ya < 0
     jnz  .yLLLclip2							;
     
     .yLLLclip1:								;
     fdecstp									;
     fdecstp									;
     fdecstp									;
     fld  dword[Player.bb.y1]					;
     fcomi st3									;Player.bb.y1 <= y0
     ja   .yLLLclipD2							;
     fsubr st3									;y0 - Player.bb.y1
     fsub dword[Player.bb.epsilon]				;max - Player.bb.epsilon
     fcom dword[esp+28]							;max < ya
     fstsw ax									;
     sahf										;
     jae  .yLLLclipD2							;
     or   eax,0x00010000						;
     fstp dword[esp+28]							;
     jmp  .yLLLclipD1							;
     
     .yLLLclip2:								;
     fdecstp									;
     fdecstp									;
     fdecstp									;
     fld  dword[Player.bb.y0]					;
     fsub st1									;
     fcomi st3									;Player.bb.y0 >= y1
     jb   .yLLLclipD2							;
     fsubr st3									;y1 - Player.bb.y0
     fadd dword[Player.bb.epsilon]				;max + Player.bb.epsilon
     fcom dword[esp+28]							;max > ya
     fstsw ax									;
     sahf										;
     jbe  .yLLLclipD2							;
     or   eax,0x00010000						;
     fstp dword[esp+28]							;
     jmp  .yLLLclipD1							;
     
     .yLLLclipD4:								;
     fdecstp									;
     .yLLLclipD3:								;
     fdecstp									;
     jmp  .yLLLclipD							;
     .yLLLclipD2:								;
     fincstp									;
     ffree st7									;
     .yLLLclipD1:								;
     fincstp									;st0 z0
     .yLLLclipD:								;
    inc  ecx									;
    fadd st7									;inc z0
    cmp  ecx,dword[esp+20]						;
    jle  .yLLL									;
    .yLLLD:										;
   fincstp										;st0 y0
   ffree st7									;
   inc  ebx										;
   fadd st6										;inc y0
   cmp  ebx,dword[esp+16]						;
   jle  .yLL									;
   .yLLD:										;
  fincstp										;st0 x0
  ffree st7										;
  inc  edx										;
  fadd st5										;inc x0
  cmp  edx,dword[esp+12]						;
  jle  .yL										;
  .yLD:											;
 fincstp										;
 ffree st7										;st0 z1
 
 fld  dword[esp+28]								;st0 ya
 fld  st0										;st0 ya
 fadd dword[Player.bb+AABB.y0]					;
 fstp dword[Player.bb+AABB.y0]					;move
 fadd dword[Player.bb+AABB.y1]					;
 fstp dword[Player.bb+AABB.y1]					;move
 
 .yD:
 
 test eax,0x00010000							;yaOrg != ya
 jz   .ysame									;
 mov  dword[Player.yd],0						;yd = 0
 test esi,0x80000000							;
 jz   .ysame									;
 or   byte[Player.ground],0x01					;
 jmp  .ysameD									;
 .ysame:										;
 and  byte[Player.ground],~0x01					;
 .ysameD:										;
 
 xor  eax,eax									;eax xaOrg != xa
 mov  esi,dword[esp+24]							;esi xa
 test esi,~0									;
 jz   .xD										;
 fild dword[esp+0]								;
 mov  edx,[esp+0]								;edx x
 cmp  edx,[esp+12]								;
 ja   .xLD										;
 .xL:											;
  fild dword[esp+4]								;
  mov  ebx,[esp+4]								;ebx y
  cmp  ebx,[esp+16]								;
  ja   .xLLD									;
  .xLL:											;
   fild dword[esp+8]							;st0 z0  ;st1 y0  ;st2 x0    ;st7 1
   mov  ecx,[esp+8]								;ecx z
   cmp  ecx,[esp+20]							;
   ja   .xLLLD									;
   .xLLL:										;
     ;ifsolidtile								;
     mov  edi,ebx								;
     shl  edi,8									;
     add  edi,ecx								;
     shl  edi,8									;
     add  edi,edx								;
     add  edi,Level.blocks						;
     test byte[edi],0x01						;
     jz   .xLLLclipD							;
     ;clipXCollide...							;
     fcom dword[Player.bb+AABB.z1]				;z0 >= Player.bb.z1
     fstsw ax									;
     sahf										;
     jae  .xLLLclipD							;
     fadd st7									;z0 + 1
     fcom dword[Player.bb+AABB.z0]				;z1 <= Player.bb.z0
     fstsw ax									;
     fsub st7									;z0 - 1
     sahf										;
     jbe  .xLLLclipD							;
     
     fincstp									;st0 y0
     fcom dword[Player.bb+AABB.y1]				;y0 >= PLayer.bb.y1
     fstsw ax									;
     sahf										;
     jae  .xLLLclipD3							;
     fadd st6									;y0 + 1
     fcom dword[Player.bb+AABB.y0]				;y1 <= Player.bb.y0
     fstsw ax									;
     fsub st6									;y0 - 1
     sahf										;
     jbe  .xLLLclipD3							;
     
     test esi,0x80000000						;
     jnz  .xLLLclip2							;
     
     .xLLLclip1:								;
     fdecstp									;
     fdecstp									;
     fld  dword[Player.bb+AABB.x0]				;st0 max
     fsub st1									;max - 1
     fcomi st4									;max >= x1
     jb   .xLLLclipD2							;
     fsub st4									;max - x1
     fsub dword[Player.bb+AABB.epsilon]			;max - Player.bb.epsilon
     fcom dword[esp+24]							;max < xa
     fstsw ax									;
     sahf										;
     jae  .xLLLclipD2							;
     or   eax,0x00010000						;
     fstp dword[esp+24]							;xa = max
     jmp  .xLLLclipD1							;
     
     .xLLLclip2:								;
     fdecstp									;
     fdecstp									;
     fld  dword[Player.bb+AABB.x1]				;st0 max
     fcomi st4									;max <= x0
     ja   .xLLLclipD2							;
     fsub  st4									;max - x0
     fadd  dword[Player.bb+AABB.epsilon]		;max + Player.bb.epsilon
     fcom  dword[esp+24]						;max > xa
     fstsw ax									;
     sahf										;
     jbe  .xLLLclipD2							;
     or   eax,0x00010000						;
     fstp dword[esp+24]							;xa = max
     jmp  .xLLLclipD1							;
     
     .xLLLclipD4:								;
     fdecstp									;
     .xLLLclipD3:								;
     fdecstp									;
     jmp  .xLLLclipD							;
     .xLLLclipD2:								;
     fincstp									;
     ffree st7									;
     .xLLLclipD1:								;
     fincstp									;st0 z0
     .xLLLclipD:								;
    inc  ecx									;
    fadd st7									;inc z0
    cmp  ecx,[esp+20]							;
    jle  .xLLL									;
    .xLLLD:										;
   fincstp										;st0 y0
   ffree st7									;
   inc  ebx										;
   fadd st6										;inc y0
   cmp  ebx,[esp+16]							;
   jle  .xLL									;
   .xLLD:										;
  fincstp										;st0 x0
  ffree st7										;
  inc  edx										;
  fadd st5										;inc x0
  cmp  edx,[esp+12]								;
  jle  .xL										;
  .xLD:											;
 fincstp										;st0 z1
 ffree st7										;
 
 fld  dword[esp+24]								;st0 xa
 fld  st0										;st0 xa
 fadd dword[Player.bb+AABB.x0]					;
 fstp dword[Player.bb+AABB.x0]					;move
 fadd dword[Player.bb+AABB.x1]					;
 fstp dword[Player.bb+AABB.x1]					;move
 
 .xD:
 
 test eax,0x00010000							;xaOrg != xa
 jz   .xsame									;
 mov  dword[Player.xd],0						;
push "x"
call fPrintchar
jmp fShutdown
 .xsame:										;
 
 xor  eax,eax									;eax zaOrg != za
 mov  esi,dword[esp+32]							;esi za
 test esi,~0									;
 jz   .zD										;
 fild dword[esp+0]								;
 mov  edx,[esp+0]								;edx x
 cmp  edx,[esp+12]								;
 ja   .zLD										;
 .zL:											;
  fild dword[esp+4]								;
  mov  ebx,[esp+4]								;ebx y
  cmp  ebx,[esp+16]								;
  ja   .zLLD									;
  .zLL:											;
   fild dword[esp+8]							;st0 z0  ;st1 y0  ;st2 x0    ;st7 1
   mov  ecx,[esp+8]								;ecx z
   cmp  ecx,[esp+20]							;
   ja   .zLLLD									;
   .zLLL:										;
     ;ifsolidtile								;
     mov  edi,ebx								;
     shl  edi,8									;
     add  edi,ecx								;
     shl  edi,8									;
     add  edi,edx								;
     add  edi,Level.blocks						;
     test byte[edi],0x01						;
     jz   .zLLLclipD							;
     ;clipZCollide...							;
     fincstp									;st0 y0
     fcom dword[Player.bb+AABB.y1]				;y0 >= Player.bb.y1
     fstsw ax									;
     sahf										;
     jae  .zLLLclipD3							;
     fadd st6									;y0 + 1
     fcom dword[Player.bb+AABB.y0]				;y1 <= Player.bb.y0
     fstsw ax									;
     fsub st6									;y0 - 1
     sahf										;
     jbe  .zLLLclipD3							;
     
     fincstp									;st0 x0
     fcom dword[Player.bb+AABB.x1]				;x0 >= PLayer.bb.x1
     fstsw ax									;
     sahf										;
     jae  .zLLLclipD4							;
     fadd st5									;x0 + 1
     fcom dword[Player.bb+AABB.x0]				;x1 <= Player.bb.x0
     fstsw ax									;
     fsub st5									;x0 - 1
     sahf										;
     jbe  .zLLLclipD4							;
     
     test esi,0x80000000						;
     jnz  .zLLLclip2							;
     
     .zLLLclip1:								;
     fdecstp									;
     fdecstp									;
     fdecstp									;
     fld  dword[Player.bb+AABB.z0]				;st0 max
     fsub st1									;max - 1
     fcomi st2									;max >= z1
     jb   .zLLLclipD2							;
     fsub st2									;max - z1
     fsub dword[Player.bb+AABB.epsilon]			;max - Player.bb.epsilon
     fcom dword[esp+32]							;max < za
     fstsw ax									;
     sahf										;
     jae  .zLLLclipD2							;
     or   eax,0x00010000						;
     fstp dword[esp+32]							;za = max	;st0 1
     jmp  .zLLLclipD1							;
     
     .zLLLclip2:								;
     fdecstp									;
     fdecstp									;
     fdecstp									;
     fld  dword[Player.bb+AABB.z1]				;st0 max
     fcomi st2									;max <= z0
     ja   .zLLLclipD2							;
     fsub  st2									;max - z0
     fadd  dword[Player.bb+AABB.epsilon]		;max + Player.bb.epsilon
     fcom  dword[esp+32]						;max > za
     fstsw ax									;
     sahf										;
     jbe  .zLLLclipD2							;
     or   eax,0x00010000						;
     fstp dword[esp+32]							;za = max	;st0 1
     jmp  .zLLLclipD1							;
     
     .zLLLclipD4:								;
     fdecstp									;
     .zLLLclipD3:								;
     fdecstp									;
     jmp  .zLLLclipD							;
     .zLLLclipD2:								;
     fincstp									;
     ffree st7									;
     .zLLLclipD1:								;
     fincstp									;st0 z0
     .zLLLclipD:								;
    inc  ecx									;
    fadd st7									;inc z0
    cmp  ecx,[esp+20]							;
    jbe .zLLL									;
    .zLLLD:										;
   fincstp										;st0 y0
   ffree st7									;
   inc  ebx										;
   fadd st6										;inc y0
   cmp  ebx,[esp+16]							;
   jbe  .zLL									;
   .zLLD:										;
  fincstp										;st0 x0
  ffree st7										;
  inc  edx										;
  fadd st5										;inc x0
  cmp  edx,[esp+12]								;
  jbe  .zL										;
  .zLD:											;
 fincstp										;
 ffree st7										;
 
 fld  dword[esp+32]								;st0 za
 fld  st0										;st0 za
 fadd dword[Player.bb+AABB.z0]					;
 fstp dword[Player.bb+AABB.z0]					;move
 fadd dword[Player.bb+AABB.z1]					;
 fstp dword[Player.bb+AABB.z1]					;move
 
 .zD:											;
 
 test eax,0x00010000							;zaOrg != za
 jz   .zsame									;
 mov  dword[Player.zd],0						;zd = 0
push "z"
call fPrintchar
jmp  fShutdown
 .zsame:										;
 
 ffree st4										;
 
 ;move...
 
 fld  dword[Player.bb+AABB.x0]					;
 fadd dword[Player.bb+AABB.x1]					;
 fdiv dword[float2]								;
 fstp dword[Player.x]							;
 fld  dword[Player.bb+AABB.y0]					;
 fadd dword[float1_62]							;
 fstp dword[Player.y]							;
 fld  dword[Player.bb+AABB.z0]					;
 fadd dword[Player.bb+AABB.z1]					;
 fdiv dword[float2]								;
 fstp dword[Player.z]							;
 
 
 add  esp,36									;
 
fld dword[Player.x]
call fPrintfloat
push LN
call fPrintchar
fld dword[Player.y]
call fPrintfloat
push LN
call fPrintchar
fld dword[Player.z]
call fPrintfloat
push LN
call fPrintchar
push LN
call fPrintchar
 ret
 
Player.moveRelative: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;st0 speed
;st1 xa
;st2 za
 
 fld st2										;
 fabs											;
 fld st2										;
 fabs											;
 faddp st1										;st0 dist  ;st1 speed  ;st2 xa  ;st3 za
 
 fcom dword[float0_01]							;dist < 0.01
 fstsw ax										;
 sahf											;
 jnb   .1										; return
 
 fincstp										;
 ffree st7										;dist
 fincstp										;
 ffree st7										;speed
 fincstp										;
 ffree st7										;xa
 fincstp										;
 ffree st7										;za
 ret
 
 .1:											;
 fsqrt											;
 fdivp   st1									;speed/sqrt(dist)
 fmul to st1									;xa
 fmulp   st2									;za
 fld  dword[Player.yRot]						;
 fldpi											;
 fmulp   st1									;
 push dh(180.0)									;
 push dl(180.0)									;
 fdiv qword[esp]								;
 add  esp,8										;
 fsincos										; st0 cos ; st1 sin ; st2 xa ; st3 za
 fld   st2										; xa, cos, sin, xa, za
 fmul  st1										; cos
 fld   st4										; za, xa*cos, cos, sin, xa, za
 fmul  st3										; sin
 fsubp st1										; xa*cos - za*sin
 fstp  dword[Player.xd]							;xd
 fmulp st3										; za*cos
 fmulp st1										; xa*sin
 faddp st1										; za*cos + xa*sin
 fstp  dword[Player.zd]							;zd
 
 ret
 
Player.turn: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 fild word[WNproc.mAccumdx]						;
 mov  word[WNproc.mAccumdx],0					;
 push f(0.15)									;
 fmul dword[esp]								;
 fadd dword[Player.yRot]						;
 fstp dword[Player.yRot]						;
 
 fild word[WNproc.mAccumdy]						;
 mov  word[WNproc.mAccumdy],0					;
 fmul dword[esp]								;
 fadd dword[Player.xRot]						;
 
 push f(-90.0)									;
 fcom dword[esp]								;
 fstsw ax										;
 sahf											;
 jae  .nomin									;
  pop  dword[Player.xRot]						;
  fincstp										;
  ffree st7										;
  add  esp,4									;
  
  ret
 
 .nomin:										;
 push f(90.0)									;
 fcom dword[esp]								;
 fstsw ax										;
 sahf											;
 jbe  .nomax									;
  pop  dword[Player.xRot]						;
  fincstp										;
  ffree st7										;
  add  esp,8									;
  
  ret
 
 .nomax:										;
 fstp dword[Player.xRot]						;
 add  esp,12									;
 
 ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;