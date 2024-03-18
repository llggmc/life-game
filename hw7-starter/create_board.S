// file header
	.arch armv6                  // armv6 architecture
	.arm                         // arm 32-bit instruction set
	.fpu vfp                     // floating point co-processor
	.syntax unified              // modern syntax

        .data
        mode: .asciz "r"
        format: .asciz "%zu %zu"
	
        .text                        // start of text segment
	.global create_board         // make function global for linking to
	.type create_board, %function// define as a function
	.equ FP_OFFSET, 4            // (#regs pushed -1) * 4 is distance from sp
	.equ EXIT_SUCCESS, 0         // return success (used by main)
	.equ EXIT_FAILURE, 1         // return failure (used by main)
        .equ sizeof_Board, 24
create_board:
	// function prologue
	push {fp, lr}                // stack register save minimum: fp,lr (push in pairs!)
	add fp, sp, FP_OFFSET        // set frame pointer to frame base
	//
	// your code here
	//
	push {r4, r5, r6, r7, r8, lr}
        
        mov r4, r0
        
        ldr r1, =mode
        bl fopen
        cmp r0, #0
        mov r4, r0
        beq error_fopen
       
        
      
        sub sp, sp, #8
        mov r0, r4
        ldr r1, =format
        add r2, sp, #0
        add r3, sp, #4
        bl fscanf
 
        ldr r0, =sizeof_Board
        bl malloc
        cmp r0, #0
        beq error_malloc_board
        mov r5, r0

        
        ldr r1, [sp, #0]
        str r1, [r5, #8]
        
        ldr r1, [sp, #4]
        str r1, [r5, #12]

        ldr r1, [r5, #8]
        ldr r2, [r5, #12]
        mul r0, r1, r2
        lsl r0, r0, #2

        bl calloc
        cmp r0, #0
        beq error_calloc_buffer
        str r0, [r5]

        bl calloc 
        cmp r0, #0
        beq error_calloc_next_buffer
        str r0, [r5, #4]

        mov r0, #0
        str r0, [r5, #20]

        mov r0, r4
        bl fclose

        mov r0, r5
        add sp, sp, #8
        pop {r4, r5, r6, r7, r8, pc}

error_fopen:
        b error_exit

error_malloc_board:
        mov r0, r4
        bl fclose
        b error_exit

error_calloc_buffer:
        mov r0, r5
        bl free
        mov r0, r4
        bl fclose
        b error_exit

error_calloc_next_buffer:
        ldr r0, [r5]
        bl free
        mov r0, r5
        bl free
        mov r0, r4
        bl fclose 
        b error_exit

error_exit:
        mov r0, #0
        add sp, sp, #8
        pop {r4, r5, r6, r7, r8, pc}
        
	// function epilogue
	sub sp, fp, FP_OFFSET        // restore stack frame top
	pop {fp, lr}                 // remove frame and restore registers
	bx lr                        // return to caller
	// function footer
	.size create_board, (. - create_board) // set size for function
	// file footer
	.section .note.GNU-stack, "", %progbits // stack/data non-exec
.end
