.386
.model flat,stdcall
option casemap: none
include F:\masm32\include\kernel32.inc
include F:\masm32\include\user32.inc
include F:\masm32\include\windows.inc
include F:\masm32\include\gdi32.inc
includelib F:\masm32\lib\kernel32.lib
includelib F:\masm32\lib\user32.lib
includelib F:\masm32\lib\shell32.lib
includelib F:\masm32\lib\gdi32.lib

.data
    MainClassName   BYTE "MainWindow", 0
    ButtonClassName BYTE "BUTTON", 0
    AppName         BYTE "Calculator", 0
    MainString      BYTE "Calculator by Ermola", 0
    wc              WNDCLASSEX <>
    msg             MSG <>

    MainPs          PAINTSTRUCT <>
    MainRect        RECT <>

    ButtonName      db 4 dup ("0", 0)
    SFInt1          db 0
    SFInt2          db 0
    SFInt3          db 0 
    SFMemory        db 0
    OutputString    db 12 dup (48, 0)
    OutputString1   db 12 dup (0)
    OutputString2   db 12 dup (0)
    Char            db 2 dup (0, 0)
    Char1           db 2 dup (0, 0)
    Char2           db 2 dup ("=", 0)
    Integer1        dd 0
    Integer2        dd 0
    Integer3        dd 0
    Memory          dd 0
    Flag            db 1
    cmFlag          db 0
    nFlag           db 0

.data?
    MainHwnd        HWND ?
    hInstance       HINSTANCE ?  

    MainHdc         HDC ?
   
.code
start:

invoke  GetModuleHandle, NULL
mov     hInstance, eax
mov     wc.cbSize, SIZEOF WNDCLASSEX
mov     wc.style, CS_HREDRAW or CS_VREDRAW
mov     wc.lpfnWndProc, OFFSET WndProc
mov     wc.cbClsExtra, NULL
mov     wc.cbWndExtra, NULL
push    hInstance
pop     wc.hInstance

invoke  CreateSolidBrush, 00AACCAAh             
mov     wc.hbrBackground, eAx

mov     wc.lpszMenuName, NULL
mov     wc.lpszClassName, OFFSET MainClassName
invoke  LoadIcon, NULL, IDI_APPLICATION
mov     wc.hIcon, eax
mov     wc.hIconSm, eax
invoke  LoadCursor, NULL, IDC_ARROW
mov     wc.hCursor, eax
invoke  RegisterClassEx, ADDR wc

invoke  CreateWindowEx, WS_EX_TOPMOST, ADDR MainClassName, ADDR AppName,\
        WS_OVERLAPPED or WS_SYSMENU or WS_VISIBLE, 200,\
        400, 365, 465,\
        NULL, NULL, hInstance, NULL        
mov     MainHwnd, eax    


invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 25,\
        365, 40, 40,\
        MainHwnd, "0", hInstance, NULL

inc     ButtonName        
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 25,\
        170, 40, 40,\
        MainHwnd, "1", hInstance, NULL

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 90,\
        170, 40, 40,\
        MainHwnd, "2", hInstance, NULL 

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 155,\
        170, 40, 40,\
        MainHwnd, "3", hInstance, NULL
        
inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 25,\
        235, 40, 40,\
        MainHwnd, "4", hInstance, NULL 

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 90,\
        235, 40, 40,\
        MainHwnd, "5", hInstance, NULL    

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 155,\
        235, 40, 40,\
        MainHwnd, "6", hInstance, NULL   

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 25,\
        300, 40, 40,\
        MainHwnd, "7", hInstance, NULL    

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 90,\
        300, 40, 40,\
        MainHwnd, "8", hInstance, NULL    

inc     ButtonName
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 155,\
        300, 40, 40,\
        MainHwnd, "9", hInstance, NULL  
              

mov     ButtonName, "+"
mov     ButtonName+1, "/"
mov     ButtonName+2, "-"
mov     ButtonName+3, 0
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 90,\
        365, 40, 40,\
        MainHwnd, ":", hInstance, NULL
mov     ButtonName+1, 0         

mov     ButtonName, "<"
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 155,\
        365, 40, 40,\
        MainHwnd, "<", hInstance, NULL

mov     ButtonName, "+"
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 225,\
        365, 40, 40,\
        MainHwnd, "+", hInstance, NULL

mov     ButtonName, "-"
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 290,\
        170, 40, 40,\
        MainHwnd, "-", hInstance, NULL

