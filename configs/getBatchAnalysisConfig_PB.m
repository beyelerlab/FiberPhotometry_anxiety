function [dataRoot,outputFolder,apparatus,videoExt,analysisParameters]=getBatchAnalysisConfig_PB(batchID,machine,analysisParameters,outputFolder)

%% Thibault 3
switch batchID
    
    %% OFT SPECIFIC PARAMETERS
    case 'test_OFT'                
        dataRoot{1} =  'C:\Users\lpages\Desktop\analysis_all_aIC\OFT_Zscore\input';
        
        if isempty(outputFolder)
            outputFolder = 'C:\Users\lpages\Desktop\analysis_all_aIC\OFT_Zscore\output';
        end
        
        journalFolder =  outputFolder;
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.5;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
        
        apparatus{1}.type='OFT';
        apparatus{1}.Model='Yifan';
        apparatus{1}.side_cm = 60; % Open Arms Envergure                
        
        videoExt{1}='mp4';
        
        analysisParameters.spatial_analysis = 1;
        analysisParameters.map_linearization = 0;
        analysisParameters.event_analysis = 0;
                
    %% EPM SPECIFIC PARAMETERS
    case 'test_EPM'
        dataRoot{1} =  'S:\___DATA\PhotometryAndBehavior\01_DATA\ONE_COLOR\20250321_LBN3\20250321_LBN3.2\20250311_LBN3_2_EPM\Analysis\input';
        if isempty(outputFolder)
            outputFolder = 'S:\___DATA\PhotometryAndBehavior\01_DATA\ONE_COLOR\20250321_LBN3\20250321_LBN3.2\20250311_LBN3_2_EPM\Analysis\output';
        end
        
        journalFolder = outputFolder;
        
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
        
        apparatus{1}.type='EPM';
        apparatus{1}.Model='Ugo Basile version 1';
        apparatus{1}.OA_cm = 75; % Open Arms Envergure
        apparatus{1}.CA_cm = 75; % Closed Arms Envergure
        apparatus{1}.W_cm = 5.3;     % Arms Width
        
        videoExt{1}='mp4';
        
        analysisParameters.spatial_analysis = 1;
        analysisParameters.map_linearization = 1;

        %To analyse arm entries or arm exits
        analysisParameters.event_analysis = 0;
                         
       
    %% Sucrose In OFT SPECIFIC PARAMETERS
    case 'test_SQ'
        
        dataRoot{1} =  'S:\_Céline\Manips\Manip for paper anxiety\2. REVISION 2\QUININE ALL\INPUT pIC';
        if isempty(outputFolder)
            outputFolder = 'S:\_Céline\Manips\Manip for paper anxiety\2. REVISION 2\QUININE ALL\OUTPUT pIC' ;
        end
        journalFolder = outputFolder;
        
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
        
        apparatus{1}.type='NSFT';
        apparatus{1}.Model='Yifan';
        apparatus{1}.side_cm = 60; % Open Arms Envergure
        
        videoExt{1}='avi';   
        
        analysisParameters.spatial_analysis = 1;
        analysisParameters.map_linearization = 0;
        analysisParameters.event_analysis = 1;
        
    %% TailSuspension SPECIFIC PARAMETERS    
    case 'test_TS'

        dataRoot{1} =  'Y:\PhotometryAndBehavior\03_ANALYSIS\ONE_COLOR_analysis\20240208_aIC_pIC_HFD\20240220_Tailsuspension\input';
        if isempty(outputFolder)
            outputFolder = 'Y:\PhotometryAndBehavior\03_ANALYSIS\ONE_COLOR_analysis\20240208_aIC_pIC_HFD\20240220_Tailsuspension\output' ;
        end
        journalFolder = outputFolder;
               
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
                
        apparatus{1}.type='';
        apparatus{1}.Model='';
        apparatus{1}.side_cm = 0; 
        
        videoExt{1}='avi';   
                
        analysisParameters.spatial_analysis = 0;
        analysisParameters.map_linearization = 0;
        analysisParameters.event_analysis = 1;      
        
        %% TailSuspension SPECIFIC PARAMETERS    
    case 'test_footshock'

        dataRoot{1} =  'S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_GCaMP_aIC_pIC\20250502_all_pIC\FS_Zscore\input';
        if isempty(outputFolder)
            outputFolder = 'S:\_Lea\2.Analysis_PhotoM_Behavior_IHC\PhotoM_Analysis\all_GCaMP_aIC_pIC\20250502_all_pIC\FS_Zscore\output' ;
        end
        journalFolder = outputFolder;
               
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.00001;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
                
        apparatus{1}.type='Fear';
        apparatus{1}.Model='';
        apparatus{1}.width_cm = 48; 
        apparatus{1}.height_cm = 25.4; 
        
        videoExt{1}='mp4';   
                
        analysisParameters.spatial_analysis = 1;
        analysisParameters.map_linearization = 0;
        analysisParameters.event_analysis = 1;         
        
    %% TailSuspension SPECIFIC PARAMETERS    
    case 'test_NSFT'

        % % % % %% RIM
        dataRoot{1} =  'C:\Users\lpages\Desktop\analysis_all_aIC\20250429_all_analysis_aIC_pIC_NSFT\20250411_Analysis_of_rim_mice\input_Rim';
        if isempty(outputFolder)
            outputFolder = 'C:\Users\lpages\Desktop\analysis_all_aIC\20250429_all_analysis_aIC_pIC_NSFT\20250411_Analysis_of_rim_mice\output_Rim' ;
        end
        % 
        % % Victor
        % dataRoot{1} =  'C:\Users\lpages\Desktop\analysis_all_aIC\20250429_all_analysis_aIC_pIC_NSFT\20250411_Analaysis_of_victor_mice\input_mice_victor';
        % if isempty(outputFolder)
        %     outputFolder = 'C:\Users\lpages\Desktop\analysis_all_aIC\20250429_all_analysis_aIC_pIC_NSFT\20250411_Analaysis_of_victor_mice\output_mice_victor' ;
        % end

        % % % % %% Lea 1
        % dataRoot{1} =  'C:\Users\lpages\Desktop\analysis_all_aIC\20250429_all_analysis_aIC_pIC_NSFT\20240531_NSFT_photoM_B2_LP\input_one_bite';
        % if isempty(outputFolder)
        %     outputFolder = 'C:\Users\lpages\Desktop\analysis_all_aIC\20250429_all_analysis_aIC_pIC_NSFT\20240531_NSFT_photoM_B2_LP\output_one_bite';
        % end
        journalFolder = outputFolder;
               
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
                
        apparatus{1}.type='NSFT';
        apparatus{1}.Model='';
        apparatus{1}.side_cm = 60;
        
        videoExt{1}='mp4';   
        
        analysisParameters.spatial_analysis = 1;
        analysisParameters.map_linearization = 0;
        analysisParameters.event_analysis = 1; 
        
        analysisParameters.extract_bites_from_audio = 1;
		analysisParameters.extract_bites_from_txt = 0;
        
        
        
    %% THREE CHAMBERS SPECIFIC PARAMETERS    
    case 'test_ThreeChambers'


        
        dataRoot{1} =  'E:\NAS_SD\SuiviClient\Beyeler\DATA\TestTransientDetection\Inputs';
