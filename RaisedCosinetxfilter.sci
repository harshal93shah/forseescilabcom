
function [y] = RaisedCosinetxfilter(in,bet,span,sps,varargin)
    y=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);

    //RaisedCosinetxfilter  Apply pulse shaping by upsampling signal using raised cosine FIR filter

    //Y = RaisedCosinetxfilter(in,bet,span,sps) 
    //or Y= RaisedCosinetxfilter(in,bet,span,shape)
    //or  Y= RaisedCosinetxfilter(in,bet,span,shape,gain)
    //he Raised Cosine Transmit Filter block upsamples and filters the input signal using a normal
    // raised cosine FIR filter or a square root raised cosine FIR filter.
    //in: input  -can be any vector
    //bet:RolloffFactor - Specify the rolloff factor as a scalar between 0 and 1. 
    //span:FilterSpanInSymbols-Specify the number of symbols the filter spans as an integer-valued, positive scalar
    //sps:Output samples per symbol - Specify the number of output samples for each input symbol
    //his property accepts an integer-valued, positive scalar value
    //The raised cosine filter has (FilterSpanInSymbols x OutputSamplesPerSymbol + 1) taps.
    //shape:Filter shape -  Specify the filter shape as one of 'normal' or 'squareroot'.
    //The default is Square root.
    //gain:Linear filter gain-Specify the linear gain of the filter as a positive numeric scalar
    //The default is 1.he object designs a raised cosine filter that has unit energy, 
    //and then applies the linear gain to obtain final tap values.

    //Author - Harshal Shah

    [LHS,RHS]=argn(0);

    if(RHS==4) then
        shape = 'squareroot';
        gain =1;
    elseif(RHS==5) then
        shape = varargin(1);
        gain =1;
    elseif(RHS==6) then
        shape = varargin(1);
        gain = varargin(2);
    else
        error("RaisedCosinetxfilter:Invalid no. of arguments");
    end

    //checking conditions on in
    if( or( isnan(in)) | min(size(in))~=1) then
        error("RaisedCosinetxfilter:improper input");
    end

    //   checking conditions on RolloffFactor
    if (~isreal(bet) | length(bet)~=1 | isnan(bet)|bet<0|bet>1) then
        error("RaisedCosinetxfilter:improper RolloffFactor");
    end

    //checking condition on FilterSpanInSymbols
    if (~isreal(span) | length(span)~=1 | isnan(span)|ceil(span)~=span|span<=0) then
        error("RaisedCosinetxfilter:improper FilterSpanInSymbols");
    end

    //checking condition on Output samples per symbol
    if (~isreal(sps) | length(sps)~=1 | isnan(sps)|ceil(sps)~=sps|sps<=0) then
        error("RaisedCosinetxfilter:improper Output samples per symbol");
    end

    //checking condition on Linear filter gain
    if (~isreal(gain) | length(gain)~=1 | isnan(gain)|ceil(gain)~=gain|gain<=0) then
        error("RaisedCosinetxfilter:improper Linear filter gain");
    end

    taps = sps * span+1;
    if(~modulo(taps,2)) then
        error("AGC:product of sps and span should be even");
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
    x=zeros(length(in)*sps,1);
    for i =1: length(x)
        if(modulo(i,sps)==1) then
           x(i)=ceil(i/sps);
        end
    end
    y=filter(h,1,x);
endfunction
            



