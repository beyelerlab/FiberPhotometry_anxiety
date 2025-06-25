function experiment=buildBasicMaps_PB(experiment)

p = experiment.p;vData = experiment.vData;pData = experiment.pData;

x = vData.mainX_cmSP;y = vData.mainY_cmSP;

map.Occ.IO=buildOccupancyMap_cmStandardPositive(x,y,p.xMax,p.yMax,p.MapScale_cmPerBin); %build a spatial map of the time spend in each pixel for the entire exp.
map.SumSig.IO=buildSignalMap_cmStandardPositive(x,y,pData.mainSig,p.xMax,p.yMax,p.MapScale_cmPerBin); %build a spatial map of the sum of Ca++ signal recorded in each pixel for the entire exp.
map.NormSig.IO=normSigMap(map.SumSig.IO,map.Occ.IO);
map.SumTransients.IO=buildSignalMap_cmStandardPositive(x,y,pData.transients2continuous,p.xMax,p.yMax,p.MapScale_cmPerBin); %build a spatial map of the sum of Ca++ signal recorded in each pixel for the entire exp.
map.NormTransients.IO=normSigMap(map.SumTransients.IO,map.Occ.IO);

experiment.map=map;

end