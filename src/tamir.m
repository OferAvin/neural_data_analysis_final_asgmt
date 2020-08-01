%MATLAB 2019a
clear all
close all

%% expariment param
load('motor_imagery_train_data.mat');       % trainig data
testFileName = 'motor_imagery_test_data.mat';
fs = P_C_S.samplingfrequency;               %sampling frequency, Hz
dt = 1/fs;                                  %time step [sec]
nTrials = size(P_C_S.data,1);               % num of trails
trialLen = size(P_C_S.data,2);              % num of sample
timeVec = dt:dt:trialLen/fs;                %create time vec according to parameters
f = 0.5:0.1:40;                             % relevant freq range
window = 1.5;                               %window length in secs                         
windOverlap = 1.3;                          %window overlap length in secs
numOfWindows = floor((size(P_C_S.data,2)-window*fs)/(window*fs-windOverlap*fs)+1); %number of windows
miStart = 2.25;                             %motor imagery start in sec
miPeriod = timeVec(timeVec >= miStart);     %motor imagery period
edgePrct = 90;                              %spectral edge percentaile

chans = cell2mat(P_C_S.channelname(1:2));   %channels in use
chans = str2num(chans);
chansName = ["c3" "c4"];                    %channels names should corresponds to chans 
nchans = length(chans);                     % num of channels

nclass = 2;                                 %this project support two classes only
classes = P_C_S.attributename(3:end);       %extract classes assuming rows 1,2 are artifact and remove 
classes = string(classes);
clasRow = cellfun(@(x) find(ismember(P_C_S.attributename,x)), classes, 'un',false); %extartct classes rows 
ntrialsPerClass = [sum(P_C_S.attribute(clasRow{1},:)==1),...
    sum(P_C_S.attribute(clasRow{2},:)==1)];

% creating struct for all relevant parameters
Prmtr = struct('fs',fs,'time',timeVec,'freq',f,'nTrials',nTrials,'winLen',floor(window*fs),...
    'winOvlp',floor(windOverlap*fs),'miPeriod',miPeriod,'nclass',nclass,'classes',classes, ...
    'clasRow',cell2mat(clasRow),'ntrialsPerClass',ntrialsPerClass,...
    'chans',chans,'chansName',chansName,'edgePrct',edgePrct);

flag = 0; % to check the best num of features to select using analyzeNumOfFeat function
% flag = 0; % use Features.nFeatSelect pram for the features selection

%% Data
% creating struct for all relevant data and arrange it 
Data.allData = P_C_S.data;
Data.combLables = cell(1,nchans*nclass);        %lables for channels*class combinations
Data.lables = strings(nTrials,1);               %lable each trail for his class
k = 1;
for i = 1:nclass
    currClass = classes(i);
    Data.indexes.(classes{i}) = find(P_C_S.attribute(Prmtr.clasRow(i),:)==1);   %finding the indexes for each class
    Data.lables(Data.indexes.(classes{i})) = currClass;                         %lable each trail for his class
    for j = 1:nchans
        chanCls = char(currClass + chansName(j));                               %creating combination name
        Data.(chanCls) = Data.allData(Data.indexes.(classes{i}),:,chans(j));    %arrange data by combination
        Data.combLables{1,k} = chanCls;
        k = k+1;
    end
end

%% features
% creating struct for the features
Features.nFeatSelect = 7 ;     %number of features to select for classification
%band power features 1st arr - band, 2nd arr - time range
Features.bandPower{1} = {[15,20],[3.5,6]};
Features.bandPower{2} = {[32,36],[4,6]};
Features.bandPower{3} = {[9,11],[5.5,6]};
Features.bandPower{4} = {[17,21],[1.2,2.7]};
%mV threshold feature
Features.mVthrshld = 4;
Features.diffBetween = ["c3","c4"];             % choose elctrode to calc diff
nBandPowerFeat = length(Features.bandPower)*2;  %bandpower and relative bandpower for each relevant range
moreFeat = 10;             %Total Power,Root Total Power,Slope,Intercept,Spectral Moment,Spectral Entropy
%Spectral Edge,Threshold Pass Count,Max Voltage,Min Voltage

