INCLUDE Irvine32.inc
include macros.inc
includelib Winmm.lib
.data
; Game variables
xPos BYTE 50               ; Player's X position (controlled by keyboard)
yPos BYTE 23               ; Player's Y position (bottom of the screen)
inputChar BYTE ?           ; Store user input
playerSpeed BYTE 2         ; Player's movement speed
playerLives Byte 3        ;Number of Lives of the player 
lifeSymbol byte ' <3', 0       ; Symbol representing a life
lifeX db 85   ; X position (adjustable)
lifeY db 9   ; Y position (adjustable)
name1 db 20 Dup(0)  ; User name, max 8 characters
scoreString db 2 DUP(0),0
levelString db 1 DUP(0),0

;store highscore
filename db "output.txt",0
filehandle dd ?

readfile1 db 5000 dup(?)  ; Buffer for file data
bytesread dd ?
debugMsg db "Debug: ",0
    buffer BYTE 256 DUP(0)
    buffer3 BYTE 256 DUP(0)          ; Temporary buffer for name
    buffer1 BYTE 256 DUP(0)          ; Temporary buffer for score string
    buffer2 BYTE 256 DUP(0)          ; Temporary buffer for scorelevel
    
    readhandle DWORD ?
    leaderboardNames BYTE 200 DUP(0) ; Stores top 10 names (20 bytes each)
    leaderboardScores DWORD 10 DUP(0) ; Stores top 10 scores
    leaderboardLevels db 1,2,1,3,1,1,2,2,3,1 ; Stores top 10 scores
    playerCount dd 0
    empty_message BYTE "No data in the leaderboard.", 0
    error_message BYTE "Error opening file.", 0
    newline BYTE 0Dh, 0Ah, 0
    iisort dd 0
    buffercount dd 0
    parsedsc dd ?
     header BYTE "Leaderboard:", 0
    rankText BYTE "Rank: ", 0
    nameText BYTE "Name: ", 0
    levelText BYTE "Level: ", 0
    scoreText BYTE "Score: ", 0


;------------------Boundary----------------------
leftBoundary BYTE 1
rightBoundary BYTE 79     ; Adjusted for a typical 80-column width
topBoundary BYTE 0        ; Adjusted for terminal's top
bottomBoundary BYTE 25     ; Typical 25-line terminal height



leftBoundary2 BYTE 83     ; Left boundary of the second border
rightBoundary2 BYTE 95    ; Right boundary of the second border
topBoundary2 BYTE 2       ; Top boundary of the second border
bottomBoundary2 BYTE 11   ; Bottom boundary of the second border

;------------------BRICK PLACEMENT----------------------

brickXPos BYTE 10, 20, 30, 40, 50, 60, 70 , 10, 20, 30, 40, 50, 60, 70, 10, 20, 30, 40, 50, 60, 70  ; Bricks' X positions
brickYPos BYTE 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5, 5 , 7, 7, 7, 7, 7, 7, 7    ; Bricks' Y positions
brickHealth BYTE 1, 1, 1, 1, 1, 1 ,1  ,1, 1, 1, 1, 1, 1 ,1  ,1, 1, 1, 1, 1, 1 ,1; Brick health counts (1 hit per brick) its reversed
brickCount BYTE 21                       ; Number of bricks
healthStage BYTE 2  ; Keeps track of the current stage (1, 2, or 3)
SpecialBrick Byte 5
;fixed brick is brick whose health will be greater then 5 



; Backup arrays for resetting
initialXPos BYTE 10, 20, 30, 40, 50, 60, 70 , 10, 20, 30, 40, 50, 60, 70, 10, 20, 30, 40, 50, 60, 70
initialYPos BYTE 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5, 5, 5, 5 , 7, 7, 7, 7, 7, 7, 7

;-------------------Time-----------------
timeInSeconds DWORD 300      ; Variable to store time in seconds
xPostime BYTE 85                  ; X position for displaying time
yPostime BYTE 3                   ; Y position for displaying time
countdown BYTE 9 
resetCount BYTE 9             ; Reset value for countdown 

;-------------------BRICK-----------------
brickString BYTE "-----", 0              ; Brick visual representation
brickWidth BYTE 5                       ; Width of each brick

;-------------------Player-----------------
xball BYTE 60           ; Ball's X position
yball BYTE 10           ; Ball's Y position
ddx BYTE -1              ; Ball's X direction (+1 or -1)
ddy BYTE 1              ; Ball's Y direction (+1 or -1)
ball BYTE 'O'           ; Ball character
PlayerString BYTE "-------", 0 
playerWidth Byte 7
ShortPlayerString BYTE "-----", 0 

;-------------------Score-----------------
score DWORD 0         ; Variable to store the score
scoreX db 85   ; X position (can be adjusted)
scoreY db 5    ; Y position (can be adjusted)
scoreMsg byte "Score:",0
delayvalue Byte 150

GameOverMsg BYTE "Game Over! The ball missed the player.", 0

namePrompt BYTE "Enter your name: ", 0  

  isPaused BYTE 0              ; 0 = game running, 1 = game paused
   ranNum byte 0


;-------------------Sounds-----------------
fileLevelComplete BYTE "LevelComplete.wav", 0  ; Path to the first .wav file
fileGameStart BYTE "GameStart.wav", 0         ; Path to the second .wav file
fileLifeEnd BYTE "LifeEnd.wav", 0         ; Path to the second .wav file
fileGameOver BYTE "GameOver.wav", 0         ; Path to the second .wav file

SND_FILENAME EQU 20000h        ; Flag to specify that a filename is being used
SND_ASYNC    EQU 0001h         ; Flag to play the sound asynchronously
SND_PURGE    EQU 004h 

Lifedestroysound byte 7,0




PACMAN_ART     db ' ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____ ',13,10
               db '|____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|',13,10
               db '     ____    ____    ____    ____    ____    ____    ____    ____    ____   ____    ____    ____    ____    ____ ',13,10
               db '    |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____| |____|  |____|  |____|  |____|  |____|',13,10
               db ' ____    ____    ____    ____    ____    ____    ____    ____    ____    ____   ____    ____    ____    ____    ____  ',13,10
               db '|____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____| |____|  |____|  |____|  |____|  |____|',13,10
               db '     ____    ____    ____    ____    ____    ____    ____    ____    ____   ____    ____    ____    ____    ____ ',13,10
               db '    |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____|  |____| |____|  |____|  |____|  |____|  |____| ',13,10
               db '                                                                                     ',13,10
               db '                                                                                     ',13,10
               db '                                                                                     ',13,10
               db '                                                                                     ',13,10
               db '                                           ___   ___  ___   ____',13,10               
               db '                                          |   \ |   \  |   /    \ |   /        ',13,10
               db '                                          |___/ |___/  |  |       |__/         ',13,10
               db '                                          |   \ |  \   |  |       |  \         ',13,10
               db '                                          |___/ |   \ _|_  \____/ |   \        ',13,10
               db '                                                                                     ',13,10
               db '                                      ___    ___   ____   __         ____  ___ ',13,10
               db '                                     |   \  |   \ |      /  \ |   / |     |   \       _             ',13,10
               db '                                     |___/  |___/ |__   |____||__/  |__   |___/      (_)                        ',13,10
               db '                                     |   \  |  \  |     |    ||  \  |     |  \                      ',13,10
               db '                                     |___/  |   \ |____ |    ||   \ |____ |   \                      ',13,10
               db '                                                                                      ________________  ',13,10
               db '                                                                                     /________________\',13,10
               db 0
                                                                      
                                                                      
START             DB '                                               ___ ___ ___ ___ ___   ',13,10
                  DB '                                              / __|_ _| . | . |_ _|  ',13,10
                  DB '                                              \__ \| ||   |   /| |   ',13,10
                  DB '                                              <___/|_||_|_|_\_\|_|   ',13,10
                  DB 0   

INSTRUCTIONS    DB '                                     _ _ _ ___ ___ ___ _ _ ___ ___ _ ___ _ _ ___ ',13,10
                DB '                                    | | \ / __|_ _| . | | |  _|_ _| | . | \ / __>',13,10
                DB '                                    | |   \__ \| ||   |   | <__| || | | |   \__ \',13,10
                DB '                                    |_|_\_<___/|_||_\_`___`___/|_||_`___|_\_<___/',13,10
                DB 0
            
