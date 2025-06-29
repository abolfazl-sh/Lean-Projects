	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZN3std2rt10lang_start17h6b68df7f15061145E
	.globl	__ZN3std2rt10lang_start17h6b68df7f15061145E
	.p2align	2
__ZN3std2rt10lang_start17h6b68df7f15061145E:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x4, x3
	mov	x3, x2
	mov	x2, x1
	str	x0, [sp, #8]
Lloh0:
	adrp	x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.0@PAGE
Lloh1:
	add	x1, x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.0@PAGEOFF
	add	x0, sp, #8
	bl	__ZN3std2rt19lang_start_internal17hdff9e551ec0db2eaE
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc

	.p2align	2
__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h7662ceb9337eb0b8E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h24e2d4225e4357acE
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h24e2d4225e4357acE:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	blr	x0
	; InlineAsm Start
	; InlineAsm End
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h7781ac9efcae84d4E:
	.cfi_startproc
	ldr	x0, [x0]
	ldr	w8, [x1, #16]
	tbnz	w8, #25, LBB3_3
	tbnz	w8, #26, LBB3_4
	b	__ZN4core3fmt3num3imp54_$LT$impl$u20$core..fmt..Display$u20$for$u20$usize$GT$3fmt17hbdb0d16d4d29e979E
LBB3_3:
	b	__ZN4core3fmt3num55_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$usize$GT$3fmt17h93259a58915836f8E
LBB3_4:
	b	__ZN4core3fmt3num55_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$usize$GT$3fmt17hc13a738e48b0caeeE
	.cfi_endproc

	.p2align	2
__ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h0d1930ff9e6ad458E:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x0, [x0]
	bl	__ZN3std3sys9backtrace28__rust_begin_short_backtrace17h24e2d4225e4357acE
	mov	w0, #0
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.cfi_endproc

	.p2align	2
__ZN70_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h9c8074ba55d8e35cE:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x8, x1
	ldr	w9, [x0], #8
	cmp	w9, #1
	b.ne	LBB5_2
	str	x0, [sp, #8]
Lloh2:
	adrp	x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.3@PAGE
Lloh3:
	add	x1, x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.3@PAGEOFF
Lloh4:
	adrp	x4, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.1@PAGE
Lloh5:
	add	x4, x4, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.1@PAGEOFF
	add	x3, sp, #8
	mov	x0, x8
	mov	w2, #3
	b	LBB5_3
LBB5_2:
	str	x0, [sp, #8]
Lloh6:
	adrp	x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.2@PAGE
Lloh7:
	add	x1, x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.2@PAGEOFF
Lloh8:
	adrp	x4, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.1@PAGE
Lloh9:
	add	x4, x4, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.1@PAGEOFF
	add	x3, sp, #8
	mov	x0, x8
	mov	w2, #2
LBB5_3:
	bl	__ZN4core3fmt9Formatter25debug_tuple_field1_finish17ha86d8d497f676a50E
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh6, Lloh7
	.cfi_endproc

	.p2align	2
__ZN11cas_example4main17hfc8c563f951f9ea1E:
	.cfi_startproc
	sub	sp, sp, #208
	.cfi_def_cfa_offset 208
	stp	x26, x25, [sp, #128]
	stp	x24, x23, [sp, #144]
	stp	x22, x21, [sp, #160]
	stp	x20, x19, [sp, #176]
	stp	x29, x30, [sp, #192]
	add	x29, sp, #192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	mov	w23, #5
	str	x23, [sp, #8]
	mov	w19, #10
	add	x21, sp, #8
	mov	w8, #5
	casal	x8, x19, [x21]
	cmp	x8, #5
	cset	w9, eq
	eor	w9, w9, #0x1
	stp	x9, x8, [sp, #16]
	add	x8, sp, #16
Lloh10:
	adrp	x20, __ZN70_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h9c8074ba55d8e35cE@PAGE
Lloh11:
	add	x20, x20, __ZN70_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h9c8074ba55d8e35cE@PAGEOFF
	stp	x8, x20, [x29, #-80]
Lloh12:
	adrp	x8, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.6@PAGE
Lloh13:
	add	x8, x8, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.6@PAGEOFF
	mov	w22, #2
	stp	x8, x22, [sp, #64]
	sub	x24, x29, #80
	mov	w25, #1
	str	x24, [sp, #80]
	stp	x25, xzr, [sp, #88]
	add	x0, sp, #64
	bl	__ZN3std2io5stdio6_print17h1c7eede3aaadf56cE
	mov	w8, #15
	casal	x23, x8, [x21]
	cmp	x23, #5
	cset	w8, eq
	eor	w8, w8, #0x1
	stp	x8, x23, [sp, #32]
	add	x8, sp, #32
Lloh14:
	adrp	x9, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.8@PAGE
Lloh15:
	add	x9, x9, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.8@PAGEOFF
	stp	x8, x20, [x29, #-80]
	stp	x9, x22, [sp, #64]
	stp	x25, xzr, [sp, #88]
	str	x24, [sp, #80]
	add	x0, sp, #64
	bl	__ZN3std2io5stdio6_print17h1c7eede3aaadf56cE
	mov	w8, #20
	casal	x19, x8, [x21]
	cmp	x19, #10
	cset	w8, eq
	eor	w8, w8, #0x1
	stp	x8, x19, [sp, #48]
	add	x8, sp, #48
Lloh16:
	adrp	x9, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.10@PAGE
Lloh17:
	add	x9, x9, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.10@PAGEOFF
	stp	x8, x20, [x29, #-80]
	stp	x9, x22, [sp, #64]
	stp	x25, xzr, [sp, #88]
	str	x24, [sp, #80]
	add	x0, sp, #64
	bl	__ZN3std2io5stdio6_print17h1c7eede3aaadf56cE
	.cfi_def_cfa wsp, 208
	ldp	x29, x30, [sp, #192]
	ldp	x20, x19, [sp, #176]
	ldp	x22, x21, [sp, #160]
	ldp	x24, x23, [sp, #144]
	ldp	x26, x25, [sp, #128]
	add	sp, sp, #208
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	ret
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh10, Lloh11
	.cfi_endproc

	.globl	_main
	.p2align	2
_main:
	.cfi_startproc
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	x3, x1
	sxtw	x2, w0
Lloh18:
	adrp	x8, __ZN11cas_example4main17hfc8c563f951f9ea1E@PAGE
Lloh19:
	add	x8, x8, __ZN11cas_example4main17hfc8c563f951f9ea1E@PAGEOFF
	str	x8, [sp, #8]
Lloh20:
	adrp	x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.0@PAGE
Lloh21:
	add	x1, x1, l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.0@PAGEOFF
	add	x0, sp, #8
	mov	w4, #0
	bl	__ZN3std2rt19lang_start_internal17hdff9e551ec0db2eaE
	ldp	x29, x30, [sp, #16]
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh18, Lloh19
	.cfi_endproc

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h0d1930ff9e6ad458E
	.quad	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h7662ceb9337eb0b8E
	.quad	__ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h7662ceb9337eb0b8E

	.p2align	3, 0x0
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.1:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	__ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h7781ac9efcae84d4E

	.section	__TEXT,__const
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.2:
	.ascii	"Ok"

l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.3:
	.ascii	"Err"

l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.4:
	.ascii	"CAS result: "

l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.5:
	.byte	10

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.6:
	.quad	l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.4
	.asciz	"\f\000\000\000\000\000\000"
	.quad	l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.5
	.asciz	"\001\000\000\000\000\000\000"

	.section	__TEXT,__const
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.7:
	.ascii	"CAS result2: "

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.8:
	.quad	l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.7
	.asciz	"\r\000\000\000\000\000\000"
	.quad	l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.5
	.asciz	"\001\000\000\000\000\000\000"

	.section	__TEXT,__const
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.9:
	.ascii	"Weak CAS result: "

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.10:
	.quad	l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.9
	.asciz	"\021\000\000\000\000\000\000"
	.quad	l_anon.a2ac7a1b090ecf1343d8dd3e3d3de3a8.5
	.asciz	"\001\000\000\000\000\000\000"

.subsections_via_symbols
