
clear all; clc

path='C:\Users\cnicolas\Desktop\Post doc Bordeaux\Manip\Combined data\aIC_BLA\SUCROSE QUININE\SUCROSE\OUTPUT TEST';
outputpath='C:\Users\cnicolas\Desktop\Post doc Bordeaux\Manip\Combined data\REANALYZE EPM\EPM\aIC\Output';

dirOutput=dir(fullfile(path,'*.mat'));
fileNames={dirOutput.name};
n=length(fileNames);

for i=1:n
    
    tmp_file=char(fileNames(i));
    tmp_path=[path filesep tmp_file];
    load(tmp_path);
    size(experiment.pData.bulkPETH.matrix,1);
    
    fod=fopen([path filesep 'event_number.xls'],'a');
    
    if (i==1)
        fprintf(fod,'mouse\tevent number\n');
    end
    fprintf(fod,'%s\t%d\n',tmp_file,size(experiment.pData.bulkPETH.matrix,1));
    
    fclose(fod);
    
end



















