function drawBasicMaps_PB(experiment)

p = experiment.p;
vData = experiment.vData;
pData = experiment.pData;
map = experiment.map;

drawVideoTrackingTrajectory(p,vData.mainX,vData.mainY); % Draw traceXXX.jpeg
% drawTrajectoryOverlayedWithSpeed(params,videoTrackingData.mainX_cmSP,videoTrackingData.mainY_cmSP,xMax,yMax)
drawOccupancyMap(p,map.Occ.IO,p.xMax,p.yMax); % Draw OccupancyMapXXX.jpeg
drawPhotometrySignalMap(p,map.NormSig.IO,p.xMax,p.yMax); % Draw SignalMapXXX.jpeg
drawPhotometryContinuousTransientsSignalMap(p,map.NormTransients.IO,p.xMax,p.yMax); % Draw SignalMapXXX.jpeg

end