function landmarks=getLandmarks(params,landmarksStr)
nLandmarks = size(landmarksStr,2);
matlabFile = [params.dataRoot filesep params.dataFileTag '-landmarks.mat'];

figureSubFolder = [params.figureFolder filesep 'landmarks'];
if ~exist(figureSubFolder,'dir'),mkdir(figureSubFolder);end
figName = [figureSubFolder filesep params.dataFileTag '-landmarks.jpeg'];

if ~exist(matlabFile,'file')
    
    videoTrackingData = getVideoTrackingData(params);
    bg=getBackGroundQuick(params);
    
    f1=figure('name',params.dataFileTag,'Position',[20 20 800 800]);
    
    videoResolution = size(bg);
    zoom = floor(videoResolution(2)/5);
    
    figure(f1)
    hold on
    axis equal
    axis off
    set(gca,'Ydir','reverse')
    colormap(gray(1024));
    for i=1:nLandmarks
        imagesc(bg);
        text(10,10,landmarksStr{i},'color',[1 0 1]);
        [x(i),y(i)]=ginput(1);
    end
    
    for i=1:nLandmarks
        clf(f1);
        hold on
        axis equal
        axis off
        set(gca,'Ydir','reverse')
        colormap(gray(1024));
        imagesc(bg);
        text(x(i)-zoom,y(i)-zoom,landmarksStr{i},'color',[1 0 1]);
        ylim([y(i)-zoom y(i)+zoom])
        xlim([x(i)-zoom x(i)+zoom])
        [x(i),y(i)]=ginput(1);
    end
    
    %     [x,y]=reorderPointsClockwise(x,y);
    
    clf(f1);
    hold on
    axis equal
    axis off
    set(gca,'Ydir','reverse')
    colormap(gray(1024));
    imagesc(bg);
    ylim([0 size(bg,1)])
    xlim([0 size(bg,2)])
    
    for i=1:nLandmarks
        plot(x(i),y(i),'+m')
        text(x(i)+10,y(i)+10,landmarksStr{i},'color',[1 0 1]);
    end
    
    pause(2);
    landmarks.x=x;
    landmarks.y=y;
    save(matlabFile,'landmarks','landmarksStr');
    print(f1,figName,'-djpeg');
    close (f1);

else
    
    load(matlabFile);

    
    if ~exist(figName,'file')
        videoTrackingData = getVideoTrackingData(params);
        bg=getBackGroundQuick(params);
        f1=figure('name',params.dataFileTag,'Position',[20 20 800 800]);
        videoResolution = size(bg);
        figure(f1)
        hold on
        axis equal
        axis off
        set(gca,'Ydir','reverse')
        colormap(gray(1024));
        imagesc(bg);
        ylim([0 size(bg,1)])
        xlim([0 size(bg,2)])
        for i=1:nLandmarks            
            plot(landmarks.x(i), landmarks.y(i),'+m')
            text(landmarks.x(i)+10, landmarks.y(i)+10,landmarksStr{i},'color',[1 0 1]);
        end
        print(f1,figName,'-djpeg');
        close(f1);
    end
    
end

end

