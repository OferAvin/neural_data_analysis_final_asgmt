function printAcc(accAvg,accSD,isValden)
% this function gets accuracy mean and SD and print it.
%     - isValden must be logical value, True - validation set,
%       False - train set
    if isValden
        set = "validation";
    else
        set = "train";
    end
    msg = char("The "+set+" accuracy is: "+accAvg+char(177)+accSD+"%");  
    disp(msg);
end 