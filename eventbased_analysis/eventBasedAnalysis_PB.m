function experiment = eventBasedAnalysis_PB(experiment)

%if isfield(experiment,'eventCategory')
    sfreq = experiment.p.HamamatsuFrameRate_Hz;
    nFrames = experiment.pData.nFrames;
    edges_msec = experiment.p.eventBasedAnalysisEdges_msec;
    edges_sec = edges_msec/1000;
    zeroPosition = find(edges_sec==0);
    zeroPositionPerc = (zeroPosition/size(edges_sec,2))*100;
    windowSize_sec = edges_sec(end)-edges_sec(1);            
    nColumns = ceil(windowSize_sec*sfreq)+1;
      
    edges_idx = 1:nColumns;
    zeroPosition = floor((size(edges_idx,2)*zeroPositionPerc)/100);
    edges_idx = edges_idx - zeroPosition;
    
    bulkSignal = experiment.pData.mainSig;
    idx_transients = [experiment.pData.transients(:).start];
       
    eventCategory = experiment.eventCategory;    
    nEventCategories= size(eventCategory,2);
    
    for iEventCategory = 1: nEventCategories
        
        idx_synchro = eventCategory(iEventCategory).frame_idx;
        
        n_idx_synchro = size(idx_synchro,1);
        
        if n_idx_synchro            
            eventCategory(iEventCategory).tansientsMatrix=get_peth(idx_synchro/sfreq,idx_transients/sfreq,edges_sec);
            eventCategory(iEventCategory).bulkMatrix = nan(n_idx_synchro,nColumns);
            for j=1:n_idx_synchro
                i = idx_synchro(j);
                idx = edges_idx + i;
                if idx(1)>0 && idx(end)<nFrames
                    eventCategory(iEventCategory).bulkMatrix(j,:)=bulkSignal(idx);
                end
            end
                                                            
        end
    end
    
    experiment.eventCategory = eventCategory;
    
%end






