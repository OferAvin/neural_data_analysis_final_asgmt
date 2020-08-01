function plotPwelch(Data,Prmtr)
%this function plot the mean spctral power by freq for each condition returned by pwelch commend
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    %sgtitle('Power Spect by PWelch')
    for i = 1:length(Data.combLables)   %looping all condition
        subplot(Prmtr.nchans,Prmtr.nclass,i)
        plot(Prmtr.freq,mean(Data.PWelch.(Data.combLables{i}),2))
        title(Data.combLables{i});hold on
        if(mod(i-1,Prmtr.nchans)==0)
            ylabel('Power Spectrom')
        end
        if(i>=3)
          xlabel('Frequency[Hz]')
        end
    end
    hold off
    comparePowerSpec(Data,Prmtr)
end
