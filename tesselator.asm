extern _glVertexPointer@12
extern _glTexCoordPointer@12
extern _glColorPointer@12
extern _glEnableClientState@4
extern _glDrawArrays@12
extern _glDisableClientState@4

Tesselator: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .bss
 
 .vertexBuffer   resd 300000
 .texCoordBuffer resd 200000
 .colorBuffer    resd 300000
 .vertices       resd 1
 .u              resd 1
 .v              resd 1
 .r              resd 1
 .b              resd 1
 .g              resd 1
 .f              resb 1
  .f.hasColor   equ 0x01
  .f.hasTexture equ 0x02
 
 section .text
 
Tesselator.init: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 mov  dword[Tesselator.vertices],0				;
 and  byte[Tesselator.f],(~Tesselator.f.hasColor)&(~Tesselator.f.hasTexture)
 
 ret
 
Tesselator.flush: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 push Tesselator.vertexBuffer					;
 push 0											;
 push 0x1406									; GL_FlOAT
 push 3											;
 call _glVertexPointer@12						;???
 test byte[Tesselator.f],Tesselator.f.hasTexture;
 jz   .texture1D								;
  push Tesselator.texCoordBuffer				;
  push 0										;
  push 0x1406									; GL_FlOAT
  push 2										;
  call _glTexCoordPointer@12					;???
  .texture1D:									;
 test byte[Tesselator.f],Tesselator.f.hasColor	;
 jz   .color1D									;
  push Tesselator.colorBuffer					;
  push 0										;
  push 0x1406									; GL_FlOAT
  push 3										;
  call _glColorPointer@12						;???
  .color1D:										;
 
 push 32884										; ???
 call _glEnableClientState@4					;???
 test byte[Tesselator.f],Tesselator.f.hasTexture;
 jz   .texture2D								;
  push 32888									; ???
  call _glEnableClientState@4					;???
  .texture2D:									;
 test byte[Tesselator.f],Tesselator.f.hasColor	;
 jz   .color2D									;
  push 32886									; ???
  call _glEnableClientState@4					;???
  .color2D:										;
 
 push dword[Tesselator.vertices]				;
 push 0											;
 push 7											;
 call _glDrawArrays@12							;???
 
 push 32884										; ???
 call _glDisableClientState@4					;???
 test byte[Tesselator.f],Tesselator.f.hasTexture;
 jz   .texture3D								;
  push 32888									; ???
  call _glDisableClientState@4					;???
  .texture3D:									;
 test byte[Tesselator.f],Tesselator.f.hasColor	;
 jz   .color3D									;
  push 32886									; ???
  call _glDisableClientState@4					;???
  .color3D:										;
 
Tesselator.clear: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 mov  dword[Tesselator.vertices],0				;
 
 ret
 
Tesselator.vertex: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;[esp+4]  x
;[esp+8]  y
;[esp+12] z
 
 mov  eax,[Tesselator.vertices]					;
 mov  ebx,eax									;
 shl  eax,1										;
 mov  ecx,eax									;
 add  eax,ebx									;
 mov  ebx,eax									;
 add  ebx,Tesselator.vertexBuffer				;
 mov  edx,[esp+4]								; x
 mov  [ebx],edx									;
 mov  edx,[esp+8]								; y
 mov  [ebx+4],edx								;
 mov  edx,[esp+12]								; z
 mov  [ebx+8],edx								;
 
 test byte[Tesselator.f],Tesselator.f.hasTexture;
 jz   .textureD									;
  add  ecx,Tesselator.texCoordBuffer			;
  mov  edx,[Tesselator.u]						; u
  mov  [ecx],edx								;
  mov  edx,[Tesselator.v]						; v
  mov  [ecx+4],edx								;
  .textureD:									;
 
 test byte[Tesselator.f],Tesselator.f.hasColor	;
 jz   .colorD									;
  add  eax,Tesselator.colorBuffer				;
  mov  edx,[Tesselator.r]						; r
  mov  [eax],edx								;
  mov  edx,[Tesselator.g]						; g
  mov  [eax+4],edx								;
  mov  edx,[Tesselator.b]						; b
  mov  [eax+8],edx								;
  .colorD:										;
 
 add  dword[Tesselator.vertices],4						;
 cmp  dword[Tesselator.vertices],400000				;
 jne  .flushD									;
  call Tesselator.flush							;
  .flushD:										;
 
 ret 12
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;