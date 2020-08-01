function p = fsks(features,lables,distPrecision)

    catVec = categorical(lables);
    cat = categories(catVec);
    celFeat1 = num2cell(features(catVec == cat{1},:),1);    %only 1st class trails
    celFeat2 = num2cell(features(catVec == cat{2},:),1);    %only 2nd class trails
    maxVal =  
    hist1 = cellfun(@(x) histcounts(x,distPrecision,'no','pr'), celFeat1, 'UniformOutput',false);
    hist2 = cellfun(@(x) histcounts(x,distPrecision,'no','pr'), celFeat2, 'UniformOutput',false);
    [~ , p] = cellfun(@(x,y) kstest2(x,y), hist1, hist2);
end