clc; clear; close all

% fip = "E:\NAS_SD\SuiviClient\Beyeler\DATA\20230502_NSFT\Inputs\F2434.mat"
data_root = 'S:\_Lea\1.Data\PhotoM\20251210_aIC_NAc_pIC\20251218_FS'

only_one_TTL = true

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
                 mice = split(mouse, "_");
                 
                 fluo_path = [folder2 filesep 'Fluorescence.csv'];
                 tmp_matrix = readmatrix(fluo_path);
                 photo_freq = 1/ (mean(diff(tmp_matrix(:,1)))/1000);

                 
                 fid = fopen(fluo_path);
                 params = fgetl(fid);
                 columns = fgetl(fid);
                 fclose(fid);
                 
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
                    all_sig = readmatrix(fluo_path); 
                    all_sig = all_sig';
                    ts = all_sig(1,:);
                    all_sig([1,2],:) = [];
                    if mod(size(all_sig,1), 2)
                        all_sig(end,:) = [];
                    end
                        
                 catch
                    print("need to be check again")
                    return
                 end

                 lines = [1, 3];
                 for i=1:2
                    labels = i; 
                    l = lines(i);
                    sig = all_sig(l:l+1, :);
                    save([data_root filesep sprintf('%s.mat', mice{i})],'labels','sig','signals_nm','ts','datetime','params');
                 end

                 event_path = [folder2 filesep 'Events.csv'];
                 t = readtable(event_path);

                 n_lines = size(t, 1);
                 for i=1:2
                     TTL = [];
                     for j=1:n_lines
                         s = t.Name(1);
                         s = s{:}
                        
                         if only_one_TTL
                            target_input = 'Input2';
                         else
                            target_input = sprintf('Input%d',i);
                         end

                         if strcmp(s,target_input)
                             if t.State(j) == false 
                                TTL = [TTL t.TimeStamp(j)/1000];
                             end
                         end
                     end
                     TTL = TTL * photo_freq;
                     TTL = cast(TTL,"int32");
                     writematrix(TTL',[data_root filesep sprintf('%s_events_idxsynchro.txt', mice{i})]);
                 end



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