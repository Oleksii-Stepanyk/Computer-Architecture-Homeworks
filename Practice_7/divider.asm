.data
.eqv N, 5

# main block of arrays for assignment
ArrayA: .word 5, 10, -3, -8, 2 
ArrayB: .word 2, -4, 6, -1, 7
ArrayC: .space 20
ExpectedResult: .space 20

# for printing numbers
Separator: .string "; \0"
NewLine: .string "\n\0"

# strings and array for checking logic correctness
PairNumMsg: .string "Pair number: \0"
ErrorMsg: .string "Some pair dividend/divisor was calculated incorrectly!\n\0"
SuccessMsg: .string "Everything is good!\n\0"

.text
.globl main

# load data to registers
main:
    la t0, ArrayA
    la t1, ArrayB
    la t2, ArrayC
    li t3, 0
    li t4, N

    la t5, ExpectedResult
    li t6, 0

# perform division for each element of array 
loop:
    beq t3, t4, check_correctness_setup
    lw a0, 0(t0)
    lw a1, 0(t1)

    div t6, a0, a1

    sw t6, 0(t5)

    jal ra, divide

    sw a0, 0(t2)

    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, 4
    addi t5, t5, 4
    addi t3, t3, 1

    j loop

# setup registers for next step of program: checking correctness
check_correctness_setup:
    la a0, NewLine
    li a7, 4
    ecall

    la t1, ArrayC
    la t2, ExpectedResult
    li t3, 0
    li t4, 0
    li t5, 1

# perform step-by-step check
check_correctness:
    blt t4, t5, print_success
    lw t3, 0(t0)
    lw t4, 0(t1)
    bne t3, t4, print_error

    addi t1, t1, 4
    addi t2, t2, 4
    addi t5, t5, 1

    j check_correctness

# print error message
print_error:
    la a0, ErrorMsg
    li a7, 4
    ecall

    la a0, PairNumMsg
    li a7, 4
    ecall

    mv a0, t5
    li a7, 1
    ecall

    la a0, NewLine
    li a7, 4
    ecall

    # set exit code 1, jump to end
    li a0, 1
    j done

# print success message
print_success:
    la a0, SuccessMsg
    li a7, 4
    ecall

    # set exit code 1, jump to end
    li a0, 0
    j done

# exit with code defined by program success
done:
    li a7, 93
    ecall 

# save return address
divide:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw t0, 12(sp)
    sw t1, 8(sp)
    sw t2, 4(sp)
    sw t3, 0(sp)
    
    li t0, 0
    li t3, 0

# check divident sign
    mv t1, a0
    bgez a0, dividend_positive
    sub t1, x0, a0
    xori t3, t3, 1

# check divisor sign
dividend_positive:
    mv t2, a1
    bgez a1, divisor_positive
    sub t2, x0, a1
    xori t3, t3, 1

# check if divisor is zero
divisor_positive:
    beq  t2, x0, apply_sign

# main loop
division_loop:
    blt  t1, t2, apply_sign 
    sub  t1, t1, t2    
    addi t0, t0, 1
    
    j division_loop

# apply sign
# +/+ -> +
# -/- -> +
# +/- -> -
# -/+ -> -
apply_sign:
    beq  t3, x0, store_result
    sub  t0, x0, t0
    
store_result:
    mv a0, t0
    li a7, 1
    ecall

    la a0, Separator
    li a7, 4
    ecall

    mv a0, t0
    
    lw t3, 0(sp)
    lw t2, 4(sp)
    lw t1, 8(sp)
    lw t0, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    
    jalr x0, 0(ra)
