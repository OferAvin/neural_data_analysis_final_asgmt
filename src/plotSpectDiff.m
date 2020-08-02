
function plotSpectDiff(Data,Prmtr)
%this function calculate mean diff between class for each chanle from the spectogram results
    diff1 = Data.spect.(Data.combLables{1})-Data.spect.(Data.combLables{3});
    diff2 = Data.spect.(Data.combLables{2})-Data.spect.(Data.combLables{4});
    spectDiffCond = {diff1,diff2};
    diffTitle = {'C3Diff','C4Diff'};
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    sgtitle('Spectogram Diff')
    for i = 1:length(spectDiffCond)
        subplot(1,length(spectDiffCond),i)
        imagesc(Prmtr.time,Prmtr.freq,spectDiffCond{i})
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(diffTitle{i})
        if(i == 1)
            ylabel ('Frequency [Hz]');
        end
        xlabel ('Time [sec]');
    end
    cb2 = colorbar;
    cb2.Label.String = 'Power diff [dB]';
    pos = [0.91868,0.324253,0.0117708,0.340874];
    lablPos = [3.9142857,0.54263613,0];
    set(cb2,'units','Normalized','position',pos,'FontSize',12);
    set(cb2.Label,'units','Normalized','position',lablPos,'FontSize',12);
    caxis('auto');
end