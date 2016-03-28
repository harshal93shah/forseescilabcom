# forseescilabcom
function [out] = compand(in,param,V,method)


      COMPAND Source code mu-law or A-law compressor or expander.
         OUT = COMPAND(IN, PARAM, V) computes mu-law compressor with mu given
         in PARAM and the peak magnitude given in V.
      
         OUT = COMPAND(IN, PARAM, V, METHOD) computes mu-law or A-law
         compressor or expander computation with the computation method given
         in METHOD. PARAM provides the mu or A value. V provides the input
         signal peak magnitude. METHOD can be chosen as one of the following:
         METHOD = ''mu/compressor'' mu-law compressor.
         METHOD = ''mu/expander''   mu-law expander.
         METHOD = ''A/compressor''  A-law compressor.
         METHOD = ''A/expander''    A-law expander.
         
  example
  sample input:
  data = 2:2:12;
 compressed = compand(data,255,max(data),'mu/compressor')
 expanded = compand(compressed,255,max(data),'mu/expander')
 
 output 
 
 compressed  =
 
    8.1644152    9.6393971    10.508437    11.126779    11.607138    12.  
 
 expanded  =
 
    2.    4.    6.    8.    10.    12.  
         
         
function ber = bersync(EbNo, sigma, typek)

BERSYNC Bit error rate (BER) for imperfect synchronization.
   BER = BERSYNC(EbNo, TIMERR, 'timing') returns the BER of coherent BPSK
   modulation over an uncoded AWGN channel with timing error. The
   normalized timing error is assumed to be Gaussian distributed.
   EbNo -- bit energy to noise power spectral density ratio (in dB)
   TIMERR -- standard deviation of the timing error, normalized to the
             symbol interval

   BER = BERSYNC(EbNo, PHASERR, 'carrier') returns the BER of BPSK
//   modulation over an uncoded AWGN channel with a noisy phase reference.
//   The phase error is assumed to be Gaussian distributed.
//   PHASERR -- standard deviation of the reference carrier phase error
//              (in rad)

example 
sample input:

EbNo = [4 8 12];
timerr = [0.2 0.07 0];
ber = zeros(length(timerr), length(EbNo));
for ii = 1:length(timerr)
    ber(ii,:) = bersync(EbNo, timerr(ii),'timing');
end

output:
ber  =
 
    0.0520727    0.0205365    0.0111603  
    0.0189479    0.0007976    0.0000049  
    0.0125008    0.0001909    9.006D-09 
