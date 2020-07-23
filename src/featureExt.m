function featureExt(data, features)
    features = zeros(nTrails,nFeat);
    
%     band power featurse
    featIdx = 1;
    for i = 1:nChan
        for j = 1:length(features.bandPower)
            tRange = (time >= features.bandPower{j}{2}(1) & time <= features.bandPower{j}{2}(2));
            featuresMat = bandpower(data(:,tRange,nChan)',fs,features.bandPower{j}{1});
        end
    end
end

