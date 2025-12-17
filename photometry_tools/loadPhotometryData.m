function [output, params_] = loadPhotometryData(params_)
% Load fiber-photometry DATA
% first valueof sig and ref are systematically aberant; if we control
% hamamatsu from Arduino, we always get one additional value due to
% fip matlab program (this has been tested three times at different
% moment 3/2018, 09/2018

    output = [];
    load([params_.dataRoot filesep params_.dataFileTag '.mat']);
   
    if ~exist('ref')                
        disp('new data type')    
        if exist('signals_nm')
            ref=sig(1,:)';
            sig=sig(2,:)';
        else
            warning('unknown data format')
        end
    end
 

    [r,c] = size(sig);
    if c>1        
            sig = sig(:,1);
            ref = ref(:,1);
    end
    output.sig = sig;
    output.ref = ref;
    output.nSamples = size(sig,1);
    output.num0 = 1: output.nSamples;
    params_.system = 'FIP' 
    if exist('ts') % it's an RWD system
        output.t0 = ts / 1000; 
        params_.HamamatsuFrameRate_Hz = 1/(mean(diff(output.t0)));
        params_.system = 'RWD'
    else % it's a FIP system
        output.t0 = (1: output.nSamples) / (params_.HamamatsuFrameRate_Hz);
    end


end