Tile: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .text
 
Tile.rock.render0: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax y
;ebx x
;esi z
;edx block	;can't be broken into smaller bits for x+1 and x-1
 
 ;x = 1
 ;y = 65536
 ;z = 256
 
 xor  ebx,ebx									;ebx vertices*3
 xor  ecx,ecx									;ecx vertices*2
 
 push ebx										;
 fild dword[esp]								;
 inc  ebx										;
 push ebx										;
 fild dword[esp]								;
 push eax										;
 fild dword[esp]								;
 inc  eax										;
 push eax										;
 fild dword[esp]								;
 dec  eax										;
 push esi										;
 fild dword[esp]								;
 inc  esi										;
 push esi										;
 fild dword[esp]								;
 add  esp,24									;st0 z1,  st1 z0,  st2 y1,  st3 y0,  st4 x1,  st5 x0
 
 xor  edi,edi									;
 mov  di,dx										;edi lightdepths+xz
 mov  edi,dword[edi+Level.lightdepths]			;edi lightdepth
 
 test eax,~0									;
 je   .1light									;
 test byte[edx+Level.blocks-65536],~0			;x, y-1, z
 jnz  .1D										;
 inc  edi										;
 cmp  eax,edi									;
 jl   .1dark									;
 .1light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0)			;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(1.0)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(1.0)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(1.0)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(1.0)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(1.0)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(1.0)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(1.0)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(1.0)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(1.0)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(1.0)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(1.0)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(1.0)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .1lightD								;
 .1dark:										;
  .1darkD:										;
 dec  edi										;
 .1D:											;
 
 cmp  eax,63									;Level.depth=1
 je   .2light									;
 test byte[edx+Level.blocks+65536],~0			;x, y+1, z
 jnz  .2D										;
 dec  edi										;
 cmp  eax,edi									;
 jl   .2dark									;
 .2light:										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(1.0)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(1.0)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(1.0)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(1.0)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(1.0)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(1.0)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0)			;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(1.0)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(1.0)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(1.0)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0)			;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(1.0)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(1.0)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(1.0)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .2lightD								;
 .2dark:										;
  .2darkD:										;
 inc  edi										;
 .2D:											;
 
 xor  edi,edi									;
 mov  di,dx										;di lightdepths index
 
 test dh,~0										;
 jz   .3light									;
 test byte[edx+Level.blocks-256],~0				;x, y, z-1
 jnz  .3D										;
 cmp  eax,[edi+Level.lightdepths-256]			;x, z-1
 jl   .3dark									;
 .3light:										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0)			;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  ;jmp  .3lightD								;
 .3dark:										;
  .3darkD:										;
 .3D:											;
 
 cmp  dh,255									;Level.height-1
 jz   .4light									;
 test byte[edx+Level.blocks+256],~0				;x, y, z+1
 jnz  .4D										;
 cmp  eax,[edi+Level.lightdepths+256]			;x, z+1
 jl   .4dark									;
 .4light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0)			;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  ;jmp  .3lightD								;
 .4dark:										;
  .4darkD:										;
 .4D:											;
 
 test dl,~0										;
 jz   .5light									;
 test byte[edx+Level.blocks-1],~0				;x-1, y, z
 jnz  .5D										;
 cmp  eax,[edi+Level.lightdepths-1]				;x-1, z
 jl   .5dark									;
 .5light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.6)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.6)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.6)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.6)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.6)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.6)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0)			;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.6)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.6)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.6)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.6)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.6)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.6)			;3 blue
  ;jmp  .3lightD								;
 .5dark:										;
  .5darkD:										;
 .5D:											;
 
 cmp  dl,255									;Level.width-1
 jz   .6light									;
 test byte[edx+Level.blocks+1],~0				;x+1, y, z
 jnz  .6D										;
 cmp  eax,[edi+Level.lightdepths+1]				;x+1, z
 jl   .6dark									;
 .6light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0)			;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.6)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.6)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.6)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.6)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.6)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.6)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.6)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.6)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.6)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0)			;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.6)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.6)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.6)			;3 blue
  ;jmp  .3lightD								;
 .6dark:										;
  .6darkD:										;
 .6D:											;
 
 ret
 
