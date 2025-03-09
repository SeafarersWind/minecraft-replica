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