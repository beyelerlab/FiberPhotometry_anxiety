function zones=threeChambersDesing2Zones(apparatusDesign)

x=apparatusDesign.x;
y=apparatusDesign.y;

apparatus_width = (x(2)-x(1))/3;

zones = [];

y1 = y(1);
y2 = y(3);

for i=1:3
    x1 =  apparatus_width*(i-1);
    x2 =  apparatus_width*(i);
    zones(i).xV = [x1 x2 x2 x1 x1];
    zones(i).yV = [y1 y1 y2 y2 y1];
    zones(i).type = sprintf('zone #%d',i);
end


% f1=figure();
% hold on
% axis equal
% % axis off
% % set(gca,'Ydir','reverse')
% for iZone=1:5
%     iZone
%     zones(iZone).position
%     rectangle('Position',zones(iZone).position,'EdgeColor',zones(iZone).color,'FaceColor','none','LineStyle',zones(iZone).lineStyle)
% end


end

