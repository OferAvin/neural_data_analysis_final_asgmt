function bestFeatNum = analyzeNumOfFeat(Data,Prmtr,Features,k)
    numSelectFeat = size(Features.featMat,2);
    analyzeMath = zeros(numSelectFeat,4);
    for j = 1:size(Features.featMat,2)
       [~,selectMat] = selectFeat(Features,Data.lables,Prmtr.Vis.binEdges,j);
        % k fold cross-validation
        idxSegments = mod(randperm(Prmtr.nTrials),k)+1;
        for i = 1:k
            testSet = logical(idxSegments == i)';
            trainSet = logical(idxSegments ~= i)';
            [results{i},trainErr{i}] = classify(selectMat(testSet,:),selectMat(trainSet,:),Data.lables(trainSet),'linear');
            acc(i) = sum(results{i} == Data.lables(testSet));
            acc(i) = acc(i)/length(results{i})*100;
        end
        analyzeMath(j,1) = mean(acc);
        analyzeMath(j,2) = std(acc);
        trainAcc = (1-cell2mat(trainErr))*100;
        analyzeMath(j,3) = mean(trainAcc);
        analyzeMath(j,4) = std(trainAcc);
    end
    numFeatVec = 1:1:numSelectFeat;
    figure
    suptitle('Validation Vs Train Accuracy');
    errorbar(numFeatVec,analyzeMath(:,1),analyzeMath(:,2),'b')
    hold on
    errorbar(numFeatVec,analyzeMath(:,3),analyzeMath(:,4),'r')
    xlabel('Num Of Select Feature')
    ylabel('accuracy [%]')
    ylim([50 100])
    Leg2 = legend('Validation','Train');
    set(Leg2,'location','southeast');
    [~,bestFeatNum] = max(analyzeMath(:,1));
end