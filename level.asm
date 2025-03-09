extern _CreateFileW@28
extern _ReadFile@20
extern _CloseHandle@4
extern _glPushName@4
extern _glPopName@0
extern _glInitNames@0
extern _glDisableClientState@4
extern _glVertexPointer@16

Level: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 .width  equ 256
 .height equ 256
 .depth  equ 64
 .widthf  equ f(256.0)
 .heightf equ f(256.0)
 .depthf  equ f(64.0)
  
 section .data
 
 .filename dw u("level.dat"),0
 
 section .bss
 
 .blocks resb .width*.height*.depth
 .lightdepths resd .width*.height
 
 section .text
 
Level.init: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 xor  ecx,ecx									;
 .Lx:											;
  xor  esi,esi									;
  .Ly:											;
   xor  ebx,ebx									;
   .Lz:											;
   
    ;blocks[(y * this.height + z) * this.width + x] = (byte)((y <= d * 2 / 3) ? 1 : 0)
    mov  eax,esi								;
    shl  eax,8									;Level.height
    add  eax,ebx								;
    shl  eax,8									;Level.width
    add  eax,ecx								;
    add  eax,Level.blocks						;
    cmp  esi,42									;
    jbe  .Lz1Grass								;
    .Lz1Air:									;
     mov  byte[eax],0							;
     jmp  .Lz1D									;
    .Lz1Grass:									;
     mov  byte[eax],1							;
    .Lz1D:										;
    
    inc  ebx									;
    cmp  ebx,Level.height						;
    jb   .Lz									;
   inc  esi										;
   cmp  esi,Level.depth							;
   jb   .Ly										;
  inc  ecx										;
  cmp  ecx,Level.width							;
  jb   .Lx										;
 
 push Level.height								;
 push Level.width								;
 push 0											;
 push 0											;
 call Level.calclightdepths						;
 
 call Level.load								;
 
 ret
 
Level.load: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 push 0											;
 push 0x00000080								; FILE_ATTRIBUTE_NORMAL
 push 4											; OPEN_ALWAYS
 push 0											;
 push 0x00000003								; FILE_SHARE_READ | FILE_SHARE_WRITE
 push 0x80000000								; GENERIC_READ
 push Level.filename							;
 call _CreateFileW@28							;
 
 push eax										;
 
 push 0											;
 push _buffer									;
 push Level.width*Level.height*Level.depth		;
 push Level.blocks								;
 push eax										; file handle
 call _ReadFile@20								;
 
 call _CloseHandle@4							;
 
 call Levelrenderer.allchanged					;
 
 ret
 
Level.calclightdepths: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;for (int x2 = x0; x2 < x0 + x1; ++x2) {
 ; for (int z = y0; z < y0 + y1; ++z) {
 ;  final int oldDepth = this.lightDepths[x2 + z * this.width];
 ;  int y2;
 ;  for (y2 = this.depth - 1; y2 > 0 && !this.isLightBlocker(x2, y2, z); --y2) {}
 ;   if (oldDepth != (this.lightDepths[x2 + z * this.width] = y2)) {
 ;    final int yl0 = (oldDepth < y2) ? oldDepth : y2;
 ;    final int yl2 = (oldDepth > y2) ? oldDepth : y2;
 ;    for (int i = 0; i < this.levelListeners.size(); ++i) {
 ;    ((LevelListener)this.levelListeners.get(i)).lightColumnChanged(x2, z, yl0, yl2);
 ;   }
 ;  }
 ; }
 ;}
 
 %define x0 esp+4
 %define y0 esp+8
 %define x1 esp+12
 %define y1 esp+16
 
 mov  ebx,[x0]									;ebx x2 = x0
 add  [x1],ebx									; x1 += x0
 .L:											;
  mov  ecx,[y0]									;ecx z = y0
  add  [y1],ecx									; y1 += y0
  .LL:											;
   
   mov  eax,ecx									;
   mov  edx,Level.width							;
   mul  edx										;
   add  eax,ebx									;
   add  eax,Level.lightdepths					;
   push eax										;[[esp]] oldDepth = lightdepths[x2+z+width]
   
   mov  edx,Level.depth							;edx y2
   .LLL:										;
    dec  edx									; y2--
    call Level.islightblocker					;
    cmp  eax,0									;
    je   .LLLD									;
    cmp  edx,0									;
    jne  .LLL									;
    .LLLD:										;
   
   pop  eax										;
   mov  esi,[eax]								;esi oldDepth
   mov  [eax],edx								; lightdepths[x2+z+width] = y2
   cmp  esi,edx									; if oldDepth != y2>
   je   .LL1									; >skip
   
   cmp  esi,edx									;
   jg   .LLylg									;
   .LLyll:										;
    mov  edi,edx								;edi yl2 = y2
    jmp  .LLylD									;esi yl0 = oldDepth
   .LLylg:										;
    mov  edi,esi								;edi yl2 = oldDepth
    mov  esi,edx								;esi yl0 = y2
   .LLylD:										;
   
   call Levelrenderer.lightcolumnchanged		;
   
   .LL1:										;
   
   inc  ecx										;
   cmp  ecx,[y1]								;
   jl   .LL										;
  
  inc  ebx										;
  cmp  ebx,[x1]									;
  jl   .L										;
 
 ret 16
 
