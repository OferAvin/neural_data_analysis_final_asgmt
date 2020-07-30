%MATLAB 2019a
clear all
close all

%% expariment param
load('motor_imagery_train_data.mat');
fs = P_C_S.samplingfrequency;               %sampling frequency, Hz
dt = 1/fs;                                  %time step [sec]
nTrials = size(P_C_S.data,1);     
trialLen = size(P_C_S.data,2);     
timeVec = dt:dt:trialLen/fs;
f = 0.5:0.1:40;
window = 1.5;                                 %window length in secs                         
windOverlap = 1.3;                          %window overlap length in secs
numOfWindows = floor((size(P_C_S.data,2)-window*fs)/(window*fs-windOverlap*fs)+1); %number of windows
miStart = 2.25;                             %motor imagery start in sec
miPeriod = timeVec(timeVec >= miStart);     %motor imagery period
edgePrct = 90;                              %spectral edge percentaile

chans = cell2mat(P_C_S.channelname(1:2));   %channels in use
chans = str2num(chans);
chansName = ["c3" "c4"];                    %channels names should corresponds to chans 
nchans = length(chans);

nclass = 2;                                 %this project support two classes only
classes = P_C_S.attributename(3:end);       %extract classes assuming rows 1,2 are artifact and remove 
classes = string(classes);
clasRow = cellfun(@(x) find(ismember(P_C_S.attributename,x)), classes, 'un',false); %extartct classes rows 
ntrialsPerClass = [sum(P_C_S.attribute(clasRow{1},:)==1),...
    sum(P_C_S.attribute(clasRow{2},:)==1)];


Prmtr = struct('fs',fs,'time',timeVec,'freq',f,'nTrials',nTrials,'winLen',floor(window*fs),...
    'winOvlp',floor(windOverlap*fs),'miPeriod',miPeriod,'nclass',nclass,'classes',classes, ...
    'clasRow',cell2mat(clasRow),'ntrialsPerClass',ntrialsPerClass,...
    'chans',chans,'chansName',chansName,'edgePrct',edgePrct);


%% Data

Data.allData = P_C_S.data;
Data.combLables = cell(1,nchans*nclass);            %lables for channels*class combinations
Data.lables = strings(nTrials,1);
k = 1;
for i = 1:nclass
    currClass = classes(i);
    Data.indexes.(classes{i}) = find(P_C_S.attribute(Prmtr.clasRow(i),:)==1);
    Data.lables(Data.indexes.(classes{i})) = currClass;
    for j = 1:nchans
        chanCls = char(currClass + chansName(j));
        Data.(chanCls) = Data.allData(Data.indexes.(classes{i}),:,chans(j));
        Data.combLables{1,k} = chanCls;
        k = k+1;
    end
end

%% features
Features.nFeatSelect = 10 ;     %number of features to select for classification
%band power features 1st arr - band, 2nd arr - time range
Features.bandPower{1} = {[15,20],[3.5,6]};
Features.bandPower{2} = {[32,36],[4,6]};
Features.bandPower{3} = {[9,11],[5.5,6]};
Features.bandPower{4} = {[17,21],[1.2,2.7]};
%mV threshold feature
Features.mVthrshld = 4;
Features.nFeat = (length(Features.bandPower)*2+2)*nchans; %bandpower and relative bandpower
%feature selection method
Features.sfMethod = "nca" ;%choose between cna  and ks
%% Model training
k = 5;              %k fold parameter
results = cell(k,1);
trainErr = cell(k,1);
acc = zeros(k,1);

%% visualization
globalPos = [0.2,0.15,0.6,0.7]; %global position for figures
globTtlPos = [0.45,0.999];      %global title position
%first visualization
signalPerFig = 20;  %signals per figuer 
plotPerRow = 4;     %plots per row 
plotPerCol = signalPerFig/plotPerRow; %make sure signalPerFig divisible with plotPerRow
%histogram
xLim = [-4 4];      %x axis lims in sd 
binWid = 0.2;
trnsp = 0.5;        %bars transparency
binEdges = xLim(1):binWid:xLim(2);

Prmtr.Vis = struct('globalPos', globalPos,'globTtlPos',globTtlPos,...
    'signalPerFig',signalPerFig,'plotPerRow',plotPerRow,'plotPerCol',plotPerCol,...
    'xLim',xLim,'binEdges',binEdges,'trnsp',trnsp);
%%
%visualization rand trails
for i = 1:length(classes)
%      signalVisualization(Data,Data.indexes.(classes{i}),classes{i},plotPerCol,plotPerRow)
end
% calculating PWelch for all condition
for i = 1:length(classes)
    for j = 1:length(Prmtr.chans)
        currClass = Prmtr.classes(i);
        chanCls = char(currClass + chansName(j));
        Data.PWelch.(chanCls) = pwelch(Data.(chanCls)(:,(Prmtr.miPeriod*fs))',...
            Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs);
    end
end

%visualization PWelch
% plotPwelch(Data.PWelch,Data.combLables,Prmtr)
% calculating spectrogram for all conditions

for i =1:length(Data.combLables)
   Data.spect.(Data.combLables{i}) = zeros(size(Data.(Data.combLables{i}),1),size(f,2),numOfWindows);
   for j = 1:size(Data.(Data.combLables{i}),1)
      Data.spect.(Data.combLables{i})(j,:,:) = spectrogram(Data.(Data.combLables{i})(j,:)',...
          Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs,'yaxis');
   end
% convert the units to dB and average all spect for each cindition
    Data.spect.(Data.combLables{i}) = squeeze(mean(10*log10(abs(Data.spect.(Data.combLables{i}))).^2));
end

%visualization spectogram
%  plotSpectogram(Data.spect,Data.combLables,f,timeVec)
%  plotSpectDiff(Data.spect,Data.combLables,f,timeVec,1)  
% plotSpectDiff(Data.spect,Data.combLables,f,timeVec,0) 

%% extracting features
Features.featMat = zeros(nTrials,Features.nFeat);
fIdx = 1;
Features.featLables = cell(1,Features.nFeat);
Features = extractFeatures(Data,Prmtr,Features,fIdx);
Features.featMat = zscore(Features.featMat);

%% histogram
mkFeaturesHist(Prmtr,Features,Data);

%% feature selection
 [featIdx,selectMat] = selectFeat(Features,Data.lables,binEdges);
 [~,colind] = rref(selectMat);       % check for lineary dependent col and remove them
% [~,colind] = rref(featMat);
% featMat = featMat(:, colind); 
 selectMat = selectMat(:, colind); 


%% k fold cross-validation

idxSegments = mod(randperm(nTrials),k)+1;
cmT = zeros(nclass,nclass);

for i = 1:k
    testSet = logical(idxSegments == i)';
    trainSet = logical(idxSegments ~= i)';
    [results{i},trainErr{i}] = classify(selectMat(testSet,:),selectMat(trainSet,:),Data.lables(trainSet),'linear');
    acc(i) = sum(results{i} == Data.lables(testSet));
    acc(i) = acc(i)/length(results{i})*100;
    
    cm = confusionmat(Data.lables(testSet),results{i});
    cmT = cmT + cm;
end

printAcc(acc,1);
trainAcc = (1-cell2mat(trainErr))*100;
printAcc(trainAcc,0);
confusionchart(cmT,[classes(1) classes(2)]);

plotPCA(Features.featMat,Data)







