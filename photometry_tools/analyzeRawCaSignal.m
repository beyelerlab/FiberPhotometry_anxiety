function Ca=analyzeRawCaSignal(experiment)

    %% INITIALIZATION
    removeFirstMinute=0;
    params = experiment.p;
    pData = experiment.pData;
    sig = pData.sig;
    ref = pData.ref;
    t = pData.T;
    t0 = pData.t0;
    debug = 0;

    frameRate_Hz = params.HamamatsuFrameRate_Hz;
    nSamples = size(sig,1);
    Ca = processBulkSignal(sig,ref,frameRate_Hz,removeFirstMinute);
    Ca.transients = get_transients(Ca.T, Ca.dff, debug);
    Ca.t0 = t0;
end

%% Subfunctions for Bulk Signal Processing
function Ca = processBulkSignal(sig,ref,frameRate_Hz,removeFirstMinute)
    Ca=[];
    %% If this has not been taken care off earlier, this has to be done to remove autobleaching period that corrupt analysis
    frameRate_Hz = floor(frameRate_Hz);
    if(removeFirstMinute), sig(1:frameRate_Hz*60)=[];ref(1:frameRate_Hz*60)=[];end
    %% Processing Bulk Signal
    Ca.nFrames = size(ref,1);
    Ca.T = 1: Ca.nFrames;
    Ca.T = Ca.T./ frameRate_Hz;
    Ca.raw.sig = sig;
    Ca.raw.ref = ref;

    % Lerner 2015, used in Beyeler lab since 20231027
    % Ca.ref_fit = fit_iso(Ca.raw.ref, Ca.raw.sig, 'without_constraints');
    
    % Lerner 2015 and contrained fit since 20250625
    Ca.ref_fit = fit_iso(Ca.raw.ref, Ca.raw.sig, 'with_constraints');
    
    Ca.dff = calculate_dff(Ca.ref_fit, Ca.raw.sig);
    
    [Ca.zscore, Ca.clean_zscore] = process_zscore(Ca.dff);
    
    Ca.mainSig = Ca.zscore; 

end

function [clean_zscore, zscore] = process_zscore(dff)

    mean_bl = mean(dff, 'omitnan');
    std_bl = std(dff, 'omitnan');
    zscore = (dff - mean_bl) ./std_bl;
    clean_zscore = zscore;
    
    nSamples = max(size(dff));
    
    [pks,locs,w,p] = findpeaks(zscore,'MinPeakHeight', 2.58, 'MinPeakProminence', 2);
    dff_clean = dff;
    n_pks = size(pks, 1);
    if n_pks
        for i=1:n_pks
            x = locs(i);
            i1 = floor(x - w(i));
            i2 = floor(x + w(i));
            i1 = max([i1,1]);
            i2 = min([i2 nSamples]);
            dff_clean(i1:i2)= nan(1,i2-i1+1);
        end
        mean_bl = mean(dff_clean, 'omitnan');
        std_bl = std(dff_clean, 'omitnan');
        clean_zscore = (dff - mean_bl) / std_bl;
    end

end

function fit_ = fit_iso(iso, physio, fit_mode)
        %% fit iso to fluo gcamp (fit sig1 to sig2)
        N=1; % polynomial coef for linear
        idx1 = find(isnan(iso)==1);
        idx2 = find(isnan(physio)==1);
        iso_tmp = iso;
        physio_tmp = physio;  
        iso_tmp(union(idx1,idx2))=[];
        physio_tmp(union(idx1,idx2))=[];

        if strcmp(fit_mode, 'without_constraints')        
            fit_coefs = polyfit(iso_tmp, physio_tmp, N);
            fit_ = iso*fit_coefs(1)+fit_coefs(2);
        end
        if strcmp(fit_mode, 'with_constraints')        
            [fit_coefs, gof] = fit(iso_tmp, physio_tmp, 'poly1', 'Lower', [0, -Inf], 'Upper', [Inf, Inf], 'Robust', 'LAR');
            fit_ = iso*fit_coefs.p1+fit_coefs.p2;
        end        
% 
%         figure()
%         hold on
%         plot(iso, 'm')
%         plot(physio, 'b')
%         plot(fit_, 'k')
%         plot(fit_2, 'r')
    
        
end

function dff = calculate_dff(iso_fit, physio)
%     min_ = min([min(physio), min(iso_fit)]);
%     physio = physio - min_ + 1;
%     iso_fit = iso_fit - min_ + 1;
    dff = (physio-iso_fit)./iso_fit;
    dff = dff * 100;
end



function transients = get_transients(t, dff, debug)
    
        
%     lowPassTh_Hz= 0.5;
%     highPassTh_Hz= 2;
    
    % filterType = 'bandpass';
%     fc = [lowPassTh_Hz highPassTh_Hz];
%     
%     
%     filterType = 'low';
%     fc = lowPassTh_Hz;
%     
%     fs = 1/median(diff(t));
%     [b,c] = butter(4,fc/(fs/2),filterType);
%     
%     nan_idx = isnan(dff)
%     
%     dff(nan_idx)=0;
%     
%     filtered_sig = filtfilt(b, c, dff);

    fs = 1/median(diff(t));
    MinPeakProminence = median(dff) + (1.5*mad(dff));
    MinPeakGap_s = 0.5;
    MinPeakDistance = floor(MinPeakGap_s * fs);
    [pks,locs,w,p] = findpeaks(dff, 'MinPeakDistance', MinPeakDistance, 'MinPeakProminence', MinPeakProminence);
    
    transients.time = t(locs);
    transients.loc = locs;
    transients.peak = pks;
    transients.width = w;
    transients.prominence = p;
    transients.MinPeakDistance = MinPeakDistance;
    transients.MinPeakProminence =MinPeakProminence;

    if debug
        n = size(locs,1);
        fig = figure();
        plot_transients(transients,t,dff,'dff');
    end

end


function plot_transients(transients_,t,sig,sig_str)

    locs_ = transients_.loc;
    w_    = transients_.width;
    p_    = transients_.prominence;
    pks_  = transients_.peak;

    max_ = max(sig);
    min_ = min (sig);
    amp_ = max_ - min_;
    sup_ = max_ + amp_/5;

    hold on
    plot(t,sig,'g')

    for k=1:size(locs_,1)
        i = locs_(k);
        x_ = t(i);
        y_ = sig(i);
        plot([x_ x_],[y_ sup_], 'm')
        plot(x_,sup_,'m*')
%         text(x_,sup_ + (amp_/10),sprintf('w=%2.2f, p=%2.2f',w_(k),p_(k)),'FontSize', 6,'Rotation',90);
    end
    legend({sig_str})

    ylim([(min_ - (amp_/4)) (max_ + (amp_))])
end
