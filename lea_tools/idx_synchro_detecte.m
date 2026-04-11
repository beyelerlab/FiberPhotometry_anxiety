%% --- Visualiser uniquement les événements détectés (idx_synchro) ---
signal = experiment.vData.optoPeriod;  % signal LED Bonsai
idx = experiment.idx_synchro{1};        % indices des événements détectés

figure('Name','LED Events (idx\_synchro)');
plot(signal, 'k');  % trace le signal complet en noir
hold on;

% Tracer les événements détectés
if ~isempty(idx)
    stem(idx, signal(idx), 'r', 'LineWidth', 1.5);  % tiges rouges
end

xlabel('Frames');
ylabel('Signal LED');
title('Événements détectés à partir de idx\_synchro');
legend('optoPeriod', 'Événements détectés');
grid on;
