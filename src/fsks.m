function p = fsks(features,lables,precision)
%this function gives each features a weight which is the p value of the
%two-sample Kolmogorov-Smirnov test. the function finds all trials belongs
%to each class, finds the max and min value in order to calculate the range where 
% the distributions will be calculated. the precision of the distributions 
% is by multiplying the precision parameter with the range. 
%lastly it runs the Kolmogorov-Smirnov test for all distribitions
    catVec = categorical(lables);
    cat = categories(catVec);
    celFeat1 = num2cell(features(catVec == cat{1},:),1);    %only 1st class trails
    celFeat2 = num2cell(features(catVec == cat{2},:),1);    %only 2nd class trails
    maxVal = num2cell(max(features,[],1)); %get total max for each feature
    minVal = num2cell(min(features,[],1)); %get total min for each feature
    hist1 = cellfun(@(x,y,z) histcounts(x,linspace(y,z,(z-y)*precision),'no','pr'),...
        celFeat1,minVal,maxVal,'UniformOutput',false);  %calculate distribution for 1st class
    hist2 = cellfun(@(x,y,z) histcounts(x,linspace(y,z,(z-y)*precision),'no','pr'),...
        celFeat2,minVal,maxVal,'UniformOutput',false);  %calculate distribution for 2nd class
    [~,p] = cellfun(@(x,y) kstest2(x,y), hist1, hist2); %two-sample Kolmogorov-Smirnov test
end