EXITED           DB '                                       _  _ _  ___  _  _  ___ ___ ___ ___  ___   ',13,10
                 DB '                                      | || | ||  _|| || |/ __|  _| . | . || __|  ',13,10
                 DB '                                      |    | || <_ |    |\__ \ <__ | |   || _>    ',13,10
                 DB '                                      |_||_|_|`_/|_|_||_|<___/___/___|_\_`|___|   ',13,10
                 DB 0

GameOverMsgart          DB '                                                                        _____                                                 _____                    ',13,10
                 DB '        _____           _____                ___________           _____\    \               ____    _______    ______   _____\    \ ___________       ',13,10
                 DB '   _____\    \_       /      |_             /           \         /    / |    |          ____\_  \__ \      |  |      | /    / |    |\          \      ',13,10
                 DB '  /     /|     |     /         \           /    _   _    \       /    /  /___/|         /     /     \ |     /  /     /|/    /  /___/| \    /\    \     ',13,10
                 DB ' /     / /____/|    |     /\    \         /    //   \\    \     |    |__ |___|/        /     /\      ||\    \  \    |/|    |__ |___|/  |   \_\    |    ',13,10
                 DB '|     | |_____|/    |    |  |    \       /    //     \\    \    |       \             |     |  |     |\ \    \ |    | |       \        |      ___/     ',13,10
                 DB '|     | |_________  |     \/      \     /     \\_____//     \   |     __/ __          |     |  |     | \|     \|    | |     __/ __     |      \  ____  ',13,10
                 DB '|\     \|\        \ |\      /\     \   /       \ ___ /       \  |\    \  /  \         |     | /     /|  |\         /| |\    \  /  \   /     /\ \/    \ ',13,10
                 DB '| \_____\|    |\__/|| \_____\ \_____\ /________/|   |\________\ | \____\/    |        |\     \_____/ |  | \_______/ | | \____\/    | /_____/ |\______| ',13,10
                 DB '| |     /____/| | ||| |     | |     ||        | |   | |        || |    |____/|        | \_____\   | /    \ |     | /  | |    |____/| |     | | |     | ',13,10
                 DB ' \|_____|     |\|_|/ \|_____|\|_____||________|/     \|________| \|____|   | |         \ |    |___|/      \|_____|/    \|____|   | | |_____|/ \|_____| ',13,10
                 DB '        |____/                                                         |___|/           \|____|                              |___|/                    ',13,10
                 DB 0

ARTWORK DB '                                     `$/                             ',13,10
        DB '           __                        O$                              ',13,10
        DB '       _.-"  )                        $''                            ',13,10
        DB '    .-"`. .-":        o      ___     ($o                             ',13,10
        DB ' .-".-  .''   ;      ,st+.  .'' , \    ($                            ',13,10
        DB ':_..-+""    :       T   "^T==^;\\;;-._ $\\                            ',13,10
        DB '   """"-,   ;       ''    /  `-:-// / )$/                            ',13,10
        DB '        :   ;           /   /  :/ / /dP                             ',13,10
        DB '        :   :          /   :    )^-:_.l                             ',13,10
        DB '        ;    ;        /    ;    `.___, \\           .-,              ',13,10
        DB '       :     :       :  /  ;.q$$$$$$b   \\$$$p,    /  ;              ',13,10
        DB '       ;   :  ;      ; :   :$$$$$$$$$b   T$$$$b .''  /              ',13,10
        DB '       ;   ;  :      ;   _.:$$$$$$$$$$    T$$P^"   /l               ',13,10
        DB '       ;.__L_.:   .q$;  :$$$$$$$$$$$$$;_   TP .-" / ;               ',13,10
        DB '       :$$$$$$;.q$$$$$  $$$$$$$$$$$$$$$$b  / /  .'' /                ',13,10
        DB '        $$$$$$$$$$$$$;  $$$$$$$$P^" "^Tb$b/   .''  :                ',13,10
        DB '        :$$$$$$$$$$$$;  $$$$P^jp,      `$$_.+''    ;                ',13,10
        DB '        $$$$$$$$$$$$$;  :$$$.d$$;`- _.-d$$ /     :                 ',13,10
        DB '        ''^T$$$$$P^^"/   :$$$$$$P      d$$;/      ;                 ',13,10
        DB '                   :    $$$$$$P"-. .--$$P/      :                  ',13,10
        DB '                   ;    $$$$P''( ,    d$$:b     .$                  ',13,10
        DB '                   :    :$$P .-dP-''  $^''$$bqqpd$$                 ',13,10
        DB '                    `.   "" '' s"")  .''  d$$$$$$$$''                 ',13,10
        DB '                      \\           /;  :$$$$$$$P''                  ',13,10
        DB '                    _  "-, ;       ''.  T$$$$P''                    ',13,10
        DB '                   / "-.''  :    .--.___.`^^''                      ',13,10
        DB '                  /      . :  .''                                     ',13,10
        DB '                  ),sss.  \\  :  bug                                 ',13,10
        DB '                 : TP""Tb. ; ;                                      ',13,10
        DB '                 ;  Tb  dP   :                                      ',13,10
        DB '                 :   TbdP    ;                                      ',13,10
        DB '                  \\   $P    /                                      ',13,10
        DB '                   `-.___.-''                                       ',13,10
        DB 0


 LEVEL2_ART db ' __    ____  _  _  ____  __      ___  ',13,10
           db '(  )  ( ___)( \/ )( ___)(  )    (__ \ ',13,10
           db ' )(__  )__)  \  /  )__)  )(__    / _/ ',13,10
           db '(____)(____)  \/  (____)(____)  (____)',13,10
           db 0


LEVEL3_ART db '(  )  ( ___)( \/ )( ___)(  )    (__ )',13,10
           db ' )(__  )__)  \  /  )__)  )(__    (_ \',13,10
           db '(____)(____)  \/  (____)(____)  (___/',13,10
           db 0



            
 POINTER            DB'  <<<<<<<<<<<<<<<<   ',13,10
                    DB 0

INSTRUCTIONS_SCREEN             db 'Controls:                                                                                        ',13,10
                               db '                                                                                                 ',13,10
                               db ' 1-Use the Left and Right arrow keys to move the paddle.                                         ',13,10
                               db ' 2-Press the Spacebar to launch the ball.                                                       ',13,10
                               db '                                                                                                 ',13,10
                               db 'Gameplay:                                                                                       ',13,10
                               db '                                                                                                 ',13,10
                               db ' 1-The ball bounces off walls, the paddle, and bricks.                                           ',13,10
                               db ' 2-Break all the bricks to clear the level and progress to the next one.                         ',13,10
                               db ' 3-Avoid letting the ball fall below the paddle, or you will lose a life.                        ',13,10
                               db ' 4-Power-ups may appear from broken bricks, offering bonuses like paddle expansion or extra lives.',13,10
                               db '                                                                                                 ',13,10
                               db 'Scoring:                                                                                        ',13,10
                               db '                                                                                                 ',13,10
                               db ' 1-Each brick broken earns points.                                                              ',13,10
                               db ' 2-Bonus points are awarded for collecting power-ups.                                            ',13,10
                               db ' 3-Higher levels may offer higher point values for bricks.                                       ',13,10
                               db '                                                                                                 ',13,10
                               db 'Game Over:                                                                                      ',13,10
                               db '                                                                                                 ',13,10
                               db ' 1-If you lose all your lives by letting the ball fall, the game ends.                           ',13,10
                               db ' 2-Complete all levels to win the game.                                                         ',13,10
                               db 0

menuSelect db 1
   
.code

PlaySound PROTO,
     pszSound:PTR BYTE, 
     hmod:DWORD, 
     fdwSound:DWORD

;------------------------------
;display leaderboard
;------------------------------
DisplayLeaderboard PROC
    mov ecx, playercount                  ; Number of leaderboard entries (10)
    mov esi, OFFSET leaderboardNames ; Pointer to the first name
    mov edi, OFFSET leaderboardScores ; Pointer to the first score

    mov ebx, 1                   ; Rank counter (1-based index)
    
    ; Display header
    mov edx, OFFSET header
    call WriteString
    call Crlf

