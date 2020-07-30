
function plotSpectDiff(Data,Prmtr)
%this function calculate mean diff between class for each chanle from the spectogram results
    diff1 = Data.spect.(Data.combLables{1})-Data.spect.(Data.combLables{3});
    diff2 = Data.spect.(Data.combLables{2})-Data.spect.(Data.combLables{4});
    spectDiffCond = {diff1,diff2};
    diffTitle = {'C3Diff','C4Diff'};
    figure
    %sgtitle('Spectogram Diff')
    for i = 1:length(spectDiffCond)
        subplot(length(spectDiffCond),1,i)
        imagesc(Prmtr.time,Prmtr.freq,spectDiffCond{i})
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(diffTitle{i})
        ylabel ('Frequency [Hz]');
        if(i==2)
            xlabel ('Time [sec]');
        end
    end
    cb2 = colorbar;
    cb2.Label.String = 'Power diff [dB]';
    cb2.FontSize = 14;
    pos = [0.812024456521744,0.34541768089848,0.011770833412239,0.340874804998318];
    set(cb2,'units','Normalized','position',pos);
    caxis('auto');
end