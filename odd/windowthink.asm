;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 %define u(x) __?utf16?__(x)
 
 section .bss ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 _Instance resd
 
 section .code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 startup:
  push 0
  call _GetModuleHandleW
  mov  _Instance,eax
  
  ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WN:
WNinit:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 section .data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 .tClass dw u('UNDERGROWTH'),0
 .tIcon dw u('ICON'),0
 
 section .code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 												;FOREGROUNDLOCKTIMEOUT: stops _SetForegroundWindow
 ;Init											;from working freely sometimes.
 push 0											; Save the old value...
 push &_glfw.win32.foregroundLockTimeout		;
 push 0											;
 push SPI_GETFOREGROUNDLOCKTIMEOUT				;
 call _SystemParametersInfoW					;
 												;
 push SPIF_SENDCHANGE							; Set the new value to 0!
 push UIntToPtr(0)								;
 push 0											;
 push SPI_SETFOREGROUNDLOCKTIMEOUT				;
 call _SystemParametersInfoW					;
 
 ;here glfw uses LoadLobraryA("user32.dll"), but I can just include user32.dll in the linker,
 ; right? return false if this one fails!
 ;now glfw uses GetProcAddress to load different user32 functions
 ; _SetProcessDpiAware, _ChangeWindowMessageFilterEx, _EnablelNonClientDpiScaling,
 ; _SetProcessDpiAwarenessContext, _GetDpiForWindow, _AdjustWindowRectExForDpi,
 ; _GetSystemMetricsForDpi
 ;load dinput8.dll...
 ; _DirectInput8Create
 ;load various xinput libraries, whichever one works...
 ; _XInputGetCapabilities, _XInputGetState
 ;load dwampi.dll...
 ; _DwmIsCompositionEnabled, _DwmFlush, _DwmEnableBlurBehindWindow, _DwmGetColorizationColor
 ;load shcore.dll...
 ; _SetProcessDpiAwareness, _GetDpiForMonitor
 ;load ntdll.dll...
 ; _RtlVerifyVersionInfo
 ;return true!
 
 ;keyboard mapping
 ;_MapVirtualKeyW
 ;what will they do with these keys...??   watch out for...
 ;_glfw.win32.keycodes, _glfw.win32.scancodes, and _glfw.win32.keynames
 
 ;check windows 10 version...  _VerSetConditionMask, _RtlVerifyVersionInfo
 ; _SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2)
 ;else check windows 10 version...  _VerSetConditionMask, _RtlVerifyVersionInfo
 ; _SetProcessDpiAwareness(PROCESS_PER_MONITOR_DPI_AWARE)
 ;else check windows 10 version...  _VerSetConditionMask, _RtlVerifyVersionInfo
 ; _SetProcessDpiAware()
 
 push ebp										; Window Class structure for registration...
 mov  ebp,esp									;
 sub  esp,48									;
 %define .wc                ebp-44				; Window Class
 %define .wc.cbSize         sWn					; Size
 %define .wc.style          sWn+4				; Style
 %define .wc.lpfnWndProc    sWn+8				; Window Procedure
 %define .wc.cbClsExtra     sWn+12				; extra bytes post Class
 %define .wc.cbWndExtra     sWn+16				; extra bytes post Instance
 %define .wc.hInstance      sWn+20				; Instance
 %define .wc.hIcon          sWn+24				; Icon
 %define .wc.hCursor        sWn+28				; Cursor
 %define .wc.hbrBackground  sWn+32				; Background Brush
 %define .wc.lpszMenuName   sWn+36				; Menu Name
 %define .wc.lpszClassName  sWn+40				; Class Name
 %define .wc.hIconSm        sWn+44				; Small Icon
 
 mov  dword[.wc.cbSize],48						; 
 mov  dword[.wc.style],0x0023					; CS_HREDRAW | CS_VREDRAW | CD_OWNDC	; lwjgl only uses CD_OWNDC
 mov  dword[.wc.lpfnWndProc],WNproc				;
 mov  dword[.wc.cbClsExtra],0					;
 mov  dword[.wc.cbWndExtra],0
 mov  dword[.wc.hInstance],_Instance			;
 push 0x00008040								; LR_DEfAULTSIZE | LR_SHARED
 push 0											;
 push 0											;
 push 1											; IMAGE_ICON
 push .tIcon									;
 push _Instance									;
 call _LoadImageW								;
 mov  dword[.wc.hIcon],eax						;
 push 32512										; IDC_ARROW
 push 0											;
 call _LoadCursorW								;
 mov  dword[.wc.hCursor],eax					;
 mov  dword[.wc.hbrBackground],0				;
 mov  dword[.wc.lpszMenuName],0					;
 mov  dword[.wc.lpszClassName],.tClass			;
 mov  dword[.wc.hIconSm],0						;
 push .wc										;
 call _RegisterClassExW							; register
 cmp  eax,0										;
 je   .registerError							;
 
 add  esp,48
 pop  ebp
 
 ;now it creates a helper window... do i need it?   watch out for...
 ;_glfw.win32.helperWindowHandle and _glfw.win32.deviceNotifcationHandle
 
 ;_QueryPergormanceFrequency(_glfw.timer.win32.frequency)
 
 ;_DirectInput8Create
 ;_XInputGetCapabilities
 ;maybe more...?
 ;i do not think i am using xinput
 
 ;poll monitors.... aaghh
 ;_EnumDisplayDevicesW(adapter.DeviceName,displayIndex,&display,0)
 ;_EnumDisplayMonitors(0,0,monitorCallback,_glfw.monitors[i])
 ;createMonitor(adapter, display)
 ;_glfwInputMonitor
 ;yowzie...
 
 ;now...
 
 ;CreateMutex _InitializeCriticalSection
 ;CreateTls _TlsAlloc
 ;CreateTls _TlsAlloc
 
 ;SetTls _TlsSetValue
 ;GamepadMappings 
 ;GetTimerValue _QueryPerformanceCounter
 ;DefaultWindowHints
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;WindowHints
 ; _glfw.hints.context.major = 4
 ; _glfw.hints.context.minor = 6
 ; _glfw.hints.context.profile = GLFW_OPENGL_CORE_PROFILE
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;CreateWindow
 ;_EnumDisplaySettingsExW(monitor->win32.adapterName, ENUM_CURRENT_SETTINGS, &dm, EDS_ROTATEDMODE)
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;MakeContextCurrent
 
 ;SetKeyCallback
 
 ;glVewport
 
