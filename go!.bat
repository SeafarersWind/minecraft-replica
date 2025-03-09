@echo off
set runner=run
del %runner%.exe
del %runner%.obj
nasm -f win32 -s %runner%.asm -o %runner%.obj
golink /entry:TheVeryBeginning /console kernel32.dll user32.dll opengl32.dll gdi32.dll glu32.dll winmm.dll %runner%.obj
@echo,
@echo,
@echo,
@echo,-------------------------------------------------------------------------------
%runner%.exe
@echo,
@echo,-------------------------------------------------------------------------------
pause