function signalVisualization(data,lable,lableNum,row,col)
   lable_index = find(lable(lableNum,:)==1);
   index_trails = lable_index(randperm(length(lable_index),(row*col)));
   figure
   if (lableNum==3)
       sgtitle('left')
   elseif(lableNum==4)
       sgtitle('right')
   end
   for i = 1:length(index_trails)
        subplot(row,col,i)
        C3 = plot(data(index_trails(i),:,1)-data(index_trails(i),:,2),'r');
%         hold on
%         C4 = plot(data(index_trails(i),:,2),'b');
        ylim([-15,15])
        if(i==20)
            xlabel('Nsample');
        end
        if(i==1)
            ylabel('Mv');
        end
   end
    hold on
%     Leg = legend([C3,C4],{'C3','C4'});
%     newUnits = 'normalized';
%     set(Leg,'Position',[0.848091556210113 0.925793650793651 0.113690476190476 0.071031746031746],'Units', newUnits);
    
end
