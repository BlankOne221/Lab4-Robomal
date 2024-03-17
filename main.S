# Created by Dr. Murray / Artem Labanau
# This main just runs the robo program
# The included files below have the robo program itself
# and the various extra functions needed

.include "../src/robomal.S"
.include "../src/robomalf.S"

.global main

.text

main:

	whileOne:

	BL runROBO_Program

	B whileOne


.end
