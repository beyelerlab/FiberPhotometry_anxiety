function [videoTrackingData]=cleanPosBasedOnSpeedThreshold(videoTrackingData,params)
%cleaning position based on abnormal speed.
idx = find(videoTrackingData.distance>params.speedThreshold);
videoTrackingData.mainX(idx)=nan;
videoTrackingData.mainY(idx)=nan;
end