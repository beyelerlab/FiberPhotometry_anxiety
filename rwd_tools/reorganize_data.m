clc; clear; close all

% fip = "E:\NAS_SD\SuiviClient\Beyeler\DATA\20230502_NSFT\Inputs\F2434.mat"
data_root = 'S:\___DATA\PhotometryAndBehavior\01_DATA\ONE_COLOR\20250401_LBN4\20250401_EPM\EPM_TMP'

subdir_list = dir([data_root filesep '*'])
n_subdir = size(subdir_list, 1);

% We will process each mouse folder within the experiment folder
for i=3:n_subdir
    
    folder = [data_root filesep subdir_list(i).name]
    item_list =  dir([folder filesep '*']); n_items = size(item_list, 1);
    
    for j=3:n_items
        
        if item_list(j).isdir
            
            folder2 = [folder filesep item_list(j).name];
            
            %look for a Fluorescence.csv file
            file_list =  dir([folder2 filesep 'Fluorescence.csv']);
             n_file = size(file_list, 1);
             
             if n_file
                 
                 fprintf('I have found a fluo file here: %s\n', [folder2 filesep file_list(1).name]);
                 [filepath,datetime,ext] = fileparts(folder2);
                 [filepath,mouse,ext] = fileparts(filepath);
                 
%                  fod = fopen([data_root filesep sprintf('%s_datetime.txt', mouse)],'w');
%                  fprintf(fod,'%s\n', datetime);
%                  fclose(fod)
                 
                 fluo_path = [folder2 filesep 'Fluorescence.csv'];
                 
                 fid = fopen(fluo_path);
                 params = fgetl(fid);
                 columns = fgetl(fid);
                 fclose(fid);
                 
%                  fod = fopen([data_root filesep sprintf('%s_photoparams.txt', mouse)],'w');
%                  fprintf(fod,'%s\n', params);
%                  fclose(fod)
                 
                 channels = [];
                 wavelength = [];
                 
                 columns =  split(columns,',');
                 for k=3:size(columns,1)-1
                     tmp = split(columns{k},'-');
                     channels = [channels sscanf(tmp{1}(3:end),'%d')];
                     wavelength = [wavelength sscanf(tmp{2},'%d')];
                 end
                 
                 labels = unique(channels);
                 signals_nm = unique(wavelength);
                 
                 try
                    sig = readmatrix(fluo_path); 
                    sig = sig';
                    ts = sig(1,:);
                    sig([1,2,5],:) = [];
                 catch
                     sig = readtable(fluo_path);                                          
                     ts = table2array(sig(:,1));
                     sig(:, [1,2,5]) = [];
                     sig=table2array(sig);
                     sig = sig';
                 end

                 
                 save([data_root filesep sprintf('%s.mat', mouse)],'labels','sig','signals_nm','ts','datetime','params');

                 file_list =  dir([folder2 filesep '*.*']);
                 n_file = size(file_list, 1);

                 for k=3:n_file                     
                     n = file_list(k).name;
                     source = [folder2 filesep n];
                     if strcmp(n,'Video.mp4')
                         dest = [data_root filesep sprintf('%s.mp4', mouse)];
                     else
                         dest = [data_root filesep sprintf('%s_%s', mouse, n)];
                     end                     
                     [status,msg,msgID] = copyfile(source, dest);                     
                 end
                 
             end             
        end        
    end     
end