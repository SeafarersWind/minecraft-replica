extern _glGetFloatv@8

Frustum: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .bss
 
 .m_Frustum resd 6*4
 .proj resd 16
 .modl resd 16
 .clip resd 16
 
 section .text
 
Frustum.getFrustum: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  push Frustum.proj								;
  push 0x0BA7									;GL_PROJECTION_MATRIX
  call _glGetFloatv@8							;
  
  push Frustum.modl								;
  push 0x0BA6									;GL_MODELVIEW_MATRIX
  call _glGetFloatv@8							;
  
  fld  dword[Frustum.modl+0]					;
  fld  dword[Frustum.modl+4]					;
  fld  dword[Frustum.modl+8]					;
  fld  dword[Frustum.modl+12]					;
  fld  dword[Frustum.proj+0]					;
  fmul st4										;
  fld  dword[Frustum.proj+16]					;
  fmul st4										;
  fld  dword[Frustum.proj+32]					;
  fmul st4										;
  fld  dword[Frustum.proj+48]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+0]					;
  fld  dword[Frustum.proj+4]					;
  fmul st4										;
  fld  dword[Frustum.proj+20]					;
  fmul st4										;
  fld  dword[Frustum.proj+36]					;
  fmul st4										;
  fld  dword[Frustum.proj+52]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+4]					;
  fld  dword[Frustum.proj+8]					;
  fmul st4										;
  fld  dword[Frustum.proj+24]					;
  fmul st4										;
  fld  dword[Frustum.proj+40]					;
  fmul st4										;
  fld  dword[Frustum.proj+56]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+8]					;
  fmul dword[Frustum.proj+60]					;
  fincstp										;
  fmul dword[Frustum.proj+44]					;
  fincstp										;
  fmul dword[Frustum.proj+28]					;
  fincstp										;
  fmul dword[Frustum.proj+12]					;
  fdecstp										;
  fdecstp										;
  fdecstp										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+12]					;
  
  fld  dword[Frustum.modl+16]					;
  fld  dword[Frustum.modl+20]					;
  fld  dword[Frustum.modl+24]					;
  fld  dword[Frustum.modl+28]					;
  fld  dword[Frustum.proj+0]					;
  fmul st4										;
  fld  dword[Frustum.proj+16]					;
  fmul st4										;
  fld  dword[Frustum.proj+32]					;
  fmul st4										;
  fld  dword[Frustum.proj+48]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+16]					;
  fld  dword[Frustum.proj+4]					;
  fmul st4										;
  fld  dword[Frustum.proj+20]					;
  fmul st4										;
  fld  dword[Frustum.proj+36]					;
  fmul st4										;
  fld  dword[Frustum.proj+52]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+20]					;
  fld  dword[Frustum.proj+8]					;
  fmul st4										;
  fld  dword[Frustum.proj+24]					;
  fmul st4										;
  fld  dword[Frustum.proj+40]					;
  fmul st4										;
  fld  dword[Frustum.proj+56]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+24]					;
  fmul dword[Frustum.proj+60]					;
  fincstp										;
  fmul dword[Frustum.proj+44]					;
  fincstp										;
  fmul dword[Frustum.proj+28]					;
  fincstp										;
  fmul dword[Frustum.proj+12]					;
  fdecstp										;
  fdecstp										;
  fdecstp										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+28]					;
  
  fld  dword[Frustum.modl+32]					;
  fld  dword[Frustum.modl+36]					;
  fld  dword[Frustum.modl+40]					;
  fld  dword[Frustum.modl+44]					;
  fld  dword[Frustum.proj+0]					;
  fmul st4										;
  fld  dword[Frustum.proj+16]					;
  fmul st4										;
  fld  dword[Frustum.proj+32]					;
  fmul st4										;
  fld  dword[Frustum.proj+48]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+32]					;
  fld  dword[Frustum.proj+4]					;
  fmul st4										;
  fld  dword[Frustum.proj+20]					;
  fmul st4										;
  fld  dword[Frustum.proj+36]					;
  fmul st4										;
  fld  dword[Frustum.proj+52]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+36]					;
  fld  dword[Frustum.proj+8]					;
  fmul st4										;
  fld  dword[Frustum.proj+24]					;
  fmul st4										;
  fld  dword[Frustum.proj+40]					;
  fmul st4										;
  fld  dword[Frustum.proj+56]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+40]					;
  fmul dword[Frustum.proj+60]					;
  fincstp										;
  fmul dword[Frustum.proj+44]					;
  fincstp										;
  fmul dword[Frustum.proj+28]					;
  fincstp										;
  fmul dword[Frustum.proj+12]					;
  fdecstp										;
  fdecstp										;
  fdecstp										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+44]					;
  
  fld  dword[Frustum.modl+48]					;
  fld  dword[Frustum.modl+52]					;
  fld  dword[Frustum.modl+56]					;
  fld  dword[Frustum.modl+60]					;
  fld  dword[Frustum.proj+0]					;
  fmul st4										;
  fld  dword[Frustum.proj+16]					;
  fmul st4										;
  fld  dword[Frustum.proj+32]					;
  fmul st4										;
  fld  dword[Frustum.proj+48]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+48]					;
  fld  dword[Frustum.proj+4]					;
  fmul st4										;
  fld  dword[Frustum.proj+20]					;
  fmul st4										;
  fld  dword[Frustum.proj+36]					;
  fmul st4										;
  fld  dword[Frustum.proj+52]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+52]					;
  fld  dword[Frustum.proj+8]					;
  fmul st4										;
  fld  dword[Frustum.proj+24]					;
  fmul st4										;
  fld  dword[Frustum.proj+40]					;
  fmul st4										;
  fld  dword[Frustum.proj+56]					;
  fmul st4										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fstp dword[Frustum.clip+56]					;
  fmul dword[Frustum.proj+60]					;
  fincstp										;
  fmul dword[Frustum.proj+44]					;
  fincstp										;
  fmul dword[Frustum.proj+28]					;
  fincstp										;
  fmul dword[Frustum.proj+12]					;
  fdecstp										;
  fdecstp										;
  fdecstp										;
  faddp st1										;
  faddp st1										;
  faddp st1										;
  fst  dword[Frustum.clip+60]					;
  
  fld  dword[Frustum.clip+44]					;
  fld  dword[Frustum.clip+28]					;
  fld  dword[Frustum.clip+12]					;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fsub dword[Frustum.clip+0]					;
  fstp dword[Frustum.m_Frustum+0*6+0]			;
  fsub dword[Frustum.clip+16]					;
  fstp dword[Frustum.m_Frustum+0*6+4]			;
  fsub dword[Frustum.clip+32]					;
  fstp dword[Frustum.m_Frustum+0*6+8]			;
  fsub dword[Frustum.clip+48]					;
  fstp dword[Frustum.m_Frustum+0*6+12]			;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fadd dword[Frustum.clip+0]					;
  fstp dword[Frustum.m_Frustum+4*6+0]			;
  fadd dword[Frustum.clip+16]					;
  fstp dword[Frustum.m_Frustum+4*6+4]			;
  fadd dword[Frustum.clip+32]					;
  fstp dword[Frustum.m_Frustum+4*6+8]			;
  fadd dword[Frustum.clip+48]					;
  fstp dword[Frustum.m_Frustum+4*6+12]			;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fadd dword[Frustum.clip+4]					;
  fstp dword[Frustum.m_Frustum+8*6+0]			;
  fadd dword[Frustum.clip+20]					;
  fstp dword[Frustum.m_Frustum+8*6+4]			;
  fadd dword[Frustum.clip+36]					;
  fstp dword[Frustum.m_Frustum+8*6+8]			;
  fadd dword[Frustum.clip+52]					;
  fstp dword[Frustum.m_Frustum+8*6+12]			;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fsub dword[Frustum.clip+4]					;
  fstp dword[Frustum.m_Frustum+12*6+0]			;
  fsub dword[Frustum.clip+20]					;
  fstp dword[Frustum.m_Frustum+12*6+4]			;
  fsub dword[Frustum.clip+36]					;
  fstp dword[Frustum.m_Frustum+12*6+8]			;
  fsub dword[Frustum.clip+52]					;
  fstp dword[Frustum.m_Frustum+12*6+12]			;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fld  st3										;
  fsub dword[Frustum.clip+8]					;
  fstp dword[Frustum.m_Frustum+16*6+0]			;
  fsub dword[Frustum.clip+24]					;
  fstp dword[Frustum.m_Frustum+16*6+4]			;
  fsub dword[Frustum.clip+40]					;
  fstp dword[Frustum.m_Frustum+16*6+8]			;
  fsub dword[Frustum.clip+56]					;
  fstp dword[Frustum.m_Frustum+16*6+12]			;
  fadd dword[Frustum.clip+8]					;
  fstp dword[Frustum.m_Frustum+20*6+0]			;
  fadd dword[Frustum.clip+24]					;
  fstp dword[Frustum.m_Frustum+20*6+4]			;
  fadd dword[Frustum.clip+40]					;
  fstp dword[Frustum.m_Frustum+20*6+8]			;
  fadd dword[Frustum.clip+56]					;
  fstp dword[Frustum.m_Frustum+20*6+12]			;
  
  ;normalizePlane
  fld  dword[Frustum.m_Frustum+0*6+0]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+0*6+4]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+0*6+8]			;
  fsqrt											;
  faddp st1										;
  faddp st1										;st0 magnitude
  fld  dword[Frustum.m_Frustum+0*6+0]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+0*6+0]			;
  fld  dword[Frustum.m_Frustum+0*6+4]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+0*6+4]			;
  fld  dword[Frustum.m_Frustum+0*6+8]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+0*6+8]			;
  fld  dword[Frustum.m_Frustum+0*6+12]			;
  fdivrp st1									;
  fstp dword[Frustum.m_Frustum+0*6+12]			;
  
  fld  dword[Frustum.m_Frustum+4*6+0]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+4*6+4]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+4*6+8]			;
  fsqrt											;
  faddp st1										;
  faddp st1										;st0 magnitude
  fld  dword[Frustum.m_Frustum+4*6+0]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+4*6+0]			;
  fld  dword[Frustum.m_Frustum+4*6+4]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+4*6+4]			;
  fld  dword[Frustum.m_Frustum+4*6+8]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+4*6+8]			;
  fld  dword[Frustum.m_Frustum+4*6+12]			;
  fdivrp st1									;
  fstp dword[Frustum.m_Frustum+4*6+12]			;
  
  fld  dword[Frustum.m_Frustum+8*6+0]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+8*6+4]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+8*6+8]			;
  fsqrt											;
  faddp st1										;
  faddp st1										;st0 magnitude
  fld  dword[Frustum.m_Frustum+8*6+0]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+8*6+0]			;
  fld  dword[Frustum.m_Frustum+8*6+4]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+8*6+4]			;
  fld  dword[Frustum.m_Frustum+8*6+8]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+8*6+8]			;
  fld  dword[Frustum.m_Frustum+8*6+12]			;
  fdivrp st1									;
  fstp dword[Frustum.m_Frustum+8*6+12]			;
  
  fld  dword[Frustum.m_Frustum+12*6+0]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+12*6+4]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+12*6+8]			;
  fsqrt											;
  faddp st1										;
  faddp st1										;st0 magnitude
  fld  dword[Frustum.m_Frustum+12*6+0]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+12*6+0]			;
  fld  dword[Frustum.m_Frustum+12*6+4]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+12*6+4]			;
  fld  dword[Frustum.m_Frustum+12*6+8]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+12*6+8]			;
  fld  dword[Frustum.m_Frustum+12*6+12]			;
  fdivrp st1									;
  fstp dword[Frustum.m_Frustum+12*6+12]			;
  
  fld  dword[Frustum.m_Frustum+16*6+0]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+16*6+4]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+16*6+8]			;
  fsqrt											;
  faddp st1										;
  faddp st1										;st0 magnitude
  fld  dword[Frustum.m_Frustum+16*6+0]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+16*6+0]			;
  fld  dword[Frustum.m_Frustum+16*6+4]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+16*6+4]			;
  fld  dword[Frustum.m_Frustum+16*6+8]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+16*6+8]			;
  fld  dword[Frustum.m_Frustum+16*6+12]			;
  fdivrp st1									;
  fstp dword[Frustum.m_Frustum+16*6+12]			;
  
  fld  dword[Frustum.m_Frustum+20*6+0]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+20*6+4]			;
  fsqrt											;
  fld  dword[Frustum.m_Frustum+20*6+8]			;
  fsqrt											;
  faddp st1										;
  faddp st1										;st0 magnitude
  fld  dword[Frustum.m_Frustum+20*6+0]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+20*6+0]			;
  fld  dword[Frustum.m_Frustum+20*6+4]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+20*6+4]			;
  fld  dword[Frustum.m_Frustum+20*6+8]			;
  fdiv st1										;
  fstp dword[Frustum.m_Frustum+20*6+8]			;
  fld  dword[Frustum.m_Frustum+20*6+12]			;
  fdivrp st1									;
  fstp dword[Frustum.m_Frustum+20*6+12]			;
  
  ret
 
