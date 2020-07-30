function [Features] = extractFeatures(Data,Prmtr,Features,fIdx)
% function that extract all fearures 
% Data - all data for extracting the features
% Prmtr - all parameter of the Data
% Features - struct that containing all features data lables and parameters
% fIdx - curr index for insert fearure and lable 
for i = 1:length(Prmtr.chans)
    for j = 1:length(Features.bandPower)   
        tRange = (Prmtr.time >= Features.bandPower{j}{2}(1) & ...
            Prmtr.time <= Features.bandPower{j}{2}(2));
        %raw bandpower
        Features.featMat(:,fIdx) = ...
            (bandpower(Data.allData(:,tRange,i)',Prmtr.fs,Features.bandPower{j}{1}))';
        Features.featLables{fIdx} ={"bandpower" ,Features.bandPower{fIdx-fIdx+1}};
        fIdx = fIdx + 1;
        %relative bandpower
        totalBP = bandpower(Data.allData(:,tRange,i)')';
        Features.featMat(:,fIdx) = Features.featMat(:,fIdx-1)./totalBP;
        Features.featLables{fIdx} ={"relative bandpower" ,Features.bandPower{fIdx-fIdx+1}};
        fIdx = fIdx + 1;
    end
    PW = pwelch(Data.allData(:,(Prmtr.miPeriod*Prmtr.fs),i)',...
            Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs);
    %total power and root total power    
    power = sum(PW);
    Features.featMat(:,fIdx) = power';
    Features.featLables{fIdx} = {"Total Power " + Prmtr.chansName{i}};
    RTP = sqrt(power);
    Features.featMat(:,fIdx+1) = RTP';
    Features.featLables{fIdx+1} = {"Root Total Power "+ Prmtr.chansName{i}};
    %Spectral fit
    [slope,intercept] = specSlopeInter(PW,Prmtr.freq);
    Features.featMat(:,fIdx+2) = slope;
    Features.featLables{fIdx+2} = {"Slope "+ Prmtr.chansName{i}};
    Features.featMat(:,fIdx+3) = real(log(intercept)); %return the intercept scale
    Features.featLables{fIdx+3} = {"Intercept "+ Prmtr.chansName{i}};
    probability = PW./power;    %normalize the power by the total power so it can be treated as a probability
    %spectralMoment
    Features.featMat(:,fIdx+4) = (Prmtr.freq*probability)';
    Features.featLables{fIdx+4} = {"Spectral Moment "+ Prmtr.chansName{i}};
    %Spectral entropy
    Features.featMat(:,fIdx+5) = (-sum(probability .* log2(probability),1))';
    Features.featLables{fIdx+5} = {"Spectral Entropy "+ Prmtr.chansName{i}};
    %Spectral edge
    Features.featMat(:,fIdx+6) = (spectralEdge(probability,Prmtr.freq,Prmtr.edgePrct))';
    Features.featLables{fIdx+6} = {"Spectral Edge "+ Prmtr.chansName{i}};
    fIdx = fIdx + 7;
    %Threshold Pass count
    Features.featMat(:,fIdx) = sum(diff(Data.allData(:,:,i) >= Features.mVthrshld,[],2),2); %get sum of passed th
    Features.featLables{fIdx} = {"Threshold Pass Count "+ Features.mVthrshld+"mV " + Prmtr.chansName{i}};
    %Max Voltage
    Features.featMat(:,fIdx+1) = max(Data.allData(:,:,i),[],2);
    Features.featLables{fIdx+1} = {"Max Voltage " + Prmtr.chansName{i}};
    %Min Voltage
    Features.featMat(:,fIdx+2) = min(Data.allData(:,:,i),[],2);
    Features.featLables{fIdx+2} = {"Min Voltage " + Prmtr.chansName{i}};
    fIdx = fIdx + 3; 
end

% diff Amplitude between chanle
[diffAmpSum,description] = chanlDiffAmp(Data,Prmtr,Prmtr.chans(2),Prmtr.chans(1));
Features.featMat(:,fIdx) = diffAmpSum;
Features.featLables{fIdx} = {description};
end