mov     ButtonName, "*"
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 225,\
        235, 40, 40,\
        MainHwnd, "*", hInstance, NULL

mov     ButtonName, "/"
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 290,\
        235, 40, 40,\
        MainHwnd, "/", hInstance, NULL

mov     ButtonName, "M"
mov     ButtonName+1, "+"
mov     ButtonName+2, 0
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 225,\
        300, 40, 40,\
        MainHwnd, "M", hInstance, NULL

mov     ButtonName, "M"
mov     ButtonName+1, "R"
mov     ButtonName+2, "C"
mov     ButtonName+3, 0
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 290,\
        300, 40, 40,\
        MainHwnd, "R", hInstance, NULL
mov     ButtonName+1, 0        

mov     ButtonName, "="
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 290,\
        365, 40, 40,\
        MainHwnd, "=", hInstance, NULL

mov     ButtonName, "C"
invoke  CreateWindowEx, NULL, ADDR ButtonClassName, ADDR ButtonName,\
        WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE, 225,\
        170, 40, 40,\
        MainHwnd, "C", hInstance, NULL

.WHILE  TRUE
    invoke  GetMessage, ADDR msg, NULL, 0, 0
    or      eax, eax
    jz      Quit
    invoke  DispatchMessage, ADDR msg
.ENDW

Quit:
    mov     eax, msg.wParam
    invoke  ExitProcess, eax

