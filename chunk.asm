extern _glGenLists@4
extern _glNewList@8
extern _glBindTexture@8
extern _glEndList@0
extern _glCallList@4

Chunk: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 .aabb  equ 0
 .x0    equ 28
 .y0    equ 32
 .z0    equ 36
 .x1    equ 40
 .y1    equ 44
 .z1    equ 48
 .dirty equ 52
 .lists equ 53
 
 section .data
 
 section .bss
 
 .texture          resd 1
 .rebuiltThisFrame resd 1
 .updates          resd 1
 
 section .text
 
Chunk.init: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax chunk
;[esp+4]  x0
;[esp+8]  y0
;[esp+12] z0
;[esp+16] x1
;[esp+20] y1
;[esp+24] z1
 
 or   dword[eax+Chunk.dirty],0x01
 mov  dword[eax+Chunk.aabb+AABB.epsilon],f(0.0)
 pop  ebx
 fild dword[esp]
 fstp dword[eax+Chunk.aabb+AABB.x0]
 pop  ecx
 mov  dword[eax+Chunk.x0],ecx
 fild dword[esp]
 fstp dword[eax+Chunk.aabb+AABB.y0]
 pop  ecx
 mov  dword[eax+Chunk.y0],ecx
 fild dword[esp]
 fstp dword[eax+Chunk.aabb+AABB.z0]
 pop  ecx
 mov  dword[eax+Chunk.z0],ecx
 fild dword[esp]
 fstp dword[eax+Chunk.aabb+AABB.x1]
 pop  ecx
 mov  dword[eax+Chunk.x1],ecx
 fild dword[esp]
 fstp dword[eax+Chunk.aabb+AABB.y1]
 pop  ecx
 mov  dword[eax+Chunk.y1],ecx
 fild dword[esp]
 fstp dword[eax+Chunk.aabb+AABB.z1]
 pop  ecx
 mov  dword[eax+Chunk.z1],ecx
 push ebx
 push eax
 push 2
 call _glGenLists@4
 pop  ebx
 mov  dword[ebx+Chunk.lists],eax
 
 ret
 
