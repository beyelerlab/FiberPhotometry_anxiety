clc; clear; close all;

data_root = 'S:\_Lea\1.Data\20251007_aIC_BLA_B3\sig_check';



subdir_list = dir(data_root);
n_subdir = numel(subdir_list);

for imouse = 3:n_subdir  % skip . and ..
    folder = fullfile(data_root, subdir_list(imouse).name);
    item_list = dir(folder);
    n_items = numel(item_list);

    for isession = 3:n_items
        if item_list(isession).isdir
            folder2 = fullfile(folder, item_list(isession).name);
            file_list = dir(fullfile(folder2, 'Fluorescence.csv'));

            if ~isempty(file_list)
                fprintf('📂 Found fluorescence file: %s\n', fullfile(folder2, file_list(1).name));

                fluo_path = fullfile(folder2, 'Fluorescence.csv');
                fid = fopen(fluo_path);
                params = fgetl(fid);
                columns = fgetl(fid);
                fclose(fid);

                % ---- PARSE HEADER ----
                columns = split(columns, ',');
                wavelength = [];
                for k = 3:numel(columns)-1
                    tmp = split(columns{k}, '-');
                    if numel(tmp) >= 2
                        wavelength = [wavelength, str2double(tmp{2})];
                    end
                end

                % ---- READ DATA ----
                try
                    all_sig = readmatrix(fluo_path);
                    all_sig = all_sig';      % transpose: channels x time
                    ts = all_sig(1,:);       % timestamp
                    all_sig([1,2],:) = [];   % remove time + TTL

                    % ensure even number of rows
                    if mod(size(all_sig,1),2)
                        all_sig(end,:) = [];
                    end

                    n_channels = min(4, size(all_sig,1));
                    framerate = 20; % Hz

                    [~, datetime_folder] = fileparts(folder2);
                    [~, mouse_folder] = fileparts(folder);

                    % ---- SAVE EACH CHANNEL & PLOT ----
                    t = (1:length(ts)) / framerate / 60; % time in minutes
                    colors = lines(n_channels);

                    for c = 1:n_channels
                        sig = all_sig(c,:)';
                        label = sprintf('Channel_%d', c);
                        wavelength_nm = NaN;
                        if c <= numel(wavelength)
                            wavelength_nm = wavelength(c);
                        end

                        % Save .mat file
                        save_path = fullfile(folder2, sprintf('%s_%s_Ch%d_%dnm.mat', ...
                            mouse_folder, datetime_folder, c, wavelength_nm));
                        save(save_path, 'sig', 'label', 'wavelength_nm', 'ts', 'params', 'framerate');
                        fprintf('✅ Saved: %s\n', save_path);

                        % Plot each channel separately (up to 3 minutes)
                        fig = figure('Visible', 'off', 'Position', [100 100 1000 400]);
                        plot(t, sig, 'Color', colors(c,:), 'LineWidth', 1.2);
                        xlabel('Time (min)');
                        ylabel('Fluorescence (a.u.)');
                        title(sprintf('%s - %s - Ch%d (%dnm)', mouse_folder, datetime_folder, c, wavelength_nm), 'Interpreter','none');
                        grid on;
                        xlim([0 3]); % only first 3 minutes

                        fig_path = fullfile(folder2, sprintf('%s_%s_Ch%d_%dnm_plot.png', ...
                            mouse_folder, datetime_folder, c, wavelength_nm));
                        saveas(fig, fig_path);
                        close(fig);

                        fprintf('📈 Saved plot: %s\n', fig_path);
                    end

                catch ME
                    warning('❌ Error processing %s: %s', fluo_path, ME.message);
                end
            end
        end
    end
end
