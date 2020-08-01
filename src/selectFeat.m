function [featIdx,selectMat] = selectFeat(Features,labels,distPrecision,nFeat2Reduce)
% this function extract the n best fearures using one of 2 method
% Features - struct that containing all features data lables and parameters
% nFeat2Reduce = the num of feature to slect
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
    featIdx = feat_order(1:nFeat2Reduce);
    selectMat = Features.featMat(:,(featIdx));
end