Level.isTile: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ebx x
;edx y
;ecx z
 ;x >= 0 && y >= 0 && z >= 0 && x < this.width && y < this.depth && z < this.height && this.blocks[(y * this.height + z) * this.width + x] == 1;
 
 cmp  ebx,Level.width							;
 jae  .false									;
 
 cmp  edx,Level.depth							;
 jae  .false									;
 
 cmp  ecx,Level.height							;
 jae  .false									;
 
 shl  edx,8										; Level.width
 add  edx,ecx									;
 shl  edx,8										; Level.height
 add  edx,ebx									;
 add  edx,Level.blocks							;
 
 cmp  byte[edx],1								;
 jne  .false									;
 
 .true:
 mov  eax,1
 
 ret
 
 .false:
 xor  eax,eax
 
 ret
 
Level.isSolidTile: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 jmp  Level.isTile
 
Level.islightblocker: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 jmp  Level.isSolidTile
 
Level.settile: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;[esp]    x
 ;[esp+4]  y
 ;[esp+8]  z
 ;[esp+12] type
 
 mov  ecx,[esp]									;
 cmp  ecx,0										;
 jl   .D										;
 cmp  ecx,Level.width							;
 jge  .D										;
 mov  ebx,[esp+8]								;
 cmp  ebx,0										;
 jl   .D										;
 cmp  ebx,Level.height							;
 jge  .D										;
 mov  edx,[esp+4]								;
 cmp  edx,0										;
 jl   .D										;
 cmp  edx,Level.depth							;
 jge  .D										;
 
 mov  eax,Level.height							;
 mul  edx										;
 add  eax,ebx									;
 mov  edx,Level.width							;
 mul  edx										;
 add  eax,ecx									;
 add  eax,Level.blocks							;
 mov  edx,[esp+12]								;
 mov  [eax],edx									;set block
 
 push 1											;
 push 1											;
 push dword[esp+8]								;
 push dword[esp]								;
 call Level.calclightdepths						;
 
 push dword[esp+8]								;
 push dword[esp+4]								;
 push dword[esp]								;
 call Levelrenderer.tilechanged					;
 
 .D:
 ret 16
 
Level.save: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ret
 
Levelrenderer: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 .xchunks equ Level.width>>4
 .ychunks equ Level.depth>>4
 .zchunks equ Level.width>>4
 .chunksize equ 57
 
 section .bss
 
 .chunks resb Levelrenderer.xchunks*Levelrenderer.ychunks*Levelrenderer.zchunks*Levelrenderer.chunksize
 
 section .text
 
Levelrenderer.init: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 mov  eax,Levelrenderer.chunks
 xor  ebx,ebx
 .L:
  cmp  ebx,Levelrenderer.xchunks<<4
  jae  .LD
  xor  ecx,ecx
  .LL:
   cmp  ecx,Levelrenderer.ychunks<<4
   jae  .LLD
   xor  edx,edx
   .LLL:
    cmp  edx,Levelrenderer.zchunks<<4
    jae  .LLLD
    push eax
    push ebx
    push ecx
    push edx
    
    add  edx,16
    add  ecx,16
    add  ebx,16
    push edx
    push ecx
    push ebx
    sub  edx,16
    sub  ecx,16
    sub  ebx,16
    push edx
    push ecx
    push ebx
    call Chunk.init
    
    pop  edx
    pop  ecx
    pop  ebx
    pop  eax
    add  eax,Levelrenderer.chunksize
    add  edx,16
    jmp  .LLL
    .LLLD:
   add  ecx,16
   jmp  .LL
   .LLD:
  add  ebx,16
  jmp  .L
  .LD:
 
 ret
 
