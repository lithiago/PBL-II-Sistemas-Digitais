.syntax unifed

.text
.global soma_valores
.thumb_func


soma_valores:
    push {lr}
    add r0, r0, r1
    pop {lr}
    bx lr