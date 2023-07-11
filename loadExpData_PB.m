function experiment = loadExpData_PB(p)

%%  LOADING, SYNCHRONIZING AND CLEANING THE DATA
vData = getVideoTrackingData(p);
% vData.bg=getBackGroundSlow(p);
pData = loadPhotometryData(p);


% if ~isfield(vData.videoInfo,'FrameRate')
%     vData.videoInfo=getVideoInfo(p);
%     if ~isfield(vData.videoInfo,'FrameRate')
%         vData.videoInfo.FrameRate = 20;
%     end
% end


if ~isfield(vData.videoInfo,'FrameRate')
    framerate = 20;
else
    framerate = vData.videoInfo.FrameRate;
end

if (framerate ~= p.HamamatsuFrameRate_Hz)
    warning('Program could not work if behavioral camera and hamamatsu camera have different frame rates');
    if p.protectMe, pause; end
end

% switch p.apparatus.type
%     case 'EPM'
%         
%         [iBehavioralStarts,vData]=detectBehavioralStart(p,vData); %For photometry we detect the experimenter placing the animal on the maze, one minute after the exp started.
%     
%     case 'NSFT'
%         
%         [iBehavioralStarts,vData]=detectBehavioralStart_HalfMinimumThreshold(p,vData); %For photometry we detect the experimenter placing the animal on the maze, one minute after the exp started.
%         iBehavioralStarts = 1200;
% 
%     case 'HOMECAGE-FD'
%         
%                 [iFirstCross,iCrossSup,iCrossInf,Th,vData]=detectBehavioralStart_simpleThresholdCrossingBothSides(p,vData);
%         iBehavioralStarts = iFirstCross;
%                 iBehavioralStarts = 1200;
%                 
%     case 'OFT'
%         
%         [iBehavioralStarts,vData]=detectBehavioralStart_HalfMinimumThreshold(p,vData); %For photometry we detect the experimenter placing the animal on the maze, one minute after the exp started.
% 
%     case 'SI'
%     
%         iBehavioralStarts = 12000;
%     case 'TASTE'
        % [iFirstCross,iCrossSup,iCrossInf,Th,vData]=detectBehavioralStart_simpleThresholdCrossingBothSides(p,vData);
%         iBehavioralStarts = iFirstCross;
% 
% end

if p.bonzaiDone
    [pData,vData] =  HamamatsuBlackFlyCorrectFrameNumbers(pData,vData,p);
end


if strcmp(p.cameraMode,'asynchronous')
    [vData,nSynchro,dFrame]=reSynchData(vData,pData,p);fprintf('\t> Synchro nSig=%d dt=%d frames\n',nSynchro,dFrame);resynchedCamPlot(p.dataRoot,p.dataFileTag,vData,B_synchronized);
end

%%

% Start_time=[p.dataRoot filesep p.dataFileTag '-Behavioralstart.txt'];
% 
% iBehavioralStarts=load(Start_time);
Samplingfreq=p.behaviorCameraFrameRate_Hz;

warning('program think behavior starts after 30 sec ! this is wrong check loadExpData_PB line 8-54');
if p.protectMe, pause; end

iBehavioralStarts=30*Samplingfreq; % unit should be seconds.


if isempty(iBehavioralStarts), iBehavioralStarts=0; end

%% DETECT ANIMAL FALL OF MAZE (I don't use this part anymore)
% nExperimenterIntervention = size(iBehavioralStarts,2);
% if (nExperimenterIntervention>1) && strcmp(p.apparatus.type,'EPM')
%     warning('Abnormal Intervention of Experimenter, did animal fall of EPM ?');
%     nFrames = size(pData.sig,1);
%     nFramesToRemove = nFrames - iBehavioralStarts(2) + (20*60);
%     if strcmp(p.dataFileTag,'F275')
%         nFramesToRemove = nFramesToRemove + (20*60)
%     end
%     
%     figure()
%     
%     
%     hold on
%     plot(pData.sig)
%     plot(iBehavioralStarts,pData.sig(iBehavioralStarts),'go');
%     i=iBehavioralStarts(2) - (20*60);
%     
%     plot(i,pData.sig(i),'ro');
%     [vData,pData]=removeFrames_PB(vData,pData,nFramesToRemove,'End',p);% if the animal fall, we remove the frames after the experimenter came into the room
% end

%% DETECT EXPERIMENTER STARTS BEHAVIOR
nFramesToRemove = max([p.HamamatsuFrameRate_Hz*60 iBehavioralStarts(1)]); %remove the first minute of the signal due to bleeching at the beginning of the fiber-photometry recording

%% DETECT EXPERIMENTER STARTS BEHAVIOR IS TOO DIFFICULT FOR NSFT
if strcmp(p.apparatus.type,'NSFT')
    nFramesToRemove = p.HamamatsuFrameRate_Hz*60; %remove the first minute of the signal due to bleeching at the beginning fot he fiber-photometry recording
end


% if p.dataFileTag == 'M800'
% 
%  [vData,pData]=removeFrames_PB(vData,pData,nFramesToRemove,'End',p);
%  
% end


[vData,pData]=removeFrames_PB(vData,pData,nFramesToRemove,'Beginning',p);%remove the first minute of the signal due to bleeching at the beginning fot he fiber-photometry recording

% if p.dataFileTag == 'F1046'
% 
% nFramesToRemove=36001-1200-13*20;
%  [vData,pData]=removeFrames_PB(vData,pData,nFramesToRemove,'End',p);
%  
% end


%% DETECT ABNORMALITIES IN PHOTOMETRY SIGNAL
% Depending of the histologfy status we skeep the analysis for the current file
if p.processDisconnection
    try
        if getSignalStatus(p.journal,p.dataFileTag)~=-6
            [pData,vData]= detectFiberDisconnection_SlidingWindow(p,pData,vData);
        else
            fprintf('Journal Said To Skeep Automatic detectFiberDisconnection\n');
        end
    catch
    end
end



%% DETECT ABNORMAL PHOTOMETRY SIGNAL WITH NEGATIVE RAW VALUES
pData = detectAbnormalNegativeValuesInPhotometryRawData(pData);
%% CLEAN VIDEO TRACKING DATA
vData=cleanPosBasedOnSpeedThreshold(vData,p); % remove all position when animal speed exceed 20 pixel per sec.

%% CREATES TIME VECTOR
nFrames = size(vData.mainX,1);T = 1: nFrames;T = T./ p.HamamatsuFrameRate_Hz;  pData.T = T; vData.nFrames = nFrames; %recreate time vector based on fiber-photometry frame rate

% delete if code doesn't ask for it
% vData_includingDisconnectionPeriods.nFrames = nFrames;

if size(pData.sig,1) ~= size(vData.mainX,1)
    fprintf('\t#Hamamatsu %d',size(pData.sig,1));fprintf('\t\t#BlackFly %d\n',size(vData.mainX,1));
    pause;
end

vData.bg=getBackGroundQuick(p);
experiment.p = p;
experiment.vData=vData;
experiment.pData=pData;

end