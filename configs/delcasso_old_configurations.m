
%% case 'ICa-ICp_EPM'
% EPM SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\PhotometryAndBehavior\01_DATA\20180809_ICa-ICp_G1\20180813_EPM';
dataRoot{2} =  'Z:\PhotometryAndBehavior\01_DATA\20180827_ICa-ICp_G2\20180827_EPM';
dataRoot{3} =  'Z:\PhotometryAndBehavior\01_DATA\20181106_ICa-ICp_G3\20181108_EPM';
dataRoot{4} =  'Z:\PhotometryAndBehavior\01_DATA\20190107_ICa-ICp_G4\20190114_EPM';

if isempty(outputFolder)
    outputFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\EPM' ;
end

journalFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\EPM' ;

analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='EPM';
apparatus{1}.Model='Ugo Basile version 1';
apparatus{1}.OA_cm = 80; % Open Arms Envergure
apparatus{1}.CA_cm = 75; % Closed Arms Envergure
apparatus{1}.W_cm = 5;     % Arms Width

apparatus{2}.type='EPM';
apparatus{2}.Model='Ugo Basile version 1';
apparatus{2}.OA_cm = 80; % Open Arms Envergure
apparatus{2}.CA_cm = 75; % Closed Arms Envergure
apparatus{2}.W_cm = 5;     % Arms Width

apparatus{3}.type='EPM';
apparatus{3}.Model='Ugo Basile version 2';
apparatus{3}.OA_cm = 75; % Open Arms Envergure
apparatus{3}.CA_cm = 75; % Closed Arms Envergure
apparatus{3}.W_cm = 5.3;     % Arms Width

apparatus{4}.type='EPM';
apparatus{4}.Model='Ugo Basile version 2';
apparatus{4}.OA_cm = 75; % Open Arms Envergure
apparatus{4}.CA_cm = 75; % Closed Arms Envergure
apparatus{4}.W_cm = 5.3;     % Arms Width

apparatus{5}.type='EPM';
apparatus{5}.Model='ForNormalization';
apparatus{5}.OA_cm = 80; % Open Arms Envergure
apparatus{5}.CA_cm = 80; % Closed Arms Envergure
apparatus{5}.W_cm = 5;     % Arms Width

videoExt{1}='avi';
videoExt{2}='avi';
videoExt{3}='avi';
videoExt{4}='avi';



%% case 'ICa-ICp_NSFT'
%% NSFT SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\PhotometryAndBehavior\01_DATA\20180809_ICa-ICp_G1\20180817_NSFT';
dataRoot{2} =  'Z:\PhotometryAndBehavior\01_DATA\20180827_ICa-ICp_G2\20180830_NSFT';
dataRoot{3} =  'Z:\PhotometryAndBehavior\01_DATA\20181106_ICa-ICp_G3\20181113_NSFT';
dataRoot{4} =  'Z:\PhotometryAndBehavior\01_DATA\20190107_ICa-ICp_G4\20190117_NSFT';

if isempty(outputFolder)
    outputFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\NSFT' ;
end
journalFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\NSFT' ;

analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='NSFT';
apparatus{1}.Model='Pierre Feugas';
apparatus{1}.side_cm = 60; % Open Arms Envergure

apparatus{2}.type='NSFT';
apparatus{2}.Model='Pierre Feugas';
apparatus{2}.side_cm = 60; % Open Arms Envergure

apparatus{3}.type='NSFT';
apparatus{3}.Model='Pierre Feugas';
apparatus{3}.side_cm = 60; % Open Arms Envergure

apparatus{4}.type='NSFT';
apparatus{4}.Model='Pierre Feugas';
apparatus{4}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';
videoExt{2}='avi';
videoExt{3}='avi';
videoExt{4}='avi';

%% case 'ICa-ICp_NSFT-CONTROL'
% OFT SPECIFIC PARAMETERS
% NSFT CONTROL IN HOMe CAGE SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\PhotometryAndBehavior\01_DATA\20190107_ICa-ICp_G4\20190122_NSFT-CONTROL';
if isempty(outputFolder)
    outputFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\NSFT-CONTROL' ;
end
journalFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\NSFT-CONTROL' ;

analysisParameters.apparatusNormalizationRequested = 0;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='HOMECAGE-FD';
apparatus{1}.Model='Adrien Verite';
apparatus{1}.side1_cm = 42.5; % Open Arms Envergure
apparatus{1}.side2_cm = 26.4; % Open Arms Envergure

videoExt{1}='avi';

