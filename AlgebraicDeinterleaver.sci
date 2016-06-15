function [y] = AlgebraicDeinterleaver(in,method,len,varargin)
    y=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //AlgebraicDeinterleaver The Algebraic Deinterleaver  
    //restores the original ordering of a sequence that was interleaved
    //The algebraic deinterleaver performs all computations in modulo N, where N is the length
    //in:input -  The input must be a  vector in the range [0, N–1].

    //Y = AlgebraicDeinterleaver(in,'taco',len,MF,CS) outputs the elements of input using 
    //Takeshita-Costello method
    //len: Length-Number of elements in input vector.
    //Specify the number of elements in the input as a positive, integer, scalar.
    //the value of the Length property requires a power of two
    //MF:-specify the factor the object uses to compute 
    //the cycle vector for the interleaver as a positive, integer, scalar.
    //CS:CyclicShift-specify the amount by which the object shifts indices, 
    //when it creates the final permutation vector, as a nonnegative, integer, scalar

    ///Y = AlgebraicDeinterleaver(in,'weco',len,PE) outputs the elements of input using 
    //Welch-Costas method
    //len: Length-Number of elements in input vector.
    //Specify the number of elements in the input as a positive, integer, scalar.
    //the value of (N+1) must be a prime number, where N is Length . 
    //PF:PrimitiveElement- You must set the PrimitiveElement property to an integer, 
    //A, between 1 and N.
    // This integer represents a primitive element of the finite field GF(N+1).

    //Author - Harshal Shah


    [LHS,RHS]=argn(0);

    //checking conditions on input
    if(~isreal(in) | or( isnan(in)) | min(size(in))~=1 | length(in)~= len) then
        error("AlgebraicDeinterleaver:improper input");
    end

    // For Takeshita-Costello method
    if(~strcmp(method,'taco')) then
        //Checking if no. of arguments are proper
        if (RHS ~=5) then
            error("AlgebraicDeinterleaver:Invalid no. of arguments");
        end

        MF = varargin(1);
        CS = varargin(2);

        //check conditions on length
        k=log2(len);
        if (~isreal(len) | length(len)~=1 | isnan(len)|len<=0|ceil(k)~=k ) then
            error("AlgebraicDeinterleaver:improper length");
        end

        //check conditions on MultiplicativeFactor
        if (~isreal(MF) | length(MF)~=1 | isnan(MF)|MF<=0|MF>=len) then
            error("AlgebraicDeinterleaver:improper MultiplicativeFactor");
        end

        //check conditions on CyclicShift
        if (~isreal(CS) | length(CS)~=1 | isnan(CS)|CS<0) then
            error("AlgebraicDeinterleaver:improper CyclicShift");
        end

        for i = 1:len
            c(i)=modulo((MF*i*(i-1)/2),len)+1;
        end

        for i =1:len-1
            p(c(i))=c(i+1);
        end
        p(c(len))=c(1);


        // For Welch-Costas method
    elseif(~strcmp(method,'weco')) then
        if (RHS ~=4) then
            error("AlgebraicDeinterleaver:Invalid no. of arguments");
        end
        PE=varargin(1);

        //check conditions on length
        if (~isreal(len) | length(len)~=1 | isnan(len)|len<=0) then
            error("AlgebraicDeinterleaver:improper length");
        end
        for i = 2:(len-1)
            if(modulo(len+1,i)==0) then
                error("AlgebraicDeinterleaver:length + 1 should be prime");
            end
        end

        //check conditions on PrimitiveElement
        if(~isreal(PE) | or( isnan(PE)) | min(size(PE))~=1 | (PE <= 0) | (PE >= len )) then
            error("AlgebraicDeinterleaver:improper PrimitiveElement");
        end

        num = ones(len,1);
        for i= 1:len
            num(modulo((PE^i),len+1))=0;
        end
        if(or(num)) then
            error("Descrambler:AlgebraicDeinterleaver PrimitiveElement");
        end

        for i =0:len-1
            p(i+1)=modulo(PE^i,len+1);

        end
        CS=0;

    else
        error("AlgebraicDeinterleaver:improper Method");
    end
    
    //changing input accroding to permutation vector

    for i = 1:len
        k=modulo(i+CS,len);
        if(k==0) then
            k=len;
        end
        y(p(k))=in(i);
    end
endfunction









