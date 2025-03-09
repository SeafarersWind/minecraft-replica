extern _LoadIconW@8
extern _LoadCursorW@8
extern _RegisterClassW@4
extern _AdjustWindowRectEx@16
extern _CreateWindowExW@48
extern _GetLastError@0
extern _MessageBoxW@16
extern _RegisterClassA@4
extern _RegisterClassExW@4
extern _ShowWindow@8
extern _SetForegroundWindow@4
extern _EnumDisplaySettingsA@12
extern _TranslateMessage@4
extern _DispatchMessageW@4
extern _PeekMessageW@20
extern _DefWindowProcW@16
extern _GetKeyState@4
extern _GetClientRect@4
extern _ClientToScreen@8
extern _OffsetRect@12
extern _ClipCursor@4
extern _SetCapture@4
extern _ReleaseCapture@0
extern _GetForegroundWindow@0
extern _SetCursorPos@8

section .text

WNinit: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 .WIDTH equ  1024
 .HEIGHT equ 768
 
 sub  esp,0xA0									;
 
 %define .wc                esp					; Window Class
 %define .wc.style          .wc					; Style
 %define .wc.lpfnWndProc    .wc+0x04			; Window Procedure
 %define .wc.cbClsExtra     .wc+0x08			; extra bytes post Class
 %define .wc.cbWndExtra     .wc+0x0C			; extra bytes post Instance
 %define .wc.hInstance      .wc+0x10			; Instance
 %define .wc.hIcon          .wc+0x14			; Icon
 %define .wc.hCursor        .wc+0x18			; Cursor
 %define .wc.hbrBackground  .wc+0x1C			; Background Brush
 %define .wc.lpszMenuName   .wc+0x20			; Menu Name
 %define .wc.lpszClassName  .wc+0x24			; Class Name
 
 mov  dword[.wc.style],0x0020					; CS_OWNDC
 mov  dword[.wc.lpfnWndProc],WNproc				;
 mov  dword[.wc.cbClsExtra],0					;
 mov  dword[.wc.cbWndExtra],0					;
 mov  eax,[_Instance]							;
 mov  [.wc.hInstance],eax						;
 push 0x7F00									; IDI_APPLICATION
 push 0											;
 call _LoadIconW@8								;
 mov  [.wc.hIcon],eax							;
 push 0x7F00									; IDC_ARROW
 push 0											;
 call _LoadCursorW@8							;
 mov  dword[.wc.hCursor],eax					;
 mov  dword[.wc.hbrBackground],0				;
 mov  dword[.wc.lpszMenuName],0					;
 mov  dword[.wc.lpszClassName],.tClass			;
 push esp										;
 call _RegisterClassW@4							;Register class
 cmp  eax,0										;
 je   .failregister								;
 
 ;;;;;;;;;;;;;;;;;;;;;;;
 
 %define .rect esp								;
 
 lea eax,[.rect]								; Adjust the window dimensions to account for the style
 mov dword[.rect],0								; left
 mov dword[.rect+4],0							; top
 mov dword[.rect+8],.WIDTH						; right
 mov dword[.rect+12],.HEIGHT					; bottom
 push 0x00040000								; WS_EX_APPWINDOW
 push 0											;
 push 0x06CA0000								; WS_OVERLAPPED | WS_BORDER | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU | WS_CLIPCHILDREN | WS_CLIPSIBLINGS
 ;push 0x86000000								; WS_POPUP | WS_CLIPCHILDREN | WS_CLIPSIBLINGS
 push eax										;
 call _AdjustWindowRectEx@16					;Adjust
 push 0											;
 push dword[_Instance]							;
 push 0											;
 push 0											;
 mov  eax,[.rect+16+12]							;
 sub  eax,[.rect+4+16]							;
 push eax										; height
 mov  eax,[.rect+20+8]							;
 sub  eax,[.rect+20]							;
 push eax										; width
 
 %define .devmode esp+24						;
 
 lea  eax,[.devmode]							; Get screen dimensions for the position
 push eax										;
 push 0xFFFFFFFF								;
 push 0x00										;
 call _EnumDisplaySettingsA@12					;Get
 cmp  eax,0										;
 je   .faildisplaysettings						;
 mov  eax,[.devmode+0x70]						; dmPelsHeight
 sub  eax,.HEIGHT								;
 shr  eax,1										;
 push eax										;
 mov  eax,[.devmode+0x6C+4]						; dmPelsWidth
 sub  eax,.WIDTH								;
 shr  eax,1										;
 push eax										;
 
 push 0x06CA0000								; WS_OVERLAPPED | WS_BORDER | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU | WS_CLIPCHILDREN | WS_CLIPSIBLINGS
 ;push 0x86000000								; WS_POPUP | WS_CLIPCHILDREN | WS_CLIPSIBLINGS
 push .tWindow									;
 push .tClass									;
 push 0x00040000								; WS_EX_APPWINDOW
 call _CreateWindowExW@48						;Create window
 cmp  eax,0										;
 je   .failcreate								;
 mov  [_hWnd],eax								;
 
 add  esp,0xA0									;
 
 ;;;;;;;;;;;;;;;;;;;;;;;
 
 push 0x0A										;
 push eax										;
 call _ShowWindow@8								;Show window
 
 push dword[_hWnd]								;
 call _SetForegroundWindow@4					;Set window to foreground
 
 ret
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 .failregister:
  ;"Failed to register window class\nCould not register window class"
  call _GetLastError@0
  push eax
  call fPrintdec
  
  push 0										;
  push 0										;
  push .failregister.t							;
  push 0										;
  call _MessageBoxW@16							;Error message
  
  call fShutdown
 
 ;;;;;;;;;;;;;;;;;;;;;;;
 
 .failcreate:
  ;"Failed to create window class\nCould not create window class"
  call _GetLastError@0
  push eax
  call fPrintdec
  
  push 0										;
  push 0										;
  push .failcreate.t							;
  push 0										;
  call _MessageBoxW@16							;Error message
  
  call fShutdown
 
 ;;;;;;;;;;;;;;;;;;;;;;;
 
 .faildisplaysettings:
  call _GetLastError@0
  push eax
  call fPrintdec
  
  push 0
  push 0
  push .faildisplaysettings.t
  push 0
  call _MessageBoxW@16
  
  call fShutdown
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .data
 
 .tWindow dw u(''),0
 .tClass dw u('UNDERGROWTH'),0
 .failregister.t dw u('Failed to register window.'),0
 .failcreate.t dw u('Failed to create window.'),0
 .faildisplaysettings.t dw u('Failed to retrieve display settings.')
 
 section .text
 
