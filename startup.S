.syntax unified
.cpu cortex-m3
.thumb

.section .isr_vector, "a", %progbits
.align 2

.global vector_table

vector_table:
    .word _stack_top
    .word Reset_Handler

    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler

.section .text.Reset_Handler
.thumb_func
.global Reset_Handler
.type Reset_Handler, %function

Reset_Handler:
    bl main

1:
    b 1b

.thumb_func
.weak Default_Handler
.global Default_Handler
.type Default_Handler, %function

Default_Handler:
1:
    b 1b
