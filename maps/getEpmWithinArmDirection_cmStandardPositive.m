function [OccIn,OccOut,SumSigIn,SumSigOut,Sigpoint_In,Sigpoint_Out]=getEpmWithinArmDirection_cmStandardPositive(x,y,sig,zones,xMax,yMax,cmPerBin)

% A minimum threshold for minimum mvt dst in order to consider the
% directionnality of the mvt.
% 0.75 px in one frame at 20Hz ~= 3.75mm per frame.
% Off course it is dependeing of the size of your pixel in cm according to
% the distance of the maze to the camera.
mvt_Th = 0.75;

xMin=0;yMin=0;
xMax=xMax/cmPerBin;yMax=yMax/cmPerBin;
x = x./cmPerBin;
y = y./cmPerBin;

for iZone=1:5
zones(iZone).X = zones(iZone).X/cmPerBin;
zones(iZone).Y = zones(iZone).Y/cmPerBin;
zones(iZone).W = zones(iZone).W/cmPerBin;
zones(iZone).H= zones(iZone).H/cmPerBin;
end

nPos=size(x,1);

% In : from the exterior to the center of the apparatus
% Out : from the center to the exterior of the apparatus

OccIn=zeros(yMax,xMax);OccOut=zeros(yMax,xMax);
SumSigIn=nan(yMax,xMax);SumSigOut=nan(yMax,xMax);
Sigpoint_In=zeros(nPos,1); Sigpoint_Out=zeros(nPos,1);

for iZone=1:5
    switch zones(iZone).positionSTR
        case 'NORTH'
            northLim = zones(iZone).Y + zones(iZone).H;
        case 'EAST'
            eastLim = zones(iZone).X;
        case 'SOUTH'
            southLim = zones(iZone).Y;
        case 'WEST'
            westLim = zones(iZone).X + zones(iZone).W;          
    end
end


for iPos=2:nPos
    
    if ~isnan(x(iPos)) && ~isnan(y(iPos)) && (x(iPos)>0) &&  (y(iPos)>0) && (x(iPos)<xMax) &&  (y(iPos)<yMax) 
        
        iX=floor(x(iPos))+1;iY=floor(y(iPos))+1;
        cZone=0;
        
        if iY<northLim, cZone=1; end
        if iY>southLim, cZone=3; end
        if iX<westLim, cZone=4; end
        if iX>eastLim, cZone=2; end
        
        xDir=x(iPos)-x(iPos-1);yDir=y(iPos)-y(iPos-1);
                
        gDir = 0; %-1 in, 1 out
        
        switch cZone
            case 1, if yDir>mvt_Th, gDir=1; end; if yDir<-mvt_Th, gDir=-1;end
            case 2, if xDir>mvt_Th, gDir=-1;end; if xDir<-mvt_Th, gDir=1;end
            case 3, if yDir<-mvt_Th, gDir=1;end; if yDir>mvt_Th, gDir=-1;end
            case 4, if xDir<-mvt_Th, gDir=-1;end; if xDir>mvt_Th, gDir=1;end
        end        
        
        if gDir==-1
            OccOut(iY,iX)=OccOut(iY,iX)+1;
            SumSigOut(iY,iX) = nansum([SumSigOut(iY,iX) sig(iPos)]);
            Sigpoint_Out(iPos,1)=1;                   
        end
        
        if gDir==1
            OccIn(iY,iX)=OccIn(iY,iX)+1;
            SumSigIn(iY,iX) = nansum([SumSigIn(iY,iX) sig(iPos)]);
            Sigpoint_In(iPos,1)=2;                                  
        end
                       
    end
end

end