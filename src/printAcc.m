function printAcc(score,isTest)
% this function gets scores vector for each fold and if the scores belongs
% to the test set, calculating mean and SD and print it.
%     - score must be a numeric vector
%     - isTest must logical value, True - test set, False - train set
    AccAvg = mean(score);
    AccSD = std(score);
    if isTest
        set = "test";
    else
        set = "train";
    end
    msg = char("The "+set+" accuracy is: "+AccAvg+char(177)+AccSD+"%");  
    disp(msg);
end 