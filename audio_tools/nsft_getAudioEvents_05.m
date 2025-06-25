function [audioEvents_sec,timeLag,nSTD,audioDetectionGap_sec] = nsft_getAudioEvents_05(experiment)

params = experiment.p

nSTD=4;
audioDetectionGap_sec = 1;

sideviewRoot = [params.dataRoot '-sideview'];
if ~exist(sideviewRoot,'dir'), fprintf('sideview folder is  missing\n');end
audioEvents_path = [sideviewRoot filesep params.dataFileTag '-audioEvents.mat'];


suffix = 'bitesDetection';

figureSubFolder = [params.figureFolder filesep suffix];
if ~exist(figureSubFolder,'dir'),mkdir(figureSubFolder);end

figName = [figureSubFolder filesep params.dataFileTag '-' suffix '.jpeg'];


if 1 %~exist(audioEvents_path,'file')
    
    sideview_videoPath = [sideviewRoot filesep params.dataFileTag '-sideview.mp4'];
    if ~exist(sideview_videoPath,'file'), fprintf('sideview video is missing\n');end
    sideview_synchroLedPath = [sideviewRoot filesep params.dataFileTag '-synchroLED.txt'];
    if ~exist(sideview_synchroLedPath,'file'), fprintf('sideview synchro LED bonsai  is missing\n'); end
    
    % Average Signals on Zero

    T = readtable(sideview_synchroLedPath);
    column1_name = T.Properties.VariableNames{1};
    cmd = sprintf('synchroSig=T.%s',column1_name);
    eval(cmd);
    clear T
    
    videoInfo = VideoReader(sideview_videoPath);
    sideview_freq = videoInfo.FrameRate;
    pks_period_sec = experiment.p.led_synchro_period_sec;
    show_plot=0;
    [synchro_size, synchro_pks]=clean_synchroSig(synchroSig, sideview_freq, pks_period_sec, show_plot);

    % synchroSig = load(sideview_synchroLedPath);
    % synchroSig =synchroSig - mean(synchroSig);
    % synchroSig_size = size(synchroSig,1);

    
    sideview_AlternativeAudioPath = [sideviewRoot filesep params.dataFileTag '-sideview.mp3'];
    if exist(sideview_AlternativeAudioPath, 'file')
            [audioSig, audio_sfreq] = audioread(sideview_AlternativeAudioPath);
    else
            [audioSig, audio_sfreq] = audioread(sideview_videoPath);
    end
    
    audioSig = audioSig - mean(audioSig);
    audioSig_size =size(audioSig ,1);
    t_tmp = (1:audioSig_size)/audio_sfreq;
    
%     plot(t_tmp,audioSig);
    
    audio_nSamplePerVideoFrame = floor(audioSig_size / (synchro_size));
%     audio_sfreq = (audioSig_size / (synchroSig_size)) * videoInfo.FrameRate;
    
%     synchroSig  = synchroSig >(max(synchroSig )/10);
%     tmp =diff(synchroSig );iSync  = find(tmp ==1)+1;dSync = diff(iSync );
%     sync_gap = median(dSync);
%     
%     ii = find(dSync>(sync_gap*1.5));
%     if ~isempty(ii), warning('synch signal lost');end
%     
%     tSyncSignal = 1:synchroSig_size;
%     tSyncSignal = tSyncSignal / videoInfo.FrameRate;
    
    tAudio = -0.5:1:audioSig_size-0.5;
    %    tAudio = 1:audioSig_size;
    tAudio = tAudio / audio_sfreq;
    tAudio_period = 1/audio_sfreq;
    
    
    
    %Smart downsampling to avoid loosing peaks
    nSamples = size(audioSig,1);
    downSamplingFactor = 1000;
    nLines = floor(nSamples/downSamplingFactor);
    nSamples = nLines * downSamplingFactor;
    tmp = audioSig(1:nSamples);
        
    
    tmp = reshape(tmp',downSamplingFactor,nLines);
    [tmp,i] = max(tmp);
    tmp2 = tAudio(1:nSamples);
    tmp2 = reshape(tmp2',downSamplingFactor,nLines);
    tmp3 = nan(nLines,1);
    for j=1:nLines
        tmp3(j)=tmp2(i(j),j);
    end
    
    audioDown_values = tmp;
    audioDown_ts = tmp3;
    audioDown_sfreq = audio_sfreq / downSamplingFactor;
    
    tic;audioDown_values_f = highpass(audioDown_values,0.25,audioDown_sfreq);
    toc
    [pks,locs1] = findpeaks(audioDown_values_f);
    audioTH = nSTD* median(movstd(audioDown_values,440));
    ii = find(pks<audioTH);
    pks(ii)=[];locs1(ii)=[];
    
    
    audioEvents_sec =audioDown_ts(locs1);
    locs2 = locs1;
    
    diff_audioevents_sec = diff(audioEvents_sec);

    ii = find(diff_audioevents_sec<audioDetectionGap_sec);
    locs2(ii+1)=[];
    
    timeLag = (synchro_pks.idx(1)/videoInfo.FrameRate);
    audioEvents_sec = audioDown_ts(locs2) - timeLag;
    
    save(audioEvents_path,'audioEvents_sec','timeLag','nSTD','audioDetectionGap_sec');
    
    if ~exist(figName,'file') || params.forceRedrawing
        f=figure('name',params.dataFileTag,'Position',[20 20 800 800]);
        hold on
        
        plot(audioDown_ts,audioDown_values_f)
        
        for vSTD=1:6
            audioTH = vSTD* median(movstd(audioDown_values,440));
            plot([audioDown_ts(1) audioDown_ts(end)],[audioTH audioTH],'k')
        end
        
        audioTH = nSTD* median(movstd(audioDown_values,440));
        plot([audioDown_ts(1) audioDown_ts(end)],[audioTH audioTH],'r')
        
        plot(audioDown_ts(locs1),audioDown_values_f(locs1),'Marker','d','MarkerFacecolor','r','MarkerEdgecolor','none','LineStyle','none');
        plot(audioDown_ts(locs2),audioDown_values_f(locs2),'Marker','d','MarkerFacecolor','g','MarkerEdgecolor','none','LineStyle','none');
        
        print(f,figName,'-djpeg');
        
        savefig(f,[figureSubFolder filesep params.dataFileTag '-' suffix '.fig']);
        
        close(f);
    end
    
    
    
    

    
    
else
    load(audioEvents_path)
end

end

function borisData = getBorisData(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   F251 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   F251 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   F251 = importfile('F251.tsv', 17, 72);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2019/08/22 17:15:35

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 17;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: categorical (%C)
%   column3: double (%f)
%	column4: double (%f)
%   column5: text (%s)
%	column6: double (%f)
%   column7: text (%s)
%	column8: text (%s)
%   column9: categorical (%C)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%C%f%f%s%f%s%s%C%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
borisData = table(dataArray{1:end-1}, 'VariableNames', {'Time','Mediafilepath','Totallength','FPS','Subject','Behavior','Behavioralcategory','Comment','Status'});
end