DisplayLoop:
    ; Check if we've displayed all entries
    cmp ecx, 0
    jz EndDisplay

    ; Display rank
    mov edx, OFFSET rankText
    call WriteString
    mov eax, ebx                 ; Load rank number
    call WriteDec
    call Crlf

    ; Display name
    mov edx, OFFSET nameText
    call WriteString
    mov edx, esi                 ; Load name pointer
    call WriteString
    call Crlf

    ; Display score
    mov edx, OFFSET scoreText
    call WriteString
    mov eax, [edi]              ; Load score
    call WriteDec
    call Crlf

    ; Display level
    mov edx, OFFSET levelText
    call WriteString
    mov al, [leaderboardLevels+ecx]                ; Load level
    call WriteDec
    call Crlf

    ; Move to the next entry
    add esi, 20                  ; Next name (20 bytes per name)
    add edi, 4                   ; Next score (4 bytes per score)
    dec ecx                      ; Decrease count
    inc ebx                      ; Increase rank
    call Crlf
    jmp DisplayLoop

EndDisplay:
    ret

DisplayLeaderboard ENDP

;---------------------------
; Append score to file 
;---------------------------
appendFile PROC
    call ConvertScoreToString
    ; Open the file for reading
	mov edx, offset filename
	call openinputfile
	mov filehandle, eax
	jc showerror
	mwrite "File Opened"
	mwrite "File Handle:"
	call writeint
	mov eax, filehandle
	call crlf

	; Read the file content into the buffer
	mov eax, filehandle
	mov edx, offset readfile1
	mov ecx, 5000  ; Max bytes to read
	call readfromfile
	jc showreaderror
	mov bytesread, eax
	mwrite "File Read"
	mwrite "Bytes Read:"
	call writeint
	mov eax, bytesread
	call crlf

	; Close the file after reading
	mov eax, filehandle
	call closefile
	mwrite "File Closed After Reading"

	; Prepare content to append: <name>,<score><newLine>
	mov esi, offset readfile1
	add esi, bytesread  ; Start at the end of the read data
	mov edi, esi
	mov esi, offset name1
	mov ecx, lengthof name1
append_name:
	mov al, [esi]
    cmp al,0
    je commaAdd
	mov [edi], al
	inc esi
	inc edi
	jmp append_name
	dec edi
	; Append comma
    commaAdd:
	mov byte ptr [edi], ','
	inc edi

	; Append score
	mov esi, offset scoreString
	mov ecx, lengthof scoreString
append_score:
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	loop append_score
	dec edi
    dec edi
	; Append newline (0ah)
	mov byte ptr [edi], 0dh
	inc edi
	mov byte ptr [edi], 32
	; Reopen the file for writing
	mov edx, offset filename
	call createoutputfile
	mov filehandle, eax
	jc showwriteerror
	mwrite "File Opened for Writing"

	; Write the combined data back to the file
	mov edx, offset readfile1
	sub edi, offset readfile1
	mov ecx, edi  ; Total length to write
	mov eax, filehandle
	call writetofile
	jc showwriteerror
	mwrite "Content Appended"

	; Close the file after appending
closefile1:
	mov eax, filehandle
	call closefile
	mwrite "File Closed"
	jmp exit1

showerror:
	mwrite "Error Opening file"
	jmp exit1

showreaderror:
	mwrite "Error Reading file"
	jmp closefile1

showwriteerror:
	mwrite "Error Writing to file"
	jmp closefile1

exit1:
	ret
appendFile ENDP



ConvertScoreToString PROC
    ; Convert the integer in 'score' to a string and store in ScoreString1
    lea edi, scoreString    ; Load the address of ScoreString1
    mov eax, score           ; Load the score value into EAX
    xor edx, edx             ; Clear EDX for division

    ; Check if the score is a single-digit number
    cmp eax, 9               ; Compare the score with 9
    jbe SingleDigit          ; Jump if less than or equal to 9 (single-digit)

    ; If it's not a single-digit number, perform the conversion for two-digit numbers
    mov ecx, 10              ; Set up divisor for the tens place
    div ecx                  ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'              ; Convert the remainder (units place) to ASCII
    mov [edi+1], dl          ; Store the second digit in buffer

    ; Get the first digit (tens place)
    mov dl, al               ; Move the quotient to DL (tens place)
    add dl, '0'              ; Convert to ASCII
    mov [edi], dl            ; Store the first digit in buffer
    jmp Done                 ; Jump to the end

SingleDigit:
    ; If it's a single-digit number, just convert it directly
    add al, '0'              ; Convert to ASCII
    mov [edi], al            ; Store the single digit in buffer

Done:
    ret
ConvertScoreToString ENDP


clearscreen PROC
    mov ecx, 50
clear_loop:
    mov edx, OFFSET newline
    call WriteString
    loop clear_loop
    ret
clearscreen ENDP


leaderboard PROC
leaderboardloop:
    call clrscr

    ; Initialize leaderboard arrays
    mov ecx, SIZEOF leaderboardNames
    lea edi, leaderboardNames
    xor eax, eax
    rep stosb                       ; Clear names array

    mov ecx, 10
    lea edi, leaderboardScores
    xor eax, eax
    rep stosd                       ; Clear scores array

    ; Open the file for reading
    invoke CreateFile, OFFSET filename, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov filehandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je error_exit

    ; Read file content
    invoke ReadFile, filehandle, OFFSET buffer, SIZEOF buffer, OFFSET bytesread, 0
    cmp bytesread, 0                ; Check if file is empty
    je empty_file

    ; Parse file content into temporary arrays

parse_line:
    inc playercount
    ; Parse name
    mov eax, buffercount
    lea esi, [buffer +eax]                ; Start of file buffer
    lea edi, buffer3                ; Temporary buffer for name
    xor ecx, ecx                    ; Name index
parse_name:
    mov al, [esi]
    inc esi
    inc buffercount
    cmp al, ','                     ; Check for delimiter
    je parse_score
    cmp al, 0Dh                     ; End of line
    je end_of_line
    mov [edi + ecx], al
    inc ecx
    jmp parse_name

parse_score:
    inc buffercount
    mov byte ptr [edi + ecx], 0     ; Null-terminate the name
    mov eax, 0
    lnull:
    inc ecx
    inc eax
    mov byte ptr [edi + ecx], 0     ; Null-terminate the name
    cmp eax, 20
    jne lnull

    lea edi, buffer1                ; Temporary buffer for score
    xor ecx, ecx                    ; Score index
parse_score_loop:
    mov al, [esi]
    inc esi
    inc buffercount
    cmp al, 0Dh                     ; End of line
    je end_of_line
    mov [edi + ecx], al
    inc ecx
    jmp parse_score_loop

end_of_line:
    mov byte ptr [edi + ecx], 0     ; Null-terminate score string
    mov edx, OFFSET buffer1
    call StrToInt
    mov ecx, eax                    ; Parsed score
    mov parsedsc, eax
    ; Check if name already exists in leaderboard
    lea edx, leaderboardNames
    mov edi, offset buffer3
    xor ebx, ebx                    ; Reset index to 0
check_existing:
    cmp ebx, 10                     ; Compare against 10 entries
    jge no_match                    ; If not found, proceed to normal logic
    mov edi, offset buffer3
    lea esi, [edx ]       ; Point to current name in leaderboard
    mov ecx, 20
    repe cmpsb                      ; Compare name with leaderboard entry
    je name_found                   ; If name matches, jump to update logic
    add edx, 20                     ; Move to next name
    inc ebx                         ; Increment index
    jmp check_existing

no_match:
    ; Compare with the 10th entry
    lea edi, leaderboardScores
    mov eax, [edi + 36]             ; 10th score is at offset 36 (4 bytes * 9)
    cmp parsedsc, eax
    jle parse_next_line             ; Skip if score is less than or equal to the 10th entry

    ; Replace the 10th entry
    mov eax, parsedsc
    mov [edi + 36], eax             ; Update score
    lea esi, buffer3
    lea edi, leaderboardNames
    lea edi, [edi + 180]            ; 10th name starts at offset 180
    mov ecx, 20
    rep movsb                       ; Copy name

    ; Sort the leaderboard
    call SortLeaderboard
    jmp parse_next_line

name_found:
    ; Update score if the new score is greater
    lea edi, leaderboardScores
    mov eax, [edi + ebx * 4]        ; Existing score
    cmp parsedsc, eax
    jle parse_next_line             ; If new score is not higher, skip
    mov eax, parsedsc
    mov [edi + ebx * 4], eax        ; Update score
    call SortLeaderboard            ; Sort the leaderboard after update
    jmp parse_next_line

parse_next_line:
    mov eax, buffercount
    lea esi, [buffer + eax]
    cmp byte ptr [esi], 0           ; Check for end of buffer
    jnz parse_line
    ret
