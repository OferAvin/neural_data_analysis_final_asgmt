function plotPwelch(condition,freq,generalTitle)
    figure
    for i = 1:length(condition)
        subplot(2,2,i)
        plot(freq,mean(condition{i},2))
        title(generalTitle{i});hold on
        if(i==1)
            ylabel('Power')
        end
        if(i==4)
          xlabel('Frequency[Hz]')
        end
    end
    hold off
end
