HamamatsuFrameRate_Hz = 30;
windowSize = HamamatsuFrameRate_Hz*5; % Sliding window size (number of points)

dff_color = [49/255, 92/255, 43/255];
variance_color = [6/255, 71/255, 137/255];
treshold_color = [255/255, 89/255, 100/255];


p = 'E:\NAS_SD\SuiviClient\Beyeler\DATA\20230502_NSFT\Inputs\F2435.mat';
load(p);

iso = sig(1,:);
physio = sig(2,:);

nSamples = max(size(sig));
num = 1: nSamples;
t = num ./ HamamatsuFrameRate_Hz;

t = t(30*HamamatsuFrameRate_Hz:end);
iso = iso(30*HamamatsuFrameRate_Hz:end);
physio = physio(30*HamamatsuFrameRate_Hz:end);

%  figure();
%  hold on
%  plot(t, iso, 'm');
%  plot(t, physio, 'b');
 
 
 iso_fit = fit_iso(iso, physio);
  dff = calculate_dff(iso_fit, physio);
 



% Initialize variables
n = length(dff);
variances = zeros(1, n - windowSize + 1);
lowVarianceRegions = false(1, n);

% Calculate variance using the sliding window
for i = 1:n - windowSize + 1
    window = dff(i:i + windowSize - 1);
    variances(i) = var(window);
end

threshold = prctile(variances,5);

% Identify low-variance periods
lowVarianceIndices = find(variances < threshold);

% Mark low-variance periods on the original time series
for idx = lowVarianceIndices
    lowVarianceRegions(idx:idx + windowSize - 1) = true;
end

% Plot the results
figure;
subplot(3,2, [3 4])
plot(dff, 'color', dff_color, 'LineWidth', 1.5); hold on;
plot(lowVarianceIndices, dff(lowVarianceIndices), 'Marker', '.', 'MarkerSize', 10, 'MarkerFaceColor', treshold_color, 'LineStyle', 'none');
title('Time Series with Detected Low-Variance Periods');
xlabel('Time');
ylabel('Amplitude');
legend('DFF', 'Low-Variance Periods');
grid on;
subplot(3,2,1)
hold on
title('Variance (5s sliding window)');
 plot(variances, 'color', variance_color, 'LineWidth', 1.5);
 plot(lowVarianceIndices, variances(lowVarianceIndices), 'Marker', '.', 'MarkerSize', 10, 'MarkerFaceColor', treshold_color, 'LineStyle', 'none');
 yline(threshold, 'color', treshold_color)
 xlabel('Time');
ylabel('Amplitude');
legend('Variance', '5th percentile threshold');
 grid on;
 subplot(3,2,2)
 hold on
 title('Variance Distribution');
 histogram(variances,100, 'Normalization', 'Probability','FaceColor', variance_color, 'EdgeColor', variance_color);
 xline(threshold, 'color', treshold_color)
 xlabel('Variance');
ylabel('Density');
 
 periods = detectLowVariancePeriods(dff, windowSize, threshold);
 
[d_max, i_max] = max(periods(:,3));

baseline = dff(periods(i_max,1):periods(i_max,2));
z_score = dff - nanmean(baseline) / nanstd(baseline)

nanstd(baseline)
 nanstd(dff)
 
 nanmean(baseline)
 nanmean(dff)
 
 
subplot(3,2,[5 6])
plot(z_score, 'color', dff_color, 'LineWidth', 1.5); hold on;
plot(dff - nanmean(dff) / nanstd(dff), 'color', [.7 .5 .2], 'LineWidth', 1.5); hold on;
plot(periods(i_max,1):periods(i_max,2), z_score(periods(i_max,1):periods(i_max,2)), 'color', treshold_color);
title('Z-score');
xlabel('Time');
ylabel('Amplitude');
legend('z-score [baseline=longest low variance period]', 'z-score full session');
grid on;
 
 
 
 
%  Partager l'axe x entre les deux sous-graphes
% ax = findall(gcf, 'Type', 'axes'); % Trouver tous les axes dans la figure
% linkaxes(ax, 'x'); % Lier les axes x


function fit_ = fit_iso(iso, physio)
        %% fit iso to fluo gcamp (fit sig1 to sig2)
        N=1; % polynomial coef for linear
        idx1 = find(isnan(iso)==1);
        idx2 = find(isnan(physio)==1);
        iso_tmp = iso;
        physio_tmp = physio;  
        iso_tmp(union(idx1,idx2))=[];
        physio_tmp(union(idx1,idx2))=[];
        P = polyfit(iso_tmp, physio_tmp, N);
        fit_ = iso*P(1)+P(2);
end

function dff = calculate_dff(iso_fit, physio)
%     min_ = min([min(physio), min(iso_fit)]);
%     physio = physio - min_ + 1;
%     iso_fit = iso_fit - min_ + 1;
    dff = (physio-iso_fit)./iso_fit;
    dff = dff * 100;
end




function periods = detectLowVariancePeriods(timeSeries, windowSize, threshold)
    % detectLowVariancePeriods: Détecte les périodes de faible variance dans une série temporelle
    % Inputs:
    %   - timeSeries: Le vecteur de la série temporelle
    %   - windowSize: Taille de la fenêtre glissante
    %   - threshold: Seuil de variance pour détecter les périodes
    % Outputs:
    %   - periods: Tableau contenant [startIdx, endIdx, length] pour chaque période
    
    n = length(timeSeries);
    variances = zeros(1, n - windowSize + 1);
    
    % Calcul des variances dans les fenêtres glissantes
    for i = 1:(n - windowSize + 1)
        window = timeSeries(i:i + windowSize - 1);
        variances(i) = var(window);
    end
    
    % Détection des indices où la variance est sous le seuil
    lowVarianceRegions = variances < threshold;
    
    % Identifier les périodes continues de faible variance
    transitions = diff([0, lowVarianceRegions, 0]); % Ajout de zéros pour détecter les bords
    startIndices = find(transitions == 1); % Début des périodes
    endIndices = find(transitions == -1) - 1; % Fin des périodes

    % Construction du tableau des périodes
    periods = [];
    for k = 1:length(startIndices)
        startIdx = startIndices(k);
%         endIdx = endIndices(k) + windowSize - 1; % Inclure la taille de la fenêtre
        endIdx = endIndices(k)- 1; % Inclure la taille de la fenêtre
        lengthPeriod = endIdx - startIdx + 1;
        periods = [periods; startIdx, endIdx, lengthPeriod]; %#ok<AGROW>
    end
end
