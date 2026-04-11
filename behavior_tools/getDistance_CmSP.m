function videoTrackingData =  getDistance_CmSP(videoTrackingData)
dx = diff(videoTrackingData.mainX_cmS);
dy=diff(videoTrackingData.mainY_cmS);
dx= [0;dx];
dy= [0;dy];
distance = sqrt((dx.*dx)+(dy.*dy));
videoTrackingData.distanceSP = distance;
end