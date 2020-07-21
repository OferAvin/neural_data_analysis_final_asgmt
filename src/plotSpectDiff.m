function plotSpectDiff(freq,time,condition)
    leftDiff = condition{1}-condition{3};
    rightDiff = condition{2}-condition{4};
    spectDiffCond = {leftDiff,rightDiff};
    figure
    for i = 1:length(spectDiffCond)
        subplot(length(spectDiffCond),1,i)
        imagesc(time,freq,spectDiffCond{i})
        colorbar;
        caxis('auto');
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        %sgtitle((spectDiffCond{i}))
        ylabel ('Frequency [Hz]');
        if(i>1)
            xlabel ('Time [sec]');
        end
    end     
end