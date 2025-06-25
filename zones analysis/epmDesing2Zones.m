function zones=epmDesing2Zones(apparatusDesign)

x=apparatusDesign.x;
y=apparatusDesign.y;

i=1;
zones(i).type = 'open';
zones(i).color=[0 0 1];
zones(i).X=x(1);
zones(i).Y=y(1);
zones(i).W=x(2)-x(1);
zones(i).H=y(12)-y(1);
zones(i).positionSTR='WEST';
zones(i).lineStyle='-';
zones(i).position = [zones(i).X zones(i).Y zones(i).W zones(i).H];

i=2;
zones(i).type = 'closed';
zones(i).color=[1 0 0];
zones(i).X=x(3);
zones(i).Y=y(3);
zones(i).W=x(4)-x(3);
zones(i).H=y(2)-y(3);
zones(i).positionSTR='NORTH';
zones(i).lineStyle='-';
zones(i).position = [zones(i).X zones(i).Y zones(i).W zones(i).H];

i=3;
zones(i).type = 'open';
zones(i).color=[0 0 1];
zones(i).X=x(5);
zones(i).Y=y(5);
zones(i).W=x(6)-x(5);
zones(i).H=y(8)-y(5);
zones(i).positionSTR='EAST';
zones(i).lineStyle='-.';
zones(i).position = [zones(i).X zones(i).Y zones(i).W zones(i).H];

i=4;
zones(i).type = 'closed';
zones(i).color=[1 0 0];
zones(i).X=x(11);
zones(i).Y=y(11);
zones(i).W=x(8)-x(11);
zones(i).H=y(10)-y(11);
zones(i).positionSTR='SOUTH';
zones(i).lineStyle='-.';
zones(i).position = [zones(i).X zones(i).Y zones(i).W zones(i).H];

i=5;
zones(i).type = 'center';
zones(i).color=[0 1 0];
zones(i).X=x(2);
zones(i).Y=y(2);
zones(i).W=x(5)-x(2);
zones(i).H=y(11)-y(2);
zones(i).positionSTR='CENTER';
zones(i).lineStyle='-';
zones(i).position = [zones(i).X zones(i).Y zones(i).W zones(i).H];

for i=1:5
    pos= zones(i).position;x=pos(1);y=pos(2);w=pos(3);h=pos(4);
    zones(i).xV=[x x+w x+w x];zones(i).yV=[y y y+h y+h]; 
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

