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
window = 2;                                 %window length in secs                         
windOverlap = 1.5;                          %window overlap length in secs
numOfWindows = floor((size(P_C_S.data,2)-window*fs)/(window*fs-windOverlap*fs)+1); %number of windows
miStart = 2.25;                             %motor imagery start in sec
miPeriod = timeVec(timeVec >= miStart);     %motor imagery period
edgePrct = 90;                              %spectral edge percentaile

chans = P_C_S.channelname(1:2);             %channels in use
chansName = ["c3" "c4"];                    %channels names should corresponds to chans 
nchans = length(chans);

classes = P_C_S.attributename(3:end);       %extract classes assuming rows 1,2 are artifact and remove 
clasRow = cellfun(@(x) find(ismember(P_C_S.attributename,x)), classes, 'un',false); %extartct classes rows 
nclass = length(classes); 

Prmtr = struct('fs', fs, 'time', timeVec, 'freq', f, 'winLen', floor(window*fs),...
    'winOvlp', floor(windOverlap*fs),'miPeriod', miPeriod, 'classes', string(classes), ...
    'clasRow', cell2mat(clasRow), 'chans', str2num(cell2mat(chans)), 'chansName', chansName);

%% Data

Data.allData = P_C_S.data;
Data.combLables = cell(1,nchans*nclass);            %lables for channels*class combinations
Data.lables = strings(nTrials,1);
k = 1;
for i = 1:length(classes)
    currClass = Prmtr.classes(i);
    Data.indexes.(classes{i}) = find(P_C_S.attribute(Prmtr.clasRow(i),:)==1);
    Data.lables(Data.indexes.(classes{i})) = currClass;
    for j = 1:length(Prmtr.chans)
        chanCls = char(currClass + Prmtr.chansName(j));
        Data.(chanCls) = Data.allData(Data.indexes.(classes{i}),:,Prmtr.chans(j));
        Data.combLables{1,k} = chanCls;
        k = k+1;
    end
end

%% features
%band power features 1st arr - band, 2nd arr - time range
Features.bandPower{1} = {[15,20],[3.5,6]};
Features.bandPower{2} = {[32,36],[4,6]};
Features.bandPower{3} = {[9,11],[5.5,6]};
Features.bandPower{4} = {[17,21],[1.2,2.7]};

%mV threshold feature
Features.mVthrshld = 15;

Features.nFeat = (length(Features.bandPower)*2+2)*nchans; %bandpower and relative bandpower
% + threshold passed + max mV for each channel
%% Model training
k = 8;
numFeatSlect = 16;
results = cell(k,1);
trainErr = cell(k,1);
acc = zeros(k,1);

%% visualization
%first visualization
signalPerFig = 20;  %signals per figuer 
plotPerRow = 4;     %plots per row 
plotPerCol = signalPerFig/plotPerRow; %make sure signalPerFig divisible with plotPerRow
%histogram
xLim = [-4 4];      %x axis lims in sd 
minBinWid = 0.3;
alph = 0.5;
%%
%visualization rand trails
for i = 1:length(classes)
     signalVisualization(Data,Data.indexes.(classes{i}),classes{i},plotPerCol,plotPerRow)
end
% calculating PWelch for all condition
for i = 1:length(classes)
    for j = 1:length(Prmtr.chans)
        currClass = Prmtr.classes(i);
        chanCls = char(currClass + Prmtr.chansName(j));
        Data.PWelch.(chanCls) = pwelch(Data.(chanCls)(:,(Prmtr.miPeriod*fs))',...
            Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs);
    end
end

%visualization PWelch
plotPwelch(Data.PWelch,Data.combLables,Prmtr)
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
 plotSpectogram(Data.spect,Data.combLables,f,timeVec)
 plotSpectDiff(Data.spect,Data.combLables,f,timeVec,1)  
% plotSpectDiff(Data.spect,Data.combLables,f,timeVec,0) 

%% extracting features
featMat = zeros(nTrials,Features.nFeat);
fIdx = 1;
featLables = cell(1,Features.nFeat);

