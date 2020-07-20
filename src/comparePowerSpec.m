function comparePowerSpec(C3LeftPwelch,C3RightPwelch,C4LeftPwelch,C4RightPwelch,f)
    figure
    subplot(2,1,1)
    %sgtitle('Power Spectrom diff C3')
    plot(f,mean(C3LeftPwelch,2),'b')
    hold on
    plot(f,mean(C3RightPwelch,2),'r')
    ylabel('Power')
    legend('left','right')

    subplot(2,1,2)
    %sgtitle('Power Spectrom diff C4')
    plot(f,mean(C4LeftPwelch,2),'b')
    hold on
    plot(f,mean(C4RightPwelch,2),'r')
    xlabel('Frequency[Hz]')
end
