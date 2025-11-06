function experiment = eventBasedFreezingAnalysis_PB(experiment)
    
    event_name = experiment.idx_synchro{2};
    [a,b] = max(size(experiment.idx_synchro{1}));
    
    if b==1
        idx_synchro = experiment.idx_synchro{1};
    else
        idx_synchro = experiment.idx_synchro{1}';
    end
    
    sfreq = experiment.p.HamamatsuFrameRate_Hz;
    nFrames = experiment.pData.nFrames;
    edges_msec = experiment.p.eventBasedAnalysisEdges_msec;
    binSizes = diff(edges_msec);
    binCenters_msec = edges_msec(1:end-1) + (binSizes/2);

    % freezingSignal = experiment.vData.freezing;
    % 
    % 
    % experiment.vData.freezingPETH.matrix = getPSTHData(idx_synchro,freezingSignal,edges_msec,sfreq,nFrames)
    % [r,c]=size(experiment.pData.bulkPETH.matrix);
    % 
    % if r>1
    %     experiment.vData.freezingPETH.nanmean = nanmean(experiment.vData.freezingPETH.matrix);
    %     experiment.vData.freezingPETH.nanstd = nanstd(experiment.vData.freezingPETH.matrix);
    % else
    %     experiment.pData.bulkPETH.nanmean = experiment.vData.freezingPETH.matrix;
    %     experiment.pData.bulkPETH.nanstd = nan(1,c);
    % end
    % 
    % 
    % varNames = {'experiment.vData.freezingPETH.matrix','experiment.vData.freezingPETH.nanmean','experiment.vData.freezingPETH.nanstd'};
    % 
    % experiment = writeOutputFile(experiment, varNames);



end


% function freezingMatrix = getPSTHData(idx_synchro,freezingSignal,edges_msec,sfreq,nFrames)
% 
% edges_sec = edges_msec/1000;
% zeroPosition = find(edges_sec==0);
% zeroPositionPerc = (zeroPosition/size(edges_sec,2))*100;
% windowSize_sec = edges_sec(end)-edges_sec(1);
% nColumns = ceil(windowSize_sec*sfreq)+1;
% edges_idx = 1:nColumns;
% zeroPosition = floor((size(edges_idx,2)*zeroPositionPerc)/100);
% edges_idx = edges_idx - zeroPosition;
% 
% n_idx_synchro = size(idx_synchro,1);
% freezingMatrix = nan(n_idx_synchro,nColumns);
% 
% 
% if n_idx_synchro              
%     for j=1:n_idx_synchro
%         i = idx_synchro(j);
%         idx = edges_idx + i;
%         if idx(1)>0 && idx(end)<nFrames
%             freezingMatrix(j,:)=freezingSignal(idx);
%         end
%     end
% 
% end
% 
% 
% end
% 
% 
% 
% 
% 
% 
% 
% 
% function experiment = writeOutputFile(experiment, varNames)
% 
%      p = experiment.p;
%      event_name = experiment.idx_synchro{2};
%      edges_msec = p.eventBasedAnalysisEdges_msec;
%      binSizes = diff(edges_msec);
%      binCenters_msec = edges_msec(1:end-1) + (binSizes/2);
%      nE = length(edges_msec);    nVar = length(varNames);
% 
%      fods = [];
% 
%     for iVar=1:nVar
% 
%         varName = varNames{iVar};
% 
%         varSubNames = split(varName,'.');  
% 
%         if isempty(event_name)
%             event_name = 'event';
%         end
% 
%         filename = [p.batch_ouputFile(1:end-4) sprintf('-%s-eventFreezingAnalysis_%s_%s.txt',event_name,varSubNames{3},varSubNames{4})];
% 
%         fods(iVar) = fopen(filename,'a');
% 
%         cmd = sprintf('var_=%s;',varName);
%         eval(cmd);
% 
%         [nR,nC] = size(var_);
% 
%         if ~p.batch_ouputFile_eventBasedAnalysis_headerWritten
% 
%             fprintf(fods(iVar), 'Event Based Analysis\n\n');
%             fprintf(fods(iVar), 'Parameters\n');
% 
%             fprintf(fods(iVar), '\tEdges_msec');
%             for iE=1:nE
%                 fprintf(fods(iVar), sprintf('\t%2.2f',edges_msec(iE)));
%             end
%             fprintf(fods(iVar), '\n');
% 
%             fprintf(fods(iVar), '\tminimum_gap_between_events_msec');
%             fprintf(fods(iVar), sprintf('\t%2.2f\n',p.minimum_gap_between_events_msec));   
% 
%             fprintf(fods(iVar), '\teventBasedAnalysisBaselineWindow_msec');
%             if ~isempty(p.eventBasedAnalysisBaselineWindow_msec)
%                 for i=1:length(p.eventBasedAnalysisBaselineWindow_msec)
%                    fprintf(fods(iVar), sprintf('\t%2.2f',p.eventBasedAnalysisBaselineWindow_msec(i))); 
%                 end
%             end
%             fprintf(fods(iVar), '\n');
% 
%              fprintf(fods(iVar), '\teventBasedAnalysisMinMaxWindow_msec');       
%             if ~isempty(p.eventBasedAnalysisMinMaxWindow_msec)
%                 for i=1:length(p.eventBasedAnalysisMinMaxWindow_msec)
%                    fprintf(fods(iVar), sprintf('\t%2.2f',p.eventBasedAnalysisMinMaxWindow_msec(i))); 
%                 end
%             end        
%             fprintf(fods(iVar), '\n');
% 
%             fprintf(fods(iVar), '\n\n');
% 
%             fprintf(fods(iVar),'\tbinCenters_msec');
%             fprintf(fods(iVar), '\n');
%             fprintf(fods(iVar),'mouse\tessai');
% 
%             for iE=1:nE-1
%                 fprintf(fods(iVar), sprintf('\t%2.4f',binCenters_msec(iE)));
%             end
%             fprintf(fods(iVar),'\n');
% 
%         end
% 
%         for iR=1:nR
%             fprintf(fods(iVar), p.dataFileTag);
%             fprintf(fods(iVar), sprintf('\t%d',iR));
%             for iE=1:nE-1
%                 fprintf(fods(iVar), sprintf('\t%2.4f',var_(iR,iE)));
%             end
%             fprintf(fods(iVar),'\n');
%         end
% 
%     end
% 
%     experiment.p.batch_ouputFile_eventBasedAnalysis_headerWritten=1;
% 
%     close_all_files(fods);
% 
% end
% 
% function close_all_files(fods)
%     for i=1:size(fods,1)       
%         fclose(fods(i));
%     end
% end