bothChanFeatTogether = 1;                       %diff Amplitude between chanle
Features.nFeat = ((nBandPowerFeat+moreFeat)*nclass)+ bothChanFeatTogether; %num of total features
%feature selection method

Features.sfMethod = "ks";       %choose between cna  and ks



%% Model training
k = 5;                  %k fold parameter
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

%visualization of the signal in Voltage[mV] for rand co-responding trails 
for i = 1:length(classes)
      signalVisualization(Data,i,Prmtr)
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
plotPwelch(Data,Prmtr)
 
% calculating spectrogram for all conditions

for i =1:length(Data.combLables)    %looping all condition
   Data.spect.(Data.combLables{i}) = zeros(size(Data.(Data.combLables{i}),1),size(f,2),numOfWindows);   %allocate space
   for j = 1:size(Data.(Data.combLables{i}),1)
      Data.spect.(Data.combLables{i})(j,:,:) = spectrogram(Data.(Data.combLables{i})(j,:)',...
          Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs,'yaxis');
   end
% convert the units to dB and average all spect for each cindition
    Data.spect.(Data.combLables{i}) = squeeze(mean(10*log10(abs(Data.spect.(Data.combLables{i}))).^2));
end

%visualization spectogram
plotSpectogram(Data,Prmtr)
plotSpectDiff(Data,Prmtr)  
 

%% extracting features
Features.featMat = zeros(nTrials,Features.nFeat);       %allocate space
fIdx = 1;                                               % index for the co-responding feature to  col
Features.featLables = cell(1,Features.nFeat);           %allocate space to features name
Features = extractFeatures(Data.allData,Prmtr,Features,'featMat',fIdx);   %calc and extract all features
[Features.featMat,meanTrain,SdTrain] = zscore(Features.featMat);            % scale all features

%% histogram
makeFeaturesHist(Prmtr,Features,Data);

%% feature selection
if flag == 1
    Features.nFeatSelect = analyzeNumOfFeat(Data,Prmtr,Features,k);
end 
%select only the best features 
[featIdx,selectMat] = selectFeat(Features,Data.lables,binEdges,Features.nFeatSelect); 

%% k fold cross-validation

idxSegments = mod(randperm(nTrials),k)+1;   %randomly split trails in to k groups
cmT = zeros(nclass,nclass);                 % allocate space for confusion matrix

for i = 1:k
% each test on 1 group and train on the else
    validSet = logical(idxSegments == i)';
    trainSet = logical(idxSegments ~= i)';
    [results{i},trainErr{i}] = classify(selectMat(validSet,:),selectMat(trainSet,:),Data.lables(trainSet),'linear');
    acc(i) = sum(results{i} == Data.lables(validSet));
    acc(i) = acc(i)/length(results{i})*100;
    %build the confusion matrix
    cm = confusionmat(Data.lables(validSet),results{i});
    cmT = cmT + cm;
end
%calculate and print results
printAcc(acc,1);
trainAcc = (1-cell2mat(trainErr))*100;
printAcc(trainAcc,0);

%% Last Plot
confusionchart(cmT,[classes(1) classes(2)]);
% plot PCA
plotPCA(Features.featMat,Data,Prmtr)


%% Test
%Load test data


load(testFileName)
testData = data(:,:,1:length(Prmtr.chans));

%Test feature extraction

Features.TestFeatMat = zeros(size(testData,1),Features.nFeat);                   %allocate space
Features = extractFeatures(testData,Prmtr,Features,'TestFeatMat',fIdx);     %calc and extract all features

%Test feature selection
Features.TestFeatMat = Features.TestFeatMat(:,featIdx);                 %choosing the same features
Features.TestFeatMat = (Features.TestFeatMat - meanTrain(:,featIdx))./SdTrain(:,featIdx);      % scale according to train data

%Test classifier - output is the classifier predictions for test data.
testPredict = classify(Features.TestFeatMat,selectMat,Data.lables,'linear');








