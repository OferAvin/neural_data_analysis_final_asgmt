function [Features] = extractFeatures(Data,Prmtr,Features,Matrix,fIdx)
% function that extract all fearures and arrange it in a matrix
% Data - all data for extracting the features
% Prmtr - all parameter of the Data
% Features - struct that containing all features data lables and parameters
% Matrix - train or test matrix
% fIdx - curr index for insert fearure and lable 
for i = 1:length(Prmtr.chans)
    for j = 1:length(Features.bandPower)    %looping over relevant range  
        tRange = (Prmtr.time >= Features.bandPower{j}{2}(1) & ...
            Prmtr.time <= Features.bandPower{j}{2}(2));
        %raw bandpower
        Features.(Matrix)(:,fIdx) = ...
            (bandpower(Data(:,tRange,i)',Prmtr.fs,Features.bandPower{j}{1}))';
        Features.featLables{fIdx} =char("Bandpower - "+Prmtr.chansName(i)+newline+...
            " "+Features.bandPower{j}{1}(1)+"Hz - "+Features.bandPower{j}{1}(2)+"Hz");
        fIdx = fIdx + 1;
        %relative bandpower
        totalBP = bandpower(Data(:,tRange,i)')';
        Features.(Matrix)(:,fIdx) = Features.(Matrix)(:,fIdx-1)./totalBP;
        Features.featLables{fIdx} = char("Relative Bandpower - "+Prmtr.chansName(i)+newline+...
            " "+Features.bandPower{j}{1}(1)+"Hz - "+Features.bandPower{j}{1}(2)+"Hz");
        fIdx = fIdx + 1;
    end
    PW = pwelch(Data(:,(Prmtr.miPeriod*Prmtr.fs),i)',...
            Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs);    %calc PWelch for features
    %total power and root total power    
    power = sum(PW);
    Features.(Matrix)(:,fIdx) = power';
    Features.featLables{fIdx} = char("Total Power " + Prmtr.chansName{i});  %update the feature name
    RTP = sqrt(power);
    Features.(Matrix)(:,fIdx+1) = RTP';
    Features.featLables{fIdx+1} = char("Root Total Power "+ Prmtr.chansName{i});%update the feature name
    %Spectral fit
    [slope,intercept] = specSlopeInter(PW,Prmtr.freq);
    Features.(Matrix)(:,fIdx+2) = slope;
    Features.featLables{fIdx+2} = char("Slope "+ Prmtr.chansName{i});%update the feature name
    Features.(Matrix)(:,fIdx+3) = real(log(intercept)); %return the intercept scale
    Features.featLables{fIdx+3} = char("Intercept "+ Prmtr.chansName{i});%update the feature name
    probability = PW./power;    %normalize the power by the total power so it can be treated as a probability
    %spectralMoment
    Features.(Matrix)(:,fIdx+4) = (Prmtr.freq*probability)';
    Features.featLables{fIdx+4} = char("Spectral Moment "+ Prmtr.chansName{i});%update the feature name
    %Spectral entropy
    Features.(Matrix)(:,fIdx+5) = (-sum(probability .* log2(probability),1))';
    Features.featLables{fIdx+5} = char("Spectral Entropy "+ Prmtr.chansName{i});%update the feature name
    %Spectral edge
    Features.(Matrix)(:,fIdx+6) = (spectralEdge(probability,Prmtr.freq,Prmtr.edgePrct))';
    Features.featLables{fIdx+6} = char("Spectral Edge "+ Prmtr.chansName{i});%update the feature name
    fIdx = fIdx + 7;
    %Threshold Pass count
    Features.(Matrix)(:,fIdx) = sum(abs(diff(Data(:,:,i) >= Features.mVthrshld,[],2)),2); %get sum of passed th
    Features.featLables{fIdx} = char("Threshold Pass Count "+ Features.mVthrshld+"mV " + Prmtr.chansName{i});%update the feature name
    %Max Voltage
    Features.(Matrix)(:,fIdx+1) = max(Data(:,:,i),[],2);
    Features.featLables{fIdx+1} = char("Max Voltage " + Prmtr.chansName{i});%update the feature name
    %Min Voltage
    Features.(Matrix)(:,fIdx+2) = min(Data(:,:,i),[],2);
    Features.featLables{fIdx+2} = char("Min Voltage " + Prmtr.chansName{i});%update the feature name
    fIdx = fIdx + 3; 
end

% diff Amplitude between channels
channle1 = find(Prmtr.chansName == Features.diffBetween(1));
channle2 = find(Prmtr.chansName == Features.diffBetween(2));
[diffAmpSum,description] = chanlDiffAmp(Data,Prmtr,channle1,channle2);
Features.(Matrix)(:,fIdx) = diffAmpSum;
Features.featLables{fIdx} = description;
end