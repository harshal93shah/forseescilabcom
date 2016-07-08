function [y,estcoef] = IQImbalanceCompensator(in,ic,ss)
    
     y=zeros(length(in),1);
     estcoef=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);
    
     //IQImbalanceCompensator Compensate for I/Q imbalance
     //The adaptive algorithm inherent to the I/Q imbalance compensator is 
     //compatible with M-PSK, M-QAM, and OFDM modulation schemes, where M>2.

    //[y,estcoef] = IQImbalanceCompensator(in,ic,ss) estimates the I/Q imbalance in the input signal,
    // in, and returns a compensated signal, Y. and also outputs the estimated coefficients, ESTCOEF
    // in:input-Input vector signal can be complex
    //ic indicates initial coefficient The initial coefficient is a complex scalar 
    //ss:Adaptation step size Specifies the step size used by the algorithm in estimating the I/Q imbalance 
    
    //Author - Harshal Shah
    
    //checking conditions on in
    if( isnan(in) | min(size(in))~=1) then
        error("IQImbalanceCompensator:improper input");
    end
    
    //checking conditions on initial condition
     if ( length(ic)~=1 | isnan(ic)) then
         error("IQImbalanceCompensator:improper intial conditions");
    end
    
    //checking condition on AdaptationStepSize
    if ( length(ss)~=1 | isnan(ss)) then
        error("IQImbalanceCompensator:improper AdaptationStepSize");
    end
 w(1)=ic;
 for i =1:length(in) 
     y(i)= in(i)+w(i)*conj(in(i));
     w(i+1)= w(i)-ss*y(i)^2;
 end
 estcoef = w(1:length(in));
