function [y,state,index,state2] = HelicalDeinterleaver(in,col,N,stp,inist,stindex,inist2)
    y=[];
    state = [];
    index=[];
    state2=[]
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);
    
   [LHS,RHS]=argn(0);
    //HelicalDeinterleaver Restore ordering of symbols  helical array.
    //[y,state,index,state2] = HelicalDeinterleaver(in,col,N,stp,inist,stindex,inist2)
    //or [y,state,index,state2] = HelicalDeinterleaver(in,col,N,stp,inist)
    // Restore ordering of symbols 
    //in input by using helical array
    //it also returns the current state of arrays as matrix
    //and the value of next index from which we would get output
    //in:input- can be any  vector. Its length should be equal to col * N 
    //col:Number of columns-The number of columns, C, in the helical array.
    //N:The group size, N, of each group of input symbols.
    //inist:Initialstate- Initial conditions of helical array
    //Specify the initial values in each shift register as a numeric scalar value(in case of 5 args) or a 
    //matrix. Intially pass a scalar for subsequent calls pass the state returned  from previous calls
    
   //inist2:intial state 2
    
    //stindex:start index- which shift register will give first ouput. it should be scalar 
    //less than no of col.Intially pass 1 subsequent cause pass the index returned  from previous calls
    //inist2 and stindex are optional and only to be used in subsequent calls

    //Author - Harshal Shah
    
    
        

    //checking conditions on input
    if(~isreal(in) | or( isnan(in)) | min(size(in))~=1 | length(in)~=(N*col) ) then
        error("HelicalDeinterleaver:improper input");
    end
    
    //   checking conditions on col
    if (~isreal(col) | length(col)~=1 | isnan(col)|col<=0) then
        error("HelicalDeinterleaver:improper col");
    end
    
     //   checking conditions on N
    if (~isreal(N) | length(N)~=1 | isnan(N)|N<=0) then
        error("HelicalDeinterleaver:improper N");
    end

  delay = 0:stp:(col-1)*stp;
  k=1;
  delayLen = modulo(col*N-stp*col*(col-1),col*N);
  if(RHS == 5) then
      inist2 = ones(delayLen,1)*inist;
      stindex=1;
  elseif (RHS ~= 7) then
      error("HelicalDeinterleaver:improper no. of arguments")
  else
  end
  
  
   [Z,state,index] = MultiplexedDeinterleaver(in,delay,inist,stindex);

   if ((size(Z,1)==1)) then
       z=z';
   end
   if (delayLen>0) then
      state2 = Z(length(Z)-delayLen+1:length(Z));
      Z = [inist2; Z(1:length(Z)-delayLen)]

  end
     for i =1:col
      for j =i:col:N*col
      y(k)=Z(j);
      k=k+1;
  end
end  
   
   endfunction
