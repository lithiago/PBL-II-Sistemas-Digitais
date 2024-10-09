.global main1
.global subtrai
.global multiplica


.type main1, %function
.type subtrai, %function
.type multiplica, %function


main1:
    adds r0, r0, r1
    bx lr

subtrai:
    subs r0, r0, r1
    bx lr

multiplica:
    lsl r0, #3
    bx lr
