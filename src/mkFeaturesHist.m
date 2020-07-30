function mkFeaturesHist(Prmtr,Features,Data)
%this function loops through all features and creats histogram for each of
%them

hist = cell(1,Prmtr.nclass);
binWid = zeros(1,Prmtr.nclass);
% ksPval = zeros(size(Features.featMat,2),1);


for i = 1:size(Features.featMat,2)
    ttl = char(Features.featLables{i});
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    hold on;
    for j = 1:Prmtr.nclass
        hist{j} = histogram(Features.featMat(Data.indexes.(Prmtr.classes{j}),i),'nor','pr');
        hist{j}.BinEdges = Prmtr.Vis.binEdges;
%         binWid(j) = hist{j}.BinWidth;
        hold on;
        alpha(Prmtr.Vis.trnsp);
    end
%     minWid = max(min(binWid),Prmtr.Vis.minBinWid);
%     cellfun(@(x) setfield(x,'BinWidth',minWid), hist,'un', false);                  %update bin size
%     cellfun(@(x) setfield(x,'BinCounts',x.BinCounts,hist,'un', false);              %normelize count  
    xlim(Prmtr.Vis.xLim);
    title(ttl, 'Units','normalized','Position', Prmtr.Vis.globTtlPos);
    hold off;
%     [h(i),p(i)] = kstest2(hist{1}.BinCounts,hist{2}.BinCounts);
end