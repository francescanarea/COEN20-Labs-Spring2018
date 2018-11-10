#include <math.h>

// takes in both an input and output array and converts the input array into twos complement, storing the result in output
void  TwosComplement(const int input[8], int output[8]){
    // flip all bits after the first occurrence of a 1.  flip is 0 when false and 1 when true.
    int flip = 0;
    for(int i = 0; i < 8; i++){
            // when flip is false and a 1 is found, flip is changed to true. copy over the bit as is
            if(flip == 0 && input[i] == 1){
                    flip = 1;
                    output[i] = input[i];
            }
            // if flip is true, flip the input bit
            else if(flip == 1){
                     // if the bit is 1, will increment by 1 = 2, then mod 2 = 0; if bit is 0, will add 1 = 1, mod 2 = 1
                    output[i] = (input[i]+1)%2;
            }
            // if flip is false, copy over the bit as is
            else{
                    output[i] = input[i];
            }
    }
}

// converts a given binary to decimal and outputs the binary's decimal representation
float Bin2Dec(const int bin[8]){
    float dec = bin[7]*(-1); //least significant bit
    // for loop to examine each bit of binary stored in array
    for(int i = 6; i >= 0; i--){
            // to avoid using pow, use repeated doubling of 2's in order to get the powers of 2
            dec = 2*dec + bin[i];
    }
    // return decimal float, div by 128 (opposite of dec2bin * by 128)
    return dec/128;
}

// converts a given decimal value to its binary equivalent and saves the result in array bin
void  Dec2Bin(const float x, int bin[8]){
    // setup for being able to treat the float as a positive int for rep div (for cases when input is neg or a number with a fractional part)
    float z = fabs(x*128);

    // round down to cast float to int
    int y = (int)z;

    // round up when the fractional part is >=.5, and also make sure that do not round above +127 limit (however it is negative, can round up to 128)
    if((z-y) >= .5 && y != 127){
            y++;
    }

    //now, use repeated division with y (-128<=y<=127)
    for(int i = 0; i < 8; i++){
            bin[i] = y%2;
            y /= 2;
    }

    // if the decimal number is negative, must convert bin to twos complement
    if(x<0){
            TwosComplement(bin, bin);
    }
}
