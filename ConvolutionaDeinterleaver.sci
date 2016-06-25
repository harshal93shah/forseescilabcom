function [y,state,index] = ConvolutionalDeinterleaver(in,nrows,slope,inist,stindex)
    y=[];
    state=[];
    index=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);
    //ConvolutionalDeinterleaver Restore ordering of symbols using specified-delay shift registers.
    //[y,state,index] = ConvolutionalDeinterleaver(in,delay,inist)..Restore ordering of 
    //internal shift registers, each with its own delay value.
    //it also returns the current state of shift register as matrix
    //and the value of next index from which we would get output
    //in:input- can be any scalar vector
    //nrows:number of rows- no of shift register present
    //slope- The number of additional symbols that fit in each successive shift register, 
    //where the first register holds zero symbols.
    //inist:Initialstate- Initial conditions of shift registers
    //Specify the initial values in each shift register as a numeric scalar value or a 
    //matrix. . When you set this property to a matrix, the size should be equal to
    // no of shiftregister * max delay r. This matric contains initial conditions,
    //Here the orignal delay elements are for ith element is max(delay)-delay
    // where the (i,j)is of jth element of i-th shift register.the irrelevant element 
    //doesn't matter. for eg nrow=2, slope =2  matrix with (2,1) and (2,2) elements
    //irrelevant
    //stindex:start index- which shift register will give first ouput. it should be scalar 
    //less than no of shift register

    //Author - Harshal Shah

    
     //   checking conditions on no of rows
    if (~isreal(nrows) | length(nrows)~=1 | isnan(nrows)|nrows<=0) then
        error("ConvolutionalDeinterleaver:improper nrows");
    end
    
      //   checking conditions on slope
    if (~isreal(slope) | length(slope)~=1 | isnan(slope)|slope<0) then
        error("ConvolutionalDeinterleaver:improper slope");
    end
   
   for i =1:nrows
       delay(i)= (i-1)*slope; 
   end
[y,state,index] = MultiplexedDeinterleaver(in,delay,inist,stindex)
   

endfunction
