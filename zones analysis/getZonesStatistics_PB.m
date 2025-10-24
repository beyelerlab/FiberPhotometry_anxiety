function experiment = getZonesStatistics_PB(experiment)

vData = experiment.vData;
pData = experiment.pData;
p = experiment.p;
distance = vData.distanceSP;

%% Position & Zones
X_cmSP = vData.mainX_cmSP;
Y_cmSP = vData.mainY_cmSP;
vData.inZone = position2zone(X_cmSP, Y_cmSP, vData.zones_cmSP);
vData.nZones = size(vData.zones_cmSP,2);
[vData.zoneTime_fr, vData.outTime_fr] = framesInZone(vData.inZone, vData.nZones);

%% Bulk Signal & Transients per zone
pData.transientStats = transientsPerZone(vData.inZone, vData.nZones, vData.zoneTime_fr, pData.transients);
pData.bulkSignalStats = bulkSignalPerZone(vData.inZone, vData.nZones, vData.zoneTime_fr, pData.mainSig);

%% Tracking signals from Bonsai per zone
trackingSignals = {'mouseX','mouseY','mouseAngle','mouseMajorAxisLength','mouseMinorAxisLength','mouseArea','optoPeriod'};
for iS = 1:length(trackingSignals)
    sigName = trackingSignals{iS};
    if isfield(vData, sigName)
        sigValues = vData.(sigName);
        vData.zoneStats.(sigName) = bulkSignalPerZone(vData.inZone, vData.nZones, vData.zoneTime_fr, sigValues);
    else
        warning('Signal %s not found in vData.', sigName);
    end
end

%% Time in Zone in sec
filename = [p.batch_ouputFile(1:end-4) '-inZoneTime_sec.txt']; %define filename
fod1 = fopen(filename,'a'); % open file

%% inZoneBulk
filename = [p.batch_ouputFile(1:end-4) '-inZoneBulk.txt']; %define filename
fod2 = fopen(filename,'a'); %open file

%% Writting Header
if ~p.batch_ouputFile_headerWritten
    
    fprintf(fod1,'Time in Zone (sec)\n');
    fprintf(fod1,'mouse');
    for iZ = 1:vData.nZones, fprintf(fod1,sprintf('\tZ%d',iZ)); end
    fprintf(fod1,sprintf('\tOUT')); fprintf(fod1,'\n');

    fprintf(fod2,'Bulk in Zone\n');
    fprintf(fod2,'mouse');
    for iZ = 1:vData.nZones, fprintf(fod2,sprintf('\tZ%d',iZ)); end
    fprintf(fod2,'\n');  
    
    % Extra headers for tracking signals
    trackingSignals = fieldnames(vData.zoneStats);
    for iS = 1:length(trackingSignals)
        fname = [p.batch_ouputFile(1:end-4) '-inZone_' trackingSignals{iS} '.txt'];
        fodExtra = fopen(fname,'a');
        fprintf(fodExtra,'%s per Zone\n', trackingSignals{iS});
        fprintf(fodExtra,'mouse');
        for iZ = 1:vData.nZones, fprintf(fodExtra,sprintf('\tZ%d',iZ)); end
        fprintf(fodExtra,'\n');
        fclose(fodExtra);
    end
    
    p.batch_ouputFile_headerWritten = 1;
end

%% Writting Values
if ~isfield(vData.videoInfo,'FrameRate')
    vData.videoInfo = getVideoInfo(p);
    if ~isfield(vData.videoInfo,'FrameRate')
        framerate = 20;
    end
else
    framerate = vData.videoInfo.FrameRate;
end

% Time per zone
fprintf(fod1,p.dataFileTag);
for iZ = 1:vData.nZones
    fprintf(fod1,sprintf('\t%2.4f', vData.zoneTime_fr(iZ)./framerate));
end
fprintf(fod1,sprintf('\t%2.4f', vData.outTime_fr./framerate));
fprintf(fod1,'\n');   
fclose(fod1);

%% Velocity
velocity = distance .* framerate; % cm/sec
vData.zoneVelocity = VelocityperZones(vData.inZone, vData.nZones, velocity);

%% Bulk per zone
fprintf(fod2,p.dataFileTag);
for iZ = 1:vData.nZones
    fprintf(fod2,sprintf('\t%2.4f', pData.bulkSignalStats.zonesMeanAmp(iZ)));