for i = 1:nchans
    for j = 1:length(Features.bandPower)   
        tRange = (Prmtr.time >= Features.bandPower{j}{2}(1) & ...
            Prmtr.time <= Features.bandPower{j}{2}(2));
        %raw bandpower
        featMat(:,fIdx) = ...
            (bandpower(Data.allData(:,tRange,i)',fs,Features.bandPower{j}{1}))';
        featLables{fIdx} =char("Bandpower - "+Prmtr.chansName(i)+" "+...
            Features.bandPower{j}{1}(1)+"Hz - "+Features.bandPower{j}{1}(2)+"Hz");
        fIdx = fIdx + 1;
        %relative bandpower
        totalBP = bandpower(Data.allData(:,tRange,i)')';
        featMat(:,fIdx) = featMat(:,fIdx-1)./totalBP;
        featLables{fIdx} = char("Relative Bandpower - "+Prmtr.chansName(i)+" "+...
            Features.bandPower{j}{1}(1)+"Hz - "+Features.bandPower{j}{1}(2)+"Hz");
        fIdx = fIdx + 1;
    end
    PW = pwelch(Data.allData(:,(Prmtr.miPeriod*fs),i)',...
            Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs);
    %total power and root total power    
    power = sum(PW);
    featMat(:,fIdx) = power';
    featLables{fIdx} = "Total Power";
    RTP = sqrt(power);
    featMat(:,fIdx+1) = RTP';
    featLables{fIdx+1} = "Root Total Power";
    %Spectral fit
    [slope,intercept] = specSlopeInter(PW,f);
    featMat(:,fIdx+2) = slope;
    featLables{fIdx+2} = "slope";
    featMat(:,fIdx+3) = real(log(intercept)); %return the intercept scale
    featLables{fIdx+3} = "intercept";
    probability = PW./power;    %normalize the power by the total power so it can be treated as a probability
    %spectralMoment
    featMat(:,fIdx+4) = (f*probability)';
    featLables{fIdx+4} = "Spectral Moment";
    %Spectral entropy
    featMat(:,fIdx+5) = (-sum(probability .* log2(probability),1))';
    featLables{fIdx+5} = "Spectral Entropy";
    %Spectral edge
    featMat(:,fIdx+6) = (spectralEdge(probability,f,edgePrct))';
    featLables{fIdx+6} = "Spectral Edge";
    fIdx = fIdx + 7;
    % mV threshold features
    for j = 1:nTrials
        %number of threshold passings
        ThPassVec = Data.allData(j,:,i) >= Features.mVthrshld;
        featMat(j,fIdx) = sum(abs(diff(ThPassVec)));
        % max mV
        maxV = max(Data.allData(j,:,i));
        featMat(j,fIdx+1) = maxV;
        % min mV
        minV = min(Data.allData(j,:,i));
        featMat(j,fIdx+2) = minV;
        % diff C4 - C3
        diffAmpSum = sum(Data.allData(j,(Prmtr.miPeriod*fs),2)-Data.allData(j,(Prmtr.miPeriod*fs),1));
        featMat(j,fIdx+3) = diffAmpSum;
    end
    featLables{fIdx} = char("Threshold Pass count - "+Features.mVthrshld+"mV");
    featLables{fIdx+1} = "Max mV";
    featLables{fIdx+2} = "Min mV";
    featLables{fIdx+3} = "diff C4 - C3";
    fIdx = fIdx + 4; 
end

%% histogram
featMat = zscore(featMat);
hist = cell(1,nclass);
binWid = zeros(1,nclass);

for i = 1:size(featMat,2)
    ttl = char(featLables{i});
    figure();
    for j = 1:length(classes)
        hist{j} = histogram(featMat(Data.indexes.(classes{j}),i));
        binWid(j) = hist{j}.BinWidth;
        hold on;
        alpha(alph);
    end
    minWid = max(min(binWid),minBinWid);
    cellfun(@(x) setfield(x,'BinWidth',minWid), hist,'un', false);
    cellfun(@(x) setfield(x,'BinCounts',x.BinCounts/nTrials), hist,'un', false); %normelize count  
    xlim(xLim);
    sgtitle(ttl);
    
    hold off;
end


featMat = zscore(featMat);


%% feature selection
 [featIdx,selectMat] = selectFeat(featMat,Data.lables,numFeatSlect);
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





confusionchart(cmT,["left" "right"]);

plotPCA(featMat,Data)







