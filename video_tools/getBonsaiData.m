function bonsai_output = getBonsaiData(bonsaiPath)

loading_done = 0;
fprintf('\n\tloading bonsaï file\n')
if exist(bonsaiPath,'file')

    try
        opts = detectImportOptions(bonsaiPath);
        opts = setvartype(opts,'double');  % or 'string'
        bonsai_data = readtable(bonsaiPath, opts);
        %     bonsai_data = renamevars(bonsai_data,["mouseX","mouseY"],["bodyX","bodyY"]);
        bonsai_output = table2struct(bonsai_data,"ToScalar",true);
        bonsai_output.bodyX = bonsai_output.mouseX;
        bonsai_output.bodyY = bonsai_output.mouseY;
        loading_done = 1;
        fprintf('\tnew way of loading bonsaï file works\n')
    catch
        fprintf('\tnew way of loading bonsaï file does not work, we try the old way\n')
    end
    
    if ~loading_done
        try
            bonsai_data = dlmread(bonsaiPath,' ',1,0);
            %bonsai_data(:,end)=[];
            bonsai_output={};
            fid = fopen(bonsaiPath, 'r');
            tline = fgets(fid);
            tline(end)=[];tline(end)=[];
            remain = tline;
            fields=[];
            nFields=0;
            while ~isempty(remain)
                [token,remain] = strtok(remain, ' ');
                nFields=nFields+1;
                fields{nFields} = token;
                cmd = sprintf('bonsai_output.%s=bonsai_data(:,nFields);', fields{nFields} );
                eval(cmd);
            end
            fclose(fid);
            bonsai_output.bodyX = bonsai_output.mouseX;
            bonsai_output.bodyY = bonsai_output.mouseY;
            rmfield(bonsai_output,'mouseX');rmfield(bonsai_output,'mouseY');
            loading_done = 1;
             fprintf('\told way works\n')
        catch
            fprintf('\tno able to read csv, the old way also doesn''t work\n')
        end
    end
    
    
    figure();
    hold on
    plot(bonsai_output.optoPeriod);
    
    
end