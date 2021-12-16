   DEVICE ZXSPECTRUMNEXT

   org $8000

start:
	jp init

	include "../Z80n/fixedpt24.asm"

ENTER = $0D

results:  dd 0,0,0

init:
   nextreg $07,$03      ; set to 28 MHz

   FP_LDA_WORD 400
   FP_LDB_WORD 80
   call fp_multiply  ; a = 32000
   FP_STA results
   call fp_divide    ; a = 400
   FP_STA results+3


done:
   halt
   jp init


; Deployment
LENGTH      = $ - start

;;; option 3: nex
	SAVENEX OPEN "test.nex",start
	SAVENEX AUTO
	SAVENEX CLOSE
