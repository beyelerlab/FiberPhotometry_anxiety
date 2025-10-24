clear all; clc

%% Paths
path = 'C:\Users\lpages\Desktop\FS_Zscore\output_test\plot\HFD';
outputpath = path;

%% Parameters
dirOutput = dir(fullfile(path,'*.mat'));
fileNames = {dirOutput.name};
n = length(fileNames);

sfreq = 29; 
timebin_msec = -10000:50:10000;    % correspond à 401 points
timebin_sec = timebin_msec / 1000;
target_length = length(timebin_msec);

% Color
color = [143 40 140] / 255;

% Preallocation
SignalaroundLicking = nan(n, target_length);
Before_bite = nan(n, 2*sfreq);
Bite = nan(n, 2*sfreq);
After_bite = nan(n, 2*sfreq);
animal_Tag = strings(1,n);

%% Loop over files
for i = 1:n
    tmp_file = fileNames{i};
    animal_Tag(i) = tmp_file(1:end-4);
    tmp_path = fullfile(path, tmp_file);
    load(tmp_path, 'experiment');

    % --- Extract signal ---
    sig = [];
    if isfield(experiment.pData,'avgBulkSignalAroundFood')
        sig = experiment.pData.avgBulkSignalAroundFood;
    elseif isfield(experiment.pData,'bulkPETH') && isfield(experiment.pData.bulkPETH,'nanmean')
        sig = experiment.pData.bulkPETH.nanmean;
    elseif isfield(experiment.vData,'freezingPETH') && isfield(experiment.vData.freezingPETH,'nanmean')
        sig = experiment.vData.freezingPETH.nanmean;
    else
        disp(['⚠️ Aucun signal trouvé dans ' tmp_file]);
        continue;  % passe au fichier suivant
    end

    % Force row vector
    sig = sig(:)';

    % Resample si nécessaire pour correspondre à 401 points
    if length(sig) ~= target_length
        x_old = linspace(1, target_length, length(sig));
        x_new = 1:target_length;
        sig = interp1(x_old, sig, x_new);
        disp(['ℹ️ Signal de ' tmp_file ' resamplé de ' num2str(length(x_old)) ' → ' num2str(target_length) ' points']);
    end

    % Store in final matrix
    SignalaroundLicking(i,:) = sig;

    % --- Optional: plot individual traces ---
    if all(~isnan(sig))
        plot(timebin_sec, sig, 'Color', color, 'LineWidth', 1.5); hold on;
    end

    % --- Segment phases ---
    Before_bite(i,:) = sig(1:2*sfreq);
    Bite(i,:)        = sig(4*sfreq+1:6*sfreq);
    After_bite(i,:)  = sig(6*sfreq+1:8*sfreq);
end

%% --- Compute mean and SEM ---
signal_mean = nanmean(SignalaroundLicking,1);
valid_n = sum(~isnan(SignalaroundLicking),1);   % n per time point
signal_sem  = nanstd(SignalaroundLicking,[],1) ./ sqrt(valid_n);

%% --- Plot mean ± SEM ---
figure; hold on;
shadedErrorBar(timebin_sec, signal_mean, signal_sem, ...
    'lineprops', {'Color', color, 'LineWidth', 1.5});
xline(0,'--k','LineWidth',1);  % Event marker
ylabel('\Delta F/F (%)', 'Interpreter', 'tex');
xlabel('Time (s)');
xticks(-10:1:5);
ylim([-0.5 1]);
title('Signal moyen autour du premier événement');

%% --- Save figure ---
filename = fullfile(outputpath, 'Bite_MeanSignal_SEM');
print(filename, '-dpdf', '-painters', '-r1200');
saveas(gcf, filename, 'png');
close(gcf);