%% case 'ICa-ICp_OFT'
%% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\PhotometryAndBehavior\01_DATA\20180809_ICa-ICp_G1\20180814_OFT';
dataRoot{2} =  'Z:\PhotometryAndBehavior\01_DATA\20180827_ICa-ICp_G2\20180828_OFT';
dataRoot{3} =  'Z:\PhotometryAndBehavior\01_DATA\20181106_ICa-ICp_G3\20181109_OFT';
dataRoot{4} =  'Z:\PhotometryAndBehavior\01_DATA\20190107_ICa-ICp_G4\20190115_OFT';
if isempty(outputFolder)
    outputFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\OFT' ;
end
journalFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\OFT' ;
analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.5;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='OFT';
apparatus{1}.Model='Pierre Feugas';
apparatus{1}.side_cm = 60; % Open Arms Envergure

apparatus{2}.type='OFT';
apparatus{2}.Model='Pierre Feugas';
apparatus{2}.side_cm = 60; % Open Arms Envergure

apparatus{3}.type='OFT';
apparatus{3}.Model='Pierre Feugas';
apparatus{3}.side_cm = 60; % Open Arms Envergure

apparatus{4}.type='OFT';
apparatus{4}.Model='Pierre Feugas';
apparatus{4}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';
videoExt{2}='avi';
videoExt{3}='avi';
videoExt{4}='avi';

%% case 'ICa-ICp_OFT-CONTROL'
%% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\PhotometryAndBehavior\01_DATA\20190107_ICa-ICp_G4\20190123_OFT-CONTROL';
if isempty(outputFolder)
    outputFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\OFT-CONTROL' ;
end
journalFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\OFT-CONTROL' ;
analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='OFT';
apparatus{1}.Model='Pierre Feugas';
apparatus{1}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';



%% case 'TEST_NSFT'
% NSFT SPECIFIC PARAMETERS
dataRoot{1} = 'C:\Anna lab\Fiber_photometry_data_analysis\Data\191217\NSFT'

if isempty(outputFolder)
    outputFolder = 'C:\Anna lab\Fiber_photometry_data_analysis\Restults\191217\NSFT';
end
journalFolder = 'C:\Anna lab\Fiber_photometry_data_analysis\Restults\191217\NSFT';

analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='NSFT';
apparatus{1}.Model='Yifan';
apparatus{1}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';




%% case 'TEST_Sucrose'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'C:\Anna lab\Fiber_photometry_data_analysis\Data\Batch3\20201007_Sucrose';
if isempty(outputFolder)
    outputFolder = 'C:\Anna lab\Fiber_photometry_data_analysis\Restults\Batch3\Sucrose' ;
end
journalFolder = 'C:\Anna lab\Fiber_photometry_data_analysis\Restults\Batch3\Sucrose' ;

analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='OFT';
apparatus{1}.Model='Yifan';
apparatus{1}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';

%% case 'ICa-ICp_QUININE-SUCROSE'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'E:\NAS_SD\SuiviClient\Beyeler\BeyelerCelinePaper\Data\Sucrose quinine';
if isempty(outputFolder)
    outputFolder = 'E:\NAS_SD\SuiviClient\Beyeler\BeyelerCelinePaper\Results\Sucrose quinine' ;
end
journalFolder = 'E:\NAS_SD\SuiviClient\Beyeler\BeyelerCelinePaper\Results\Sucrose quinine' ;
analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='NSFT';
apparatus{1}.Model='Pierre Feugas';
apparatus{1}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';

%% case 'Test_QUININE-SUCROSE'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'E:\NAS_SD\SuiviClient\Beyeler\BeyelerCelinePaper\Data\Sucrose quinine';
if isempty(outputFolder)
    outputFolder = 'E:\NAS_SD\SuiviClient\Beyeler\BeyelerCelinePaper\Results\Sucrose quinine' ;
end
journalFolder = 'E:\NAS_SD\SuiviClient\Beyeler\BeyelerCelinePaper\Results\Sucrose quinine' ;
analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='NSFT';
apparatus{1}.Model='Yifan';
apparatus{1}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';

%% case 'ICa-ICp_SI'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\PhotometryAndBehavior\01_DATA\20180809_ICa-ICp_G1\20180815_SI';
dataRoot{2} =  'Z:\PhotometryAndBehavior\01_DATA\20180827_ICa-ICp_G2\20180829_SI';
dataRoot{3} =  'Z:\PhotometryAndBehavior\01_DATA\20181106_ICa-ICp_G3\20181112_SI';
dataRoot{4} =  'Z:\PhotometryAndBehavior\01_DATA\20190107_ICa-ICp_G4\20190116_SI';

if isempty(outputFolder)
    outputFolder = 'Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\SI' ;
