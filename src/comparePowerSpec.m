
function comparePowerSpec(data,condition,prmtr)
%this function compare the chanle for each class for the PWelch results
    figure
    %sgtitle('Compare Power Spec by chanle')
    for i =1:length(prmtr.chansName)
        subplot(2,1,i)
        plot(prmtr.freq,mean(data.(condition{i}),2),'b')
        hold on
        plot(prmtr.freq,mean(data.(condition{i+2}),2),'r')
        title(strcat('Power Spectrom diff',{'  '}', (prmtr.chansName{i})))
        ylabel('Power Spectrom')
        if(i>1)
            xlabel('Frequency[Hz]')
        end
        legend('left','right')
    end

end
