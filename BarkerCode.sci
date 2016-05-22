function [y] = BarkerCode(len,opsamples)
    y=[];
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //BarkerCode Generate Barker code

    //Y = BarkerCode(len,opsamples)) outputs a frame of the Barker code in column vector Y
    //opsamples specify output frame length properties
    //length specifies length of barker code
    //
    //Author - Harshal Shah

    //check conditions on length
    if (~isreal(len) | length(len)~=1 | isnan(len)|~or(len ==[1 2 3 4 5 7 11 13])) then
        error("BarkerCode:improper length");
    end

    //check condition on opsamples

    if (~isreal(opsamples) | length(opsamples)~=1 | isnan(opsamples)|ceil(opsamples)~=opsamples|opsamples<=0) then
        error("BarkerCode:improper output samples");
    end

    //create barker code os specified length

    select len
    case 1 then
        baco = [1];
    case 2 then 
        baco =[1 -1];
    case 3 then
        baco = [1 1 -1];
    case 4 then 
        baco =[1 1 -1 1];
    case 5 then 
        baco =[1 1 1 -1 1];
    case 7 then 
        baco =[1 1 1 -1 -1 1 -1];
    case 11 then 
        baco =[1 1 1 -1 -1 -1 1 -1 -1 1 -1];
    case 13 then 
        baco =[1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
    end

    //create outputsequence

    for i =0:opsamples-1
        y(i+1)=baco(modulo(i,len)+1);   
    end
endfunction



