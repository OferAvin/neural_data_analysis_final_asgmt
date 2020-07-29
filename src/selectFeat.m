function [featIdx,selectMat] = selectFeat(featMat ,labels, num2selectFeat)
    %Selecting features
    Select = fscnca(featMat,labels);
    %Decsending order of importence
    [~ , feat_order] = sort(Select.FeatureWeights, 'descend');
    %Taking the most importent features
    featIdx = feat_order(1:num2selectFeat);
    selectMat = featMat(:,(featIdx));
end