function [y] = Scrambler(N,in,polynomial,initialstate)
      y=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //Scrambler The Scrambler object scrambles a scalar or column vector input signal.

    //Y = Scrambler(CalculationBase,in,polynomial,initialstate) outputs vector y after
    //scrambling the input data
    //N:CalculationBase-Range of input data
    //Specify calculation base as a positive, integer, scalar value. 
    //Set the calculation base property to one greater than the number of input values
    //in:input -  The input must be a  vector in the range [0, CalculationBase–1].
    //polynomial - Generator polynomial
    //Specify the generator polynomial as a binary  vector, 
    //that lists the coefficients of the polynomial in order of ascending powers of z–1
    //eg. specify 1 + z^(-6) + Z^(-7) as [1 0 0 0 0 0 1 1]
    //Initialstate - Vector array (with length of the generator polynomial order)
    //of initial shift register values  vector with values in [0 CalculationBase–1]
    
    //Author - Harshal Shah
    
    //check condition on CalculationBase
    if (~isreal(N) | length(N)~=1 | isnan(N)|ceil(N)~=N|N<=0) then
        error("Scrambler:improper CalculationBase");
    end
    
    //checking conditions on input
    if(~isreal(in) | or( isnan(in)) | min(size(in))~=1 | or(in < 0) | or(in >= N )) then
        error("Scrambler:improper input");
    end
    
    //checking conditions on genpoly
    if(~isreal(polynomial) | or( isnan(polynomial)) | min(size(polynomial))~=1 | or(polynomial ~= 0 & polynomial ~= 1)) then
        error("Scrambler:improper genpoly");
    end
    
    if((~polynomial(1)) |(~polynomial(length(polynomial))) ) then
         error("Scrambler:improper genpoly");
    end
    
    //checking conditions on initial state
    if(~isreal(initialstate) | or( isnan(initialstate)) | min(size(initialstate))~=1 |  or(initialstate < 0) | or(initialstate >= N )) then
        error("Scrambler:improper initialstate");
    end
    
      //checking that length of Initialstate is equal to degree of genpoly
    if (length(polynomial)~=(length(initialstate)+1) ) then
        error(" Scrambler:length of Initialstate  should be equal to degree of gen poly");
    end
    
    buff = initialstate;
    for i = 1:length(in)
        y(i) = in(i);
        for j =length(initialstate):-1:1
            if(polynomial(j+1)) then
                y(i) = y(i) + buff(j);
            end
            if(j>1) then
                buff(j)=buff(j-1);
            end
        end
        y(i) = modulo(y(i),N);
        buff(1)=y(i);
    end
    
endfunction        
        
        
            
            
  
    
    
