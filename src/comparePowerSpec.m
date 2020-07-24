%this function compare the chanle for each class
function comparePowerSpec(data,condition,f)
    figure
    subplot(2,1,1)
    plot(f,mean(data.(condition{1}),2),'b')
    hold on
    plot(f,mean(data.(condition{3}),2),'r')
    title('Power Spectrom diff C3')
    ylabel('Spectrom Power')
    legend('left','right')

    subplot(2,1,2)
    plot(f,mean(data.(condition{2}),2),'b')
    hold on
    plot(f,mean(data.(condition{4}),2),'r')
    title('Power Spectrom diff C4')
    xlabel('Frequency[Hz]')
    ylabel('Spectrom Power')
end
