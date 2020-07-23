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
        subplot(1,length(spectDiffCond),i)
        imagesc(time,freq,spectDiffCond{i})
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(diffTitle{i})
        ylabel ('Frequency [Hz]');
        if(i>1)
            xlabel ('Time [sec]');
        end
    end
    cb = colorbar;
    pos = [0.94,0.3,0.02,0.35];
    set(cb,'units','Normalized','position',pos);
    caxis('auto');
end