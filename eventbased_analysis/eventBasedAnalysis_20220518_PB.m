function experiment = eventBasedAnalysis_20220518_PB(experiment)

sfreq = experiment.p.HamamatsuFrameRate_Hz;
nFrames = experiment.pData.nFrames;
edges_msec = experiment.p.eventBasedAnalysisEdges_msec;
binSizes = diff(edges_msec);
binCenters_msec = edges_msec(1:end-1) + (binSizes/2);
     
bulkSignal = experiment.pData.mainSig;
idx_transients = [experiment.pData.transients(:).loc];


if isfield(experiment.p,'extract_bites_from_audio')
    [audioEvents_sec,timeLag,nSTD,audioDetectionGap_sec] = nsft_getAudioEvents_05(experiment);
    idx_synchro = discretize(audioEvents_sec, experiment.pData.t0);
    idx_synchro(isnan(idx_synchro))=[];
    
    
else
    idx_synchro = findEventsIdx(experiment.vData.optoPeriod);
    idx_synchro=cleanEvents(idx_synchro,experiment.p.minimum_gap_between_events_msec,sfreq);
    warning('cleaning events only works for home-made Hamamatsu system');
end

if isempty(idx_synchro)
    msg = sprintf('Please remove all the files starting with %s* from %s and restart the program',experiment.p.dataFileTag, experiment.p.dataRoot);
    warning(msg)
    pause
end

[experiment.pData.bulkPETH.matrix,experiment.pData.transientsPETH.matrix] = getPSTHData(idx_synchro,bulkSignal,idx_transients,edges_msec,sfreq,nFrames);
%experiment.pData.eventsPETH = experiment.pData.num0(idx_synchro);
[r,c]=size(experiment.pData.bulkPETH.matrix);
if r>1
    experiment.pData.bulkPETH.nanmean = nanmean(experiment.pData.bulkPETH.matrix);
    experiment.pData.bulkPETH.nanstd = nanstd(experiment.pData.bulkPETH.matrix);
    experiment.pData.transientsPETH.nanmean = nanmean(experiment.pData.transientsPETH.matrix);
    experiment.pData.transientsPETH.nanstd = nanstd(experiment.pData.transientsPETH.matrix);
else
    experiment.pData.bulkPETH.nanmean = experiment.pData.bulkPETH.matrix;
    experiment.pData.bulkPETH.nanstd = nan(1,c);
    experiment.pData.transientsPETH.nanmean = experiment.pData.transientsPETH.matrix;
    experiment.pData.transientsPETH.nanstd = nan(1,c);
end









bl_window_msec = experiment.p.eventBasedAnalysisBaselineWindow_msec;
minmax_window_msec = experiment.p.eventBasedAnalysisMinMaxWindow_msec;

