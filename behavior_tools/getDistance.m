function videoTrackingData =  getDistance(videoTrackingData)
    videoTrackingData.distance = get_euclidean_distance(videoTrackingData.mainX,videoTrackingData.mainY)
end