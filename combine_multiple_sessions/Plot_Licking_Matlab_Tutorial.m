clear all; clc
path=['Y:\PhotometryAndBehavior\03_ANALYSIS\ONE_COLOR_analysis\GRAB\GRAB_DA\D1-cre\aIC\Batch4\20230328_EPM\Output\New_zscore\HM'];
outputpath=['Y:\PhotometryAndBehavior\03_ANALYSIS\ONE_COLOR_analysis\GRAB\GRAB_DA\D1-cre\aIC\Batch4\20230328_EPM\Output\New_zscore\HM'];
dirOutput=dir(fullfile(path,'*.mat'));
fileNames={dirOutput.name};
n=length(fileNames);
sfreq=29; 
SignalaroundLicking=nan(n,581);
timebin_msec=(-10000:50:10000);
timebin_sec=timebin_msec./1000;
animal_Tag=strings([1,n]);

for i=1:n
    
    tmp_file=char(fileNames(i))
    animal_Tag(1,i)=tmp_file(1:end-4);
    tmp_path=[path filesep tmp_file];
    load(tmp_path)
    
    if isfield(experiment.pData,'avgBulkSignalAroundFood')
        SignalaroundLicking(i,:) = experiment.pData.avgBulkSignalAroundFood;
    else
        if isfield(experiment.pData.bulkPETH,'nanmean')
            SignalaroundLicking(i,:)=experiment.pData.bulkPETH.nanmean;
        end
    end
    
   
    signal_tmp(1,:)=SignalaroundLicking(i,:);
    Before_bite(i,:)=signal_tmp(1:2*sfreq);
    Bite(i,:)=signal_tmp(4*sfreq+1:6*sfreq);
    After_bite(i,:)=signal_tmp(6*sfreq+1:8*sfreq);
    
end

for i=1:n
    
    signal_tmp=SignalaroundLicking(i,:);
    timebin_sec=timebin_msec./1000;
    signal=nanmean(SignalaroundLicking);

end 

sem = nanstd(SignalaroundLicking) / sqrt(size(SignalaroundLicking,1));
color=[143 40 140]./255;
shadedErrorBar(timebin_sec, SignalaroundLicking, {signal,sem}, 'lineprops', {'Color',color,'linewidth',1.5},'transparent',1)
ylabel('\Delta F/F (%)', 'Interpreter', 'tex');
xlabel('Time (s)')
xticks([-10 -5 -3 -2 -1 0 1 2 3 4 5])
% xticks([-5 -4 -3 -2 -1 0 1 2 3 4 5])
ylim([-1 3])

filename = fullfile(outputpath,'Bite');
print(filename,'-dpdf','-painters','-r1200');
close(figure(1))




