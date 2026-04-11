cd 'S:\___DATA\PhotometryAndBehavior\01_DATA\ONE_COLOR\20260119_Carolina\SI-FiberAdult\OFT_SI-FiberAdult\Signal Plot'
%% PLOT FITTED DFF
close all; clear all;
files = dir('*.mat');
disp(['Found ', num2str(length(files)), ' files']);
for i = 1:length(files)
    load(files(i).name)
    ref=sig(1,:)';
    sig2=sig(2,:)';
    P = polyfit(ref,sig2,1);
    ref_fit = P(1)*ref+P(2);
    dff = ((sig2-ref_fit)./ref_fit)*100.0;
    
    Ax(i)=subplot(5,4,i);
    plot(dff((3:end),:),'Color',[0 0.4470 0.7410]);hold all;  
    title(files(i).name)
end
linkaxes(Ax,'x');
set(Ax,'xlim',[1 18000]);
saveas(figure(1),'Carolina_OFT__AM.fig');
saveas(figure(1),'Carolina_OFT__AM.png');

%% PLOT RAW
close all; clear all;
files = dir('*.mat');
for i = 1:length(files)
   load(files(i).name)
   ref=sig(1,:)';
   sig2=sig(:)';
    Ax(i)=subplot(5,4,i);
    plot(ref((3:end),:),'Color',[0.5 0.5 0.5]); hold all; 
    plot(sig2((3:end),:),'Color',[0 0 0]); hold all; 
    title(files(i).name)
end
linkaxes(Ax,'x');
set(Ax,'xlim',[1 18000]);
saveas(figure(1),'Carolina_OFT_baseline.fig');
saveas(figure(1),'Carolina_OFT_baseline.png');

%% PLOT DFF
close all; clear all;
files = dir('*.mat');
for i = 1:length(files)
   load(files(i).name)
   ref=sig(1,:)';
   sig2=sig(2,:)';
   sigdff = ((sig2 - mean(sig2))/(mean(sig2)));
   refdff = ((ref - mean(ref))/(mean(ref)))-0.1;
   finaldff = sigdff-refdff;
   subplot(5,4,i);
    plot(refdff((3:end),:),'Color',[0.5 0.5 0.5]); hold all; 
    plot(sigdff((3:end),:),'Color',[0 0 0]); hold all; 
    plot(finaldff((3:end),:),'Color',[0 0.4470 0.7410]); hold all;
   title(files(i).name)
end
saveas(figure(1),'Carolina_OFT_dff');
saveas(figure(1),'Carolina_OFT_dff.png');

%% CONVERT FILES
files = dir('*.mat');
for i = 1:length(files)
   load(files(i).name)
   ref=sig(1,:)';
   sig2=sig(2,:)';
   clear sig;
   sig=sig2;
   clear sig2 signals_nm;
   framerate=40;
   save(files(i).name,'ref','sig', 'framerate', 'labels');
end   

%% ZOOMED_IN

close all; clear all;
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
    ref=sig(1,:)';
    sig2=sig(:)';
    P = polyfit(ref,sig2,1);
    ref_fit = P(1)*ref+P(2);
    dff = ((sig2-ref_fit)./ref_fit)*100.0;
    Ax(i)=subplot(5,4,i)
    plot(dff((3:end),:),'Color',[0 0.4470 0.7410])   
    title(files(i).name)
end
linkaxes(Ax,'x');
set(Ax,'xlim',[1000 2000]);

saveas(figure(1),'Carolina_OFT_baseline_dff.fig');
saveas(figure(1),'Carolina_OFT_baseline_dff.png');


%% PLOT FITTED DFF - old data
close all; clear all;
files = dir('*.mat');
for i = 1:length(files)
    load(files(i).name)
    P = polyfit(ref,sig,1);
    ref_fit = P(1)*ref+P(2);
    dff = ((sig-ref_fit)./ref_fit)*100.0;
    
    Ax(i)=subplot(5,4,i);
    plot(dff((3:end),:),'Color',[0 0.4470 0.7410]);hold all;  
    title(files(i).name)
end
linkaxes(Ax,'x');
set(Ax,'xlim',[1 18000]);
saveas(figure(1),'Carolina_OFT_baseline_dff.fig');
saveas(figure(1),'Carolina_OFT_baseline_dff.png');