empty_file:
    mov edx, OFFSET empty_message
    call WriteString
    call ReadChar
    cmp al, 27
    jne leaderboardloop
    call clearscreen
    invoke CloseHandle, filehandle
    ret

error_exit:
    mov edx, OFFSET error_message
    call WriteString
    invoke ExitProcess, 1
    ret

leaderboard ENDP

SortLeaderboard PROC
    push esi
    push edi
    push ebx
    push ecx

    mov iisort, 0                      ; Outer loop index
sort_outer:
    mov ecx, 9                      ; Compare up to the second-to-last entry
    sub ecx, iisort
    jle done_sorting

    xor ebx, ebx                    ; Inner loop index
sort_inner:
    lea edx, leaderboardScores
    mov eax, [edx + ebx * 4]        ; Current score
    mov edi, [edx + ebx * 4 + 4]    ; Next score
    cmp eax, edi
    jge no_swap                     ; If current >= next, no need to swap

    ; Swap scores
    mov [edx + ebx * 4], edi
    mov [edx + ebx * 4 + 4], eax

    ; Swap names
    lea esi, leaderboardNames
    mov eax, ebx
    imul eax, 20
    lea esi, [esi + eax]
    lea edi, buffer3
    mov ecx, 20
    rep movsb                       ; Copy current name to buffer3

    lea esi, leaderboardNames
    mov eax, ebx

    imul eax, 20
    lea edi, [leaderboardNames + eax]
    mov eax, ebx
    add eax, 1
    imul eax, 20
    lea esi, [esi + eax]
    mov ecx, 20
    rep movsb                       ; Copy next name to current position

    lea esi, buffer3
    mov eax, ebx
    imul eax, 20
    add eax, 20
    lea edi, [leaderboardNames + eax]
    mov ecx, 20
    rep movsb                       ; Copy buffer3 to next name position

no_swap:
    inc ebx
    cmp ebx, ecx
    jl sort_inner

    inc iisort
    jmp sort_outer

done_sorting:
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret
SortLeaderboard ENDP

StrToInt PROC
    xor eax, eax
    xor ebx, ebx
next_digit:
    mov bl, [edx]
    test bl, bl
    je done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc edx
    jmp next_digit
done:
    ret
StrToInt ENDP




;------------------------------
; Draw Ball
;------------------------------
drawball PROC
    mov al, [xball]        ; Load xball into AL
    add al,1
    cmp al, leftBoundary   ; Check left boundary
    jl skipDraw
    cmp al, rightBoundary  ; Check right boundary
    jg skipDraw

    mov al, [yball]        ; Load yball into AL
    cmp al, topBoundary    ; Check top boundary
    jl skipDraw
    cmp al, bottomBoundary ; Check bottom boundary
    jg skipDraw

    mov dl, [xball]        ; Set cursor X position
    mov dh, [yball]        ; Set cursor Y position
    call gotoxy
     mov  eax,yellow+(yellow*16)                     
    call SetTextColor
    mov al, [ball]         ; Load ball character
    call writechar
    mov eax, 7              ; Reset text color: Default (White on Black)
    call SetTextColor
    ret

skipDraw:
    ret
drawball ENDP

;------------------------------
; Draw Second Border
;------------------------------
DrawSecondBorder PROC
    mov  eax, green+(green*16)                  ; Text color: Green (2)
    call SetTextColor

    ; Draw top border
    mov dl, leftBoundary2       ; Start at the left boundary of the second border
    mov dh, topBoundary2        ; Top of the screen for the second border
    call gotoxy
    mov al, '-'                 ; Horizontal border character
    mov cl, rightBoundary2      ; Right boundary of the second border
draw_top2:
    cmp dl, cl                  ; Compare DL with the right boundary
    jg done_top2
    call writechar
    inc dl                      ; Move to the next position
    jmp draw_top2
done_top2:

    ; Draw bottom border
    mov dl, leftBoundary2       ; Start at the left boundary of the second border
    mov dh, bottomBoundary2     ; Bottom of the screen for the second border
    call gotoxy
draw_bottom2:
    cmp dl, cl                  ; Compare DL with the right boundary
    jg done_bottom2
    mov al, '-'                 ; Horizontal border character
    call writechar
    inc dl
    jmp draw_bottom2
done_bottom2:

    ; Draw left border
    mov dl, leftBoundary2       ; Left boundary column for the second border
    mov dh, topBoundary2        ; Start at the top boundary
    mov cl, bottomBoundary2     ; Bottom boundary
draw_left2:
    cmp dh, cl                  ; Compare DH with the bottom boundary
    jg done_left2
    call gotoxy
    mov al, '|'                 ; Vertical border character
    call writechar
    inc dh                      ; Move down
    jmp draw_left2
done_left2:

    ; Draw right border
    mov dl, rightBoundary2      ; Right boundary column for the second border
    mov dh, topBoundary2        ; Start at the top boundary
draw_right2:
    cmp dh, cl                  ; Compare DH with the bottom boundary
    jg done_right2
    call gotoxy
    mov al, '|'                 ; Vertical border character
    call writechar
    inc dh                      ; Move down
    jmp draw_right2
done_right2:
    
    mov eax, 7                  ; Reset text color: Default (White on Black)
    call SetTextColor
    ret
DrawSecondBorder ENDP


;------------------------------
; Update Ball Position
;------------------------------
UpdateBall PROC
    ; Clear previous ball position
    mov dl, [xball]
    mov dh, [yball]
    call gotoxy
    mov al, ' '           ; Clear previous ball position
    call writechar

    ; Update X position
    mov al, [xball]
    add al, [ddx]
    mov bl, [leftBoundary]
    cmp al, bl            ; Prevent moving left of the boundary
    jl boundary_snap_x
    mov bl, [rightBoundary]
    cmp al, bl            ; Prevent moving right of the boundary
    jg boundary_snap_x
    mov [xball], al
    jmp update_y

boundary_snap_x:
    mov [xball], bl       ; Snap to boundary
    neg byte ptr [ddx]    ; Reverse direction

update_y:
    ; Update Y position
    mov al, [yball]
    add al, [ddy]
    mov bl, [topBoundary]
    cmp al, bl            ; Prevent moving above the boundary
    jl boundary_snap_y
    mov bl, [bottomBoundary]
    cmp al, bl            ; Prevent moving below the boundary
    jg boundary_snap_y
    mov [yball], al
    ret

boundary_snap_y:
    mov [yball], bl       ; Snap to boundary
    neg byte ptr [ddy]    ; Reverse direction
    ret
UpdateBall ENDP


;------------------------------
; Check Ball Boundary Collisions
;------------------------------
CheckBallBoundary PROC
    ; Check if the ball hits the paddle
    mov al, [yball]           ; Load Y position of the ball
    mov bl, [yPos]            ; Load Y position of the paddle
    cmp al, bl
    jne check_game_over       ; If not at the paddle's Y, check game over
    
    ; Check if the ball is within the paddle's X range
    mov al, [xball]           ; Ball's X position
    mov bl, [xPos]            ; Paddle's X position (start)
    cmp al, bl
    jl check_game_over        ; Ball is left of the paddle
    add bl, [playerWidth]                ; Paddle's end position (7-char wide paddle)
    cmp al, bl
    jg check_game_over        ; Ball is right of the paddle

    ; Ball hits the paddle, bounce up
    neg byte ptr [ddy]        ; Reverse Y direction
    ret

check_game_over:
    ; Check if the ball falls below the paddle
    mov al, [yball]
    mov bl, [bottomBoundary]  ; Load bottom boundary
    cmp al, bl
    jl check_vertical         ; If above the bottom boundary, check vertical collisions

    ; Ball missed the paddle and fell below
    call GameOver             ; Trigger game over
    ret

check_vertical:
    ; Check collision with top boundary
    mov al, [yball]
    mov bl, [topBoundary]
    add bl, 2
    cmp al, bl
    jg check_horizontal
    neg byte ptr [ddy]        ; Reverse Y direction
    ret

check_horizontal:
    ; Check collision with left and right boundaries
    mov al, [xball]
    mov bl, [leftBoundary]
    add bl, 4
    cmp al, bl
    jg check_right
    neg byte ptr [ddx]        ; Reverse X direction (left wall)
    ret

check_right:
    mov bl, [rightBoundary]
    sub bl, 2
    cmp al, bl
    jl check_brick_collision
    neg byte ptr [ddx]        ; Reverse X direction (right wall)
    ret

