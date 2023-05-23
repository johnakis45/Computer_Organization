.data 
nextline:	.asciz "\n"

.text 

main:
	#INITIALIZE DUMMY NODE
	jal node_alloc #creating a new node by calling node_alloc function (x10 will have the address of the new node)
	add x8,x0,x10  #saving address into s0 
	add x9,x0,x10  #saving address into s1 
	sw x0,0(x8)   #data=0 initialize
	sw x0,4(x8)   #nPtr=0 initialize (we created the first "dummy" node 
	
	
	j read      #go to the condition of the while loop 
	
loop:   
	
	jal node_alloc #creating new node
	sw x10,4(x9) #store the address of the new node into the nptr
	add x9,x10,x0  #we save the address of the new node into x9 register 
	sw x5,0(x9) #save x5==input number into the data of the new node
	sw x0,4(x9) #initialize nptr=0 of the new node 
	
read:   jal read_int  #calling the function read_int (input number will be in register x10)
	add x5,x10,x0 #putting input number in the x5 temporary register
	blt  x0, x5, loop #while 0<=input loop
	
	
#------END OF THE FIRST PART 7.4--------
	

	
	j read2 #go to the condition of the while loop
		
search:	add x11,x10,x0 #input to argument 2
	add x10,x18,x0 #node address to argument 1
	addi sp,sp,-8 #PUSH 1 : allocate 8 Bytes on the stack
	sw x11,0(sp) #PUSH 2 : save input number(argument 2) into second allocated word
	sw x10,4(sp) #PUSH 2 : save node address(argument 1) into first allocated word
	jal search_list #call search_list function
	lw x11,0(sp) # POP 1: restore input number (argument 2) from stack
	lw x10,4(sp) #  POP 2: restore node address (argument 1) from stack
	addi sp,sp,8 #	POP 3: dealloc the 8 B that I had allocated		
read2:  jal read_int #call read_int function
	add x18,x8,x0 #s2=s0 initialization
	ble x0,x10,search #if 0<=input then print else terminate (loop lasts while input is a positive number or zero)
	addi x17,x0,10 #exit 
	ecall

#END OF MAIN	
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------
#FUNCTIONS


read_int:
	addi x17,x0,5
	ecall
	jr ra,0 #return to the "main" programm ( to the command which is after the call )
	
	
node_alloc:
	addi x17,x0,9 
	addi x10,x0,8
	ecall  #x10 has now the address of the new node
	jr ra,0
	
	
print_node:
	lw x5,0(x10) #x5 =data
	ble x5,x11,exit #if data <= arg 2 goto return
	addi x17,x0,1 #print int
	add x10,x5,x0
	ecall
	addi x17,x0,4 #print "\n"
	la x10,nextline
	ecall  
exit:
	jr ra,0
	
	
	
	
search_list:
	addi sp,sp,-12 #PUSH 1: allocate 8 Bytes on the stack
	sw x1,  8(sp) #PUSH 2: save ra to stack
	sw x10, 4(sp) #PUSH 3: save node address (argument 1) into stack
	sw x11, 0(sp) #PUSH 4: save input number (argument 2) into stack
	jal print_node
	lw x1, 8(sp) #POP 1: restore ra from stack
	lw x10, 4(sp) #POP 2: restore node address (argument 1) into stack
	lw x11 0(sp) #POP 3: restore input number (argument 2)  into stack
	addi sp,sp,12 #POP 4: dealloc the 12 B that I had allocated
	lw x10,4(x10) #x10=nptr (argument 1 takes the value of nptr)
	beq x10,x0,return #if no next nodes read again another number (if nptr == 0 return to the "main")
	j search_list #else o to the beggining of the function
return:  jr ra,0 #this command is executed when there is no next node which means nptr==0
