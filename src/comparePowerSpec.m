function comparePowerSpec(C3LeftPwelch,C3RightPwelch,C4LeftPwelch,C4RightPwelch,f)
    figure
    subplot(2,1,1)
    plot(f,mean(C3LeftPwelch,2),'b')
    hold on
    plot(f,mean(C3RightPwelch,2),'r')
    title('Power Spectrom diff C3')
    ylabel('Power')
    legend('left','right')

    subplot(2,1,2)
    plot(f,mean(C4LeftPwelch,2),'b')
    hold on
    plot(f,mean(C4RightPwelch,2),'r')
    title('Power Spectrom diff C4')
    xlabel('Frequency[Hz]')
end
