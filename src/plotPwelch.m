%this function plot the mean spctral power for each condition returned by pwelch commend 
function plotPwelch(data,condition,freq,generalTitle)
    figure
    for i = 1:length(generalTitle)
        subplot(2,2,i)
        plot(freq,mean(data.(condition{i}),2))
        title(generalTitle{i});hold on
        if(i==1 || i==3)
            ylabel('Spectrom Power')
        end
        if(i>=3)
          xlabel('Frequency[Hz]')
        end
    end
    hold off
end
