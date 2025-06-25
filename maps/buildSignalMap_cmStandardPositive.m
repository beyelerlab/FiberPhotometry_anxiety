function SigMap=buildSignalMap_cmStandardPositive(x,y,sig,xMax,yMax,cmPerBin)

xMin=0;yMin=0;
xMax=xMax/cmPerBin;yMax=yMax/cmPerBin;
x = x./cmPerBin;
y = y./cmPerBin;
xMax = ceil(xMax);yMax = ceil(yMax);
SigMap = nan(yMax,xMax);

nPos=size(x,1);
for iPos=1:nPos
    if ~isnan(x(iPos)) && ~isnan(y(iPos)) && (x(iPos)>0) &&  (y(iPos)>0) && (x(iPos)<xMax) &&  (y(iPos)<yMax) 
        i=floor(y(iPos))+1;j=floor(x(iPos))+1;
        SigMap(i,j)= nansum([SigMap(i,j) sig(iPos)]);
    end
end
end
