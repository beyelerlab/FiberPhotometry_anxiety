function experiment = exportLinearMapsForEPM(experiment)

p=experiment.p;

filename = [p.batch_ouputFile(1:end-4) '-linearMapsForEPM.txt']; %define filename
fod = fopen(filename,'a'); % open file

%% Header
if ~p.batch_ouputFile_linearMapsForEPM_headerWritten
    fprintf(fod,"Exporting linear-maps for each recorded session\n");
    fprintf(fod,"here one bin = %2.2fcm of the spatially normalized map\n",p.MapScale_cmPerBin);
    fprintf(fod,"\n\n");
    fprintf(fod,"file_prefix\tmap_type");
    nBins = size(experiment.armAlignedSig.IO.oneDim{1},2);
    for i=1:nBins
        fprintf(fod,"\tb_%02d",i);
    end
    fprintf(fod,"\n");
    p.batch_ouputFile_linearMapsForEPM_headerWritten = 1;
end

%% Values
values_to_export = {'experiment.armAlignedSig.IO.Openarm','experiment.armAlignedSig.I.Openarm','experiment.armAlignedSig.O.Openarm','experiment.armAlignedSig.IO.Closearm','experiment.armAlignedSig.I.Closearm','experiment.armAlignedSig.O.Closearm'};
nValues = size(values_to_export,2);
for iValue = 1:nValues
    fprintf(fod,"%s\t%s",experiment.p.dataFileTag,values_to_export{iValue});
    tmp = [];
    cmd = sprintf("tmp = %s;",values_to_export{iValue});
    eval(cmd);
    for i=1:max(size(tmp))
        fprintf(fod,"\t%2.4f",tmp(i));
    end
    fprintf(fod,"\n");
end

fclose(fod); %close file

experiment.p = p;

end