Levelrenderer.setdirty: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;ebx x0
 ;esi y0
 ;edi z0
 ;edx x1
 ;eax y1
 ;ecx z1
 
 shr  ebx,4										;
 shr  edx,4										;
 shr  esi,4										;
 shr  eax,4										;
 shr  edi,4										;
 shr  ecx,4										;
 
 cmp  ebx,0										;
 jg   .clip1D									;
  mov  ebx,0									;
 .clip1D:										;
 cmp  esi,0										;
 jg   .clip2D									;
  mov  esi,0									;
 .clip2D:										;
 cmp  edi,0										;
 jg   .clip3D									;
  mov  edi,0									;
 .clip3D:										;
 cmp  edx,Levelrenderer.xchunks					;
 jl   .clip4D									;
  mov  edx,Levelrenderer.xchunks-1				;
 .clip4D:										;
 cmp  eax,Levelrenderer.ychunks					;
 jl   .clip5D									;
  mov  eax,Levelrenderer.ychunks-1				;
 .clip5D:										;
 cmp  ecx,Levelrenderer.zchunks					;
 jl   .clip6D									;
  mov  ecx,Levelrenderer.zchunks-1				;
 .clip6D:										;
 
 .Lx:											;
  push edx										; x1
  .Ly:											;
   push eax										; y1
   .Lz:											;
    mov  eax,esi								;
    mov  edx,Levelrenderer.xchunks				;
    mul  edx									;
    add  eax,ebx								;
    mov  edx,Levelrenderer.zchunks				;
    add  eax,edi								;
    add  eax,Levelrenderer.chunks				; (x0 + y0 * xchunks) * zchunks + z0
    											;Set the chunk dirty
    inc  edi									;
    cmp  edi,ecx								;
    jl   .Lz									;
   pop  eax										; y1
   inc  esi										;
   cmp  esi,eax									;
   jl   .Ly										;
  pop  edx										; x1
  inc  ebx										;
  cmp  ebx,edx									;
  jl   .Lx										;
 
 ret
 
Levelrenderer.lightcolumnchanged: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;ebx x
 ;ecx z
 ;esi y0
 ;edi y1
 
 push ecx										; preserve z
 push ebx										; preserve x
 
 mov  edx,ebx									;
 mov  eax,edi									;
 mov  edi,ecx									;
 
 dec  ebx										;
 inc  edx										;
 dec  esi										;
 inc  eax										;
 dec  edi										;
 inc  ecx										;
 call Levelrenderer.setdirty					;
 
 pop  ebx										; restore x
 pop  ecx										; restore z
 
 ret
 
Levelrenderer.allchanged: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 xor  ebx,ebx
 xor  esi,esi
 xor  edi,edi
 mov  edx,Level.width
 mov  eax,Level.depth
 mov  ecx,Level.height
 call Levelrenderer.setdirty
 
 ret
 
