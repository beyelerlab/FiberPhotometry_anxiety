%% --- Visualiser les événements LED détectés ---
experiment = preprocessEvents(experiment); % à exécuter avant si pas encore fait

idx = experiment.idx_synchro{1};  % indices des événements LED
signal = experiment.pData.mainSig; % signal principal
if size(signal,2) > 1
    signal = signal(:,end); % prendre la dernière colonne si plusieurs
end

figure('Name','LED Detection');
plot(signal, 'k'); % trace le signal en noir
hold on;

% Marquer les événements détectés
if ~isempty(idx)
    stem(idx, signal(idx), 'r', 'LineWidth', 1.5);
end

xlabel('Frames');
ylabel('Signal LED');
title('Vérification des événements LED détectés');
legend('Signal', 'Événements détectés');
grid on;