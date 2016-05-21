function [y] = recqammod(x,M,varargin)
      y=[];
      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);
      //RECQAMMOD Quadrature amplitude modulation

      //Y = RECQAMMOD(X,M) outputs the complex envelope of the modulation of the
      //message signal X using quadrature amplitude modulation. M is the alphabet
      //size and must be an integer power of two. The message signal must consist of
      //  integers between 0 and M-1. The signal constellation is a rectangular
      //  constellation. For two-dimensional signals, the function treats each column
      //   as 1 channel.

      //   Y = RECQAMMOD(X,M,INI_PHASE) specifies a phase offset (rad).

      //   Y = RECQAMMOD(X,M,INI_PHASE,SYMBOL_ORDER) specifies how the function assigns
      //  binary words to corresponding integers. If SYMBOL_ORDER is set to 'bin'
      //   (default), then the function uses a natural binary-coded ordering. If
      //   SYMBOL_ORDER is set to 'gray', then the function uses a Gray-coded ordering.
      //
      //Author - Harshal Shah

      [LHS,RHS]=argn(0);

      //Checking if no. of arguments are proper
      if(RHS<2 | RHS >4 ) then
            error("Invalid no. of arguments")
      end

      //checking if x is real, integer and numeric
      if(~isreal(x) | or(isnan(x)) | or(ceil(x)~=x)) then
            error("qammod:improper x");
      end
      //checking range of X
      if ((min(x) < 0) |(max(x) > (M-1))) then
            error("qammod:improper x");
      end

      //check condition on M
      if (~isreal(M) | length(M)~=1 | M<=0 | ceil(M)~=M | isnan(M)) then
            error("qammod:improper M");
      end
      if (ceil( log2(M)) ~= log2(M)) then
            error("qammod:M should pe power of 2");
      end



      order='bin';
      iniphase = 0;
      a= max(size(varargin));
      //extracting optinoal arguments initial phase and symbol order
      //checking conditions on them 
      if (a>0) then
            iniphase=varargin(1);
            if (~isreal(iniphase) | length(iniphase)~=1) then
                  error("qammod:improper iniphase");
            end
      end

      if (a==2) then
            order=varargin(2);
            if((type(order)~=10)| (strcmp(order,'BIN')&strcmp(order,'GRAY'))) then
                  error("qammod:improper symbol order");
            end        
      end
      
      //If symbol order is gray convert input signal to gray
      if (~strcmp(order,'GRAY'))  then
            x=bin2gray(x,'QAM',M);
      end
      const = zeros(M,1);
      
      //generate QAM constellation diagram for given M
      // distance between each point is 2 units
      
      //for rectangular(non square constellation)
      if(modulo(log2(M),2)) then
            k=1;
            for i = -sqrt(M/2)+1:2:sqrt(M/2)-1
                  for j = -sqrt(M/2)*2+1:2:sqrt(M/2)*2-1
                        const(k)= i + %i*j;
                        k=k+1;
                  end

            end
      //for square constellation
      else

            k=1;
            for i = -sqrt(M)+1:2:sqrt(M)-1
                  for j = -sqrt(M)+1:2:sqrt(M)-1
                        const(k)= i + %i*j;
                        k=k+1;
                  end

            end
      end
      //shifting constellation for initial phase
      const = const * complex(cos(iniphase),sin(iniphase));
      //assure X has correct orientation
      wid = size(x,1);
      if(wid ==1) then
            x = x(:);
      end

      // --- constellation needs to have the same orientation as the input -- 
      if(size(const,1) ~= size(x,1) )
            const = const(:);
      end

      // mapping
      y = const(x+1);

      // ensure output is a complex data type
      y = complex(real(y), imag(y));

      // --- restore the output signal to the original orientation --- 
      if(wid == 1)
            y = y.';
      end
      y = clean(y);

endfunction

//-----------------------------------------------------------------------------------

