                    .syntax     unified
                    .cpu        cortex-m4
                    .text

                    .global     PixelAddress
                    .thumb_func
                    .align
PixelAddress:

                    LDR         R2,=240
                    #calculates the kth word of the array
                    MLA         R3,R1,R2,R0
                    #calculate the address based on the starting address
                    LDR         R0,=0xD0000000
                    #go forward by 4*k because 32 bits=4bytes
                    LSL         R3,R3,2
                    ADD         R0,R0,R3
                    BX          LR

                    .global     BitmapAddress
                    .thumb_func
                    .align
BitmapAddress:
                    #calculate how many bytes per row
                    PUSH        {R4}
                    #calculate the number of the char within the font table
                    SUB         R4,R0,' '

                    #calculate how many bytes per row using given formula
                    ADD         R0,R3,7
                    LSR         R0,R0,3
                    #calculate the shift using the number of the char
                    MUL         R0,R4,R0

                    #calculate how many bytes per col, then add on row shift
                    # num*n + num*height
                    MUL         R0,R0,R2

                    #jumps from first index of font table to the ascii char based on calculated numbers
                    ADD         R0,R0,R1

                    POP         {R4}
                    BX          LR

                    .global     GetBitmapRow
                    .thumb_func
                    .align
GetBitmapRow:
                    LDR         R0,[R0]
                    #reverses the row and stores into R0
                    REV         R0,R0
                    BX          LR