Tile.grass.render0: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax y
;ebx x
;esi z
;edx block	;can't be broken into smaller bits for x+1 and x-1
 
 ;x = 1
 ;y = 65536
 ;z = 256
 
 xor  ebx,ebx									;ebx vertices*3
 xor  ecx,ecx									;ecx vertices*2
 
 push ebx										;
 fild dword[esp]								;
 inc  ebx										;
 push ebx										;
 fild dword[esp]								;
 push eax										;
 fild dword[esp]								;
 inc  eax										;
 push eax										;
 fild dword[esp]								;
 dec  eax										;
 push esi										;
 fild dword[esp]								;
 inc  esi										;
 push esi										;
 fild dword[esp]								;
 add  esp,24									;st0 z1,  st1 z0,  st2 y1,  st3 y0,  st4 x1,  st5 x0
 
 xor  edi,edi									;
 mov  di,dx										;edi lightdepths+xz
 mov  edi,dword[edi+Level.lightdepths]			;edi lightdepth
 
 test eax,~0									;
 je   .1light									;
 test byte[edx+Level.blocks-65536],~0			;x, y-1, z
 jnz  .1D										;
 inc  edi										;
 cmp  eax,edi									;
 jl   .1dark									;
 .1light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(1.0)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(1.0)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(1.0)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(1.0)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(1.0)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(1.0)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.124875)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(1.0)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(1.0)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(1.0)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(1.0)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(1.0)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(1.0)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .1lightD								;
 .1dark:										;
  .1darkD:										;
 dec  edi										;
 .1D:											;
 
 cmp  eax,63									;Level.depth=1
 je   .2light									;
 test byte[edx+Level.blocks+65536],~0			;x, y+1, z
 jnz  .2D										;
 dec  edi										;
 cmp  eax,edi									;
 jl   .2dark									;
 .2light:										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.124875)		;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(1.0)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(1.0)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(1.0)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.124875)		;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(1.0)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(1.0)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(1.0)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(1.0)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(1.0)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(1.0)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(1.0)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(1.0)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(1.0)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .2lightD								;
 .2dark:										;
  .2darkD:										;
 inc  edi										;
 .2D:											;
 
 xor  edi,edi									;
 mov  di,dx										;di lightdepths index
 
 test dh,~0										;
 jz   .3light									;
 test byte[edx+Level.blocks-256],~0				;x, y, z-1
 jl   .3D										;
 cmp  eax,[edi+Level.lightdepths-256]			;x, z-1
 jge  .3dark									;
 .3light:										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.124875)		;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  ;jmp  .3lightD								;
 .3dark:										;
  .3darkD:										;
 .3D:											;
 
 cmp  dh,255									;Level.height-1
 jz   .4light									;
 test byte[edx+Level.blocks+256],~0				;x, y, z+1
 jnz  .4D										;
 cmp  eax,[edi+Level.lightdepths+256]			;x, z+1
 jl   .4dark									;
 .4light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.124875)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  ;jmp  .3lightD								;
 .4dark:										;
  .4darkD:										;
 .4D:											;
 
 test dl,~0										;
 jz   .5light									;
 test byte[edx+Level.blocks-1],~0				;x-1, y, z
 jnz  .5D										;
 cmp  eax,[edi+Level.lightdepths-1]				;x-1, z
 jl   .5dark									;
 .5light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.124875)		;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.6)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.6)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.6)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.6)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.6)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.6)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.6)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.6)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.6)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.6)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.6)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.6)			;3 blue
  ;jmp  .3lightD								;
 .5dark:										;
  .5darkD:										;
 .5D:											;
 
 cmp  dl,255									;Level.width-1
 jz   .6light									;
 test byte[edx+Level.blocks+1],~0				;x+1, y, z
 jnz  .6D										;
 cmp  eax,[edi+Level.lightdepths+1]				;x+1, z
 jl   .6dark									;
 .6light:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.6)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.6)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.6)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.124875)		;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.6)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.6)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.6)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.124875)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.6)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.6)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.6)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.6)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.6)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.6)			;3 blue
  ;jmp  .3lightD								;
 .6dark:										;
  .6darkD:										;
 .6D:											;
 
 ret
 
