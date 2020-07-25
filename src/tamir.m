%MATLAB 2019a
clear all
close all

%% expariment param
load('motor_imagery_train_data.mat');
fs = P_C_S.samplingfrequency;               %sampling frequency, Hz
dt = 1/fs;                                  %time step [sec]
trialLen = size(P_C_S.data,2);     
timeVec = dt:dt:trialLen/fs;
f = 0.5:0.1:40;
window = 2;                                 %window length in secs                         
windOverlap = 1.5;                          %window overlap length in secs
numOfWindows = floor((size(P_C_S.data,2)-window*fs)/(window*fs-windOverlap*fs)+1); %number of windows
miStart = 2.25;                             %motor imagery start in sec
miPeriod = timeVec(timeVec >= miStart);     %motor imagery period

chans = P_C_S.channelname(1:2);             %channels in use
chansName = ["c3" "c4"];                    %channels names should corresponds to chans 

classes = P_C_S.attributename(3:end);       %extract classes assuming rows 1,2 are artifact and remove 
clasRow = cellfun(@(x) find(ismember(P_C_S.attributename,x)), classes, 'un',false); %extartct classes rows 

Prmtr = struct('fs', fs, 'time', timeVec, 'freq', f, 'winLen', floor(window*fs),...
    'winOvlp', floor(windOverlap*fs),'miPeriod', miPeriod, 'classes', string(classes), ...
    'clasRow', cell2mat(clasRow), 'chans', str2num(cell2mat(chans)), 'chansName', chansName);

%% Data

Data.allData = P_C_S.data;
for i = 1:length(classes)
    currClass = Prmtr.classes(i);
    Data.indexes.(classes{i}) = find(P_C_S.attribute(Prmtr.clasRow(i),:)==1);
    for j = 1:length(Prmtr.chans)
        chanCls = char(currClass + Prmtr.chansName(j));
        Data.(chanCls) = Data.allData(Data.indexes.(classes{i}),:,Prmtr.chans(j));
    end
end

%% features
%band power features 1st arr - time range, 2nd - band
% Features.bandPower{1} = {[3.5,6],[15,20]};
% Features.bandPower{2} = {[4,6],[32,36]};
% Features.bandPower{3} = {[5.5,6],[9,11]};
% Features.bandPower{4} = {[1.2,2.7],[17,21]};

%% visualization
%first visualization
signalPerFig = 20; %signals per figuer 
plotPerRow = 4;    %plots per row 
plotPerCol = signalPerFig/plotPerRow; %make sure signalPerFig divisible with plotPerRow

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

condition = {'LEFTc3','LEFTc4','RIGHTc3','RIGHTc4'};

%visualization PWelch
plotPwelch(Data.PWelch,condition,f)
comparePowerSpec(Data.PWelch,condition,f)

% calculating spectrogram for all condition

for i =1:length(condition)
   Data.spect.(condition{i}) = zeros(size(Data.(condition{i}),1),size(f,2),numOfWindows);
   for j = 1:size(Data.(condition{i}),1)
      Data.spect.(condition{i})(j,:,:) = spectrogram(Data.(condition{i})(j,:)',...
          Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs,'yaxis');
   end
% convert the units to dB and average all spect for each cindition
    Data.spect.(condition{i}) = squeeze(mean(10*log10(abs(Data.spect.(condition{i}))).^2));
end

%visualization spectogram
plotSpectogram(Data.spect,condition,f,timeVec)
plotSpectDiff(Data.spect,condition,f,timeVec,1)  
plotSpectDiff(Data.spect,condition,f,timeVec,0) 








