function experiment=buildDirectionalMapsForEPM(experiment)

p = experiment.p;
vData = experiment.vData;
pData = experiment.pData;
map = experiment.map;

%% TAKING MOUSE DIRECTION (INSIDE/ Vs. OUSIDE) THE ARM
[map.Occ.I,map.Occ.O,map.SumSig.I,map.SumSig.O,map.Sigpoint_In,map.Sigpoint_Out]=getEpmWithinArmDirection_cmStandardPositive(vData.mainX_cmSP,vData.mainY_cmSP,pData.mainSig,vData.zones_cmSP,p.xMax,p.yMax,p.MapScale_cmPerBin);
map.NormSig.I=normSigMap(map.SumSig.I,map.Occ.I);
map.NormSig.O=normSigMap(map.SumSig.O,map.Occ.O);
[map.Occ.I,map.Occ.O,map.SumTransients.I,map.SumTransients.O]=getEpmWithinArmDirection_cmStandardPositive(vData.mainX_cmSP,vData.mainY_cmSP,pData.transients2continuous,vData.zones_cmSP,p.xMax,p.yMax,p.MapScale_cmPerBin);
map.NormTransients.I=normSigMap(map.SumTransients.I,map.Occ.I);
map.NormTransients.O=normSigMap(map.SumTransients.O,map.Occ.O);

experiment.map=map;

end