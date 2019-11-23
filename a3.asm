
#Title: A3					
#Autors: Carlos Padilla 15-11061, Alexander Nascimento 15-10471			Date: Abril 2019
#Descriptions: "Version en mars del programa P1.c dado por el profesor"

################################## Data segment ##################################
.data 
	arreglo: 			.space 0x8 		 # Tamaño arreglo 8*4=32 (se reserva el espacio del framebuffer)
	saludo:        			.asciz "Quiz 1. Memoria cache" 
	mensaje_final: 			.asciz "\n Hola Profe! Resultado: \n "
	SIZE_ARRAY:			.word 0x8

################################## Code segment ##################################
.text

.macro  Saludo_p
   # Saludo 
    li  a7, 4           # Servicio de 'print string'
    la  a0, saludo      # Cargo el contenido de 'saludo'en $a0
    ecall
.end_macro

.macro  Inicializar
    la a6, arreglo	#A[0]
    lw s8, SIZE_ARRAY	#SIZE_ARRAY
    li s1, 2
    div s0, s8, s1	#offset (SIZE_ARRAY/2)
    li a1, 0		#i
.end_macro


main:
    Saludo_p() 
    Inicializar()
    j LlenarArreglo
  
LlenarArreglo:
	bge a1, s8, submain 	#i>8
	addi t0, a1, 1		# i+1
	sw t0, (a6)		#A[i]=t0
	addi a1, a1, 1 		#i++
	addi a6, a6, 4		#A[i+1]
	j LlenarArreglo

      
submain: 
    Inicializar()
    j SumarArreglo



SumarArreglo: 
	beqz s0, resultado	#offset=0 sale del ciclo
	bge a1, s0, resultado	#i>offset
	lw a2, (a6)		#a2=A[i]
	li a3, 4
	mul a3, s0, a3
	add a4, a6, a3		#variable aux a4=i+ 4*offset
	lw a3, (a4)		#reutilizamos a3 para guardar a3=A[i+offset]
	add a4, a2, a3 		#reutilizamos a4, a4= A[i] + A[i+offset]
	sw a4, (a6)
	addi a6, a6, 4
	addi a1, a1, 1
	div s0, s0, s1		#offset/2
	j SumarArreglo
	
 resultado: 
    li  a7, 4         
    la  a0, mensaje_final      # Cargo el contenido de 'mensaje_final' en $a0
    ecall
    lw a0, (a6)
    li  a7, 1         
    add  a0, a0, zero     
    ecall