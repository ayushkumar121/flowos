extern _start

[bits 32]
section .text
    start:
    setup_paging:
        ; Point the first entry of the level 4 page table to the first entry in the
        ; p3 table

        mov eax, p3_table
        or eax, 0b11 ;; Adding Present & Writable flag
        mov dword [p4_table + 0], eax
        ; Point the first entry of the level 3 page table to the first entry in the
        ; p2 table

        mov eax, p2_table
        or eax, 0b11 ;; Adding Present & Writable flag
        mov dword [p3_table + 0], eax
        
        mov ecx, 0 ;; Counter
    map_p2_table:         ;; Point each page table level two entry to a page
        mov eax, 0x200000  ; 2MiB
        mul ecx
        or eax, 0b10000011 ; Adding Present & Writable flag as  well as huge page flag
        mov [p2_table + ecx * 8], eax
        inc ecx
        cmp ecx, 512   ;; Mapping first 1GiB
        jne map_p2_table

        ; Pointing p4_table to cr3
        mov eax, p4_table
        mov cr3, eax
        
        ; Enable Physical Address Extension
        mov eax, cr4
        or eax, 1 << 5
        mov cr4, eax
    
    long_mode_enable:
        ; Set the long mode bit
        mov ecx, 0xC0000080
        rdmsr
        or eax, 1 << 8
        wrmsr

        ; enable paging
        mov eax, cr0
        or eax, 1 << 31
        or eax, 1 << 16
        mov cr0, eax

        lgdt [gdt64.pointer]

        ; update selectors
        mov ax, gdt64.data
        mov ss, ax
        mov ds, ax
        mov es, ax

        ; jump to long mode!
        jmp gdt64.code:long_mode_start   

        jmp $

[bits 64]
section .text
    long_mode_start:
        cli                           ; Clear the interrupt flag.
        mov ax, gdt64.data
        mov ss, ax
        mov ds, ax
        mov es, ax
     	mov ds, ax
	    mov fs, ax
	    mov gs, ax

	    mov esp, stack_end

        call _start
        jmp $


section .rodata
gdt64: ;; 64 bit GDT
    dq 0
.code: equ $ - gdt64
    dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53)
.data: equ $ - gdt64
    dq (1<<44) | (1<<47) | (1<<41)
.pointer:
    dw .pointer - gdt64 - 1
    dq gdt64


section .bss

[global idt_entries]
idt_entries:
   resb 4096  ; Reserve 4 KiB for idt_entries

stack_begin:
    resb 4096  ; Reserve 4 KiB stack space
stack_end:

align 4096
p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096