end
fprintf(fod2,'\n');
fclose(fod2);

%% Tracking signals per zone
trackingSignals = fieldnames(vData.zoneStats);
for iS = 1:length(trackingSignals)
    fname = [p.batch_ouputFile(1:end-4) '-inZone_' trackingSignals{iS} '.txt'];
    fodExtra = fopen(fname,'a');
    fprintf(fodExtra,p.dataFileTag);
    values = vData.zoneStats.(trackingSignals{iS}).zonesMeanAmp;
    for iZ = 1:vData.nZones
        fprintf(fodExtra,sprintf('\t%2.4f', values(iZ)));
    end
    fprintf(fodExtra,'\n');
    fclose(fodExtra);
end

%% Update experiment
experiment.pData = pData;
experiment.vData = vData;
experiment.p = p;

end



























% function experiment = getZonesStatistics_PB(experiment)
% 
% vData=experiment.vData;
% pData=experiment.pData;
% p=experiment.p;
% distance = vData.distanceSP;
% 
% X_cmSP = vData.mainX_cmSP;Y_cmSP = vData.mainY_cmSP;
% vData.inZone=position2zone(X_cmSP,Y_cmSP,vData.zones_cmSP);
% vData.nZones = size(vData.zones_cmSP,2);
% [vData.zoneTime_fr,vData.outTime_fr]=framesInZone(vData.inZone,vData.nZones);
% 
% pData.transientStats=transientsPerZone(vData.inZone,vData.nZones,vData.zoneTime_fr,pData.transients);
% pData.bulkSignalStats=bulkSignalPerZone(vData.inZone,vData.nZones,vData.zoneTime_fr,pData.mainSig);
% 
% %% Time in Zone in sec
% filename = [p.batch_ouputFile(1:end-4) '-inZoneTime_sec.txt']; %define filename
% fod1 = fopen(filename,'a'); % open file
% 
% %% inZoneBulk
% filename = [p.batch_ouputFile(1:end-4) '-inZoneBulk.txt']; %define filename
% fod2 = fopen(filename,'a'); %open file
% 
% %% Writting Header
% if ~p.batch_ouputFile_headerWritten
% 
%     fprintf(fod1,'Time in Zone (sec)\n');
%     fprintf(fod1,'mouse');
%     for iZ = 1:vData.nZones, fprintf(fod1,sprintf('\tZ%d',iZ));end
%     fprintf(fod1,sprintf('\tOUT'));fprintf(fod1,'\n');
% 
%     fprintf(fod2,'Bulk in Zone\n');
%     fprintf(fod2,'mouse');
%     for iZ = 1:vData.nZones, fprintf(fod2,sprintf('\tZ%d',iZ));end;fprintf(fod2,'\n');  
% 
%     p.batch_ouputFile_headerWritten = 1;
% end
% 
% %% Writtgin Values
% if ~isfield(vData.videoInfo,'FrameRate')
%     vData.videoInfo=getVideoInfo(p);
%     if ~isfield(vData.videoInfo,'FrameRate')
%         framerate = 20;
%     end
% else
%     framerate=vData.videoInfo.FrameRate;
% end
% 
% fprintf(fod1,p.dataFileTag);
% for iZ = 1:vData.nZones
%     fprintf(fod1,sprintf('\t%2.4f',vData.zoneTime_fr(iZ)./framerate));end
%     fprintf(fod1,sprintf('\t%2.4f',vData.outTime_fr./framerate));fprintf(fod1,'\n');   
% fclose(fod1); % close file
% 
% 
% %% Velocity
% velocity = distance./0.05; % unit: cm/s
% vData.zoneVelocity=VelocityperZones(vData.inZone,vData.nZones,velocity);
% 
% 
% %% Writting values
% fprintf(fod2,p.dataFileTag);
% for iZ = 1:vData.nZones, fprintf(fod2,sprintf('\t%2.4f',pData.bulkSignalStats.zonesMeanAmp(iZ)));end;fprintf(fod2,'\n');
% fclose(fod2); %close file
% 
% experiment.pData=pData;
% experiment.vData=vData;
% experiment.p = p;
% 
% end