Levelrenderer.pick: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;grow...
 ;0 -= 3
 ;1 += 3
 sub  esp,24
 fld  dword[Player.bb.x1]						;
 fld  dword[Player.bb.y1]						;
 fld  dword[Player.bb.z1]						;
 fld  dword[Player.bb.x0]						;
 fld  dword[Player.bb.y0]						;
 fld  dword[Player.bb.z0]						;
 fld  tword[tloat3]								;
 fsub to st0									;
 fsub to st1									;
 fsub to st2									;
 fadd to st3									;
 fadd to st4									;
 faddp   st5									;
 fistp dword[esp+4]								;
 fistp dword[esp+12]							;
 fistp dword[esp+20]							;
 fistp dword[esp+0]								;
 fistp dword[esp+8]								;
 fistp dword[esp+16]							;[esp] z1, z0, y1, y0, x1, x0
 
 call _glInitNames@0							;???
 
 fld1											;st6 1
 fld  dword[esp+20]								;st5 x0
 mov  ecx,dword[esp+20]							;x0
 fld  st0										;
 mov  ebx,dword[esp+16]							;x1
 fadd st2										;st4 x0+1
 cmp  ecx,ebx									;
 jg   .LD										;
 .L:											;
  push ecx										;
  push ebx										;
  push ecx										;
  call _glPushName@4							;
  fld  dword[esp+20]							;st3 y0
  mov  ecx,dword[esp+20]						;y0
  fld  st0										;
  mov  ebx,dword[esp+16]						;y1
  fadd st2										;st2 y0+1
  cmp  ecx,ebx									;
  jg   .LLD										;
  .LL:											;
   push ecx										;
   push ebx										;
   push ecx										;
   call _glPushName@4							;
   fld  dword[esp+20]							;st1 z0
   mov  ecx,dword[esp+20]						;z0
   fld  st0										;
   mov  ebx,dword[esp+16]						;z1
   fadd st2										;st0 z0+1
   cmp  ecx,ebx									;
   jg   .LLLD									;
   .LLL:										;
    push ecx									;
    push ebx									;
    push ecx									;
    call _glPushName@4							;
     ;ifSolidTile...							;
     mov  ebx,[esp+12]							; y0
     shl  ebx,8									;
     add  ebx,[esp+4]							; z0
     shl  ebx,8									;
     add  ebx,[esp+20]							; x0
     test byte[ebx+Level.blocks],0x01			;
     jz   .LLLrenderD							;
     
     push 0										;
     call _glPushName@4							;
     mov  dword[Tesselator.vertices],0			;
     and  byte[Tesselator.f],(~Tesselator.f.hasColor)&(~Tesselator.f.hasTexture)
     
     ;0, 1, 2, 3, 4, 5							;;
     push 0										;;
     call _glPushName@4							;;
     ;renderface...
     ;;0  4  8  12 16 20 24 28 32 36 40 44
     ;;x2,y2,z3,x2,y2,z2,x3,y2,z2,x3,y2,z3
     fst  dword[Tesselator.vertexBuffer+8]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+44]		;;z0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+20]		;;z0
     fst  dword[Tesselator.vertexBuffer+32]		;;z0
     fincstp									;;
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+4]		;;y0
     fst  dword[Tesselator.vertexBuffer+16]		;;y0
     fst  dword[Tesselator.vertexBuffer+28]		;;y0
     fst  dword[Tesselator.vertexBuffer+40]		;;y0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+24]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+36]		;;x0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+0]		;;x0
     fst  dword[Tesselator.vertexBuffer+12]		;;x0
     fincstp									;;
     ;flush...
     push Tesselator.vertexBuffer				;;
     push 0										;;
     push 0x1406								;; GL_FLOAT
     push 3										;;
     call _glVertexPointer@16					;;???
     push 32884									;;
     call _glEnableClientState@4				;;???
     push 4										;; vertices
     push 0										;;
     push 7										;;
     call _glDrawArrays@12						;;???
     push 32884									;;
     call _glDisableClientState@4				;;???
     mov  dword[Tesselator.vertices],0			;;
     call _glPopName@0							;;
     fincstp									;;
     fincstp									;;
     
     push 1										;;
     call _glPushName@4							;;
     ;renderface...
     ;;0  4  8  12 16 20 24 28 32 36 40 44
     ;;x3,y3,z3,x3,y3,z2,x2,y3,z2,x2,y3,z3
     fst  dword[Tesselator.vertexBuffer+8]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+44]		;;z0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+20]		;;z0
     fst  dword[Tesselator.vertexBuffer+32]		;;z0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+4]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+16]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+28]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+40]		;;y0+1
     fincstp									;;
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+0]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+12]		;;x0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+24]		;;x0
     fst  dword[Tesselator.vertexBuffer+36]		;;x0
     fincstp									;;
     ;flush...
     push Tesselator.vertexBuffer				;;
     push 0										;;
     push 0x1406								;; GL_FLOAT
     push 3										;;
     call _glVertexPointer@16					;;???
     push 32884									;;
     call _glEnableClientState@4				;;???
     push 4										;; vertices
     push 0										;;
     push 7										;;
     call _glDrawArrays@12						;;???
     push 32884									;;
     call _glDisableClientState@4				;;???
     mov  dword[Tesselator.vertices],0			;;
     call _glPopName@0							;;
     fincstp									;;
     fincstp									;;
     
     push 2										;;
     call _glPushName@4							;;
     ;renderface...
     ;;0  4  8  12 16 20 24 28 32 36 40 44
     ;;x2,y3,z2,x3,y3,z2,x3,y2,z2,x2,y2,z2
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+8]		;;z0
     fst  dword[Tesselator.vertexBuffer+44]		;;z0
     fst  dword[Tesselator.vertexBuffer+20]		;;z0
     fst  dword[Tesselator.vertexBuffer+32]		;;z0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+4]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+16]		;;y0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+28]		;;y0
     fst  dword[Tesselator.vertexBuffer+40]		;;y0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+12]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+24]		;;x0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+0]		;;x0
     fst  dword[Tesselator.vertexBuffer+36]		;;x0
     fincstp									;;
     ;flush...
     push Tesselator.vertexBuffer				;;
     push 0										;;
     push 0x1406								;; GL_FLOAT
     push 3										;;
     call _glVertexPointer@16					;;???
     push 32884									;;
     call _glEnableClientState@4				;;???
     push 4										;; vertices
     push 0										;;
     push 7										;;
     call _glDrawArrays@12						;;???
     push 32884									;;
     call _glDisableClientState@4				;;???
     mov  dword[Tesselator.vertices],0			;;
     call _glPopName@0							;;
     fincstp									;;
     fincstp									;;
     
     push 3										;;
     call _glPushName@4							;;
     ;renderface...
     ;;0  4  8  12 16 20 24 28 32 36 40 44
     ;;x2,y3,z3,x2,y2,z3,x3,y2,z3,x3,y3,z3
     fst  dword[Tesselator.vertexBuffer+8]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+44]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+20]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+32]		;;z0+1
     fincstp									;;
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+4]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+40]		;;y0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+16]		;;y0
     fst  dword[Tesselator.vertexBuffer+28]		;;y0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+24]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+36]		;;x0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+0]		;;x0
     fst  dword[Tesselator.vertexBuffer+12]		;;x0
     fincstp									;;
     ;flush...
     push Tesselator.vertexBuffer				;;
     push 0										;;
     push 0x1406								;; GL_FLOAT
     push 3										;;
     call _glVertexPointer@16					;;???
     push 32884									;;
     call _glEnableClientState@4				;;???
     push 4										;; vertices
     push 0										;;
     push 7										;;
     call _glDrawArrays@12						;;???
     push 32884									;;
     call _glDisableClientState@4				;;???
     mov  dword[Tesselator.vertices],0			;;
     call _glPopName@0							;;
     fincstp									;;
     fincstp									;;
     
     push 4										;;
     call _glPushName@4							;;
     ;renderface...
     ;;0  4  8  12 16 20 24 28 32 36 40 44
     ;;x2,y3,z3,x2,y3,z2,x2,y2,z2,x2,y2,z3
     fst  dword[Tesselator.vertexBuffer+8]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+44]		;;z0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+20]		;;z0
     fst  dword[Tesselator.vertexBuffer+32]		;;z0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+4]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+16]		;;y0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+28]		;;y0
     fst  dword[Tesselator.vertexBuffer+40]		;;y0
     fincstp									;;
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+24]		;;x0
     fst  dword[Tesselator.vertexBuffer+36]		;;x0
     fst  dword[Tesselator.vertexBuffer+0]		;;x0
     fst  dword[Tesselator.vertexBuffer+12]		;;x0
     fincstp									;;
     ;flush...
     push Tesselator.vertexBuffer				;;
     push 0										;;
     push 0x1406								;; GL_FLOAT
     push 3										;;
     call _glVertexPointer@16					;;???
     push 32884									;;
     call _glEnableClientState@4				;;???
     push 4										;; vertices
     push 0										;;
     push 7										;;
     call _glDrawArrays@12						;;???
     push 32884									;;
     call _glDisableClientState@4				;;???
     mov  dword[Tesselator.vertices],0			;;
     call _glPopName@0							;;
     fincstp									;;
     fincstp									;;
     
     push 5										;;
     call _glPushName@4							;;
     ;renderface...
     ;;0  4  8  12 16 20 24 28 32 36 40 44
     ;;x3,y2,z3,x3,y2,z2,x3,y3,z2,x3,y3,z3
     fst  dword[Tesselator.vertexBuffer+8]		;;z0+1
     fst  dword[Tesselator.vertexBuffer+44]		;;z0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+20]		;;z0
     fst  dword[Tesselator.vertexBuffer+32]		;;z0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+28]		;;y0+1
     fst  dword[Tesselator.vertexBuffer+40]		;;y0+1
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+4]		;;y0
     fst  dword[Tesselator.vertexBuffer+16]		;;y0
     fincstp									;;
     fst  dword[Tesselator.vertexBuffer+24]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+36]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+0]		;;x0+1
     fst  dword[Tesselator.vertexBuffer+12]		;;x0+1
     fincstp									;;
     fincstp									;;
     ;flush...
     push Tesselator.vertexBuffer				;;
     push 0										;;
     push 0x1406								;; GL_FLOAT
     push 3										;;
     call _glVertexPointer@16					;;???
     push 32884									;;
     call _glEnableClientState@4				;;???
     push 4										;; vertices
     push 0										;;
     push 7										;;
     call _glDrawArrays@12						;;???
     push 32884									;;
     call _glDisableClientState@4				;;???
     mov  dword[Tesselator.vertices],0			;;
     call _glPopName@0							;;
     fincstp									;;
     fincstp									;;
     
     .LLLrenderD:								;
    call _glPopName@0							;
    pop  ebx									;
    pop  ecx									;
    fincstp										;
    ffree st7									;
    fincstp										;
    ffree st7									;
    inc  ecx									;
    cmp  ecx,ebx								;
    jle  .LLL									;
    .LLLD:										;
   call _glPopName@0							;
   pop  ebx										;
   pop  ecx										;
   fincstp										;
   ffree st7									;
   fincstp										;
   ffree st7									;
   inc  ecx										;
   cmp  ecx,ebx									;
   jle  .LL										;
   .LLD:										;
  call _glPopName@0								;
  pop  ebx										;
  pop  ecx										;
  fincstp										;
  ffree st7										;
  fincstp										;
  ffree st7										;
  inc  ecx										;
  cmp  ecx,ebx									;
  jle  .L										;
  .LD:											;
 
 add  esp,24									;
 
 ret
 
