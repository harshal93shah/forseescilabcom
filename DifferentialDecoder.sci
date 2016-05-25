function [y] = DifferentialDecoder(x,ic)
     y=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //DifferentialEncoder Decodes differentially encoded signal

    //Y = DifferentialDecoder(x,ic) outputs binary data y(column vector)
    //by decoding differntially encoded  he input data. 
    //x can be any vector
    //ic indicates initial conditions and it could be any number
    
    //Author - Harshal Shah
    
    //checking conditions on x
    if(~isreal(x) | or( isnan(x)) | min(size(x))~=1) then
        error("DifferentialDecoder:improper input");
    end
    
     if (~isreal(ic) | length(ic)~=1 | isnan(ic)) then
         error("DifferentialDecoder:improper intial conditions");
    end
    
    y(1)= xor(x(1),ic);
    for i=2:length(x)
        y(i)= xor(x(i),y(i-1));
    end
endfunction

function c = xor(a,b)
    if(a==b) then
        c=0;
    else 
        c=1;
    end
    endfunction 