check_brick_collision:
    ; Check for collisions with bricks
    ;call CheckBrickCollision
    ret
CheckBallBoundary ENDP


;------------------------------
; Check Brick Collisions
;------------------------------

CheckBrickCollision PROC
    mov ecx,0
    mov esi, offset brickXPos        ; Pointer to brick X positions
    mov edi, offset brickYPos        ; Pointer to brick Y positions
    lea ebx, offset brickHealth      ; Pointer to brick health values
    mov cl, [brickCount]             ; Load the number of bricks to check
    mov edx,0
   
brick_loop:

    cmp cl, 0                        ; Check if all bricks are checked
    je no_collision                  ; Exit if no more bricks

    ; Check if the brick is already destroyed
    lea eax, [brickHealth+ecx-1]     ; Calculate the address of current brick's health
    mov al, byte ptr [eax]
    cmp al, 0                        ; Is health = 0 (destroyed)?
    je next_brick                    ; Skip if the brick is destroyed

    ; Check X collision
    mov al, [esi]                    ; Load X position of the current brick
    mov bl, [xball]                  ; Load ball X position
    cmp bl, al                       ; Is the ball left of the brick?
    jl next_brick                    ; Skip if yes
    add al, [brickWidth]             ; Calculate right edge of the brick
    cmp bl, al
    jge next_brick                   ; Skip if the ball is right of the brick

    ; Check Y collision
    mov al, [edi]                    ; Load Y position of the current brick
    mov bl, [yball]                  ; Load ball Y position
    cmp bl, al                       ; Is the ball above the brick?
    jl next_brick                    ; Skip if yes
    add al, 1                        ; Calculate bottom edge of the brick
    cmp bl, al
    jg next_brick                    ; Skip if the ball is below the brick

    ; Collision detected
    lea eax, [brickHealth+ecx-1]     ; Calculate the address of current brick's health
    mov al, byte ptr [eax]
    cmp [healthStage],4
    jne Simple
    cmp cl, SpecialBrick
    jne Simple
    mov al,1


Simple:
    dec al                           ; Reduce brick's health
    mov [brickHealth+ecx-1] , al
    cmp al, 0                        ; If health is 0, brick is destroyed
    jg bounce_ball                   ; Ball should always bounce, regardless of health

    ; Clear the brick visually (if health reaches 0)
   
    mov dl, [esi]                    ; X position of the current brick
    mov dh, [edi]                    ; Y position of the current brick
    call gotoxy                      ; Move cursor to brick position
    mov ch, [brickWidth]             ; Brick width to clear
clear_loop:
    mov al, ' '                      ; Clear brick with space
    call writechar
    inc dl                           ; Move to next position
    dec ch
    cmp ch, 0
    jg clear_loop
    ;mov byte ptr [esi], 0            ; Set X position to 0 (indicates destroyed)
    ;mov byte ptr [edi], 0            ; Set Y position to 0
    inc DWORD ptr [score]            ; Update score for destroyed brick
    
    cmp [healthStage],4
    jne bounce_ball
    cmp cl, SpecialBrick             ; Is this the special brick?
    je DestroyAdjacentBricks               
    
bounce_ball:
    ; Reverse ball's Y direction
   
    neg byte ptr [ddy]
    ;call DrawBricks           ; Draw the bricks

skip_bounce:
    ; Advance to the next brick
    inc esi                          ; Move to the next X position
    inc edi                          ; Move to the next Y position
    dec cl                           ; Decrease bricks left to check
    jmp brick_loop

next_brick:
    ; Move to the next brick
    inc esi
    inc edi
    dec cl
    jmp brick_loop

no_collision:
    call DrawBricks           ; Draw the bricks
    ret
CheckBrickCollision ENDP


;------------------------------
; Destroy Special Bricks
;------------------------------
DestroyAdjacentBricks PROC
    mov ecx, 0                       ; Reset loop counter
    mov esi, offset brickXPos        ; Pointer to brick X positions
    mov edi, offset brickYPos        ; Pointer to brick Y positions
    mov ebx, offset brickHealth      ; Pointer to brick health values
    mov cl, [brickCount]             ; Number of bricks to check
    mov bl, 5                        ; Max bricks to destroy
    mov dl, 0                        ; Count of destroyed bricks

brick_check:
    cmp cl, 0                        ; Check if all bricks are checked
    je done_destroy                  ; Exit if no more bricks

    lea eax, [brickHealth+ecx-1]     ; Calculate the address of current brick's health
    mov al, byte ptr [eax]
    cmp al, 0                        ; Skip if brick is already destroyed
    je next_brick

    ; Destroy the brick
    mov al,0
    mov [brickHealth+ecx-1], al            ; Set health to 0
    inc dl                           ; Increment destroyed brick count
    inc DWORD ptr [score]            ; Update score for each destroyed brick

    ; Clear the brick visually
    push edx
    mov dl, [esi]                    ; Load X position of the brick
    mov dh, [edi]                    ; Load Y position of the brick
    call gotoxy                      ; Move cursor to brick position
    mov dh, [brickWidth]             ; Load brick width
clear_loop:
    mov al, ' '                      ; Write space to clear the brick
    call writechar
    inc dl                           ; Move to the next position
    dec dh
    cmp dh, 0
    jg clear_loop
    pop edx
    dec bl                           ; Decrease remaining bricks to destroy
    cmp bl, 0                        ; Check if 5 bricks are destroyed
    je done_destroy

next_brick:
    ; Move to the next brick
    inc esi                          ; Advance X position pointer
    inc edi                          ; Advance Y position pointer
                             ; Advance health pointer
    dec cl                           ; Decrease bricks left to check
    jmp brick_check

done_destroy:
    add [timeInSeconds],30
    ret
DestroyAdjacentBricks ENDP





;------------------------------
; Draw Bricks
;------------------------------
DrawBricks PROC
    mov esi, offset brickXPos        ; Pointer to brick X positions
    mov edi, offset brickYPos        ; Pointer to brick Y positions
    mov ebx, offset brickHealth      ; Pointer to brick health values
    mov cl, [brickCount]             ; Load the number of bricks

brick_loop:
    cmp cl, 0                        ; Check if we've checked all bricks
    je done
    
    cmp byte ptr [esi], 0            ; Check if the brick's X position is 0
    je skip_brick                    ; Skip this brick if it is destroyed
    lea eax, [brickHealth + ecx - 1] ; Calculate the address of current brick's health
    mov al, byte ptr [eax]
    cmp al, 0                        ; Check if the brick's health is 0 (destroyed)
    je skip_brick                    ; Skip this brick if it is destroyed

    ; Check if this brick is the special brick
    mov al, cl                       ; Load current brick index into AL
    cmp al, SpecialBrick             ; Compare with SpecialBrick value
    jne check_health                 ; If not the special brick, skip to health checks

    ; If it is the special brick, check if healthStage is 4
    cmp [healthStage], 4             ; Is healthStage 4?
    je set_white                     ; If true, draw in white
    jmp check_health                 ; Otherwise, continue with health-based checks

check_health:
    ; Check the brick's health to determine color
    lea eax, [brickHealth + ecx - 1] ; Calculate the address of current brick's health
    mov al, byte ptr [eax]           ; Load the health value of the brick
    cmp al, 5                        ; If health is >= 5, color it magenta
    jge set_magenta
    cmp al, 3                        ; If health is 3, color it red
    je set_red
    cmp al, 2                        ; If health is 2, color it green
    je set_green
    cmp al, 1                        ; If health is 1, color it blue
    je set_blue
    jmp draw_brick                   ; Skip to drawing the brick

set_magenta:
    mov eax, magenta + (magenta * 16) ; Text color: Magenta (5)
    call SetTextColor
    jmp draw_brick
set_red:
    mov eax, red + (red * 16)         ; Text color: Red (4)
    call SetTextColor
    jmp draw_brick
set_green:
    mov eax, green + (green * 16)     ; Text color: Green (2)
    call SetTextColor
    jmp draw_brick
set_blue:
    mov eax, blue + (blue * 16)       ; Text color: Blue (1)
    call SetTextColor
    jmp draw_brick
set_white:
    mov eax, white + (white * 16)     ; Text color: White (15)
    call SetTextColor
    jmp draw_brick
draw_brick:
    ; Draw the brick
    mov dl, [esi]                    ; Load X position of the brick
    mov dh, [edi]                    ; Load Y position of the brick
    call gotoxy                      ; Move cursor to the brick's position
    lea edx, brickString             ; Load the address of the brick string
    call writestring                 ; Draw the brick

    ; Reset color after drawing the brick
    mov eax, 7                       ; Reset text color: Default (White on Black)
    call SetTextColor

