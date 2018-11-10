                            .syntax     unified
                            .cpu        cortex-m4
                            .text

                            .global         DeleteItem
                            .thumb_func
                            .align
DeleteItem:
                            ADD             R0,R0,R2,LSL 2        //R0 <- pointer to value to be deleted
                            SUB             R1,R1,1
top:
                            CMP             R2,R1                 //while index < items-1, continue loop
                            BGE             done                  //if index >= items, quit loop
                            LDR             R3,[R0,4]             //R3 <- value of next element, pre indexed addressing
                            STR             R3,[R0],4             //storing R3 into R0 (the next value into current value), post-index addressing
                            ADD             R2,R2,1               //incrementing index
                            B               top
done:
                            BX              LR

                            .global         InsertItem
                                            .thumb_func
                                           .align
InsertItem:
                            PUSH            {R4}
                            SUB             R1,R1,1                //R1 <- items-1
                            ADD             R0,R0,R1,LSL 2         //R0 <- pointer to last item
top2:
                            CMP             R1,R2                  //as long as R1 (index) > index of item to add
                            BLE             done2
                            LDR             R4,[R0,-4]             //pre-indexed addressing to get the value before
                            STR             R4,[R0],-4             //store value of previous element into element ahead of it, post-indexed addressing
                            SUB             R1,R1,1                //decrementing index
                            B               top2
done2:
                            STR             R3,[R0]                //final store of value in the end
                            POP             {R4}
                            BX              LR