WNloop:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;ClearColor
 ;Clear
 
 ;SwapBuffers
 ;PollEvents
 
LWJGLWNinit:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;int, int, int, int, boolean, boolean, long
 ;X, Y, width, height, isFullscreen|isUndecorated, isChild, hWndParent
 
 ;int, int, int, int, int, int, char, char, HWND, int
 ;arg_0, ?, X, Y, arg_10, arg_14, arg_18, arg_1C, hWndParent
 
 already done? >skip
 
 ;proc,"LWJGL"
 ;arg_0, arg_4
 
 push ebp										; Window Class structure for registration...
 mov  ebp,esp									;
 sub  esp,44									;
 %define .wc                ebp-40				; Window Class
 %define .wc.cbSize         .wc					; Size
 %define .wc.style          .wc+4				; Style
 %define .wc.lpfnWndProc    .wc+8				; Window Procedure
 %define .wc.cbClsExtra     .wc+12				; extra bytes post Class
 %define .wc.cbWndExtra     .wc+16				; extra bytes post Instance
 %define .wc.hInstance      .wc+20				; Instance
 %define .wc.hIcon          .wc+24				; Icon
 %define .wc.hCursor        .wc+28				; Cursor
 %define .wc.hbrBackground  .wc+32				; Background Brush
 %define .wc.lpszMenuName   .wc+36				; Menu Name
 %define .wc.lpszClassName  .wc+40				; Class Name
 
 mov  dword[.wc.cbSize],48						; 
 mov  dword[.wc.style],0x0020					; CD_OWNDC
 mov  dword[.wc.lpfnWndProc],LWJGLWNproc		;
 mov  dword[.wc.hInstance],_Instance			;
 push 0x00007F00								; IDI_APPLICATION
 push 0											;
 call _LoadIconW								;
 mov  dword[.wc.hIcon],eax						;
 push 0x00007F00								; IDC_ARROW
 push 0											;
 call _LoadCursorW								;
 mov  dword[.wc.hCursor],eax					;
 mov  dword[.wc.hbrBackground],0				;
 mov  dword[.wc.lpszMenuName],0					;
 mov  dword[.wc.lpszClassName],.tClass			;
 ;.wc.hIconSm									;
 push .wc;
 call _RegisterClassW							; more outdated; doesn't use small icon
 cmp  eax,0										;
 je   .registerError							;
 
 add  esp,44									;
 pop  ebp										;
 
 ;"LWJGL", X, Y, width, height, isFullscreen|isUndecorated, isChild, hWndParent
 ;lpClassName, X, Y, arg_C, arg_10, arg_14, arg_18, hWndParent
 
 push ebp										;
 mov  ebp,esp									;
 sub  esp,0x10									;
 
 cmp  [esp+0x10+arg_14],0						;isFullscreen|isUndecorated
 jz   .notFullscreen							;
 mov  edi,0x80000000							;dwStyle
 jmp  .notFullscreenD							;
 .notFullscreen:								;
 cmp  [esp+0x18+arg_18],0						;isChild
 jz   .notChild									;
 xor  esi,esi									;
 mov  edi,0x40000000							;dwStyle
 jmp  .notChildD								;
 .notChild:										;
 mov  edi,0x00CA0000							;dwStyle
 notFullscreenD:								;
 mov  esi, 0x00040000							;dwExStyle
 .notChildD:									;
 mov  ecx,[esp+0x18+arg_C]						;
 mov  edi,0x06000000							;
 
 push esi										;
 push 0											;
 push edi										;
 push [esp+0x24+Rect]							;
 mov  eax,[esp+0x1C+arg_10]						;
 mov  [esp+0x28+Rect.bottom],eax				;
 mov  [esp+0x28+Rect.left],0					;
 mov  [esp+0x28+Rect.right],eax					;
 mov  [esp+0x28+Rect.top],0						;
 call _AdjustWindowRectEx						;_AdjustWindowRectEx
 push 0											;
 push _Instance									;
 push 0											;
 push [esp+0x18+hWndParent]						;
 mov  edx,[esp+0x18+Rect.bottom]				;
 sub  edx,[esp+0x18+Rect.top]					;
 push edx										;
 mov  eax,[esp+0x20+Rect.right]					;
 sub  eax,[esp+0x20+Rect.left]					;
 push eax										;
 push [esp+0x28+Y]								;
 push [esp+0x2C+X]								;
 push edi										;
 push WindowName								;
 push [esp+0x30+lpClassName]					;
 push esi										;
 call _CreateWindowExW							;_CreateWindowExW
 
 add  esp,0x10									;
 pop  ebp										;
 
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;