%                 dataRoot{1} =  'E:\NAS_SD\SuiviClient\Beyeler\DATA\Alba\ThreeChambers\Inputs';
        if isempty(outputFolder)
            outputFolder = 'E:\NAS_SD\SuiviClient\Beyeler\DATA\TestTransientDetection\Outputs' ;
%                         outputFolder = 'E:\NAS_SD\SuiviClient\Beyeler\DATA\Alba\ThreeChambers\Outputs' ;
        end
        journalFolder = outputFolder;
               
        analysisParameters.apparatusNormalizationRequested = 0;
        analysisParameters.MouseCoordinatesCentroid = 'Body';
        analysisParameters.MapScale_cmPerBin = 0.5;
                
        apparatus{1}.type='ThreeChambers';
        apparatus{1}.Model='';
        apparatus{1}.chamber_width_cm = 20;
        apparatus{1}.chamber_height_cm = 40;
        
        videoExt{1}='avi';   
        
        analysisParameters.spatial_analysis = 1;
        analysisParameters.map_linearization = 0;
        analysisParameters.event_analysis = 0; 
        analysisParameters.extract_bites_from_audio = 0;        
        
end



switch machine
    case 'local'
        fprintf('Drive is C:\n');
        for i=1:size(dataRoot,2)
            dataRoot{i} = strrep(dataRoot{i},'Z:\','C:\');
        end
        outputFolder = strrep(outputFolder,'Z:\','C:\');
    case 'remote'
        fprintf('Drive is Z:\n')
end


analysisParameters.journal = readtable([journalFolder filesep 'Journal.xlsx']);

analysisParameters.batchID = batchID;

analysisParameters = getConfig_PB(analysisParameters,outputFolder,apparatus,videoExt);







