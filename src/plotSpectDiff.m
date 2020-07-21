function plotSpectDiff(freq,time,condition)
    C3Diff = condition{1}-condition{3};
    C4Diff = condition{2}-condition{4};
    spectDiffCond = {C3Diff,C4Diff};
    diffTitle = {'C3Diff','C4Diff'};
    figure
    for i = 1:length(spectDiffCond)
        subplot(length(spectDiffCond),1,i)
        imagesc(time,freq,spectDiffCond{i})
        colorbar;
        caxis('auto');
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(diffTitle{i})
        ylabel ('Frequency [Hz]');
        if(i>1)
            xlabel ('Time [sec]');
        end
    end     
end