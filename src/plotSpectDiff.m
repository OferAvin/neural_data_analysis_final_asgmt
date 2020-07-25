%this function compare the chanle or the class-depending on the user
%selection by flag, from the spectogram results
function plotSpectDiff(data,condition,freq,time,flag)
    if flag == 1
        diff1 = data.(condition{1})-data.(condition{3});
        diff2 = data.(condition{2})-data.(condition{4});
        spectDiffCond = {diff1,diff2};
        diffTitle = {'C3Diff','C4Diff'};
    else
        diff1 = data.(condition{1})-data.(condition{2});
        diff2 = data.(condition{3})-data.(condition{4});
        spectDiffCond = {diff1,diff2};
        diffTitle = {'left Diff','right Diff'};
    end
    figure
    %sgtitle('Spectogram Diff')
    for i = 1:length(spectDiffCond)
        subplot(1,length(spectDiffCond),i)
        imagesc(time,freq,spectDiffCond{i})
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(diffTitle{i})
        ylabel ('Frequency [Hz]');
        if(i>=1)
            xlabel ('Time [sec]');
        end
    end
    cb = colorbar;
    pos = [0.94,0.3,0.02,0.35];
    set(cb,'units','Normalized','position',pos);
    caxis('auto');
end