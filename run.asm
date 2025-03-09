extern _glTranslatef@12
extern _glRenderMode@4
extern _glClear@4
extern _gluPerspective@16
extern _glTranslatef@12
extern _glRotatef@16
extern _glRotatef@16
extern _glTranslatef@12
extern _glFogi@8
extern _glFogf@8
extern _glFogfv@8
extern _glDisable@4
extern _glDisable@4
extern _glDisable@4
extern _glSelectBuffer@8
extern _glGetIntegerv@8
extern _gluPickMatrix@20

extern _glClearColor@16
extern _glColor3f@12
extern _glBegin@4
extern _glOrtho@24
extern _glVertex2f@8
extern _glEnd@0
extern _glFlush@0

extern _GetLastError@0

 %include "common.asm"

section .data

;fld1: dt 1.0

floattest: dd 0x00000000, 0x20000000
           dw 0x4000

fld1: dw 0x0000
      dd 0x00000000
      dd 0x3FFF8000


section .bss

fst1 resd 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;run
 
 global TheVeryBeginning
 section .text
 TheVeryBeginning:
  call fStartup
  ;we begin!
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;temp.
  
  ;call WNinit									;
  
  ;push f(0.0)
  ;push f(0.0)
  ;push f(0.0)
  ;push f(0.0)
  ;call _glClearColor@16
  ;push 0x4000									;GL_COLOR_BUFFER_BIT
  ;call _glClear@4
  ;push f(1.0)
  ;push f(1.0)
  ;push f(1.0)
  ;call _glColor3f@12
  ;push f(1.0)
  ;push f(-1.0)
  ;push f(1.0)
  ;push f(-1.0)
  ;push f(1.0)
  ;push f(-1.0)
  ;call _glOrtho@24
  ;push 0x9										;GL_POLYGON
  ;call _glBegin@4
  ;push f(-0.5)
  ;push f(-0.5)
  ;call _glVertex2f@8
  ;push f(0.5)
  ;push f(-0.5)
  ;call _glVertex2f@8
  ;push f(0.5)
  ;push f(0.5)
  ;call _glVertex2f@8
  ;push f(-0.5)
  ;push f(0.5)
  ;call _glVertex2f@8
  ;call _glEnd@0
  ;call _glFlush@0
  
  ;forefer:
  ; cmp  byte[_closerequest],1					;
  ; je   fShutdown								;quit
  ; test byte[keys+(0x1B>>3)],0x01<<(0x1B&0x07)	; VK_ESCAPE
  ; jne  fShutdown								;quit
  ;call WNupdate
  ;jmp forefer
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  call WNinit									;
  
  call GLinit									;
  
  call Level.init								;
  
  call Levelrenderer.init						;
  
  call Player.init								;
  
  call Timer.init
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;sub  esp,8									;
  ;push esp										;
  ;call _GetSystemTimeAsFileTime@4				;
  ;pop  ecx										;ecx low
  ;pop  eax										;eax high
  ;xor  edx,edx									;
  ;mov  esi,10000								;
  ;div  esi										;
  ;mov  ebx,eax									;
  ;mov  eax,ecx									;
  ;mov  esi,10000								;
  ;div  esi										; / 10000
  ;sub  edx,11643609600000>>32					;
  ;sub  eax,11643609600000&0xFFFFFFFF			; - 11,643,609,600,000
  ;mov  [lasttime],eax
  ;mov  [lasttime+4],ebx
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  call _timeGetTime@0							;
  push eax										;
  
  
  forever:										;
   cmp  byte[_closerequest],1					;
   je   fShutdown								;quit
   test byte[keys+(0x1B>>3)],0x01<<(0x1B&0x07)	; VK_ESCAPE
   jne  fShutdown								;quit
   
   
   
   call Timer.advancetime						;advance ticks
   cmp  dword[Timer.ticks],0					;
   jz   .tickLD									;
   .tickL:										;
    call Player.tick							;tick
    dec  dword[Timer.ticks]						;
    cmp  dword[Timer.ticks],0					;
    jnz  .tickL									;
    .tickLD:									;
   
   
   
   call Player.turn								; player turns around
   
   .pick:										;
    push selectBuffer							;
    push 8000									;
    call _glSelectBuffer@8						; select selectBuffer for mode values
    push 0x1C02									; GL_SELECT
    call _glRenderMode@4						; set the rasterization to selection mode
    
    											;Set up pick camera
    push 0x1701									; GL_PROJECTION
    call _glMatrixMode@4						;Set the matrix to the projection matrix stack
    call _glLoadIdentity@0						;Load the identity matrix
    ;mov  dword[viewportBuffer],0				;
    ;mov  dword[viewportBuffer+4],0				;
    ;mov  dword[viewportBuffer+8],0				;
    ;mov  dword[viewportBuffer+12],0				;
    ;mov  dword[viewportBuffer+16],0				;
    ;mov  dword[viewportBuffer+20],0				;
    ;mov  dword[viewportBuffer+24],0				;
    ;mov  dword[viewportBuffer+28],0				;
    ;mov  dword[viewportBuffer+32],0				;
    ;mov  dword[viewportBuffer+36],0				;
    ;mov  dword[viewportBuffer+40],0				;
    ;mov  dword[viewportBuffer+44],0				;
    ;mov  dword[viewportBuffer+48],0				;
    ;mov  dword[viewportBuffer+52],0				;
    ;mov  dword[viewportBuffer+56],0				;
    ;mov  dword[viewportBuffer+60],0				;
    push viewportBuffer							;
    push 0x0BA2									; GL_VIEWPORT
    call _glGetIntegerv@8						;Get the x, y, width, and height of the viewport
    push viewportBuffer							; viewport
    push d(5.0)>>32								;
    push d(5.0)&0xFFFFFFFF						; width
    push d(5.0)>>32								;
    push d(5.0)&0xFFFFFFFF						; height
    push d(384.0)>>32;WNinit.HEIGHT/2			;
    push d(384.0)&0xFFFFFFFF					; y
    push d(512.0)>>32;WNinit.WIDTH/2			;
    push d(512.0)&0xFFFFFFFF					; x
    call _gluPickMatrix@20						;Define the picking region
    push d(1000.0)>>32							; 
    push d(1000.0)&0xFFFFFFFF					; far clipping plane
    push d(0.05)>>32							; 
    push d(0.05)&0xFFFFFFFF						; near clipping plane
    push d(1.33333333)>>32;WNinit.WIDTH/WNinit.HEIGHT
    push d(1.33333333)&0xFFFFFFFF				; aspect
    push d(70.0)>>32							; 
    push d(70.0)&0xFFFFFFFF						; fovy
	call _gluPerspective@16						;Set up a perspective projection matrix
    push 0x1700									; GL_MODELVIEW
    call _glMatrixMode@4						;Set the matrix to the model matrix stack
    call _glLoadIdentity@0						;Load the identity matrix
    
    											;Move camera to player
    push f(-0.3)								; z
    push f(0.0)									; y
    push f(0.0)									; x
    call _glTranslatef@12						;Multiply the current matrix by a translation matrix
    push f(0.0)									; z
    push f(0.0)									; y
    push f(1.0)									; x
    push dword[Player.xRot]						; angle
    call _glRotatef@16							;Multiply the current matrix by a rotation matrix
    push f(0.0)									; z
    push f(1.0)									; y
    push f(0.0)									; x
    push dword[Player.yRot]						; angle
    call _glRotatef@16							;Multiply the current matrix by a rotation matrix
    mov  eax,Player.zo							;
    not  eax									;
    inc  eax									;
    push eax									; (do extra stuff if you skip ticks)
    mov  eax,Player.yo							; (this.player.xo + (this.player.x - this.player.xo) * a)
    not  eax									; (a = number of ticks skipped when tick count exceeds 100)
    inc  eax									;
    push eax									;
    mov  eax,Player.xo							;
    not  eax									;
    inc  eax									;
    push eax									;
    call _glTranslatef@12						;
    
    call Levelrenderer.pick						; (this.player)
    push 0x1C00									; GL_RENDER   return the number of hits from GL_SELECT before
    call _glRenderMode@4						; set the rasterization to render mode and return the number of hit records transferred to the select buffer
    
    											;Pick
    times 13 push 0								;esp+12   names
    											;[esp+8]  hitNameCount
    											;[esp+4]  closest
    push eax									;[esp]    hits
    mov  ebx,selectBuffer						;ebx selectBuffer
    cmp  dword[esp],0							; if there are no more hits>
    je   .pick.LD								; >end loop
    mov  eax,[ebx+4]							;
    jmp  .pick.Lhit								;
    .pick.L:									;
     mov  eax,[ebx+4]							;eax dist
     cmp  eax,[esp+4]							; if dist is not less than closest>
     jnb  .pick.L.skip							; >skip hit
     .pick.Lhit:								;;hit
     mov  [esp+4],eax							;;closest = dist
     mov  ecx,[ebx]								;;ecx nameCount
     mov  [esp+8],ecx							;;hitNameCount = nameCount
     add  ebx,12								;;
     mov  edx,esp								;;
     add  edx,12								;;edx names
     .pick.L.L:									;;
      cmp  ecx,0								;;
      je   .pick.L.LD							;;
      mov  eax,[ebx]							;;
      mov  [edx],eax							;; put in name
      add  ebx,4								;;
      add  edx,4								;;
      dec  ecx									;;
      jmp  .pick.L.L							;;
      .pick.L.LD:								;;
     .pick.L.L2:								;;
      lea  eax,[esp+52]							;;
      cmp  edx,eax								;;
      je   .pick.L.L2D							;;
      mov  dword[edx],0							;; fill the rest with 0
      add  edx,4								;;
      jmp  .pick.L.L2							;;
      .pick.L.L2D:								;;
     dec  dword[esp]							;
     cmp  dword[esp],0							; if there are no more hits>
     jne  .pick.L								; >end loop
     jmp  .pick.LD								;
     .pick.L.skip:								;;skip hit
      mov  ecx,[ebx]							;;
      shl  ecx,2								;;
      add  ebx,ecx								;;
      add  ebx,12								;; add the namecount to selectBuffer
      dec  dword[esp]							;;
      cmp  dword[esp],0							;; if there are no more hits>
      jne  .pick.L								;; >end loop
     .pick.LD:									;
    cmp  dword[esp+8],0							;
    je   .pick.nohits							;
     mov  eax,[esp+12]							;
     mov  [hitResult.x],eax						;
     mov  eax,[esp+16]							;
     mov  [hitResult.y],eax						;
     mov  eax,[esp+20]							;
     mov  [hitResult.z],eax						;
     mov  eax,[esp+24]							;
     mov  [hitResult.o],eax						;
     mov  eax,[esp+28]							;
     mov  [hitResult.f],eax						;
     jmp  .pick.nohitsD							;
    .pick.nohits:								;
     mov  dword[hitResult.x],0					;
     mov  dword[hitResult.y],0					;
     mov  dword[hitResult.z],0					;
     mov  dword[hitResult.o],0					;
     mov  dword[hitResult.f],0					;
     .pick.nohitsD:								;
    add  esp,56									;
    
    .pickD:
   
   test byte[WNproc.mButtons],0x01				;
   jz   .placeblockD							;
    push 0										;
    push dword[hitResult.z]						;
    push dword[hitResult.y]						;
    push dword[hitResult.x]						;
    call Level.settile							;Place block
    .placeblockD:								;
   
   test byte[WNproc.mButtons],0x02				;
   jz   .destroyblockD							;
    mov  eax,[hitResult.f]						;
    shl  eax,2									;
    add  eax,.destroyblock.pFaces				;
    jmp  dword[eax]								;
    section .data								;
    .destroyblock.pFaces:						;
    dd .destroyblock.ym,.destroyblock.yp		;
    dd .destroyblock.zm,.destroyblock.zp		;
    dd .destroyblock.xm,.destroyblock.xp		;
    section .text								;
    .destroyblock.ym:							;
     dec  dword[hitResult.y]					;
    .destroyblock.yp:							;
     inc  dword[hitResult.y]					;
    .destroyblock.zm:							;
     dec  dword[hitResult.z]					;
    .destroyblock.zp:							;
     inc  dword[hitResult.z]					;
    .destroyblock.xm:							;
     dec  dword[hitResult.x]					;
    .destroyblock.xp:							;
     inc  dword[hitResult.x]					;
    push 0										;
    push dword[hitResult.z]						;
    push dword[hitResult.y]						;
    push dword[hitResult.x]						;
    call Level.settile							;Destroy block
    .destroyblockD:								;
   
   test byte[keys+1],0x20						; ENTER key
   jz   .savelevelD								;
    call Level.save								;Save level
    .savelevelD:								;
   
   push 0x4100									; GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
   call _glClear@4								;Clear the depth and color buffer
   
   												;Set up camera
   push 0x1701									; GL_PROJECTION
   call _glMatrixMode@4							;Set the matrix to the projection matrix stack
   call _glLoadIdentity@0						;Load the identity matrix
   
   push d(1000.0)>>32							;
   push d(1000.0)&0xFFFFFFFF					; far clipping plane
   push d(0.05)>>32								;
   push d(0.05)&0xFFFFFFFF						; near clipping plane
   push d(1.33333333)>>32;WNinit.WIDTH/WNinit.HEIGHT
   push d(1.33333333)&0xFFFFFFFF				; aspect
   push d(70.0)>>32								;
   push d(70.0)&0xFFFFFFFF						; fov
   call _gluPerspective@16						;Set up a perspective projection matrix
   
   push 0x1700									; GL_MODELVIEW
   call _glMatrixMode@4							;Set the matrix to the model matrix stack
   call _glLoadIdentity@0						;Load the identity matrix
   
   												;Move camera to player
   push f(-0.3)									; z
   push f(0.0)									; y
   push f(0.0)									; x
   call _glTranslatef@12						;Multiply the current matrix by a translation matrix
   push f(0.0)									; z
   push f(0.0)									; y
   push f(1.0)									; x
   push dword[Player.xRot]						; angle
   call _glRotatef@16							;Multiply the current matrix by a rotation matrix
   push f(0.0)									; z
   push f(1.0)									; y
   push f(0.0)									; x
   push dword[Player.yRot]						; angle
   call _glRotatef@16							;Multiply the current matrix by a rotation matrix
   mov  eax,Player.zo							;
   not  eax										;
   inc  eax										;
   push eax										; (do extra stuff if you skip ticks)
   mov  eax,Player.yo							; (this.player.xo + (this.player.x - this.player.xo) * a)
   not  eax										; (a = number of ticks skipped when tick count exceeds 100)
   inc  eax										;
   push eax										;
   mov  eax,Player.xo							;
   not  eax										;
   inc  eax										;
   push eax										;
   call _glTranslatef@12						;
   
   push 0x0B44									; GL_CULL_FACE
   call _glEnable@4								;Enable face culling
   push 0x0B60									; GL_FOG
   call _glEnable@4								;Enable fog
   push 0x0800									; GL_EXP
   push 0x0B65									; GL_FOG_MODE
   call _glFogi@8								;Set the fog equation to exp
   push f(0.2)									; density
   push 0x0B62									; GL_FOG_DENSITY
   call _glFogf@8								;Set the fog density to 0.2
   push fogcolor								; color
   push 0x0B66									; GL_FOG_COLOR
   call _glFogfv@8								;Set the fog color
   push 0x0B60									; GL_FOG
   call _glDisable@4							;Disable fog
   call Levelrenderer.render0					;
   push 0x0B60									; GL_FOG
   call _glEnable@4								;Enable fog
   call Levelrenderer.render1					;
   push 0x0DE1									; GL_TEXTURE_2D
   call _glDisable@4							;Disable two-dimensional texturing
   
   cmp  dword[hitResult.x],0					;
   jne  .renderhit								;
   cmp  dword[hitResult.y],0					;
   jne  .renderhit								;
   cmp  dword[hitResult.z],0					;
   jne  .renderhit								;
   cmp  dword[hitResult.o],0					;
   jne  .renderhit								;
   cmp  dword[hitResult.f],0					;
   jne  .renderhit								;
    call Levelrenderer.renderhit				;
   .renderhit:									;
   push 0x0B60									; GL_FOG
   call _glDisable@4							;Disable fog
   
   
   
   call WNupdate								;Update the window
   
   inc  dword[frames]							;
   call _timeGetTime@0							;eax time in milliseconds
   pop  ebx										;ebx lastTime
   push ebx										;[esp] lastTime
   add  ebx,1000								;lastTime += 1000
   cmp  eax,ebx									;
   jb   .waitLD									;
   .waitL:										;
    push dword[frames]							;; print frames
    mov  eax,tFrames							;;
    call fPrint									;;
    add  dword[esp],1000						; lastTime
    mov  dword[frames],0						; frames
    call _timeGetTime@0							;eax time in milliseconds
    pop  ebx									;ebx lastTime
    push ebx									;[esp] lastTime
    add  ebx,1000								;lastTime += 1000
    cmp  eax,ebx								;
    jae  .waitL									;
    .waitLD:
   
   
   jmp  forever
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  push __?float32?__(74.0)
  fld  st2
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;we end.
  call fShutdown
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .data
 
 tHello db "Hello, World!",EM
 tHex8  db "0x",PS,PSHEX8,LN,EM
 tX     db LN, LN, "x: ", 0
 tY     db LN, "y: ", 0
 tZ     db LN, "z: ", 0
 tXRot  db LN, "xRot: ", 0
 tYRot  db LN, "yRot: ", 0
 tFrames db PS,PSDEC," fps",LN,0
 
 fogcolor dd f(0.05490196), f(0.0431372549), f(0.039215686), f(1.0)
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .bss
 
 _closerequest resb 1
 keys resb 32
 selectBuffer resd 2000
 viewportBuffer resd 16
 hitResult:
 .x resd 1
 .y resd 1
 .z resd 1
 .o resd 1
 .f resd 1
 
 lasttime resq 1
 frames   resd 1
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;init
; put fog color
; create display
; create keyboard and mouse
; GL
; new level
; new level renderer
; new player
; grab mouse
;time and frames
;loop
; advance time
; tick
; render
; increment frames
; loop
;  "fps, chunk updates"
;  add time
;  reset frames
;destroy
;
;tick
; player tick
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;include
 
 %include "window.asm"
 %include "gl.asm"
 %include "level.asm"
 %include "chunk.asm"
 %include "tile.asm"
 %include "player.asm"
 %include "aabb.asm"
 %include "tesselator.asm"
 %include "frustum.asm"
 %include "timer.asm"
