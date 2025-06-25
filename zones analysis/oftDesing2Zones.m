function zones=oftDesing2Zones(apparatusDesign, propOfTotalArea)

s = 0.001;

x0=apparatusDesign.x;
x0 = [x0 x0(1)];
y0=apparatusDesign.y;
y0 = [y0 y0(1)];

H=y0(3)-y0(1);
W=x0(3)-x0(1);

centerZone_SideSize_cmSize = sqrt( (H*W) * propOfTotalArea );

z1H = (H-centerZone_SideSize_cmSize)/2;
z1W = (W-centerZone_SideSize_cmSize)/2;
z2H = centerZone_SideSize_cmSize; 
z2W = centerZone_SideSize_cmSize;
interZone_xGap = (W-centerZone_SideSize_cmSize)/2;
interZone_yGap = (H-centerZone_SideSize_cmSize)/2;



xZ1(1:5)=x0(1:5);
yZ1(1:4)=y0(1:4);yZ1(5)=y0(5)+s;

xZ1(6) = xZ1(1) + interZone_xGap; 
yZ1(6) = yZ1(1) + interZone_yGap + s;

xZ1(7) = xZ1(6); yZ1(7) = yZ1(6) + z2H - s;
xZ1(8) = xZ1(7) + z2W; yZ1(8) = yZ1(7);
xZ1(9) = xZ1(8); yZ1(9) = yZ1(8)-z2H;
xZ1(10) = xZ1(9) - z2W; yZ1(10) = yZ1(9);
xZ1(11) = xZ1(1); yZ1(11) = yZ1(1);

zones(1).xV=xZ1;zones(1).yV=yZ1;
zones(1).type = 'border';

xZ2(1)=xZ1(10)+s;yZ2(1)=yZ1(10)+s;
xZ2(2)=xZ1(9)-s;yZ2(2)=yZ1(9)+s;
xZ2(3)=xZ2(2);yZ2(3)=yZ1(8)-s;
xZ2(4)=xZ2(1);yZ2(4)=yZ2(3);
xZ2(5)=xZ2(1);yZ2(5)=yZ2(1);

zones(2).xV=xZ2;zones(2).yV=yZ2;
zones(2).type = 'center';


% figure()
% hold on
% set(gca,'Ydir','reverse')
% axis equal
% % plot(x0,y0,'k:')
% % plot(xZ2,yZ2,'b');
% % plot(xZ1,yZ1,'r');



end

