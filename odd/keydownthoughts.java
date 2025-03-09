   //handleKeyButton(long wParam, long lParam, long millis)
   //wParam: virtual-key code; uses low byte
   //lParam: other parameters
   byte state = (byte)(1L - (lParam >>> 31L & 0x1L));			//lParam bit 31: Transition state; 1 for KEYUP, 0 for KEYDOWN
   boolean repeat = (state == ((byte)(lParam >>> 30L & 0x1L)));	//lParam bit 30: Previous key state; 1 if they key was down before KEYDOWN, 1 for KEYUP, 0 otheriwse
   int virt_key = (int)wParam;									//wParam: virtual-key code
   boolean extended = (((byte)(lParam >>> 24L & 0x1L)) != 0);	//lParam bit 24: Extended key; Shift, Ctrl, and Alt are extended keys if they are left and right
   int keycode = WindowsKeycodes.mapVirtualKeyToLWJGLCode(virt_key);
   
   switch (virt_key) {
    case 0x10:	;VK_SHIFT
     if ( (this.key_down_buffer[keycode] == (1 - state))  &&  (((_GetKeyState(0xA1) >>> 15) & 0x1) == state) )
      virt_key = 0xA1;					//VK_RSHIFT
      break;
     if (((int)(lParam >>> 16L & 0xFFL)) == 54)					//lParam bits 16..23: Scan code; OEM. 54 = VK_RSHIFT apparently
      virt_key = 0xA1;					//VK_RSHIFT
      break;
     virt_key = 0xA0;					//VK_LSHIFT
     break;
    case 0x11:	;VK_CONTROL
     virt_key = extended ? 0xA3 : 0xA2	//VK_RCONTROL : VK_LCONTROL
     break;
    case 0x12:	;VK_MENU (alt)
     virt_key = extended ? 0xA5 : 0xA4	//VK_RMENU : VK_LMENU
     break;
   }
   
   if (!repeat && ((state == 1) == (this.virt_key_down_buffer[virt_key] == 1)))
    return;		//don't bother if it's the same; might not be faster in this here code
   //EventQueue stuff; not used?
   
   if (keycode < this.key_down_buffer.length) {
    this.key_down_buffer[keycode] = state //used for all keyboard stuff
    this.virt_key_down_buffer[virt_key] = state //used for WM_KILFOCUS and WM_SETFOCUS
   }
   
   this.retained_key_code = keycode;
   this.retained_state = state;
   this.retained_millis = millis;
   this.retained_char = 0;
   this.retained_repeat = repeat;