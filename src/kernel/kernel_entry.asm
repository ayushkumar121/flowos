[bits 32]

extern _start

global idt_load
; global isr_divide_zero

extern idt_descriptor
extern divide_by_zero_handler
extern KERNEL_LOCATION

section .text
    start:
        call _start
        jmp $

    idt_load:
        lidt [idt_descriptor]
        ret

    ; isr_divide_zero:
    ;     pusha        
    ;     call divide_by_zero_handler
    ;     popa
    ;     iret