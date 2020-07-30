function signalVisualization(data,indexClass,class,row,col)
% this function plot a random co-responding trails for each chanle on the same plot 
% the number of trails depend on the user selection
% generic function for all classes
   randIndex_trails = indexClass(randperm(length(indexClass),(row*col)));
   figure
%    if (class=='LEFT')
%        sgtitle('Left Imagery')
%    elseif(class=='RIGHT')
%        sgtitle('Right Imagery')
%    end
   for i = 1:length(randIndex_trails)
        subplot(row,col,i)
        C3 = plot(data.allData(randIndex_trails(i),:,1),'r');
        hold on
        C4 = plot(data.allData(randIndex_trails(i),:,2),'b');
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
    newUnits = 'normalized';
    set(Leg,'Position',[0.848091556210113 0.925793650793651 0.113690476190476 0.071031746031746],'Units', newUnits);
    
end
