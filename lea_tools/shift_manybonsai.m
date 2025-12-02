
% clear
% close all
% clc

shift_sec = 2;

p = 'S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_GCaMP_aIC_pIC\20250502_all_pIC\FS_Zscore\input';
l = dir([p filesep '*-bonsai.txt']);

for i=1:length(l)
    datapath = [p filesep l(i).name];
    shift_led_in_time(shift_sec, datapath);
end
