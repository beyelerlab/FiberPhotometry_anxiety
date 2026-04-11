function tmp=VelocityperZones(inZone,nZones,velocity)
tmp=nan(1,nZones);
%    fprintf('\n');
for iZone=1:nZones
    idx=find(inZone==iZone);
    tmp(iZone) = nanmean(velocity(idx)); 
%     fprintf('\tZone %d, bulkSignalStats = %2.2f\n',iZone,bulkSignalStats.zonesMeanAmp(iZone));
end