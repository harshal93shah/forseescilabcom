function [y] = DifferentialEncoder(x,ic)
     y=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //DifferentialEncoder Encodes the input data differntially

    //Y = DifferentialEncoder(x,ic) outputs binary data y(column vector)
    //by differntial encoding he input data. Returns 1 if data is same
    //x can be any vector
    //ic indicates initial conditions and it could be any number
    
    //Author - Harshal Shah
    
    //checking conditions on x
    if(~isreal(x) | or( isnan(x)) | min(size(x))~=1) then
        error("DifferentialEncoder:improper input");
    end
    
     if (~isreal(ic) | length(ic)~=1 | isnan(ic)) then
         error("DifferentialEncoder:improper intial conditions");
    end
    
    y(1)= xor(x(1),ic);
    for i=2:length(x)
        y(i)= xor(x(i),x(i-1));
    end
endfunction

function c = xor(a,b)
    if(a==b) then
        c=0;
    else 
        c=1;
    end
    endfunction 
