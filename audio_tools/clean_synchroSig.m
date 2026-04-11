function [npks,pks] = clean_synchroSig(synchroSig, sideview_freq, pks_period_sec, show_plot)

    % clear;clc;close all;
    % load('synchroSig.mat');
    % sideview_freq = 25.0;
    % pks_period_sec = 3;
    % show_plot=1;

    med_ = median(synchroSig);
    mad_ = mad(synchroSig);
    nSamples = size(synchroSig,1);
    t = 1:nSamples;
    t = t/sideview_freq;

    [pks,locs] = findpeaks(synchroSig,'MinPeakProminence',5*mad_,'MinPeakHeight',med_+5*mad_);
    t_pks = t(locs);
    dt_pks = diff(t_pks);
    n_pks = size(pks,1);
    idx_missing_pks = find(dt_pks>(pks_period_sec*1.5))
    n_missing_pks = size(idx_missing_pks,2);
    new_locs = []
    new_pks = []

    if show_plot
        figure()
        hold on
        plot(t,synchroSig)
        plot(t_pks,pks,'+r')
    end

    if n_missing_pks
        warning('%d/%d synchro signals are missing\n',n_missing_pks,n_pks+n_missing_pks);
        for i=1:n_missing_pks
            idx = idx_missing_pks(i);
            new_locs(end+1)= locs(idx)+floor(pks_period_sec*sideview_freq);
            new_pks(end+1) = (pks(idx)+pks(idx+1))/2;
            if show_plot
                plot([t_pks(idx),t_pks(idx+1)],[pks(idx),pks(idx+1)],'g:');
                plot(t(new_locs(end)),(pks(idx)+pks(idx+1))/2,'+g');
            end
        end
    end

    new_t_pks = t(new_locs);

    all_t_pks = [t_pks new_t_pks];
    all_idx_pks = [locs' new_locs];
    all_pks = [pks' new_pks];

    npks = size(all_pks,2);

    [~,i]=sort(all_idx_pks)
    all_t_pks=all_t_pks(i);
    all_idx_pks=all_idx_pks(i);
    all_pks=all_pks(i);

    pks={};
    pks.t_sec=all_t_pks;
    pks.idx=all_idx_pks;
    pks.values=all_pks;

    if show_plot
    plot(all_t_pks,all_pks,'m^');
    end

end




