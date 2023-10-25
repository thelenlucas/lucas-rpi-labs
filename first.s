@ ARM assembly

.data
input: .space 3 @ 2 bytes for the input, 1 byte for the null terminator ('\0')
msg: .asciz "Enter a number: "

.text
.global _start

_start:
    @ Print the prompt
    mov r0, #1 @ This is for the stdout system call file descriptor
    ldr r1, =msg @ Load the location of the message into r1
    ldr r2, =19 @ Load the length of the message into r2
    mov r7, #4 @ This is for the write system call
    swi 0 @ Call the kernel

    @ Read the input
    mov r0, #0 @ This is for the stdin system call file descriptor
    ldr r1, =input @ Load the location of the input into r1
    mov r2, #2 @ Sets the maximum number of bytes to read
    mov r7, #3 @ This is for the read system call
    swi 0 @ Call the kernel

    @ Convert the input to an integer
    ldrb r3, [r1] @ Load the first byte of the input into r3
    sub r3, r3, #'0' @ I'm a bit proud of this
    mov r5, #10 @ Load 10 into r4
    mul r6, r3, r5 @ First digit up by 10
    cmp r0, #2 @ If the input is 2 characters long
    blt finish @ If r0 < 2, then the input is 1 character long, and we're done here

    ldrb r4, [r1, #1] @ Load the second byte of the input into r4
    sub r4, r4, #'0' @ once again
    mul r7, r3, r5 @ Second digit up by 10
    add r3, r6, r7 @ Add the two digits together

finish:
    @ Congrats, you read the integer! Now print it out
    mov r0, #1 @ This is for the stdout system call file descriptor
    mov r1, r3 @ Load the integer into r1
    mov r7, #1 @ This is for the exit system call
    swi 0 @ Call the kernel

    @ Exit
    mov r0, #0 @ This is for the exit system call
    mov r7, #1 @ This is for the exit system call
    swi 0 @ Call the kernel