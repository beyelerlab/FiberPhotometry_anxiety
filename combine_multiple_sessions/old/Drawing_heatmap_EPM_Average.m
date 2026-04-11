clear all; clc

path='S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_GCaMP_aIC_pIC\20250408_all_aIC\EPM_Zscore\output2\good_heatmaps\SD';
outputpath='S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_GCaMP_aIC_pIC\20250408_all_aIC\EPM_Zscore\output2\good_heatmaps\SD';

dirOutput=dir(fullfile(path,'*.mat'));
fileNames={dirOutput.name};
n=length(fileNames);
map=[];
occ_map=[];


MapScale_cmPerBin = 0;

for i=1:n
    tmp_file=char(fileNames(i));
    tmp_path=[path filesep tmp_file];
    load(tmp_path)
    MapScale_cmPerBin = experiment.p.MapScale_cmPerBin;
    if i==1
        tmp = experiment.map.NormSig.IO;
        map = nan(size(tmp,1), size(tmp,2), n);
        occ_map = map;
    end
    map(:,:,i)=experiment.map.NormSig.IO;
    occ_map(:,:,i)=experiment.map.Occ.IO;
end


map= mean(map, 3, 'omitnan');
occ_map = sum(map, 3, 'omitnan');

xMax=experiment.p.xMax/MapScale_cmPerBin;
yMax=experiment.p.yMax/MapScale_cmPerBin;


caxis_ = [-1, 1]
gaussian_sigma = []
customize_plot = 1


filename = fullfile(outputpath,'Heatmap_wo_smoothing');
plot_heatmap(map, occ_map, xMax, yMax, filename, experiment, gaussian_sigma, caxis_, customize_plot);


gaussian_sigma = 0.75
filename = fullfile(outputpath,'Heatmap_gaussian_smoothing');
plot_heatmap(map, occ_map, xMax, yMax, filename, experiment, gaussian_sigma, caxis_, customize_plot);



function plot_heatmap(map, occ_map, xMax, yMax, filename, experiment, gaussian_sigma, caxis_, customize_plot)


MapScale_cmPerBin = experiment.p.MapScale_cmPerBin;
apparatusDesign_cmSP = experiment.apparatusDesign_cmSP;

ii = find(occ_map==0);
map(ii)=NaN;

f=figure()

hold on

map_mask = zeros(size(map));

x=apparatusDesign_cmSP.x/MapScale_cmPerBin;
y=apparatusDesign_cmSP.y/MapScale_cmPerBin;

% Zone Ordering
zones_ = experiment.vData.zones_cmSP;
types_ = {zones_(:).type};
idx_open = find(ismember(types_, 'open'));
idx_closed = find(ismember(types_, 'closed'));
idx_center = find(ismember(types_, 'center'));
idx_ordered = [idx_open idx_closed idx_center];

for iZ=1:size(zones_,2)
    X = int32((zones_(iZ).X)/MapScale_cmPerBin);
    Y = int32((zones_(iZ).Y)/MapScale_cmPerBin);
    W = int32((zones_(iZ).W)/MapScale_cmPerBin);
    H = int32((zones_(iZ).H)/MapScale_cmPerBin);
    map_mask(X+1:X+W-1, Y+1:Y+H-1) = ones(W-1,H-1);
    % imagesc(map_mask)
end


nan_map = nan(size(map));


if ~isempty(gaussian_sigma)
    ii = isnan(map);
    map(ii)=0;
    map = imgaussfilt(map,0.75);
    map(ii)=nan;
end

map(~map_mask) = nan_map(~map_mask);


imagesc(map);

for iZ=1:size(idx_ordered,2)
    type = zones_(idx_ordered(iZ)).type
    if strcmp(type, 'center')
        continue
    end
    if strcmp(type, 'open')
        linedef = '--k';
    end
    if strcmp(type, 'closed')
        linedef = 'k';
    end
    hold on
    x = zones_(idx_ordered(iZ)).xV/MapScale_cmPerBin;
    y = zones_(idx_ordered(iZ)).yV/MapScale_cmPerBin;
    x = [x x(1)];
    y = [y y(1)];
    plot(x,y, linedef, 'linewidth',1)

end


if customize_plot
    axis equal
    axis off
    xlim([0 xMax])
    ylim([0 yMax])
    set(gca,'Ydir','reverse')
    box off
    if ~isempty(caxis_)
        caxis(caxis_)
    end
    hBar=colorbar('horiz');
    colormap([1 1 1; jet(1024)]);
    set(get(hBar,'title'),'string','\Delta F/F (z-score)','Fontname', 'Arial', 'Fontsize', 10)
    %set(hBar, 'Position', [0.624 0.046 0.2 0.02], 'YTickLabel', {'-1','0','3'},'Fontname', 'Arial', 'Fontsize', 10);
    set(0,'defaultfigurecolor','w')
end




print(filename,'-depsc','-painters','-r1200');
print(filename, '-dpdf');
close(f)

end

