.data

			.align 2
	array_ptr :	
			.space 32
	str_give :
			.asciz "\nGive me 8 numbers \n"
	str_line :	
			.asciz "/----------------------------------------------------------/\n"
	str_space :
			.asciz " "

.text

	main :
			la x5,array_ptr #load the address of the array in the x5 register
			addi x17,x0,4 #environment call code for print_string
			la x10,str_give #load the address of the string into x10 register
			ecall
			addi x20,x0,0 #initialize x1 register with i=0
			addi x21,x0,8 #initialize x2 register with maxarray=8
	floop :
			bgt     x20, x21 , exito #(if i > maxarray go to exito)
			addi	x17,x0,5 #environment call code for read_int
			ecall 
			sw	x10, 0(x5) 
			addi	x5,x5,4 #go to the next 4byte address(next element of the array)
			addi	x20,x20,1 #add 1 to the i counter(counter for the loop)
			bgt     x21, x20 , floop #(if maxarray > i go to floop)
	exito :		
			addi x17,x0,4 #environment call code for print_string
			la x10,str_line #load the address of the string into x10 register
			ecall
			addi x20,x0,0 #initialize x1 register with i=0
			addi x21,x0,8 #initialize x2 register with maxarray=8
			addi x5,x5,-4 #go to the address of the last element of the array(since we were 4bytes forward)
	loop :
			bgt     x20, x21 , exitt  #(if i > maxarray go to exitt)
			lw	x18, 0(x5) #load word into the x18 register
			add	x18,x18,x18 #x18 register is egual to 2*x18(add itself two times)
			add	x16,x18,x18 #x16 register is egual to 4 times x18 ((x18*2)+(x18*2)=4*x18)
			add	x18,x16,x18#x18 is equal six times x18((x18*2)+(x18*4)=6*x18)
			addi	x17,x0,1 #environment call code for print_int
			add	x10,x18,x0 #put x18 register's value into to x10 register
			ecall
			addi x17,x0,4 #environment call code for print_string
			la x10,str_space #load the address of the string into x10 register
			ecall
			addi	x5,x5,-4  #go to the previous 4 byte position in the data segment(x5 register has the address of the 4byte position,the array's element position)
			addi	x20,x20,1 #add 1 to the i counter
			bgt     x21, x20 , loop #(if maxarray > i go to loop)
	exitt :
			j	main
