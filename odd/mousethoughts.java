int x = lParam & 0xFFFF;
GetClientRect(_hWnd, new Rect rect)
int y = (rect.bottom - rect.top) - 1 - (lParam >> 16 & 0xFFFF)
int dx = x - last_x;
int dy = y - last_y;

if (dx != 0 || dy != 0) {
 accum_dx += dx;
 accum_dy += dy;
 
 last_x = x;
 last_y = y;    
}