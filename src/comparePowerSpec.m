
function comparePowerSpec(data,condition,f)
%this function compare the chanle for each class for the PWelch results
    figure
    %sgtitle('Compare Power Spec')
    subplot(2,1,1)
    plot(f,mean(data.(condition{1}),2),'b')
    hold on
    plot(f,mean(data.(condition{3}),2),'r')
    title('Power Spectrom diff C3')
    ylabel('Power Spectrom')
    legend('left','right')

    subplot(2,1,2)
    plot(f,mean(data.(condition{2}),2),'b')
    hold on
    plot(f,mean(data.(condition{4}),2),'r')
    title('Power Spectrom diff C4')
    xlabel('Frequency[Hz]')
    ylabel('Power Spectrom')
end
