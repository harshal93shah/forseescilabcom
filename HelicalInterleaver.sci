function [y,state,index] = HelicalInterleaver(in,col,N,stp,inist,stindex)
    y=[];
    state = [];
    index=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);
    
   
    //HelicalInterleaver Permute symbols using helical array.
    //[y,state,index]= HelicalInterleaver(in,delay,inist).permutes the elements in input by using
    //Permute symbols using helical array
    //it also returns the current state of arrays as matrix
    //and the value of next index from which we would get output
    //in:input- can be any  vector. Its length should be equal to col * N 
    //col:Number of columns-The number of columns, C, in the helical array.
    //N:The group size, N, of each group of input symbols.
    //inist:Initialstate- Initial conditions of helical array
    //Specify the initial values in each shift register as a numeric scalar value or a 
    //matrix. Intially pass a scalar for subsequent calls pass the state returned  from previous calls
    
    //stindex:start index- which shift register will give first ouput. it should be scalar 
    //less than no of col.Intially pass 1 subsequent cause pass the index returned  from previous calls

    //Author - Harshal Shah

    //checking conditions on input
    if(~isreal(in) | or( isnan(in)) | min(size(in))~=1 | length(in)~=(N*col) ) then
        error("HelicalInterleaver:improper input");
    end
    
    //   checking conditions on col
    if (~isreal(col) | length(col)~=1 | isnan(col)|col<=0) then
        error("HelicalInterleaver:improper col");
    end
    
     //   checking conditions on N
    if (~isreal(N) | length(N)~=1 | isnan(N)|N<=0) then
        error("HelicalInterleaver:improper N");
    end

  delay = 0:stp:(col-1)*stp;
  k=1;
  for i =1:N
      for j =i:N:N*col
      Z(k)=in(j);
      k=k+1;
  end
end  
   [y,state,index] = MultiplexedInterleaver(Z,delay,inist,stindex);
   endfunction
