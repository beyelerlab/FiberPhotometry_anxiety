clc; clear; close all

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