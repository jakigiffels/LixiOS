BITS 16
org 0x7C00

start:
    ; Setzen des Segmentregisters
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ; Stack initialisieren
    mov ss, ax
    mov sp, 0x7C00

    ; "LixiOS booted!" auf den Bildschirm schreiben
    mov si, msg
    call print_string

    ; Endlosschleife
    jmp $

print_string:
    lodsb           ; Lade das nächste Zeichen aus SI in AL
    or al, al        ; Ist es das Ende (Null-Terminator)?
    jz done          ; Wenn ja, fertig
    mov ah, 0x0E    ; BIOS-Funktion: Zeichen ausgeben
    int 0x10        ; BIOS-Interrupt aufrufen
    jmp print_string

done:
    ret

msg db "LixiOS booted! Press Ctrl+C to exit QEMU.", 0

; Bootsektor-Signatur
times 510-($-$$) db 0
 dw 0xAA55