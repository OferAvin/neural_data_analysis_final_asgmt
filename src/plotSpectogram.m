
function plotSpectogram(data,condition,freq,time)
%this function plot the spctral power for each condition returned by
%spectogram commend
    figure
    %sgtitle('Power Spectogram');
    for i = 1:length(condition)
        subplot(2,2,i)
        imagesc(time,freq,data.(condition{i}))
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        title(condition{i});
        if(i==1 || i==3)
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
