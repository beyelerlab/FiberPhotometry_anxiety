function experiment  = mergeZoneForEPM(experiment)

zonesTypes = [experiment.vData.zones_cmSP(:).type];
[r,c] = size(experiment.p.results);

if ~strcmp(zonesTypes,'openclosedopenclosedcenter')
    warning('watch out your are not averargin the zone you thinck you are');
else
    experiment.vData.OA_time_fr = experiment.vData.zoneTime_fr(1) + experiment.vData.zoneTime_fr(3);
    experiment.vData.CA_time_fr = experiment.vData.zoneTime_fr(2) + experiment.vData.zoneTime_fr(4);
end

index = getJournalIndex(experiment.p.results,experiment.p.dataFileTag);

if ~ismember('OA_time_fr', experiment.p.results.Properties.VariableNames)
    experiment.p.results.OA_time_fr = nan(r,1);
end
if ~ismember('CA_time_fr', experiment.p.results.Properties.VariableNames)
    experiment.p.results.CA_time_fr = nan(r,1);
end

experiment.p.results.OA_time_fr(index) = experiment.vData.OA_time_fr;
experiment.p.results.CA_time_fr(index) = experiment.vData.CA_time_fr;