Chunk.render0: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ecx instance
 
 test byte[ecx+Chunk.dirty],0x01
 jz   .norebuild
 cmp  dword[Chunk.rebuiltThisFrame],2
 je   .norebuild
 
 and  byte[ecx+Chunk.dirty],~0x01
 
 
 ;rebuild layer 0
 push ecx										;
 inc  dword[Chunk.updates]						;
 inc  dword[Chunk.rebuiltThisFrame]				;
 push 0x1300									;GL_COMPILE
 push dword[ecx+Chunk.lists]					;
 call _glNewList@8								;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glEnable@4								;
 push dword[Chunk.texture]						;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glBindTexture@8							;
 pop  ecx										;
 
 mov  ebx,[ecx+Chunk.x0]						;ebx x
 .0L:											;
  cmp  ebx,[ecx+Chunk.x1]						;
  jge  .1LD										;
  test ebx,0x80000000							;
  jnz  .1LD										;
  cmp  ebx,Level.width							;
  jge  .1LD										;
  mov  eax,[ecx+Chunk.y0]						;eax  y
  .0LL:											;
   cmp  eax,[ecx+Chunk.y1]						;
   jge  .1LLD									;
   test eax,0x80000000							;
   jnz  .1LLD									;
   cmp  eax,Level.depth							;
   jge  .1LLD									;
   mov  esi,[ecx+Chunk.z0]						;esi z
   .0LLL:										;
    cmp  esi,[ecx+Chunk.z1]						;
    jge  .1LLLD									;
    test esi,0x80000000							;
    jnz  .1LLLD									;
    cmp  esi,Level.height						;
    jge  .1LLLD									;
    ;isTile										;
    mov  edx,eax								; y
    shl  edx,8									;
    add  edx,esi								; z
    shl  edx,8									;
    add  edx,ebx								; x
    test byte[edx+Level.blocks],~0				;
    jz   .1LLLskip								;
    ;render tile								;
    push ecx									;
    push ebx									;
    push esi									;
    cmp  eax,42									;Level.depth * 2 / 3
    jne  .1LLLstone								;
    .0LLLgrass:									;
     call Tile.grass.render0					;render grass tile
     jmp  .1LLLstoneD							;
    .0LLLstone:									;
     call Tile.rock.render0						;render rock tile
     .0LLLstoneD:								;
    pop  esi									;
    pop  ebx									;
    pop  ecx									;
    .0LLLskip:									;
    inc  esi									;
    jmp  .1LLL									;
    .0LLLD:										;
   inc  eax										;
   jmp  .1LL									;
   .0LLD:										;
  inc  ebx										;
  jmp  .1L										;
  .0LD:											;
 
 push ecx										;
 call Tesselator.flush							;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glDisable@4								;
 call _glEndList@0								;
 pop  ecx										;
 
 
 ;rebuild layer 1
 push ecx										;
 inc  dword[Chunk.updates]						;
 inc  dword[Chunk.rebuiltThisFrame]				;
 push 0x1300									;GL_COMPILE
 mov  eax,dword[ecx+Chunk.lists]				;
 inc  eax										;
 push eax										;
 call _glNewList@8								;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glEnable@4								;
 push dword[Chunk.texture]						;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glBindTexture@8							;
 pop  ecx										;
 
 mov  ebx,[ecx+Chunk.x0]						;ebx x
 .1L:											;
  cmp  ebx,[ecx+Chunk.x1]						;
  jge  .1LD										;
  test ebx,0x80000000							;
  jnz  .1LD										;
  cmp  ebx,Level.width							;
  jge  .1LD										;
  mov  eax,[ecx+Chunk.y0]						;eax  y
  .1LL:											;
   cmp  eax,[ecx+Chunk.y1]						;
   jge  .1LLD									;
   test eax,0x80000000							;
   jnz  .1LLD									;
   cmp  eax,Level.depth							;
   jge  .1LLD									;
   mov  esi,[ecx+Chunk.z0]						;esi z
   .1LLL:										;
    cmp  esi,[ecx+Chunk.z1]						;
    jge  .1LLLD									;
    test esi,0x80000000							;
    jnz  .1LLLD									;
    cmp  esi,Level.height						;
    jge  .1LLLD									;
    ;isTile										;
    mov  edx,eax								; y
    shl  edx,8									;
    add  edx,esi								; z
    shl  edx,8									;
    add  edx,ebx								; x
    test byte[edx+Level.blocks],~0				;
    jz   .1LLLskip								;
    ;render tile								;
    push ecx									;
    push ebx									;
    push esi									;
    cmp  eax,42									;Level.depth * 2 / 3
    jne  .1LLLstone								;
    .1LLLgrass:									;
     call Tile.grass.render1					;render grass tile
     jmp  .1LLLstoneD							;
    .1LLLstone:									;
     call Tile.rock.render1						;render rock tile
     .1LLLstoneD:								;
    pop  esi									;
    pop  ebx									;
    pop  ecx									;
    .1LLLskip:									;
    inc  esi									;
    jmp  .1LLL									;
    .1LLLD:										;
   inc  eax										;
   jmp  .1LL									;
   .1LLD:										;
  inc  ebx										;
  jmp  .1L										;
  .1LD:											;
 
 push ecx										;
 call Tesselator.flush							;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glDisable@4								;
 call _glEndList@0								;
 pop  ecx										;
 
 
 .norebuild:
 
 push dword[ecx+Chunk.lists]					;
 call _glCallList@4								;
 
 ret
 
