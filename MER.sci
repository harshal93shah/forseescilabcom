function [avgMER,minMER,perMER] = MER(rxsg,txsg,xper)
    avgMER = [];
    minMER=[];
    perMER=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);

    //MER The MER Measurement fn outputs the modulation error ratio (MER).
    // MER is a measure of the signal-to-noise ratio (SNR) in digital modulation
    // applications. The block measures all outputs in dB.
    //he modulation error ratio is the ratio of the average reference signal power 
    //to the mean square error. This ratio corresponds to the SNR of the AWGN channel.
    // The minimum MER represents the best-case MER value per burst
    //he Xth percentile is the MER value above which X% of all the computed MER values lie

    //[avgMER,minMER,perMER] = MER(rxsg,txsg,avgdmn,xper)
    //rxsg:received signal- A vector
    //txsg:transmitted - A vector
    //xper:X-percentile value above which X% of the MER measurements fall, 
    //specified as a real scalar from 0 to 100

    // Author - Harshal Shah
    //checking conditions on transmitted signal
    if( min(size(txsg))~=1 ) then
        error("MER:improper transmitted signal");
    end
    //   checking conditions on received signal
    if( min(size(rxsg))~=1 ) then
        error("MER:improper received signal");
    end

    if(size(txsg)~=size(rxsg)) then
        error("MER:txsig and rxsig should have same dimensions");
    end

    //   checking conditions on X-percentile
    if (~isreal(xper) | length(xper)~=1 | isnan(xper)|xper<0|xper>100) then
        error("MER:improper X-percentile");
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
    for i=1:N
        if(e) then
            merk(i)=10*log10(sgpw/(e(i)*N));
        else
            merk(i)=%inf;
        end
    end
    if(nopw) then
            avgMER = 10*log10(sgpw/nopw);
        else
            avgMER=%inf;
        end
    minMER = min(merk);
    merk=gsort(merk);
    n=ceil(xper*N/100);
    perMER=merk(n);
endfunction
