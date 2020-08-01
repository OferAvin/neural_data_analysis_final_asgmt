function bestFeatNum = analyzeNumOfFeat(Data,Prmtr,Features,k)
% this function make an advance analysis to detarmain what is the best num
% of feature which will perform bast at the test.
% function use F1 Score and error of accuracy
% Data - all data for analyzing the features
% Prmtr - all parameter of the Data
% Features - struct that containing all features data lables and parameters
% k - num for the k-fild validation
    numSelectFeat = size(Features.featMat,2);   % num of total features exstract
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
        % calculate F1 score using the confusion matrix for each num of features
        percision = cmT(1,1)/(cmT(1,1) + cmT(1,2));
        recall = cmT(1,1)/(cmT(1,1) + cmT(2,1));
        F1Score = 2*((percision*recall)/(percision+recall));
        analyzeMathF1(j,1) = F1Score;
        %calculate mean and sd to predict overfit
        analyzeMath(j,1) = mean(acc);        
        analyzeMath(j,2) = std(acc);
        trainAcc = (1-cell2mat(trainErr))*100;
        analyzeMath(j,3) = mean(trainAcc);
        analyzeMath(j,4) = std(trainAcc);
    end
    numFeatVec = 1:1:numSelectFeat;
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    suptitle('Validation Vs Train Accuracy');
    % validation plot
    ValErrorVec = 100 - analyzeMath(:,1);   %turning the acc to error
    posSDVal = ValErrorVec + analyzeMath(:,2);
    negSDVal = ValErrorVec - analyzeMath(:,2);
    V = plot(numFeatVec,ValErrorVec,'b'); hold on;
    upV = plot(numFeatVec,posSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    underV = plot(numFeatVec,negSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    % train plot
    TrainErrorVec = 100 - analyzeMath(:,3); %turning the acc to error
    posSDTrain = TrainErrorVec + analyzeMath(:,4);
    negSDTrain = TrainErrorVec - analyzeMath(:,4);
    T = plot(numFeatVec,TrainErrorVec,'r'); hold on;
    upT = plot(numFeatVec,posSDTrain,'color',[0.8500 0.3250 0.0980],'LineStyle',':'); hold on;
    underT = plot(numFeatVec,negSDTrain,'color',[0.8500 0.3250 0.0980],'LineStyle',':'); hold on;
    ylabel('Error [%]')
    xlabel('Num Of Select Feature')
    ylim([0 50])
    Leg2 = legend([V,upV,underV,T,upT,underT],...
        {'Validation','Validation+SD','Validation-SD','Train','Train+SD','Train-SD'});
    set(Leg2,'location','northeast');
    %F1 score plot
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    suptitle('F1 Score by Num Of Features');
    plot(numFeatVec,analyzeMathF1(:,1),'b')
    xlabel('Num Of Select Feature')
    ylabel('F1 Score')
    Leg3 = legend('F1 Score');
    set(Leg3,'location','southeast');
    [~,bestFeatNum] = max(analyzeMathF1(:,1));
end