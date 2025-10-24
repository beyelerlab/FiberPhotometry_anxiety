function p = getConfig_PB(p,outputFolder,apparatus,videoExt)

c = clock();

p.batch_ouputFile = [outputFolder filesep sprintf('%04d%02d%02d-%02d%02d%02d',c(1),c(2),c(3),c(4),c(5),floor(c(6))) '.txt'];
p.bach_resultFile =  [outputFolder filesep sprintf('results_%04d%02d%02d-%02d%02d%02d',c(1),c(2),c(3),c(4),c(5),floor(c(6))) '.xlsx'];

p.batch_ouputFile_headerWritten=0;
p.batch_ouputFile_linearMapsForEPM_headerWritten=0;
p.batch_ouputFile_timebins_headerWritten=0;
p.batch_ouputFile_eventBasedAnalysis_headerWritten=0;
p.batch_ouputFile_eventBasedAnalysis_header2Written=0;

p.outputFolder=outputFolder;
p.figureFolder = [p.outputFolder filesep 'figures'];
p.apparatus=apparatus;
p.videoExt=videoExt;
p.cameraMode = 'synchronous';
p.ledDetectionThreshold = 50; %percent of led signal max
p.HamamatsuFrameRate_Hz = 20;
p.behaviorCameraFrameRate_Hz = 20;
p.led_synchro_period_sec = 5;
p.speedThreshold=50; % Use to clean the position data automatically, based on abnormal animal speed
p.body2licko_distanceMax_cm = 6;

p.remove_high_bleaching_period_sec = 60;

p.savePDF = 0;
p.saveFIG = 0;
p.savePNG = 0;

p.forceRedrawing = 0;
p.forceBehavioralStart = 0;

p.getVideoTrackingData_plot=0;
p.getVideoTrackingData_force=0;
p.forceGetBodyParts=0;

p.OccupancyMap_sigmaGaussFilt=1;
p.PhotometrySignalMap_sigmaGaussFilt=1;

p.OccupancyMap_sigmaGaussFilt=6;
p.PhotometrySignalMap_sigmaGaussFilt=6;

% p.deltaFF_slidingWindowWidth = 1200;

p.lookingForMouse = '';

p.bonzaiDone = 1;

% Event Based Analysis
p.eventBasedAnalysisEdges_msec = [-10000:50:10000]; 
p.minimum_gap_between_events_msec = 1000;
p.keep_first_and_last_events_only = 0;
p.eventBasedAnalysisBaselineWindow_msec = [-5000 -3000];
p.eventBasedAnalysisMinMaxWindow_msec = [-5000 2000];

% If you would like to divide the analysis in sub time periods you could

% define a serie of periods, p.time_bins_sec = start:step:stop
% p.time_bins_sec = 0:300:1200

% you can also define periods of different duration, define them one by one like p.time_bins_sec = [0,100,300,600]

% if you want only one period [start stop], just do p.time_bins_sec = [0 900];

% it uses indices, so we don't count the cut period used to remove
% photobleaching when you start at 0, the removed part will not be included

p.time_bins_sec = [0 900];


% p.firstLickTh_msec = 10000;

p.protectMe = 0;

p.results = p.journal;

save([p.outputFolder filesep 'analysisParams.mat'],'p');