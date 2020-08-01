function makeFeaturesHist(Prmtr,Features,Data)
%this function loops through all features and creats histogram for each one
% of them
    jump = 18; %co-responding feature for second electrode
    lastFeat = size(Features.featMat,2);
    hist = cell(1,Prmtr.nclass);
    for i = 1:(size(Features.featMat,2))/2  % loops through all features
        titlCell = cell(1,length(Prmtr.chans)); % co-responding title for all chans for each elec
        figure('Units','normalized','Position',Prmtr.Vis.globalPos);
        hold on;
        for k = 1:length(Prmtr.chans)
            subplot(2,1,k)  %subplot the same fearure for each elect
            if(k~=1)        % check if use jump for co-responding feature for diff elec
                i = i + (jump*(k-1));
            end
            titlCell{k} = char(Features.featLables{i}); % select the co-responded feature name
            for j = 1:Prmtr.nclass
                hist{j} = histogram(Features.featMat(Data.indexes.(Prmtr.classes{j}),i),'nor','pr');
                hist{j}.BinEdges = Prmtr.Vis.binEdges;
                hold on;
                alpha(Prmtr.Vis.trnsp);
            end
            title(titlCell{k}, 'Units','normalized','Position', Prmtr.Vis.globTtlPos);
        end 
        xlim(Prmtr.Vis.xLim);
        legend(Prmtr.classes{1},Prmtr.classes{2})
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
    xlim(Prmtr.Vis.xLim);
    title(ttlast, 'Units','normalized','Position', Prmtr.Vis.globTtlPos);
    legend(Prmtr.classes{1},Prmtr.classes{2})
    hold off;
end