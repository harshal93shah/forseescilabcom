function [rmsEVM,maxEVM,perEVM] = EVM(rxsg,txsg,normmeth,xper,varargin)
    rmsEVM = [];
    maxEVM=[];
    maxEVM=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);

    //EVM The EVM Measurement fn measures the error vector magnitude (EVM), 
    //which is an indication of modulator or demodulator performance.
    //The block normalizes to the average reference signal power, 
    //average constellation power, or peak constellation power.
    //rmsEVM- gives root mean square of evm values over N symbols  
    // The maximum EVM represents the worst-case EVM value per burst
    //Xth percentile is the EVM value below which X% of all the computed EVM values lie

    //[[rmsEVM,maxEVM,perEVM] = EVM(rxsg,txsg,normmeth,xper,varargin)
    //rxsg:received signal- A vector
    //txsg:transmitted - A vector
    //xper:X-percentile value above which X% of the MER measurements fall, 
    //specified as a real scalar from 0 to 100
    //[rmsEVM,maxEVM,perEVM] = EVM(rxsg,txsg,'avgrefsigpow',xper)
    //normalizes w.r.t avg sig power
    //[rmsEVM,maxEVM,perEVM] = EVM(rxsg,txsg,'peakconpow',xper,pcon)
    //normalizes w.r.t peak constellation power pcon
    //[rmsEVM,maxEVM,perEVM] = EVM(rxsg,txsg,'avgconpow',xper,pcon)
    //normalizes w.r.t average constellation power pcon

    // Author - Harshal Shah
    //checking conditions on transmitted signal
    
    [LHS,RHS]=argn(0);
    if( min(size(txsg))~=1 ) then
        error("EVM:improper transmitted signal");
    end
    //   checking conditions on received signal
    if( min(size(rxsg))~=1 ) then
        error("EVM:improper received signal");
    end

    if(size(txsg)~=size(rxsg)) then
        error("EVM:txsig and rxsig should have same dimensions");
    end

    //   checking conditions on X-percentile
    if (~isreal(xper) | length(xper)~=1 | isnan(xper)|xper<0|xper>100) then
        error("MER:improper X-percentile");
    end
    
    if(~strcmp(normmeth,'avgrefsigpow')) then
        if(RHS ~= 4) then
            error("EVM:Invalid no. of arguments");
        end
    elseif (~strcmp(normmeth,'peakconpow') | ~strcmp(normmeth,'avgconpow')) then
        if(RHS ~= 5) then
            error("EVM:Invalid no. of arguments");
        end
        p=varargin(1);
        //   checking conditions on pcon
    if (~isreal(p) | length(p)~=1 | isnan(p)|p<=0) then
        error("EVM:improper pcon");
    end
else
    error("EVM:improper normmeth");
    end
        
           sgpw =0;
    nopw=0;
    N=length(txsg);
    for i =1:N
        it=real(txsg(i));
        ir=real(rxsg(i));
        qt=imag(txsg(i));
        qre=imag(rxsg(i));
        e(i)=(it-ir)^2+(qt-qre)^2;
        nopw=nopw+e(i);
        sgpw=sgpw+(it^2)+(qt^2);
    end
    if(~strcmp(normmeth,'avgrefsigpow')) then
        p=sgpw/N;
    end
    
    for i=1:N
            evmk(i)=sqrt(e(i)/p)*100;
    end
    
            rmsEVM=sqrt(nopw/(p*N))*100;
        
    maxEVM = max(evmk);
    evmk=gsort(evmk,'g','i');
    n=ceil(xper*N/100);
    perEVM=evmk(n);
endfunction
