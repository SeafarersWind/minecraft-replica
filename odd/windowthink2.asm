LWJGLWNinit:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;int, int, int, int, boolean, boolean, long
 ;X, Y, width, height, isFullscreen|isUndecorated, isChild, hWndParent
 
 ;int?, int?, int, int, int, int, char, char, HWND, int?
 ;arg_0?, X, Y, arg_10, arg_14, arg_18, arg_1C, hWndParent
 
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
 
 
 
 
WNinit: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;width = 1024
 ;height = 768
 
 nCreateWindow(x, y, mode.getWidth(), mode.getHeight(), (Display.isFullscreen() || isUndecorated()), (parent != null), parent_hwnd);
 ;JNIEnv, jclass, jint,                  jint,                    jint,  jint,   jboolean,    jboolean,     jlong
 ;*env,   unused, x,                     y,                       width, height, undecorated, child_window, parent_hwnd
 ;?,      ?,      (screenwidth-width)/2, (screenheight-height)/2, width, height, false?,      false,        0
 	HWND hwnd;
	if (!registerWindow()) {
		throwException(env, "Could not register window class");
		return 0;
	}
	hwnd = createWindow(x, y, width, height);
	return (INT_PTR)hwnd;
	
	
 registerWindow()
  	WNDCLASS windowClass;
	memset(&windowClass, 0, sizeof(windowClass));
	
	windowClass.style = CS_OWNDC;				;!!!!!!!!!!!!!!!!!!
	windowClass.lpfnWndProc = WNproc;			;
	windowClass.cbClsExtra = 0;					;
	windowClass.cbWndExtra = 0;					;
	windowClass.hInstance = dll_handle;			;
	windowClass.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	windowClass.hCursor = LoadCursor(NULL, IDC_ARROW);
	windowClass.hbrBackground = NULL;			;
	windowClass.lpszMenuName = NULL;			;
	windowClass.lpszClassName = WNtClassname;	;
												;
	if (RegisterClass(&windowClass) == 0) {		;
		printfDebug("Failed to register window class\n");
		return false;
	}
	return true;
 
 
 createWindow(int x, int y, int width, int height)
 createWindow(int x, int y, int width, int height)
	DWORD windowflags;
	
	;undecorated == false
	 windowflags = WS_OVERLAPPED | WS_BORDER | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU | WS_CLIPCHILDREN | WS_CLIPSIBLINGS
	;undecorated == true
	 ;windowflags = WS_POPUP | WS_CLIPCHILDREN | WS_CLIPSIBLINGS;

 	RECT clientSize;
	clientSize.bottom = height;
	clientSize.left = 0;
	clientSize.right = width;
	clientSize.top = 0;

	AdjustWindowRectEx(							;?????????
	  &clientSize,    // client-rectangle structure
	  windowflags,    // window styles			;windowflags
	  FALSE,       // menu-present option		;
	  WS_EX_APPWINDOW   // extended window style;
	);
	// Create the window now, using that class:
	return CreateWindowEx (						;!!!!!!!!!!!!!!!!!!!!!!!
			WS_EX_APPWINDOW,					;exstyle
			WNtClassname,						;
			_T(""),								;
			windowflags,						;windowflags
			x, y, clientSize.right - clientSize.left, clientSize.bottom - clientSize.top,
			0,									;parent
			NULL,								;
			dll_handle,							;
			NULL);								;
 
 
WNinit: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
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
 mov  dword[.wc.style],0x0020					; CS_OWNDC
 mov  dword[.wc.lpfnWndProc],WNproc				;
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
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;