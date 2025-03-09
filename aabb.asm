AABB: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 .epsilon equ 0
 .x0      equ 4
 .y0      equ 8
 .z0      equ 12
 .x1      equ 16
 .y1      equ 20
 .z1      equ 24
 
 section .text
 
AABB.new: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;eax new instance
 ;st0 x0
 ;st1 y0
 ;st2 z0
 ;st3 x1
 ;st4 y1
 ;st5 z1
 
 mov  dword[eax+AABB.epsilon],f(0.0)
 fstp dword[eax+AABB.x0]
 fstp dword[eax+AABB.y0]
 fstp dword[eax+AABB.z0]
 fstp dword[eax+AABB.x1]
 fstp dword[eax+AABB.y1]
 fstp dword[eax+AABB.z1]
 
 ret
 
AABB.expand: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax instance
;st0 xa
;st1 ya
;st2 za
 
 pop  ebx										;ebx return
 sub  esp,28									;
 push ebx										;[esp] return
 mov  dword[esp+4+AABB.epsilon],0				;
 mov  edx,[eax+AABB.x0]							;
 mov  [esp+4+AABB.x0],edx						;
 mov  edx,[eax+AABB.y0]							;
 mov  [esp+4+AABB.y0],edx						;
 mov  edx,[eax+AABB.z0]							;
 mov  [esp+4+AABB.z0],edx						;
 mov  edx,[eax+AABB.x1]							;
 mov  [esp+4+AABB.x1],edx						;
 mov  edx,[eax+AABB.y1]							;
 mov  [esp+4+AABB.y1],edx						;
 mov  edx,[eax+AABB.z1]							;
 mov  [esp+4+AABB.z1],edx						;
 
 ftst											;
 fstsw ax										;
 sahf											;
 jae   .xg										;
  fadd dword[esp+4+AABB.x0]						;
  fstp dword[esp+4+AABB.x0]						;
  jmp  .xgD										;
 .xg:											;
  fadd dword[esp+4+AABB.x1]						;
  fstp dword[esp+4+AABB.x1]						;
  .xgD:											;
 ftst											;
 fstsw ax										;
 sahf											;
 jae   .yg										;
  fadd dword[esp+4+AABB.y0]						;
  fstp dword[esp+4+AABB.y0]						;
  jmp  .ygD										;
 .yg:											;
  fadd dword[esp+4+AABB.y1]						;
  fstp dword[esp+4+AABB.y1]						;
  .ygD:											;
 ftst											;
 fstsw ax										;
 sahf											;
 jae   .zg										;
  fadd dword[esp+4+AABB.z0]						;
  fstp dword[esp+4+AABB.z0]						;
  jmp  .zgD										;
 .zg:											;
  fadd dword[esp+4+AABB.z1]						;
  fstp dword[esp+4+AABB.z1]						;
  .zgD:											;
 
 ret
 
AABB.grow: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;eax instance
 ;ebx new instance
 ;st0 xa
 ;st1 ya
 ;st2 za
 
 mov  dword[ebx+AABB.epsilon],f(0.0)			;
 
 fld  dword[eax+AABB.x0]						;
 fsub st1										; xa
 fstp dword[ebx+AABB.x0]						;
 fld  dword[eax+AABB.y0]						;
 fsub st2										; ya
 fstp dword[ebx+AABB.y0]						;
 fld  dword[eax+AABB.z0]						;
 fsub st3										; za
 fstp dword[ebx+AABB.z0]						;
 
 fld  dword[eax+AABB.x1]						;
 faddp st1										; xa
 fstp dword[ebx+AABB.x1]						;
 fld  dword[eax+AABB.y1]						;
 faddp st1										; ya
 fstp dword[ebx+AABB.y1]						;
 fld  dword[eax+AABB.z1]						;
 faddp st1										; za
 fstp dword[ebx+AABB.z1]						;
 
 mov  eax,ebx
 
 ret
 