function [output,mapping] = bin2gray(x,modulation,order)
      //BIN2GRAY Gray encode
      //Y = BIN2GRAY(X,MODULATION,M) generates a Gray encoded output with the same
      //  dimensions as its input parameter X.  The input X can be a scalar, vector or
      //  matrix.  MODULATION is the modulation type, which can be a string equal to
      //  'QAM', 'PAM', 'FSK', 'DSPK' or 'PSK'.  M is the modulation order that must
      //  be an integer power of two.
      [ll,rr]=argn(0);
      funcprot(0);
      if rr<3 then
            error("Too few input arguments.");
      end;
      //Validate numeric x data
      if isempty(x)
            error("comm:bin2gray:InputEmpty");
      end
      //x must be a scalar, vector or a 2D matrix
      if length(size(x))>2
            error("comm:bin2gray:InputDimensions");
      end
      //Validate modulation type
      if (~(type(modulation)==10))|(~strcmpi(modulation,'QAM'))&(~strcmpi(modulation,'PSK'))...
            &(~strcmpi(modulation,'FSK'))&(~strcmpi(modulation,'PAM'))&(~strcmpi(modulation,'DPSK'))&(~strcmpi(modulation,'qam'))&(~strcmpi(modulation,'psk'))...
            &(~strcmpi(modulation,'fsk'))&(~strcmpi(modulation,'pam'))&(~strcmpi(modulation,'dpsk'))
            error("comm:bin2gray:ModulationTypeError");
      end
      //Validate modulation order
      if (order < 2)|(isinf(order)|...
            (~isreal(order))|(floor(log2(order)) ~= log2(order)))
            error("comm:bin2gray:ModulationOrderError");
      end
      //Check for overflows - when x is greater than the modulation order
      if (max(max(x)) >= order)
            error("comm:bin2gray:XError");
      end
      if ((modulation == 'PSK')|(modulation == 'PAM')|(modulation == 'DPSK')|(modulation == 'FSK')|(modulation == 'psk')|(modulation == 'pam')|(modulation == 'dpsk')|(modulation == 'fsk'))
            y = uint8(1)
      elseif((modulation=='QAM')|(modulation=='qam'))
            y= uint8(0)
      end
      select y

      case 1
            //'PSK', 'PAM','FSK','DSPK'
            // Calculate Gray table
            j = (0:order-1)';
            j = uint8(j)
            mapping = bitxor(j,bitshift(j,-1));
            // Format output and translate x (map) i.e. convert to Gray
            output = mapping(x+1);
            //Assure that the output, if one dimensional,
            //has the correct orientation
            wid = size(x,1);
            if(wid == 1)
                  output = output';
            end
            mapping = mapping'
      case 0
            //QAM
            k = log2(order);                // Number of bits per symbol
            mapping = (0:order-1)';         // Binary mapping to be Gray converted
            if rem(k,2) // non-square constellation
                  kI = (k+1)/2;
                  kQ = (k-1)/2;
                  symbolI = bitshift(mapping,-kQ);
                  symbolQ = bitand(mapping,bitshift(order-1,-kI));
                  // while i is smaller (Number of bits per symbol)/2
                  i = 1;
                  while i < kI
                        tempI = symbolI;
                        tempI = bitshift(tempI,-i);
                        symbolI = bitxor(symbolI,tempI);
                        i = i + i;                          // i takes on values 1,2,4,8,...,2^n - n is an integer
                  end
                  // while i is smaller (Number of bits per symbol)/2
                  i = 1;
                  while i < kQ
                        tempQ = symbolQ;
                        tempQ = bitshift(tempQ,-i);
                        symbolQ = bitxor(symbolQ, tempQ);
                        i = i + i;                          // i takes on values 1,2,4,8,...,2^n - n is an integer
                  end
                  SymbolIndex = double(bitshift(symbolI,kQ) + symbolQ);
            else         // square constellation
                  symbolI = bitshift(mapping,-k/2);
                  z = uint8(bitshift(order-1,-k/2)*ones(1,length(mapping)))
                  symbolQ = bitand(uint8(mapping),z');
                  // while i is smaller (Number of bits per symbol)/2
                  i = 1;
                  while i < k/2
                        tempI = symbolI;
                        tempI = bitshift(tempI,-i);
                        symbolI = bitxor(symbolI,tempI);

                        tempQ = symbolQ;
                        tempQ = bitshift(tempQ,-i);
                        symbolQ = bitxor(symbolQ, tempQ);
                        i = i + i;                          // i takes on values 1,2,4,8,...,2^n - n is an integer
                  end
                  SymbolIndex = double(bitshift(symbolI,k/2) + symbolQ);
            end
            mapping = SymbolIndex;
            //Format output and translate x (map) i.e. convert to Gray
            output = mapping(x+1);
            //Assure that the output, if one dimensional,
            //has the correct orientation
            if or(size(x) ~= size(output))
                  output = output';
            end
            //Make sure that mapping is a vector, when used to name the symbols
            //column-wise starting from left upper corner, results in a gray mapped
            //constellation.
            [dummy,index]=members(0:order-1,mapping);
            mapping = index - 1;
      else
            error("comm:bin2gray:ModulationTypeUnknown")
      end
endfunction
//-----------------------------------------------------------------------------------
function [Z] = rem(X,Y)
      Z=  X-fix(X./Y).*Y
endfunction
//---------------------------------------------------------------------------------
function[C]=bitshift(A,K)
      A = uint8(A);
      if(K<0)
            A =A/(2^abs(K));
      else
            A = A*(2^K);
      end
      C =A;
endfunction
//---------------------------------------------------------------------------------








