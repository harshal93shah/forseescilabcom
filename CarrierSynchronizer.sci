function [y,p] = CarrierSynchronizer(in,mod,phoff,sps,tav,nb)
    y=[];
    p=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);

    //CarrierSynchronizer - Compensate for carrier frequency offsetexpand
    //[y] = CarrierSynchronizer(in,mod,phoff,sps,damfac,nlb) ompensates for frequency 
    //and phase offsets in the input signal,X, and returns a compensated signal, Y, and
    // an estimate of the phase error, P, in radians. 
    //The output Y has the same properties as X, 
    //while P is real scalar or column vector having the same dimensions as X.
    //x:input-Input vector signal can be complex
    //mod:Modulation type size for gain updates
    //Specify the modulation type as BPSK, QPSK, 8PSK, QAM, or PAM.
    //phoff:Phase offset:Specify the phase offset in radians as a real scalar
    //sps:SamplesPerSymbol Specify the number of samples per symbol as a positive integer scalar.
    //tav:Damping factor of the loop filter power gain in decibels
    //Specify the damping factor of the loop filter as a positive real finite scalar.
    //nb:NormalizedLoopBandwidth-Normalized bandwidth of the loop filter
    //Specify the normalized loop bandwidth as a real scalar between 0 and 1. 
    //The loop bandwidth is normalized by the sample rate of the synchronizer.
    
    
     //checking conditions on in
    if( or( isnan(in)) | min(size(in))~=1) then
        error("RaisedCosinerxfilter:improper input");
    end
    
     //   checking conditions on Phase offset
    if (~isreal(phoff) | length(phoff)~=1 | isnan(phoff)) then
        error("RaisedCosinetxfilter:improper Phase offset");
    end
    
     //checking condition on samples per symbol
    if (~isreal(sps) | length(sps)~=1 | isnan(sps)|ceil(sps)~=sps|sps<=0) then
        error("RaisedCosinetxfilter:improper  samples per symbol");
    end
    
     //checking condition on Damping factor
    if (~isreal(tav) | length(tav)~=1 | isnan(tav)|tav<=0) then
        error("RaisedCosinetxfilter:improper  Damping factor");
    end
    
     //checking condition on NormalizedLoopBandwidth
    if (~isreal(nb) | length(nb)~=1 | isnan(nb)|nb>1|nb<=0) then
        error("RaisedCosinetxfilter:improper  NormalizedLoopBandwidthl");
    end

    if(~strcmp(mod,'QAM') | ~strcmp(mod,'BPSK') | ~strcmp(mod,'PAM')) then
        x = in.*exp(-%i*phoff);
    elseif(~strcmp(mod,'QPSK')) then
        x = in*exp(%i*(%pi/4-phoff));
    elseif(~strcmp(mod,'8PSK'))  then
        x = in*exp(%i*(%pi/8-phoff));
    else
        error("RaisedCosinetxfilter:Invalid Modulation type")
    end

    len = length(in);
    if(~strcmp(mod,'QAM') | ~strcmp(mod,'QPSK')) then
        e = sign(real(x)).*imag(x)- sign(imag(x)).*real(x);
        kp=2;
    elseif (~strcmp(mod,'8PSK'))  then
        for i = 1:len
            if(real(x(i))>=imag(x(i))) then
                e(i) = (sqrt(2)-1)*sign(real(x(i))).*imag(x(i))- sign(imag(x(i))).*real(x(i));
            else
                e = sign(real(x(i))).*imag(x(i))- (sqrt(2)-1)*sign(imag(x(i))).*real(x(i));
            end
        end

        kp=1;
    else
        e= real(x)*imag(x);
        kp=2;
    end
    disp(tav);
    the = nb/(tav+1/(4*tav));
    d = 1+ 2*tav*the*the^2;
    gi = 4*the^2/(d*kp*sps);
    gp = 4 *tav*the/(d*kp*sps);
    si(1)= gi*e(1);
    lem(1)= 0;
    y(1)=x(1);
    for i= 2:len
        si(i)= gi*e(i)+si(i-1);
        lem(i)=gp*e(i-1)+si(i-1)+lem(i-1);
        y(i)= x(i)*exp(%i*lem(i));
    end
    
    if(~strcmp(mod,'QAM') | ~strcmp(mod,'BPSK') | ~strcmp(mod,'PAM')) then
        y = y.*exp(%i*phoff);
    elseif(~strcmp(mod,'QPSK')) then
        y = y.*exp(-%i*(%pi/4-phoff));
    else
        y = y.*exp(-%i*(%pi/8-phoff));
    end
    
    p =lem;
    
    
    

