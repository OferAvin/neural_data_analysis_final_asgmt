function bestFeatNum = analyzeNumOfFeat(Data,Prmtr,Features,k)
    numSelectFeat = size(Features.featMat,2);
    analyzeMath = zeros(numSelectFeat,4); % 2 for valid mean + sd and 2 for train mean + sd
    analyzeMathF1 = zeros(numSelectFeat,1); % 1 for F1 Score 
    for j = 1:size(Features.featMat,2)
       [~,selectMat] = selectFeat(Features,Data.lables,Prmtr.Vis.binEdges,j);
        % k fold cross-validation
        idxSegments = mod(randperm(Prmtr.nTrials),k)+1;
        cmT = zeros(Prmtr.nclass,Prmtr.nclass);
        for i = 1:k
            testSet = logical(idxSegments == i)';
            trainSet = logical(idxSegments ~= i)';
            [results{i},trainErr{i}] = classify(selectMat(testSet,:),selectMat(trainSet,:),Data.lables(trainSet),'linear');
            acc(i) = sum(results{i} == Data.lables(testSet));
            acc(i) = acc(i)/length(results{i})*100;
            %count for confusion matrix
            cm = confusionmat(Data.lables(testSet),results{i});
            cmT = cmT + cm;
        end
        percision = cmT(1,1)/(cmT(1,1) + cmT(1,2));
        recall = cmT(1,1)/(cmT(1,1) + cmT(2,1));
%         analyzeMathF1(j,1) = percision;
%         analyzeMathF1(j,2) = recall;
        F1Score = 2*((percision*recall)/(percision+recall));
        analyzeMathF1(j,1) = F1Score;
        
        analyzeMath(j,1) = mean(acc);        
        analyzeMath(j,2) = std(acc);
        trainAcc = (1-cell2mat(trainErr))*100;
        analyzeMath(j,3) = mean(trainAcc);
        analyzeMath(j,4) = std(trainAcc);
    end
    numFeatVec = 1:1:numSelectFeat;
    figure
    suptitle('Validation Vs Train Accuracy');
    % validation plot
    posSDVal = analyzeMath(:,1) + analyzeMath(:,2);
    negSDVal = analyzeMath(:,1) - analyzeMath(:,2);
    plot(numFeatVec,analyzeMath(:,1),'b'); hold on;
    plot(numFeatVec,posSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    plot(numFeatVec,negSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    % train plot
    posSDTrain = analyzeMath(:,3) + analyzeMath(:,4);
    negSDTrain = analyzeMath(:,3) - analyzeMath(:,4);
    plot(numFeatVec,analyzeMath(:,3),'r'); hold on;
    plot(numFeatVec,posSDTrain,'color',[0.8500 0.3250 0.0980],'LineStyle',':'); hold on;
    plot(numFeatVec,negSDTrain,'color',[0.8500 0.3250 0.0980],'LineStyle',':'); hold on;
       
%     errorbar(numFeatVec,analyzeMath(:,1),analyzeMath(:,2),'b')
%     hold on
%     errorbar(numFeatVec,analyzeMath(:,3),analyzeMath(:,4),'r')
    xlabel('Num Of Select Feature')
    ylabel('accuracy [%]')
    ylim([50 100])
    Leg2 = legend('Validation','Train');
    set(Leg2,'location','southeast');
    
    figure
    suptitle('F1 Score by Num Of Features');
    plot(numFeatVec,analyzeMathF1(:,1),'r')
    xlabel('Num Of Select Feature')
    ylabel('F1 Score')
    
    [~,bestFeatNum] = max(analyzeMathF1(:,1));
end