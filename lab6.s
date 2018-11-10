                            .syntax     unified
                            .cpu        cortex-m4
                            .text

                            .global         PutNibble
                            .thumb_func
                            .align
PutNibble:
                            LSRS            R1,R1,1             //array of bytes so divide by 2
                            ADD             R0,R0,R1            //jump to the byte where the nibble should be stored
                            LDRB            R3,[R0]

                            ITTEE          CS                   //odd, so store into the MS bits
                            ANDCS           R3,R3,0xF           //clear MS 4 bits if odd
                            ORRCS           R3,R3,R2,LSL 4      //shift into MS because odd, then fill in using an or
                            ANDCC           R3,R3,0xF0          //clear LS if even
                            ORRCC           R3,R3,R2            //insert nibble into LS because even
                            STRB            R3,[R0]             //insert nibble back into array
                            BX              LR

                            .global         GetNibble
                            .thumb_func
                            .align
GetNibble:
                            LSRS            R1,R1,1             //array of bytes so divide by 2
                            ADD             R0,R0,R1            //jump to byte where nibble will be found
                            LDRB            R2,[R0]             //load the byte into R3

                            ITE             CC
                            ANDCC           R0,R2,0xF           //if even, clear MS
                            LSRCS           R0,R2,4             //if odd, move to LS to prepare for return

                            BX              LR

                            .end
