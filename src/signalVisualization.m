function signalVisualization(Data,class,Prmtr)
% this function plot the Voltage[mV] for a random co-responding trails for each chanle on the same plot 
% the number of trails depend on the pramter
% generic function for all classes
   randIndex_trails = Data.indexes.(Prmtr.classes{class})...
       (randperm(length(Data.indexes.(Prmtr.classes{class})),...
       (Prmtr.Vis.plotPerRow*Prmtr.Vis.plotPerCol)));   %choose rand trails
   figure('Units','normalized','Position',Prmtr.Vis.globalPos);
%    sgtitle(Prmtr.classes{class} + " " + "Imagery")
   for i = 1:length(randIndex_trails)
        subplot(Prmtr.Vis.plotPerCol,Prmtr.Vis.plotPerRow,i)
        C3 = plot(Data.allData(randIndex_trails(i),:,1),'r');   %c3 signal
        hold on
        C4 = plot(Data.allData(randIndex_trails(i),:,2),'b');   %c4 signal
        ylim([-15,15])
        if(i>=17)
            xlabel('sample num');
        end
        toLable = [1,5,9,13,17];
        if(ismember(i,toLable))
            ylabel('Voltage[Mv]');
        end
   end
    hold on
    Leg = legend([C3,C4],{'C3','C4'});
    set(Leg,'Position',[0.848091556210113 0.925793650793651 0.113690476190476 0.071031746031746],'Units', 'normalized');
end
