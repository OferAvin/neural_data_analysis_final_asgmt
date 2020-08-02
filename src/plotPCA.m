function plotPCA(featMet,data,Prmtr)
% function that compute PCA and Ploting the seperation of 2 and 3 dimensions PCA 
    comp = pca(featMet);
    comp = comp(:,1:3);             %choose the best 3 PCA 
    component = (featMet * comp)';  % coded matrix
    figure('Units','normalized','Position',Prmtr.Vis.globalPos);
    sz = 11;    %Scatter dots size 
    %2 dimentional
    sgtitle("PCA Plots");
    subplot(1,2,1)
    scatter(component(1,(data.indexes.LEFT)),...
        component(2,(data.indexes.LEFT)),sz,'b','filled');hold on;
    hold on;
    scatter(component(1,(data.indexes.RIGHT)),...
        component(2,(data.indexes.RIGHT)),sz,'r','filled')
    title('2 Dimentional PCA')
    axis square
    xlabel('PC1'); ylabel('PC2');
    set(gca,'YDir','normal')
    %3 dimentional
    subplot(1,2,2)
    scatter3(component(1,(data.indexes.LEFT)),...
        component(2,(data.indexes.LEFT)),component(3,(data.indexes.LEFT)),sz,'b','filled')
    hold on;
    scatter3(component(1,(data.indexes.RIGHT)),...
        component(2,(data.indexes.RIGHT)),component(3,(data.indexes.RIGHT)),sz,'r','filled')
    title('3 Dimentional PCA')
    axis square
    xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
    set(gca,'YDir','normal')
    leg3 = legend(Prmtr.classes(1),Prmtr.classes(2));
    pos2 = [0.01203125,0.839907407407407,0.062239583333333,0.078148148148148];
    set(leg3,'position',pos2)
end