AABB.clipXCollide: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax instance
;ebx object
;st0 xa
 
 fld  dword[ebx+AABB.y1]						;
 fcom dword[eax+AABB.y0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jbe  .retxa									;
 
 fld  dword[ebx+AABB.y0]						;
 fcom dword[eax+AABB.y1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jae  .retxa									;
 
 fld  dword[ebx+AABB.z1]						;
 fcom dword[eax+AABB.z0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jbe  .retxa									;
 
 fld  dword[ebx+AABB.z0]						;
 fcom dword[eax+AABB.z1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jae  .retxa									;
 
 push f(0.0)									;
 fcom dword[esp]								;
 pop  eax										;
 fstsw ax										;
 sahf											;
 jbe  .1										;
 
 fld  dword[ebx+AABB.x1]						;
 fcom dword[eax+AABB.x0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 ja   .1										;
 
 fld  dword[eax+AABB.x0]						;
 fsub dword[ebx+AABB.x1]						;
 fsub dword[eax+AABB.epsilon]					;
 fcomi st1										;
 jae  .1a										;
 
 fst  st1										;
 fincstp										;
 ffree st7										;
 
 ret
 
 .1a:											;
 fincstp										;
 ffree st7										;
 .1:											;
 push f(0.0)									;
 fcom dword[esp]								;
 pop  eax										;
 fstsw ax										;
 sahf											;
 jae  .retxa									;
 
 fld  dword[ebx+AABB.x0]						;
 fcom dword[eax+AABB.x1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jb   .retxa									;
 
 fld  dword[eax+AABB.x1]						;
 fsub dword[ebx+AABB.x0]						;
 fsub dword[eax+AABB.epsilon]					;
 fcomi st1										;
 jbe  .1b
 
 fst  st1										;
 
 .1b:											;
 fincstp										;
 ffree st7										;
 .retxa:										;
 
 ret
 
AABB.clipYCollide: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax instance
;ebx object
;st0 ya
 
 fld  dword[ebx+AABB.x1]						;
 fcom dword[eax+AABB.x0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jbe  .retxa									;
 
 fld  dword[ebx+AABB.x0]						;
 fcom dword[eax+AABB.x1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jae  .retxa									;
 
 fld  dword[ebx+AABB.z1]						;
 fcom dword[eax+AABB.z0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jbe  .retxa									;
 
 fld  dword[ebx+AABB.z0]						;
 fcom dword[eax+AABB.z1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jae  .retxa									;
 
 push f(0.0)									;
 fcom dword[esp]								;
 pop  eax										;
 fstsw ax										;
 sahf											;
 jbe  .1										;
 
 fld  dword[ebx+AABB.y1]						;
 fcom dword[eax+AABB.y0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 ja   .1										;
 
 fld  dword[eax+AABB.y0]						;
 fsub dword[ebx+AABB.y1]						;
 fsub dword[eax+AABB.epsilon]					;
 fcomi st1										;
 jae  .1a										;
 
 fst  st1										;
 fincstp										;
 ffree st7										;
 
 ret
 
 .1a:											;
 fincstp										;
 ffree st7										;
 .1:											;
 push f(0.0)									;
 fcom dword[esp]								;
 pop  eax										;
 fstsw ax										;
 sahf											;
 jae  .retxa									;
 
 fld  dword[ebx+AABB.y0]						;
 fcom dword[eax+AABB.y1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jb   .retxa									;
 
 fld  dword[eax+AABB.y1]						;
 fsub dword[ebx+AABB.y0]						;
 fsub dword[eax+AABB.epsilon]					;
 fcomi st1										;
 jbe  .1b
 
 fst  st1										;
 
 .1b:											;
 fincstp										;
 ffree st7										;
 .retxa:										;
 
 ret
 
AABB.clipZCollide: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax instance
;ebx object
;st0 za
 
 fld  dword[ebx+AABB.x1]						;
 fcom dword[eax+AABB.x0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jbe  .retxa									;
 
 fld  dword[ebx+AABB.x0]						;
 fcom dword[eax+AABB.x1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jae  .retxa									;
 
 fld  dword[ebx+AABB.y1]						;
 fcom dword[eax+AABB.y0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jbe  .retxa									;
 
 fld  dword[ebx+AABB.y0]						;
 fcom dword[eax+AABB.y1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jae  .retxa									;
 
 push f(0.0)									;
 fcom dword[esp]								;
 pop  eax										;
 fstsw ax										;
 sahf											;
 jbe  .1										;
 
 fld  dword[ebx+AABB.z1]						;
 fcom dword[eax+AABB.z0]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 ja   .1										;
 
 fld  dword[eax+AABB.z0]						;
 fsub dword[ebx+AABB.z1]						;
 fsub dword[eax+AABB.epsilon]					;
 fcomi st1										;
 jae  .1a										;
 
 fst  st1										;
 fincstp										;
 ffree st7										;
 
 ret
 
 .1a:											;
 fincstp										;
 ffree st7										;
 .1:											;
 push f(0.0)									;
 fcom dword[esp]								;
 pop  eax										;
 fstsw ax										;
 sahf											;
 jae  .retxa									;
 
 fld  dword[ebx+AABB.z0]						;
 fcom dword[eax+AABB.z1]						;
 fstsw ax										;
 fincstp										;
 ffree st7										;
 sahf											;
 jb   .retxa									;
 
 fld  dword[eax+AABB.z1]						;
 fsub dword[ebx+AABB.z0]						;
 fsub dword[eax+AABB.epsilon]					;
 fcomi st1										;
 jbe  .1b
 
 fst  st1										;
 
 .1b:											;
 fincstp										;
 ffree st7										;
 .retxa:										;
 
 ret
 
AABB.move: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax instance
;st0 x
;st1 y
;st2 z
 
 fld  dword[eax+AABB.x0]						;
 fadd st1										;
 fstp dword[eax+AABB.x0]						;
 fld  dword[eax+AABB.x1]						;
 faddp st1										;
 fstp dword[eax+AABB.x1]						;
 
 fld  dword[eax+AABB.y0]						;
 fadd st1										;
 fstp dword[eax+AABB.y0]						;
 fld  dword[eax+AABB.y1]						;
 faddp st1										;
 fstp dword[eax+AABB.y1]						;
 
 fld  dword[eax+AABB.z0]						;
 fadd st1										;
 fstp dword[eax+AABB.z0]						;
 fld  dword[eax+AABB.z1]						;
 faddp st1										;
 fstp dword[eax+AABB.z1]						;
 
 ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;