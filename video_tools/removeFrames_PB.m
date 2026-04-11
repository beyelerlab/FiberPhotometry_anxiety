function [videoTrackingData,photometryData]=removeFrames_PB(videoTrackingData,photometryData,nFrames,Side,p)

if strcmp(Side,'Beginning')
    if p.bonzaiDone
        videoTrackingData.mouseX=videoTrackingData.mouseX(nFrames+1:end);
        videoTrackingData.mouseY=videoTrackingData.mouseY(nFrames+1:end);
        videoTrackingData.mainX=videoTrackingData.mainX(nFrames+1:end);
        videoTrackingData.mainY=videoTrackingData.mainY(nFrames+1:end);
        videoTrackingData.bodyX=videoTrackingData.bodyX(nFrames+1:end);
        videoTrackingData.bodyY=videoTrackingData.bodyY(nFrames+1:end);
        videoTrackingData.mouseAngle = videoTrackingData.mouseAngle(nFrames+1:end);
        videoTrackingData.mouseMajorAxisLength = videoTrackingData.mouseMajorAxisLength(nFrames+1:end);
        videoTrackingData.mouseMinorAxisLength = videoTrackingData.mouseMinorAxisLength(nFrames+1:end);
        videoTrackingData.mouseArea = videoTrackingData.mouseArea(nFrames+1:end);
        
        if isfield(videoTrackingData,'optoPeriod')
            videoTrackingData.optoPeriod = videoTrackingData.optoPeriod(nFrames+1:end);
        end
        
        if isfield(videoTrackingData,'Sucrose')
            videoTrackingData.Sucrose = videoTrackingData.Sucrose(nFrames+1:end);
        end
        
        if isfield(videoTrackingData,'Quinine')
            videoTrackingData.Quinine = videoTrackingData.Quinine(nFrames+1:end);
        end
        
        videoTrackingData.distance = videoTrackingData.distance(nFrames+1:end);
        videoTrackingData.xF = videoTrackingData.xF(nFrames+1:end);
        videoTrackingData.yF = videoTrackingData.yF(nFrames+1:end);
        videoTrackingData.xB = videoTrackingData.xB(nFrames+1:end);
        videoTrackingData.yB = videoTrackingData.yB(nFrames+1:end);
        videoTrackingData.num0 = videoTrackingData.num0(nFrames+1:end);
        videoTrackingData.t0 = videoTrackingData.t0(nFrames+1:end);
        if isfield('videoTrackingData','xL')
            videoTrackingData.xL = videoTrackingData.xL(nFrames+1:end);
            videoTrackingData.yL = videoTrackingData.yL(nFrames+1:end);
            videoTrackingData.xR = videoTrackingData.xR(nFrames+1:end);
            videoTrackingData.yR = videoTrackingData.yR(nFrames+1:end);
        end
    end
  %  videoTrackingData.vMean = videoTrackingData.vMean(nFrames+1:end);
    photometryData.sig=photometryData.sig(nFrames+1:end);
    photometryData.ref=photometryData.ref(nFrames+1:end);
    photometryData.num0=photometryData.num0(nFrames+1:end);
    photometryData.t0=photometryData.t0(nFrames+1:end);
end

if strcmp(Side,'End')
    if p.bonzaiDone
        videoTrackingData.mouseX=videoTrackingData.mouseX(1:end-nFrames);
        videoTrackingData.mouseY=videoTrackingData.mouseY(1:end-nFrames);
        videoTrackingData.mainX=videoTrackingData.mainX(1:end-nFrames);
        videoTrackingData.mainY=videoTrackingData.mainY(1:end-nFrames);
        videoTrackingData.bodyX=videoTrackingData.bodyX(1:end-nFrames);
        videoTrackingData.bodyY=videoTrackingData.bodyY(1:end-nFrames);
        videoTrackingData.mouseAngle = videoTrackingData.mouseAngle(1:end-nFrames);
        videoTrackingData.mouseMajorAxisLength = videoTrackingData.mouseMajorAxisLength(1:end-nFrames);
        videoTrackingData.mouseMinorAxisLength = videoTrackingData.mouseMinorAxisLength(1:end-nFrames);
        videoTrackingData.mouseArea = videoTrackingData.mouseArea(1:end-nFrames);
        
        videoTrackingData.optoPeriod = videoTrackingData.optoPeriod(1:end-nFrames);
        
        
        if isfield(videoTrackingData,'optoPeriod')
            videoTrackingData.optoPeriod = videoTrackingData.optoPeriod(1:end-nFrames);
        end
        
        if isfield(videoTrackingData,'Sucrose')
            videoTrackingData.Sucrose = videoTrackingData.Sucrose(1:end-nFrames);
        end
        
        if isfield(videoTrackingData,'Quinine')
            videoTrackingData.Quinine = videoTrackingData.Quinine(1:end-nFrames);
        end
        
        videoTrackingData.distance = videoTrackingData.distance(1:end-nFrames);
        videoTrackingData.xF = videoTrackingData.xF(1:end-nFrames);
        videoTrackingData.yF = videoTrackingData.yF(1:end-nFrames);
        videoTrackingData.xB = videoTrackingData.xB(1:end-nFrames);
        videoTrackingData.yB = videoTrackingData.yB(1:end-nFrames);
        videoTrackingData.num0 = videoTrackingData.num0(1:end-nFrames);
        videoTrackingData.t0 = videoTrackingData.t0(1:end-nFrames);
        if isfield('videoTrackingData','xL')
            videoTrackingData.xL = videoTrackingData.xL(1:end-nFrames);
            videoTrackingData.yL = videoTrackingData.yL(1:end-nFrames);
            videoTrackingData.xR = videoTrackingData.xR(1:end-nFrames);
            videoTrackingData.yR = videoTrackingData.yR(1:end-nFrames);
        end
       % videoTrackingData.vMean = videoTrackingData.vMean(1:end-nFrames);
        photometryData.sig=photometryData.sig(1:end-nFrames);
        photometryData.ref=photometryData.ref(1:end-nFrames);
        photometryData.num0=photometryData.num0(1:end-nFrames);
        photometryData.t0=photometryData.t0(1:end-nFrames);
    end
end

end