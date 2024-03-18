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
	.global sim_loop             // make function global for linking to
	.type sim_loop, %function    // define as a function
	.equ FP_OFFSET, 4            // (#regs pushed -1) * 4 is distance from sp
	.equ EXIT_SUCCESS, 0         // return success (used by main)
	.equ EXIT_FAILURE, 1         // return failure (used by main)
sim_loop:
	// function prologue
	push {fp, lr}                // stack register save minimum: fp,lr (push in pairs!)
	add fp, sp, FP_OFFSET        // set frame pointer to frame base
	
        push {r4, r5, r6, r7, r8, lr}

        mov r4, r0
        ldr r5, [r4, #8]
        ldr r6, [r4, #12]
        ldr r7, [sp, #24]
         
step_loop:
        cmp r7, #0
        beq end_step_loop
        mov r8, #0

row_loop:
        cmp r8, r5
        bge end_row_loop

        ldr r0, [r4, #4]
        ldr r1, [r4]
        mov r2, r8
        mov r3, r5
        mov r12, r6
 
        bl do_row

        add r8, r8, #1
        b row_loop
  
end_row_loop:
        ldr r0, [r4]
        ldr r1, [r4, #4]
        str r1, [r4]
        str r0, [r4, #4]
 
        ldr r0, [r4, #20]
        add r0, r0, #1
        str r0, [r4, #20]
  
        sub r7, r7, #1
        b step_loop

end_step_loop:
        pop {r4, r5, r6, r7, r8, pc}
          
	// function epilogue
	sub sp, fp, FP_OFFSET        // restore stack frame top
	pop {fp, lr}                 // remove frame and restore registers
	bx lr                        // return to caller
	// function footer
	.size sim_loop, (. - sim_loop) // set size for function
	// file footer
	.section .note.GNU-stack, "", %progbits // stack/data non-exec
.end
