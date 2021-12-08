	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"MPU_Filter.c"
	.text
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Scope has been changed, drop measurements\000"
	.text
	.align	1
	.global	FilterAvg
	.arch armv7-a
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	FilterAvg, %function
FilterAvg:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r7, lr}
	sub	sp, sp, #80
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	str	r2, [r7, #4]
	ldr	r3, [r7, #8]
	ldrh	r3, [r3, #6]
	str	r3, [r7, #76]
	ldr	r3, .L7
.LPIC0:
	add	r3, pc
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2
	ldr	r3, .L7+4
.LPIC1:
	add	r3, pc
	mov	r2, r3
	movs	r3, #11
	str	r3, [r2]
	ldr	r3, .L7+8
.LPIC2:
	add	r3, pc
	mov	r2, r3
	ldr	r3, [r7, #76]
	str	r3, [r2]
.L2:
	ldr	r3, .L7+12
.LPIC3:
	add	r3, pc
	ldr	r3, [r3]
	ldr	r2, [r7, #76]
	cmp	r2, r3
	beq	.L3
	ldr	r3, .L7+16
.LPIC4:
	add	r3, pc
	mov	r2, r3
	movs	r3, #0
	str	r3, [r2]
	ldr	r3, .L7+20
.LPIC5:
	add	r3, pc
	mov	r0, r3
	bl	puts(PLT)
	ldr	r3, .L7+24
.LPIC6:
	add	r3, pc
	mov	r2, r3
	ldr	r3, [r7, #76]
	str	r3, [r2]
	ldr	r3, .L7+28
.LPIC7:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #12]	@ float
	ldr	r3, .L7+32
.LPIC8:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #16]	@ float
	ldr	r3, .L7+36
.LPIC9:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #20]	@ float
	ldr	r3, .L7+40
.LPIC10:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #24]	@ float
	ldr	r3, .L7+44
.LPIC11:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2]	@ float
	ldr	r3, .L7+48
.LPIC12:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #4]	@ float
	ldr	r3, .L7+52
.LPIC13:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #8]	@ float
	ldr	r3, .L7+56
.LPIC14:
	add	r3, pc
	mov	r2, r3
	movs	r3, #0
	str	r3, [r2]
	b	.L1
.L3:
	ldr	r3, .L7+60
.LPIC15:
	add	r3, pc
	ldr	r3, [r3]
	adds	r3, r3, #1
	ldr	r2, .L7+64
.LPIC16:
	add	r2, pc
	str	r3, [r2]
	ldr	r3, .L7+68
.LPIC17:
	add	r3, pc
	ldr	r3, [r3]
	ldr	r2, [r7, #76]
	cmp	r2, r3
	blt	.L5
	ldr	r3, .L7+72
.LPIC18:
	add	r3, pc
	vldr.32	s14, [r3, #12]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3, #12]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+76
.LPIC19:
	add	r3, pc
	vstr.32	s15, [r3, #12]
	ldr	r3, .L7+80
.LPIC20:
	add	r3, pc
	vldr.32	s14, [r3, #16]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3, #16]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+84
.LPIC21:
	add	r3, pc
	vstr.32	s15, [r3, #16]
	ldr	r3, .L7+88
.LPIC22:
	add	r3, pc
	vldr.32	s14, [r3, #20]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3, #20]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+92
.LPIC23:
	add	r3, pc
	vstr.32	s15, [r3, #20]
	ldr	r3, .L7+96
.LPIC24:
	add	r3, pc
	vldr.32	s14, [r3, #24]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3, #24]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+100
.LPIC25:
	add	r3, pc
	vstr.32	s15, [r3, #24]
	ldr	r3, .L7+104
.LPIC26:
	add	r3, pc
	vldr.32	s14, [r3]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+108
.LPIC27:
	add	r3, pc
	vstr.32	s15, [r3]
	ldr	r3, .L7+112
.LPIC28:
	add	r3, pc
	vldr.32	s14, [r3, #4]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3, #4]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+116
.LPIC29:
	add	r3, pc
	vstr.32	s15, [r3, #4]
	ldr	r3, .L7+120
.LPIC30:
	add	r3, pc
	vldr.32	s14, [r3, #8]
	ldr	r3, [r7, #4]
	vldr.32	s15, [r3, #8]
	vadd.f32	s15, s14, s15
	ldr	r3, .L7+124
.LPIC31:
	add	r3, pc
	vstr.32	s15, [r3, #8]
	b	.L1
.L5:
	ldr	r3, .L7+128
.LPIC32:
	add	r3, pc
	vldr.32	s13, [r3, #12]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+132
.LPIC33:
	add	r3, pc
	vstr.32	s15, [r3, #12]
	ldr	r3, .L7+136
.LPIC34:
	add	r3, pc
	vldr.32	s13, [r3, #16]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+140
.LPIC35:
	add	r3, pc
	vstr.32	s15, [r3, #16]
	ldr	r3, .L7+144
.LPIC36:
	add	r3, pc
	vldr.32	s13, [r3, #20]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+148
.LPIC37:
	add	r3, pc
	vstr.32	s15, [r3, #20]
	ldr	r3, .L7+152
.LPIC38:
	add	r3, pc
	vldr.32	s13, [r3, #24]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+156
.LPIC39:
	add	r3, pc
	vstr.32	s15, [r3, #24]
	ldr	r3, .L7+160
.LPIC40:
	add	r3, pc
	vldr.32	s13, [r3]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+164
.LPIC41:
	add	r3, pc
	vstr.32	s15, [r3]
	ldr	r3, .L7+168
.LPIC42:
	add	r3, pc
	vldr.32	s13, [r3, #4]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+172
.LPIC43:
	add	r3, pc
	vstr.32	s15, [r3, #4]
	ldr	r3, .L7+176
.LPIC44:
	add	r3, pc
	vldr.32	s13, [r3, #8]
	ldr	r3, [r7, #76]
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vdiv.f32	s15, s13, s14
	ldr	r3, .L7+180
.LPIC45:
	add	r3, pc
	vstr.32	s15, [r3, #8]
	ldr	r3, .L7+184
.LPIC46:
	add	r3, pc
	add	r4, r7, #48
	mov	r5, r3
	ldmia	r5!, {r0, r1, r2, r3}
	stmia	r4!, {r0, r1, r2, r3}
	ldm	r5, {r0, r1, r2}
	stm	r4, {r0, r1, r2}
	ldr	r3, .L7+188
.LPIC47:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #12]	@ float
	ldr	r3, .L7+192
.LPIC48:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #16]	@ float
	ldr	r3, .L7+196
.LPIC49:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #20]	@ float
	ldr	r3, .L7+200
.LPIC50:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #24]	@ float
	ldr	r3, .L7+204
.LPIC51:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2]	@ float
	ldr	r3, .L7+208
.LPIC52:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #4]	@ float
	ldr	r3, .L7+212
.LPIC53:
	add	r3, pc
	mov	r2, r3
	mov	r3, #0
	str	r3, [r2, #8]	@ float
	ldr	r3, .L7+216
.LPIC54:
	add	r3, pc
	mov	r2, r3
	movs	r3, #0
	str	r3, [r2]
	ldr	r3, .L7+220
.LPIC55:
	add	r3, pc
	mov	r2, r3
	ldr	r3, [r7, #76]
	str	r3, [r2]
	ldr	r3, [r7, #12]
	mov	r5, r3
	add	r4, r7, #48
	ldmia	r4!, {r0, r1, r2, r3}
	stmia	r5!, {r0, r1, r2, r3}
	ldm	r4, {r0, r1, r2}
	stm	r5, {r0, r1, r2}
.L1:
	ldr	r0, [r7, #12]
	adds	r7, r7, #80
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r7, pc}
.L8:
	.align	2
.L7:
	.word	first.9939-(.LPIC0+4)
	.word	first.9939-(.LPIC1+4)
	.word	last_scope.9938-(.LPIC2+4)
	.word	last_scope.9938-(.LPIC3+4)
	.word	Reads.9937-(.LPIC4+4)
	.word	.LC0-(.LPIC5+4)
	.word	last_scope.9938-(.LPIC6+4)
	.word	Avg.9934-(.LPIC7+4)
	.word	Avg.9934-(.LPIC8+4)
	.word	Avg.9934-(.LPIC9+4)
	.word	Avg.9934-(.LPIC10+4)
	.word	Avg.9934-(.LPIC11+4)
	.word	Avg.9934-(.LPIC12+4)
	.word	Avg.9934-(.LPIC13+4)
	.word	Reads.9937-(.LPIC14+4)
	.word	Reads.9937-(.LPIC15+4)
	.word	Reads.9937-(.LPIC16+4)
	.word	Reads.9937-(.LPIC17+4)
	.word	Avg.9934-(.LPIC18+4)
	.word	Avg.9934-(.LPIC19+4)
	.word	Avg.9934-(.LPIC20+4)
	.word	Avg.9934-(.LPIC21+4)
	.word	Avg.9934-(.LPIC22+4)
	.word	Avg.9934-(.LPIC23+4)
	.word	Avg.9934-(.LPIC24+4)
	.word	Avg.9934-(.LPIC25+4)
	.word	Avg.9934-(.LPIC26+4)
	.word	Avg.9934-(.LPIC27+4)
	.word	Avg.9934-(.LPIC28+4)
	.word	Avg.9934-(.LPIC29+4)
	.word	Avg.9934-(.LPIC30+4)
	.word	Avg.9934-(.LPIC31+4)
	.word	Avg.9934-(.LPIC32+4)
	.word	Avg.9934-(.LPIC33+4)
	.word	Avg.9934-(.LPIC34+4)
	.word	Avg.9934-(.LPIC35+4)
	.word	Avg.9934-(.LPIC36+4)
	.word	Avg.9934-(.LPIC37+4)
	.word	Avg.9934-(.LPIC38+4)
	.word	Avg.9934-(.LPIC39+4)
	.word	Avg.9934-(.LPIC40+4)
	.word	Avg.9934-(.LPIC41+4)
	.word	Avg.9934-(.LPIC42+4)
	.word	Avg.9934-(.LPIC43+4)
	.word	Avg.9934-(.LPIC44+4)
	.word	Avg.9934-(.LPIC45+4)
	.word	Avg.9934-(.LPIC46+4)
	.word	Avg.9934-(.LPIC47+4)
	.word	Avg.9934-(.LPIC48+4)
	.word	Avg.9934-(.LPIC49+4)
	.word	Avg.9934-(.LPIC50+4)
	.word	Avg.9934-(.LPIC51+4)
	.word	Avg.9934-(.LPIC52+4)
	.word	Avg.9934-(.LPIC53+4)
	.word	Reads.9937-(.LPIC54+4)
	.word	last_scope.9938-(.LPIC55+4)
	.size	FilterAvg, .-FilterAvg
	.local	first.9939
	.comm	first.9939,4,4
	.local	last_scope.9938
	.comm	last_scope.9938,4,4
	.local	Reads.9937
	.comm	Reads.9937,4,4
	.local	Avg.9934
	.comm	Avg.9934,28,4
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
