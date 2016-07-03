function [y] = DiscretetimeVCO(in,Ac,fc,kc,iniph,T)
     y=[];
    // Display mode
    mode(0);
    // Display warning for floating point exception
    ieee(1);
    
    //DiscretetimeVCO  Implement voltage-controlled oscillator in discrete time
    
    //[y] = DiscretetimeVCO(in,Ac,fc,kc,iniph,T) - The Discrete-Time VCO (voltage-controlled oscillator) 
    //generates ywhose frequency shift from the Quiescent frequency parameter 
    //is proportional to the input signal. The input signal is interpreted as a voltage.
    
   //in: input  -can be any vector
   //Ac:OutputAmplitude-Specify the amplitude of the output signal as scalar value.
   //fc:QuiescentFrequency- Frequency of output signal when input is zero
   //Specify the quiescent frequency of the output signal in Hertz, , real, scalar value.
   //kc:Sensitivity- Sensitivity of frequency shift of output signal
   //Specify the sensitivity as real, scalar value
   //iniph:InitialPhase- Initial phase of output signal
   //Specify the initial phase of the output signal, in radians, as  real, scalar value
   //T:Sampletime -Sample time of input
   //Specify the sample time of the input, in seconds, as  positive, scalar value
   
   //Author - Harshal Shah
   
   //checking conditions on input
    if( ~isreal(in) |or( isnan(in)) | min(size(in))~=1) then
        error("RaisedCosinetxfilter:improper input");
    end
    
    //checking condition on OutputAmplitude
    if (~isreal(Ac) | length(Ac)~=1 | isnan(Ac)) then
        error("RaisedCosinetxfilter:improper OutputAmplitude");
    end
    
    //checking condition on QuiescentFrequency
    if (~isreal(fc) | length(fc)~=1 | isnan(fc)) then
        error("RaisedCosinetxfilter:improper QuiescentFrequency");
    end
    
    //checking condition on Sensitivity
    if (~isreal(kc) | length(kc)~=1 | isnan(kc)) then
        error("RaisedCosinetxfilter:improper Sensitivity");
    end
    
    //checking condition on Sampletime
    if (~isreal(T) | length(T)~=1 | isnan(T)) then
        error("RaisedCosinetxfilter:improper SampleRate");
    end
    len=length(in);
    t = (0:len-1)*T
    s=0;
    for i =1:len
         s= s+in(i)
         y(i)=Ac*cos(2*%pi*fc*t(i)+2*%pi*kc*s+iniph);
     end
 endfunction
 
    
    
    
    
    
    
    
    

