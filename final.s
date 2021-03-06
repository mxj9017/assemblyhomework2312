.global main
.func main

main:
	MOV R1,#0
writeloop:
	CMP R1,#10	
	BEQ doneloop	
	PUSH {R1}
	PUSH {R2}
	BL _scanf	@ Take user input
	POP {R2}
	POP {R1}
	LDR R4, =a
	LSL R5,R1,#2
	ADD R5,R5,R4
	STR R0, [R5]
	ADD R1,R1,#1
	B writeloop

doneloop:	
	PUSH {R2}
	MOV  R0,#0
	
readloop:
	CMP R0,#10
	BEQ readdone
	LDR R1,=a
	LSL R2,R0,#2
	ADD R2,R1,R2
	LDR R1, [R2]
	PUSH {R0}
	PUSH {R1}
	PUSH {R2}
	MOV R2,R1
	MOV R1,R0
	BL _printf
	POP {R2}
	POP {R1}
	POP {R0}
	ADD R0,R0,#1
	B readloop

readdone:
	POP {R2}
	BL _printf1
	BL _scanf
	MOV R8,R0
	MOV R0,#0
	
readloop1:			@for searching the array
	CMP R0,#10
	BEQ readdone1
	LDR R1,=a
	LSL R2,R0,#2
	ADD R2,R1,R2
	LDR R1, [R2]
	PUSH {R8}      @ push search value into th stack
	CMP R1,R8      @compare array values to the search value
	ADDEQ R9,R9,#1 @ means value is in the array    
	PUSH {R9}
	PUSH {R0}
	PUSH {R1}
	PUSH {R2}
	MOVEQ R2,R1
	MOVEQ R1,R0
	BLEQ _printf  @print array value if found
	POP {R2}      @POP all PUSH
	POP {R1}
	POP {R0}
	POP {R9}
	POP {R8}
	ADD R0,R0,#1
	B readloop1   @loop till 10 elements
	
readdone1:
	CMP R9,#0      @ if R9=0 print not found
	BLEQ not_found @ branch for printing not found
	B _exit	

not_found:
	PUSH {LR}
	LDR R0,=not_str
	BL printf
	POP {PC}
	
_printf:
	PUSH {LR}
	LDR R0,=printf_str
	BL printf
	POP {PC}

_printf1:
	PUSH {LR}
	LDR R0,=printf_str1
	BL printf
	POP {PC}
	
_scanf:
	MOV R4,LR
	SUB SP,SP,#4
	LDR R0,=format_str
	MOV R1,SP
	BL scanf
	LDR R0, [SP]
	ADD SP,SP,#4
	MOV PC,R4

_exit:
	MOV  R7,#4
	MOV R0,#1
	MOV R2,#21
	SWI 0
	MOV R7,#1
	SWI 0

.data
.balign 4
a:		.skip	40
printf_str:	.asciz	"a[%d] = %d\n"
printf_str1:	.asciz   "ENTER A SEARCH VALUE: "
format_str1:	.asciz	"%d"
exit_str:	.asciz   "Terminating Program.."
format_str:	.asciz	"%d"
not_str:        .asciz  "That value does not exist in the array\n"
