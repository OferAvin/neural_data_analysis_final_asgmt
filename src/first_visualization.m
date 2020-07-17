function first_visualization(data,lable,lableNum,row,col)
   lable_index = find(lable(lableNum,:)==1);
   index_trails = lable_index(randperm(length(lable_index),(row*col)));
   figure
%    if (lableNum==3)
%        sgtitle('left')
%    elseif(lableNum==4)
%        sgtitle('right')
%    end
   for i = 1:length(index_trails)
    subplot(row,col,i)
    plot(data(index_trails(i),:,1),'r')
    hold on
    plot(data(index_trails(i),:,2),'b')
    end
end
