function [fest] = QAMCoaFreqEstim(in,fs,fr)

    fest=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);
    
    //QAMCoaFreqEstim-QAMCoarseFrequencyEstimator
    //fest = QAMCoarseFrequencyEstimator(fs,fr) estimates for the carrier frequency offset 
    //returns a scalar estimate of the frequency offset  fft based algorithm 
    //in:input-Input vector signal can be complex

    //fs:Sample rate (Hz)-specify the sample rate in samples per second as a positive, real scalar 

    //fr:Frequency resolution (Hz) -Specify the frequency resolution for the offset frequency estimation as a positive, real scalar
    //The value for this property must be less than or equal to half the SampleRate 
    //checking conditions on in
    if( or( isnan(in)) | min(size(in))~=1) then
        error("QAMCoaFreqEstim:improper input");
    end

    //checking condition on Sample rate
    if (~isreal(fs) | length(fs)~=1 | isnan(fs)|fs<=0) then
        error("QAMCoaFreqEstim:improper  Sample rate");
    end

    //checking condition on Frequency resolution 
    if (~isreal(fr) | length(fr)~=1 | isnan(fr)|fr<=0|fr>=(fs/2)) then
        error("QAMCoaFreqEstim:improper  Frequency resolution/Max frequency ");
    end

    N= 2^ceil(log2(fs/fr));
    l=length(in);
    if(l<= N) then
        for i = (l+1):N
            in(i) = 0;
        end
    else
        error("CarrierSynchronizer:input is too large ");
    end
    x= abs(fft(in.^4));
    [l,k]=max(x);
    if(k>N/2) then
        k = k-N;
    end
    fest = k*fs/(N*4);
    endfunction
    


