function [featIdx,selectMat] = selectFeat(Features,labels,distPrecision)
    %Selecting features by method
    if Features.sfMethod == "nca"
        Selection = fscnca(Features.featMat,labels);
        weights = Selection.FeatureWeights;
    else
        weights = fsks(Features.featMat,labels,distPrecision); 
    end
    %Decsending order of importence
    [~ , feat_order] = sort(weights, 'descend');
    %Taking the most importent features
    featIdx = feat_order(1:Features.nFeatSelect);
    selectMat = Features.featMat(:,(featIdx));
end