skip_brick:
    inc esi                          ; Move to the next brick X position
    inc edi                          ; Move to the next brick Y position
    inc ebx                          ; Move to the next brick health value
    dec cl                           ; Decrease the number of bricks to check
    jmp brick_loop                   ; Continue checking other bricks

done:
    ret
DrawBricks ENDP







;------------------------------
; Update Player Position
;------------------------------
UpdatePlayer PROC
    ; Clear the previous player position
    mov dl, [xPos]          ; Load X position into DL
    mov dh, [yPos]          ; Load Y position into DH
    call gotoxy             ; Move cursor to the start of the player
    mov cl, [playerWidth]               ; Set width to clear
clear_loop:
    mov al, ' '             ; Space to clear the previous player
    call writechar
    inc dl                  ; Move to the next position
    dec cl
    cmp cl,0
    jge clear_loop
    ret
UpdatePlayer ENDP


;------------------------------
; Draw Player
;------------------------------

DrawPlayer PROC
    mov dl, [xPos]          ; Load X position into DL
    mov dh, [yPos]          ; Load Y position into DH
    mov  eax,lightMagenta+(lightMagenta*16)                      ; Text color: Red (4)
    call SetTextColor
    call gotoxy             ; Move cursor to the player's position
    lea edx, PlayerString   ; Load the address of PlayerString into EDX
    call writestring        ; Write the string to the screen
    mov eax, 7              ; Reset text color: Default (White on Black)
    call SetTextColor
    ret
DrawPlayer ENDP

;------------------------------
; Handle Input
;------------------------------
HandleInput PROC
    call readkey             ; Read a keypress
    jz NoInput               ; If no key pressed, skip handling
    mov inputChar, al        ; Store the input character

     ; Handle movement keys
    cmp inputChar, 'w'       ; Check if the input is 'w' (move up)
    je MoveUp
    cmp inputChar, 'W'       ; Check if the input is 'W' (move up)
    je MoveUp
    cmp inputChar, 's'       ; Check if the input is 's' (move down)
    je MoveDown
    cmp inputChar, 'S'       ; Check if the input is 'S' (move down)
    je MoveDown
    cmp inputChar, 'a'       ; Check if the input is 'a' (move left)
    je MoveLeft
    cmp inputChar, 'A'       ; Check if the input is 'A' (move left)
    je MoveLeft
    cmp inputChar, 'd'       ; Check if the input is 'd' (move right)
    je MoveRight
    cmp inputChar, 'D'       ; Check if the input is 'D' (move right)
    je MoveRight
    ; Handle pause key
    cmp inputChar, 'p'       ; Check if the input is 'p' (pause)
    je TogglePause
    cmp inputChar, 'P'       ; Check if the input is 'P' (pause)
    je TogglePause

NoInput:
    ret

TogglePause:
    cmp isPaused, 0          ; Check if the game is currently running
    jne ResumeGame           ; If already paused, resume the game

    ; Pause the game
    mov isPaused, 1          ; Set isPaused to 1
PauseLoop:
    call readkey             ; Wait for a keypress
    cmp al, 'p'              ; Check if the key is 'p' to unpause
    je ResumeGame
    cmp al, 'P'              ; Check if the key is 'P' to unpause
    je ResumeGame
    jmp PauseLoop            ; Keep waiting for 'P' or 'p'

ResumeGame:
    mov isPaused, 0          ; Set isPaused to 0
    ret
HandleInput ENDP



;==============================
; Move Up
;==============================
MoveUp PROC
    mov al, [yPos]          ; Load current Y position into AL
    sub al,3
    cmp al, [topBoundary]   ; Compare with top boundary
    ;sub al,1
    jle skip                ; If Y position <= topBoundary, skip movement
    ;add al,1
    call UpdatePlayer       ; Update (clear) current position
    sub [yPos] ,3             ; Decrement Y position (move up)
    call DrawPlayer         ; Draw player at new position
skip:
    ret
MoveUp ENDP

;==============================
; Move Down
;==============================
MoveDown PROC
    mov al, [yPos]          ; Load current Y position into AL
    add al,3
    cmp al, [bottomBoundary]; Compare with bottom boundary
    ;sub al,1                 
    jg skip                ; If Y position >= bottomBoundary, skip movement
    ;add al,1
    call UpdatePlayer       ; Update (clear) current position
    add [yPos],3              ; Increment Y position (move down)
    call DrawPlayer         ; Draw player at new position
skip:
    ret
MoveDown ENDP


;==============================
; Move Left
;==============================
MoveLeft PROC
    mov al, [xPos]           ; Load current x position into AL
    sub al,3
    cmp al, leftBoundary     ; Compare AL with leftBoundary
    jle skip                  ; If AL <= leftBoundary, skip movement
    call UpdatePlayer         ; Clear previous player position
    sub [xPos] ,3               ; Move left (decrease xPos)
    call DrawPlayer           ; Draw player at the new position
skip:
    ret
MoveLeft ENDP

;==============================
; Move Right
;==============================
MoveRight PROC
    mov al, [xPos]           ; Load current x position into AL
    add al,8
    cmp al, rightBoundary    ; Compare AL with rightBoundary
    jge skip                  ; If AL >= rightBoundary, skip movement
    
    call UpdatePlayer         ; Clear previous player position
    add [xPos],3               ; Move right (increase xPos)
    call DrawPlayer           ; Draw player at the new position
skip:
    ret
MoveRight ENDP






;------------------------------
; Draw Borders
;------------------------------

DrawBorders PROC
    mov  eax,cyan+(cyan*16)                      ; Text color: Red (4)
    call SetTextColor
    ; Draw top border
    mov dl, leftBoundary      ; Start at the left boundary
    mov dh, topBoundary       ; Top of the screen
    sub dh,3
    call gotoxy
    mov al, '-'               ; Horizontal border character
    mov cl, rightBoundary     ; Width of the screen
    sub dl,3
draw_top:
    cmp dl, cl                ; Compare DL with rightBoundary
    jg done_top
    call writechar
    inc dl                    ; Move to the next position
    jmp draw_top
done_top:

    ; Draw bottom border
    mov dl, leftBoundary      ; Start at the left boundary
    mov dh, bottomBoundary    ; Bottom of the screen
    call gotoxy
draw_bottom:
    cmp dl, cl                ; Compare DL with rightBoundary
    jg done_bottom
    mov al, '-'               ; Horizontal border character
    call writechar
    inc dl
    jmp draw_bottom
done_bottom:

    ; Draw left border
    mov dl, leftBoundary      ; Left boundary column
    sub dl,1
    mov dh, topBoundary       ; Start at the top boundary
    sub dh ,3
    mov cl, bottomBoundary    ; Height of the screen
draw_left:
    cmp dh, cl                ; Compare DH with bottomBoundary
    jg done_left
    call gotoxy
    mov al, '|'               ; Vertical border character
    call writechar
    inc dh                    ; Move down
    jmp draw_left
done_left:

    ; Draw right border
    mov dl, rightBoundary     ; Right boundary column
    add dl,2
    mov dh, topBoundary       ; Start at the top boundary
    sub dh,3
draw_right:
    cmp dh, cl                ; Compare DH with bottomBoundary
    jg done_right
    call gotoxy
    mov al, '|'               ; Vertical border character
    call writechar
    inc dh                    ; Move down
    jmp draw_right
done_right:
     mov eax, 7                       ; Reset text color: Default (White on Black)
    call SetTextColor
    ret
DrawBorders ENDP






;------------------------------
; Game over 
;------------------------------
GameOver PROC
    ; Decrement the player lives
    mov al, [playerLives]   ; Load the current number of lives into AL
    dec al                  ; Decrease the lives by 1
    ;lea edx,Lifedestroysound
    ;call writestring
    mov [playerLives], al   ; Store the new lives value
    
    ; Check if lives are 0 or less
    cmp al, 0
    jle endgame             ; If lives are 0 or less, go to endgame
    INVOKE PlaySound, NULL, NULL, SND_PURGE
    INVOKE PlaySound, OFFSET fileLifeEnd, NULL, SND_FILENAME
    INVOKE PlaySound, NULL, NULL, SND_PURGE
     INVOKE PlaySound, OFFSET fileGameStart, NULL, SND_FILENAME OR SND_ASYNC
    ; Continue the game if there are lives left
    jmp continue

