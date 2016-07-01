
function [y] = RaisedCosinerxfilter(in,bet,span,sps,varargin)
    y=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);

    //RaisedCosinerxfilter  Apply pulse shaping by decimating signal using raised cosine filter

    //Y = RaisedCosinerxfilter(in,bet,span,sps) 
    //or Y= RaisedCosinerxfilter(in,bet,span,sps,shape)
    //or  Y= RaisedCosinerxfilter(in,bet,span,sps,shape,decfac)
    //or  Y= RaisedCosinerxfilter(in,bet,span,sps,shape,decfac,decoff)
    //or  Y= RaisedCosinerxfilter(in,bet,span,sps,shape,decfac,decoff,gain)
    //he Raised Cosine Transmit Filter block upsamples and filters the input signal using a normal
    // raised cosine FIR filter or a square root raised cosine FIR filter.
    //in: input  -can be any vector
    //bet:RolloffFactor - Specify the rolloff factor as a scalar between 0 and 1. 
    //span:FilterSpanInSymbols-Specify the number of symbols the filter spans as an integer-valued, positive scalar
    //sps:Input samples per symbol - Specify the number of Input samples for each symbol
    //his property accepts an integer-valued, positive scalar value
    //The raised cosine filter has (FilterSpanInSymbols x OutputSamplesPerSymbol + 1) taps.
    //shape:Filter shape -  Specify the filter shape as one of 'normal' or 'squareroot'.
    //The default is Square root.
    //decfac : Decimation factor - Specify the factor by which the object reduces the sampling rate of the input signal.
    //default value is equal to sps. This property accepts a positive integer scalar value between 1 and InputSamplesPerSymbol
    //he value must evenly divide into InputSamplesPerSymbol
    //decoff:DecimationOffset - Specify the number of filtered samples the System object discards before downsampling
    //The default is 0
    //This property accepts an integer valued scalar between 0 and DecimationFactor − 1.
    //gain:Linear filter gain-Specify the linear gain of the filter as a positive numeric scalar
    //The default is 1.he object designs a raised cosine filter that has unit energy, 
    //and then applies the linear gain to obtain final tap values.

    //Author - Harshal Shah

    [LHS,RHS]=argn(0);

    if(RHS==4) then
        shape = 'squareroot';
        decfac = sps;
        decoff=0;
        gain =1;
    elseif(RHS==5) then
        shape = varargin(1);
        decfac = sps;
        decoff=0;
        gain =1;
    elseif(RHS==6) then
        shape = varargin(1);
        decfac = varargin(2);
        decoff=0;
        gain =1;
    elseif(RHS==7) then
        shape = varargin(1);
        decfac = varargin(2);
        decoff=varargin(3);
        gain =1;
    elseif(RHS==8) then
        shape = varargin(1);
        decfac = varargin(2);
        decoff=varargin(3);
        gain =varargin(4);
    else
        error("EVM:Invalid no. of arguments");
    end

    //checking conditions on in
    if( or( isnan(in)) | min(size(in))~=1) then
        error("RaisedCosinerxfilter:improper input");
    end

    //   checking conditions on RolloffFactor
    if (~isreal(bet) | length(bet)~=1 | isnan(bet)|bet<0|bet>1) then
        error("RaisedCosinerxfilter:improper RolloffFactor");
    end

    //checking condition on FilterSpanInSymbols
    if (~isreal(span) | length(span)~=1 | isnan(span)|ceil(span)~=span|span<=0) then
        error("RaisedCosinerxfilter:improper FilterSpanInSymbols");
    end

    //checking condition on Input samples per symbol
    if (~isreal(sps) | length(sps)~=1 | isnan(sps)|ceil(sps)~=sps|sps<=0) then
        error("RaisedCosinerxfilter:improper Input samples per symbol");
    end
    
    //checking condition on Decimation factor
    if (~isreal(decfac) | length(decfac)~=1 | isnan(decfac)|ceil(decfac)~=decfac|decfac<=0|decfac>sps|ceil(sps/decfac)~= (sps/decfac)) then
        error("RaisedCosinerxfilter:improper Decimation factor");
    end
    
    //checking condition on Decimation offset
    if (~isreal(decoff) | length(decoff)~=1 | isnan(decoff)|ceil(decoff)~=decoff|decoff<0|decoff>=decfac) then
        error("RaisedCosinerxfilterC:improper Decimation offset");
    end

    //checking condition on Linear filter gain
    if (~isreal(gain) | length(gain)~=1 | isnan(gain)|ceil(gain)~=gain|gain<=0) then
        error("AGC:improper Linear filter gain");
    end

    taps = sps * span+1;
    if(~modulo(taps,2)) then
        error("RaisedCosinerxfilter:product of sps and span should be even");
    end
    l = ceil(taps/2);
    h=zeros(l,1);
    delay = span*sps/2;
    t = (-delay:delay)/sps;
    if(~strcmp(shape,'normal')) then
        for i= 0:l-1
            if(t(l+i)~=1/(2*bet)) then 
                h(l+i)=sinc(%pi * t(l+i))*cos(%pi * bet *t(l+i))/ (1-(2*bet*t(l+i))^2);
                h(l-i)=h(l+i);
            else 
                h(l+i)=%pi/4*sinc(%pi/(2*bet));
                h(l-i)=h(l+i);
            end
        end
    elseif(~strcmp(shape,'squareroot')) then
        for i= 0:l-1
            if( t(l+i) ~= 1/(4*bet) & t(l+i)~= 0) then 
                h(l+i)=4*bet*(cos((1+bet)*%pi*t(l+i))+sin((1-bet)*%pi *t(l+i))/(4*bet*t(l+i)))/(%pi*(1-(4*bet*t(l+i))^2));
                h(l-i)=h(l+i);
            elseif(t(l+i)==0) then
                h(l+i)=(4*bet/%pi+(1-bet));
                h(l-i)=h(l+i);
            else 
                h(l+i)= bet/sqrt(2)*((1+2/%pi)*sin(%pi/(4*bet))+(1-2/%pi)*cos(%pi/(4*bet)));
                h(l-i)=h(l+i);
            end

        end
    else
        error("AGC:improper Linear filter shape");
    end
    h=h/sqrt(sum(h.^2))* gain;  
    x=filter(h,1,in);
    y = x((1+decoff):decfac:length(x));
endfunction
            



