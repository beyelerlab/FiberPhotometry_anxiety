function corners=getRectangularZone_201810041830(params,matFileSuffix,orderSTR)

matlabFile = [params.dataRoot filesep params.dataFileTag '-' matFileSuffix '.mat'];

suffix =matFileSuffix;

figureSubFolder = [params.figureFolder filesep matFileSuffix];
if ~exist(figureSubFolder,'dir'),mkdir(figureSubFolder);end
figName = [figureSubFolder filesep params.dataFileTag '-' matFileSuffix '.jpeg'];

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
    imagesc(bg);
    text(10,10,orderSTR,'color',[0.5 1 0.5]);
    for i=1:4
        [x(i),y(i)]=ginput(1);
    end
    
    for i=1:4
        ylim([y(i)-zoom y(i)+zoom])
        xlim([x(i)-zoom x(i)+zoom])
        [x(i),y(i)]=ginput(1);
    end
    
    [x,y]=reorderPointsClockwise(x,y);
    
    ylim([0 size(bg,1)])
    xlim([0 size(bg,2)])
            
    for i=1:4
        plot(x(i),y(i),'+')
        text(x(i)+10,y(i)+10,num2str(i),'color',[0.5 1 0.5]);
    end
        
    
    pause(2);    
    cmd=sprintf('%s.x=x;',matFileSuffix);eval(cmd);
    cmd=sprintf('%s.y=y;',matFileSuffix);eval(cmd);
    cmd=sprintf('save(matlabFile,''%s'');',matFileSuffix);eval(cmd);        
    print(f1,figName,'-djpeg');
    close (f1);
    cmd=sprintf('corners=%s;',matFileSuffix);eval(cmd);
else
    
    load(matlabFile);
    cmd=sprintf('corners=%s;',matFileSuffix);eval(cmd);
    
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
        for i=1:4
            plot(corners.x(i),corners.y(i),'+')
            text(corners.x(i)+10,corners.y(i)+10,num2str(i),'color',[0.5 1 0.5]);
        end
        print(f1,figName,'-djpeg');
        close(f1);        
    end
                    
end

end

