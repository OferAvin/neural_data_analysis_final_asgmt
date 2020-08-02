
function plotSpectogram(Data,Prmtr)
%this function plot the spctral power for each condition returned by
%spectogram commend
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    %sgtitle('Power Spectogram');
    for i = 1:length(Data.combLables)   %looping all condition
        subplot(Prmtr.nclass,Prmtr.nchans,i)
        imagesc(Prmtr.time,Prmtr.freq,Data.spect.(Data.combLables{i}))
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(Data.combLables{i});
        if(mod(i-1,Prmtr.nchans) == 0)
            ylabel ('Frequency [Hz]');
        end
        if(i>2)
            xlabel ('Time [sec]');
        end
    end
    cb = colorbar;
    cb.Label.String = 'Power diff [dB]';
    cb.FontSize = 10;
    pos = [0.9,0.3,0.02,0.35];
    set(cb,'units','Normalized','position',pos);
    caxis('auto');
end