Frustum.cubeInFrustum: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ecx aabb *
; edx false
 
 ;six faces
 ;one
 fld  dword[Frustum.m_Frustum+0*6+8]			;
 fld  dword[Frustum.m_Frustum+0*6+4]			;
 fld  dword[Frustum.m_Frustum+0*6+0]			;
 fld  dword[Frustum.m_Frustum+0*6+12]			;
 fld  dword[ecx+AABB.z0]						;
 fmul st4										;
 fadd st1										;z0*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st4										;
 fadd st1										;y0*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st4										;
 fadd st1										;x0*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true7									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st4										;
 faddp st1										;x1*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st4										;
 faddp st1										;y1*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.z1]						;
 fmul st4										;
 faddp st1										;z1*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st3										;
 fadd st1										;y0*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st3										;
 faddp st1										;y1*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st2										;
 fadd st1										;x0*0 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st2										;
 faddp st1										;x1*1 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true4									;
 fincstp										;
 ffree st7										;
 
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 
 
 ;two
 fld  dword[Frustum.m_Frustum+4*6+8]			;
 fld  dword[Frustum.m_Frustum+4*6+4]			;
 fld  dword[Frustum.m_Frustum+4*6+0]			;
 fld  dword[Frustum.m_Frustum+4*6+12]			;
 fld  dword[ecx+AABB.z0]						;
 fmul st4										;
 fadd st1										;z0*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st4										;
 fadd st1										;y0*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st4										;
 fadd st1										;x0*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true7									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st4										;
 faddp st1										;x1*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st4										;
 faddp st1										;y1*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.z1]						;
 fmul st4										;
 faddp st1										;z1*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st3										;
 fadd st1										;y0*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st3										;
 faddp st1										;y1*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st2										;
 fadd st1										;x0*0 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st2										;
 faddp st1										;x1*1 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true4									;
 fincstp										;
 ffree st7										;
 
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 
 
 ;three
 fld  dword[Frustum.m_Frustum+8*6+8]			;
 fld  dword[Frustum.m_Frustum+8*6+4]			;
 fld  dword[Frustum.m_Frustum+8*6+0]			;
 fld  dword[Frustum.m_Frustum+8*6+12]			;
 fld  dword[ecx+AABB.z0]						;
 fmul st4										;
 fadd st1										;z0*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st4										;
 fadd st1										;y0*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st4										;
 fadd st1										;x0*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true7									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st4										;
 faddp st1										;x1*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st4										;
 faddp st1										;y1*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.z1]						;
 fmul st4										;
 faddp st1										;z1*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st3										;
 fadd st1										;y0*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st3										;
 faddp st1										;y1*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st2										;
 fadd st1										;x0*0 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st2										;
 faddp st1										;x1*1 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true4									;
 fincstp										;
 ffree st7										;
 
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 
 
 ;four
 fld  dword[Frustum.m_Frustum+12*6+8]			;
 fld  dword[Frustum.m_Frustum+12*6+4]			;
 fld  dword[Frustum.m_Frustum+12*6+0]			;
 fld  dword[Frustum.m_Frustum+12*6+12]			;
 fld  dword[ecx+AABB.z0]						;
 fmul st4										;
 fadd st1										;z0*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st4										;
 fadd st1										;y0*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st4										;
 fadd st1										;x0*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true7									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st4										;
 faddp st1										;x1*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st4										;
 faddp st1										;y1*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.z1]						;
 fmul st4										;
 faddp st1										;z1*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st3										;
 fadd st1										;y0*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st3										;
 faddp st1										;y1*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st2										;
 fadd st1										;x0*0 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st2										;
 faddp st1										;x1*1 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true4									;
 fincstp										;
 ffree st7										;
 
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 
 ;five
 fld  dword[Frustum.m_Frustum+16*6+8]			;
 fld  dword[Frustum.m_Frustum+16*6+4]			;
 fld  dword[Frustum.m_Frustum+16*6+0]			;
 fld  dword[Frustum.m_Frustum+16*6+12]			;
 fld  dword[ecx+AABB.z0]						;
 fmul st4										;
 fadd st1										;z0*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st4										;
 fadd st1										;y0*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st4										;
 fadd st1										;x0*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true7									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st4										;
 faddp st1										;x1*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st4										;
 faddp st1										;y1*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.z1]						;
 fmul st4										;
 faddp st1										;z1*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st3										;
 fadd st1										;y0*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st3										;
 faddp st1										;y1*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st2										;
 fadd st1										;x0*0 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st2										;
 faddp st1										;x1*1 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true4									;
 fincstp										;
 ffree st7										;
 
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 
 
 ;six
 fld  dword[Frustum.m_Frustum+20*6+8]			;
 fld  dword[Frustum.m_Frustum+20*6+4]			;
 fld  dword[Frustum.m_Frustum+20*6+0]			;
 fld  dword[Frustum.m_Frustum+20*6+12]			;
 fld  dword[ecx+AABB.z0]						;
 fmul st4										;
 fadd st1										;z0*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st4										;
 fadd st1										;y0*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st4										;
 fadd st1										;x0*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true7									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st4										;
 faddp st1										;x1*0 + y0*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st4										;
 faddp st1										;y1*1 + z0*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y1*1 + z0*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.z1]						;
 fmul st4										;
 faddp st1										;z1*2 + 3
 fld  dword[ecx+AABB.y0]						;
 fmul st3										;
 fadd st1										;y0*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st3										;
 fadd st1										;x0*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true6									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st3										;
 faddp st1										;x1*0 + y0*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.y1]						;
 fmul st3										;
 faddp st1										;y1*1 + z1*2 + 3
 fld  dword[ecx+AABB.x0]						;
 fmul st2										;
 fadd st1										;x0*0 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true5									;
 fincstp										;
 ffree st7										;
 
 fld  dword[ecx+AABB.x1]						;
 fmul st2										;
 faddp st1										;x1*1 + y1*1 + z1*2 + 3
 ftst											;
 fstsw ax										;
 sahf											;
 jbe  .true4									;
 fincstp										;
 ffree st7										;
 
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 fincstp										;
 ffree st7										;
 
 .false:										;
  or  edx,0x01									;
  
  ret
 
 .true7:										;
  fincstp										;
  ffree st7										;
 .true6:										;
  fincstp										;
  ffree st7										;
 .true5:										;
  fincstp										;
  ffree st7										;
 .true4:										;
  fincstp										;
  ffree st7										;
 .true3:										;
  fincstp										;
  ffree st7										;
 .true2:										;
  fincstp										;
  ffree st7										;
 .true1:										;
  fincstp										;
  ffree st7										;
 .true0:										;
  
  xor edx,edx									;
  
  ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
