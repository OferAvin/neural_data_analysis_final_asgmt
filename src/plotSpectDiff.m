
function plotSpectDiff(data,condition,freq,time)
%this function calculate mean diff between class for each chanle from the spectogram results
    diff1 = data.(condition{1})-data.(condition{3});
    diff2 = data.(condition{2})-data.(condition{4});
    spectDiffCond = {diff1,diff2};
    diffTitle = {'C3Diff','C4Diff'};
    figure
    %sgtitle('Spectogram Diff')
    for i = 1:length(spectDiffCond)
        subplot(1,length(spectDiffCond),i)
        imagesc(time,freq,spectDiffCond{i})
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(diffTitle{i})
        xlabel ('Time [sec]');
        if(i==1)
            ylabel ('Frequency [Hz]');
        end
    end
    cb2 = colorbar;
    cb2.Label.String = 'Power diff [dB]';
    cb2.FontSize = 10;
    pos = [0.892708335138942,0.100813007884849,0.016666666666667,0.814634130891833];
    set(cb2,'units','Normalized','position',pos);
    caxis('auto');
end