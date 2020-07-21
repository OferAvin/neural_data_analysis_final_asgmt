function plotPwelch(condition,freq)
    figure
    for i = 1:length(condition)
        subplot(2,2,i)
        plot(freq,mean(condition{i},2))
        %sgtitle('C3_left')
        if(i==1)
            ylabel('Power')
        end
        if(i==4)
          xlabel('Frequency[Hz]')
        end
    end
end
