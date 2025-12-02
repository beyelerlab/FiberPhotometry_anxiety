clear all; clc

% ---- Paths ----
path = 'S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_aIC_BLA\Analysis_all_aIC_BLA\NSFT_Zscore\heatmaps\HFD';
outputpath = 'S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_aIC_BLA\Analysis_all_aIC_BLA\NSFT_Zscore\heatmaps\HFD';

% ---- Files ----
dirOutput = dir(fullfile(path,'*.mat'));
fileNames = {dirOutput.name};
n = numel(fileNames);

if n == 0
    error('Aucun fichier .mat trouvé dans %s', path);
end

maps      = [];   % heatmaps brutes (ΔF/F%)
occ_maps  = [];   % maps d'occupation
exp_ref   = [];   % on conserve le 1er "experiment" pour les contours/paramètres

% ---- Load loop (RAW, pas de filtre ici) ----
for i = 1:n
    S = load(fullfile(path, fileNames{i}));  % charge 'experiment'
    experiment = S.experiment;

    I = experiment.map.NormSig.IO;   % heatmap brute avec NaN
    O = experiment.map.Occ.IO;       % occupation (même grille)

    if i == 1
        [h,w] = size(I);
        maps     = nan(h,w,n);
        occ_maps = nan(h,w,n);
        exp_ref  = experiment;  % géométrie / sigma / etc.
    else
        [hh,ww] = size(I);
        if hh~=h || ww~=w
            error('Taille de carte différente dans %s', fileNames{i});
        end
    end

    maps(:,:,i)     = I;
    occ_maps(:,:,i) = O;
end

% ---- Moyenne groupe avant tout filtrage ----
map_avg   = nanmean(maps,    3);
occ_avg   = nanmean(occ_maps,3);

% ---- Masque d’occupation : enlève zones quasi non visitées ----
occ_thr   = 0.01 * max(occ_avg(:));   % 1% du max (à ajuster: 0.5–5%)
mask_occ  = occ_avg >= occ_thr;
map_avg(~mask_occ) = NaN;

% ---- Flou gaussien NaN-safe une seule fois (sigma du dataset) ----
sigma = exp_ref.p.PhotometrySignalMap_sigmaGaussFilt;
map_filt = gaussfilt_nan_safe(map_avg, sigma);

% ---- Échelle robuste centrée sur 0 (divergente) ----
vals = map_filt(~isnan(map_filt));
if isempty(vals), warning('Carte vide après masquage.'); vals = 0; end
v = prctile(abs(vals), 98);         % coupe les outliers (95–99% selon besoin)
if v == 0, v = max(abs(vals)); end  % fallback
clim = [-v v];

% ---- Plot ----
f = figure(1); clf; hold on
imagesc(map_filt);
set(gca,'YDir','reverse'); axis equal tight off
colormap(bluewhitered(257));
caxis(clim);

% Colorbar
hBar = colorbar('southoutside');
hBar.Label.String = '\DeltaF/F (%)';
set(hBar,'Ticks',linspace(clim(1),clim(2),3));

set(0,'defaultfigurecolor','w');

% Contours appareil
x1 = exp_ref.apparatusDesign_cmSP.x / 0.5;
y1 = exp_ref.apparatusDesign_cmSP.y / 0.5;
x1 = [x1, x1(1)]; y1 = [y1, y1(1)];
plot(x1, y1, 'k', 'LineWidth', 1);

% Exemple zone (si dispo)
if isfield(exp_ref,'vData') && isfield(exp_ref.vData,'zones_cmSP') && numel(exp_ref.vData.zones_cmSP) >= 2
    x2 = [exp_ref.vData.zones_cmSP(2).xV] / 0.5;
    y2 = [exp_ref.vData.zones_cmSP(2).yV] / 0.5;
    plot(x2, y2, '--k', 'LineWidth', 1);
end

% ---- Export ----
filename = fullfile(outputpath,'Heatmap_OFT_FD_hypercenter');
print(f, [filename '.pdf'], '-dpdf','-painters','-r1200');
print(f, [filename '.jpg'], '-djpeg','-painters','-r1200');

% =================== FONCTIONS LOCALES ===================

function F = gaussfilt_nan_safe(I, sigma)
% Filtre gaussien 2D en tenant compte des NaN par normalisation du masque
    if nargin<2 || sigma<=0 || all(isnan(I(:)))
        F = I; return
    end
    mask = ~isnan(I);
    I0   = I; I0(~mask) = 0;

    ksize = max(1, 2*ceil(3*sigma)+1);        % ~6*sigma
    g = fspecial('gaussian', [ksize ksize], sigma);

    num = conv2(I0,          double(g), 'same');
    den = conv2(double(mask),double(g), 'same');

    F = num ./ den;
    F(den==0) = NaN;  % aucun voisin valide
end

function cmap = bluewhitered(m)
% Colormap divergente centrée (0 -> blanc), bleu négatif / rouge positif
    if nargin<1, m = 257; end
    n = ceil(m/2);
    r = [(0:n-1)'/max(n-1,1); ones(m-n,1)];
    g = [(0:n-1)'/max(n-1,1); (m-n-1:-1:0)'/max(m-n-1,1)];
    b = [ones(n,1); (m-n-1:-1:0)'/max(m-n-1,1)];
    cmap = [r g b];
    cmap(isnan(cmap)) = 1; % cas limite
end
