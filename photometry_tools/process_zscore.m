function [clean_zscore, zscore] = process_zscore(dff)

     mean_bl = nanmean(dff);
     std_bl = nanstd(dff);
     zscore = (dff - mean_bl) / std_bl;
     
      nSamples = max(size(dff));
     
     [pks,locs,w,p] = findpeaks(zscore,'MinPeakHeight', 2.58, 'MinPeakProminence', 2);
     dff_clean = dff;
    n_pks = size(pks, 2);
    % if n_pks
        for i=1:n_pks
            x = locs(i);      
            i1 = floor(x - w(i));
            i2 = floor(x + w(i));
            i1 = max([i1,1]);
            i2 = min([i2 nSamples]);
            dff_clean(i1:i2)= nan(1,i2-i1+1);
        end
    % end
    
    mean_bl = nanmean(dff_clean);
    std_bl = nanstd(dff_clean);
    clean_zscore = (dff - mean_bl) / std_bl;
    
end