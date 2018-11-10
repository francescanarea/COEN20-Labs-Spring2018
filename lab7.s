                            .syntax     unified
                            .cpu        cortex-m4
                            .text

                             .global       CallReturnOverhead
                            .thumb_func
                            .align
CallReturnOverhead:
                            BX             LR

                             .global       UDIVby13
                            .thumb_func
                            .align
UDIVby13:
                            MOVS.N         R1,13
                            UDIV           R0,R0,R1
                            BX             LR

                             .global       SDIVby13
                            .thumb_func
                            .align
SDIVby13:

                            MOVS.N          R1,13
                            SDIV            R0,R0,R1
                            BX              LR

                            .global         MySDIVby13
                            .thumb_func
                            .align
MySDIVby13:

                            LDR             R1,=0x4EC4EC4F          //multiply by 2*N/d = 2^34/13. used 2^34 and not 2^32 because gives more precision; overall multiplying by constant optimizes # clock cycles for division & keep precision
                            SMMUL           R1,R1,R0                //R1 <- bits 63-32 of R1xR0, only takes upper bits because treating the 64 bit mult as a 32 bit #
                            ASRS.N          R1,R1,2                 //by taking only the most sig 32 bits from before, we shifted by 2^32 but we multiplied by 2^34 initially so must shift by 4 to divide by 4 to fully divide out constant now; .N allows for use of a 16 bit instruction if available to increase efficiency
                            ADD             R0,R1,R0,LSR 31         //adding in the sign, so 31 bit shift for the sign to be most significant bit
                            BX              LR

                            .global         MyUDIVby13
                            .thumb_func
                            .align
MyUDIVby13:
                            LDR             R1,=0x4EC4EC4F          //multiply by 2*N/d = 2^34/13. used 2^34 and not 2^32 because gives more precision; overall multiplying by constant optimizes # clock cycles for division & keep precision
                            UMULL           R2,R1,R1,R0             //R1.R2 <- R1xR0, this time keeping the full 64 bit product
                            LSRS.N          R0,R1,2                 //since multiplied by 2^34 initially, even after taking only the 32 most significant bits, we have to compensate for the bigger constant by doing this additional shift, .N allows for use of a 16 bit instruction if available to increase efficiency
                            BX              LR
                            .end

