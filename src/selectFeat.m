function [featIdx,selectMat,featOrder] = selectFeat(Features,labels)
% this function extract the n best fearures using one of 2 method
% Features - struct that containing all features data lables and parameters
% nFeat2Reduce = the num of feature to slect
    %Selecting features by method
    if Features.fsMethod == "nca"
        Selection = fscnca(Features.featMat,labels);
        weights = Selection.FeatureWeights;
        order = 'descend';
    else
        weights = fsks(Features.featMat,labels,Features.distPrecision);
        order = 'ascend';
    end
    %Decsending order of importence
    [~ , featOrder] = sort(weights, order);
    %Taking the most importent features
    featIdx = featOrder(1:Features.nFeatSelect);
    selectMat = Features.featMat(:,(featIdx));
end