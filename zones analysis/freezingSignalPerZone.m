function freezingStats=freezingSignalPerZone(inZone,nZones,zoneTime_fr,freezingSig, framerate)
freezingStats.zonesFreezingTime=nan(1,nZones);
for iZone=1:nZones
    idx=find(inZone==iZone);
    freezingStats.zonesFreezingTime(iZone) = nansum(freezingSig(idx))./ framerate; 
end