end
journalFolder ='Z:\PhotometryAndBehavior\03_ANALYSIS\20180926_iCa-ICp_allGroups\SI' ;
analysisParameters.socialDistance_cm = 5;
analysisParameters.MouseCoordinatesCentroid = 'Nose';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='SI';
apparatus{1}.Model='Pierre Feugas';
apparatus{1}.side_cm = 60;
apparatus{1}.side2_cm = 30;
apparatus{1}.cageDiameter_cm = 8;

apparatus{2}.type='SI';
apparatus{2}.Model='Pierre Feugas';
apparatus{2}.side_cm = 60;
apparatus{2}.side2_cm = 30;
apparatus{2}.cageDiameter_cm = 8;

apparatus{3}.type='SI';
apparatus{3}.Model='Pierre Feugas';
apparatus{3}.side_cm = 60;
apparatus{3}.side2_cm = 30;
apparatus{2}.cageDiameter_cm = 8;

apparatus{4}.type='SI';
apparatus{4}.Model='Pierre Feugas';
apparatus{4}.side_cm = 60;
apparatus{4}.side2_cm = 30;
apparatus{4}.cageDiameter_cm = 8;

videoExt{1}='avi';
videoExt{2}='avi';
videoExt{3}='avi';
videoExt{4}='avi';




%% case 'test_Sucrose'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'C:\Users\dell\Desktop\Sucrose_rename';

if isempty(outputFolder)
    outputFolder = 'C:\Users\dell\Desktop\Sucrose' ;
end
journalFolder ='C:\Users\dell\Desktop\Sucrose' ;

analysisParameters.apparatusNormalizationRequested = 1;
analysisParameters.apparatusCenterZoneSize_propOfTotalArea = 0.1;
analysisParameters.MouseCoordinatesCentroid = 'Body';
analysisParameters.MapScale_cmPerBin = 0.5;

apparatus{1}.type='NSFT';
apparatus{1}.Model='Yifan';
apparatus{1}.side_cm = 60; % Open Arms Envergure

videoExt{1}='avi';


%% case '20180926_ICa-ICp_AllTogether_TASTE'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'Z:\Fiber-Photometry\01_DATA\20180809_ICa-ICp_G1\20180905_TASTE';
dataRoot{2} =  'Z:\Fiber-Photometry\01_DATA\20180827_ICa-ICp_G2\20180904_TASTE';
if isempty(outputFolder)
    outputFolder = 'Z:\Fiber-Photometry\01_DATA\20180926_ICa-ICp_AllTogether\TASTE' ;
end
journalFolder = 'Z:\Fiber-Photometry\01_DATA\20180926_ICa-ICp_AllTogether\TASTE' ;
analysisParameters.MouseCoordinatesCentroid = 'Nose';
analysisParameters.MapScale_cmPerBin = 0.25;
analysisParameters.tasteDistance_cm = 2;
analysisParameters.zoningMethod = 'port';
%        analysisParameters.zoningMethod = 'quadrant';

apparatus{1}.type='TASTE';
apparatus{1}.Model='4 ports';
apparatus{1}.side_cm = 18;
apparatus{1}.side2_cm = 9;
apparatus{1}.licko_led = 'yes';

apparatus{2}.type='TASTE';
apparatus{2}.Model='4 ports';
apparatus{2}.side_cm = 18;
apparatus{2}.side2_cm = 9;
apparatus{2}.licko_led = 'yes';

videoExt{1}='avi';
videoExt{2}='avi';

%% case 'Test_TASTE'
% OFT SPECIFIC PARAMETERS
dataRoot{1} =  'C:\Users\dell\Desktop\Sucrose';

if isempty(outputFolder)
    outputFolder = 'C:\Anna lab\Fiber_photometry_data_analysis\Restults\Seb data\Taste' ;
end
journalFolder = 'C:\Anna lab\Fiber_photometry_data_analysis\Restults\Seb data\Taste' ;
analysisParameters.MouseCoordinatesCentroid = 'Nose';
analysisParameters.MapScale_cmPerBin = 0.25;
analysisParameters.tasteDistance_cm = 2;
analysisParameters.zoningMethod = 'port';
%        analysisParameters.zoningMethod = 'quadrant';

apparatus{1}.type='TASTE';
apparatus{1}.Model='4 ports';
apparatus{1}.side_cm = 18;
apparatus{1}.side2_cm = 9;
apparatus{1}.licko_led = 'yes';
apparatus{1}.ref_cm = 12.727922061357855;
apparatus{1}.ref_pix = 2.174380669568400e+02;

videoExt{1}='avi';















