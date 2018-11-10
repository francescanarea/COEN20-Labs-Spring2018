            .syntax     unified
            .cpu        cortex-m4
            .text

            #program to test data copying timing

            .global     UseLDRB
            .thumb_func
            .align
            #copies 1 byte at a time, uses LDRB/STRB
UseLDRB:
            #since 1 byte at a time, need to rept 512x
            .rept       512
            #uses post-indexed addressing mode, increment by 1 byte
            LDRB        R2,[R1],1
            STRB        R2,[R0],1
            .endr
            #return to main program control
            BX          LR

            .global     UseLDRH
            .thumb_func
            .align
            #copies 2 bytes at a time, uses LDRH/STRH
UseLDRH:
            #rept 256x since 2 bytes/rept --> 512/2
            .rept       256
            #uses post-indexed addressing mode, increment by 2 bytes
            LDRH        R2,[R1],2
            STRH        R2,[R0],2
            .endr
            BX          LR

            .global     UseLDR
            .thumb_func
            .align
            #copies 4 bytes at a time, uses LDR/STR
UseLDR:
            #rept 128x since 4 bytes/rept --> 512/4
            .rept       128
            #post-indexed addressing, increment by 4 bytes
            LDR         R2,[R1],4
            STR         R2,[R0],4
            .endr
            BX          LR

            .global     UseLDRD
            .thumb_func
            .align
            #copies 8 bytes at a time, uses LDRD/STRD
UseLDRD:
            #rept 64x since 8 bytes/rept --> 512/8
            .rept       64
            #post-indexed addressing, increment by 8 bytes
            LDRD        R2,R3,[R0],8
            STRD        R2,R3,[R1],8
            .endr
            BX          LR

            .global     UseLDMIA
            .thumb_func
            .align
            #copies 32 bytes at a time using LDMIA/STMIA and write back flag
UseLDMIA:
            #need to push the registers to copy 32bytes at a time
            PUSH        {R4-R9}
            #copying 32 bytes at a time so rept 16x  --> 512/32
            .rept       16
            #loads and stores to R2-R9; uses write back flag (!)
            LDMIA       R1!,{R2-R9}
            STMIA       R0!,{R2-R9}
            .endr
            #restore registers
            POP         {R4-R9}
            BX          LR

            .end
