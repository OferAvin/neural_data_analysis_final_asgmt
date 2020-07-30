function [diffAmpSum,description] = chanlDiffAmp(Data,Prmtr,chanl1,chanl2)
% function that calculate the diff (in voltge) by subtracting chanl2 from chanl1 
    diffAmpSum = sum(Data.allData(:,(Prmtr.miPeriod*Prmtr.fs),chanl1)-...
        Data.allData(:,(Prmtr.miPeriod*Prmtr.fs),chanl2),2);
    description = " Amplitude Diff: " + Prmtr.chansName{chanl1} + "-" + Prmtr.chansName{chanl2};
end