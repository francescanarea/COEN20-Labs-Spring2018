                            .syntax     unified
                            .cpu        cortex-m4
                            .text

                            .global        FloatPoly
                            .thumb_func
                            .align
FloatPoly:

                            VMOV           S1,S0                    //S1 <- x
                            VLDMIA         R0!,{S2}                 //S3 <- R0[i], updates address

                            SUB            R1,R1,1                  //n -= 1 because first element is outside of loop
top:
                            CMP            R1,0                     //when n == 0, done
                            BEQ            done
                            VLDMIA         R0!,{S3}                 //S3 <- R0[i], updates address
                            VMLA.F32       S2,S1,S3                 //s2 <- s2 + R0[i]*x^i
                            VMUL.F32       S1,S0,S1                 //S1 <- x^i
                            SUB            R1,R1,1                  //n -= 1 for control
                            B              top
done:
                            VMOV           S0,S2                    //return result in S0
                            BX             LR

                            .global        FixedPoly
                            .thumb_func
                            .align
FixedPoly:
                            PUSH           {R4,R5,R6,R7}
                            LDR            R3,=0                    //set-up for using 64 bit sum to not lose precision
                            LDR            R4,=0
                            MOV            R5,1<<16                 //x^i = x^0 = 1, 64 bit
                            LDR            R6,=0
top2:
                            CMP            R2,0                     //when n == 0, done
                            BEQ            done2
                            LDMIA          R1!,{R7}                 //R7 <- a[i]
                            SMLAL          R3,R4,R5,R7              //R4.R3 <- R4.R3 + a[i]*x^i
                            SMULL          R5,R6,R5,R0              //R6.R5 <- middle 32 * x = x^i
                            LSRS.N         R5,R5,16                 //extract middle 32 bits of x^i
                            ORR            R5,R5,R6,LSL 16
                            SUB            R2,R2,1                  //n -= 1 for control
                            B              top2
done2:
                            LSRS.N         R3,R3,16                 //extract middle 32 from sum registers
                            ORR            R3,R3,R4,LSL 16
                            MOV            R0,R3
                            POP            {R4,R5,R6,R7}
                            BX             LR
