            .syntax     unified
            .cpu        cortex-m4
            .text

            #loads R0 with 10, then returns control to main program
            .global     Ten32
            .thumb_func
            .align

Ten32:      LDR         R0,=10
            BX          LR

            #loads R0 with 10 and R1 with 0 to extend to 64 bit, so will return R1.R0 (32 0s in front of 10 in binary
            .global     Ten64
            .thumb_func
            .align

Ten64:      LDR         R0,=10
            LDR         R1,=0
            BX          LR

            #adds one to R0
            .global     Incr
            .thumb_func
            .align

Incr:       ADD         R0, R0, 1
            BX          LR

            #returns rand number +#branches to random func 1
            .global     Nested1
            .thumb_func
            .align

            #push LR to stack because executing function call
Nested1:    PUSH        {LR}
            #branches to random func
            BL          rand
            #adds 1 to output of rand number stored in R0
            ADD         R0,R0,1
            #returns control to main program: PC can be used instead of POP{LR} and BX LR because ProgramCounter points to return location in main program
            POP         {PC}

            #returns the sum of 2 random numbers
            .global     Nested2
            .thumb_func
            .align

Nested2:    PUSH        {R4, LR}
            BL          rand
            #preserves the first random number is R4
            MOV         R4,R0
            #gets the second random number
            BL          rand
            ADD         R0,R0,R4
            #pops R4 from the stack and returns control to main program
            POP         {R4, PC}

            #calls printf twice
            .global     PrintTwo
            .thumb_func
            .align

PrintTwo:   PUSH        {R4,R5,LR}
            #preserves R0,R1 parameters (format,n)
            MOV         R4, R0
            MOV         R5, R1
            BL          printf
            #recopies preserved R0,R1 from R4,R5
            MOV         R0,R4
            MOV         R1,R5
            #increments R1
            ADD         R1,R1,1
            BL          printf
            #returns control to main program and pops R4,R5 from the stack
            POP        {R4,R5,PC}

            .end
