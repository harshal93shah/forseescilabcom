function [y] = CRCGenerator(in,polynomial,initialstate,chksumsperframe)
    y=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //CRCGenerator Generates Generate CRC code bits and append to input data

    //Y = CRCGenerator(in,polynomial,initialstate,chksumsperframe) outputs y binary sequence
    //after appending CRC code to input bits
    //in:input -  The input must be a binary vector.
    //polynomial - Generator polynomial
    //Specify the generator polynomial as a binary or integer row vector, 
    //with coefficients in descending order of powers
    //Initialstate - Vector array (with length of the generator polynomial order)
    //of initial shift register values (in bits)
    //chksumsperframe - checksumsperframe
    //Number of checksums per input frame
    //Specify the number of checksums that the object calculates for each input frame as a positive integer
    //the integer must divide the length of each input frame evenly.

    //checking conditions on input
    if(~isreal(in) | or( isnan(in)) | min(size(in))~=1 | or(in ~= 0 & in ~= 1)) then
        error("CRCGenerator:improper input");
    end

    //checking conditions on genpoly
    if(~isreal(polynomial) | or( isnan(polynomial)) | min(size(polynomial))~=1 | or(polynomial ~= 0 & polynomial ~= 1)) then
        error("CRCGenerator:improper genpoly");
    end
    if((~polynomial(1)) |(~polynomial(length(polynomial))) ) then
         error("PNsequence:improper genpoly");
    end
    //checking conditions on initial state
    if(~isreal(initialstate) | or( isnan(initialstate)) | min(size(initialstate))~=1 | or(initialstate ~= 0 & initialstate ~= 1)) then
        error("CRCGenerator:improper initialstate");
    end

    //check condition on chksumsperframe
    if (~isreal(chksumsperframe) | length(chksumsperframe)~=1 | isnan(chksumsperframe)|ceil(chksumsperframe)~=chksumsperframe|chksumsperframe<=0) then
        error("CRCGenerator:improper chksumsperframe");
    end

    //chksumsperframe must divide the length of each input frame evenly.
    if(modulo(length(in),chksumsperframe)) then
        error("CRCGenerator:The input length must be an integer multiple of the ChecksumsPerFrame  value");
    end

    //checking that length of Initialstate is equal to degree of genpoly
    if (length(polynomial)~=(length(initialstate)+1) ) then
        error(" length of Initialstate  should be equal to degree of gen poly");
    end
    
    //correcting orentation
    if((size(in,1)~=size(initialstate,1))&(size(in,2)~=size(initialstate,2))) then
        initialstate = initialstate';
    end
    

    m= length(in)/chksumsperframe;
    l=length(initialstate);
    //dividing in frames
    for k=1:chksumsperframe
        buff = initialstate;
        x=in(m*(k-1)+1:m*k);
        //applying method to find CRC on each frame
        for i =1:length(x)
            pre=buff(1);
            for j =1:l-1
               if(polynomial(j+1)) then
                   buff(j)=xor(buff(j+1),pre);
               else
                   buff(j)=buff(j+1);
               end
            end
            buff(l)=xor(x(i),pre);
        end
        y = [ y x buff(:,$:-1:1)];   //ouputing each subframe after appending CRC
    end
endfunction

function c = xor(a,b)
    if(a==b) then
        c=0;
    else 
        c=1;
    end
endfunction 




