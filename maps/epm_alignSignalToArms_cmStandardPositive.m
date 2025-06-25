function alignedSignal = epm_alignSignalToArms_cmStandardPositive(params,Map,zones,outputPrefix)

for iZone=1:5
    zones(iZone).position = zones(iZone).position./params.MapScale_cmPerBin;
end

Z=[];LZ=[];     %ZS stands for Zoned Signal, LZS for linearized Zoned Signal
Sum=nan(1,5);
Armsum=nan(1,2);

for iZone =1:5
    
    x1=zones(iZone).position(1); if x1==0, x1=1;end; xMax = size(Map,2); if x1>xMax, x1=xMax;end
    y1=zones(iZone).position(2); if y1==0, y1=1;end;yMax = size(Map,1);if y1>yMax, y1=yMax;end
    x2 = x1 + zones(iZone).position(3); if x2==0, x2=1;end;xMax = size(Map,2);if x2>xMax, x2=xMax;end
    y2 = y1 + zones(iZone).position(4); if y2==0, y2=1;end;yMax = size(Map,1);if y2>yMax, y2=yMax;end
    
    % LSZ : Linear-Signal Zoned
    switch zones(iZone).positionSTR
        case 'NORTH'
            Z{iZone} = fliplr(Map(y1:y2,x1:x2)');
            LZ{iZone} = nanmean([Z{iZone}(:,:)]);
            Sum(1,iZone)=nanmean(nanmean([Z{iZone}(:,:)]));
        case 'EAST'
            Z{iZone} = Map(y1:y2,x1:x2);
            LZ{iZone}= nanmean([Z{iZone}(:,:)]);
            Sum(1,iZone)=nanmean(nanmean([Z{iZone}(:,:)]));
        case 'SOUTH'
            Z{iZone} = Map(y1:y2,x1:x2)';
            LZ{iZone} = nanmean([Z{iZone}(:,:)]);
            Sum(1,iZone)=nanmean(nanmean([Z{iZone}(:,:)]));
        case 'WEST'
            Z{iZone} = fliplr(Map(y1:y2,x1:x2));
            LZ{iZone} = nanmean([Z{iZone}(:,:)]);
            Sum(1,iZone)=nanmean(nanmean([Z{iZone}(:,:)]));
        case 'CENTER'
            LZ{iZone} = nanmedian(nanmedian(Map(y1:y2,x1:x2)));
          %  Sum(1,iZone)=nanmean(nanmean([Z{iZone}(:,:)]));
        end
    end

Openarm=nanmean((LZ{1,1}+LZ{1,3}),1);
Closearm=nanmean((LZ{1,2}+LZ{1,4}),1);
Armsum(1)=mean([Sum(1,1),Sum(1,3)]);
Armsum(2)=mean([Sum(1,2),Sum(1,4)]);


minLSZ=[];maxLSZ=[];

for iZone=1:5
    minLZ(iZone) = nanmin(LZ{iZone});
    maxLZ(iZone) = nanmax(LZ{iZone});
end
minLZ = nanmin(minLZ);
maxLZ = nanmax(maxLZ);

alignedSignal.twoDim=Z;
alignedSignal.oneDim=LZ;
alignedSignal.oneDimMax=maxLZ;
alignedSignal.oneDimMin=minLZ;
alignedSignal.sum=Sum;
alignedSignal.armsum=Armsum;
alignedSignal.Openarm=Openarm;
alignedSignal.Closearm=Closearm;


end