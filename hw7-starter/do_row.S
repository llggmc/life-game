// file header
	.arch armv6                  // armv6 architecture
	.arm                         // arm 32-bit instruction set
	.fpu vfp                     // floating point co-processor
	.syntax unified              // modern syntax

	// .extern                   // symbol import - external references
	// .equ                      // file level definitions
	// .bss                      // uncomment if needed
	// .data                     // uncomment if needed
	// .section .rodata          // uncomment if needed

	.text                        // start of text segment
	// function header (change main to function name in 5 places below)
	.global do_row               // make function global for linking to
	.type do_row, %function      // define as a function
	.equ FP_OFFSET, 4            // (#regs pushed -1) * 4 is distance from sp
	.equ EXIT_SUCCESS, 0         // return success (used by main)
	.equ EXIT_FAILURE, 1         // return failure (used by main)
do_row:
	// function prologue
	push {fp, lr}                // stack register save minimum: fp,lr (push in pairs!)
	add fp, sp, FP_OFFSET        // set frame pointer to frame base
	//
	// your code here
	//

	push {r4, r5, r6, r7, r8, r9, r10, lr}

        ldr r4, [sp, #32]
        ldr r5, [sp, #36]
        ldr r6, [sp, #40]
        ldr r7, [sp, #44]
        ldr r8, [sp, #48]

        mov r9, #0
col_loop:
        cmp r9, r8
        bge end_col_loop

        mov r10, #0

        mov r0, #-1
i_loop:
        cmp r0, #1
        bgt end_i_loop
    
        mov r1, #-1
j_loop:
        cmp r1, #1
        bgt end_j_loop

        cmp r0, #0
        beq skip_cell
        cmp r1, #0
        beq skip_cell
       
        add r2, r6, r0
        add r3, r9, r1
        add r2, r2, r7
        add r3, r3, r8
        and r2, r2, r7
        and r3, r3, r8

        mul r2, r2, r8
        add r2, r2, r3
        ldrb r3, [r5, r2]
        add r10, r10, r3
 
skip_cell:
        add r1, r1, #1
        b j_loop

end_j_loop:
        add r0, r0, #1
        b i_loop

end_i_loop:
        mul r0, r6, r8
        add r0, r0, r9
        
        ldrb r1,[r5, r0]
        cmp r1, #1
        beq cell_alive
        cmp r10, #3
        bne update_cell_dead
        b update_cell
cell_alive:
        cmp r10, #2
        beq update_cell 
        cmp r10, #3
        beq update_cell
        b update_cell_dead
update_cell:
        mov r1, #1
        b update_buffer
update_cell_dead:
        mov r1, #0
update_buffer:
        strb r1, [r4, r0]
        add r9, r9, #1
        b col_loop
        
end_col_loop:
        pop {r4, r5, r6, r7, r8, r9, r10, pc}
        


                            
	// function epilogue
	sub sp, fp, FP_OFFSET        // restore stack frame top
	pop {fp, lr}                 // remove frame and restore registers
	bx lr                        // return to caller
	// function footer
	.size do_row, (. - do_row)  // set size for function
	// file footer
	.section .note.GNU-stack, "", %progbits // stack/data non-exec
.end
