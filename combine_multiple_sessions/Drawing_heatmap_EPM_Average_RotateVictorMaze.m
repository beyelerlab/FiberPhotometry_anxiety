%
%
clear all; clc

%   load('mamap.mat');

path='C:\Users\epetru\Desktop\Behavioral Analysis\aIC-BLA Eli+Vici\20230624_EPM\Output';
outputpath='C:\Users\epetru\Desktop\Behavioral Analysis\aIC-BLA Eli+Vici\20230624_EPM\Output';

victor_mice = {'F23','M23'}

dirOutput=dir(fullfile(path,'*.mat'));
idx_toremove=[]
for i=1:size(dirOutput,1)
    if(strcmp(dirOutput(i).name,'analysisParams.mat'))
        idx_toremove(end+1)=i
    end
end
dirOutput(idx_toremove)=[]

fileNames={dirOutput.name};
n=length(fileNames);
map=nan(150,150,n);
occ_map = nan(150,150,n);


for i=1:n
    
    tmp_file=char(fileNames(i));
    for i=1:max(size(victor_mice))
        if strfind(tmp_file,victor_mice{i})
            rotate_maps=1;
        else
            rotate_maps=0;
        end
    end

    tmp_path=[path filesep tmp_file];
    load(tmp_path)
    
    fields_ = fieldnames(experiment.map);
    for iField=1:max(size(fields_))
        field_= experiment.map.(fields_{iField})      
        if isstruct(field_)
            fields2_ = fieldnames(field_);
            for iField2=1:max(size(fields2_))
%                 field2_= getfield(field_,fields2_{iField2});
                field2_= experiment.map.(fields_{iField}).(fields2_{iField2});      
                tmp=sprintf('[r,c]=size(experiment.map.%s.%s);', fields_{iField},fields2_{iField2})
                eval(tmp)
                if r==c && r>1
                    tmp=sprintf('experiment.map.%s.%s=experiment.map.%s.%s'';',fields_{iField},fields2_{iField2},fields_{iField},fields2_{iField2})
                    eval(tmp)
                end
            end
        end
    end
    
    ii = isnan(experiment.map.NormSig.IO);
    experiment.map.NormSig.IO(ii)=0;
    gaussFilt_PercAvgSigMap = imgaussfilt(experiment.map.NormSig.IO,2);
    gaussFilt_PercAvgSigMap(ii)=nan;
    % gaussFilt_PercAvgSigMap=gaussFilt_PercAvgSigMap./max(gaussFilt_PercAvgSigMap(:));
    map(:,:,i)=gaussFilt_PercAvgSigMap;
    occ_map(:,:,i)=experiment.map.Occ.IO;
    
    xMax=experiment.p.xMax/0.5;
    yMax=experiment.p.yMax/0.5;
    apparatusDesign_cmSP = experiment.apparatusDesign_cmSP;
    
    filename = [outputpath filesep 'Heatmap_' experiment.p.dataFileTag];

    clims=[-1 1];
    plot_heatmap(gaussFilt_PercAvgSigMap, experiment.map.Occ.IO, xMax, yMax, apparatusDesign_cmSP, filename, clims)  
    
end


map=nanmean(map, 3);
occ_map = nansum(occ_map, 3);
xMax=experiment.p.xMax/0.5;
yMax=experiment.p.yMax/0.5;
apparatusDesign_cmSP = experiment.apparatusDesign_cmSP;

filename = fullfile(outputpath,'Heatmap');
clims=[-0.5 0.5];
plot_heatmap(map, occ_map, xMax, yMax, apparatusDesign_cmSP, filename, clims);



















function plot_heatmap(map, occ_map, xMax, yMax, apparatusDesign_cmSP, filename, clims)


ii = find(occ_map==0);
map(ii)=NaN;

f=figure(1)
axis equal
axis off
hold on

xlim([0 xMax])
ylim([0 yMax])
set(gca,'Ydir','reverse')

colormap([1 1 1; jet(1024)]);

im=imagesc(map);
ax = gca
ax.CLim = clims;

hBar=colorbar('horiz');
box off
set(get(hBar,'title'),'string','\Delta F/F (%)','Fontname', 'Arial', 'Fontsize', 10)
set(hBar, 'Position', [0.624 0.046 0.2 0.02],'Fontname', 'Arial', 'Fontsize', 10);
% set(hBar, 'Position', [0.624 0.046 0.2 0.02], 'YTickLabel', {'-1','0','1'},'Fontname', 'Arial', 'Fontsize', 10);
set(0,'defaultfigurecolor','w')

x=apparatusDesign_cmSP.x/0.5;
y=apparatusDesign_cmSP.y/0.5;
x1=[x(2), x(1), x(12), x(11)];
y1=[y(2), y(1), y(12), y(11)];
plot(x1, y1, '--k', 'linewidth',1)
hold on
x2=[x(5), x(6), x(7), x(8)];
y2=[y(5), y(6), y(7), y(8)];
plot(x2, y2, '--k', 'linewidth',1)
x3=[x(8), x(9), x(10), x(11)];
y3=[y(8), y(9), y(10), y(11)];
plot(x3, y3, 'k', 'linewidth',1)
hold on
x4=[x(2), x(3), x(4), x(5)];
y4=[y(2), y(3), y(4), y(5)];
plot(x4, y4, 'k', 'linewidth',1)

print(filename,'-depsc','-painters','-r1200');
print(filename, '-dpdf');
close(figure(1))

end