if length(bl_window_msec)>1
    
    e1 = find(edges_msec>=bl_window_msec(1),1,'first');
    e2 = find(edges_msec<bl_window_msec(2),1,'last');   
    matrix_ = experiment.pData.bulkPETH.matrix;
    [nR,nC] = size(matrix_);
    bl_mean = nanmean(matrix_(:,e1:e2),2);
    bl_std = nanstd(matrix_(:,e1:e2),0,2);
    mean_matrix = repmat(bl_mean,1,nC);
    std_matrix = repmat(bl_std,1,nC);
    
    experiment.pData.bulkPETH.zcored_matrix = (matrix_ - mean_matrix) ./ std_matrix;

    
    m1 = find(edges_msec>=minmax_window_msec(1),1,'first');
    m2 = find(edges_msec<minmax_window_msec(2),1,'last');  
    
    [r,c]=size(experiment.pData.bulkPETH.zcored_matrix);
    if r>1           
            experiment.pData.bulkPETH.zcored_nanmean = nanmean(experiment.pData.bulkPETH.zcored_matrix);
            experiment.pData.bulkPETH.zcored_nanstd = nanstd(experiment.pData.bulkPETH.zcored_matrix);
    else             
            experiment.pData.bulkPETH.zcored_nanmean = experiment.pData.bulkPETH.zcored_matrix;
            experiment.pData.bulkPETH.zcored_nanstd = nan(1,c);            
    end
    
    tmp = experiment.pData.bulkPETH.zcored_nanmean(m1:m2);

    
    [min_, idx_min] = nanmin(tmp);
    [max_, idx_max] = nanmax(tmp);
        
    idx_min = m1 + idx_min - 1;
    idx_max = m1 + idx_max - 1; 
    
    idx_min_msec = binCenters_msec(idx_min);
    idx_max_msec = binCenters_msec(idx_max); 
    
    experiment.pData.bulkPETH.zcored_idx_min = idx_min;        
    experiment.pData.bulkPETH.zcored_idx_max = idx_max;        
    experiment.pData.bulkPETH.zcored_idx_min_msec = idx_min_msec;        
    experiment.pData.bulkPETH.zcored_idx_max_msec = idx_max_msec;
    experiment.pData.bulkPETH.zcored_min = min_;        
    experiment.pData.bulkPETH.zcored_max = max_;
    
    
    figure();
    hold on
    plot(experiment.pData.bulkPETH.matrix','color',[0.5 0.5 0.5])
    plot(experiment.pData.bulkPETH.nanmean,'color',[0.5 0 0])
    plot(experiment.pData.bulkPETH.nanmean + experiment.pData.bulkPETH.nanstd,'color',[0.5 0 0], 'linestyle', ':');
    plot(experiment.pData.bulkPETH.nanmean - experiment.pData.bulkPETH.nanstd,'color',[0.5 0 0], 'linestyle', ':');
    
    figure();
    hold on
    plot(experiment.pData.bulkPETH.zcored_matrix','color',[0.5 0.5 0.5])
    plot(experiment.pData.bulkPETH.zcored_nanmean,'color',[0.5 0 0])
    plot(experiment.pData.bulkPETH.zcored_nanmean + experiment.pData.bulkPETH.zcored_nanstd,'color',[0.5 0 0], 'linestyle', ':');
    plot(experiment.pData.bulkPETH.zcored_nanmean - experiment.pData.bulkPETH.zcored_nanstd,'color',[0.5 0 0], 'linestyle', ':');   
    plot(idx_min,experiment.pData.bulkPETH.zcored_nanmean(idx_min),'rv'); 
    plot(idx_max,experiment.pData.bulkPETH.zcored_nanmean(idx_max),'r^'); 
    
    disp('here');
    
    varNames = {'experiment.pData.bulkPETH.matrix','experiment.pData.transientsPETH.matrix','experiment.pData.bulkPETH.nanmean',...
        'experiment.pData.bulkPETH.nanstd', 'experiment.pData.transientsPETH.nanmean','experiment.pData.transientsPETH.nanstd',...
        'experiment.pData.bulkPETH.zcored_matrix','experiment.pData.bulkPETH.zcored_nanmean','experiment.pData.bulkPETH.zcored_nanstd'};       

else
    varNames = {'experiment.pData.bulkPETH.matrix','experiment.pData.transientsPETH.matrix','experiment.pData.bulkPETH.nanmean',...
        'experiment.pData.bulkPETH.nanstd','experiment.pData.transientsPETH.nanmean','experiment.pData.transientsPETH.nanstd'};
end




experiment = writeOutputFile(experiment, varNames);
experiment = writeOutputFile2(experiment);


% figure();
% hold on
% nEvents = size(experiment.pData.bulkPETH.matrix,1);
% plot(experiment.pData.bulkPETH.matrix','color',[0.5 0.5 0.5])
% plot(experiment.pData.bulkPETH.nanmean,'color',[0.5 0 0])
% plot(experiment.pData.bulkPETH.nanmean + experiment.pData.bulkPETH.nanstd,'color',[0.5 0 0], 'linestyle', ':');
% plot(experiment.pData.bulkPETH.nanmean - experiment.pData.bulkPETH.nanstd,'color',[0.5 0 0], 'linestyle', ':');

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

function [bulkMatrix,transientsMatrix] = getPSTHData(idx_synchro,bulkSignal,idx_transients,edges_msec,sfreq,nFrames)

edges_sec = edges_msec/1000;
zeroPosition = find(edges_sec==0);
zeroPositionPerc = (zeroPosition/size(edges_sec,2))*100;
windowSize_sec = edges_sec(end)-edges_sec(1);
nColumns = ceil(windowSize_sec*sfreq)+1;
edges_idx = 1:nColumns;
zeroPosition = floor((size(edges_idx,2)*zeroPositionPerc)/100);
edges_idx = edges_idx - zeroPosition;

n_idx_synchro = size(idx_synchro,1);
bulkMatrix = nan(n_idx_synchro,nColumns);
transientsMatrix=[];

if n_idx_synchro   
    
    transientsMatrix=get_peth(idx_synchro/sfreq,idx_transients/sfreq,edges_sec);   
    
    for j=1:n_idx_synchro
        i = idx_synchro(j);
        idx = edges_idx + i;
        if idx(1)>0 && idx(end)<nFrames
            bulkMatrix(j,:)=bulkSignal(idx);
        end
    end
    
end


end


function experiment = writeOutputFile2(experiment)

     p = experiment.p;
     edges_msec = p.eventBasedAnalysisEdges_msec;
     binSizes = diff(edges_msec);
     binCenters_msec = edges_msec(1:end-1) + (binSizes/2);
     nE = length(edges_msec);   
        
    filename = [p.batch_ouputFile(1:end-4) '-eventAnlaysis_minmaxzscore.txt'];
    fod = fopen(filename,'a');
   
    if ~p.batch_ouputFile_eventBasedAnalysis_header2Written

        fprintf(fod, 'Event Based Analysis\n\n');
        fprintf(fod, 'Parameters\n');
        
        fprintf(fod, '\tEdges_msec');
        for iE=1:nE
            fprintf(fod, sprintf('\t%2.2f',edges_msec(iE)));
        end
        fprintf(fod, '\n');
                
        fprintf(fod, '\tminimum_gap_between_events_msec');
        fprintf(fod, sprintf('\t%2.2f\n',p.minimum_gap_between_events_msec));   
        
        fprintf(fod, '\teventBasedAnalysisBaselineWindow_msec');
        if ~isempty(p.eventBasedAnalysisBaselineWindow_msec)
            for i=1:length(p.eventBasedAnalysisBaselineWindow_msec)
               fprintf(fod, sprintf('\t%2.2f',p.eventBasedAnalysisBaselineWindow_msec(i))); 
            end
        end
        fprintf(fod, '\n');
        
         fprintf(fod, '\teventBasedAnalysisMinMaxWindow_msec');       
        if ~isempty(p.eventBasedAnalysisMinMaxWindow_msec)
            for i=1:length(p.eventBasedAnalysisMinMaxWindow_msec)
               fprintf(fod, sprintf('\t%2.2f',p.eventBasedAnalysisMinMaxWindow_msec(i))); 
            end
        end        
        fprintf(fod, '\n');
        
        fprintf(fod, '\n\n');
        
        fprintf(fod,'\tmouse\tmin_val\tmax_val\tmin_msec\tmax_msec\tmin_idx\tmax_idx\n');
    end
        
    idx_min_msec = experiment.pData.bulkPETH.zcored_idx_min_msec;
    idx_max_msec = experiment.pData.bulkPETH.zcored_idx_max_msec;
    idx_min = experiment.pData.bulkPETH.zcored_idx_min;
    idx_max = experiment.pData.bulkPETH.zcored_idx_max;
    min_ = experiment.pData.bulkPETH.zcored_min;
    max_ = experiment.pData.bulkPETH.zcored_max;    
    
    fprintf(fod,'\t%s\t%2.4f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\t%2.4f\n',p.dataFileTag,min_,max_,idx_min_msec,idx_max_msec,idx_min,idx_max);
    experiment.p.batch_ouputFile_eventBasedAnalysis_header2Written=1;
    
    fclose(fod);
  
end


function experiment = writeOutputFile(experiment, varNames)

     p = experiment.p;
     edges_msec = p.eventBasedAnalysisEdges_msec;
     binSizes = diff(edges_msec);
     binCenters_msec = edges_msec(1:end-1) + (binSizes/2);
     nE = length(edges_msec);    nVar = length(varNames);
     
     fods = [];
     
    for iVar=1:nVar
        
        varName = varNames{iVar};
        
        varSubNames = split(varName,'.');  
                
        filename = [p.batch_ouputFile(1:end-4) sprintf('-eventAnlaysis_%s_%s.txt',varSubNames{3},varSubNames{4})];
        
        fods(iVar) = fopen(filename,'a');
        
        cmd = sprintf('var_=%s;',varName);
        eval(cmd);
        
        [nR,nC] = size(var_);
        
        if ~p.batch_ouputFile_eventBasedAnalysis_headerWritten

            fprintf(fods(iVar), 'Event Based Analysis\n\n');
            fprintf(fods(iVar), 'Parameters\n');

            fprintf(fods(iVar), '\tEdges_msec');
            for iE=1:nE
                fprintf(fods(iVar), sprintf('\t%2.2f',edges_msec(iE)));
            end
            fprintf(fods(iVar), '\n');

            fprintf(fods(iVar), '\tminimum_gap_between_events_msec');
            fprintf(fods(iVar), sprintf('\t%2.2f\n',p.minimum_gap_between_events_msec));   

            fprintf(fods(iVar), '\teventBasedAnalysisBaselineWindow_msec');
            if ~isempty(p.eventBasedAnalysisBaselineWindow_msec)
                for i=1:length(p.eventBasedAnalysisBaselineWindow_msec)
                   fprintf(fods(iVar), sprintf('\t%2.2f',p.eventBasedAnalysisBaselineWindow_msec(i))); 
                end
            end
            fprintf(fods(iVar), '\n');

             fprintf(fods(iVar), '\teventBasedAnalysisMinMaxWindow_msec');       
            if ~isempty(p.eventBasedAnalysisMinMaxWindow_msec)
                for i=1:length(p.eventBasedAnalysisMinMaxWindow_msec)
                   fprintf(fods(iVar), sprintf('\t%2.2f',p.eventBasedAnalysisMinMaxWindow_msec(i))); 
                end
            end        
            fprintf(fods(iVar), '\n');

            fprintf(fods(iVar), '\n\n');

            fprintf(fods(iVar),'\tbinCenters_msec');
            fprintf(fods(iVar), '\n');
            fprintf(fods(iVar),'mouse\tessai');

            for iE=1:nE-1
                fprintf(fods(iVar), sprintf('\t%2.4f',binCenters_msec(iE)));
            end
            fprintf(fods(iVar),'\n');
            
        end
        
        for iR=1:nR
            fprintf(fods(iVar), p.dataFileTag);
            fprintf(fods(iVar), sprintf('\t%d',iR));
            for iE=1:nE-1
                fprintf(fods(iVar), sprintf('\t%2.4f',var_(iR,iE)));
            end
            fprintf(fods(iVar),'\n');
        end
        
    end
    
    experiment.p.batch_ouputFile_eventBasedAnalysis_headerWritten=1;

    close_all_files(fods);
  
end

function close_all_files(fods)
    for i=1:size(fods,1)       
        fclose(fods(i));
    end
end




