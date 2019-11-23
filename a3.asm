
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
  
    
submain: 
    Inicializar()
    j SumarArreglo

 LlenarArreglo:
	bge a1, s8, submain #i>8
	addi t0, a1, 1		# i+1
	sw t0, (a6)		#A[i]=t0
	addi a1, a1, 1 		#i++
	addi a6, a6, 4		#A[i+1]
	j LlenarArreglo

SumarArreglo: 
	beqz s0, resultado	#offse=0 sale del ciclo
	bge a1, s0, resultado	#i>offset
	lw a2, (a6)		#a2=A[i]
	add a5, a1, s0 		#A[i+offset]
	add a, a6, a5
	 
	addi a6, a6, 4
	
 resultado: 
    # llamar el cilo de suma
    #resultado 
    li  a7, 4           # Servicio de 'print string'
    la  a0, mensaje_final      # Cargo el contenido de 'saludo'en $a0
    ecall