; void escape_time_avx2(float* cx, float* cy, unsigned* iters, unsigned maxit) {
; rcx, rdx, r8, r9


;ymm0    cx
;ymm1    cy
;ymm2    zx
;ymm3    zy
;ymm4    zx2
;ymm5    zy2
;ymm6    tmp_zx
;ymm7    tmp_zy
;ymm8    mask
;ymm9    iters
;ymm10   maxit
;ymm11   two
;ymm12   four
;ymm13   one
;ymm14   zxzy
;ymm15

.code
PUBLIC escape_time_avx2

escape_time_avx2 PROC
    push rbp
    mov rbp,rsp

    ; load cx and cy
    vmovaps ymm0, YMMWORD PTR [rcx]
    vmovaps ymm1, YMMWORD PTR [rdx]

    ; zero zx,zy
    vxorps ymm2, ymm2, ymm2
    vxorps ymm3, ymm3, ymm3
    
    vxorps ymm14,ymm14,ymm14

    ; zero iters
    vpxor ymm9, ymm9, ymm9

    ; set max iters
    movd xmm10,r9d
    vpbroadcastd ymm10,xmm10

    ; constants
    vmovaps ymm11, YMMWORD PTR [v_two]
    vmovaps ymm12, YMMWORD PTR [v_four]
    vmovdqa ymm13, YMMWORD PTR [v_one]

escape_loop:
    ; zx2 and zy2
    vmulps ymm4, ymm2, ymm2
    vmulps ymm5, ymm3, ymm3

    vaddps ymm8, ymm4, ymm5 ; mag = zx2 + zy2

    vcmpltps ymm8, ymm8, ymm12 ; ymm8 = mag < 4.0 (escape condition not met)

    vpcmpgtd ymm7, ymm10, ymm9 ; ymm13 = iters < maxit

    vpand ymm8, ymm8, ymm7 ; active = iters < maxit & mag < 4.0

    vptest ymm8, ymm8 ; if all are zero, then we are done
    jz escape

    ; iters += 1 & active
    vpand ymm7, ymm8, v_one
    vpaddd ymm9, ymm9, ymm7

    ; tmp_zx = zx2 - zy2 + cx
    vsubps ymm6, ymm4, ymm5
    vaddps ymm6, ymm6, ymm0

    ; tmp_zy = 2 * zx * zy + cy
    
    ; vmulps ymm7, ymm7, ymm11
    ; switch to vaddps for faster
    vmulps ymm7, ymm2, ymm3  ; tmp_zy = zx * zy
    vaddps ymm7, ymm7, ymm7 ; tmp_zy = 2 * zx * zy
    vaddps ymm7, ymm7, ymm1  ; tmp_zy += cy


    vblendvps ymm2, ymm2, ymm6, ymm8  ; zx = active ? tmp_zx : zx
    vblendvps ymm3, ymm3, ymm7, ymm8 ; zy = active ? tmp_zy : zy

    jmp escape_loop
escape:
    vmovdqu YMMWORD PTR [r8],ymm9


done:
    ;mov rsp,rbp
    pop rbp
    ret

escape_time_avx2 ENDP


.data
	v_two		REAL4		2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0
	v_four	    REAL4		4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0
	v_one		DWORD		1,1,1,1,1,1,1,1
	

END