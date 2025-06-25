function transientStats=transientsPerZone(inZone,nZones,zoneTime_fr,transients)

transientStats.zonesMeanAmp=nan(1,nZones);
transientStats.zonesCounts=nan(1,nZones);
transientStats.zonesProba=nan(1,nZones);

% allTransients_indices = [transients.indices];
% if transientsStats.idx

allTransientsIndices=[transients.loc];
transientStats.zones=inZone(allTransientsIndices);
TransientsInstances=1:size(transients.time,2);
for iZone=1:nZones
    idx=find(transientStats.zones==iZone);
    idx = [TransientsInstances(idx)];
    vMax = [transients.prominence];
    vMax = vMax(idx);
    transientStats.zonesMeanAmp(iZone) = nanmean(vMax);
end
transientStats.zones(~logical(transientStats.zones))=[];
[transientStats.zonesCounts,e]=histcounts(transientStats.zones,1:nZones+1);
%     if transients.zonesIDs(1)==0,transients.zonesCounts(1)=[];end
transientStats.zonesProba=transientStats.zonesCounts./(zoneTime_fr');
% end

