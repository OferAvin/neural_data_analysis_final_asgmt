function makeFeaturesHist(Prmtr,Features,Data)
%this function loops through all features and creats histogram for each one
% of them.
% each figure plot using subplot the same feat for all channles
    lastFeat = size(Features.featMat,2);        %should be diff between elec feature
    jump = (size(Features.featMat,2) - 1)/2;    %co-responding feature for second electrode
    hist = cell(1,Prmtr.nclass);                %allocate space 
    for i = 1:(size(Features.featMat,2))/2      %loops through all features
        titlCell = cell(1,length(Prmtr.chans)); % co-responding title for all chans for each elec
        figure('Units','normalized','Position',Prmtr.Vis.globalPos);
        hold on;
        for k = 1:Prmtr.nchans
            subplot(length(Prmtr.chans),1,k)    %subplot the same fearure for each elect
            if(k~=1)        % check if use jump for co-responding feature for diff elec
                i = i + (jump*(k-1));
            end
            titlCell{k} = char(Features.featLables{i}); % select the co-responded feature name
            for j = 1:Prmtr.nclass
                %making the hist for each class
                hist{j} = histogram(Features.featMat(Data.indexes.(Prmtr.classes{j}),i),'nor','pr');
                hist{j}.BinEdges = Prmtr.Vis.binEdges;
                hold on;
                alpha(Prmtr.Vis.trnsp);
            end
            if(k == 1)
                legend(Prmtr.classes{1},Prmtr.classes{2})
            end
            title(titlCell{k}, 'Units','normalized','Position', Prmtr.Vis.globTtlPos);
            ylabel('Probability');
            if(k == length(Prmtr.chans))
                xlabel('Standad Deviation');
            end
        end 
        xlim(Prmtr.Vis.xLim);
        hold off;
    end
    %plot the last feature 
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    ttlast = char(Features.featLables{lastFeat}); % select the co-responded feature name for the last feature
    for j = 1:Prmtr.nclass
        hist{j} = histogram(Features.featMat(Data.indexes.(Prmtr.classes{j}),lastFeat),'nor','pr');
        hist{j}.BinEdges = Prmtr.Vis.binEdges;
        hold on;
        alpha(Prmtr.Vis.trnsp);
    end
    hold on;
    xlim(Prmtr.Vis.xLim);
    title(ttlast, 'Units','normalized','Position', Prmtr.Vis.globTtlPos);
    xlabel('Standard Deviation');
    ylabel('probability');
    legend(Prmtr.classes{1},Prmtr.classes{2});
    hold off;
end