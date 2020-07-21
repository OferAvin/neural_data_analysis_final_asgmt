function plotSpectDiff(freq,time,condition,flag)
    if flag == 1
        diff1 = condition{1}-condition{3};
        diff2 = condition{2}-condition{4};
        spectDiffCond = {diff1,diff2};
        diffTitle = {'C3Diff','C4Diff'};
    else
        diff1 = condition{1}-condition{2};
        diff2 = condition{3}-condition{4};
        spectDiffCond = {diff1,diff2};
        diffTitle = {'left Diff','right Diff'};
    end
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