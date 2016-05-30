function [y] = HadamardCode(len,index,opsamples)
    y=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //HadamardCode Generate hadamard code

    //Y = HadamardCode(len,opsamples)) outputs a frame of the hadamard
    // code in column vector Y. It generates a Hadamard code from a Hadamard 
    //matrix, whose rows form an orthogonal set of codes
    //len- length of generated code Specify the length of the generated code as a numeric, 
    //integer scalar value with a power of two
    //index - Row index of Hadamard matrix
    //Specify the row index of the Hadamard matrix as a numeric, integer scalar 
    //value in the range [0, 1, ... , N-1]. N is the value of the Length property
    //Number of output samples per frame
    //It shoud be numeric positive scalar value

    //Author - Harshal Shah

    //check conditions on length
    k=log2(len);
    if (~isreal(len) | length(len)~=1 | isnan(len)|len<=0|ceil(k)~=k ) then
        error("HadamardCode:improper length");
    end

    //check condition on index
    if (~isreal(index) | length(index)~=1 | isnan(index)|ceil(index)~=index|index<0|index>(len-1)) then
        error("HadamardCode:improper index");
    end

    //check condition on opsamples
    if (~isreal(opsamples) | length(opsamples)~=1 | isnan(opsamples)|ceil(opsamples)~=opsamples|opsamples<=0) then
        error("HadamardCode:improper output samples");
    end

    H= [1 1; 1 -1];

    for i =2:k
        H= [H H; H -H];
    end

    haco = H(index+1,:);

    for i =0:opsamples-1
        y(i+1)=haco(modulo(i,len)+1);   
    end

endfunction