WndProc proc hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM 
    LOCAL   hdc: HDC
    LOCAL   ps: PAINTSTRUCT
    LOCAL   rect: RECT
    LOCAL   rect1: RECT
    LOCAL   rect2: RECT
    LOCAL   rect3: RECT
    LOCAL   rect4: RECT
    LOCAL   rect5: RECT

    mov     rect.top, 25
    mov     rect.left, 25
    mov     rect.right, 330
    mov     rect.bottom, 40

    mov     rect1.top, 65
    mov     rect1.left, 25
    mov     rect1.right, 330
    mov     rect1.bottom, 80
    
    mov     rect2.top, 80
    mov     rect2.left, 25
    mov     rect2.right, 330
    mov     rect2.bottom, 95
    
    mov     rect3.top, 95
    mov     rect3.left, 25
    mov     rect3.right, 330
    mov     rect3.bottom, 110
    
    mov     rect4.top, 110
    mov     rect4.left, 25
    mov     rect4.right, 330
    mov     rect4.bottom, 125
    
    mov     rect5.top, 125
    mov     rect5.left, 25
    mov     rect5.right, 330
    mov     rect5.bottom, 140 
    
        
    .IF uMsg == WM_DESTROY
        invoke  PostQuitMessage, NULL

    .ELSEIF uMsg == WM_PAINT  
        invoke  BeginPaint, hWnd, ADDR ps
        mov     hdc, eax
        invoke  FillRect, hdc, ADDR rect, 0
        invoke  FillRect, hdc, ADDR rect1, 0
        invoke  FillRect, hdc, ADDR rect2, 0
        invoke  FillRect, hdc, ADDR rect3, 0
        invoke  FillRect, hdc, ADDR rect4, 0
        invoke  FillRect, hdc, ADDR rect5, 0
        invoke  DrawText, hdc, ADDR MainString, -1, ADDR rect, DT_CENTER
        
        .IF Flag == 1
            invoke  DrawText, hdc, ADDR OutputString, -1, ADDR rect1, DT_RIGHT 
        .ELSEIF Flag == 2
            invoke  DrawText, hdc, ADDR OutputString, -1, ADDR rect1, DT_RIGHT
            invoke  DrawText, hdc, ADDR Char1, -1, ADDR rect2, DT_RIGHT 
        .ELSEIF Flag == 3
            invoke  DrawText, hdc, ADDR OutputString1, -1, ADDR rect1, DT_RIGHT
            invoke  DrawText, hdc, ADDR Char1, -1, ADDR rect2, DT_RIGHT
            invoke  DrawText, hdc, ADDR OutputString, -1, ADDR rect3, DT_RIGHT              
        .ELSEIF Flag == 6
            invoke  DrawText, hdc, ADDR OutputString1, -1, ADDR rect1, DT_RIGHT
            invoke  DrawText, hdc, ADDR Char1, -1, ADDR rect2, DT_RIGHT
            invoke  DrawText, hdc, ADDR OutputString2, -1, ADDR rect3, DT_RIGHT
            invoke  DrawText, hdc, ADDR Char2, -1, ADDR rect4, DT_RIGHT
            invoke  DrawText, hdc, ADDR OutputString, -1, ADDR rect5, DT_RIGHT                         
        .ENDIF
            
        invoke  EndPaint, hWnd, ADDR ps            

    .ElSEIF uMsg == WM_COMMAND
        xor     edx, edx
        mov     edx, wParam
        mov     Char, Dl

        cmp     wParam, 48
        je      Paint

        cmp     wParam, 49
        je      Paint
        
        cmp     wParam, 50
        je      Paint
        
        cmp     wParam, 51
        je      Paint
        
        cmp     wParam, 52
        je      Paint
        
        cmp     wParam, 53
        je      Paint
        
        cmp     wParam, 54
        je      Paint
        
        cmp     wParam, 55
        je      Paint
        
        cmp     wParam, 56
        je      Paint
        
        cmp     wParam, 57
        je      Paint     

        cmp     wParam, "+"
        je      Command

        cmp     wParam, "-"    
        je      Command

        cmp     wParam, "*"
        je      Command

        cmp     wParam, "/"    
        je      Command

        cmp     wParam, "="
        je      Command

        cmp     wParam, "C"
        je      Command

        cmp     wParam, "<"
        je      Command

        cmp     wParam, ":"
        je      Command
        
        cmp     wParam, "M"
        je      Command
        
        cmp     wParam, "R"
        je      Command 

        Paint:
            .IF Flag == 2
                mov     Flag, 3
                .IF OutputString1 == 0     
                    xor     ecx, ecx
                    Cycle2:
                        xor     eax, eax
                        mov     Al, [OutputString+ecx]
                        mov     [OutputString1+ecx], Al
                        inc     ecx
                        cmp     ecx, 12
                    jne Cycle2       
                    mov     OutputString, 0
                .ENDIF
            .ELSEIF Flag == 6
                mov     Integer1, 0
                mov     Integer2, 0
                mov     Integer3, 0
                mov     OutputString, 48
                mov     OutputString+1, 0
                mov     OutputString1, 0
                mov     OutputString2, 0
                mov     SFInt1, 0
                mov     SFInt2, 0
                mov     SFInt3, 0
                mov     Flag, 1
            .ENDIF    

            .IF Flag < 4
                .IF Char >= "0"
                    .IF Char <= "9"    
                        call    FromCharToInt
                        call    FromIntToStr        
                        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                    .ENDIF
                .ENDIF
            .ENDIF            
            jmp     Exit

        Command:
            .IF wParam < "0"
                .IF Flag < 3
                    mov     Flag, 2
                    mov     Al, Char                     
                    mov     Char1, Al 
                    .IF wParam == "+"
                        mov     cmFlag, 1
                    .ELSEIF wParam == "-"    
                        mov     cmFlag, 2
                    .ELSEIF wParam == "*"
                        mov     cmFlag, 3
                    .ELSEIF wParam == "/"
                        mov     cmFlag, 4
                    .ENDIF             
                    invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE                  
                .ELSEIF Flag == 3
                    mov     Flag, 4   
                .ELSEIF Flag == 6
                    mov     Flag, 8
                    mov     Al, Char
                    mov     Char1, Al 
                    .IF wParam == "+"
                        mov     cmFlag, 1
                    .ELSEIF wParam == "-"    
                        mov     cmFlag, 2
                    .ELSEIF wParam == "*"
                        mov     cmFlag, 3
                    .ELSEIF wParam == "/"
                        mov     cmFlag, 4
                    .ENDIF                  
                .ENDIF
                
            .ElSEIF wParam == "<" 
                .IF Flag < 4 
                    call    IntMinus
                    call    FromIntToStr        
                    invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE     
                .ENDIF  
                     
            .ElSEIF wParam == "="
                .IF Flag == 2
                    mov     eax, Integer1
                    mov     Integer2, eax
                    mov     Al, SFInt1
                    mov     SFInt2, Al
                    xor     ecx, ecx
                    Cycle8:
                        xor     eax, eax
                        mov     Al, [OutputString+ecx]
                        mov     [OutputString1+ecx], Al
                        inc     ecx
                        cmp     ecx, 12
                    jne Cycle8                    
                    mov     Flag, 5  
                .ELSEIF Flag == 3
                    mov     Flag, 5    
                .ELSEIF Flag == 6
                    mov     eax, Integer3
                    mov     Integer1, eax
                    mov     Al, SFInt3
                    mov     SFInt1, Al
                    mov     nFlag, 1
                    mov     Flag, 5    
                .ENDIF    
                
            .ELSEIF wParam == "C"
                mov     Flag, 7 

            .ELSEIF wParam == ":"
                .IF Flag < 3
                    .IF Integer1 != 0
                        .IF SFInt1 == 1
                            mov     SFInt1, 0
                        .ELSE
                            mov     SFInt1, 1
                        .ENDIF 
                        call    FromIntToStr
                        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                    .ENDIF            
                .ELSEIF Flag == 3
                    .IF Integer2 != 0
                        .IF SFInt2 == 1
                            mov     SFInt2, 0
                        .ELSE
                            mov     SFInt2, 1
                        .ENDIF 
                        call    FromIntToStr
                        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                    .ENDIF
                .ENDIF 
                
            .ELSEIF wParam == "M"
                .IF Flag < 3
                    mov     eax, Integer1
                    mov     Memory, eax
                    mov     Al, SFInt1
                    mov     SFMemory, Al
                .ELSEIF Flag == 3
                    mov     eax, Integer2
                    mov     Memory, eax
                    mov     Al, SFInt2
                    mov     SFMemory, Al
                .ELSEIF Flag == 6
                    mov     eax, Integer3
                    mov     Memory, eax
                    mov     Al, SFInt3
                    mov     SFMemory, Al
                .ENDIF             

            .ELSEIF wParam == "R"
                .IF Flag < 3
                    mov     eax, Memory
                    mov     Integer1, eax
                    mov     Al, SFMemory
                    mov     SFInt1, Al
                    Call    FromIntToStr
                    invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                .ELSEIF Flag == 3
                    mov     eax, Memory
                    mov     Integer2, eax
                    mov     Al, SFMemory
                    mov     SFInt2, Al
                    Call    FromIntToStr
                    invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                .ELSEIF Flag == 6
                    mov     eax, Memory
                    mov     Integer1, eax
                    mov     Integer2, 0
                    mov     Integer3, 0
                    mov     OutputString1, 0
                    mov     OutputString2, 0
                    mov     Al, SFMemory
                    mov     SFInt1, Al
                    mov     SFInt2, 0
                    mov     SFInt3, 0
                    mov     Flag, 1
                    Call    FromIntToStr
                    invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE 
                .ENDIF       
    
            .ENDIF
                            
                           
            .IF Flag == 4
                mov     Flag, 2
                mov     OutputString1, 0
                mov     OutputString2, 0
                mov     Integer3, 0
                
                mov     eax, Integer2
                mov     Integer2, 0
                mov     Bl, SFInt2
                
                .IF cmFlag == 1    
                    .IF SFInt1 == Bl
                        add     Integer1, eax
                        .IF SFInt1 == 1
                            mov     SFInt1, 1
                        .ELSE 
                            mov     SFInt1, 0    
                        .ENDIF
                    .ELSE
                        sub     Integer1, eax
                        .IF SFInt1 == 1
                            .IF eax > Integer1
                                mov     SFInt1, 0
                                mov     edx, Integer1
                                mov     Integer1, 0
                                sub     Integer1, edx
                            .ELSEIF eax == Integer1
                                mov     SFInt1, 0
                            .ELSE
                                mov     SFInt1, 1 
                            .ENDIF       
                        .ELSE
                            .IF Integer1 >= eax
                                mov     SFInt1, 0
                            .ELSE
                                mov     SFInt1, 1
                                mov     edx, Integer1
                                mov     Integer1, 0
                                sub     Integer1, edx
                            .ENDIF    
                        .ENDIF
                    .ENDIF            
                .ELSEIF cmFlag == 2
                    .IF SFInt1 == Bl       
                        sub     Integer1, eax
                        .IF SFInt1 == 1
                            .IF eax > Integer1
                                mov     SFInt1, 0
                                mov     edx, Integer1
                                mov     Integer1, 0
                                sub     Integer1, edx
                            .ELSEIF eax == Integer1
                                mov     SFInt1, 0
                            .ELSE
                                mov     SFInt1, 1
                            .ENDIF        
                        .ELSE
                            .IF Integer1 >= eax
                                mov     SFInt1, 0
                            .ELSE
                                mov     SFInt1, 1
                                mov     edx, Integer1
                                mov     Integer1, 0
                                sub     Integer1, edx
                            .ENDIF    
                        .ENDIF    
                    .ELSE
                        add     Integer1, eax
                        .IF SFInt1 == 1
                            mov     SFInt1, 1
                        .ELSE 
                            mov     SFInt1, 0    
                        .ENDIF
                    .ENDIF
                .ELSEIF cmFlag == 3
                    mov     edx, Integer1
                    .IF eax == 0
                        mov     Integer1, 0
                    .ELSEIF eax > 1    
                        Cycle4:
                            add     Integer1, edx  
                            dec     eax  
                            cmp     eax, 1
                        jne Cycle4

                        mov     Al, SFInt2
                        .IF SFInt1 != Al
                            mov     SFInt1, 1
                        .ENDIF
                    .ENDIF       
                .ELSEIF cmFlag == 4
                    mov     edx, Integer1
                    mov     Integer1, 0
                    .IF eax != 0
                        Cycle6:
                            sub     edx, eax
                            inc     Integer1
                            cmp     edx, eax
                        jnl Cycle6

                        mov     Al, SFInt2
                        .IF SFInt1 != Al
                            mov     SFInt1, 1
                        .ENDIF
                    .ENDIF                               
                .ENDIF

                mov     Al, Char
                mov     Char1, Al    
                        
                .IF wParam == "+"
                    mov     cmFlag, 1
                .ELSEIF wParam == "-"    
                    mov     cmFlag, 2
                .ELSEIF wParam == "*"
                    mov     cmFlag, 3
                .ELSEIF wParam == "/"
                    mov     cmFlag, 4
                .ENDIF

                mov     SFInt2, 0
                mov     SFInt3, 0              
                
                call FromIntToStr
                invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                
            .ELSEIF Flag == 5      
                mov     Flag, 6  
                xor     ecx, ecx
                Cycle3:
                    xor     eax, eax
                    mov     Al, [OutputString+ecx]
                    .IF nFlag == 0
                        mov     [OutputString2+ecx], Al
                    .ELSE
                        mov     [OutputString1+ecx], Al
                    .ENDIF        
                    inc     ecx
                    cmp     ecx, 12
                jne Cycle3
                mov nFlag, 0
                
                mov     eax, Integer1
                mov     Integer3, eax
                mov     eax, Integer2
                mov     Bl, SFInt2
                
                .IF cmFlag == 1
                    .IF SFInt1 == Bl
                        add     Integer3, eax
                        .IF SFInt1 == 1
                            mov     SFInt3, 1
                        .ELSE 
                            mov     SFInt3, 0    
                        .ENDIF
                    .ELSE
                        sub     Integer3, eax
                        .IF SFInt1 == 1
                            .IF eax > Integer1
                                mov     SFInt3, 0
                                mov     edx, Integer3
                                mov     Integer3, 0
                                sub     Integer3, edx
                            .ELSEIF eax == Integer1
                                mov     SFInt3, 0
                            .ELSE
                                mov     SFInt3, 1 
                            .ENDIF       
                        .ELSE
                            .IF Integer1 >= eax
                                mov     SFInt3, 0
                            .ELSE
                                mov     SFInt3, 1
                                mov     edx, Integer3
                                mov     Integer3, 0
                                sub     Integer3, edx
                            .ENDIF    
                        .ENDIF    
                    .ENDIF    
                .ELSEIF cmFlag == 2
                    .IF SFInt1 == Bl
                        sub     Integer3, eax
                        .IF SFInt1 == 1
                            .IF eax > Integer1
                                mov     SFInt3, 0
                                mov     edx, Integer3
                                mov     Integer3, 0
                                sub     Integer3, edx
                            .ELSEIF eax == Integer1
                                mov     SFInt3, 0
                            .ELSE
                                mov     SFInt3, 1
                            .ENDIF       
                        .ELSE
                            .IF Integer1 >= eax
                                mov     SFInt3, 0
                            .ELSE
                                mov     SFInt3, 1
                                mov     edx, Integer3
                                mov     Integer3, 0
                                sub     Integer3, edx
                            .ENDIF    
                        .ENDIF
                    .ELSE
                        add     Integer3, eax
                        .IF SFInt1 == 1
                            mov     SFInt3, 1
                        .ELSE 
                            mov     SFInt3, 0    
                        .ENDIF
                    .ENDIF   
                .ELSEIF cmFlag == 3
                    mov     edx, Integer1
                    .IF eax == 0
                        mov     Integer3, 0
                    .ELSEIF eax > 1    
                        Cycle5:
                            add     Integer3, edx
                            dec     eax
                            cmp     eax, 1          
                        jne Cycle5
                        
                        mov     Al, SFInt2
                        .IF SFInt1 != Al
                            mov     SFInt3, 1
                        .ENDIF        
                    .ENDIF    
                .ELSEIF cmFlag == 4
                    mov     edx, Integer1
                    mov     Integer3, 0
                    .IF     eax != 0
                        Cycle7:
                            sub     edx, eax
                            inc     Integer3
                            cmp     edx, eax
                        jnl Cycle7

                        mov     Al, SFInt2
                        .IF SFInt1 != Al
                            mov     SFInt3, 1
                        .ENDIF                     
                    .ENDIF    
                .ENDIF    
                
                call    FromIntToStr
                invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                
            .ELSEIF Flag == 7
                mov     Integer1, 0
                mov     Integer2, 0
                mov     Integer3, 0
                ;mov     Memory, 0
                mov     OutputString, 48
                mov     OutputString+1, 0
                mov     OutputString1, 0
                mov     OutputString2, 0
                mov     SFInt1, 0
                mov     SFInt2, 0
                mov     SFInt3, 0
                ;mov     SFMemory, 0
                mov     Flag, 1
                invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE 

            .ELSEIF Flag == 8
                mov     Flag, 2
                mov     OutputString1, 0
                mov     OutputString2, 0
                mov     Integer2, 0
                
                mov     eax, Integer3
                mov     Integer1, eax
                mov     Integer3, 0        
                
                mov     Al, SFInt3
                mov     SFInt1, Al
                mov     SFInt2, 0
                mov     SFInt3, 0    
                
                call    FromIntToStr
                invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INVALIDATE
                           
            .ENDIF    

        Exit:                 
    
    .ELSE
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret     
    .ENDIF

    xor     eax, eax
    ret    
