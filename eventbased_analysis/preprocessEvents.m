function experiment = preprocessEvents(experiment)
  
    sfreq = experiment.p.HamamatsuFrameRate_Hz;
    params = experiment.p;

    event_file_needed = true;

    if event_file_needed
        if strfind(experiment.p.batchID,'NSFT')
    
            if isfield(experiment.p,'extract_bites_from_audio') && experiment.p.extract_bites_from_audio
                [audioEvents_sec,timeLag,nSTD,audioDetectionGap_sec] = nsft_getAudioEvents_05(experiment);
                idx_synchro = discretize(audioEvents_sec, experiment.pData.t0);
                idx_synchro(isnan(idx_synchro))=[]; 
            else
                if isfield(experiment.p,'extract_bites_from_txt') && experiment.p.extract_bites_from_txt
                    txt_path = [experiment.p.dataRoot filesep experiment.p.dataFileTag '.kdenlive']
                    if ~exist(txt_path,'file')
                        fprintf('kdenlive file is missing\n');
                    else
                        import_kdenlive_xml(txt_path)
                        idx_synchro = []
                        try
                            idx_synchro = load([experiment.p.dataRoot filesep experiment.p.dataFileTag '_events.txt']); 
                        catch
                            fprintf('no events')
                        end

                        % Here we tagged frames form behavior camera using
                        % kdelive

                        % We need to convert this indices (idx_synchro) because the fiber
                        % phometry camera has a different frame rate and
                        % because the beginning of the photometry recording
                        % (ususally 60s) has been trimmed

                        vidObj = VideoReader([params.dataRoot filesep params.dataFileTag '.' params.videoExtension]);
                        beh_fr = vidObj.FrameRate;
                        t_cut = params.remove_high_bleaching_period_sec;
                        i_cut = t_cut * beh_fr;

                        idx_synchro = idx_synchro(idx_synchro>i_cut); % we remove indices that are in the trimmed section
                        idx_synchro = idx_synchro - i_cut; % we shift the indices to follow the time cut
                        tps_synchro = idx_synchro / beh_fr; % we convert indices in time
                        idx_synchro = tps_synchro * params.HamamatsuFrameRate_Hz; % we convert back the times to indices using photometry frame rate
                        idx_synchro = round(idx_synchro);

                        event_file_needed = false;
                    end
                end
            end          
        end
    end


    if event_file_needed

        events_idxsynchro_path = [experiment.p.dataRoot filesep experiment.p.dataFileTag '_events_idxsynchro.txt']

        if exist(events_idxsynchro_path,'file')
            idx_synchro = load(events_idxsynchro_path);
            idx_lag = experiment.pData.t0(1)*experiment.p.HamamatsuFrameRate_Hz;
            idx_synchro = idx_synchro - idx_lag;
            event_file_needed = false;
        end

    end


    if event_file_needed
        idx_synchro = findEventsIdx(experiment.vData.optoPeriod);
    end



    if isempty(idx_synchro)
        msg = sprintf('Please remove all the files starting with %s* from %s and restart the program',experiment.p.dataFileTag, experiment.p.dataRoot);
        warning(msg);
    end



    dt_min_msec = experiment.p.minimum_gap_between_events_msec;
    warning(sprintf('Warning you are going to remove events that are too close to each other (dt < %d msec)',dt_min_msec));
    beep();
    warning('cleaning events only works for home-made Hamamatsu system');
    idx_synchro=cleanEvents(idx_synchro,dt_min_msec,sfreq);
    
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