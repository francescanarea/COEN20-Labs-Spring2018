/*
void SIMD_USatAdd(uint8_t bytes [], uint32_t count, uint8_t amount) ;
void SIMD_USatSub(uint8_t bytes[], uint32_t count, uint8_t amount) ;
load 40 bytes at a time but # is not always easily /40
one loop to read in 40
one loop to go 4 bytes at a time to finish 36
only update pointer after you store out of
uqadd8,uqsub8
*/
                            .syntax     unified
                            .cpu        cortex-m4
                            .text

                            .global        SIMD_USatAdd
                            .thumb_func
                            .align
SIMD_USatAdd:
                            PUSH            {R4-R12}            //need registers R4-R12 during the loop that takes in 40 bytes at a time
                            BFI             R2,R2,8,8           //copy first byte and paste in second byte
                            BFI             R2,R2,16,16         //copy first half and paste in second half
loop:
                            CMP             R1,40
                            BLT             cleanup
                            LDMIA           R0,{R3-R12}         //loading in 40 bytes into R3-R12
                            UQADD8          R3,R2,R3            //add amount to each register
                            UQADD8          R4,R2,R4
                            UQADD8          R5,R2,R5
                            UQADD8          R6,R2,R6
                            UQADD8          R7,R2,R7
                            UQADD8          R8,R2,R8
                            UQADD8          R9,R2,R9
                            UQADD8          R10,R2,R10
                            UQADD8          R11,R2,R11
                            UQADD8          R12,R2,R12
                            STMIA           R0!,{R3-R12}        //store each register back into array, use write-back to update pointer
                            SUB             R1,R1,40            //decrement count by 40
                            B               loop
cleanup:
                            CBZ             R1,done             //done when count = 0
                            LDR             R3,[R0]             //load 4 bytes
                            UQADD8          R3,R2,R3            //add amount to each of the 4 bytes
                            STR             R3,[R0],4           //store result back into array
                            SUB             R1,R1,4             //decrement count by 4
                            B               cleanup
done:
                            POP             {R4-R12}
                            BX              LR

                            .global        SIMD_USatSub
                            .thumb_func
                            .align
SIMD_USatSub:
                            PUSH            {R4-R12}            //need registers R4-R12 during the loop that takes in 40 bytes at a time
                            BFI             R2,R2,8,8           //copy first byte and paste in second byte
                            BFI             R2,R2,16,16         //copy first half and paste in second half
loop2:
                            CMP             R1,40
                            BLT             cleanup2
                            LDMIA           R0,{R3-R12}         //loading in 40 bytes into R3-R12
                            UQSUB8          R3,R3,R2            //subtract amount from each register
                            UQSUB8          R4,R4,R2
                            UQSUB8          R5,R5,R2
                            UQSUB8          R6,R6,R2
                            UQSUB8          R7,R7,R2
                            UQSUB8          R8,R8,R2
                            UQSUB8          R9,R9,R2
                            UQSUB8          R10,R10,R2
                            UQSUB8          R11,R11,R2
                            UQSUB8          R12,R12,R2
                            STMIA           R0!,{R3-R12}        //store each register back into array, use write-back to update pointer
                            SUB             R1,R1,40            //decrement count by 40
                            B               loop2
cleanup2:
                            CBZ             R1,done2            //done when count = 0
                            LDR             R3,[R0]             //load 4 bytes
                            UQSUB8          R3,R3,R2            //subtract amount from each of the 4 bytes
                            STR             R3,[R0],4           //store result back into array & increment address
                            SUB             R1,R1,4             //decrement count by 4
                            B               cleanup2
done2:
                            POP             {R4-R12}
                            BX              LR
