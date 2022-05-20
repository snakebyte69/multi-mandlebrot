	.global MAND_XMIN,MAND_XMAX,MAND_YMIN,MAND_YMAX
	.global MAND_WIDTH,MAND_HEIGHT,MAND_MAX_IT
	.global setup,plot,restore
	;; mandelbrot constants
	.equ MAND_XMIN,0xfd80	; -2.5
	.equ MAND_XMAX,0x0380	; 3.5 (fixed point width)
	.equ MAND_YMIN,0xff00	; -1.0
	.equ MAND_YMAX,0x0200	; 2.0 (fixed point height)
	.equ MAND_WIDTH,32
	.equ MAND_HEIGHT,22
	.equ MAND_MAX_IT,14
	;; QDOS constants
	;; trap #1
	.equ mt.susjb,0x08
	;; trap #2
	.equ io.open,0x01
	.equ io.close,0x02
	;; trap #3
	.equ sd.fill,0x2e
	;; vectors
	.equ ut.scr,0xc8


setup:
	;; open a 512x256 window at 0,0 and save the channel id in chanid
	move.w ut.scr,a4
	lea windef(pc),a1
	jsr (a4)
	lea chanid(PC),a4
	move.l a0,(a4)
	rts
	.align 2
windef:
	.byte 0,0,0,7
	.word 512,256,0,0

plot:
	;; plot a point
	;; x-coord: 4(sp)
	;; y-coord: 6(sp)
	;; color:   8(sp)
	moveq #sd.fill,d0
	move.b #MAND_MAX_IT-1,d1
	sub.b 8(sp),d1
	move.b d1,d3
	and.b #0xfa,d1
	and.b #0x01,d3
	lsl.b #2,d3
	or.b d3,d1
	move.b 8(sp),d3
	and.b #0x04,d3
	lsr.b #2,d3
	or.b d3,d1
	andi.b #7,d1
	moveq #-1,d3
	move.l chanid(pc),a0
	lea block(pc),a1
	move.w 4(sp),d4
	asl.w #4,d4
	move.w d4,4(a1)
	move.w 6(sp),d4
	muls #11,d4
	move.w d4,6(a1)
	trap #3
	tst.l d0
	rts
	.align 2
block:
	.word 16,11,16,16

restore:
	moveq #io.close,d0
	move.l chanid(pc),a0
	trap #2
	tst.l d0
	rts
	.align 4
chanid:
	.long 0
	
