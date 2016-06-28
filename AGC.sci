function [y] = AGC(x,K,A,N,maxpow)
    y=zeros(size(x,1),size(x,2));
      // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);
    
    //AGC- Adaptively adjust gain for constant signal-level output
    //[y] = AGC(x,K,A,N,maxpow) outputs the constant power level signal from input x
    //x:input-Input vector signal
    //k:AdaptationStepSize-Step size for gain updates
    //Specify the step size as a real positive scalar.
    //A:DesiredOutputPower-Target output power level
    //Specify the desired output power level as a real positive scalar.
    //N:AveragingLength-Length of the averaging window
    //Specify the length of the averaging window in samples as a positive integer scalar.
    //MaxPowerGain-Maximum power gain in decibels
    //Specify the maximum gain of the AGC in decibels as a positive scalar. 
    
    // Author - Harshal Shah
    
    //checking conditions on input
    if(| or( isnan(x)) | min(size(x))~=1 ) then
        error("AGC:improper input");
    end
    
    //checking condition on AdaptationStepSize
    if (~isreal(K) | length(K)~=1 | isnan(K)|ceil(K)~=K|K<=0) then
        error("AGC:improper AdaptationStepSize");
    end
    
    //checking condition on DesiredOutputPower
    if (~isreal(A) | length(A)~=1 | isnan(A)|ceil(A)~=A|A<=0) then
        error("AGC:improper DesiredOutputPower");
    end
    
    //checking condition on AveragingLength
    if (~isreal(N) | length(N)~=1 | isnan(N)|ceil(N)~=N|N<=0) then
        error("AGC:improper AveragingLength");
    end
    
    //checking condition on MaxPowerGain
    if (~isreal(maxpow) | length(maxpow)~=1 | isnan(maxpow)|ceil(maxpow)~=maxpow|maxpow<=0) then
        error("AGC:improper MaxPowerGain");
    end
    
    y(1)=x(1);
    z(1)=y(i)*conj(y(i));
    e(1)=A - log(z(1))
    g(1)= K*e(1);
    //runnning logarithmic AGC itertaively
    for i =2:length(x)
        if(g(i-1) > (maxpow * log(10)/20) then
            g(i-1)=maxpow * log(10)/20;             //saturate the gain acc to max power
        end
        
            
        y(i)= x(i)*exp(g(i-1));
         D(i)=0;
         //input detector
        if(i<=N) then
            for j=1:i
                D(i)= D(i)+y(j)*conj(y(j));
            end
            D(i)=D(i)/i;
        else
            D(i)= D(i-1)+(y(i)*conj(y(i)) -y(i-N)*conj(y(i-N)))/N
        end
        z(i)=D(i)*exp(2*g(i-1));
        e(i)=A-log(z(i));
        g(i)=g(i-1)+ K*e(i);

    end
endfunction

    
    
    
