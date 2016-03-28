function [out] = compand(in,param,V,method)

      // Output variables initialisation (not found in input variables)
      out=[];


      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      //COMPAND Source code mu-law or A-law compressor or expander.
      //   OUT = COMPAND(IN, PARAM, V) computes mu-law compressor with mu given
      //   in PARAM and the peak magnitude given in V.
      //
      //   OUT = COMPAND(IN, PARAM, V, METHOD) computes mu-law or A-law
      //   compressor or expander computation with the computation method given
      //   in METHOD. PARAM provides the mu or A value. V provides the input
      //   signal peak magnitude. METHOD can be chosen as one of the following:
      //   METHOD = ''mu/compressor'' mu-law compressor.
      //   METHOD = ''mu/expander''   mu-law expander.
      //   METHOD = ''A/compressor''  A-law compressor.
      //   METHOD = ''A/expander''    A-law expander.
      //
      //   The prevailing values used in practice are mu=255 and A=87.6.
      //
      //   Author(s): Harshal Shah
      //   .

      //   References:
      //     [1] https://help.scilab.org


      [LHS,RHS]=argn(0);
      if (RHS<3) then
            error("Invalid no. of arguments")
      elseif(RHS<4) then 
            method = 'mu/compressor';
      else 
            if (~type(method)==10) then
                  error("comm:compand:InvalidParam")
            end
            method = convstr(method,'l');
      end
      // error checking for first three input parameters
      if (~(or(type(in)==[1,5,8]))|~(or(type(param)==[1,5,8]))|~(or(type(V)==[1,5,8]))) then
            error("comm:compand:InputNotNumeric")
      end

      // it is a mu-law compressor case
      if (strcmp(method,"mu/compressor")==0) then
            out = V ./ log(1 + param) .* log(1 + param / V * abs(in)) .* sign(in);
      // it is a mu-law expander case
      elseif (strcmp(method,"mu/expander")==0) then
            out = V / param * (exp(abs(in) * log(1 + param) / V) - 1) .* sign(in);
      // it is a A-law compressor
      elseif (strcmp(method,"A/compressor")==0) then 
            lnAp1 = log(param) + 1
            VdA   = V / param
            indx = find(abs(in) <= VdA,-1)
            if ~isempty(indx)
                  out(indx) = param / lnAp1 * abs(in(indx)) .* sign(in(indx));
            end
            indx = find(abs(in) >  VdA)
            if ~isempty(indx)
                  out(indx) = V / lnAp1 * (1 + log(abs(in(indx)) / VdA)) .* sign(in(indx));
            end
      // it is a A-law expander
      elseif (strcmp(method,"A/expander")==0) then
            lnAp1 = log(param) + 1
            VdA   = V / param
            VdlnAp1 = V / lnAp1
            indx = find(abs(in) <= VdlnAp1,-1)
            if ~isempty(indx)
                  out(indx) = lnAp1 / param * abs(in(indx)) .* sign(in(indx));
            end
            indx = find(abs(in) >  VdlnAp1,-1)
            if ~isempty(indx)
                  out(indx) = VdA * exp(abs(in(indx)) / VdlnAp1 - 1) .* sign(in(indx))
            end
      else
            error("comm:compand:InvalidMethod")

      end
endfunction