Tile.rock.render1: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax y
;ebx x
;esi z
;edx block	;can't be broken into smaller bits for x+1 and x-1
 
 ;x = 1
 ;y = 65536
 ;z = 256
 
 xor  ebx,ebx									;ebx vertices*3
 xor  ecx,ecx									;ecx vertices*2
 
 push ebx										;
 fild dword[esp]								;
 inc  ebx										;
 push ebx										;
 fild dword[esp]								;
 push eax										;
 fild dword[esp]								;
 inc  eax										;
 push eax										;
 fild dword[esp]								;
 dec  eax										;
 push esi										;
 fild dword[esp]								;
 inc  esi										;
 push esi										;
 fild dword[esp]								;
 add  esp,24									;st0 z1,  st1 z0,  st2 y1,  st3 y0,  st4 x1,  st5 x0
 
 xor  edi,edi									;
 mov  di,dx										;edi lightdepths+xz
 mov  edi,dword[edi+Level.lightdepths]			;edi lightdepth
 
 test eax,~0									;
 je   .1D										;
 test byte[edx+Level.blocks-65536],~0			;x, y-1, z
 jnz  .1D										;
 inc  edi										;
 cmp  eax,edi									;
 jge  .1light									;
 .1dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0)			;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .1lightD								;
 .1light:										;
  .1lightD:										;
 dec  edi										;
 .1D:											;
 
 cmp  eax,63									;Level.depth=1
 je   .2D										;
 test byte[edx+Level.blocks+65536],~0			;x, y+1, z
 jnz  .2D										;
 dec  edi										;
 cmp  eax,edi									;
 jge  .2light									;
 .2dark:										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0)			;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0)			;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .2lightD								;
 .2light:										;
  .2lightD:										;
 inc  edi										;
 .2D:											;
 
 xor  edi,edi									;
 mov  di,dx										;di lightdepths index
 
 test dh,~0										;
 jz   .3D										;
 test byte[edx+Level.blocks-256],~0				;x, y, z-1
 jnz  .3D										;
 cmp  eax,[edi+Level.lightdepths-256]			;x, z-1
 jge  .3light									;
 .3dark:										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0)			;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;3 blue
  ;jmp  .3lightD								;
 .3light:										;
  .3lightD:										;
 .3D:											;
 
 cmp  dh,255									;Level.height-1
 jz   .4D										;
 test byte[edx+Level.blocks+256],~0				;x, y, z+1
 jnz  .4D										;
 cmp  eax,[edi+Level.lightdepths+256]			;x, z+1
 jge  .4light									;
 .4dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0)			;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;3 blue
  ;jmp  .3lightD								;
 .4light:										;
  .4lightD:										;
 .4D:											;
 
 test dl,~0										;
 jz   .5D										;
 test byte[edx+Level.blocks-1],~0				;x-1, y, z
 jnz  .5D										;
 cmp  eax,[edi+Level.lightdepths-1]				;x-1, z
 jge  .5light									;
 .5dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0)			;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0)			;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;3 blue
  ;jmp  .3lightD								;
 .5light:										;
  .5lightD:										;
 .5D:											;
 
 cmp  dl,255									;Level.width-1
 jz   .6D										;
 test byte[edx+Level.blocks+1],~0				;x+1, y, z
 jnz  .6D										;
 cmp  eax,[edi+Level.lightdepths+1]				;x+1, z
 jge  .6light									;
 .6dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0)			;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0)			;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;3 blue
  ;jmp  .3lightD								;
 .6light:										;
  .6lightD:										;
 .6D:											;
 
 ret
 
