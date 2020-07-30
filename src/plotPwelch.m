
function plotPwelch(Data,Prmtr)
%this function plot the mean spctral power by freq for each condition returned by pwelch commend
    figure
    %sgtitle('Power Spect by PWelch')
    for i = 1:length(Data.combLables)
        subplot(2,2,i)
        plot(Prmtr.freq,mean(Data.PWelch.(Data.combLables{i}),2))
        title(Data.combLables{i});hold on
        if(i==1 || i==3)
            ylabel('Power Spectrom')
        end
        if(i>=3)
          xlabel('Frequency[Hz]')
        end
    end
    hold off
    comparePowerSpec(Data,Prmtr)
end
