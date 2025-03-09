extern _timeGetTime@0

Timer: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 .tickspersecond equ f(60.0)
 
 section .bss
 .ticks    resd 1
 .lasttime resd 1
 .third    resb 1
 
 section .data
 .timescale  dd f(1.0)
 .fps        dd f(0.0)
 .passedtime dd f(0.0)
 
 section .text
 
Timer.init: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 call _timeGetTime@0
 mov  [Timer.lasttime],eax
 
 ret
 
Timer.advancetime: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 call _timeGetTime@0							;
 sub  eax,[Timer.lasttime]						;eax passed
 mov  dword[Timer.ticks],0						; reset ticks
 
 .1:											; 60ticks/second = 16.6666ms/tick
 cmp  byte[Timer.third],2						; 17, 17, 16
 jae  .2										;
 
 cmp  eax,17									;
 jb   .3										;
  inc  dword[Timer.ticks]						;
  add  dword[Timer.lasttime],17					;
  inc  byte[Timer.third]						;
  sub  eax,17									;
  cmp  eax,16									;
  jb   .3										;
  jmp  .1										;
 
 .2:											;
 cmp  eax,16									;
 jb   .3										;
  inc  dword[Timer.ticks]						;
  add  dword[Timer.lasttime],16					;
  mov  byte[Timer.third],0						;
  sub  eax,16									;
  cmp  eax,17									;
  jae  .1
 
 .3:											;
 
 ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;