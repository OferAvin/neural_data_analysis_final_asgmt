%% extracting features
Features.featMat = zeros(nTrials,Features.nFeat);
fIdx = 1;
Features.featLables = cell(1,Features.nFeat);

for i = 1:nchans
    for j = 1:length(Features.bandPower)   
        tRange = (Prmtr.time >= Features.bandPower{j}{2}(1) & ...
            Prmtr.time <= Features.bandPower{j}{2}(2));
        %raw bandpower
        Features.featMat(:,fIdx) = ...
            (bandpower(Data.allData(:,tRange,i)',fs,Features.bandPower{j}{1}))';
        Features.featLables{fIdx} =char("Bandpower - "+Prmtr.chansName(i)+newline+...
            Features.bandPower{j}{1}(1)+"Hz - "+Features.bandPower{j}{1}(2)+"Hz");
        fIdx = fIdx + 1;
        %relative bandpower
        totalBP = bandpower(Data.allData(:,tRange,i)')';
        Features.featMat(:,fIdx) = Features.featMat(:,fIdx-1)./totalBP;
        Features.featLables{fIdx} = char("Relative Bandpower - "+Prmtr.chansName(i)+newline+...
            Features.bandPower{j}{1}(1)+"Hz - "+Features.bandPower{j}{1}(2)+"Hz");
        fIdx = fIdx + 1;
    end
    PW = pwelch(Data.allData(:,(Prmtr.miPeriod*fs),i)',...
            Prmtr.winLen,Prmtr.winOvlp,Prmtr.freq,Prmtr.fs);
    %total power and root total power    
    power = sum(PW);
    Features.featMat(:,fIdx) = power';
    Features.featLables{fIdx} = "Total Power";
    RTP = sqrt(power);
    Features.featMat(:,fIdx+1) = RTP';
    Features.featLables{fIdx+1} = "Root Total Power";
    %Spectral fit
    [slope,intercept] = specSlopeInter(PW,f);
    Features.featMat(:,fIdx+2) = slope;
    Features.featLables{fIdx+2} = "slope";
    Features.featMat(:,fIdx+3) = real(log(intercept)); %return the intercept scale
    Features.featLables{fIdx+3} = "intercept";
    probability = PW./power;    %normalize the power by the total power so it can be treated as a probability
    %spectralMoment
    Features.featMat(:,fIdx+4) = (f*probability)';
    Features.featLables{fIdx+4} = "Spectral Moment";
    %Spectral entropy
    Features.featMat(:,fIdx+5) = (-sum(probability .* log2(probability),1))';
    Features.featLables{fIdx+5} = "Spectral Entropy";
    %Spectral edge
    Features.featMat(:,fIdx+6) = (spectralEdge(probability,f,edgePrct))';
    Features.featLables{fIdx+6} = "Spectral Edge";
    fIdx = fIdx + 7;
    % mV threshold features
    for j = 1:nTrials
        %number of threshold passings
        ThPassVec = Data.allData(j,:,i) >= Features.mVthrshld;
        Features.featMat(j,fIdx) = sum(abs(diff(ThPassVec)));
        % max mV
        maxV = max(Data.allData(j,:,i));
        Features.featMat(j,fIdx+1) = maxV;
        % min mV
        minV = min(Data.allData(j,:,i));
        Features.featMat(j,fIdx+2) = minV;
        % diff between electrodes
        diffAmpSum = sum(Data.allData(j,(Prmtr.miPeriod*fs),2)-Data.allData(j,(Prmtr.miPeriod*fs),1));
        Features.featMat(j,fIdx+3) = diffAmpSum;
    end
    Features.featLables{fIdx} = char("Threshold Pass count - "+Features.mVthrshld+"mV");
    Features.featLables{fIdx+1} = "Max mV";
    Features.featLables{fIdx+2} = "Min mV";
    Features.featLables{fIdx+3} = "diff C4 - C3";
    fIdx = fIdx + 4; 
end