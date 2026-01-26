clc; clear; close all

datafolder = 'S:\___DATA\PhotometryAndBehavior\01_DATA\ONE_COLOR\20260119_Carolina\EPM_SI-FiberAdult';
l = dir([datafolder filesep '*.*']);
n = size(l,1)
for i=1:n
    if ~l(i).isdir
        [filepath,name,ext] = fileparts(l(i).name);
        source = [datafolder filesep l(i).name];
        dest = [datafolder filesep 'M' name ext];
        [status,msg,msgID] = movefile(source,dest);
    end
end



datafolder = 'S:\___DATA\PhotometryAndBehavior\01_DATA\ONE_COLOR\20260119_Carolina\OFT_SI-FiberAdult';
l = dir([datafolder filesep '*.*']);
n = size(l,1)
for i=1:n
    if ~l(i).isdir
        [filepath,name,ext] = fileparts(l(i).name);
        source = [datafolder filesep l(i).name]
        dest = [datafolder filesep 'M' name(5:end) ext]
        [status,msg,msgID] = movefile(source,dest);
    end
end



% datafolder = 'E:\NAS_SD\SuiviClient\Beyeler\NSFT_Victor\11012023_NSFT_aIC\Input'
% l = dir([datafolder filesep '*.txt']);
% n = size(l,1)
% for i=1:n
%     [filepath,name,ext] = fileparts(l(i).name);
%     source = [datafolder filesep l(i).name]
%     dest = [datafolder filesep name '-bonsai.txt'] 
%     [status,msg,msgID] = movefile(source,dest);
% end

% datafolder = 'E:\NAS_SD\SuiviClient\Beyeler\NSFT_Victor\11012023_NSFT_aIC\Input-sideview'
% l = dir([datafolder filesep '*.mp4']);
% n = size(l,1)
% for i=1:n
%     [filepath,name,ext] = fileparts(l(i).name);
%     source = [datafolder filesep l(i).name]
%     dest = [datafolder filesep name '-sideview.mp4'] 
%     [status,msg,msgID] = movefile(source,dest);
% end

% datafolder = 'E:\NAS_SD\SuiviClient\Beyeler\NSFT_Victor\11012023_NSFT_aIC\Input-sideview'
% l = dir([datafolder filesep '*.txt']);
% n = size(l,1)
% for i=1:n
%     [filepath,name,ext] = fileparts(l(i).name);
%     source = [datafolder filesep l(i).name]
%     dest = [datafolder filesep name '-synchroLED.txt'] 
%     [status,msg,msgID] = movefile(source,dest);
% end