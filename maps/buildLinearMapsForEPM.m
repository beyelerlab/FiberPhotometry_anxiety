function experiment=buildLinearMapsForEPM(experiment)
% CREATING LINEAR MAPS         %ZS stands for Zoned Signal, LZS for linearized Zoned Signal
p = experiment.p;
vData = experiment.vData;
pData = experiment.pData;
map = experiment.map;
%------------------------------------------------------------------------------------------------------------------------------------------------------
outputPrefix = 'IN-OUT';
armAlignedSig.IO = epm_alignSignalToArms_cmStandardPositive(p,map.NormSig.IO,vData.zones_cmSP,outputPrefix);
%draw_linearizedActivityMaps_cmStandardPositive(p,outputPrefix,map.NormSig.IO,armAlignedSig.IO,vData);
outputPrefix = 'Transients_IN-OUT';
armAlignedTransients.IO = epm_alignSignalToArms_cmStandardPositive(p,map.NormTransients.IO,vData.zones_cmSP,outputPrefix);
%draw_linearizedActivityMaps_cmStandardPositive(p,outputPrefix,map.NormTransients.IO,armAlignedTransients.IO,vData);
%------------------------------------------------------------------------------------------------------------------------------------------------------
outputPrefix = 'IN';
armAlignedSig.I = epm_alignSignalToArms_cmStandardPositive(p,map.NormSig.I,vData.zones_cmSP,outputPrefix);
%draw_linearizedActivityMaps_cmStandardPositive(p,outputPrefix,map.NormSig.I,armAlignedSig.I,vData);
outputPrefix = 'Transients_IN';
armAlignedTransients.I = epm_alignSignalToArms_cmStandardPositive(p,map.NormTransients.I,vData.zones_cmSP,outputPrefix);
%draw_linearizedActivityMaps_cmStandardPositive(p,outputPrefix,map.NormTransients.I,armAlignedTransients.I,vData);
%------------------------------------------------------------------------------------------------------------------------------------------------------
outputPrefix = 'OUT';
armAlignedSig.O = epm_alignSignalToArms_cmStandardPositive(p,map.NormSig.O,vData.zones_cmSP,outputPrefix);
%draw_linearizedActivityMaps_cmStandardPositive(p,outputPrefix,map.NormSig.O,armAlignedSig.O,vData);
outputPrefix = 'Transients_OUT';
armAlignedTransients.O = epm_alignSignalToArms_cmStandardPositive(p,map.NormTransients.O,vData.zones_cmSP,outputPrefix);
%draw_linearizedActivityMaps_cmStandardPositive(p,outputPrefix,map.NormTransients.O,armAlignedTransients.O,vData);
%------------------------------------------------------------------------------------------------------------------------------------------------------
experiment.armAlignedSig = armAlignedSig;
experiment.armAlignedTransients = armAlignedTransients;
experiment.map=map;
end