function ber = bersync(EbNo, sigma, typek)
ber =[];
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);
//BERSYNC Bit error rate (BER) for imperfect synchronization.
//   BER = BERSYNC(EbNo, TIMERR, 'timing') returns the BER of coherent BPSK
//   modulation over an uncoded AWGN channel with timing error. The
//   normalized timing error is assumed to be Gaussian distributed.
//   EbNo -- bit energy to noise power spectral density ratio (in dB)
//   TIMERR -- standard deviation of the timing error, normalized to the
//             symbol interval
//
//   BER = BERSYNC(EbNo, PHASERR, 'carrier') returns the BER of BPSK
//   modulation over an uncoded AWGN channel with a noisy phase reference.
//   The phase error is assumed to be Gaussian distributed.
//   PHASERR -- standard deviation of the reference carrier phase error
//              (in rad)

 //   Author(s): Harshal Shah
      //   .
      //   References:
      //     [1] https://help.scilab.org
      [LHS,RHS]=argn(0);
 if (RHS~=3) then
       error("Invalid no. of arguments")
 end
 if((type(EbNo)~=1) | (min(size(EbNo))~=1)) then   //checking if EbNo iss real vector
        error("comm:bersync:EbNo");
  end
  
  EbNoLin = 10.^(EbNo/10);    //converting from dB to linear scale
ber = zeros(length(EbNo),1)';
zero = zeros(length(EbNo),1)';
one = ones(length(EbNo),1)';
//timing error
if(~strcmp(typek,'timing')) then
      if((sigma < 0)|(length(sigma)~=1)|(sigma >0.5)) then
            error("comm:bersync:timerr");
        elseif (sigma < %eps) then
              [P,Q]=cdfnor("PQ",sqrt(2.*EbNoLin),zero,one);
              ber = Q;
        else
              tol = 1e-4 ./ EbNoLin.^6;
        tol(tol>1e-4) = 1e-4;
        tol(tol<%eps) = %eps;
        disp(EbNoLin)
         for i = 1:length(EbNoLin)
               
               ber(i)=integrate('erfc(sqrt(EbNoLin(i))*(1-2*abs(x)))*exp(-x^2/(2*(sigma)^2))','x',-10*sigma,10*sigma,tol(i),tol(i));
               ber(i)=ber(i)*sqrt(2) / (8*sqrt(%pi)*sigma);
         end
         ber = ber + erfc(sqrt(EbNoLin)) / 4;
    end
    //carrier phase error
    elseif(~strcmp(typek,'carrier')) then
            if((sigma < 0)|(length(sigma)~=1)) then
                   error('comm:bersync:phaserr');
                    elseif (sigma < %eps) then
              [P,Q]=cdfnor("PQ",sqrt(2*EbNoLin),zero,one);
              ber = Q;
        else
             tol = 1e-4 ./ EbNoLin.^6;
        tol(tol>1e-4) = 1e-4;
        tol(tol<%eps) = %eps
         for i = 1:length(EbNoLin)
               ber(i)=integrate('erfc(sqrt(EbNoLin(i))*(cos(x))* exp(-x^2/(2*(sigma)^2))','x',0,10*sigma,tol(i),tol(i));
               ber(i)=ber(i)/ (sqrt(2*(%pi)) * sigma);
         end
    end
    else
    error('comm:bersync:thirdArg');
end
endfunction