Levelrenderer.tilechanged: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;[esp+4]  x
 ;[esp+8]  y
 ;[esp+12] z
 
 mov  ebx,[esp+4]
 mov  edx,ebx
 dec  ebx
 inc  edx
 mov  esi,[esp+8]
 mov  eax,esi
 inc  esi
 dec  eax
 mov  edi,[esp+12]
 mov  ecx,edi
 inc  edi
 dec  ecx
 call Levelrenderer.setdirty
 
 ret 12
 
Levelrenderer.render0: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 mov  dword[Chunk.rebuiltThisFrame],0			;
 call Frustum.getFrustum						;
 mov ecx,Levelrenderer.chunks+Chunk.aabb		;eax chunk index
 .L:											;
  call Frustum.cubeInFrustum					;
  test edx,~0									;
  jnz  .Lskip									;
   call Chunk.render0							; eax chunk
  .Lskip:										;
  add ecx,Levelrenderer.chunksize				;
  cmp ecx,Levelrenderer.xchunks*Levelrenderer.ychunks*Levelrenderer.zchunks*Levelrenderer.chunksize+Levelrenderer.chunks+Chunk.aabb
  jb  .L										;
 
 ret
 
Levelrenderer.render1: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 mov  dword[Chunk.rebuiltThisFrame],0			;
 call Frustum.getFrustum						;
 mov ecx,Levelrenderer.chunks+Chunk.aabb		;eax chunk index
 .L:											;
  call Frustum.cubeInFrustum					;
  test edx,~0									;
  jnz  .Lskip									;
   call Chunk.render1							; eax chunk
  .Lskip:										;
  add ecx,Levelrenderer.chunksize				;
  cmp ecx,Levelrenderer.xchunks*Levelrenderer.ychunks*Levelrenderer.zchunks*Levelrenderer.chunksize+Levelrenderer.chunks+Chunk.aabb
  jb  .L										;
 
 ret
 
Levelrenderer.renderhit: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;