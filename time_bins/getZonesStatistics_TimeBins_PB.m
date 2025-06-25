function experiment = getZonesStatistics_TimeBins_PB(experiment)

    vData=experiment.vData;pData=experiment.pData;p=experiment.p;

    X_cmSP = vData.mainX_cmSP;Y_cmSP = vData.mainY_cmSP;
    inZone=position2zone(X_cmSP,Y_cmSP,vData.zones_cmSP);

    time_bins = p.time_bins_sec;
    nTimePeriods = max(size(time_bins))-1;

    if nTimePeriods<1, 
        warning('you should redefine your time bins in getConfig.m to have at leat to numbers');
        pause
    end

    varNames = {'timeInZone_sec', 'bulkSignal', 'transientsAmplitude.', 'transientsFrequency'};        
   
    
    [fods, p] = createFiles(varNames, p, vData.nZones);

    for iTimePeriod=1:nTimePeriods

        iFrame1=time_bins(iTimePeriod)*p.HamamatsuFrameRate_Hz + 1;
        iFrame2=time_bins(iTimePeriod+1)*p.HamamatsuFrameRate_Hz;   

        if iFrame2>pData.nFrames
            iFrame2 = pData.nFrames;
        end

        X_cmSP_tmp = vData.mainX_cmSP(iFrame1:iFrame2);
        Y_cmSP_tmp = vData.mainY_cmSP(iFrame1:iFrame2);
        inZone_tmp=position2zone(X_cmSP_tmp,Y_cmSP_tmp,vData.zones_cmSP);
        nZones = size(vData.zones_cmSP,2);
        [zoneTime_fr_tmp,outTime_fr_tmp]=framesInZone(inZone_tmp,nZones);

        selected_transients = select_transients(pData.transients, iFrame1, iFrame2)
        
        pData.transientPeriodStats{iTimePeriod}=transientsPerZone(inZone,nZones,zoneTime_fr_tmp,selected_transients);
        pData.bulkPeriodStats{iTimePeriod} = bulkSignalPerZone(inZone_tmp,nZones,zoneTime_fr_tmp,pData.mainSig(iFrame1:iFrame2));           
               
        if ~isfield(vData.videoInfo,'FrameRate')
            framerate = 20;
        else
            framerate = vData.videoInfo.FrameRate;
        end
        
        datas = {(zoneTime_fr_tmp'/framerate), pData.bulkPeriodStats{iTimePeriod }.zonesMeanAmp, pData.transientPeriodStats{iTimePeriod}.zonesMeanAmp, (pData.transientPeriodStats{iTimePeriod}.zonesCounts./(zoneTime_fr_tmp'/framerate))};
        popFiles(fods, varNames, datas, vData.nZones)
                
        iFrame1 = iFrame2+1;

    end
   
    experiment.vData=vData;
    experiment.pData=pData;
    experiment.p = p;
    
    close_all_files(fods);

end


function selected_transients = select_transients(tr, frame_start_idx, frame_stop_idx)
    nT = size(tr.time,2);
    toKeep = [];
    for iT = 1:nT
        ii1 = find(tr.loc(iT)<frame_start_idx);
        ii2 = find(tr.loc(iT)>frame_stop_idx);
        ii3 = [ii1 ii2];
        if isempty(ii3)
            toKeep = [toKeep iT];
        end
    end

    selected_transients =  struct('time',tr.time(toKeep),...
    'loc',tr.loc(toKeep),...
    'peak',tr.peak(toKeep),...
    'width',tr.width(toKeep),...
    'prominence',tr.prominence(toKeep),...
    'MinPeakDistance',tr.MinPeakDistance,...
    'MinPeakProminence',tr.MinPeakProminence)
    
    
end


function close_all_files(fods)
    for i=1:size(fods,1)       
        fclose(fods(i));
    end
end


function [fods, p] = createFiles(varNames, p, nZones)

    nVar = size(varNames,2);
    fods = [];

    time_bins = p.time_bins_sec;
    nTimePeriods = max(size(time_bins))-1;

    for iVar=1:nVar

        filename = [p.batch_ouputFile(1:end-4) sprintf('-timebins_%s.txt',varNames{iVar})];
        fods(iVar) = fopen(filename,'a');
        if ~p.batch_ouputFile_timebins_headerWritten
            fprintf(fods(iVar), sprintf('Time bins analysis (sec) of %s\n',varNames{iVar}));
            fprintf(fods(iVar),'mouse');
            for iTimePeriod=1:nTimePeriods
                for iZ = 1:nZones
                    fprintf(fods(iVar),sprintf('\tt=[%2d-%2d], Z=%d',time_bins(iTimePeriod),time_bins(iTimePeriod+1),iZ));
                end
            end
                  
        end
        fprintf(fods(iVar),'\n');      
        fprintf(fods(iVar), p.dataFileTag);
        
    end
    
    p.batch_ouputFile_timebins_headerWritten=1;
    
end


function popFiles(fods, varNames, datas, nZones)
nVar = size(varNames,2);
for iVar=1:nVar
    tmp = datas{iVar};
    for iZ = 1:nZones
        fprintf(fods(iVar),sprintf('\t%2.2f',tmp(iZ)));
    end
end
end


    
    
    
  