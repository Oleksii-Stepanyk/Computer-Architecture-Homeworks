.data
.eqv N, 5

ArrayA: .word 5, 10, -3, -8, 2
ArrayB: .word 2, -4, 6, -1, 7
ArrayC: .space 20

.text
.globl main

main:
    addi t0, x0, 0  # t0 = &ArrayA
    addi t1, x0, 20 # t1 = &ArrayB
    addi t2, x0, 40 # t2 = &ArrayC
    addi t3, x0, 0  # i = 0
    addi t4, x0, N  # N
    addi a3, x0, 1  # const 1

# perform division for each element of array
loop:
    beq t3, t4, done
    lw a0, 0(t0)    # dividend
    lw a1, 0(t1)    # divisor

    # sign = (a0<0) XOR (a1<0)
    slt t5, a0, x0  # t5 = a0<0
    slt t6, a1, x0  # t6 = a1<0
    add s1, t5, t6  # s1 in {0,1,2}
    addi t5, x0, 0  # sign = 0
    beq s1, a3, sign_one
    jal x0, sign_done

sign_one:
    addi t5, x0, 1  # sign = 1

sign_done:
    # a0 = |a0|
    slt s1, a0, x0
    beq s1, x0, a0_pos
    sub a0, x0, a0

a0_pos:
    # a1 = |a1|
    slt s1, a1, x0
    beq s1, x0, a1_pos
    sub a1, x0, a1

a1_pos:
    # if a1 == 0: q = 0
    addi a2, x0, 0  # q = 0
    beq a1, x0, apply_sign

DivLoop:
    slt s1, a0, a1      # if a0 < a1 -> exit
    beq s1, x0, ge_case # if a0>=a1 do one subtract
    jal x0, apply_sign

ge_case:
    sub a0, a0, a1
    addi a2, a2, 1
    jal x0, DivLoop

apply_sign:
    beq t5, x0, store_q # if sign==0 keep q
    sub a2, x0, a2      # q = -q

store_q:
    sw a2, 0(t2)

    # advance
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, 4
    addi t3, t3, 1
    jal x0, loop

done:
    jal x0, done
