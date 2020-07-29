
function plotPwelch(data,condition,prmtr)
%this function plot the mean spctral power by freq for each condition returned by pwelch commend
%condition - all combination for the exp condition
    figure
    %sgtitle('Power Spect by PWelch')
    for i = 1:length(condition)
        subplot(2,2,i)
        plot(prmtr.freq,mean(data.(condition{i}),2))
        title(condition{i});hold on
        if(i==1 || i==3)
            ylabel('Power Spectrom')
        end
        if(i>=3)
          xlabel('Frequency[Hz]')
        end
    end
    hold off
    comparePowerSpec(data,condition,prmtr)
end