Chunk.render1: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ecx instance
 
 test byte[ecx+Chunk.dirty],0x01
 jz   .norebuild
 cmp  dword[Chunk.rebuiltThisFrame],2
 je   .norebuild
 
 and  byte[ecx+Chunk.dirty],~0x01
 
 
 ;rebuild layer 0
 push ecx										;
 inc  dword[Chunk.updates]						;
 inc  dword[Chunk.rebuiltThisFrame]				;
 push 0x1300									;GL_COMPILE
 push dword[ecx+Chunk.lists]					;
 call _glNewList@8								;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glEnable@4								;
 push dword[Chunk.texture]						;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glBindTexture@8							;
 pop  ecx										;
 
 mov  ebx,[ecx+Chunk.x0]						;ebx x
 .0L:											;
  cmp  ebx,[ecx+Chunk.x1]						;
  jge  .1LD										;
  test ebx,0x80000000							;
  jnz  .1LD										;
  cmp  ebx,Level.width							;
  jge  .1LD										;
  mov  eax,[ecx+Chunk.y0]						;eax  y
  .0LL:											;
   cmp  eax,[ecx+Chunk.y1]						;
   jge  .1LLD									;
   test eax,0x80000000							;
   jnz  .1LLD									;
   cmp  eax,Level.depth							;
   jge  .1LLD									;
   mov  esi,[ecx+Chunk.z0]						;esi z
   .0LLL:										;
    cmp  esi,[ecx+Chunk.z1]						;
    jge  .1LLLD									;
    test esi,0x80000000							;
    jnz  .1LLLD									;
    cmp  esi,Level.height						;
    jge  .1LLLD									;
    ;isTile										;
    mov  edx,eax								; y
    shl  edx,8									;
    add  edx,esi								; z
    shl  edx,8									;
    add  edx,ebx								; x
    test byte[edx+Level.blocks],~0				;
    jz   .1LLLskip								;
    ;render tile								;
    push ecx									;
    push ebx									;
    push esi									;
    cmp  eax,42									;Level.depth * 2 / 3
    jne  .1LLLstone								;
    .0LLLgrass:									;
     call Tile.grass.render0					;render grass tile
     jmp  .1LLLstoneD							;
    .0LLLstone:									;
     call Tile.rock.render0						;render rock tile
     .0LLLstoneD:								;
    pop  esi									;
    pop  ebx									;
    pop  ecx									;
    .0LLLskip:									;
    inc  esi									;
    jmp  .1LLL									;
    .0LLLD:										;
   inc  eax										;
   jmp  .1LL									;
   .0LLD:										;
  inc  ebx										;
  jmp  .1L										;
  .0LD:											;
 
 push ecx										;
 call Tesselator.flush							;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glDisable@4								;
 call _glEndList@0								;
 pop  ecx										;
 
 
 ;rebuild layer 1
 push ecx										;
 inc  dword[Chunk.updates]						;
 inc  dword[Chunk.rebuiltThisFrame]				;
 push 0x1300									;GL_COMPILE
 mov  eax,dword[ecx+Chunk.lists]				;
 inc  eax										;
 push eax										;
 call _glNewList@8								;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glEnable@4								;
 push dword[Chunk.texture]						;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glBindTexture@8							;
 pop  ecx										;
 
 mov  ebx,[ecx+Chunk.x0]						;ebx x
 .1L:											;
  cmp  ebx,[ecx+Chunk.x1]						;
  jge  .1LD										;
  test ebx,0x80000000							;
  jnz  .1LD										;
  cmp  ebx,Level.width							;
  jge  .1LD										;
  mov  eax,[ecx+Chunk.y0]						;eax  y
  .1LL:											;
   cmp  eax,[ecx+Chunk.y1]						;
   jge  .1LLD									;
   test eax,0x80000000							;
   jnz  .1LLD									;
   cmp  eax,Level.depth							;
   jge  .1LLD									;
   mov  esi,[ecx+Chunk.z0]						;esi z
   .1LLL:										;
    cmp  esi,[ecx+Chunk.z1]						;
    jge  .1LLLD									;
    test esi,0x80000000							;
    jnz  .1LLLD									;
    cmp  esi,Level.height						;
    jge  .1LLLD									;
    ;isTile										;
    mov  edx,eax								; y
    shl  edx,8									;
    add  edx,esi								; z
    shl  edx,8									;
    add  edx,ebx								; x
    test byte[edx+Level.blocks],~0				;
    jz   .1LLLskip								;
    ;render tile								;
    push ecx									;
    push ebx									;
    push esi									;
    cmp  eax,42									;Level.depth * 2 / 3
    jne  .1LLLstone								;
    .1LLLgrass:									;
     call Tile.grass.render1					;render grass tile
     jmp  .1LLLstoneD							;
    .1LLLstone:									;
     call Tile.rock.render1						;render rock tile
     .1LLLstoneD:								;
    pop  esi									;
    pop  ebx									;
    pop  ecx									;
    .1LLLskip:									;
    inc  esi									;
    jmp  .1LLL									;
    .1LLLD:										;
   inc  eax										;
   jmp  .1LL									;
   .1LLD:										;
  inc  ebx										;
  jmp  .1L										;
  .1LD:											;
 
 push ecx										;
 call Tesselator.flush							;
 push 0x0DE1									;GL_TEXTURE_2D
 call _glDisable@4								;
 call _glEndList@0								;
 pop  ecx										;
 
 
 .norebuild:
 
 mov  eax,dword[ecx+Chunk.lists]				;
 inc  eax										;
 push eax										;
 call _glCallList@4								;
 
 ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;