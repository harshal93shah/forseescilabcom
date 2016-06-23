function [y,state,index] = MultiplexedDeinterleaver(in,delay,inist,stindex)
    y=[];
    state=[];
    index=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);
    //MultiplexeDeinterleaver Restore ordering of symbols using specified-delay shift registers
    //[y,state,index]= MultiplexeDeinterleaver(in,delay,inist).Restore ordering of 
    //symbols using specified-delay shift registers
    //it also returns the current state of shift register as matrix
    //and the value of next index from which we would get output
    //in:input- can be any scalar vector
    //delay-Specify the lengths of the shift registers as an integer  vector
    //inist:Initialstate- Initial conditions of shift registers
    //Specify the initial values in each shift register as a numeric scalar value or a 
    //matrix. . When you set this property to a matrix, the size should be equal to
    // no of shiftregister * max delay . Here the orignal delay elements are for ith element is max(delay)-delay
    // This matric contains initial conditions,
    // where the (i,j)is of jth element of i-th shift register.the irrelevant element 
    //doesn't matter. for eg delay = [2,4], inist = 2*2 matrix with (2,1) and (2,2) elements
    //irrelevant
    //stindex:start index- which shift register will give first ouput. it should be scalar 
    //less than no of shift register

    //Author - Harshal Shah

    //checking conditions on input
    if(~isreal(in) | or( isnan(in)) | min(size(in))~=1 ) then
        error("MultiplexeDeinterleaver:improper input");
    end

    //checking conditions on delay
    if(~isreal(delay) | or( isnan(delay)) | min(size(delay))~=1 | or(ceil(delay)~=delay)) then
        error("MultiplexeDeinterleaver:improper input");
    end

    len = length(delay);    
     di = max(delay)-delay;
    delay=di;
    //checking conditions on initialstate
    if (~isreal(inist) | ( length(inist)~=1 & or(size(inist) ~= [len max(delay)]))| isnan(inist)) then
        error("MultiplexeDeinterleaver:improper intial conditions");
    end
    
     //   checking conditions on start index
    if (~isreal(stindex) | length(stindex)~=1 | isnan(stindex)|stindex<0|stindex>len) then
        error("MultiplexeDeinterleaver:improper stindex");
    end
    
   
    
    if(length(inist)==1) then
        buff = zeros(len,max(delay)); 
    else 
        buff=inist;
    end

    index =stindex;
    for i = 1:length(in)
        if(~delay(index)) then
            y(i)=in(i);
        else
            y(i)=buff(index,delay(index));
            for j = delay(index):-1:2
                buff(index,j)=buff(index,j-1);
            end
            buff(index,1)=in(i);
        end
        index = modulo(index,len) +1;
    end
    state = buff;  
endfunction
