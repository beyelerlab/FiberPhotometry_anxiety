function [x,y]=reorderPointsClockwise(x,y)

xCenter=mean(x);
yCenter=mean(y);
xTMP=x-xCenter;
yTMP=y-yCenter;
[theta,rho]=cart2pol(xTMP,yTMP);
[~,iSorted]=sort(theta);
x=xTMP(iSorted)+xCenter;
y=yTMP(iSorted)+yCenter;

end


