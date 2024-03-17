
.ifndef ROBOMALF_S
.set ROBOMALF_S, 1

# This file contains all additonal information needed for our robomal program
# contains both readPMODB and writePMODB, more can be added if needed just a
# included file in our robot program

# Created by Dr. Murray / Artem Labanau

@ Base address for our MIO address space
@ We care about DATA_2, DATA_2_RO, DIR_2, and OE_2
@ Which have offsets #0x48, #0x68, #0x284, #0x288 from the base address respectively
.set MIO_BASE_ADDR, 0xE000A000

@ Our bitmasks for the top and bottom pins of PMODB
.set PMODB_TOP_MASK, 0x0780 	@ top pin information is in bits 7,8,9,10 of the above registers
.set PMODB_BOTTOM_MASK, 0x7800  @ bottom pin information is in bits 11,12,13,14 of the above registers

# LEDS address for the robot control simulation
.set LEDS, 0x41210000

.text

# row = 0 means PMODB top row, row = 1 means PMODB bottom row
# unsigned int that is returned from the function == r0, unsigned int row == r1
readPMODB:

	PUSH {r3, r4, r5, r6, LR}

	LDR r3, =MIO_BASE_ADDR
	CMP r1, #0
	BNE readRowTrue
	readRowFalse:	@ row = 0
	LDR r4, =PMODB_TOP_MASK	@ r4 = PMODB_TOP_MASK
	LDR r5, [r3, #0x68]		@ r5 = DATA_2_RO
	AND r6, r5, r4			@ r6 = PMODB_TOP_MASK & DATA_2_RO
	LSR r0, r6, #7			@ r0 = (PMODB_TOP_MASK & DATA_2_RO) >> 7

	B endReadPMODB
	readRowTrue: @ row =1
	LDR r4, =PMODB_BOTTOM_MASK	@ r4 = PMODB_BOTTOM_MASK
	LDR r5, [r3, #0x68]			@ r5 = DATA_2_RO
	AND r6, r5, r4				@ r6 = PMODB_BOTTOM_MASK & DATA_2_RO
	LSR r0, r6, #11				@ r0 = (PMODB_BOTTOM_MASK & DATA_2_RO) >> 11

	endReadPMODB:
	POP {r3, r4, r5, r6, LR}
	BX LR


# row = 0 means PMODB top row, row = 1 means PMODB bottom row
# unsigned int value == r1, unsigned int row == r2
writePMODB:

	PUSH {r2-r9, LR}

	LDR r3, =MIO_BASE_ADDR
	CMP r2, #0
	BNE writeRowTrue

	writeRowFalse: @ row = 0
	LDR r4, =PMODB_TOP_MASK
	MVN r5, r4				@ r5 = ~PMODB_TOP_MASK
	LDR r6, [r3, #0x48]		@ r6 = DATA_2
	AND r7, r6, r5			@ r7 = DATA_2 & ~PMODB_TOP_MASK
	AND r8, r4, r1, LSL #7  @ r8 = PMODB_TOP_MASK & (value << 7)
	ORR r9, r7, r8			@ r9 = (DATA_2 & ~PMODB_TOP_MASK) | (PMODB_TOP_MASK & (value << 7))
	STR r9, [r3, #0x48]		@ DATA_2 = r9

	B endWritePMODB
	writeRowTrue: @ row = 1
	LDR r4, =PMODB_BOTTOM_MASK
	MVN r5, r4				@ r5 = ~PMODB_BOTTOM_MASK
	LDR r6, [r3, #0x48]		@ r6 = DATA_2
	AND r7, r6, r5			@ r7 = DATA_2 & ~PMODB_BOTTOM_MASK
	AND r8, r4, r1, LSL #11 @ r8 = PMODB_BOTTOM_MASK & (value << 11)
	ORR r9, r7, r8			@ r9 = (DATA_2 & ~PMODB_BOTTOM_MASK) | (PMODB_BOTTOM_MASK & (value << 11))
	STR r9, [r3, #0x48]		@ DATA_2 = r9


	endWritePMODB:
	POP {r2-r9, LR}
	BX LR



.endif
