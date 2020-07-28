function printAcc(score,isValden)
% this function gets scores vector for each fold and if the scores belongs
% to the validation set, calculating mean and SD and print it.
%     - score must be a numeric vector
%     - isValden must be logical value, True - validation set,
%       False - train set
    AccAvg = mean(score);
    AccSD = std(score);
    if isValden
        set = "validation";
    else
        set = "train";
    end
    msg = char("The "+set+" accuracy is: "+AccAvg+char(177)+AccSD+"%");  
    disp(msg);
end 