endgame:
    call appendFile
    ; Display the "Game Over" message box
    call ClrScr
    mov dl ,60
    mov dh,0
    call gotoxy
    mov edx,offset ARTWORK
    call writestring
    INVOKE PlaySound, NULL, NULL, SND_PURGE
    INVOKE PlaySound, OFFSET fileGameOver, NULL, SND_FILENAME
    INVOKE PlaySound, NULL, NULL, SND_PURGE
    call DisplayMessageBox
    ; You can either exit the game or reset the game state here.
    ; For example, call ResetGame or use a game loop to restart
    exit                     ; Exit the game (or reset game variables)
    ; Or for a restart you might want something like:
    ; call ResetGame           ; Call a reset function to restart the game

continue:
;(if lives > 0)
    call DisplayLife
    mov al, [xPos]  ; Center X
    add al,5
    mov [xball], al
    mov al,[yPos] ; Center Y
    sub al,4
    mov [yball], al
    mov byte ptr [ddx], -1  ; Set initial X direction
    mov byte ptr [ddy], 1   ; Set initial Y direction
    
    
    ret
GameOver ENDP




;------------------------------
; Display Message Box (Game Over, etc.)
;------------------------------
DisplayMessageBox PROC
    ; Clear the screen
    call ClrScr
    
    ; Display the message at a specific location
    mov dl, 30                ; Set X position (center of the screen)
    mov dh, 12                ; Set Y position (center of the screen)
    call gotoxy

        ; Load the address of the message
     mov ebx, OFFSET    GameOverMsg   ; Set the title of the message box
    mov edx, OFFSET GameOverMsg    ; Set the question to be asked
    call MsgBox
    ; Wait for key press to continue
    call readkey
    ret
DisplayMessageBox ENDP


;------------------------------
; Draw  score
;------------------------------
DrawScore PROC
    ; Load X and Y coordinates for the score
    mov dl, [scoreX]         ; Load X position of the score
    mov dh, [scoreY]         ; Load Y position of the score

    ; Move cursor to the score's position
    call gotoxy

    ; Load the score message and display it
    lea edx, ScoreMsg        ; Load the score message prefix into EDX
    call writestring         ; Write "Score: " message

    ; Load the current score and display it
    mov eax, [score]         ; Load current score into EAX
    mov edx, eax             ; Copy the score into EDX for writing
    call writeint            ; Write the score value

    ret
DrawScore ENDP
    
;------------------------------
; Display Player Name
;------------------------------
DisplayPlayerName PROC
    mov dl,[rightBoundary]
    add dl,6
    mov dh,7
    call gotoxy
    
    lea edx, name1   ; Load the score message prefix into EDX
    call writestring     ; Write "Hamas"
    
    ret
DisplayPlayerName ENDP

;------------------------------
; Initialize Player Name
;------------------------------
InitializePlayerName PROC
    ; Prompt the user for their name
    lea edx, namePrompt
    call writestring         ; Display "Enter your name: "
    lea edx, name1      ; Load the address of the playerName variable
    mov ecx, 20              ; Set the maximum number of characters to read
    call readstring          ; Read the user's input into name1
    
    ret
InitializePlayerName ENDP


;------------------------------
; Display Life
;------------------------------
DisplayLife PROC
    ; Load X and Y coordinates for the life display
    mov dl, [lifeX]            ; Load X position for life display
    mov dh, [lifeY]            ; Load Y position for life display

    ; Move cursor to the life display's position
    call gotoxy

    ; Clear the previous life display (overwrite with spaces)
    mov cx, 6                  ; Maximum number of lives to clear
ClearLifeLoop:
    mov al, ' '                ; Space character
    call writechar             ; Overwrite with a space
    dec cx
    cmp cx,0
    jge ClearLifeLoop

    ; Move back to the start position for drawing lives
    mov dl, [lifeX]            ; Load X position again for life display
    mov dh, [lifeY]            ; Load Y position again for life display
    call gotoxy
    mov ecx,0
    ; Display lives as $ symbol
    mov al, playerLives        ; Load the number of lives into AL
    mov cl, al                 ; Copy the number of lives to CX for the loop
DisplayLifeLoop:
    lea edx, [lifeSymbol]       ; Load the address of the life symbol ("$")
    call writestring           ; Display the symbol
    loop DisplayLifeLoop       ; Repeat for the number of lives

    ret
DisplayLife ENDP

;------------------------------
; Display Time
;------------------------------
DisplayTime PROC
    ; Position cursor at (xPos, yPos)
    mov dl, xPostime              ; Load X position
    mov dh, yPostime              ; Load Y position
    call gotoxy               ; Move cursor to (xPos, yPos)

    ; Display the time using writeint
    mov eax, timeInSeconds    ; Load the time value into EAX
    call writedec             ; Display the integer value on the screen
    dec eax
    mov timeInSeconds,eax
    mov al,[resetCount]
    mov countdown, al
    ret
DisplayTime ENDP

UpdateCountdown PROC
    ; Check if timeInSeconds is zero
    mov eax, timeInSeconds    ; Load the time into EAX
    cmp eax, 0                ; Check if timeInSeconds is zero
    je CallGameOver           ; If zero, jump to GameOver

    ; Decrease countdown value
    dec countdown             ; Decrement the countdown variable
    cmp countdown, 0          ; Check if it has reached zero
    jne EndUpdate             ; If not zero, skip the reset and display

    ; Call DisplayTime when countdown reaches zero
    call DisplayTime          ; Display the time on the screen

    ; Reset countdown to resetCount value
    mov al, resetCount        ; Load resetCount value into AL
    mov countdown, al         ; Reset the countdown

    ; Decrement timeInSeconds
    dec timeInSeconds         ; Reduce total time by 1 second

EndUpdate:
    ret

CallGameOver:
    call GameOver             ; Call GameOver procedure
    ret

UpdateCountdown ENDP

;------------------------------
; Game Loop
;------------------------------
GameLoop PROC
    ; Continuously update ball position and check for collisions
gameloop3:
    call UpdateCountdown
    call UpdateBall             ; Update ball position
    call CheckBallBoundary      ; Check for boundary collisions
    call DrawBall               ; Draw the ball at the new position

    ; Check if the ball's Y-axis matches a brick row
    mov al, [yball]             ; Load ball Y position
    cmp al, 3
    je check_collision          ; If Y position is 3, check collisions
    cmp al, 5
    je check_collision          ; If Y position is 5, check collisions
    cmp al, 7
    je check_collision          ; If Y position is 7, check collisions
    jmp skip_collision          ; Otherwise, skip collision checking

check_collision:
    mov al,[xpos]
    mov bl,[ypos]
    push eax
    push ebx
    call CheckBrickCollision    ; Check collisions with bricks
    pop ebx
    mov [ypos],bl
    pop eax
    mov [xpos],al
    call CheckBrickHealth

skip_collision:
    ; Handle player input (so the player can move)

    call HandleInput

    ; Redraw the player
    call DrawPlayer             ; Draw player at current position

    ; Draw score
    call DrawScore              ; Display the score
    
    ; Add a delay
    movzx eax, [delayvalue]
    call Delay

    done:
    ; Keep looping the game process

    jmp gameloop3               ; Continue looping
    ret
GameLoop ENDP

;------------------------------
; Brick health Initialization
;------------------------------

ReinitializeBricks PROC
    ; Load the number of bricks
    mov ecx,0
    mov cl, brickCount
    

    ; Load healthStage
    mov al, healthStage


    ; Main loop
ReinitLoop:
    ; Set the health for the current brick
    mov [brickHealth + ecx-1], al

   

    ; Decrement the counter
    dec cl
    jnz ReinitLoop      ; Repeat for all bricks

    ; Increment healthStage for the next call
    inc healthStage
    
SkipReset:

    ret
ReinitializeBricks ENDP 

;------------------------------
; Brick Position Initialization
;------------------------------

ResetBricks PROC
    ; Load the brick count
    mov ecx,0
    mov al, brickCount
    mov cl, al          ; Store brickCount in cl for looping


ResetLoop:
    ; Reset X position
    mov al, [initialXPos + ecx-1]
    mov [brickXPos + ecx-1], al

    ; Reset Y position
    mov al, [initialYPos +ecx-1]
    mov [brickYPos + ecx-1], al

    

    ; Decrement counter and loop
    dec cl
    jnz ResetLoop

    ret
