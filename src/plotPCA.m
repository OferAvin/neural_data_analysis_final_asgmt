function plotPCA(featMet,data)
%     N = size(featMet,1);       %trails num
%     Cov = featMet*featMet'./(N-1);  %covarience matrix
%     [EV,~] = eigs(Cov,3);
%     component = EV' * featMet;
    comp = pca(featMet);
    comp = comp(:,1:3);
    component = (featMet * comp)';
    figure
    %2 dimentional
    subplot(2,1,1)
    scatter(component(1,(data.indexes.LEFT)),...
        component(2,(data.indexes.LEFT)),8,'b','filled');hold on;
    scatter(component(1,(data.indexes.RIGHT)),...
        component(2,(data.indexes.RIGHT)),8,'r','filled')
    xlabel('PC1'); ylabel('PC2');
    %3 dimentional
    subplot(2,1,2)
    scatter3(component(1,(data.indexes.LEFT)),...
        component(2,(data.indexes.LEFT)),component(3,(data.indexes.LEFT)),8,'b','filled')
    hold on;
    scatter3(component(1,(data.indexes.RIGHT)),...
        component(2,(data.indexes.RIGHT)),component(3,(data.indexes.RIGHT)),8,'r','filled')
    xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
    legend('Left','Right');
end
