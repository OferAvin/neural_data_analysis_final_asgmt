function maxF1Idx = analyzeNumOfFeat(Prmtr,analyzeMath,Features)
% this function make an advance analysis to detarmain what is the best num
% of feature which will perform bast at the test.
% function use F1 Score and error of accuracy
% Prmtr - all parameter of the Data
    numFeatVec = 1:1:Features.nFeatSelect;
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    suptitle(char('Validation Vs Train Accuracyfor '+Features.fsMethod+' method'));
    % validation plot
    ValErrorVec = 100 - analyzeMath(:,2);   %turning the acc to error
    [minErr,minErIdx] = min(ValErrorVec);
    maxErr = max(ValErrorVec);
    posSDVal = ValErrorVec + analyzeMath(:,3);
    negSDVal = ValErrorVec - analyzeMath(:,3);
    V = plot(numFeatVec,ValErrorVec,'b'); hold on;
    upV = plot(numFeatVec,posSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    underV = plot(numFeatVec,negSDVal,'color',[0 0.4470 0.7410],'LineStyle',':'); hold on;
    minV = plot(numFeatVec(minErIdx),minErr,'or','Color','k','LineWidth',3);
    % train plot
    TrainErrorVec = 100 - analyzeMath(:,4); %turning the acc to error
    posSDTrain = TrainErrorVec + analyzeMath(:,5);
    negSDTrain = TrainErrorVec - analyzeMath(:,5);
    T = plot(numFeatVec,TrainErrorVec,'r'); hold on;
    upT = plot(numFeatVec,posSDTrain,'color',[0.8500 0.3250 0.0980],'LineStyle',':'); hold on;
    underT = plot(numFeatVec,negSDTrain,'color',[0.8500 0.3250 0.0980],'LineStyle',':'); hold on;
    
    ylabel('Error [%]')
    xlabel('Num Of Select Feature')
    ylim([0 maxErr+10])
    Leg2 = legend([V,upV,underV,T,upT,underT,minV],...
        {'Validation','Validation+SD','Validation-SD','Train','Train+SD','Train-SD','Min Error'});
    set(Leg2,'location','northeast');
    %F1 score plot
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    suptitle(char('F1 Score by Num Of Features for '+Features.fsMethod+' method'));
    P = plot(numFeatVec,analyzeMath(:,1),'b');
    hold on;
    xlabel('Num Of Selected Feature')
    ylabel('F1 Score')
    Leg3 = legend('F1 Score');
    set(Leg3,'location','southeast');
    [maxF1,maxF1Idx] = max(analyzeMath(:,1));
    Pmax = plot(numFeatVec(maxF1Idx),maxF1,'or','LineWidth',3);
    Leg3 = legend([P,Pmax],{'F1 score','max score'});
    set(Leg3,'location','southeast');
end