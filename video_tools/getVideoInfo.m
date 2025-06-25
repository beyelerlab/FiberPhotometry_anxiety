% function videoInfo=getVideoInfo(params)
%     videoInfoPath = [params.dataRoot  filesep params.dataFileTag '-videoInfo.mat'];
%     if ~exist(videoInfoPath,'file')
%         videoPath = [params.dataRoot filesep params.dataFileTag '.' params.videoExtension];
%         videoInfo = VideoReader(videoPath);
%         save(videoInfoPath,'videoInfo');
%     end
%      load(videoInfoPath)
% end

function videoInfo=getVideoInfo(params)
    videoInfoPath = [params.dataRoot  filesep params.dataFileTag '-videoInfo.mat'];
    if ~exist(videoInfoPath,'file')
        videoPath = [params.dataRoot filesep params.dataFileTag '.' params.videoExtension];
        
        tmp = VideoReader(videoPath);
        videoInfo = struct();
        videoInfo.FrameRate = tmp.FrameRate;
        save(videoInfoPath,'videoInfo');
    else
        try
            load(videoInfoPath);
        catch
            delete(videoInfoPath);
            videoInfo=getVideoInfo(params);
        end
    end
end
