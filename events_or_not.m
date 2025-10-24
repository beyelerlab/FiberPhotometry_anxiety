%% Script de vérification des signaux pour détection d'événements
inputFolder = 'C:\Users\lpages\Desktop\FS_Zscore\input'; % dossier des fichiers
files = dir(fullfile(inputFolder, '*.mat')); % adapter l'extension selon vos fichiers

perc_max = 10;  % seuil par défaut
sfreq = 30;     % fréquence d'échantillonnage par défaut, à adapter

for k = 1:length(files)
    dataFile = fullfile(files(k).folder, files(k).name);
    fprintf('Processing %s\n', files(k).name);
    
    % Charger le fichier
    data = load(dataFile);
    
    if isfield(data, 'vData') && isfield(data.vData, 'optoPeriod')
        Sig = data.vData.optoPeriod;
        
        % Détection simple d'événements
        threshold = max(Sig)/perc_max;
        threshold = max(threshold, 0.01);
        Sig_bin = Sig > threshold;
        diffSig = diff(Sig_bin);
        idx_events = find(diffSig==1)+1;
        
        % Affichage résumé
        fprintf('  Signal max: %.4f, min: %.4f\n', max(Sig), min(Sig));
        fprintf('  Number of detected events: %d\n', length(idx_events));
        
        % Plot
        figure('Name', files(k).name);
        plot(Sig); hold on;
        plot(idx_events, Sig(idx_events), 'ro');
        xlabel('Frame'); ylabel('Amplitude');
        title(sprintf('%s: %d events detected', files(k).name, length(idx_events)));
        grid on;
        
    else
        warning('  File %s does not contain vData.optoPeriod', files(k).name);
    end
end
