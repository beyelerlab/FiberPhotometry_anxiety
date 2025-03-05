function experiment = preprocessEvents(experiment)
  
    sfreq = experiment.p.HamamatsuFrameRate_Hz;

    if isfield(experiment.p,'extract_bites_from_audio')
        [audioEvents_sec,timeLag,nSTD,audioDetectionGap_sec] = nsft_getAudioEvents_05(experiment);
        idx_synchro = discretize(audioEvents_sec, experiment.pData.t0);
        idx_synchro(isnan(idx_synchro))=[];        
    else
        idx_synchro = findEventsIdx(experiment.vData.optoPeriod);
        dt_min_msec = experiment.p.minimum_gap_between_events_msec;
        warning(sprintf('Warning you are going to remove events that are too close to each other (dt < %d msec)',dt_min_msec));
        beep();
        idx_synchro=cleanEvents(idx_synchro,dt_min_msec,sfreq);
        warning('cleaning events only works for home-made Hamamatsu system');
    end
    
    if isempty(idx_synchro)
        msg = sprintf('Please remove all the files starting with %s* from %s and restart the program',experiment.p.dataFileTag, experiment.p.dataRoot);
        warning(msg)
        pause
    end
    
    if experiment.p.keep_first_and_last_events_only
        tmp = idx_synchro;
        idx_synchro = [tmp(1);tmp(end)];
    end

    if strcmp(experiment.p.apparatus.type, 'EPM')
        experiment.idx_synchro = {{experiment.vData.eOA.idx, 'OpenArmEntries'}, {experiment.vData.eCA.idx, 'ClosedArmEntries'}}
    else
        experiment.idx_synchro = {{idx_synchro, ''}}
    end


end

function idx_events = findEventsIdx(Sig)
    Sig = Sig> (max(Sig)/10);
    diff_lickSig =diff(Sig);
    idx_events =find(diff_lickSig==1)+1;
end

function idx_events = cleanEvents(idx,minimum_gap_msec,sfreq)
    minimum_gap_idx = ceil(minimum_gap_msec / 1000.0 * sfreq);
    d_idx = diff(idx);
    ii = find(d_idx<minimum_gap_idx);
    idx_events = idx;
    if ~isempty(idx_events)
        idx_events(ii+1)=[];
    end
end
