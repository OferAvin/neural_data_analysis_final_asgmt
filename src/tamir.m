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
pwelchWindow = 2*Fs;           %window length in secs
pwelchOverlap = 1*Fs;          %window overlap length in secs
motorImageryRange = 2.5*Fs:6*Fs;
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

left_C3 = P_C_S.data(left_index,:,1);
right_C3 = P_C_S.data(right_index,:,1);
left_C4 = P_C_S.data(left_index,:,2);
right_C4 = P_C_S.data(right_index,:,2);

first_visualization(P_C_S.data,P_C_S.attribute,3,5,4)
first_visualization(P_C_S.data,P_C_S.attribute,4,5,4)


C3LeftPwelch = pwelch(left_C3(:,motorImageryRange)',pwelchWindow,pwelchOverlap,f,Fs);
C3RightPwelch = pwelch(right_C3(:,motorImageryRange)',pwelchWindow,pwelchOverlap,f,Fs);
C4LeftPwelch = pwelch(left_C4(:,motorImageryRange)',pwelchWindow,pwelchOverlap,f,Fs);
C4RightPwelch = pwelch(right_C4(:,motorImageryRange)',pwelchWindow,pwelchOverlap,f,Fs);

plotPwelch(C3LeftPwelch,C3RightPwelch,C4LeftPwelch,C4RightPwelch,f)

comparePowerSpec(C3LeftPwelch,C3RightPwelch,C4LeftPwelch,C4RightPwelch,f)








% spectrogram(left_C3(i,:),pwelchWindow,pwelchOverlap,f,Fs,'yaxis')
% spectrogram(right_C3(i,:),pwelchWindow,pwelchOverlap,f,Fs,'yaxis')
% spectrogram(left_C4(i,:),pwelchWindow,pwelchOverlap,f,Fs,'yaxis')
% spectrogram(right_C4(i,:),pwelchWindow,pwelchOverlap,f,Fs,'yaxis')




