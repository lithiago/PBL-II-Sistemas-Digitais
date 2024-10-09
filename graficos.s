.global main1
.global subtrai

.type main1, %function
.type subtrai, %function

main1:
    adds r0, r0, r1
    bx lr

subtrai:
    subs r0, r0, r1
    bx lr
