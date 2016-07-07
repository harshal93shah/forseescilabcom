function [fest] = CoaFreqEstim(in,mod,algo,fs,f)

    fest=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);

    //CoaFreqEstim-CoarseFrequencyEstimator which estimates frequency offset
    //CoaFreqEstim(in,mod,algo,fs,f)estimates for the carrier frequency offset 
    //returns a scalar estimate of the frequency offset  fft based algorithm or correleation based algo
    //for mod of BPSK,QPSK,PSK,PAM and QAM
    //CoaFreqEstim(in,mod,'fft',fs,fr) or //CoaFreqEstim(in,m,'corr',fs,fm)
    //in:input-Input vector signal can be complex
    //m:ModulationOrder-Modulation order the object uses
    //Specify the modulation order of the PSK signal as a positive, real scalar 
    //fs:Sample rate (Hz)-specify the sample rate in samples per second as a positive, real scalar 
    //fr:Frequency resolution (Hz) -Specify the frequency resolution for the offset frequency estimation as a positive, real scala
    //The value for this property must be less than or equal to half the SampleRate 
    //checking conditions on in
    //fm:Maximum measurable frequency offset (Hz) 
    //Specify the maximum measurable frequency offset as a positive, real scalar 
    //The value of this property must be less than SampleRate/ ModulationOrder

    //checking conditions on in
    if( or( isnan(in)) | min(size(in))~=1) then
        error("CoaFreqEstim:improper input");
    end

    if(~strcmp('BPSK',mod)|~strcmp('PAM',mod)) then
        m=2;
    elseif(~strcmp('QPSK',mod))
        m=4;
    elseif(~strcmp('8PSK',mod))
        m=8;
    elseif(~strcmp('QAM',mod))
        m=4;
        if (~strcmp(algo,'corr')) then
            error("CoaFreqEstim:QAM should have algo fft");
        end

    end

    //checking condition on Sample rate
    if (~isreal(fs) | length(fs)~=1 | isnan(fs)|fs<=0) then
        error("CoaFreqEstim:improper  Sample rate");
    end

    //checking condition on Frequency resolution
    if(~strcmp(algo,'fft')) then
        if (~isreal(f) | length(f)~=1 | isnan(f)|f<=0|f>=(fs/2)) then
            error("CoaFreqEstim:improper  Frequency resolution ");
        end

        N= 2^ceil(log2(fs/f));
        l=length(in);
        if(l<= N) then
            for i = (l+1):N
                in(i) = 0;
            end
        else
            error("CarrierSynchronizer:input is too large ");
        end
        x= abs(fft(in.^m));
        [l,k]=max(x);
        if(k>N/2) then
            k = k-N;
        end
        fest = k*fs/(N*m);

    elseif(~strcmp(algo,'corr')) then
        if (~isreal(f) | length(f)~=1 | isnan(f)|f<=0|f>=(fs/m)) then
            error("CoaFreqEstim:improper  Frequency resolution ");
        end

        N=length(in);
        L=min(round(fs/f),N)
        R= zeros(N,1);
        for i = 1:N
            for j =i:N
                R(i)=R(i)+in(j)*conj(in(j-i+1));
            end
            R(i)=R(i)/(N-i+1);
        end
        s=sum(R(2:L));
        phi=atan(imag(s),real(s));
        fest= phi*fs/(%pi*(L));
    else
        error("CoaFreqEstim:improper  algorithm ");
    end

