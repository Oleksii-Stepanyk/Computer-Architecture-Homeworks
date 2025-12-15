.text
main:
    addi x9, x0, 0 # Configuration counter
    addi x10, x0, 40 # Word 10 * 4 bytes = 40
    addi x11, x0, 44 # Word 11 * 4 bytes = 44

config1:
    addi x12, x0, 5 # state1_duration
    addi x13, x0, 3 # state2_duration
    addi x14, x0, 4 # state3_duration
    addi x15, x0, 2 # number of cycles
    jal x1, run_test # Run test
    
config2:
    addi x12, x0, 10
    addi x13, x0, 8
    addi x14, x0, 6
    addi x15, x0, 3
    jal x1, run_test

config3:
    addi x12, x0, 15
    addi x13, x0, 12
    addi x14, x0, 10
    addi x15, x0, 4
    jal x1, run_test
    
end:
    jal x0, end

run_test:
    slli x5, x12, 1 # state1_duration << 1
    slli x6, x13, 9 # state2_duration << 9
    add x5, x5, x6

    slli x6, x14, 17 # state3_duration << 17
    add x5, x5, x6 # x5 = complete config (enable=0)

    addi x8, x15, 0 # x8 = cycle counter

test_loop:
    beq x8, x0, test_done
    
    addi x6, x5, 1 # x6 = complete config (enable=1)
    sw x6, 0(x10)
    
wait_loop:
    # We wait until peripheral is done
    # assign status_reg = {29'b0, ventilation_active, irrigation_active, peripheral_done};
    # END_STATE -> 001
    lw x6, 0(x11)
    andi x6, x6, 1 # 001 & 1 = 1
    beq x6, x0, wait_loop
    
    # Disable peripheral
    sw x5, 0(x10)
    
    # Delay counter
    addi x7, x0, 5

# Give Quartus some time to populate the data
delay_loop:
    addi x7, x7, -1
    beq x7, x0, delay_done
    jal x0, delay_loop

delay_done:    
    addi x8, x8, -1
    jal x0, test_loop

test_done:
    # Increment config counter
    addi x9, x9, 1

    # If counter equals 1, go to config2
    addi x16, x0, 1
    beq x9, x16, config2

    # If counter equals 2, go to config3
    addi x16, x0, 2
    beq x9, x16, config3
    
    # Otherwise, go to end
    jal x0, end