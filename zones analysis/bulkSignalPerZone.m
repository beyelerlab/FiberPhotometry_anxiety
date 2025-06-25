function bulkSignalStats=bulkSignalPerZone(inZone,nZones,zoneTime_fr,mainSig)
bulkSignalStats.zonesMeanAmp=nan(1,nZones);
for iZone=1:nZones
    idx=find(inZone==iZone);
    bulkSignalStats.zonesMeanAmp(iZone) = nanmean(mainSig(idx)); 
end