Tile.grass.render1: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;eax y
;ebx x
;esi z
;edx block	;can't be broken into smaller bits for x+1 and x-1
 
 ;x = 1
 ;y = 65536
 ;z = 256
 
 xor  ebx,ebx									;ebx vertices*3
 xor  ecx,ecx									;ecx vertices*2
 
 push ebx										;
 fild dword[esp]								;
 inc  ebx										;
 push ebx										;
 fild dword[esp]								;
 push eax										;
 fild dword[esp]								;
 inc  eax										;
 push eax										;
 fild dword[esp]								;
 dec  eax										;
 push esi										;
 fild dword[esp]								;
 inc  esi										;
 push esi										;
 fild dword[esp]								;
 add  esp,24									;st0 z1,  st1 z0,  st2 y1,  st3 y0,  st4 x1,  st5 x0
 
 xor  edi,edi									;
 mov  di,dx										;edi lightdepths+xz
 mov  edi,dword[edi+Level.lightdepths]			;edi lightdepth
 
 test eax,~0									;
 je   .1D										;
 test byte[edx+Level.blocks-65536],~0			;x, y-1, z
 jnz  .1D										;
 inc  edi										;
 cmp  eax,edi									;
 jge  .1light									;
 .1dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.124875)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .1lightD								;
 .1light:										;
  .1lightD:										;
 dec  edi										;
 .1D:											;
 
 cmp  eax,63									;Level.depth=1
 je   .2D										;
 test byte[edx+Level.blocks+65536],~0			;x, y+1, z
 jnz  .2D										;
 dec  edi										;
 cmp  eax,edi									;
 jge  .2light									;
 .2dark:										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.124875)		;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)				;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)				;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)				;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.124875)		;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)			;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)			;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)			;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)			;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)			;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)			;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)			;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)			;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)			;3 blue
  add  ebx,48									;
  add  ecx,32									;
  ;jmp  .2lightD								;
 .2light:										;
  .2lightD:										;
 inc  edi										;
 .2D:											;
 
 xor  edi,edi									;
 mov  di,dx										;di lightdepths index
 
 test dh,~0										;
 jz   .3D										;
 test byte[edx+Level.blocks-256],~0				;x, y, z-1
 jnz  .3D										;
 cmp  eax,[edi+Level.lightdepths-256]			;x, z-1
 jge  .3light									;
 .3dark:										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z0
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.124875)		;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;3 blue
  ;jmp  .3lightD								;
 .3light:										;
  .3lightD:										;
 .3D:											;
 
 cmp  dh,255									;Level.height-1
 jz   .4D										;
 test byte[edx+Level.blocks+256],~0				;x, y, z+1
 jnz  .4D										;
 cmp  eax,[edi+Level.lightdepths+256]			;x, z+1
 jge  .4light									;
 .4dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z1
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.124875)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.8)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.8)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.8)		;3 blue
  ;jmp  .3lightD								;
 .4light:										;
  .4lightD:										;
 .4D:											;
 
 test dl,~0										;
 jz   .5D										;
 test byte[edx+Level.blocks-1],~0				;x-1, y, z
 jnz  .5D										;
 cmp  eax,[edi+Level.lightdepths-1]				;x-1, z
 jge  .5light									;
 .5dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y1
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y1
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y0
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y0
  fincstp										;
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x0
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x0
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x0
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x0
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.124875)		;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0)			;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.0624375)	;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0)			;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.0624375)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0624375)	;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.124875)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0624375)	;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;3 blue
  ;jmp  .3lightD								;
 .5light:										;
  .5lightD:										;
 .5D:											;
 
 cmp  dl,255									;Level.width-1
 jz   .6D										;
 test byte[edx+Level.blocks+1],~0				;x+1, y, z
 jnz  .6D										;
 cmp  eax,[edi+Level.lightdepths+1]				;x+1, z
 jge  .6light									;
 .6dark:										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+8]	;0 z1
  fst  dword[ebx+36+Tesselator.vertexBuffer+8]	;3 z1
  fincstp										;
  fst  dword[ebx+12+Tesselator.vertexBuffer+8]	;1 z0
  fst  dword[ebx+24+Tesselator.vertexBuffer+8]	;2 z0
  fincstp										;
  fst  dword[ebx+24+Tesselator.vertexBuffer+4]	;2 y1
  fst  dword[ebx+36+Tesselator.vertexBuffer+4]	;3 y1
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+4]	;0 y0
  fst  dword[ebx+12+Tesselator.vertexBuffer+4]	;1 y0
  fincstp										;
  fst  dword[ebx+0+Tesselator.vertexBuffer+0]	;0 x1
  fst  dword[ebx+12+Tesselator.vertexBuffer+0]	;1 x1
  fst  dword[ebx+24+Tesselator.vertexBuffer+0]	;2 x1
  fst  dword[ebx+36+Tesselator.vertexBuffer+0]	;3 x1
  fincstp										;
  fincstp										;
  fincstp										;
  fincstp										;
  mov  dword[ecx+0+Tesselator.texCoordBuffer+0],f(0.0624375)	;0 u
  mov  dword[ecx+0+Tesselator.texCoordBuffer+4],f(0.0624375)	;0 v
  mov  dword[ebx+0+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;0 red
  mov  dword[ebx+0+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;0 green
  mov  dword[ebx+0+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;0 blue
  mov  dword[ecx+8+Tesselator.texCoordBuffer+0],f(0.124875)		;1 u
  mov  dword[ecx+8+Tesselator.texCoordBuffer+4],f(0.0624375)	;1 v
  mov  dword[ebx+12+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;1 red
  mov  dword[ebx+12+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;1 green
  mov  dword[ebx+12+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;1 blue
  mov  dword[ecx+16+Tesselator.texCoordBuffer+0],f(0.124875)	;2 u
  mov  dword[ecx+16+Tesselator.texCoordBuffer+4],f(0.0)			;2 v
  mov  dword[ebx+24+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;2 red
  mov  dword[ebx+24+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;2 green
  mov  dword[ebx+24+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;2 blue
  mov  dword[ecx+24+Tesselator.texCoordBuffer+0],f(0.0624375)	;3 u
  mov  dword[ecx+24+Tesselator.texCoordBuffer+4],f(0.0)			;3 v
  mov  dword[ebx+36+Tesselator.colorBuffer+0],f(0.8)*f(0.6)		;3 red
  mov  dword[ebx+36+Tesselator.colorBuffer+4],f(0.8)*f(0.6)		;3 green
  mov  dword[ebx+36+Tesselator.colorBuffer+8],f(0.8)*f(0.6)		;3 blue
  ;jmp  .3lightD								;
 .6light:										;
  .6lightD:										;
 .6D:											;
 
 ret
 
Tile.renderFace: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;[esp+4]  tex
;[esp+8]  x
;[esp+12] y
;[esp+16] z
;[esp+20] face
 
 push f(1.0)									;
 fld  dword[esp]								;
 pop  eax										;
 push dword[esp+16]								;
 push dword[esp+16]								;
 push dword[esp+16]								;
 fld  dword[esp]								;
 fadd st1										;
 fstp dword[esp]								;[esp]   x1
 fld  dword[esp+4]								;
 fadd st1										;
 fstp dword[esp+4]								;[esp+4] y1
 fld  dword[esp+8]								;
 fadd st1										;
 fstp dword[esp+8]								;[esp+8] z1
 
 mov  eax,[esp+16]								; tex
 shl  eax,2										;
 add  eax,.P									;
 jmp  dword[eax]								;
  section .data									;
  .P dd .0,.1,.2,.3,.4,.5						;
  section .text									;
 
 .0:
  push dword[esp+8]								; z1
  push dword[esp+28]							; y
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+28]							; y
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+28]							; y
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+28]							; y
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  
  add  esp,12
  ret  20
  
 .1:
  push dword[esp+8]								; z1
  push dword[esp+8]								; y1
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+8]								; y1
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+8]								; y1
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+8]								; y1
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  
  add  esp,12
  ret  20
 
 .2:
  push dword[esp+28]							; z
  push dword[esp+8]								; y1
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+8]								; y1
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+28]							; y
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+28]							; z1
  push dword[esp+28]							; y1
  push dword[esp+28]							; x1
  call Tesselator.vertex						;
  
  add  esp,12
  ret  20
 
 .3:
  push dword[esp+8]								; z1
  push dword[esp+8]								; y1
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+28]							; y
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+28]							; y
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+8]								; y1
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  
  add  esp,12
  ret  20
 
 .4:
  push dword[esp+8]								; z1
  push dword[esp+8]								; y1
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+8]								; y1
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+28]							; y
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+28]							; y
  push dword[esp+28]							; x
  call Tesselator.vertex						;
  
  add  esp,12
  ret  20
 
 .5:
  push dword[esp+8]								; z1
  push dword[esp+28]							; y
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+28]							; y
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+28]							; z
  push dword[esp+8]								; y1
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  push dword[esp+8]								; z1
  push dword[esp+8]								; y1
  push dword[esp+8]								; x1
  call Tesselator.vertex						;
  
  add  esp,12
  ret  20
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;