ResetBricks ENDP
;------------------------------
; Check Brick health
;------------------------------

CheckBrickHealth PROC
    ; Load the brick count
    mov ecx,0
    mov al, brickCount       ; Load number of bricks
    mov cl, al               ; Copy to CL for looping
    mov edi ,offset brickHealth
   

HealthCheckLoop:
    ; Check if the current brick's health is zero
    mov al, [edi]
    cmp al, 0
    jne ContinueGame         ; If non-zero health, continue the game


    ; Decrement counter
    inc edi
    dec cl
    jnz HealthCheckLoop      ; Repeat for remaining bricks

    ; If all bricks have zero health, exit game loop
    jmp ExitGame

ContinueGame:
    ; If any brick is not zero, continue the game loop
    ret

ExitGame:
    call ReinitializeBricks ;set the brick health for the next stage 
    INVOKE PlaySound, NULL, NULL, SND_PURGE
    INVOKE PlaySound, OFFSET fileLevelComplete, NULL, SND_FILENAME
    INVOKE PlaySound, NULL, NULL, SND_PURGE
    INVOKE PlaySound, OFFSET fileGameStart, NULL, SND_FILENAME OR SND_ASYNC
    cmp [healthStage],3
    je level2
    jmp Level3

level2:
    call Level2 
    ret
CheckBrickHealth ENDP




;------------------------------
; Level 2 
;------------------------------


Level2 proc
    call clrscr
    mov eax,blue
    call settextcolor
    mov dl,0
    mov dh,10
    call gotoxy
    mov edx,offset LEVEL2_ART
    call writestring
    call gotoxy
    call waitmsg
   
    mov eax,7
    call gotoxy
    call clrscr



        mov al, 100                ; Load the new delay value into AL
        mov delayValue, al         ; Update delayValue to 120
        call Clrscr
        mov playerWidth, 5          ; Set the player width to 5 for Level 2
        lea esi, PlayerString        ; Load the address of PlayerString into SI
        mov cl, playerWidth         ; Set CX to the new player width

            ; Modify PlayerString dynamically using the pointer (SI)
    TruncatePlayerString:
        cmp cl, 0               ; Check if CX is 0 (all characters updated)
        je NullTerminate        ; If finished, null-terminate the string
        mov byte ptr [esi], '-'  ; Update the current character to '-'
        inc esi                  ; Move to the next character
        dec cl                  ; Decrement the width counter
        jmp TruncatePlayerString

    NullTerminate:
        mov byte ptr [esi], 0    ; Null-terminate the string

       call DrawBorders          ; Draw the borders first
       call DrawSecondBorder
       call DisplayLife
       call DrawBricks           ; Draw the bricks
       call DrawPlayer           ; Draw the player
       call DisplayPlayerName
       call GameLoop             ; Start the game loop

Level2 Endp



;------------------------------
; Level 3 
;------------------------------


Level3 proc

call clrscr
    mov eax,blue
    call settextcolor
    mov dl,0
    mov dh,10
    call gotoxy
    mov edx,offset LEVEL3_ART
    call writestring
    call gotoxy
    call waitmsg
   
    mov eax,7
    call gotoxy
    call clrscr
       call Clrscr
        mov al, 90                ; Load the new delay value into AL
        mov delayValue, al         ; Update delayValue to 120
        call Clrscr
        mov playerWidth, 3          ; Set the player width to 5 for Level 2
        lea esi, PlayerString        ; Load the address of PlayerString into SI
        mov cl, playerWidth         ; Set CX to the new player width

            ; Modify PlayerString dynamically using the pointer (SI)
    TruncatePlayerString:
        cmp cl, 0               ; Check if CX is 0 (all characters updated)
        je NullTerminate        ; If finished, null-terminate the string
        mov byte ptr [esi], '-'  ; Update the current character to '-'
        inc esi                  ; Move to the next character
        dec cl                  ; Decrement the width counter
        jmp TruncatePlayerString

    NullTerminate:
        mov byte ptr [esi], 0    ; Null-terminate the string


        ;this will randomly generate a solid block
       mov  eax,5     ;get random 0 to 21
       call Randomize
       call RandomRange ;
       add eax,10
       mov [brickHealth+eax],30

       ;Randomly SpecialBrick

       mov  eax,5    ;get random 0 to 99
       call Randomize
       call RandomRange ;
       mov SpecialBrick,al
       

       call DrawBorders          ; Draw the borders first
       call DrawSecondBorder
       call DisplayLife
       call DrawBricks           ; Draw the bricks
       call DrawPlayer           ; Draw the player
       call DisplayPlayerName
       call GameLoop             ; Start the game loop
       
Level3 Endp




GetRANDOM PROC
       mov  eax,100     ;get random 0 to 99
       call RandomRange ;
       inc  eax         ;make range 1 to 100
       mov  ranNum,al  ;save random number


ret
GetRANDOM endp


;------------------------------
; instruction menu
;------------------------------
instructionmenu PROC
    mov dl,0 
    mov dh,0
    call gotoxy
    mov edx,offset INSTRUCTIONS_SCREEN
    call writestring
    call readchar
    call clrscr
    cmp al,27
    je exitfunc1
    call instructionmenu
    exitfunc1:
    ret
instructionmenu ENDP



;------------------------------
; highscore menu
;------------------------------
highscoremenu PROC
    call leaderboard
    disploop:
    mov dl,0 
    mov dh,0
    call gotoxy
    call DisplayLeaderboard
    call readchar
    call clrscr
    cmp al,27
    je exitfunc1
    jmp disploop
    exitfunc1:
    ret
highscoremenu ENDP


;------------------------------
; Main Menu
;------------------------------
mainmenu PROC
;MAIN SCREEN
    mov dl,0
    mov dh,0
    ;mov eax,offset PACMAN_ART
    
    call gotoxy
    mov eax,blue
    call settextcolor
    mov edx,offset PACMAN_ART
    call writestring
    call waitmsg
    mov  eax,7                     ; Text color: Red (4)
    call SetTextColor
    call clrscr


    
    call InitializePlayerName
    call clrscr

     ;START MENU
    point1:
        mov dl,70
        mov dh,3
        call gotoxy
        mov edx,offset POINTER
        call writestring
        mov menuSelect,1
    jmp start_tab

    point2:
        mov dl,80
        mov dh,12
        call gotoxy
        mov edx,offset POINTER
        call writestring
        mov menuSelect,2
    jmp start_tab

    point3:
        mov dl,70
        mov dh,22
        call gotoxy
        mov edx,offset POINTER
        call writestring
        mov menuSelect,3
    jmp start_tab


    start_tab:
    mov dl,0
    mov dh,1
    call gotoxy
    mov eax,red
    call settextcolor
    mov edx,offset START
    call writestring

    mov dl,0
    mov dh,10
    call gotoxy
    mov eax,blue
    call settextcolor
    mov edx,offset INSTRUCTIONS
    call writestring

    mov dl,0
    mov dh,20
    call gotoxy
    mov eax,green
    call settextcolor
    mov edx,offset EXITED
    call writestring
    
    mov eax,7
    call settextcolor
    call readchar
    call clrscr
    cmp al,'1'
    je point1
    cmp al,'2'
    je point2
    cmp al,'3'
    je point3
    cmp al,13
    je selection


    selection:
    cmp menuSelect,1
    je exitfunc
    
    cmp menuSelect,2
    je instructionselected
    

    cmp menuSelect,3
    je highscoreselected

    instructionselected:
    call instructionmenu
    jmp point2
    je exitfunc
    
    highscoreselected:
    call highscoremenu
    jmp point2
    je exitfunc

    exitfunc:
    mov eax,7
    call settextcolor
    ret
mainmenu ENDP



;------------------------------
; Main
;------------------------------
main PROC
    
    call clearscreen
      ;call DrawSecondBorder
    call mainmenu
    call Clrscr
    ;call InitializePlayerName
  ;  call Clrscr

    ;Level 1
    
     
    call DrawBorders          ; Draw the borders first
    call DrawSecondBorder
    call DisplayLife
    call DrawBricks           ; Draw the bricks
    call DrawPlayer           ; Draw the player
    call DisplayPlayerName
    INVOKE PlaySound, OFFSET fileGameStart, NULL, SND_FILENAME OR SND_ASYNC
    call GameLoop             ; Start the game loop
    
   ;call ReinitializeBricks
    ;call ResetBricks
    ret
    
    
main endp
end main