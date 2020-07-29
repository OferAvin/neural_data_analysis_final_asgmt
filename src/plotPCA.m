function plotPCA(featMet,data)

    comp = pca(featMet);
    comp = comp(:,1:3);
    component = (featMet * comp)';
    figure
    %2 dimentional
    subplot(1,2,1)
    title('2 Dimentional PCA')
    scatter(component(1,(data.indexes.LEFT)),...
        component(2,(data.indexes.LEFT)),8,'b','filled');hold on;
    scatter(component(1,(data.indexes.RIGHT)),...
        component(2,(data.indexes.RIGHT)),8,'r','filled')
    axis square
    xlabel('PC1'); ylabel('PC2');
    %3 dimentional
    subplot(1,2,2)
    title('3 Dimentional PCA')
    scatter3(component(1,(data.indexes.LEFT)),...
        component(2,(data.indexes.LEFT)),component(3,(data.indexes.LEFT)),8,'b','filled')
    hold on;
    scatter3(component(1,(data.indexes.RIGHT)),...
        component(2,(data.indexes.RIGHT)),component(3,(data.indexes.RIGHT)),8,'r','filled')
    axis square
    xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
    legend('Left','Right');
end
