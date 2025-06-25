function videoTrackingData =  vt_getDistance(videoTrackingData)
dx = diff(videoTrackingData.mainX);
dy=diff(videoTrackingData.mainY);
distance = sqrt((dx.*dx)+(dy.*dy));
videoTrackingData.distance = distance;
end