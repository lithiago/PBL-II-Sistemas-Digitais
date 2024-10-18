setPolygon:
   push {r4,r5,r6,r7,r8,lr} @recebe 7 parametors | 4 em r0,,r1,r2,r3 | o resto na pilha

    @ r0 = address
    @ r1 = opcode
    @ r2 = color
    @ r3 = form
    @ r4 = mult
    @ r5 = ref_point_x
    @ r6 = ref_point_y

	ldr r4, [sp, #12]
	ldr r5, [sp, #8]
	ldr r6, [sp, #4]

	@ mov r7, #0
	@ orr r7, r7, r0
	@ lsl r7, r7, #4
	@ orr r7, r7, r1

	lsl r0, r0, #4
	orr r0, r0,#3

	lsl r3, #9
	orr r3, r3, r2
	lsl r3, #4
	orr r3, r3, r4
	lsl r3, r3, #9
	orr r3, r3, r6
	lsl r3, r3, #9
	orr r3, r3, r5

	mov r3, r1


	bl sendInstruction @chama a funçao sendInstruction
    pop {r4, r5, r6, r7, r8, lx} @ Restaura os registradores e retorna
	bx lr