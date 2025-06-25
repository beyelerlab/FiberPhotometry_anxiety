function OccupancyMap=buildOccupancyMap_cmStandardPositive(x,y,xMax,yMax,cmPerBin)

xMin=0;yMin=0;
xMax=xMax/cmPerBin;yMax=yMax/cmPerBin;
x = x./cmPerBin;
y = y./cmPerBin;
xMax = ceil(xMax);yMax = ceil(yMax);
OccupancyMap = zeros(yMax,xMax);

nPos=size(x,1);

for iPos=1:nPos
    if ~isnan(x(iPos)) && ~isnan(y(iPos)) && (x(iPos)>0) &&  (y(iPos)>0) && (x(iPos)<xMax) &&  (y(iPos)<yMax) 
        i=floor(y(iPos))+1;j=floor(x(iPos))+1;
        OccupancyMap(i,j)=OccupancyMap(i,j)+1;
    end
end

end

