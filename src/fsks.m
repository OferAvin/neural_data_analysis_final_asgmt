function p = fsks(features,lables)
%this function gives each features a weight which is the p value of the
%two-sample Kolmogorov-Smirnov test. the function finds all trials 
    catVec = categorical(lables);
    cat = categories(catVec);
    celFeat1 = num2cell(features(catVec == cat{1},:),1);    %only 1st class trails
    celFeat2 = num2cell(features(catVec == cat{2},:),1);    %only 2nd class trails
    maxVal = (cellfun(@(x,y) max([max(x),max(y)]),celFeat1,celFeat2,'UniformOutput',false));
    minVal = (cellfun(@(x,y) min([min(x),min(y)]),celFeat1,celFeat2,'UniformOutput',false));
    hist1 = cellfun(@(x,y,z) histcounts(x,linspace(y,z,(z-y)*10),'no','pr'),...
        celFeat1,minVal,maxVal,'UniformOutput',false);
    hist2 = cellfun(@(x,y,z) histcounts(x,linspace(y,z,(z-y)*10),'no','pr'),...
        celFeat2,minVal,maxVal,'UniformOutput',false);
    [~ , p] = cellfun(@(x,y) kstest2(x,y), hist1, hist2);
end