p = 'C:\Users\lpages\Desktop\video_a_convertir';
file_list = dir([p filesep '*.avi']);
nFiles = size(file_list,1);

for iFile = 1:nFiles
    source = fullfile(p, file_list(iFile).name);
    [~, name, ~] = fileparts(file_list(iFile).name);
    dest = fullfile(p, [name '.mp4']);
    
    ffmpegPath = 'C:\Users\lpages\Desktop\OLD 2025_FiberPhotometry_Matlab\ffmpeg\bin\ffmpeg.exe';
    
    % Ajout de guillemets autour des chemins
    cmd = sprintf('"%s" -i "%s" "%s"', ffmpegPath, source, dest);
    
    [status, cmdout] = system(cmd);
    
    if status ~= 0
        fprintf('Erreur lors de la conversion de : %s\n', source);
        fprintf('Message : %s\n', cmdout);
    end
end