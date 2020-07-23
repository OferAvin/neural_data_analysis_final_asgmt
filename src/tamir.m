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
    indexes = find(P_C_S.attribute(Prmtr.clasRow(i),:)==1);
    for j = 1:length(Prmtr.chans)
        chanCls = char(currClass + Prmtr.chansName(j));
        Data.(chanCls) = Data.allData(indexes,:,Prmtr.chans(j));
    end
end

%% features
%band power features 1st arr - time range, 2nd - band
Features.bandPower{1} = {[3.5,6],[15,20]};
Features.bandPower{2} = {[4,6],[32,36]};
Features.bandPower{3} = {[5.5,6],[9,11]};
Features.bandPower{4} = {[1.2,2.7],[17,21]};

%% visualization
%first visualization
signalPerFig = 20; %signals per figuer 
plotPerRow = 4;    %plots per row 
%%

signalVisualization(P_C_S.data,P_C_S.attribute,3,5,4)
signalVisualization(P_C_S.data,P_C_S.attribute,4,5,4)


C3LeftPwelch = pwelch(leftC3(:,Prmtr.miPeriod)',Prmtr.winLen,Prmtr.winOvlp,Prmtr.f,Prmtr.fs);
C3RightPwelch = pwelch(rightC3(:,Prmtr.miPeriod)',Prmtr.winLen,Prmtr.winOvlp,Prmtr.f,Prmtr.fs);
C4LeftPwelch = pwelch(leftC4(:,Prmtr.miPeriod)',Prmtr.winLen,Prmtr.winOvlp,Prmtr.f,Prmtr.fs);
C4RightPwelch = pwelch(rightC4(:,Prmtr.miPeriod)',Prmtr.winLen,Prmtr.winOvlp,Prmtr.f,Prmtr.fs);

PwelchCond = {C3LeftPwelch,C3RightPwelch,C4LeftPwelch,C4RightPwelch};
plotPwelch(PwelchCond,f,generalTitle)

comparePowerSpec(C3LeftPwelch,C3RightPwelch,C4LeftPwelch,C4RightPwelch,f)

spect_left_C3 = zeros(size(leftC3,1),size(f,2),9); %9 num of col the spectrogram return according the pwelchWindow,pwelchOverlap
spect_right_C3 = zeros(size(rightC3,1),size(f,2),9);
spect_left_C4 = zeros(size(leftC4,1),size(f,2),9);
spect_right_C4 = zeros(size(rightC4,1),size(f,2),9);
trails = size(leftC3,1);
for i = 1:trails
    spect_left_C3(i,:,:) = spectrogram(leftC3(i,:),pwelchWindow,pwelchOverlap,f,fs,'yaxis');
    spect_right_C3(i,:,:) = spectrogram(rightC3(i,:),pwelchWindow,pwelchOverlap,f,fs,'yaxis');
    spect_left_C4(i,:,:) = spectrogram(leftC4(i,:),pwelchWindow,pwelchOverlap,f,fs,'yaxis');
    spect_right_C4(i,:,:) = spectrogram(rightC4(i,:),pwelchWindow,pwelchOverlap,f,fs,'yaxis');
end

% convert the units to dB and average of the spectograma
spect_left_C3 = squeeze(mean(10*log10(abs(spect_left_C3)).^2));
spect_left_C4 = squeeze(mean(10*log10(abs(spect_left_C4)).^2));
spect_right_C3 = squeeze(mean(10*log10(abs(spect_right_C3)).^2));
spect_right_C4 = squeeze(mean(10*log10(abs(spect_right_C4)).^2));

spectCondition = {spect_left_C3,spect_left_C4,spect_right_C3,spect_right_C4};
plotSpectogram(f,timeVec,spectCondition,generalTitle)
plotSpectDiff(f,timeVec,spectCondition,1) 
plotSpectDiff(f,timeVec,spectCondition,0) 