WndProc endp

FromCharToInt proc 
    LOCAL   del: DWORD
    LOCAL   Integer: DWORD

    .IF Flag < 3
        mov     eax, Integer1
        mov     Integer, eax
    .ELSEIF Flag == 3
        mov     eax, Integer2
        mov     Integer, eax
    .ENDIF

    mov     del, 10
    
    .IF Integer < 100000000
        mov     eax, Integer
        mul     del
        mov     Integer, eax       
        sub     Char, 48
        xor     eax, eax
        mov     al, Char
        add     Integer, eax
    .ENDIF

    mov eax, Integer
    .IF Flag < 3
        mov     Integer1, eax
    .ELSEIF Flag == 3
        mov     Integer2, eax
    .ENDIF
    
    ret
FromCharToInt endp

IntMinus proc 
    LOCAL   del: DWORD

    mov     del, 10

    .IF Flag < 3
        mov     eax, Integer1
    .ELSEIF Flag == 3
        mov     eax, Integer2
    .ENDIF
    
    .IF eax > 0
        xor edx, edx
        div del
    .ENDIF

    .IF Flag < 3
        mov     Integer1, eax
        .IF eax == 0
            mov     SFInt1, 0
        .ENDIF    
    .ELSEIF Flag == 3
        mov     Integer2, eax
        .IF eax == 0
            mov     SFInt2, 0
        .ENDIF
    .ENDIF
    
    ret
