function MarkSwarm(data, cens, lbl, markerColor, markerShape, makerSize)
%     line(data(:, 1), data(:, 2),'Color','b','Marker','o',...
%         'Linestyle','none','Markersize',10)  
    figure(221)
    hold on;
    for k1 = 1:length(cens)
        scatter(data(lbl==k1,1),data(lbl==k1,2), 20, rand(1,3), 'filled');
        hold on
    end
    line(cens(:, 1), cens(:, 2),'Color',markerColor,'Marker',markerShape,...
        'Linewidth',2,'Linestyle','none', 'Markersize',makerSize)
    hold off
    grid minor
end