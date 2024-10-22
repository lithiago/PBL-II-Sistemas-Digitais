.section .text
.global set_background_block
.type set_background_block, %function
.global set_background_color
.type set_background_color, %function
.type send_instruction, &function
.type dataA_builder, %function

.extern h2p_lw_dataA_addr
.extern h2p_lw_dataB_addr
.extern h2p_lw_wrReg_addr
.extern h2p_lw_wrFull_addr
.extern h2p_lw_screen_addr
.extern h2p_lw_result_pulseCounter_addr


    
    


