function plotSpectogram(freq,time,condition,title)
    figure
    for i = 1:length(condition)
        subplot(2,2,i)
        imagesc(time,freq,condition{i})
        colorbar;
        caxis('auto');
        set(gca,'YDir','normal')
        colormap(jet);
        axis square
        %sgtitle(title{i});
        if(i==1)
            ylabel ('Frequency [Hz]');
        end
        if(i>2)
            xlabel ('Time [sec]');
        end
    end
end
