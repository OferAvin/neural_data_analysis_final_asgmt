function bestFeatNum = analyzeNumOfFeat(Prmtr,analyzeMath,numSelectFeat)
% this function make an advance analysis to detarmain what is the best num
% of feature which will perform bast at the test.
% function use F1 Score and error of accuracy
% Prmtr - all parameter of the Data
    numFeatVec = 1:1:numSelectFeat;
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    suptitle('Validation Vs Train Accuracy');
    % validation plot
    ValErrorVec = 100 - analyzeMath(:,2);   %turning the acc to error
    posSDVal = ValErrorVec + analyzeMath(:,3);
    negSDVal = ValErrorVec - analyzeMath(:,3);
    V = plot(numFeatVec,ValErrorVec,'b'); hold on;
    upV = plot(numFeatVec,posSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    underV = plot(numFeatVec,negSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    % train plot
    TrainErrorVec = 100 - analyzeMath(:,4); %turning the acc to error
    posSDTrain = TrainErrorVec + analyzeMath(:,5);
    negSDTrain = TrainErrorVec - analyzeMath(:,5);
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
    plot(numFeatVec,analyzeMath(:,1),'b')
    xlabel('Num Of Selected Feature')
    ylabel('F1 Score')
    Leg3 = legend('F1 Score');
    set(Leg3,'location','southeast');
    [~,bestFeatNum] = max(analyzeMath(:,1));
end