IntMinus endp    
    
FromIntToStr proc
    LOCAL   del:          DWORD
    LOCAL   kolvo:        DWORD
    LOCAL   cmechenie:    BYTE

    mov     del, 10

    .IF Flag < 3
        mov     eax, Integer1
    .ELSEIF Flag == 3
        mov     eax, Integer2
    .ELSEIF Flag == 6
        mov     eax, Integer3   
    .ENDIF
        
    mov     kolvo, esp
    
    cycle:
        xor     edx, edx
        div     del               
        push    edx
        cmp     eax, 0
    jne cycle

    xor     ecx, ecx
    
    .IF Flag < 3
        .IF SFInt1 == 1
            inc     ecx
            mov     OutputString, "-"    
        .ENDIF
    .ELSEIF Flag == 3
        .IF SFInt2 == 1
            inc     ecx
            mov     OutputString, "-"
        .ENDIF
    .ELSEIF Flag == 6
        .IF SFInt3 == 1
            inc     ecx
            mov     OutputString, "-"
        .ENDIF   
    .ENDIF    

    cycle1:
        xor     eax, eax
        pop     eax
        add     al, 48
        mov     [OutputString+ecx], al
        inc     ecx
        cmp     esp, kolvo
    jne cycle1

    mov     al, 0
    mov     [OutputString+ecx], al

    ret
FromIntToStr endp

end start