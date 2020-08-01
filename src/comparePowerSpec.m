
function comparePowerSpec(Data,Prmtr)
%this function compare the chanle for each class for the PWelch results
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    %sgtitle('Compare Power Spec by chanle')
    for i =1:length(Prmtr.chansName)
        subplot(Prmtr.nchans,1,i)
        plot(Prmtr.freq,mean(Data.PWelch.(Data.combLables{i}),2),'b')   %left
        hold on
        plot(Prmtr.freq,mean(Data.PWelch.(Data.combLables{i+2}),2),'r') %right
        title(strcat('Power Spectrom diff',{'  '}', (Prmtr.chansName{i})))
        ylabel('Power Spectrom')
        if(i>1)
            xlabel('Frequency[Hz]')
        end
        legend(Prmtr.classes{1},Prmtr.classes{2})
    end
end
