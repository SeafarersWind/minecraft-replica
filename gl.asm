extern _glEnable@4
extern _glShadeModel@4
extern _glClearColor@16
extern _glClearDepth@8
extern _glDepthFunc@4
extern _glMatrixMode@4
extern _glLoadIdentity@0

section .text

GLinit: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 push 0x0DE1									; GL_TEXTURE_2D
 call _glEnable@4								;Enable two-dimensional texturing
 
 push 0x1D01									; GL_SMOOTH
 call _glShadeModel@4							;Select smooth shading
 
 push f(0.0)									; alpha
 push f(1.0)									; blue
 push f(0.8)									; green
 push f(0.5)									; red
 call _glClearColor@16							;Clear values for color
 
 push dh(1.0)									; clear value
 push dl(1.0)									; clear value
 call _glClearDepth@8							;Set the depth clear value to 1.0
 
 push 0x0B71									; GL_DEPTH_TEST
 call _glEnable@4								;Enable depth comparisons
 
 push 0x0203									; GL_LEQUAL
 call _glDepthFunc@4							;Set the comparison function to lequal
 
 push 0x1701									; GL_PROJECTION
 call _glMatrixMode@4							;Set the matrix to the projection matrix stack
 
 call _glLoadIdentity@0							;Load the identity matrix
 
 push 0x1700									; GL_MODELVIEW
 call _glMatrixMode@4							;Set the matrix to the model matrix stack
 
 ret
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;