WNupdate: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 sub  esp,0x1C
 %define .mg          esp
 %define .mg.hwnd     .mg+0x00					; Window handle
 %define .mg.message  .mg+0x04					; Message identifier
 %define .mg.wParam   .mg+0x08					; Parameter
 %define .mg.lParam   .mg+0x0C					; Parameter
 %define .mg.time     .mg+0x10					; Time when posted
 %define .mg.pt       .mg+0x14					; Cursor position when posted
 %define .mg.lPrivate .mg+0x18					; Cursor position when posted
 
 .L:											;
  ;exception occured??							;
  
  lea  eax,[.mg]								;
  push 1										;
  push 0										;
  push 0										;
  push 0										;
  push eax										;
  call _PeekMessageW@20							;
  test eax,eax									;
 jz   .quit										;
  
  cmp  dword[.mg.message],0x12					; WM_QUIT
 je   .quit										;
  
  push .mg										;
  call _TranslateMessage@4						;
  
  push .mg										;
  call _DispatchMessageW@4						;
  
  jmp  .L										;
  
 .quit:											;
 add  esp,0x1C									;
 
 ret
 
WNproc: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;if env is okay
 ; WindowsDisplay.doHandleMessage
 
 %define .hWnd    esp+4							; Window handler
 %define .uMsg    esp+8							; Message
 %define .wParam  esp+12						; parameter
 %define .lParam  esp+16						; parameter
 
 mov  eax,[.uMsg]								;
 cmp  eax,0x200									; WM_MOUSEMOVE
 je   .mousemove								;
 cmp  eax,0x20A									; WM_MOUSEWHEEL
 je   .mousewheel								;
 cmp  eax,0x201									; WM_LBUTTONDOWN
 je   .lbuttondown								;
 cmp  eax,0x202									; WM_LBUTTONUP
 je   .lbuttonup								;
 cmp  eax,0x204									; WM_RBUTTONDOWN
 je   .rbuttondown								;
 cmp  eax,0x205									; WM_RBUTTONUP
 je   .rbuttonup								;
 cmp  eax,0x207									; WM_MBUTTONDOWN
 je   .mbuttondown								;
 cmp  eax,0x208									; WM_MBUTTONUP
 je   .mbuttonup								;
 cmp  eax,0x20C									; WM_XBUTTONUP
 je   .xbuttonup								;
 cmp  eax,0x20B									; WM_XBUTTONDOWN
 je   .xbuttondown								;
 cmp  eax,0x0105								; WM_SYSKEYUP
 je   .keyup									;
 cmp  eax,0x0101								; WM_KEYUP
 je   .keyup									;
 cmp  eax,0x0104								; WM_SYSKEYDOWN
 je   .keydown									;
 cmp  eax,0x0100								; WM_KEYDOWN
 je   .keydown									;
 cmp  eax,0x0012								; WM_QUIT
 je   .quit										;
 cmp  eax,0x0112								; WM_SYSCOMMAND
 je   .syscommand								;
 jmp  .default									;
 
 
 
 .mousemove:									;
  sub  esp,0x18									;
  %define .mousemove.rect   esp					;
  %define .mousemove.point  esp+0x10			;
  %define .mousemove.pointx esp+0x10			;
  %define .mousemove.pointy esp+0x14			;
  mov  dword[.mousemove.pointx],0				;
  mov  dword[.mousemove.pointy],0				;
  
  mov  eax,[.lParam+0x18]						;Get x coordinates
  mov  bx,ax									;
  sub  bx,[.mLastx]								;
  mov  [.mDx],bx								;
  add  [.mAccumdx],bx							;
  mov  [.mLastx],ax								;
  
  push .mousemove.rect							;Get y coordinates
  push dword[_hWnd]								;
  call _GetClientRect@4							;
  mov  eax,[.mousemove.rect+12]					; bottom
  sub  eax,[.mousemove.rect+4]					; top
  dec  eax										;
  mov  ebx,[.lParam+0x18]						;
  shr  ebx,16									;
  sub  eax,ebx									;
  mov  bx,ax									;
  sub  bx,[.mLasty]								;
  mov  [.mDy],bx								;
  add  [.mAccumdy],bx							;
  mov  [.mLasty],ax								;
  
  call _GetForegroundWindow@0					;Center cursor
  cmp  eax,[_hWnd]								;
  jne  .mousemove1								;
  mov  dword[.mousemove.pointx],0				;
  mov  dword[.mousemove.pointy],0				;
  lea  eax,[.mousemove.point]					;
  push eax										;
  push dword[_hWnd]								;
  call _ClientToScreen@8						;
  mov  eax,[.mousemove.pointy]					;
  push eax										;
  mov  eax,[.mousemove.pointx+4]				;
  push eax										;
  lea  eax,[.mousemove.rect+8]					;
  push eax										;
  call _OffsetRect@12							;
  mov  eax,[.mousemove.rect+4]					; top
  add  eax,[.mousemove.rect+12]					; bottom
  shr  eax,1									;
  mov  ebx,[.mousemove.rect]					; left
  add  ebx,[.mousemove.rect+8]					; right
  shr  ebx,1									;
  push ebx										;
  push eax										;
  push eax										;
  push ebx										;
  call _SetCursorPos@8							;
  pop  eax										;
  sub  eax,[.mousemove.rect+4+4]				; top
  mov  ebx,[.mousemove.rect+12+4]				; bottom
  sub  ebx,[.mousemove.rect+4+4]				; top
  dec  ebx										;
  sub  ebx,eax									;
  mov  [.mLasty],bx								;
  pop  eax										;
  sub  eax,[.mousemove.rect]					; left
  mov  [.mLastx],ax								;
  push .mousemove.rect							;Contain cursor
  call _ClipCursor@4							;
  
  .mousemove1:
  
  ;this.mouseInside = true;
  
  ;if (!this.trackingMouse)
  ; this.trackingMouse = nTrackMouseEvent(hwnd); 
  
  add  esp,0x18									;
  
  jmp .default									;
 
 
 
 .mousewheel:									;
  mov  eax,[.wParam]							;
  shr  eax,16									;
  add  [.mAccumdwheel],ax						;
  
  jmp .default
 
 
 
 .lbuttondown:									;
  or   byte[.mButtons],0x01						;
  
  cmp  byte[.mCapture],0						;
  jne  .default									;
   mov  byte[.mCapture],1						;
   push  dword[_hWnd]							;
   call  _SetCapture@4							;
  
  jmp .default
 
 
 
 .lbuttonup:									;
  and  byte[.mButtons],~0x01					;
  
  cmp  byte[.mCapture],1						;
  jne  .default									;
   mov  byte[.mCapture],0						;
   call _ReleaseCapture@0						;
    
  jmp .default
 
 
 
 .rbuttondown:									;
  or   byte[.mButtons],0x02						;
  
  cmp  byte[.mCapture],0						;
  jne  .default									;
   mov  byte[.mCapture],2						;
   push  dword[_hWnd]							;
   call  _SetCapture@4							;
  
  jmp .default
 
 
 
 .rbuttonup:									;
  and  byte[.mButtons],~0x02					;
  
  cmp  byte[.mCapture],2						;
  jne  .default									;
   mov  byte[.mCapture],0						;
   call _ReleaseCapture@0						;
    
  jmp .default
 
 
 
 .mbuttondown:									;
  or   byte[.mButtons],0x04						;
  
  cmp  byte[.mCapture],0						;
  jne  .default									;
   mov  byte[.mCapture],3						;
   push  dword[_hWnd]							;
   call  _SetCapture@4							;
  
  jmp .default
 
 
 
 .mbuttonup:									;
  and  byte[.mButtons],~0x04					;
  
  cmp  byte[.mCapture],3						;
  jne  .default									;
   mov  byte[.mCapture],0						;
   call _ReleaseCapture@0						;
    
  jmp .default
 
 
 
 .xbuttonup:									;
  mov  eax,[.wParam]							;
  shr  eax,16									;
  cmp  ax,0x0001								; XBUTTON1
  jne  .xbuttonup2								;
  
  .xbuttonup1:									;
   and  byte[.mButtons],~0x08					;
   
   cmp  byte[.mCapture],4						;
   jne  .default								;
    mov  byte[.mCapture],0						;
    call _ReleaseCapture@0						;
     
   jmp .default
  
  .xbuttonup2:									;
   and  byte[.mButtons],~0x10					;
   
   cmp  byte[.mCapture],5						;
   jne  .default								;
    mov  byte[.mCapture],0						;
    call _ReleaseCapture@0						;
     
   jmp .default
 
 
 
 .xbuttondown:									;
  mov  eax,[.wParam]							;
  cmp  ax,0x0020								; MK_XBUTTON1
  jne  .xbuttondown2							;
  
  .xbuttondown1:								;
   or   byte[.mButtons],0x08					;
   
   cmp  byte[.mCapture],0						;
   jne  .default								;
    mov  byte[.mCapture],4						;
    push  dword[_hWnd]							;
    call  _SetCapture@4							;
   
   jmp .default
  
  .xbuttondown2:								;
   or   byte[.mButtons],0x10					;
   
   cmp  byte[.mCapture],0						;
   jne  .default								;
    mov  byte[.mCapture],5						;
    push  dword[_hWnd]							;
    call  _SetCapture@4							;
   
   jmp .default
 
 
 
 .keyup:										;
  ;cmp  byte[.wParam],0x2C						; VK_SNAPSHOT
  ;jne  .keyup1									;
  ;yboard.key_down_buffer[KEY_SYSRQ] == 1		;
   ;mov  eax,[.lParam]							;
   ;and  eax,0x3FFFFFFF							;
   ;handleKeyButton								;
   
  .keyup1:										;
 
 
 
 .keydown:										;
   mov  eax,[.wParam]							;
   cmp  eax,0x10								; VK_SHIFT
   je   .keydownShift							;
   cmp  eax,0x11								; VK_CONTROL
   je   .keydownCtrl							;
   cmp  eax,0x12								; VK_MENU
   je   .keydownAlt								;
   jmp  .keydown1								;
   
   .keydown1:									;
   
   mov  cl,al									;
   and  cl,0x07									;
   shr  eax,3									;
   and  eax,0x1F								;
   add  eax,keys								;
   mov  dl,0x01									;
   shl  dl,cl									;
   test byte[.lParam+3],0x80					; KF_UP >> 8
   jne  .keydownUp								;
   or   [eax],dl								;
   jmp  .keydownDownD							;
   .keydownUp:									;
   not  dl										;
   and  [eax],dl								;
   .keydownDownD:								;
   
   ;this.retained_key_code = keycode;			;
   ;this.retained_state = state;				;
   ;this.retained_millis = millis;				;
   ;this.retained_char = 0;						;
   ;this.retained_repeat = repeat;				;
   
   jmp  .default
    
   .keydownShift:								;!!!!!!!!!!!!! can't fix check later you'll be ok
    mov  al,[keys+(0xA0>>3)]					;
    shl  al,7-(0xA0&0x07)						;
    and  al,0x80								;
    mov  bl,[.lParam+3]							;
    and  bl,0x80								; KF_UP >> 8
    cmp  al,bl									;
    je   .keydownShift3							;
    
    .keydownShift1:								;
    mov  al,[keys+(0xA1>>3)]					;
    shl  al,7-(0xA1&0x07)						;
    and  al,0x80								;
    mov  bl,[.lParam+3]							;
    and  bl,0x80								; KF_UP >> 8
    cmp  al,bl									;
    je   .keydownShift4							;
    
    .keydownShift2:								;
    cmp  byte[.lParam+2],0x2A					; Left shift??
    je   .keydownShiftL							;
    cmp  byte[.lParam+2],0x36					; Right shift??
    je   .keydownShiftR							;
    
    .keydownShiftL:								;
     mov  eax,0xA0								; VK_LSHIFT
     jmp  .keydown1								;
    
    .keydownShift3:								;
     push 0xA0									;
     call _GetKeyState@4						;
     and  ah,0x80								;
     mov  bl,[.lParam+3]						;
     and  bl,0x80								; KF_UP >> 8
     cmp  ah,bl									;
     jne  .keydownShiftL						;
     jmp  .keydownShift1						;
    
    .keydownShift4:								;
     push 0xA1									;
     call _GetKeyState@4						;
     and  ah,0x80								;
     mov  bl,[.lParam+3]						;
     and  bl,0x80								; KF_UP >> 8
     cmp  ah,bl									;
     je   .keydownShift2						;
    
    .keydownShiftR:								;
     mov  eax,0xA1								; VK_RSHIFT
     jmp  .keydown1								;
   
   .keydownCtrl:								;
    test byte[.lParam+3],0x01					; KF_EXTENDED >> 8
    jne  .keydownCtrlR							;
    .keydownCtrlL:								;
     mov  eax,0xA2								; VK_LCONTROL
     jmp  .keydown1								;
    .keydownCtrlR:								;
     mov  eax,0xA3								; VK_RCONTROL
     jmp  .keydown1								;
   
   .keydownAlt:
    test byte[.lParam+3],0x01					; KF_EXTENDED >> 8
    jne  .keydownAltR							;
    .keydownAltL:								;
     mov  eax,0xA4								; VK_LMENU
     jmp  .keydown1								;
    .keydownAltR:								;
     mov  eax,0xA5								; VK_RMENU
     jmp  .keydown1								;
  
  
 
 .quit:											;
  mov  byte[_closerequest],1					;
 .retzero:										;
  mov  eax,0									;
  ret  16										;
 
 .syscommand:									;
  mov  eax,[.wParam]							;
  cmp  eax,0xF100								; SC_KEYMENU
  je   .retzero									;
  cmp  eax,0xF090								; SC_MOUSEMENU
  je   .retzero									;
  cmp  eax,0xF140								; SC_SCREENSAVE
  je   .retzero									;
  cmp  eax,0xF170								; SC_MONITORPOWER
  je   .retzero									;
  cmp  eax,0xF060								; SC_CLOSE
  je   .quit									;
  jmp  .default									;
 
 
 
 .default:
  push dword[.lParam]							; 
  push dword[.wParam+4]							; 
  push dword[.uMsg+8]							; 
  push dword[.hWnd+12]							; 
  call _DefWindowProcW@16						;Default Window Procedure
  
  ret  16
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 section .bss
 
 .mDx resw 1
 .mDy resw 1
 .mAccumdx resw 1
 .mAccumdy resw 1
 .mLastx resw 1
 .mLasty resw 1
 .mAccumdwheel resw 1
 .mButtons resb 1
 .mCapture resb 1
 _hWnd resd 1

 section .text
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;