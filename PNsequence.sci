function [y,currstate] = PNsequence(genpoly,initialstate,opmask,nbitsout)
     y=[];
     currstate=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //PNsequence Generates PN sequence

    //Y = PNsequence(genpoly,initialstate,opmask,nbitsout) outputs y binary pn sequence(column vector)
    //and currstate i.e current state of shift register
    //genpoly - Generator polynomial is vector array of bits; must be descending order.
    //Initialstate - Vector array (with length of the generator polynomial order)
    //of initial shift register values (in bits)
    //opmask  -Outout mask vector of binary 0 and 1 values is used to specify which 
    //shift register state bits are XORed to produce the resulting output bit value.
    //Initialstate and opmask should have same length and should be equal to degree of gen poly
    //   
    //nbitsout - number of outputbits
    
    //Author - Harshal Shah
    
    //checking conditions on genpoly
    if(~isreal(genpoly) | or( isnan(genpoly)) | min(size(genpoly))~=1 | or(genpoly ~= 0 & genpoly ~= 1)) then
        error("PNsequence:improper genpoly");
    end
    if(~genpoly(1)) then
         error("PNsequence:improper genpoly");
    end
  
    //checking conditions on initial state
    if(~isreal(initialstate) | or( isnan(initialstate)) | min(size(initialstate))~=1 | or(initialstate ~= 0 & initialstate ~= 1)) then
        error("PNsequence:improper initialstate");
    end
    //checking conditions on hecking conditions on initial stat
    if(~isreal(opmask) | or( isnan(opmask)) | min(size(opmask))~=1 | or(opmask ~= 0 & opmask ~= 1)) then
        error("PNsequence:improper opmask");
    end
    //checking conditions on inbitsout
    if (~isreal(nbitsout) | length(nbitsout)~=1 | isnan(nbitsout)|ceil(nbitsout)~=nbitsout|nbitsout<=0) then
        error("PNsequence:improper nbitsout");
    end
    
    //checking that length of Initialstate, genpoly and opmask are equal
    if (length(genpoly)~=(length(initialstate)+1) | length(initialstate)~=length(opmask)) then
        error(" Initialstate and opmask should have same length and should be equal to degree of gen poly");
    end
    
    buff = initialstate; 
    for i = 1:nbitsout
        //generating output bit
        y(i)=maskedxor(buff,opmask);
        //generating next beet to feed in shift register
        k = maskedxor(buff,genpoly(2:length(genpoly)));
        //shifting the register
        buff = shift(buff,k);
    end
    currstate = buff;
endfunction

function out = shift(in,k)
    out=[];
    for i =length(in):-1:2
        out(i)=in(i-1);
    end
    out(1)=k;
endfunction

function y = maskedxor(in,mask)
    y=0;
    for i=1:length(in)
        if(mask(i)) then
        y=y+in(i);    
        end
    end
    y=modulo(y,2);
endfunction




