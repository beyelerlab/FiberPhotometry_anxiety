function videoTrackingData =  getFreezing(videoTrackingData, distanceThreshold, avg_window_fr)
    avg_window_fr = 50
    videoTrackingData.raw_freezing = videoTrackingData.distanceSP > distanceThreshold;
    videoTrackingData.freezing = movmean(videoTrackingData.raw_freezing, avg_window_fr, "omitnan");
%     figure()
% hold on
% plot(videoTrackingData.raw_freezing)
% plot(videoTrackingData.freezing)
end