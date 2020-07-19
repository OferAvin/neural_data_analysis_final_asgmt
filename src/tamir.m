%MATLAB 2019a
clear all
close all

%% expariment param
load('motor_imagery_train_data.mat');
Fs = P_C_S.samplingfrequency;   % sampling frequency, Hz
dt = 1/Fs;                          % time step [sec]
f = 0.5:0.1:40;
windLen = 4;               % signal length in secs
windStep = 2;              % window step in secs
pwelchWindow = 2;           %window length in secs
pwelchOverlap = 1;          %window overlap length in secs
motorImageryRange = 240:1:768;
%bends
nFreqBands = 6;
delta = 0.5:0.1:4.5;
theta = 4.5:0.1:8;
lowAlpha = 8:0.1:11.5;
highAlpha = 11.5:0.1:15;
beta = 15:0.1:30;
gamma = 30:0.1:40;
waves = extractWavesIdx(delta, theta, lowAlpha, highAlpha, beta, gamma, f);


left_index = find(P_C_S.attribute(3,:)==1);
right_index = find(P_C_S.attribute(4,:)==1);
first_visualization(P_C_S.data,P_C_S.attribute,3,5,4)
first_visualization(P_C_S.data,P_C_S.attribute,4,5,4)


C3LeftPwelch = pwelch(P_C_S.data(left_index,(motorImageryRange),1),pwelchWindow,pwelchOverlap,f,Fs);
C3RightPwelch = pwelch(P_C_S.data(right_index,(motorImageryRange),1),pwelchWindow,pwelchOverlap,f,Fs);
C4LeftPwelch = pwelch(P_C_S.data(left_index,(motorImageryRange),2),pwelchWindow,pwelchOverlap,f,Fs);
C4RightPwelch = pwelch(P_C_S.data(right_index,(motorImageryRange),2),pwelchWindow,pwelchOverlap,f,Fs);
figure
subplot(2,2,1)
plot(f,mean(C3LeftPwelch,2))
subplot(2,2,2)
plot(f,mean(C4LeftPwelch,2))
subplot(2,2,3)
plot(f,mean(C3RightPwelch,2))
subplot(2,2,4)
plot(f,mean(C4RightPwelch,2))
figure
subplot(2,2,1)
spectrogram(mean(C3LeftPwelch,2),5,pwelchOverlap,f,Fs)
subplot(2,2,2)
spectrogram(mean(C4LeftPwelch,2),5,pwelchOverlap,f,Fs)
subplot(2,2,3)
spectrogram(mean(C3RightPwelch,2),5,pwelchOverlap,f,Fs)
subplot(2,2,4)
spectrogram(mean(C4RightPwelch,2),5,pwelchOverlap,f,Fs)





