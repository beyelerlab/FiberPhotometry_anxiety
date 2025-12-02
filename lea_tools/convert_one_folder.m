p = 'C:\Users\lpages\Desktop\video_a_convertir';
file_list = dir([p filesep '*.avi']);
nFiles = size(file_list,1);
for iFile=1:nFiles
    source = [p filesep file_list(iFile).name];
    [filepath,name,ext] = fileparts(file_list(iFile).name);
    dest = [p filesep name '.mp4'];
    cmd = 'C:\Users\lpages\Documents\GitHub\FiberPhotometry_anxiety\lea_tools';
    cmd = sprintf('%s -i %s %s', cmd,source, dest)
    [status,cmdout] = system(cmd)
end

% videoPath = "C:\Users\lpages\Desktop\video_a_convertir\F3732.avi"
% videoInfo = VideoReader(videoPath);
% bg = readFrame(videoInfo);

