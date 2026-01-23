clear all; clc; close all;


p = 'S:\_Lea\1.Data\PhotoM\20251210_aIC_NAc_pIC\20251218_FS\Analysis\output_test\plot';
l = dir([p filesep '*.mat']);



for iMouse=1:length(l)

    datapath = [p filesep l(iMouse).name];

    load(datapath);
    peth = experiment.pData.bulkPETH.zcored_matrix;

    [nTrials, nBins] = size(peth);

    if iMouse==1
        all_means = nan(length(l),nBins);
    end

    t_sec = experiment.p.eventBasedAnalysisEdges_msec/1000;
    peth_time = linspace(t_sec(1), t_sec(end), nBins);


    N = nTrials;
    baseColor = [1 1 1];          % blue
    
    intensity = linspace(0, 1, N)';    % from 1 (full) to 0 (black)
    
    cmap = [baseColor(1)*intensity, ...
            baseColor(2)*intensity, ...
            baseColor(3)*intensity];


    trials_to_keep = [];

    [filepath,name,ext] = fileparts(l(iMouse).name)
    f1 = figure('Name',name);
    subplot(2,1,1);
    hold on
    for iTrial=1:nTrials
        trial_data = peth(iTrial,:);
        if ~(sum(isnan(trial_data))==nBins)
            plot(peth_time, trial_data, 'Color', cmap(iTrial,:));
            trials_to_keep = [iTrial trials_to_keep];
        end
    end

    peth_fig = peth(trials_to_keep,:);

    peth_nanmean = nanmean(peth_fig);
    plot(peth_time, peth_nanmean, 'Color', [1 0.2 0.2]);
    all_means(iMouse,:) = peth_nanmean(:,:);

    [nTrials, nBins] = size(peth_fig);

    subplot(2,1,2);
    imagesc(peth_time, 1:nTrials, peth_fig);

    saveas(f1,[p filesep name '_peth.jpg']);

    close(f1);
    
end


f1 = figure('Name','AllMice');
subplot(2,1,1);
hold on
for iMouse=1:length(l)
    plot(peth_time, all_means(iMouse,:), 'Color', [0.6 0.6 0.6]);
end

peth_nanmean = nanmean(all_means);
plot(peth_time, peth_nanmean, 'Color', [1 0.2 0.2]);

[nTrials, nBins] = size(peth_fig);

subplot(2,1,2);
imagesc(peth_time, 1:length(l), all_means);

saveas(f1,[p filesep 'allmice_peth.jpg']);

close(f1);
